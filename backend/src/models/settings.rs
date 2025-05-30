use serde::{Deserialize, Serialize};

use crate::data_access::json_file::StoredInJsonFile;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Settings {
    pub(crate) reaper_path: String,
    pub(crate) reaper_script_path: String,
    pub(crate) reaper_project_path: String,
}

impl Default for Settings {
    fn default() -> Self {
        Self {
            reaper_path: String::new(),
            reaper_script_path: String::new(),
            reaper_project_path: String::new(),
        }
    }
}

impl StoredInJsonFile for Settings {
    const FILENAME: &'static str = "settings.json";
}
