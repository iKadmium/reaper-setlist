use crate::models::settings::Settings;
use reqwest::Error as ReqwestError;
use std::time::Duration;

#[derive(Debug)]
pub enum ReaperError {
    Http(ReqwestError),
    Command(String),
    Parse(String),
    ConfigError(String),
}

impl From<ReqwestError> for ReaperError {
    fn from(err: ReqwestError) -> ReaperError {
        ReaperError::Http(err)
    }
}

pub struct ReaperClient {
    base_url: String,
    client: reqwest::Client,
}

impl ReaperClient {
    pub async fn new(settings: &Settings) -> Result<Self, ReaperError> {
        let reaper_url = settings.reaper_url.clone();

        if reaper_url.is_empty() {
            return Err(ReaperError::Command(
                "Reaper URL is not configured".to_string(),
            ));
        }

        Ok(Self {
            base_url: reaper_url,
            client: reqwest::Client::new(),
        })
    }

    // Set project root folder using the new API approach
    pub async fn set_project_root(
        &self,
        folder_path: &str,
        settings: &Settings,
    ) -> Result<(), ReaperError> {
        let action_id = settings.set_root_script_action_id.ok_or_else(|| {
            ReaperError::ConfigError("Set root script action ID not configured".to_string())
        })?;

        // Step 1: Set temporary ExtState
        let section = "WebAppControl";
        let temp_key = "temp_set_root_path";

        let encoded_path = urlencoding::encode(folder_path);
        let set_temp_state_url = format!(
            "{}/_extstate?section={}&key={}&value={}",
            self.base_url, section, temp_key, encoded_path
        );

        let response = self.client.get(&set_temp_state_url).send().await?;
        if !response.status().is_success() {
            return Err(ReaperError::Command(format!(
                "Failed to set temporary ExtState: {}",
                response.status()
            )));
        }

        // Step 2: Trigger the script
        let trigger_script_url = format!("{}/_run?_action={}", self.base_url, action_id);
        let response = self.client.get(&trigger_script_url).send().await?;
        if !response.status().is_success() {
            return Err(ReaperError::Command(format!(
                "Failed to trigger root folder setting script: {}",
                response.status()
            )));
        }

        Ok(())
    }

    // List project files using the new API approach
    pub async fn list_projects(&self, settings: &Settings) -> Result<Vec<String>, ReaperError> {
        let action_id = settings.list_projects_script_action_id.ok_or_else(|| {
            ReaperError::ConfigError("List projects script action ID not configured".to_string())
        })?;

        let section = "WebAppControl";
        let list_output_key = "project_file_list";

        // Step 1: Trigger the script
        let trigger_script_url = format!("{}/_run?_action={}", self.base_url, action_id);
        let response = self.client.get(&trigger_script_url).send().await?;
        if !response.status().is_success() {
            return Err(ReaperError::Command(format!(
                "Failed to trigger list script: {}",
                response.status()
            )));
        }

        // Step 2: Wait a moment for script execution
        tokio::time::sleep(Duration::from_millis(1000)).await;

        // Step 3: Retrieve the project list from ExtState
        let get_list_url = format!(
            "{}/_extstate?section={}&key={}",
            self.base_url, section, list_output_key
        );
        let response = self.client.get(&get_list_url).send().await?;
        if !response.status().is_success() {
            return Err(ReaperError::Command(format!(
                "Failed to retrieve project list from ExtState: {}",
                response.status()
            )));
        }

        let file_list_str = response.text().await?;
        if file_list_str.starts_with("ERROR") {
            return Err(ReaperError::Command(format!(
                "Reaper script error: {}",
                file_list_str
            )));
        }

        let project_files: Vec<String> = if file_list_str.is_empty() {
            Vec::new()
        } else {
            file_list_str.split(',').map(|s| s.to_string()).collect()
        };

        Ok(project_files)
    }

    // Load a project by relative path using the new API approach
    pub async fn load_project_by_path(
        &self,
        relative_project_path: &str,
        settings: &Settings,
    ) -> Result<(), ReaperError> {
        let action_id = settings.load_project_script_action_id.ok_or_else(|| {
            ReaperError::ConfigError("Load project script action ID not configured".to_string())
        })?;

        let section = "WebAppControl";
        let temp_project_path_key = "temp_load_project_path";

        // Step 1: Set temporary ExtState for project path
        let encoded_path = urlencoding::encode(relative_project_path);
        let set_temp_state_url = format!(
            "{}/_extstate?section={}&key={}&value={}",
            self.base_url, section, temp_project_path_key, encoded_path
        );

        let response = self.client.get(&set_temp_state_url).send().await?;
        if !response.status().is_success() {
            return Err(ReaperError::Command(format!(
                "Failed to set temporary ExtState for project load: {}",
                response.status()
            )));
        }

        // Step 2: Trigger the script
        let trigger_script_url = format!("{}/_run?_action={}", self.base_url, action_id);
        let response = self.client.get(&trigger_script_url).send().await?;
        if !response.status().is_success() {
            return Err(ReaperError::Command(format!(
                "Failed to trigger project load script: {}",
                response.status()
            )));
        }

        Ok(())
    }

    // Legacy methods for backward compatibility
    pub async fn go_to_end(&self) -> Result<(), ReaperError> {
        let url = format!("{}/_/{}", self.base_url, "40043");
        let response = self.client.get(&url).send().await?;
        if response.status().is_success() {
            Ok(())
        } else {
            Err(ReaperError::Command(format!(
                "Command 'go_to_end' failed with status: {}",
                response.status()
            )))
        }
    }

    pub async fn go_to_start(&self) -> Result<(), ReaperError> {
        let url = format!("{}/_/{}", self.base_url, "40042");
        let response = self.client.get(&url).send().await?;
        if response.status().is_success() {
            Ok(())
        } else {
            Err(ReaperError::Command(format!(
                "Command 'go_to_start' failed with status: {}",
                response.status()
            )))
        }
    }

    pub async fn get_duration(&self) -> Result<Duration, ReaperError> {
        // go to the end of the project to get the duration
        self.go_to_end().await?;
        let url = format!("{}/_/{}", self.base_url, "TRANSPORT");
        let response = self.client.get(&url).send().await?;

        if !response.status().is_success() {
            return Err(ReaperError::Command(format!(
                "Command 'get_transport' failed with status: {}",
                response.status()
            )));
        }

        let transport_string = response.text().await?;
        let parts: Vec<&str> = transport_string.split('\t').collect();
        if parts.len() > 2 {
            parts[2]
                .parse::<f64>()
                .map(Duration::from_secs_f64)
                .map_err(|e| {
                    ReaperError::Parse(format!("Failed to parse transport seconds: {}", e))
                })
        } else {
            Err(ReaperError::Parse(
                "Transport string format unexpected".to_string(),
            ))
        }
    }

    pub async fn new_tab(&self) -> Result<(), ReaperError> {
        let url = format!("{}/_/{}", self.base_url, "40859");
        let response = self.client.get(&url).send().await?;
        if response.status().is_success() {
            Ok(())
        } else {
            Err(ReaperError::Command(format!(
                "Command 'new_tab' failed with status: {}",
                response.status()
            )))
        }
    }

    // Legacy load_project method (kept for compatibility with old code)
    pub async fn load_project(&self, name: &str) -> Result<(), ReaperError> {
        let command_str = format!("OSC/loadproject:s{}", name);
        let url = format!("{}/_/{}", self.base_url, command_str);
        let response = self.client.get(&url).send().await?;

        if response.status().is_success() {
            Ok(())
        } else {
            Err(ReaperError::Command(format!(
                "Command '{}' failed with status: {}",
                command_str,
                response.status()
            )))
        }
    }
}
