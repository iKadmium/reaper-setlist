use axum::{
    Json, Router,
    extract::State,
    http::StatusCode,
    response::IntoResponse,
    routing::{get, post, put},
};
use serde::Deserialize;
use std::sync::Arc;
use tokio::sync::RwLock;
use uuid::Uuid; // Added for nonce generation

use crate::data_access::{json_file::StoredInJsonFile, reaper_client::ReaperClient};
use crate::models::settings::Settings;

#[derive(Deserialize)]
struct TestConnectionRequest {
    reaper_url: String,
    reaper_username: Option<String>,
    reaper_password: Option<String>,
}

#[derive(Deserialize)]
struct TestActionId {
    action_id: Option<String>,
}

pub fn settings_api_controller(settings_state: Arc<RwLock<Settings>>) -> Router {
    // Changed to Arc<RwLock<Settings>>
    Router::new()
        .route("/", get(get_settings).put(update_settings))
        .route("/action-ids", put(update_action_ids))
        .route("/test-connection", post(test_reaper_connection))
        .route("/test-load-project", post(test_load_project_command_id))
        .route("/test-list-projects", post(test_list_projects_command_id))
        .with_state(settings_state)
}

async fn get_settings(State(settings_state): State<Arc<RwLock<Settings>>>) -> Json<Settings> {
    // Changed to Arc<RwLock<Settings>>
    let settings_read_guard = settings_state.read().await;
    Json(settings_read_guard.clone())
}

async fn update_settings(
    State(settings_state): State<Arc<RwLock<Settings>>>, // Added State extractor for settings_state
    Json(new_settings): Json<Settings>,
) -> impl IntoResponse {
    let mut settings_write_guard = settings_state.write().await;
    // Merge: preserve action ids if not present in new_settings
    let merged_settings = Settings {
        load_project_script_action_id: if new_settings.load_project_script_action_id.is_some() {
            new_settings.load_project_script_action_id.clone()
        } else {
            settings_write_guard.load_project_script_action_id.clone()
        },
        list_projects_script_action_id: if new_settings.list_projects_script_action_id.is_some() {
            new_settings.list_projects_script_action_id.clone()
        } else {
            settings_write_guard.list_projects_script_action_id.clone()
        },
        // ...other fields are always overwritten
        folder_path: new_settings.folder_path.clone(),
        reaper_url: new_settings.reaper_url.clone(),
        reaper_username: new_settings.reaper_username.clone(),
        reaper_password: new_settings.reaper_password.clone(),
    };
    match merged_settings.save().await {
        Ok(_) => {
            *settings_write_guard = merged_settings;
            StatusCode::OK
        }
        Err(e) => {
            tracing::error!("Failed to save settings: {}", e);
            StatusCode::INTERNAL_SERVER_ERROR
        }
    }
}

#[derive(Deserialize)]
struct ActionIdsRequest {
    load_project_script_action_id: Option<String>,
    list_projects_script_action_id: Option<String>,
}

async fn update_action_ids(
    State(settings_state): State<Arc<RwLock<Settings>>>,
    Json(action_ids): Json<ActionIdsRequest>,
) -> impl IntoResponse {
    let mut settings_write_guard = settings_state.write().await;
    let mut updated_settings = settings_write_guard.clone();

    // Update the action IDs
    updated_settings.load_project_script_action_id = action_ids.load_project_script_action_id;
    updated_settings.list_projects_script_action_id = action_ids.list_projects_script_action_id;

    match updated_settings.save().await {
        Ok(_) => {
            *settings_write_guard = updated_settings;
            StatusCode::OK
        }
        Err(e) => {
            tracing::error!("Failed to save action IDs: {}", e);
            StatusCode::INTERNAL_SERVER_ERROR
        }
    }
}

async fn test_reaper_connection(
    Json(test_request): Json<TestConnectionRequest>,
) -> impl IntoResponse {
    // Create temporary settings for testing
    let test_settings = Settings {
        reaper_url: test_request.reaper_url,
        reaper_username: test_request.reaper_username,
        reaper_password: test_request.reaper_password,
        folder_path: String::new(), // Not needed for connection test
        load_project_script_action_id: None,
        list_projects_script_action_id: None,
    };

    let client = ReaperClient::new(&test_settings);
    match client.test_connectivity().await {
        Ok(status_code) => {
            if status_code == 200 {
                StatusCode::NO_CONTENT // 204 - Connection successful
            } else {
                // Return the actual status code from Reaper
                StatusCode::from_u16(status_code).unwrap_or(StatusCode::SERVICE_UNAVAILABLE)
            }
        }
        Err(e) => {
            tracing::warn!("Reaper connection test failed: {:?}", e);
            // For network errors, return 503 Service Unavailable
            StatusCode::SERVICE_UNAVAILABLE
        }
    }
}

// Helper function to map ReaperError to an appropriate HTTP response
pub(crate) fn map_reaper_error(
    err: crate::data_access::reaper_client::ReaperError,
) -> impl IntoResponse {
    use axum::http::StatusCode;
    tracing::error!("Reaper error: {:?}", err);
    match err {
        crate::data_access::reaper_client::ReaperError::Http(e) => (
            StatusCode::INTERNAL_SERVER_ERROR,
            format!("Reaper HTTP error: {}", e),
        )
            .into_response(),
        crate::data_access::reaper_client::ReaperError::Command(e) => (
            StatusCode::BAD_GATEWAY,
            format!("Reaper command error: {}", e),
        )
            .into_response(),
        crate::data_access::reaper_client::ReaperError::Parse(e) => (
            StatusCode::INTERNAL_SERVER_ERROR,
            format!("Reaper response parse error: {}", e),
        )
            .into_response(),
        crate::data_access::reaper_client::ReaperError::Config(e) => (
            StatusCode::PRECONDITION_FAILED,
            format!("Reaper configuration error: {}", e),
        )
            .into_response(),
        crate::data_access::reaper_client::ReaperError::NonceMismatch => (
            StatusCode::EXPECTATION_FAILED, // Using 417 for nonce mismatch
            "Nonce verification failed. Script execution may not be as expected.".to_string(),
        )
            .into_response(),
    }
}

// Test Load Project Script Command ID
async fn test_load_project_command_id(
    State(settings_state): State<Arc<RwLock<Settings>>>,
    Json(payload): Json<TestActionId>,
) -> impl IntoResponse {
    let mut settings = settings_state.read().await.clone();
    if let Some(id) = payload.action_id {
        settings.load_project_script_action_id = Some(id);
    }
    let client = ReaperClient::new(&settings);
    let test_path = "test-dummy-song.rpp";

    let nonce = Uuid::new_v4().to_string();
    let expected_nonce_out = format!("{}_modified", nonce);

    // Set nonce_in before enabling dummy mode or running the script
    if let Err(e) = client
        .set_ext_state("WebAppControl", "test_nonce_in", &nonce)
        .await
    {
        return map_reaper_error(e).into_response();
    }

    // Enable dummy mode before test
    if let Err(e) = client.enable_dummy_mode().await {
        // Attempt to clean up nonce_in even if dummy mode enabling fails
        let _ = client
            .set_ext_state("WebAppControl", "test_nonce_in", "")
            .await;
        return map_reaper_error(e).into_response();
    }

    let script_execution_result = client.load_project_by_path(test_path).await;

    // Retrieve nonce_out after script execution
    let nonce_out_result = client
        .get_ext_state("WebAppControl", "test_nonce_out")
        .await;

    // Always disable dummy mode and clean up nonces after
    let _ = client.disable_dummy_mode().await;
    // It's important to clean up nonce_out as well, as the script sets it.
    let _ = client
        .set_ext_state("WebAppControl", "test_nonce_out", "")
        .await;
    // Nonce_in should have been cleaned by the script, but delete defensively if still present.
    let _ = client
        .set_ext_state("WebAppControl", "test_nonce_in", "")
        .await;

    match script_execution_result {
        Ok(_) => {
            // Script execution was Ok, now check nonce
            match nonce_out_result {
                Ok(Some(nonce_out_value)) => {
                    if nonce_out_value == expected_nonce_out {
                        StatusCode::NO_CONTENT.into_response()
                    } else {
                        tracing::warn!(
                            "Nonce mismatch: expected '{}', got '{}'",
                            expected_nonce_out,
                            nonce_out_value
                        );
                        map_reaper_error(
                            crate::data_access::reaper_client::ReaperError::NonceMismatch,
                        )
                        .into_response()
                    }
                }
                Ok(None) => {
                    tracing::warn!("Nonce_out not set by script");
                    map_reaper_error(crate::data_access::reaper_client::ReaperError::NonceMismatch)
                        .into_response()
                }
                Err(e) => {
                    tracing::error!("Failed to get nonce_out: {:?}", e);
                    map_reaper_error(e).into_response()
                }
            }
        }
        Err(e) => map_reaper_error(e).into_response(),
    }
}

// Test List Projects Script Command ID
async fn test_list_projects_command_id(
    State(settings_state): State<Arc<RwLock<Settings>>>,
    Json(payload): Json<TestActionId>,
) -> impl IntoResponse {
    let mut settings = settings_state.read().await.clone();
    if let Some(id) = payload.action_id {
        settings.list_projects_script_action_id = Some(id);
    }
    let client = ReaperClient::new(&settings);

    let nonce = Uuid::new_v4().to_string();
    let expected_nonce_out = format!("{}_modified", nonce);

    // Set nonce_in before enabling dummy mode or running the script
    if let Err(e) = client
        .set_ext_state("WebAppControl", "test_nonce_in", &nonce)
        .await
    {
        return map_reaper_error(e).into_response();
    }

    // Enable dummy mode before test
    if let Err(e) = client.enable_dummy_mode().await {
        // Attempt to clean up nonce_in even if dummy mode enabling fails
        let _ = client
            .set_ext_state("WebAppControl", "test_nonce_in", "")
            .await;
        return map_reaper_error(e).into_response();
    }

    let script_execution_result = client.list_projects().await;

    // Retrieve nonce_out after script execution
    let nonce_out_result = client
        .get_ext_state("WebAppControl", "test_nonce_out")
        .await;

    // Always disable dummy mode and clean up nonces after
    let _ = client.disable_dummy_mode().await;
    let _ = client
        .set_ext_state("WebAppControl", "test_nonce_out", "")
        .await;
    let _ = client
        .set_ext_state("WebAppControl", "test_nonce_in", "")
        .await;

    match script_execution_result {
        Ok(_) => {
            // Script execution was Ok, now check nonce
            match nonce_out_result {
                Ok(Some(nonce_out_value)) => {
                    if nonce_out_value == expected_nonce_out {
                        StatusCode::NO_CONTENT.into_response()
                    } else {
                        tracing::warn!(
                            "Nonce mismatch: expected '{}', got '{}'",
                            expected_nonce_out,
                            nonce_out_value
                        );
                        map_reaper_error(
                            crate::data_access::reaper_client::ReaperError::NonceMismatch,
                        )
                        .into_response()
                    }
                }
                Ok(None) => {
                    tracing::warn!("Nonce_out not set by script");
                    map_reaper_error(crate::data_access::reaper_client::ReaperError::NonceMismatch)
                        .into_response()
                }
                Err(e) => {
                    tracing::error!("Failed to get nonce_out: {:?}", e);
                    map_reaper_error(e).into_response()
                }
            }
        }
        Err(e) => map_reaper_error(e).into_response(),
    }
}
