local Globals = require "globals"
local Operations = require "operations_registry"
local Install = require "operations.install"

-- Main execution logic
local operation = reaper.GetExtState(Globals.SECTION, Globals.KEYS.operation)
if not operation or operation == "" then
    local _, _, _, cmdId = reaper.get_action_context()
    local saved_action_id = reaper.GetExtState(Globals.SECTION, Globals.KEYS.script_action_id)
    if saved_action_id == "" or tostring(cmdId) ~= saved_action_id then
        -- If the script is just called by Reaper without an operation and the project root folder is not set,
        -- it's probably the initial installation request
        Install()
        reaper.ShowConsoleMsg("Installation completed.\n")
        return
    else
        reaper.ShowConsoleMsg("No operation specified. Exiting.\n")
        return
    end
end

if Operations[operation] then
    Operations[operation]()
    reaper.DeleteExtState(Globals.SECTION, Globals.KEYS.operation, true)
else
    reaper.ShowConsoleMsg("Unknown operation: " .. operation .. "\n")
end
