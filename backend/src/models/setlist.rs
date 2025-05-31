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

impl StoredInDb for SetList {
    const FILENAME: &'static str = "sets.json";

    fn id(&self) -> String {
        self.id.clone()
    }
}
