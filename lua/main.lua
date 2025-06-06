local section = "ReaperSetlist"
local operation_key = "Operation"

local project_path_key = "ProjectPath"
local project_root_folder_key = "ProjectRootFolder"
local list_projects_output_key = "ListProjectsOutput"

local ListProjectFiles = require("list_project_files")

local operation = reaper.GetExtState(section, operation_key)
if not operation or operation == "" then
    reaper.ShowConsoleMsg("No operation specified. Exiting.\n")
    return
end

local operations = {
    ["OpenProject"] = function()
        local project_path = reaper.GetExtState(section, project_path_key)
        if not project_path or project_path == "" then
            reaper.ShowConsoleMsg("No project path specified. Exiting.\n")
            return
        end

        -- Normalize path separators to forward slashes for consistency
        project_path = project_path:gsub("\\", "/")

        -- Open the specified project
        reaper.Main_openProject(project_path)
        reaper.DeleteExtState(section, project_path_key, true)
    end,

    ["ListProjects"] = function()
        local project_root_folder = reaper.GetExtState(section, project_root_folder_key)
        if not project_root_folder or project_root_folder == "" then
            reaper.ShowConsoleMsg("No project root folder specified. Exiting.\n")
            return
        end

        -- Normalize path separators to forward slashes for consistency
        project_root_folder = project_root_folder:gsub("\\", "/")

        local project_files = ListProjectFiles(project_root_folder)

        reaper.SetExtState(section, list_projects_output_key, table.concat(project_files, ","), false)
    end,
}

if operations[operation] then
    operations[operation]()
    reaper.DeleteExtState(section, operation_key, true)
else
    reaper.ShowConsoleMsg("Unknown operation: " .. operation .. "\n")
end
