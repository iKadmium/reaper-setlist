local ListProjectFiles = require "list_project_files"

---@type string
local section = "ReaperSetlist"

local KEYS = {
    operation = "Operation",
    project_path = "ProjectPath",
    project_root_folder = "ProjectRootFolder",
    test_input = "TestInput",
    script_output = "ScriptOutput"
}

local OPERATIONS = {
    open_project = "OpenProject",
    list_projects = "ListProjects",
    test = "TestOperation"
}

---@param func function
---@return function
local function safe_operation(func)
    return function()
        local success, err = pcall(func)
        if not success then
            reaper.ShowConsoleMsg("Error: " .. tostring(err) .. "\n")
        end
    end
end

local operations = {
    [OPERATIONS.open_project] = safe_operation(function()
        local project_path = reaper.GetExtState(section, KEYS.project_path)
        if not project_path or project_path == "" then
            error("No project path specified")
        end

        project_path = project_path:gsub("\\", "/")
        reaper.Main_openProject(project_path)
        reaper.DeleteExtState(section, KEYS.project_path, true)
    end),

    [OPERATIONS.list_projects] = safe_operation(function()
        local project_root_folder = reaper.GetExtState(section, KEYS.project_root_folder)
        if not project_root_folder or project_root_folder == "" then
            error("No project root folder specified")
        end

        project_root_folder = project_root_folder:gsub("\\", "/")
        local project_files = ListProjectFiles(project_root_folder)
        reaper.SetExtState(section, KEYS.script_output, table.concat(project_files, ","), false)
    end),

    [OPERATIONS.test] = safe_operation(function()
        local test_input = reaper.GetExtState(section, KEYS.test_input)
        if not test_input or test_input == "" then
            error("No test input specified")
        end

        local result = "Test input received: " .. test_input
        reaper.SetExtState(section, KEYS.script_output, result, false)
        reaper.DeleteExtState(section, KEYS.test_input, true)
    end),
}

local operation = reaper.GetExtState(section, KEYS.operation)
if not operation or operation == "" then
    reaper.ShowConsoleMsg("No operation specified. Exiting.\n")
    return
end

if operations[operation] then
    operations[operation]()
    reaper.DeleteExtState(section, KEYS.operation, true)
else
    reaper.ShowConsoleMsg("Unknown operation: " .. operation .. "\n")
end
