---@return number project_length
local function GetLength()
    -- Get the current project length in seconds
    local project = reaper.EnumProjects(-1)
    local project_length = reaper.GetProjectLength(project)
    return project_length
end

return GetLength
