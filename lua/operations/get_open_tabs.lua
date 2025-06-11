---@return ReaperTab[]
local GetOpenTabs = function()
    ---@type ReaperTab[]
    local tabs = {}
    local tab_index = 0

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

        ---@type ReaperTab
        local tab = {
            index = tab_index,
            name = normalized_tab_name,
            length = duration,
            tempo = reaper.Master_GetTempo()
        }

        table.insert(tabs, tab)
        tab_index = tab_index + 1
    end

    return tabs
end

return GetOpenTabs
