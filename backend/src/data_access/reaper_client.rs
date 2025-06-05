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
    NonceMismatch, // Added NonceMismatch variant
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
    CloseAllTabs,
    RunAction(String), // Action ID for custom scripts (changed from u32 to String)
}

impl ReaperCommand {
    fn to_command_string(&self) -> String {
        match self {
            ReaperCommand::GoToEnd => "40043".to_string(),
            ReaperCommand::GoToStart => "40042".to_string(),
            ReaperCommand::GetTransport => "TRANSPORT".to_string(),
            ReaperCommand::NewTab => "40859".to_string(),
            ReaperCommand::CloseAllTabs => "40860".to_string(),
            ReaperCommand::RunAction(action_id) => action_id.to_string(),
        }
    }
}

pub struct ReaperClient<'a> {
    settings: &'a Settings,
    client: reqwest::Client,
}

impl<'a> ReaperClient<'a> {
    pub fn new(settings: &'a Settings) -> Self {
        Self {
            settings,
            client: reqwest::Client::new(),
        }
    }

    /// Helper function to create an authenticated GET request
    fn authenticated_get(&self, url: &str) -> reqwest::RequestBuilder {
        let mut request = self.client.get(url);

        // Add basic auth if credentials are provided
        if let (Some(username), Some(password)) = (
            &self.settings.reaper_username,
            &self.settings.reaper_password,
        ) {
            request = request.basic_auth(username, Some(password));
        }

        request
    }

    /// Simple connectivity test that returns the raw HTTP status code
    #[instrument(skip(self))]
    pub async fn test_connectivity(&self) -> Result<u16, ReaperError> {
        let url = format!("{}/_/TRANSPORT", self.settings.reaper_url);
        let response = self.authenticated_get(&url).send().await?;
        Ok(response.status().as_u16())
    }

    #[instrument(skip(self))]
    async fn run_command(&self, command: &ReaperCommand) -> Result<String, ReaperError> {
        let command_str = command.to_command_string();
        let url = format!("{}/_/{}", self.settings.reaper_url, command_str);

        let response = self.authenticated_get(&url).send().await?;

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
    pub async fn set_ext_state(
        // Changed to pub
        &self,
        section: &str,
        key: &str,
        value: &str,
    ) -> Result<(), ReaperError> {
        let url = Url::parse(&format!(
            "{}/_/SET/EXTSTATE/{}/{}/{}",
            self.settings.reaper_url, section, key, value
        ))
        .map_err(|e| ReaperError::Command(format!("Invalid base URL: {}", e)))?;

        let response = self.authenticated_get(url.as_str()).send().await?;

        if response.status().is_success() {
            tracing::info!(
                "Successfully set ExtState {}/{} to '{}'",
                section,
                key,
                value
            );
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
    pub async fn get_ext_state(
        &self,
        section: &str,
        key: &str,
    ) -> Result<Option<String>, ReaperError> {
        // Changed to pub and Option<String>
        let url = Url::parse(&format!(
            "{}/_/GET/EXTSTATE/{}/{}",
            self.settings.reaper_url, section, key
        ))
        .map_err(|e| ReaperError::Command(format!("Invalid base URL: {}", e)))?;

        Span::current().record("url", url.to_string());

        let response = self.authenticated_get(url.as_str()).send().await?;

        if response.status().is_success() {
            let text = response.text().await?;
            // Reaper's GET/EXTSTATE response format:
            // - "EXTSTATE\tsection\tkey\tvalue\n" if the key has a non-empty value.
            // - "VALUE\n" if the key exists but its value is empty, or if the key does not exist.
            // - An empty response body might also occur in some edge cases for non-existent keys.

            let parts = text
                .split('\n')
                .next()
                .unwrap_or("")
                .split('\t')
                .collect::<Vec<&str>>();

            if parts.len() == 4 && parts[0] == "EXTSTATE" {
                // Valid response with section, key, and value
                if parts[1] == section && parts[2] == key {
                    tracing::info!("Retrieved ExtState {}/{}: '{}'", section, key, parts[3]);
                    Ok(Some(parts[3].to_string()))
                } else {
                    tracing::warn!(
                        "Unexpected ExtState response: section={}, key={}",
                        parts[1],
                        parts[2]
                    );
                    Ok(None)
                }
            } else if parts.len() == 2 && parts[0] == "VALUE" {
                // Key exists but has no value
                tracing::info!("ExtState {}/{} exists but is empty", section, key);
                Ok(Some("".to_string()))
            } else {
                tracing::warn!("Unexpected ExtState response format: {}", text);
                Ok(None)
            }
        } else {
            tracing::error!(
                "Failed to retrieve ExtState {}/{}: {}",
                section,
                key,
                response.status()
            );
            Err(ReaperError::Command(format!(
                "Failed to get ExtState {}/{}: {}",
                section,
                key,
                response.status()
            )))
        }
    }

    /// Clears an ExtState value by setting it to an empty string.
    #[instrument(skip(self))]
    pub async fn clear_ext_state(&self, section: &str, key: &str) -> Result<(), ReaperError> {
        self.set_ext_state(section, key, "").await
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

    pub async fn close_all_tabs(&self) -> Result<(), ReaperError> {
        self.run_command(&ReaperCommand::CloseAllTabs).await?;
        Ok(())
    }

    #[instrument(skip(self))]
    pub async fn set_project_root(&self, folder_path: &str) -> Result<(), ReaperError> {
        // Set temporary ExtState
        self.set_ext_state("WebAppControl", "project_root_folder", folder_path)
            .await?;

        Ok(())
    }

    /// List project files by triggering the ListProjectFiles script and retrieving the result
    #[instrument(skip(self))]
    pub async fn list_projects(&self) -> Result<Vec<String>, ReaperError> {
        let action_id = self
            .settings
            .list_projects_script_action_id
            .clone()
            .ok_or_else(|| {
                ReaperError::Config("ListProjectFiles script action ID not configured".to_string())
            })?;

        // Trigger script
        self.run_command(&ReaperCommand::RunAction(action_id))
            .await?;

        // Retrieve result from ExtState
        let file_list_str = self
            .get_ext_state("WebAppControl", "project_file_list")
            .await?
            .unwrap_or("ERROR".to_string());

        if file_list_str.starts_with("ERROR") {
            return Err(ReaperError::Command(format!(
                "Reaper script error: {}",
                "No file list returned".to_string()
            )));
        }

        let project_files = if file_list_str.is_empty() {
            Vec::new()
        } else {
            let root_path_str = self.settings.folder_path.replace('\\', "/");
            let root_path = std::path::Path::new(&root_path_str);
            file_list_str
                .split(',')
                .map(|s| {
                    let file_path = std::path::Path::new(s.trim());
                    if file_path.starts_with(root_path) {
                        file_path.strip_prefix(root_path).unwrap_or(file_path)
                    } else {
                        file_path
                    }
                })
                .map(|p| p.to_str().unwrap_or_default().to_string())
                .collect()
        };

        Ok(project_files)
    }

    /// Load a project by relative path using the LoadProjectFromRelativePath script
    pub async fn load_project_by_path(&self, relative_path: &str) -> Result<(), ReaperError> {
        let action_id = self
            .settings
            .clone()
            .load_project_script_action_id
            .ok_or_else(|| {
                ReaperError::Config(
                    "LoadProjectFromRelativePath script action ID not configured".to_string(),
                )
            })?;

        self.set_ext_state(
            "WebAppControl",
            "project_root_folder",
            &self.settings.folder_path,
        )
        .await?;

        // Set temporary ExtState for project path
        self.set_ext_state("WebAppControl", "temp_load_project_path", relative_path)
            .await?;

        // Trigger script
        self.run_command(&ReaperCommand::RunAction(action_id))
            .await?;

        Ok(())
    }

    /// Enable dummy mode for testing (scripts will simulate actions without actually performing them)
    pub async fn enable_dummy_mode(&self) -> Result<(), ReaperError> {
        self.set_ext_state("WebAppControl", "dummy_mode", "true")
            .await?;
        Ok(())
    }

    /// Disable dummy mode (scripts will perform real actions)
    pub async fn disable_dummy_mode(&self) -> Result<(), ReaperError> {
        self.set_ext_state("WebAppControl", "dummy_mode", "false")
            .await?;
        Ok(())
    }

    /// Check if the last load operation was successful
    pub async fn get_last_load_result(&self) -> Result<Option<String>, ReaperError> {
        // Ensure this returns Option<String>
        self.get_ext_state("WebAppControl", "last_load_result")
            .await
    }
}
