use axum::{
    Json, Router,
    extract::Path,
    http::StatusCode,
    response::IntoResponse,
    routing::{delete, get, post, put},
};
use axum_extra::extract::WithRejection;
use tracing::instrument; // Added instrument

use crate::{
    data_access::database::StoredInDb,              // Added StoredInDb
    models::{database::Database, setlist::SetList}, // Added Database and SetList
};

use super::error::JsonError;

pub fn set_api_controller() -> Router {
    Router::new()
        .route("/", get(get_all_sets))
        .route("/", post(create_set))
        .route("/{id}", get(get_set_by_id))
        .route("/{id}", put(update_set_by_id))
        .route("/{id}", delete(delete_set_by_id))
}

#[instrument]
async fn get_all_sets() -> Result<Json<Database<SetList>>, StatusCode> {
    match SetList::get_all().await {
        Ok(db) => Ok(Json(db)),
        Err(e) => {
            tracing::error!(error = %e, "Failed to retrieve setlist list");
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

#[instrument]
async fn create_set(
    WithRejection(Json(setlist), _): WithRejection<Json<SetList>, JsonError>,
) -> impl IntoResponse {
    match setlist.save().await {
        Ok(()) => Ok(Json(setlist)),
        Err(e) => {
            tracing::error!(error = %e, "Failed to create setlist");
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

#[instrument]
async fn get_set_by_id(Path(id): Path<String>) -> Result<Json<SetList>, StatusCode> {
    match SetList::get_by_id(&id).await {
        Ok(setlist) => Ok(Json(setlist)),
        Err(e) => {
            tracing::error!(error = %e, "Failed to retrieve setlist by id");
            Err(StatusCode::NOT_FOUND)
        }
    }
}

#[instrument]
async fn update_set_by_id(
    Path(id): Path<String>,
    Json(setlist): Json<SetList>,
) -> Result<Json<SetList>, StatusCode> {
    if setlist.id() != id {
        tracing::warn!(
            "Mismatched id in path and body: path_id={}, body_id={}",
            id,
            setlist.id()
        );
        return Err(StatusCode::BAD_REQUEST);
    }
    match setlist.save().await {
        Ok(()) => Ok(Json(setlist)),
        Err(e) => {
            tracing::error!(error = %e, "Failed to update setlist by id");
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

#[instrument]
async fn delete_set_by_id(Path(id): Path<String>) -> Result<StatusCode, StatusCode> {
    match SetList::get_by_id(&id).await {
        Ok(setlist) => match setlist.delete().await {
            Ok(()) => Ok(StatusCode::NO_CONTENT),
            Err(e) => {
                tracing::error!(error = %e, "Failed to delete setlist by id");
                Err(StatusCode::INTERNAL_SERVER_ERROR)
            }
        },
        Err(e) => {
            tracing::error!(error = %e, "Failed to find setlist to delete by id");
            Err(StatusCode::NOT_FOUND)
        }
    }
}
