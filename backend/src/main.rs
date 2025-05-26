pub mod reaper_project; // Made reaper_project module public

use axum::Router;
use reaper_project::reaper_project::reaper_project_controller;

#[tokio::main]
async fn main() {
    // build our application with a single route
    let app = Router::new().nest("/api/reaper-project", reaper_project_controller()); // Removed .with_state(app_state)

    // run our app with hyper, listening globally on port 3000
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
