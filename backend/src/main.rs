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
use tokio::{signal, sync::RwLock};
use tower_http::{
    services::{ServeDir, ServeFile},
    trace::TraceLayer,
};

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
                .make_span_with(|request: &axum::http::Request<_>| {
                    let method = request.method().clone();
                    let uri = request.uri().clone();
                    tracing::info_span!("http_request", method = %method, uri = %uri)
                })
                .on_request(|_request: &axum::http::Request<_>, _span: &tracing::Span| {
                    tracing::info!("started processing request");
                })
                .on_response(|response: &axum::http::Response<_>, latency: std::time::Duration, _span: &tracing::Span| {
                    let status = response.status();
                    if status.is_client_error() || status.is_server_error() {
                        tracing::error!(latency = ?latency, status = %status, "response finished");
                    } else {
                        tracing::info!(latency = ?latency, status = %status, "response finished");
                    }
                })
        );

    let app = Router::new().merge(api_router).fallback(static_service);

    // run our app with hyper, listening globally on port 3000
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    tracing::info!(addr = %listener.local_addr().unwrap(), "Server running");

    // This is the key change for graceful shutdown:
    // `axum::serve` now includes a `with_graceful_shutdown` future that awaits Ctrl+C.
    let server = axum::serve(listener, app).with_graceful_shutdown(async {
        // Await the Ctrl+C signal. This future completes when Ctrl+C is pressed.
        signal::ctrl_c()
            .await
            .expect("Failed to listen for Ctrl+C signal");
        tracing::info!("Received Ctrl+C, initiating graceful shutdown...");
    });

    // Await the server. It will run until the graceful_shutdown future completes.
    server.await.unwrap();
    tracing::info!("Server shut down gracefully.");
}
