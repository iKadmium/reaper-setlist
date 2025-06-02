use crate::data_access::database::StoredInDb;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
pub(crate) struct Song {
    pub id: String,
    pub name: String,
    pub length: u64, // Length in seconds
}

#[derive(Deserialize, Debug, Clone)]
pub(crate) struct NewSong {
    pub name: String,
    pub length: u64, // Length in seconds
}

impl Song {
    pub fn from_new_song(new_song: NewSong) -> Self {
        Self {
            id: uuid::Uuid::new_v4().to_string(),
            name: new_song.name,
            length: new_song.length,
        }
    }
}

impl StoredInDb for Song {
    const FILENAME: &'static str = "songs.json";

    fn id(&self) -> String {
        self.id.clone()
    }
}
