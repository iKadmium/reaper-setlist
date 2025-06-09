local Globals = require "globals"
local Operations = require "operations_registry"

-- Main execution logic
local operation = reaper.GetExtState(Globals.SECTION, Globals.KEYS.operation)
if not operation or operation == "" then
    reaper.ShowConsoleMsg("No operation specified. Exiting.\n")
    return
end

if Operations[operation] then
    Operations[operation]()
    reaper.DeleteExtState(Globals.SECTION, Globals.KEYS.operation, true)
else
    reaper.ShowConsoleMsg("Unknown operation: " .. operation .. "\n")
end
