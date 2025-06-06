-- filepath: /workspaces/reaper-setlist/lua/.luacheckrc
std = "lua54"
globals = { "reaper" }
files["*.lua"].read_globals = { "reaper" }
include_files = { "reaper-api.lua" }