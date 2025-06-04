use axum::{Router, http::StatusCode, routing::get, response::IntoResponse};
use std::fs;

pub fn reaper_script_api_controller() -> Router {
    Router::new()
        .route("/SetProjectRootFolder.lua", get(serve_set_root_script))
        .route("/LoadProjectFromRelativePath.lua", get(serve_load_project_script))
        .route("/ListProjectFiles.lua", get(serve_list_projects_script))
}

async fn serve_set_root_script() -> Result<impl IntoResponse, StatusCode> {
    serve_lua_script("frontend/static/lua/SetProjectRootFolder.lua").await
}

async fn serve_load_project_script() -> Result<impl IntoResponse, StatusCode> {
    serve_lua_script("frontend/static/lua/LoadProjectFromRelativePath.lua").await
}

async fn serve_list_projects_script() -> Result<impl IntoResponse, StatusCode> {
    serve_lua_script("frontend/static/lua/ListProjectFiles.lua").await
}

async fn serve_lua_script(file_path: &str) -> Result<impl IntoResponse, StatusCode> {
    match fs::read_to_string(file_path) {
        Ok(content) => Ok((
            [("Content-Type", "text/plain; charset=utf-8")],
            content
        )),
        Err(e) => {
            tracing::error!("Failed to read Lua script {}: {}", file_path, e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}
