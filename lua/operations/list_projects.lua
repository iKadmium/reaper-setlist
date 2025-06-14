local Globals = require "globals"
local GetRelativePath = require "relative_path"

-- Maximum runtime in seconds (default: 30 seconds)
local MAX_RUNTIME_SECONDS = 10

---@param path string
---@return string
local function normalize_path(path)
    local normalized = path:gsub("\\", "/")
    return normalized
end

---@param current_dir string
---@param base_path_for_relative string
---@param start_time number
---@return string[]
local function list_rpp_files_recursive(current_dir, base_path_for_relative, start_time)
    ---@type string[]
    local project_files = {}

    -- Check if we've exceeded the maximum runtime
    local current_time = reaper.time_precise()
    if current_time - start_time > MAX_RUNTIME_SECONDS then
        error("TIMEOUT: Operation exceeded " .. MAX_RUNTIME_SECONDS .. " seconds")
    end

    current_dir = normalize_path(current_dir)
    base_path_for_relative = normalize_path(base_path_for_relative)

    -- Step 1: Enumerate files in the current directory
    local file_index = 0
    while true do
        local filename = reaper.EnumerateFiles(current_dir, file_index)
        if not filename then
            break
        end

        -- Check if it's an .rpp file (case-insensitive)
        if filename:lower():match("%.rpp$") then
            local full_path = current_dir .. "/" .. filename
            local relative_path = GetRelativePath(full_path, base_path_for_relative)
            table.insert(project_files, relative_path)
        end
        file_index = file_index + 1
    end

    -- Step 2: Enumerate subdirectories and recurse
    local subdir_index = 0
    while true do
        local dirname = reaper.EnumerateSubdirectories(current_dir, subdir_index)
        if not dirname then
            break
        end

        -- Skip special directories and hidden directories
        if dirname ~= "." and dirname ~= ".." and not dirname:match("^%.") then
            local full_subdir_path = current_dir .. "/" .. dirname
            local subdir_files = list_rpp_files_recursive(full_subdir_path, base_path_for_relative, start_time)

            -- Use ipairs for better performance with arrays
            for _, file in ipairs(subdir_files) do
                table.insert(project_files, file)
            end
        end
        subdir_index = subdir_index + 1
    end

    return project_files
end

---Returns a list of .rpp files in the project root folder and its subfolders
---@return string[]
local function ListProjects()
    local project_root_folder = reaper.GetExtState(Globals.SECTION, Globals.KEYS.project_root_folder)
    if not project_root_folder or project_root_folder == "" then
        error("Project root folder is not set. Cannot list files.")
    end

    project_root_folder = normalize_path(project_root_folder)
    project_root_folder = project_root_folder:gsub("/$", "")

    -- Record start time for timeout checking
    local start_time = reaper.time_precise()

    -- Use pcall to catch timeout errors
    local success, result = pcall(function()
        return list_rpp_files_recursive(project_root_folder, project_root_folder, start_time)
    end)

    if not success then
        -- Check if it's a timeout error
        if result:match("^TIMEOUT:") then
            reaper.ShowMessageBox(
                "Operation timed out after " .. MAX_RUNTIME_SECONDS .. " seconds. Consider reducing the search scope.",
                "List Projects Timeout", 0)
            return {} -- Return empty list on timeout
        else
            -- Re-throw other errors
            error(result)
        end
    end

    local project_files = result

    table.sort(project_files, function(a, b)
        return a:lower() < b:lower()
    end)

    return project_files
end

return ListProjects
