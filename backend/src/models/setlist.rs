use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

use crate::data_access::database::StoredInDb;

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub(crate) struct SetList {
    pub id: String,
    pub venue: String,
    pub date: DateTime<Utc>,
    pub songs: Vec<String>,
}

#[derive(Deserialize, Debug, Clone)]
pub(crate) struct NewSetList {
    pub venue: String,
    pub date: DateTime<Utc>,
    pub songs: Vec<String>,
}

impl SetList {
    pub fn from_new_setlist(new_setlist: NewSetList) -> Self {
        Self {
            id: uuid::Uuid::new_v4().to_string(),
            venue: new_setlist.venue,
            date: new_setlist.date,
            songs: new_setlist.songs,
        }
    }
}

impl StoredInDb for SetList {
    const FILENAME: &'static str = "sets.json";

    fn id(&self) -> String {
        self.id.clone()
    }
}
