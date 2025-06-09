-- Bundled by luabundle {"version":"1.7.0"}
local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(require)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
local Globals = require("globals")
local Operations = require("operations_registry")

-- Main execution logic
local operation = reaper.GetExtState(Globals.SECTION, Globals.KEYS.operation)
if not operation or operation == "" then
    reaper.ShowConsoleMsg("No operation specified. Exiting.\n")
    return
end

if Operations[operation] then
    Operations[operation]()
    reaper.DeleteExtState(Globals.SECTION, Globals.KEYS.operation, true)
else
    reaper.ShowConsoleMsg("Unknown operation: " .. operation .. "\n")
end

end)
__bundle_register("operations_registry", function(require, _LOADED, __bundle_register, __bundle_modules)
local Globals = require("globals")

---@param path string
---@return string
local function normalize_path(path)
    local normalized = path:gsub("\\", "/")
    return normalized
end

---@param full_path string
---@param base_path string
---@return string
local function get_relative_path(full_path, base_path)
    -- Ensure both paths end consistently for proper matching
    local normalized_base = base_path:gsub("/$", "") .. "/"
    local normalized_full = full_path:gsub("\\", "/")

    if normalized_full:sub(1, #normalized_base) == normalized_base then
        return normalized_full:sub(#normalized_base + 1)
    end
    return normalized_full -- fallback to full path if base not found
end

---@param current_dir string
---@param base_path_for_relative string
---@return string[]
local function list_rpp_files_recursive(current_dir, base_path_for_relative)
    ---@type string[]
    local project_files = {}

    current_dir = normalize_path(current_dir)
    base_path_for_relative = normalize_path(base_path_for_relative)

    -- Step 1: Enumerate files in the current directory
    local file_index = 0
    while true do
        local filename = reaper.EnumerateFiles(current_dir, file_index)
        if not filename then
            break
        end

        -- Check if it's an .rpp file (case-insensitive)
        if filename:lower():match("%.rpp$") then
            local full_path = current_dir .. "/" .. filename
            local relative_path = get_relative_path(full_path, base_path_for_relative)
            table.insert(project_files, relative_path)
        end
        file_index = file_index + 1
    end

    -- Step 2: Enumerate subdirectories and recurse
    local subdir_index = 0
    while true do
        local dirname = reaper.EnumerateSubdirectories(current_dir, subdir_index)
        if not dirname then
            break
        end

        -- Skip special directories and hidden directories
        if dirname ~= "." and dirname ~= ".." and not dirname:match("^%.") then
            local full_subdir_path = current_dir .. "/" .. dirname
            local subdir_files = list_rpp_files_recursive(full_subdir_path, base_path_for_relative)

            -- Use ipairs for better performance with arrays
            for _, file in ipairs(subdir_files) do
                table.insert(project_files, file)
            end
        end
        subdir_index = subdir_index + 1
    end

    return project_files
end

---Returns a list of .rpp files in the project root folder and its subfolders
---@return string
local function ListProjects()
    local project_root_folder = reaper.GetExtState(Globals.SECTION, Globals.KEYS.project_root_folder)
    if not project_root_folder or project_root_folder == "" then
        error("Project root folder is not set. Cannot list files.")
    end

    project_root_folder = normalize_path(project_root_folder)
    project_root_folder = project_root_folder:gsub("/$", "")

    local project_files = list_rpp_files_recursive(project_root_folder, project_root_folder)

    table.sort(project_files, function(a, b)
        return a:lower() < b:lower()
    end)

    return table.concat(project_files, ",")
end

return ListProjects

end)
__bundle_register("globals", function(require, _LOADED, __bundle_register, __bundle_modules)
local Globals = require("globals")

---@param path string
---@return string
local function normalize_path(path)
    local normalized = path:gsub("\\", "/")
    return normalized
end

---@param full_path string
---@param base_path string
---@return string
local function get_relative_path(full_path, base_path)
    -- Ensure both paths end consistently for proper matching
    local normalized_base = base_path:gsub("/$", "") .. "/"
    local normalized_full = full_path:gsub("\\", "/")

    if normalized_full:sub(1, #normalized_base) == normalized_base then
        return normalized_full:sub(#normalized_base + 1)
    end
    return normalized_full -- fallback to full path if base not found
end

---@param current_dir string
---@param base_path_for_relative string
---@return string[]
local function list_rpp_files_recursive(current_dir, base_path_for_relative)
    ---@type string[]
    local project_files = {}

    current_dir = normalize_path(current_dir)
    base_path_for_relative = normalize_path(base_path_for_relative)

    -- Step 1: Enumerate files in the current directory
    local file_index = 0
    while true do
        local filename = reaper.EnumerateFiles(current_dir, file_index)
        if not filename then
            break
        end

        -- Check if it's an .rpp file (case-insensitive)
        if filename:lower():match("%.rpp$") then
            local full_path = current_dir .. "/" .. filename
            local relative_path = get_relative_path(full_path, base_path_for_relative)
            table.insert(project_files, relative_path)
        end
        file_index = file_index + 1
    end

    -- Step 2: Enumerate subdirectories and recurse
    local subdir_index = 0
    while true do
        local dirname = reaper.EnumerateSubdirectories(current_dir, subdir_index)
        if not dirname then
            break
        end

        -- Skip special directories and hidden directories
        if dirname ~= "." and dirname ~= ".." and not dirname:match("^%.") then
            local full_subdir_path = current_dir .. "/" .. dirname
            local subdir_files = list_rpp_files_recursive(full_subdir_path, base_path_for_relative)

            -- Use ipairs for better performance with arrays
            for _, file in ipairs(subdir_files) do
                table.insert(project_files, file)
            end
        end
        subdir_index = subdir_index + 1
    end

    return project_files
end

---Returns a list of .rpp files in the project root folder and its subfolders
---@return string
local function ListProjects()
    local project_root_folder = reaper.GetExtState(Globals.SECTION, Globals.KEYS.project_root_folder)
    if not project_root_folder or project_root_folder == "" then
        error("Project root folder is not set. Cannot list files.")
    end

    project_root_folder = normalize_path(project_root_folder)
    project_root_folder = project_root_folder:gsub("/$", "")

    local project_files = list_rpp_files_recursive(project_root_folder, project_root_folder)

    table.sort(project_files, function(a, b)
        return a:lower() < b:lower()
    end)

    return table.concat(project_files, ",")
end

return ListProjects

end)
return __bundle_require("__root")