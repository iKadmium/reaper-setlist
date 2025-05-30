mod controllers;
pub(crate) mod data_access;
mod models;

use axum::Router;
use controllers::reaper_project_api::reaper_project_api_controller;
use controllers::reaper_script_api::reaper_script_api_controller;
use controllers::set_api::set_api_controller;
use controllers::settings_api::settings_api_controller;
use controllers::song_api::song_api_controller;
use data_access::json_file::StoredInJsonFile;
use models::settings::Settings;
use std::sync::Arc;
use tokio::sync::RwLock; // Added import for RwLock

#[tokio::main]
async fn main() {
    // Load settings
    let initial_settings = match Settings::load().await {
        Ok(s) => s,
        Err(e) => {
            eprintln!("Failed to load settings: {}. Using default settings.", e);
            Settings::default()
        }
    };
    let settings_state = Arc::new(RwLock::new(initial_settings)); // Wrap in RwLock

    // build our application with a single route
    let app = Router::new()
        .nest(
            "/api/reaper-project",
            reaper_project_api_controller(settings_state.clone()),
        )
        .nest("/api/reaper-script", reaper_script_api_controller())
        .nest("/api/songs", song_api_controller(settings_state.clone()))
        .nest("/api/sets", set_api_controller())
        .nest(
            "/api/settings",
            settings_api_controller(settings_state.clone()),
        ); // Pass Arc<RwLock<Settings>>

    // run our app with hyper, listening globally on port 3000
    let listener = tokio::net::TcpListener::bind("0.0.0.0:4000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
