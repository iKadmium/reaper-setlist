-- luacheck: globals Globals

--- Global constants for the Reaper Setlist application
--- @class GlobalsKeys
--- @field operation string
--- @field project_root_folder string

--- @class Globals
--- @field SECTION string
--- @field KEYS GlobalsKeys
local Globals = {
    SECTION = "ReaperSetlist",
    KEYS = {
        operation = "Operation",
        project_root_folder = "ProjectRoot",
    }
}

return Globals
