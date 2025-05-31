use std::time::Duration;

use crate::models::settings::Settings;
use reqwest::Error as ReqwestError;

#[derive(Debug)]
pub enum ReaperError {
    Http(ReqwestError),
    Command(String),
    Parse(String),
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
    LoadProjectByName(String), // Added new variant
}

impl ReaperCommand {
    // Renamed from as_str and changed return type to String to handle formatted strings
    fn to_command_string(&self) -> String {
        match self {
            ReaperCommand::GoToEnd => "40043".to_string(),
            ReaperCommand::GoToStart => "40042".to_string(),
            ReaperCommand::GetTransport => "TRANSPORT".to_string(),
            ReaperCommand::NewTab => "40859".to_string(),
            ReaperCommand::LoadProjectByName(name) => format!("OSC/loadproject:s{}", name),
        }
    }
}

pub struct ReaperClient {
    base_url: String,
    client: reqwest::Client,
}

impl ReaperClient {
    pub async fn new(settings: &Settings) -> Result<Self, ReaperError> {
        // In a real application, you would load settings from a config file or environment variables
        // For now, we'll use a placeholder. You'll need to integrate your Settings model here.
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

    // Updated to take ReaperCommand directly
    async fn run_command(&self, command: &ReaperCommand) -> Result<String, ReaperError> {
        let command_str = command.to_command_string();
        let url = format!("{}/_/{}", self.base_url, command_str);
        let response = self.client.get(&url).send().await?;

        if response.status().is_success() {
            Ok(response.text().await?)
        } else {
            Err(ReaperError::Command(format!(
                "Command '{}' failed with status: {}",
                command_str, // Use the string representation for the error message
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
        // go to the end of the project to get the duration
        self.go_to_end().await?;
        let transport_string = self.run_command(&ReaperCommand::GetTransport).await?;
        let parts: Vec<&str> = transport_string.split('\t').collect();
        if parts.len() > 2 {
            parts[2]
                .parse::<f64>()
                .map(|seconds| Duration::from_secs_f64(seconds))
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

    pub async fn load_project(&self, name: &str) -> Result<(), ReaperError> {
        self.run_command(&ReaperCommand::LoadProjectByName(name.to_string()))
            .await?;
        Ok(())
    }

    // This function is synchronous in TypeScript, but to fit the async model of ReaperClient and Settings loading,
    // it might be better as async if folder_path also comes from async Settings.
    // For now, keeping it synchronous as per the TS example, assuming folder_path is readily available.
    pub fn get_script(folder_path: &str) -> String {
        let escaped_folder_path = folder_path
            .replace('\\', "\\\\") // Escape backslashes
            .replace("'", "\\'") // Escape single quotes
            .replace("\"", "\\\""); // Escape double quotes

        format!(
            r#"local is_new_value,filename,sectionID,cmdID,mode,resolution,val,contextstr = reaper.get_action_context()
if contextstr == "" then
  reaper.ShowConsoleMsg("No project"..val.."\n")
else
  local project_name = string.gmatch(contextstr,"[^:]+:[^:]+:s=(.*)")()
  local path = "{}/" .. project_name .. "/" .. project_name .. ".rpp"
  if project_name ~= nil then
    local x = "noprompt:" .. path
    reaper.Main_openProject(x)
  end
end"#,
            escaped_folder_path
        )
    }
}
