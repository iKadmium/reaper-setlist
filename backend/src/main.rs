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
use tower_http::{
    services::{ServeDir, ServeFile},
    trace::{DefaultMakeSpan, DefaultOnRequest, TraceLayer},
};
use tracing::Level; // Import Level for setting trace level

const SPA_DIR: &str = "assets";

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

    // Create a service to serve the index.html file
    let index_html_service = ServeFile::new(format!("{}/index.html", SPA_DIR));

    // Create the static file service with a fallback to index.html
    let static_service = get_service(ServeDir::new(SPA_DIR).fallback(index_html_service));

    let api_router = Router::new()
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
        .layer(
            TraceLayer::new_for_http()
                .make_span_with(DefaultMakeSpan::new())
                .on_request(DefaultOnRequest::new().level(Level::INFO))
                .on_response(|response: &axum::http::Response<_>, latency: std::time::Duration, _span: &tracing::Span| {
                    let status = response.status();
                    if status.is_client_error() || status.is_server_error() {
                        tracing::warn!(latency = ?latency, status = %status, "response finished");
                    } else {
                        tracing::info!(latency = ?latency, status = %status, "response finished");
                    }
                })
        );

    let app = Router::new().merge(api_router).fallback(static_service);

    // run our app with hyper, listening globally on port 3000
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    tracing::info!(addr = %listener.local_addr().unwrap(), "Server running");
    axum::serve(listener, app).await.unwrap();
}
