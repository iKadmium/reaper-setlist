use axum::{
    Json, Router,
    extract::State,
    http::StatusCode,
    response::IntoResponse,
    routing::{get, post},
};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use tokio::sync::RwLock;

use crate::{
    data_access::reaper_client::{ReaperClient, ReaperError},
    models::settings::Settings,
};

// Request/Response types
#[derive(Deserialize)]
struct SetRootRequest {
    folder_path: String,
}

#[derive(Serialize)]
struct ProjectListResponse {
    projects: Vec<String>,
}

#[derive(Deserialize)]
struct LoadProjectRequest {
    relative_path: String,
}

// Helper function to map ReaperError to an appropriate HTTP response
fn map_reaper_error(err: ReaperError) -> impl IntoResponse {
    tracing::error!("Reaper error: {:?}", err);
    match err {
        ReaperError::Http(e) => (
            StatusCode::INTERNAL_SERVER_ERROR,
            format!("Reaper HTTP error: {}", e),
        ),
        ReaperError::Command(e) => (
            StatusCode::BAD_GATEWAY,
            format!("Reaper command error: {}", e),
        ),
        ReaperError::Parse(e) => (
            StatusCode::INTERNAL_SERVER_ERROR,
            format!("Reaper response parse error: {}", e),
        ),
        ReaperError::Config(e) => (
            StatusCode::PRECONDITION_FAILED,
            format!("Reaper configuration error: {}", e),
        ),
    }
}

pub fn project_api_controller(settings: Arc<RwLock<Settings>>) -> Router {
    Router::new()
        // Project management routes
        .route("/set-root", post(set_project_root))
        .route("/list", get(list_projects))
        .route("/load", post(load_project))
        // Current project control routes
        .route("/current/get-duration", post(get_current_project_duration))
        .route("/current/go-to-start", post(current_project_go_to_start))
        .route("/current/go-to-end", post(current_project_go_to_end))
        .route("/new-tab", post(new_project_tab))
        .with_state(settings)
}

// Project Management Endpoints

async fn set_project_root(
    State(settings_state): State<Arc<RwLock<Settings>>>,
    Json(request): Json<SetRootRequest>,
) -> Result<StatusCode, impl IntoResponse> {
    let settings = settings_state.read().await.clone();

    match ReaperClient::new(&settings).await {
        Ok(client) => {
            match client
                .set_project_root(&request.folder_path, &settings)
                .await
            {
                Ok(_) => Ok(StatusCode::OK),
                Err(e) => Err(map_reaper_error(e)),
            }
        }
        Err(e) => Err(map_reaper_error(e)),
    }
}

async fn list_projects(
    State(settings_state): State<Arc<RwLock<Settings>>>,
) -> Result<Json<ProjectListResponse>, impl IntoResponse> {
    let settings = settings_state.read().await.clone();

    match ReaperClient::new(&settings).await {
        Ok(client) => {
            match client
                .set_project_root(&settings.folder_path, &settings)
                .await
            {
                Ok(_) => {}
                Err(e) => return Err(map_reaper_error(e)),
            }
            match client.list_projects(&settings).await {
                Ok(projects) => Ok(Json(ProjectListResponse { projects })),
                Err(e) => Err(map_reaper_error(e)),
            }
        }
        Err(e) => Err(map_reaper_error(e)),
    }
}

async fn load_project(
    State(settings_state): State<Arc<RwLock<Settings>>>,
    Json(request): Json<LoadProjectRequest>,
) -> Result<StatusCode, impl IntoResponse> {
    let settings = settings_state.read().await.clone();

    match ReaperClient::new(&settings).await {
        Ok(client) => {
            match client
                .load_project_by_path(&request.relative_path, &settings)
                .await
            {
                Ok(_) => Ok(StatusCode::OK),
                Err(e) => Err(map_reaper_error(e)),
            }
        }
        Err(e) => Err(map_reaper_error(e)),
    }
}

// Current Project Control Endpoints

async fn get_current_project_duration(
    State(settings_state): State<Arc<RwLock<Settings>>>,
) -> Result<Json<u64>, impl IntoResponse> {
    let settings_read_guard = settings_state.read().await;
    match ReaperClient::new(&settings_read_guard).await {
        Ok(client) => match client.get_duration().await {
            Ok(duration) => Ok(Json(duration.as_secs())),
            Err(e) => Err(map_reaper_error(e)),
        },
        Err(e) => Err(map_reaper_error(e)),
    }
}

async fn current_project_go_to_start(
    State(settings_state): State<Arc<RwLock<Settings>>>,
) -> Result<StatusCode, impl IntoResponse> {
    let settings_read_guard = settings_state.read().await;
    match ReaperClient::new(&settings_read_guard).await {
        Ok(client) => match client.go_to_start().await {
            Ok(_) => Ok(StatusCode::OK),
            Err(e) => Err(map_reaper_error(e)),
        },
        Err(e) => Err(map_reaper_error(e)),
    }
}

async fn current_project_go_to_end(
    State(settings_state): State<Arc<RwLock<Settings>>>,
) -> Result<StatusCode, impl IntoResponse> {
    let settings_read_guard = settings_state.read().await;
    match ReaperClient::new(&settings_read_guard).await {
        Ok(client) => match client.go_to_end().await {
            Ok(_) => Ok(StatusCode::OK),
            Err(e) => Err(map_reaper_error(e)),
        },
        Err(e) => Err(map_reaper_error(e)),
    }
}

async fn new_project_tab(
    State(settings_state): State<Arc<RwLock<Settings>>>,
) -> Result<StatusCode, impl IntoResponse> {
    let settings_read_guard = settings_state.read().await;
    match ReaperClient::new(&settings_read_guard).await {
        Ok(client) => match client.new_tab().await {
            Ok(_) => Ok(StatusCode::OK),
            Err(e) => Err(map_reaper_error(e)),
        },
        Err(e) => Err(map_reaper_error(e)),
    }
}
