use std::sync::Arc;

use axum::{
    Json, Router,
    extract::{self, State},
    http::StatusCode,
    routing::{delete, get, post, put},
};
use tokio::sync::RwLock;

use crate::{
    data_access::{database::StoredInDb, reaper_client::ReaperClient},
    models::{
        database::Database,
        settings::Settings,
        song::{NewSong, Song},
    },
};

pub fn song_api_controller(settings_state: Arc<RwLock<Settings>>) -> Router {
    Router::new()
        .route("/", get(get_all_songs))
        .route("/", post(add_song))
        .route("/{id}", get(get_song_by_id))
        .route("/{id}", put(edit_song_by_id))
        .route("/{id}", delete(delete_song_by_id))
        .route("/{id}/load", get(load_song_by_id))
        .with_state(settings_state)
}

async fn get_all_songs() -> Result<Json<Database<Song>>, StatusCode> {
    let result = Song::get_all().await;
    match result {
        Ok(db) => Ok(Json(db)),
        Err(e) => {
            tracing::error!(error = %e, "Failed to retrieve song list");
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

async fn add_song(extract::Json(song): extract::Json<NewSong>) -> Result<Json<Song>, StatusCode> {
    let real_song = Song::from_new_song(song);
    let result = real_song.save().await;
    match result {
        Ok(()) => Ok(Json(real_song)),
        Err(e) => {
            tracing::error!(error = %e, "Failed to add song");
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

async fn get_song_by_id(
    extract::Path(id): extract::Path<String>,
) -> Result<Json<Song>, StatusCode> {
    let result = Song::get_by_id(&id).await;
    match result {
        Ok(song) => Ok(Json(song)),
        Err(e) => {
            tracing::error!(error = %e, "Failed to retrieve song by id");
            Err(StatusCode::NOT_FOUND)
        }
    }
}

async fn edit_song_by_id(
    extract::Path(id): extract::Path<String>,
    extract::Json(song): extract::Json<Song>,
) -> Result<Json<Song>, StatusCode> {
    if song.id != id {
        return Err(StatusCode::BAD_REQUEST);
    }
    let result = song.save().await;
    match result {
        Ok(()) => Ok(Json(song)),
        Err(e) => {
            tracing::error!("Failed to edit song by id {}: {}", id, e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

async fn delete_song_by_id(
    extract::Path(id): extract::Path<String>,
) -> Result<StatusCode, StatusCode> {
    let result = Song::get_by_id(&id).await;
    match result {
        Ok(song) => {
            song.delete()
                .await
                .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
            Ok(StatusCode::NO_CONTENT)
        }
        Err(e) => {
            tracing::error!("Failed to delete song by id {}: {}", id, e);
            Err(StatusCode::NOT_FOUND)
        }
    }
}

async fn load_song_by_id(
    State(settings_state): State<Arc<RwLock<Settings>>>,
    extract::Path(id): extract::Path<String>,
) -> Result<StatusCode, StatusCode> {
    let result = Song::get_by_id(&id).await;
    match result {
        Ok(song) => {
            let settings = settings_state.read().await.clone();
            ReaperClient::new(&settings)
                .await
                .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
                .load_project(&song.name)
                .await
                .map_err(|_| StatusCode::BAD_GATEWAY)?;
            Ok(StatusCode::NO_CONTENT)
        }
        Err(_e) => Err(StatusCode::NOT_FOUND),
    }
}
