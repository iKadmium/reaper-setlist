local Globals = require "globals"

---comment Open a Reaper project from a specified path, relative to the project root.
---@param project_path string
local function OpenProject(project_path)
    if not project_path or project_path == "" then
        reaper.ShowConsoleMsg("No project path specified.\n")
        return
    end

    -- Normalize the path to use forward slashes
    project_path = project_path:gsub("\\", "/")

    -- Get the project root folder from Reaper's project settings
    local project_root_folder = reaper.GetExtState(Globals.SECTION, Globals.KEYS.project_root_folder)
    local full_project_path = project_root_folder .. "/" .. project_path

    -- Open the project
    reaper.Main_openProject(full_project_path)
end

return OpenProject
