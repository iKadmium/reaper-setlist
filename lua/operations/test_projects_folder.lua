local NormalizePath = require "normalize_path"
local ListRppFilesRecursive = require "list_rpp_files"

local MAX_RUNTIME_SECONDS = 10

---@param folderPath string
---@return boolean valid
---@return string message
local function TestProjectsFolder(folderPath)
    local project_root_folder = NormalizePath(folderPath)
    project_root_folder = project_root_folder:gsub("/$", "")

    -- Record start time for timeout checking
    local start_time = reaper.time_precise()

    -- Use pcall to catch timeout errors
    local success, result = pcall(function()
        return ListRppFilesRecursive(project_root_folder, project_root_folder, start_time, MAX_RUNTIME_SECONDS)
    end)

    if not success then
        -- Check if it's a timeout error
        if result:match("^TIMEOUT:") then
            reaper.ShowMessageBox(
                "Operation timed out after " .. MAX_RUNTIME_SECONDS .. " seconds. Consider reducing the search scope.",
                "List Projects Timeout", 0)
            return false, "Operation timed out" -- Return empty list on timeout
        else
            -- Re-throw other errors
            return false, tostring(result)
        end
    end

    local project_files = result

    table.sort(project_files, function(a, b)
        return a:lower() < b:lower()
    end)

    if #project_files == 0 then
        return false, "No project files found in the specified folder."
    end

    return true, "Found " .. #project_files .. " project files in the specified folder."
end

return TestProjectsFolder;
