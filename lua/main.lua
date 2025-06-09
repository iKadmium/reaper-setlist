require "globals"
local Operations = require "operations_registry"

-- Main execution logic
local operation = reaper.GetExtState(SECTION, OPERATION_KEY)
if not operation or operation == "" then
    reaper.ShowConsoleMsg("No operation specified. Exiting.\n")
    return
end

if Operations[operation] then
    Operations[operation]()
    reaper.DeleteExtState(SECTION, OPERATION_KEY, true)
else
    reaper.ShowConsoleMsg("Unknown operation: " .. operation .. "\n")
end
