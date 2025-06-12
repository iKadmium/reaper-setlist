---@param section string
---@param key string
---@param chunks string[]
---@return nil
local function WriteChunkedData(section, key, chunks)
    -- join the chunks into a single string
    local data = table.concat(chunks)
    reaper.SetExtState(section, key, data, true)
end

return WriteChunkedData
