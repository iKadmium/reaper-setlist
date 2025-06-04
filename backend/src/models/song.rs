use crate::data_access::database::StoredInDb;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
pub(crate) struct Song {
    pub id: String,
    pub name: String,
    pub length: u64,           // Length in seconds
    pub relative_path: String, // Relative path to the project file
}

#[derive(Deserialize, Debug, Clone)]
pub(crate) struct NewSong {
    pub name: String,
    pub length: u64,           // Length in seconds
    pub relative_path: String, // Relative path to the project file
}

impl Song {
    pub fn from_new_song(new_song: NewSong) -> Self {
        Self {
            id: uuid::Uuid::new_v4().to_string(),
            name: new_song.name,
            length: new_song.length,
            relative_path: new_song.relative_path,
        }
    }
}

impl StoredInDb for Song {
    const FILENAME: &'static str = "songs.json";

    fn id(&self) -> String {
        self.id.clone()
    }
}
