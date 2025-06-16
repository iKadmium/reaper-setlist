---@return ReaperTab[]
---@return number active_index
local GetOpenTabs = function()
    ---@type ReaperTab[]
    local tabs = {}
    local tab_index = 0

    local active_project = reaper.EnumProjects(-1)
    local active_project_index = -1;

    while true do
        local proj = reaper.EnumProjects(tab_index)
        if proj == nil then
            break
        end

        local tab_name = reaper.GetProjectName(proj)
        if not tab_name or tab_name == "" then
            break
        end

        local duration = reaper.GetProjectLength(proj)

        -- Normalize the path to ensure consistency
        local normalized_tab_name = tab_name:gsub("\\", "/")

        local is_dirty = reaper.IsProjectDirty(proj) == 1
        local is_active = (proj == active_project)
        if is_active then
            active_project_index = tab_index
        end

        ---@type ReaperTab
        local tab = {
            index = tab_index,
            name = normalized_tab_name,
            dirty = is_dirty,
            length = duration
        }

        table.insert(tabs, tab)
        tab_index = tab_index + 1
    end

    return tabs, active_project_index
end

return GetOpenTabs
