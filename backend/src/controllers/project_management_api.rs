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
    match err {
        ReaperError::Http(e) => {
            tracing::error!("HTTP error: {:?}", e);
            (StatusCode::BAD_GATEWAY, format!("Network error: {}", e))
        }
        ReaperError::Command(msg) => {
            tracing::error!("Command error: {}", msg);
            (StatusCode::BAD_REQUEST, format!("Command failed: {}", msg))
        }
        ReaperError::Parse(msg) => {
            tracing::error!("Parse error: {}", msg);
            (StatusCode::UNPROCESSABLE_ENTITY, format!("Parse error: {}", msg))
        }
        ReaperError::ConfigError(msg) => {
            tracing::error!("Config error: {}", msg);
            (StatusCode::PRECONDITION_FAILED, format!("Configuration error: {}", msg))
        }
    }
}

pub fn project_management_api_controller(settings_state: Arc<RwLock<Settings>>) -> Router {
    Router::new()
        .route("/set-root", post(set_project_root))
        .route("/list", get(list_projects))
        .route("/load", post(load_project))
        .with_state(settings_state)
}

async fn set_project_root(
    State(settings_state): State<Arc<RwLock<Settings>>>,
    Json(request): Json<SetRootRequest>,
) -> Result<StatusCode, impl IntoResponse> {
    let settings = settings_state.read().await.clone();
    
    match ReaperClient::new(&settings).await {
        Ok(client) => {
            match client.set_project_root(&request.folder_path, &settings).await {
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
            match client.load_project_by_path(&request.relative_path, &settings).await {
                Ok(_) => Ok(StatusCode::OK),
                Err(e) => Err(map_reaper_error(e)),
            }
        }
        Err(e) => Err(map_reaper_error(e)),
    }
}
