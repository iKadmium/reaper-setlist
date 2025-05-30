use crate::data_access::database::StoredInDb;
use serde::{Deserialize, Serialize};
use std::time::Duration;

#[derive(Debug, Serialize, Deserialize, Clone)]
pub(crate) struct Song {
    pub id: String,
    pub name: String,
    pub length: Duration,
}

impl StoredInDb for Song {
    const FILENAME: &'static str = "songs.json";

    fn id(&self) -> String {
        self.id.clone()
    }
}
