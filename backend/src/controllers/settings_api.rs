use axum::{
    Json, Router,
    extract::State,
    http::StatusCode,
    response::IntoResponse,
    routing::{get, post, put},
};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use tokio::sync::RwLock;

use crate::data_access::{json_file::StoredInJsonFile, reaper_client::ReaperClient};
use crate::models::settings::Settings;

#[derive(Deserialize)]
struct TestConnectionRequest {
    reaper_url: String,
    reaper_username: Option<String>,
    reaper_password: Option<String>,
}

#[derive(Serialize)]
struct TestConnectionResponse {
    success: bool,
    message: String,
}

pub fn settings_api_controller(settings_state: Arc<RwLock<Settings>>) -> Router {
    // Changed to Arc<RwLock<Settings>>
    Router::new()
        .route("/", get(get_settings).put(update_settings))
        .route("/action-ids", put(update_action_ids))
        .route("/test-connection", post(test_reaper_connection))
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
    match new_settings.save().await {
        Ok(_) => {
            let mut settings_write_guard = settings_state.write().await; // Acquire write lock
            *settings_write_guard = new_settings; // Update the in-memory settings
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
    set_root_script_action_id: Option<u32>,
    load_project_script_action_id: Option<u32>,
    list_projects_script_action_id: Option<u32>,
}

async fn update_action_ids(
    State(settings_state): State<Arc<RwLock<Settings>>>,
    Json(action_ids): Json<ActionIdsRequest>,
) -> impl IntoResponse {
    let mut settings_write_guard = settings_state.write().await;
    let mut updated_settings = settings_write_guard.clone();

    // Update the action IDs
    updated_settings.set_root_script_action_id = action_ids.set_root_script_action_id;
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
        set_root_script_action_id: None,
        load_project_script_action_id: None,
        list_projects_script_action_id: None,
    };

    match ReaperClient::new(&test_settings).await {
        Ok(client) => {
            // Try a simple command to test the connection
            match client.go_to_start().await {
                Ok(_) => Json(TestConnectionResponse {
                    success: true,
                    message: "Successfully connected to Reaper!".to_string(),
                }),
                Err(e) => {
                    tracing::warn!("Reaper connection test failed: {:?}", e);
                    Json(TestConnectionResponse {
                        success: false,
                        message: format!("Failed to communicate with Reaper: {:?}", e),
                    })
                }
            }
        }
        Err(e) => {
            tracing::warn!("Failed to create Reaper client: {:?}", e);
            Json(TestConnectionResponse {
                success: false,
                message: format!("Failed to connect to Reaper: {:?}", e),
            })
        }
    }
}
