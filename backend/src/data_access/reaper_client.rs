use std::time::Duration;
use tracing::{Span, instrument};
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

#[derive(Debug)]
pub enum ReaperCommand {
    GoToEnd,
    GoToStart,
    GetTransport,
    NewTab,
    RunAction(String), // Action ID for custom scripts (changed from u32 to String)
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

    #[instrument(skip(self))]
    async fn run_command(&self, command: &ReaperCommand) -> Result<String, ReaperError> {
        let command_str = command.to_command_string();
        let url = if matches!(command, ReaperCommand::RunAction(_)) {
            format!("{}/_/{}", self.base_url, command_str)
        } else {
            format!("{}/_/{}", self.base_url, command_str)
        };

        let response = self.client.get(&url).send().await?;

        if response.status().is_success() {
            tracing::info!("Command '{}' executed successfully", command_str);
            Ok(response.text().await?)
        } else {
            tracing::error!(
                "Command '{}' failed with status: {}",
                command_str,
                response.status()
            );
            Err(ReaperError::Command(format!(
                "Command '{}' failed with status: {}",
                command_str,
                response.status()
            )))
        }
    }

    #[instrument(skip(self))]
    async fn set_ext_state(
        &self,
        section: &str,
        key: &str,
        value: &str,
    ) -> Result<(), ReaperError> {
        let url = Url::parse(&format!(
            "{}/_/SET/EXTSTATE/{}/{}/{}",
            self.base_url, section, key, value
        ))
        .map_err(|e| ReaperError::Command(format!("Invalid base URL: {}", e)))?;

        let response = self.client.get(url).send().await?;

        if response.status().is_success() {
            tracing::info!("Successfully set ExtState ");
            Ok(())
        } else {
            tracing::error!("Failed to set ExtState: {}", response.status());
            Err(ReaperError::Command(format!(
                "Failed to set ExtState: {}",
                response.status()
            )))
        }
    }

    #[instrument(skip(self), fields(url))]
    async fn get_ext_state(&self, section: &str, key: &str) -> Result<String, ReaperError> {
        let url = Url::parse(&format!(
            "{}/_/GET/EXTSTATE/{}/{}",
            self.base_url, section, key
        ))
        .map_err(|e| ReaperError::Command(format!("Invalid base URL: {}", e)))?;

        Span::current().record("url", &url.to_string());
        let response = self.client.get(url).send().await?;

        if response.status().is_success() {
            tracing::trace!("Successfully retrieved ExtState");
            Ok(response.text().await?)
        } else {
            tracing::error!("Failed to retrieve ExtState: {}", response.status());
            Err(ReaperError::Command(format!(
                "Failed to get ExtState: {}",
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

    #[instrument(skip(self, settings))]
    pub async fn set_project_root(
        &self,
        folder_path: &str,
        settings: &Settings,
    ) -> Result<(), ReaperError> {
        let action_id = settings.set_root_script_action_id.clone().ok_or_else(|| {
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
    #[instrument(skip(self, settings))]
    pub async fn list_projects(&self, settings: &Settings) -> Result<Vec<String>, ReaperError> {
        let action_id = settings
            .list_projects_script_action_id
            .clone()
            .ok_or_else(|| {
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
        let action_id = settings
            .clone()
            .load_project_script_action_id
            .ok_or_else(|| {
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
}
