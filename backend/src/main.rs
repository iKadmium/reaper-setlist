mod controllers;
pub(crate) mod data_access;
mod models;

use axum::Router;
use axum::routing::get_service;
use controllers::reaper_project_api::reaper_project_api_controller;
use controllers::reaper_script_api::reaper_script_api_controller;
use controllers::set_api::set_api_controller;
use controllers::settings_api::settings_api_controller;
use controllers::song_api::song_api_controller;
use data_access::json_file::StoredInJsonFile;
use models::settings::Settings;
use std::sync::Arc;
use tokio::sync::RwLock;
use tower_http::services::{ServeDir, ServeFile}; // Import ServeFile

#[tokio::main]
async fn main() {
    // Initialize tracing for logging
    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| tracing_subscriber::EnvFilter::new("info")),
        )
        .init();

    // Load settings
    let initial_settings = match Settings::load().await {
        Ok(s) => s,
        Err(e) => {
            eprintln!("Failed to load settings: {}. Using default settings.", e);
            Settings::default()
        }
    };
    let settings_state = Arc::new(RwLock::new(initial_settings));

    // build our application with a single route
    let spa_dir = "/workspaces/reaper-setlist/frontend/build";

    // Create a service to serve the index.html file
    let index_html_service = ServeFile::new(format!("{}/index.html", spa_dir));

    // Create the static file service with a fallback to index.html
    let static_service = ServeDir::new(spa_dir).fallback(index_html_service);

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
        )
        .fallback(get_service(static_service)); // Wrap in get_service when used as fallback

    // run our app with hyper, listening globally on port 3000
    let listener = tokio::net::TcpListener::bind("0.0.0.0:4000").await.unwrap();
    tracing::info!(addr = %listener.local_addr().unwrap(), "Server running");
    axum::serve(listener, app).await.unwrap();
}
