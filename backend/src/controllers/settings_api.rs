use axum::{Json, Router, extract::State, http::StatusCode, response::IntoResponse, routing::get};
use std::sync::Arc;
use tokio::sync::RwLock; // Added import for RwLock
use tracing::instrument;

use crate::data_access::json_file::StoredInJsonFile;
use crate::models::settings::Settings;

pub fn settings_api_controller(settings_state: Arc<RwLock<Settings>>) -> Router {
    // Changed to Arc<RwLock<Settings>>
    Router::new()
        .route("/", get(get_settings).put(update_settings))
        .with_state(settings_state)
}

#[instrument(skip(settings_state))]
async fn get_settings(State(settings_state): State<Arc<RwLock<Settings>>>) -> Json<Settings> {
    // Changed to Arc<RwLock<Settings>>
    let settings_read_guard = settings_state.read().await;
    Json(settings_read_guard.clone())
}

#[instrument(skip(settings_state, new_settings))]
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
