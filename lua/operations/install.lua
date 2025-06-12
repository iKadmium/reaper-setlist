local Globals = require "globals"

---@return nil
local function Install()
    -- Get the script filename
    local _, filename, _, _, _, _, _, _ = reaper.get_action_context()
    if not filename or filename == "" then
        reaper.ShowConsoleMsg("No script filename found. Exiting installation.\n")
        return
    end

    -- this action id is a red herring - it's temporary and subject to change
    local action_id = reaper.AddRemoveReaScript(true, 0, filename, true)
    -- get the permanent ID of the action
    local permanent_id = reaper.ReverseNamedCommandLookup(action_id)

    reaper.SetExtState(Globals.SECTION, Globals.KEYS.script_action_id, "_" .. permanent_id, true)
end

return Install
