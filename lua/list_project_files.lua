---returns a list of .rpp files in the project root folder and its subfolders
---@param current_dir string
---@param base_path_for_relative string
---@param project_files string[]
---@return string[]
local function list_rpp_files_recursive(current_dir, base_path_for_relative, project_files)
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
            list_rpp_files_recursive(full_subdir_path, base_path_for_relative, project_files) -- Recurse into subdirectory
        end
        subdir_index = subdir_index + 1
    end

    return project_files
end

---returns a list of .rpp files in the project root folder and its subfolders
---@param project_root_folder string
function ListProjectFiles(project_root_folder)
    -- This function is called to list project files
    -- It will be used in the WebAppControl context

    -- Proceed with actual file listing only if not in dummy mode
    if not project_root_folder or project_root_folder == "" then
        error("Project root folder is not set. Cannot list files.")
    end

    -- Normalize path separators to forward slashes for consistency
    project_root_folder = project_root_folder:gsub("\\", "/")

    local project_files = {}

    -- Call the recursive function starting from the root
    project_files = list_rpp_files_recursive(project_root_folder, project_root_folder, project_files)

    -- Sort the files alphabetically for consistent display
    table.sort(project_files)

    return project_files
end

return ListProjectFiles
