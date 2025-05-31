use serde::{Serialize, de::DeserializeOwned};
use std::{io::Result, path::PathBuf};
use tokio::{fs::File, io::AsyncReadExt};

const ROOT_DIR: &str = "data";

pub(super) async fn get_json(filename: &str) -> Result<String> {
    let path = PathBuf::from(ROOT_DIR).join(filename);
    let mut buffer = String::new();
    let mut result = File::open(&path).await?;
    result.read_to_string(&mut buffer).await?;
    Ok(buffer)
}

pub(super) async fn save_json(filename: &str, contents: &str) -> Result<()> {
    let path = PathBuf::from(ROOT_DIR).join(filename);
    // Ensure the data directory exists
    if let Some(parent) = path.parent() {
        tokio::fs::create_dir_all(parent).await?;
    }
    tokio::fs::write(path, contents).await?;
    Ok(())
}

pub trait StoredInJsonFile: Sized + Clone + DeserializeOwned + Serialize {
    const FILENAME: &'static str;

    async fn load() -> Result<Self> {
        let contents = get_json(Self::FILENAME).await?;
        let item: Self = serde_json::from_str(&contents)?;
        Ok(item)
    }

    async fn save(&self) -> Result<()> {
        let contents = serde_json::to_string(self)?;
        save_json(Self::FILENAME, contents.as_str()).await?;
        Ok(())
    }
}
