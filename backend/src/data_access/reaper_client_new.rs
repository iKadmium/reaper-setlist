use std::time::Duration;
use url::Url;

use crate::models::settings::Settings;
use reqwest::Error as ReqwestError;

#[derive(Debug)]
pub enum ReaperError {
    Http(ReqwestError),
    Command(String),
    Parse(String),
    Config(String),
}

impl From<ReqwestError> for ReaperError {
    fn from(err: ReqwestError) -> ReaperError {
        ReaperError::Http(err)
    }
}

pub enum ReaperCommand {
    GoToEnd,
    GoToStart,
    GetTransport,
    NewTab,
    RunAction(u32), // Action ID for custom scripts
}

impl ReaperCommand {
    fn to_command_string(&self) -> String {
        match self {
            ReaperCommand::GoToEnd => "40043".to_string(),
            ReaperCommand::GoToStart => "40042".to_string(),
            ReaperCommand::GetTransport => "TRANSPORT".to_string(),
            ReaperCommand::NewTab => "40859".to_string(),
            ReaperCommand::RunAction(action_id) => action_id.to_string(),
        }
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

    async fn run_command(&self, command: &ReaperCommand) -> Result<String, ReaperError> {
        let command_str = command.to_command_string();
        let url = if matches!(command, ReaperCommand::RunAction(_)) {
            format!("{}/_run?_action={}", self.base_url, command_str)
        } else {
            format!("{}/_/{}", self.base_url, command_str)
        };

        let response = self.client.get(&url).send().await?;

        if response.status().is_success() {
            Ok(response.text().await?)
        } else {
            Err(ReaperError::Command(format!(
                "Command '{}' failed with status: {}",
                command_str,
                response.status()
            )))
        }
    }

    async fn set_ext_state(
        &self,
        section: &str,
        key: &str,
        value: &str,
    ) -> Result<(), ReaperError> {
        let mut url = Url::parse(&format!("{}/_extstate", self.base_url))
            .map_err(|e| ReaperError::Command(format!("Invalid base URL: {}", e)))?;

        {
            let mut query_pairs = url.query_pairs_mut();
            query_pairs.append_pair("section", section);
            query_pairs.append_pair("key", key);
            query_pairs.append_pair("value", value);
        }

        let response = self.client.get(url).send().await?;

        if response.status().is_success() {
            Ok(())
        } else {
            Err(ReaperError::Command(format!(
                "Failed to set ExtState {}/{}: {}",
                section,
                key,
                response.status()
            )))
        }
    }

    async fn get_ext_state(&self, section: &str, key: &str) -> Result<String, ReaperError> {
        let mut url = Url::parse(&format!("{}/_extstate", self.base_url))
            .map_err(|e| ReaperError::Command(format!("Invalid base URL: {}", e)))?;

        {
            let mut query_pairs = url.query_pairs_mut();
            query_pairs.append_pair("section", section);
            query_pairs.append_pair("key", key);
        }

        let response = self.client.get(url).send().await?;

        if response.status().is_success() {
            Ok(response.text().await?)
        } else {
            Err(ReaperError::Command(format!(
                "Failed to get ExtState {}/{}: {}",
                section,
                key,
                response.status()
            )))
        }
    }

    pub async fn go_to_end(&self) -> Result<(), ReaperError> {
        self.run_command(&ReaperCommand::GoToEnd).await?;
        Ok(())
    }

    pub async fn go_to_start(&self) -> Result<(), ReaperError> {
        self.run_command(&ReaperCommand::GoToStart).await?;
        Ok(())
    }

    pub async fn get_duration(&self) -> Result<Duration, ReaperError> {
        self.go_to_end().await?;
        let transport_string = self.run_command(&ReaperCommand::GetTransport).await?;
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
        self.run_command(&ReaperCommand::NewTab).await?;
        Ok(())
    }

    /// Set the project root folder by triggering the SetProjectRootFolder script
    pub async fn set_project_root(
        &self,
        folder_path: &str,
        settings: &Settings,
    ) -> Result<(), ReaperError> {
        let action_id = settings.set_root_script_action_id.ok_or_else(|| {
            ReaperError::Config("SetProjectRootFolder script action ID not configured".to_string())
        })?;

        // Set temporary ExtState
        self.set_ext_state("WebAppControl", "temp_set_root_path", folder_path)
            .await?;

        // Trigger script
        self.run_command(&ReaperCommand::RunAction(action_id))
            .await?;

        Ok(())
    }

    /// List project files by triggering the ListProjectFiles script and retrieving the result
    pub async fn list_projects(&self, settings: &Settings) -> Result<Vec<String>, ReaperError> {
        let action_id = settings.list_projects_script_action_id.ok_or_else(|| {
            ReaperError::Config("ListProjectFiles script action ID not configured".to_string())
        })?;

        // Trigger script
        self.run_command(&ReaperCommand::RunAction(action_id))
            .await?;

        // Give Reaper a moment to execute the script
        tokio::time::sleep(Duration::from_millis(1000)).await;

        // Retrieve result from ExtState
        let file_list_str = self
            .get_ext_state("WebAppControl", "project_file_list")
            .await?;

        if file_list_str.starts_with("ERROR") {
            return Err(ReaperError::Command(format!(
                "Reaper script error: {}",
                file_list_str
            )));
        }

        let project_files = if file_list_str.is_empty() {
            Vec::new()
        } else {
            file_list_str.split(',').map(|s| s.to_string()).collect()
        };

        Ok(project_files)
    }

    /// Load a project by relative path using the LoadProjectFromRelativePath script
    pub async fn load_project_by_path(
        &self,
        relative_path: &str,
        settings: &Settings,
    ) -> Result<(), ReaperError> {
        let action_id = settings.load_project_script_action_id.ok_or_else(|| {
            ReaperError::Config(
                "LoadProjectFromRelativePath script action ID not configured".to_string(),
            )
        })?;

        // Set temporary ExtState for project path
        self.set_ext_state("WebAppControl", "temp_load_project_path", relative_path)
            .await?;

        // Trigger script
        self.run_command(&ReaperCommand::RunAction(action_id))
            .await?;

        Ok(())
    }

    /// Legacy method for backward compatibility - loads project by name (now uses relative path)
    pub async fn load_project(&self, name: &str) -> Result<(), ReaperError> {
        // For backward compatibility, we assume the name IS the relative path
        // In the new system, this should ideally be updated to use load_project_by_path
        Err(ReaperError::Command(
            "load_project method is deprecated. Use load_project_by_path with proper relative path.".to_string()
        ))
    }

    // This function is no longer needed since scripts are served from static storage
    pub fn get_script(_folder_path: &str) -> String {
        "// This function is deprecated. Scripts are now served from static storage.".to_string()
    }
}
