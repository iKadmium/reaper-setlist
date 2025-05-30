use serde::{Serialize, de::DeserializeOwned};
use std::io::Result;
use tokio::{fs::File, io::AsyncReadExt};

pub(super) async fn get_json(path: &str) -> Result<String> {
    let mut buffer = String::new();
    let mut result = File::open(path).await?;
    result.read_to_string(&mut buffer).await?;
    Ok(buffer)
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
        tokio::fs::write(Self::FILENAME, contents).await?;
        Ok(())
    }
}
