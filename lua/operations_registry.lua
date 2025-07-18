-- Generated by ts-morph script. Do not edit manually!

---@param func function
---@return function
local function safe_operation(func)
    return function()
        local success, err = pcall(func)
        if not success then
            reaper.ShowConsoleMsg("Error: " .. tostring(err) .. "\n")
        end
    end
end

local Globals = require "globals"
local json = require "json"
local ListProjects = require "operations/list_projects"
local TestProjectsFolder = require "operations/test_projects_folder"
local OpenProject = require "operations/open_project"
local TestActionId = require "operations/test_action_id"
local GetProjectLength = require "operations/get_project_length"
local GetOpenTabs = require "operations/get_open_tabs"
local WriteChunkedData = require "operations/write_chunked_data"
local DeleteState = require "operations/delete_state"

---@class ReaperTab
---@field index number
---@field name string
---@field length number
---@field dirty boolean

local Operations = {
	["listProjects"] = safe_operation(function()
		local projects = ListProjects()

		if projects == nil or projects == '' then
			error("Operation listProjects failed to return required output: projects")
		end

		reaper.SetExtState(Globals.SECTION, "projects", json.encode(projects), false)
	end),

	["testProjectsFolder"] = safe_operation(function()
		local folderPath = reaper.GetExtState(Globals.SECTION, "folderPath")
		if folderPath == nil or folderPath == "" then
			error("Missing required parameter: folderPath")
		end

		local valid, message = TestProjectsFolder(folderPath)

		if valid == nil or valid == '' then
			error("Operation testProjectsFolder failed to return required output: valid")
		end

		reaper.SetExtState(Globals.SECTION, "valid", valid and "true" or "false", false)
		if message == nil or message == '' then
			error("Operation testProjectsFolder failed to return required output: message")
		end

		reaper.SetExtState(Globals.SECTION, "message", message, false)
		reaper.DeleteExtState(Globals.SECTION, "folderPath", true)
	end),

	["openProject"] = safe_operation(function()
		local projectPath = reaper.GetExtState(Globals.SECTION, "projectPath")
		if projectPath == nil or projectPath == "" then
			error("Missing required parameter: projectPath")
		end

		OpenProject(projectPath)

		reaper.DeleteExtState(Globals.SECTION, "projectPath", true)
	end),

	["testActionId"] = safe_operation(function()
		local testNonce = reaper.GetExtState(Globals.SECTION, "testNonce")
		if testNonce == nil or testNonce == "" then
			error("Missing required parameter: testNonce")
		end

		local testOutput = TestActionId(testNonce)

		if testOutput == nil or testOutput == '' then
			error("Operation testActionId failed to return required output: testOutput")
		end

		reaper.SetExtState(Globals.SECTION, "testOutput", testOutput, false)
		reaper.DeleteExtState(Globals.SECTION, "testNonce", true)
	end),

	["getProjectLength"] = safe_operation(function()
		local projectLength = GetProjectLength()

		if projectLength == nil or projectLength == '' then
			error("Operation getProjectLength failed to return required output: projectLength")
		end

		reaper.SetExtState(Globals.SECTION, "projectLength", tostring(projectLength), false)
	end),

	["getOpenTabs"] = safe_operation(function()
		local tabs, activeIndex = GetOpenTabs()

		if tabs == nil or tabs == '' then
			error("Operation getOpenTabs failed to return required output: tabs")
		end

		reaper.SetExtState(Globals.SECTION, "tabs", json.encode(tabs), false)
		if activeIndex == nil or activeIndex == '' then
			error("Operation getOpenTabs failed to return required output: activeIndex")
		end

		reaper.SetExtState(Globals.SECTION, "activeIndex", tostring(activeIndex), false)
	end),

	["writeChunkedData"] = safe_operation(function()
		local section = reaper.GetExtState(Globals.SECTION, "section")
		if section == nil or section == "" then
			error("Missing required parameter: section")
		end

		local key = reaper.GetExtState(Globals.SECTION, "key")
		if key == nil or key == "" then
			error("Missing required parameter: key")
		end

		local chunks_length = reaper.GetExtState(Globals.SECTION, "chunks_length")
		if chunks_length == nil or chunks_length == "" then
			error("Missing required parameter: chunks_length")
		end

		local chunks = {}
		for i = 0, (tonumber(chunks_length) - 1) do
			local chunk = reaper.GetExtState(Globals.SECTION, "chunks_" .. i)
			if chunk and chunk ~= "" then
				chunks[i + 1] = chunk
			else
				error("Missing chunk for chunks at index " .. i)
			end
		end

		WriteChunkedData(section, key, chunks)

		reaper.DeleteExtState(Globals.SECTION, "section", true)
		reaper.DeleteExtState(Globals.SECTION, "key", true)
		reaper.DeleteExtState(Globals.SECTION, "chunks", true)
	end),

	["deleteState"] = safe_operation(function()
		local section = reaper.GetExtState(Globals.SECTION, "section")
		if section == nil or section == "" then
			error("Missing required parameter: section")
		end

		local key = reaper.GetExtState(Globals.SECTION, "key")
		if key == nil or key == "" then
			error("Missing required parameter: key")
		end

		DeleteState(section, key)

		reaper.DeleteExtState(Globals.SECTION, "section", true)
		reaper.DeleteExtState(Globals.SECTION, "key", true)
	end),
}

return Operations