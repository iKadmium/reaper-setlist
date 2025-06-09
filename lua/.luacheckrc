-- filepath: /workspaces/reaper-setlist/lua/.luacheckrc
std = "lua54"
read_globals = { 
    "reaper",
    "Globals"
}
exclude_files = { "reaper-api.lua", "std/globals.luacheck.lua" }
max_line_length = 120
-- Enable strict checking
unused = true
redefined = true

-- Custom pattern checking for invalid field access
patterns = {
    "Globals%.KEYS%.script_output"
}
