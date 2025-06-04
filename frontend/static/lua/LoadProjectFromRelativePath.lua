-- LoadProjectFromRelativePath.lua
-- This script loads a Reaper project file.
-- It expects the 'project_root_folder' to be set in ExtState.
-- It expects the relative project path to be provided via a temporary ExtState key.

local section = "WebAppControl"
local root_key = "project_root_folder"
local temp_project_path_key = "temp_load_project_path"

local project_root_folder = reaper.GetExtState(section, root_key)
local relative_project_path = reaper.GetExtState(section, temp_project_path_key)

if not project_root_folder or project_root_folder == "" then
    reaper.ShowConsoleMsg("Error: Project root folder not set. Please configure it first.\n")
    return
end

if not relative_project_path or relative_project_path == "" then
    reaper.ShowConsoleMsg("Error: No project path provided for loading.\n")
    return
end

local full_project_path = project_root_folder .. "/" .. relative_project_path
-- Ensure forward slashes for Reaper's API regardless of OS
full_project_path = full_project_path:gsub("\\", "/")

reaper.ShowConsoleMsg("Attempting to load project: " .. full_project_path .. "\n")

-- Optional: Confirmation dialog in Reaper
local confirm_load = reaper.MB("Load project:\n" .. full_project_path .. "?", "Confirm Load", 4) -- 4 = MB_YESNO

if confirm_load == 6 then -- 6 = IDYES
    -- You might want to save current project first if it's dirty, or prompt the user.
    -- For automation, often you'd just proceed or explicitly save.
    local project_loaded = reaper.LoadProjectSet(full_project_path)
    if project_loaded then
        reaper.ShowConsoleMsg("Project loaded successfully.\n")
    else
        reaper.ShowConsoleMsg("Failed to load project: " .. full_project_path .. ". File might not exist or is corrupt.\n")
    end
else
    reaper.ShowConsoleMsg("Project load cancelled by user.\n")
end

reaper.DeleteExtState(section, temp_project_path_key) -- Clean up the temporary key