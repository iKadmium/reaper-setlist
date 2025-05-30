use axum::{Router, http::StatusCode, routing::post};
use tracing::instrument;

use crate::{
    data_access::{json_file::StoredInJsonFile, reaper_client::ReaperClient},
    models::settings::Settings,
};

pub fn reaper_script_api_controller() -> Router {
    Router::new().route("/", post(handle_reaper_script))
}

#[instrument]
async fn handle_reaper_script() -> Result<String, StatusCode> {
    let settings = Settings::load().await;
    match settings {
        Ok(settings) => Ok(ReaperClient::get_script(&settings.reaper_project_path)),
        Err(e) => {
            tracing::error!(err = %e, "Failed to get settings");
            return Err(StatusCode::INTERNAL_SERVER_ERROR);
        }
    }
}
