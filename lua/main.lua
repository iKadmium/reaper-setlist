local globals = require "globals"
local Operations = require "operations"

-- Main execution logic
local operation = reaper.GetExtState(globals.SECTION, globals.KEYS.operation)
if not operation or operation == "" then
    reaper.ShowConsoleMsg("No operation specified. Exiting.\n")
    return
end

if Operations[operation] then
    Operations[operation]()
    reaper.DeleteExtState(globals.SECTION, globals.KEYS.operation, true)
else
    reaper.ShowConsoleMsg("Unknown operation: " .. operation .. "\n")
end
