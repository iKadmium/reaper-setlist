---@diagnostic disable: missing-return

---@class reaper
reaper = reaper or {}

---@param section string
---@param key string
---@return string
function reaper.GetExtState(section, key) end

---@param section string
---@param key string
---@param value string
---@param persist boolean
function reaper.SetExtState(section, key, value, persist) end

---@param section string
---@param key string
---@param persist boolean
function reaper.DeleteExtState(section, key, persist) end

---@param msg string
function reaper.ShowConsoleMsg(msg) end

---@param directory string
---@param index integer
---@return string|nil
function reaper.EnumerateFiles(directory, index) end

---@param directory string
---@param index integer
---@return string|nil
function reaper.EnumerateSubdirectories(directory, index) end

---@param path string
function reaper.Main_openProject(path) end
