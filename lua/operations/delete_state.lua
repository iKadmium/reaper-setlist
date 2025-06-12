---@param state string The state table from which the key should be deleted
---@param key string The key to delete from the state table
local function DeleteState(state, key)
    reaper.DeleteExtState(state, key, false)
end

return DeleteState
