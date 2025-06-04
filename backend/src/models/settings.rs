use serde::{Deserialize, Serialize};

use crate::data_access::json_file::StoredInJsonFile;

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
#[serde(rename_all = "camelCase")]
pub struct Settings {
    pub(crate) folder_path: String,
    pub(crate) reaper_url: String,
    pub(crate) reaper_username: Option<String>,
    pub(crate) reaper_password: Option<String>,
    pub(crate) set_root_script_action_id: Option<u32>,
    pub(crate) load_project_script_action_id: Option<u32>,
    pub(crate) list_projects_script_action_id: Option<u32>,
}

impl StoredInJsonFile for Settings {
    const FILENAME: &'static str = "settings.json";
}
