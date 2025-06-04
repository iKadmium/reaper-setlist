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

-- You might want to save current project first if it's dirty, or prompt the user.
-- For automation, often you'd just proceed or explicitly save.
reaper.Main_openProject(full_project_path)

reaper.DeleteExtState(section, temp_project_path_key, true) -- Clean up the temporary key