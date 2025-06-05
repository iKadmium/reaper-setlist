-- ListProjectFiles.lua
-- This script lists .rpp files in the defined project root folder (and subfolders).
-- It explicitly uses reaper.EnumerateFiles for files and reaper.EnumerateSubdirectories for directories.
-- It stores the list as a comma-separated string in ExtState (relative paths).
-- For testing purposes, set 'dummy_mode' to 'true' to simulate listing without real file operations
-- and to test nonce verification.

local section = "WebAppControl"
local root_key = "project_root_folder"
local list_output_key = "project_file_list"
local dummy_mode_key = "dummy_mode"
local nonce_in_key = "test_nonce_in"
local nonce_out_key = "test_nonce_out"

local project_root_folder = reaper.GetExtState(section, root_key)
local dummy_mode = reaper.GetExtState(section, dummy_mode_key)
local nonce_in_value = reaper.GetExtState(section, nonce_in_key)

-- Check if we're in dummy mode
local is_dummy_mode = dummy_mode == "true"

-- Nonce handling: If a nonce_in is provided, prepare to set nonce_out
if nonce_in_value and nonce_in_value ~= "" then
    reaper.SetExtState(section, nonce_out_key, nonce_in_value .. "_modified", true)
    -- Clean up nonce_in immediately after reading
    reaper.DeleteExtState(section, nonce_in_key, true)
end

if is_dummy_mode then
    -- In dummy mode, simulate file listing by setting a predefined or empty list
    reaper.SetExtState(section, list_output_key, "dummy_project1.rpp,dummy_folder/dummy_project2.rpp", true)
    -- No further file operations needed in dummy mode
    return
end

-- Proceed with actual file listing only if not in dummy mode
if not project_root_folder or project_root_folder == "" then
    reaper.ShowConsoleMsg("Error: Project root folder not set. Cannot list files.\n")
    reaper.SetExtState(section, list_output_key, "ERROR: Project root folder not set.", true)
    return
end

-- Normalize path separators to forward slashes for consistency
project_root_folder = project_root_folder:gsub("\\", "/")

local project_files = {}

-- Recursive function to list .rpp files and traverse subdirectories
local function list_rpp_files_recursive(current_dir, base_path_for_relative)
    -- Step 1: Enumerate files in the current directory
    local file_index = 0
    while true do
        local filename = reaper.EnumerateFiles(current_dir, file_index)
        if not filename then -- End of file enumeration
            break
        end

        -- Check if it's an .rpp file
        if filename:lower():match("%.rpp$") then
            local full_path = current_dir .. "/" .. filename
            local relative_path = full_path:gsub(base_path_for_relative .. "/", "")
            table.insert(project_files, relative_path)
        end
        file_index = file_index + 1
    end

    -- Step 2: Enumerate subdirectories in the current directory and recurse
    local subdir_index = 0
    while true do
        local dirname = reaper.EnumerateSubdirectories(current_dir, subdir_index)
        if not dirname then -- End of subdirectory enumeration
            break
        end

        -- Avoid special directory entries like "." and ".."
        if dirname ~= "." and dirname ~= ".." then
            local full_subdir_path = current_dir .. "/" .. dirname
            list_rpp_files_recursive(full_subdir_path, base_path_for_relative) -- Recurse into subdirectory
        end
        subdir_index = subdir_index + 1
    end
end

-- Call the recursive function starting from the root
list_rpp_files_recursive(project_root_folder, project_root_folder)

-- Sort the files alphabetically for consistent display
table.sort(project_files)

local files_str = table.concat(project_files, ",")
reaper.SetExtState(section, list_output_key, files_str, true)
