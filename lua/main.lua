local Globals = require "globals"
local Operations = require "operations_registry"
local Install = require "operations.install"

-- Main execution logic
local operation = reaper.GetExtState(Globals.SECTION, Globals.KEYS.operation)
if not operation or operation == "" then
    reaper.ShowConsoleMsg("No operation specified. Exiting.\n")
    return
end

if Operations[operation] then
    Operations[operation]()
    reaper.DeleteExtState(Globals.SECTION, Globals.KEYS.operation, true)
elseif reaper.GetExtState(Globals.SECTION, Globals.KEYS.script_action_id) == "" then
    -- If the script is just called by Reaper without an operation and the project root folder is not set,
    -- it's probably the initial installation request
    Install()
else
    reaper.ShowConsoleMsg("Unknown operation: " .. operation .. "\n")
end
