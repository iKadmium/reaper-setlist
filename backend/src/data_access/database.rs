use crate::models::database::Database;
use serde::{Deserialize, Serialize};
use std::{collections::HashMap, io::Result};

use super::json_file::{get_json, save_json};

async fn get_db<T: for<'de> Deserialize<'de>>(file: &str) -> Result<Database<T>> {
    // let exists = try_exists(file).await?;
    // if !exists {
    //     return Ok(Database::new());
    // }
    let result = get_json(file).await;
    match result {
        Ok(contents) => {
            let db: HashMap<String, T> = serde_json::from_str(&contents)?;
            Ok(db)
        }
        Err(e) => {
            if e.kind() == std::io::ErrorKind::NotFound {
                Ok(Database::new())
            } else {
                Err(e)
            }
        }
    }
}

async fn save_db<T: Serialize>(file: &str, db: &Database<T>) -> Result<()> {
    let contents = serde_json::to_string(db)?;
    save_json(file, contents.as_str()).await?;
    Ok(())
}

pub(crate) trait StoredInDb: Serialize + Sized + Clone
where
    for<'de> Self: Deserialize<'de>,
{
    const FILENAME: &str;

    fn id(&self) -> String;

    async fn get_by_id(id: &str) -> Result<Self> {
        let db = get_db::<Self>(Self::FILENAME).await?;
        match db.get(id) {
            Some(item) => Ok(item.clone()),
            None => Err(std::io::Error::new(
                std::io::ErrorKind::NotFound,
                format!("Item with id {} not found", id),
            )),
        }
    }

    async fn get_all() -> Result<Database<Self>> {
        get_db(Self::FILENAME).await
    }

    async fn save(&self) -> Result<()> {
        let mut db = get_db::<Self>(Self::FILENAME).await?;
        db.insert(self.id(), self.clone());
        save_db(Self::FILENAME, &db).await
    }

    async fn delete(&self) -> Result<()> {
        let mut db = get_db::<Self>(Self::FILENAME).await?;
        db.remove(&self.id());
        save_db(Self::FILENAME, &db).await
    }
}
