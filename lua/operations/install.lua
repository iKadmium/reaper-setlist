local Globals = require "globals"

---@return nil
local function Install()
    -- Get the script filename
    local _is_new_value, filename, _sectionID, _cmdID, _mode, _resolution, _val, _contextstr = reaper.get_action_context()
    if not filename or filename == "" then
        reaper.ShowConsoleMsg("No script filename found. Exiting installation.\n")
        return
    end

    local action_id = reaper.AddRemoveReaScript(true, 0, filename, true)
    reaper.SetExtState(Globals.SECTION, Globals.KEYS.script_action_id, tostring(action_id), true)
end

return Install
