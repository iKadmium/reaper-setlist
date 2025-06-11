---@param full_path string
---@param base_path string
---@return string
local function GetRelativePath(full_path, base_path)
    -- Ensure both paths end consistently for proper matching
    local normalized_base = base_path:gsub("/$", "") .. "/"
    local normalized_full = full_path:gsub("\\", "/")

    if normalized_full:sub(1, #normalized_base) == normalized_base then
        return normalized_full:sub(#normalized_base + 1)
    end
    return normalized_full -- fallback to full path if base not found
end

return GetRelativePath
