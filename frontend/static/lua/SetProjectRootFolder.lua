-- SetProjectRootFolder.lua
-- This script sets the 'project_root_folder' in ExtState.
-- Expected usage: Trigger this script via HTTP API with a path provided through a temporary ExtState key.

local section = "WebAppControl" -- A unique section for your web app's settings
local key = "project_root_folder"

local temp_key = "temp_set_root_path"
local path_to_set = reaper.GetExtState(section, temp_key)

if path_to_set and path_to_set ~= "" then
    -- Normalize path separators to forward slashes for consistency, regardless of OS
    path_to_set = path_to_set:gsub("\\", "/")
    reaper.SetExtState(section, key, path_to_set, true) -- Store persistently (last 'true')
    reaper.ShowConsoleMsg("Project root folder set to: " .. path_to_set .. "\n")
    reaper.DeleteExtState(section, temp_key) -- Clean up the temporary key
else
    reaper.ShowConsoleMsg("Error: No path provided to SetProjectRootFolder script.\n")
end