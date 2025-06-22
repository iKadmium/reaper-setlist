local GetRelativePath = require "relative_path"
local NormalizePath = require "normalize_path"

---@param current_dir string
---@param base_path_for_relative string
---@param start_time number
---@param max_runtime_seconds number
---@return string[]
local function ListRppFilesRecursive(current_dir, base_path_for_relative, start_time, max_runtime_seconds)
    ---@type string[]
    local project_files = {}

    -- Check if we've exceeded the maximum runtime
    local current_time = reaper.time_precise()
    if current_time - start_time > max_runtime_seconds then
        error("TIMEOUT: Operation exceeded " .. max_runtime_seconds .. " seconds")
    end

    current_dir = NormalizePath(current_dir)
    base_path_for_relative = NormalizePath(base_path_for_relative)

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
            local subdir_files = ListRppFilesRecursive(full_subdir_path, base_path_for_relative, start_time,
                max_runtime_seconds)

            -- Use ipairs for better performance with arrays
            for _, file in ipairs(subdir_files) do
                table.insert(project_files, file)
            end
        end
        subdir_index = subdir_index + 1
    end

    return project_files
end

return ListRppFilesRecursive
