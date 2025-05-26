use axum::{Router, extract::Path, routing::post};

pub fn reaper_project_controller() -> Router {
    Router::new().route("/{name}/load", post(load_project))
}

async fn load_project(Path(name): Path<String>) -> String {
    println!("Project name: {}", name);
    "lol".to_string()
}
