use crate::data_access::database::StoredInDb;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
pub(crate) struct Song {
    pub name: String,
    pub length: u64, // Length in seconds
}

impl StoredInDb for Song {
    const FILENAME: &'static str = "songs.json";

    fn id(&self) -> String {
        self.name.clone()
    }
}
