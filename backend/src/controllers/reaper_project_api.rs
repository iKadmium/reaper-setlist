use axum::{
    Json, Router,
    extract::{Path, State},
    http::StatusCode,
    response::IntoResponse,
    routing::post,
};
use std::sync::Arc;
use tokio::sync::RwLock; // Added import for RwLock
use tracing::instrument;

use crate::{
    data_access::reaper_client::{ReaperClient, ReaperError},
    models::settings::Settings,
};

// Helper function to map ReaperError to an appropriate HTTP response
fn map_reaper_error(err: ReaperError) -> impl IntoResponse {
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
    }
}

pub fn reaper_project_api_controller(settings: Arc<RwLock<Settings>>) -> Router {
    Router::new()
        .route("/current/get-duration", post(get_current_project_duration))
        .route("/new-tab", post(new_project_tab))
        .route("/{name}/load", post(load_project_by_name))
        .route("/current/go-to-start", post(current_project_go_to_start))
        .route("/current/go-to-end", post(current_project_go_to_end)) // Assuming go-to-end is similar to go-to-start
        .with_state(settings)
}

#[instrument(skip(settings_state))]
async fn get_current_project_duration(
    State(settings_state): State<Arc<RwLock<Settings>>>, // Changed to Arc<RwLock<Settings>>
) -> Result<Json<u64>, impl IntoResponse> {
    let settings_read_guard = settings_state.read().await; // Acquire read lock
    match ReaperClient::new(&settings_read_guard).await {
        // Pass reference to Settings inside guard
        Ok(client) => match client.get_transport_seconds().await {
            Ok(duration) => Ok(Json(duration)),
            Err(e) => Err(map_reaper_error(e)),
        },
        Err(e) => Err(map_reaper_error(e)),
    }
}

#[instrument(skip(settings_state))]
async fn new_project_tab(
    State(settings_state): State<Arc<RwLock<Settings>>>, // Changed to Arc<RwLock<Settings>>
) -> Result<StatusCode, impl IntoResponse> {
    let settings_read_guard = settings_state.read().await; // Acquire read lock
    match ReaperClient::new(&settings_read_guard).await {
        // Pass reference to Settings inside guard
        Ok(client) => match client.new_tab().await {
            Ok(_) => Ok(StatusCode::OK),
            Err(e) => Err(map_reaper_error(e)),
        },
        Err(e) => Err(map_reaper_error(e)),
    }
}

#[instrument(skip(settings_state))]
async fn load_project_by_name(
    Path(name): Path<String>,
    State(settings_state): State<Arc<RwLock<Settings>>>, // Changed to Arc<RwLock<Settings>>
) -> Result<StatusCode, impl IntoResponse> {
    let settings_read_guard = settings_state.read().await; // Acquire read lock
    match ReaperClient::new(&settings_read_guard).await {
        // Pass reference to Settings inside guard
        Ok(client) => match client.load_project(&name).await {
            Ok(_) => Ok(StatusCode::OK),
            Err(e) => Err(map_reaper_error(e)),
        },
        Err(e) => Err(map_reaper_error(e)),
    }
}

#[instrument(skip(settings_state))]
async fn current_project_go_to_start(
    State(settings_state): State<Arc<RwLock<Settings>>>, // Changed to Arc<RwLock<Settings>>
) -> Result<StatusCode, impl IntoResponse> {
    let settings_read_guard = settings_state.read().await; // Acquire read lock
    match ReaperClient::new(&settings_read_guard).await {
        // Pass reference to Settings inside guard
        Ok(client) => match client.go_to_start().await {
            Ok(_) => Ok(StatusCode::OK),
            Err(e) => Err(map_reaper_error(e)),
        },
        Err(e) => Err(map_reaper_error(e)),
    }
}

#[instrument(skip(settings_state))]
async fn current_project_go_to_end(
    State(settings_state): State<Arc<RwLock<Settings>>>, // Changed to Arc<RwLock<Settings>>
) -> Result<StatusCode, impl IntoResponse> {
    let settings_read_guard = settings_state.read().await; // Acquire read lock
    match ReaperClient::new(&settings_read_guard).await {
        // Pass reference to Settings inside guard
        Ok(client) => match client.go_to_end().await {
            Ok(_) => Ok(StatusCode::OK),
            Err(e) => Err(map_reaper_error(e)),
        },
        Err(e) => Err(map_reaper_error(e)),
    }
}
