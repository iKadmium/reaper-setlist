-- LoadProjectFromRelativePath.lua
-- This script loads a Reaper project file.
-- It expects the 'project_root_folder' to be set in ExtState.
-- It expects the relative project path to be provided via a temporary ExtState key.
-- For testing purposes, set 'dummy_mode' to 'true' to simulate loading without opening real files.

local section = "WebAppControl"
local root_key = "project_root_folder"
local temp_project_path_key = "temp_load_project_path"
local dummy_mode_key = "dummy_mode"
local nonce_in_key = "test_nonce_in"
local nonce_out_key = "test_nonce_out"

-- Nonce handling
local nonce_in_value = reaper.GetExtState(section, nonce_in_key)
if nonce_in_value and nonce_in_value ~= "" then
    reaper.SetExtState(section, nonce_out_key, nonce_in_value .. "_modified", true)
end

local project_root_folder = reaper.GetExtState(section, root_key)
local relative_project_path = reaper.GetExtState(section, temp_project_path_key)
local dummy_mode = reaper.GetExtState(section, dummy_mode_key)

-- Check if we're in dummy mode
local is_dummy_mode = dummy_mode == "true"

if not project_root_folder or project_root_folder == "" then
    if is_dummy_mode then
        -- In dummy mode, use test folder silently
        project_root_folder = "/dummy/test/projects"
    else
        reaper.ShowConsoleMsg("Error: Project root folder not set. Please configure it first.\n")
        return
    end
end

if not relative_project_path or relative_project_path == "" then
    if is_dummy_mode then
        -- In dummy mode, use test project silently
        relative_project_path = "test-song.rpp"
    else
        reaper.ShowConsoleMsg("Error: No project path provided for loading.\n")
        return
    end
end

local full_project_path = project_root_folder .. "/" .. relative_project_path
-- Ensure forward slashes for Reaper's API regardless of OS
full_project_path = full_project_path:gsub("\\", "/")

if is_dummy_mode then
    -- In dummy mode, just store success indicator without console output
    reaper.SetExtState(section, "last_load_result", "dummy_success", true)
else
    -- In real mode, load the project silently
    reaper.Main_openProject(full_project_path)
    
    -- Store success indicator
    reaper.SetExtState(section, "last_load_result", "success", true)
end

reaper.DeleteExtState(section, temp_project_path_key, true) -- Clean up the temporary key