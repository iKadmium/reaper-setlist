-- ListProjectFiles.lua
-- This script lists .rpp files in the defined project root folder (and subfolders).
-- It uses reaper.EnumerateFiles for robust, cross-platform file listing.
-- It stores the list as a comma-separated string in ExtState (relative paths).

local section = "WebAppControl"
local root_key = "project_root_folder"
local list_output_key = "project_file_list"

local project_root_folder = reaper.GetExtState(section, root_key)

if not project_root_folder or project_root_folder == "" then
    reaper.ShowConsoleMsg("Error: Project root folder not set. Cannot list files.\n")
    reaper.SetExtState(section, list_output_key, "ERROR: Project root folder not set.", true)
    return
end

-- Normalize path separators to forward slashes for consistency
project_root_folder = project_root_folder:gsub("\\", "/")

reaper.ShowConsoleMsg("Listing project files in: " .. project_root_folder .. " (using reaper.EnumerateFiles)\n")

local project_files = {}

-- Recursive function to list .rpp files
local function list_rpp_files_recursive(current_dir, base_path_for_relative)
    local file_index = 0
    while true do
        local filename, is_directory = reaper.EnumerateFiles(current_dir, file_index)
        if not filename then -- End of enumeration
            break
        end

        local full_path = current_dir .. "/" .. filename
        local relative_path = full_path:gsub(base_path_for_relative .. "/", "")

        if is_directory then
            -- Avoid infinite recursion or re-entering parent directory
            if filename ~= "." and filename ~= ".." then
                list_rpp_files_recursive(full_path, base_path_for_relative) -- Recurse into subdirectory
            end
        else
            -- It's a file, check if it's an .rpp file
            if filename:lower():match("%.rpp$") then
                table.insert(project_files, relative_path)
            end
        end
        file_index = file_index + 1
    end
end

-- Call the recursive function starting from the root
list_rpp_files_recursive(project_root_folder, project_root_folder)

-- Sort the files alphabetically for consistent display
table.sort(project_files)

local files_str = table.concat(project_files, ",")
reaper.SetExtState(section, list_output_key, files_str, true)
reaper.ShowConsoleMsg("Listed " .. #project_files .. " project files.\n")
reaper.ShowConsoleMsg("Output stored in ExtState: " .. section .. ":" .. list_output_key .. "\n")