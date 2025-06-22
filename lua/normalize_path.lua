---@param path string
---@return string
local function NormalizePath(path)
    local normalized = path:gsub("\\", "/")
    return normalized
end

return NormalizePath
