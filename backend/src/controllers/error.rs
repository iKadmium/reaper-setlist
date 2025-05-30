use axum::{
    extract::FromRequest, extract::rejection::JsonRejection, http::StatusCode,
    response::IntoResponse,
};
use serde::Serialize;
use serde_json::json;
use tracing::instrument;

// create an extractor that internally uses `axum::Json` but has a custom rejection
#[derive(FromRequest, Debug)]
#[from_request(via(axum::Json), rejection(JsonError))]
pub struct Json<T>(T);

// We implement `IntoResponse` for our extractor so it can be used as a response
impl<T: Serialize> IntoResponse for Json<T> {
    fn into_response(self) -> axum::response::Response {
        let Self(value) = self;
        axum::Json(value).into_response()
    }
}

// We create our own rejection type
#[derive(Debug)]
pub struct JsonError {
    status: StatusCode,
    message: String,
}

// We implement `From<JsonRejection> for ApiError`
impl From<JsonRejection> for JsonError {
    fn from(rejection: JsonRejection) -> Self {
        Self {
            status: rejection.status(),
            message: rejection.body_text(),
        }
    }
}

// We implement `IntoResponse` so `ApiError` can be used as a response
impl IntoResponse for JsonError {
    #[instrument]
    fn into_response(self) -> axum::response::Response {
        let payload = json!({
            "message": self.message,
            "origin": "derive_from_request"
        });
        tracing::error!("Deserialization failed");

        (self.status, axum::Json(payload)).into_response()
    }
}
