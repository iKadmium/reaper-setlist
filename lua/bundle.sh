#!/bin/sh

echo "---@diagnostic disable" > build/reaper-setlist.lua
bun x luabundler bundle main.lua -p "?.lua" -p "?/?.lua" -o build/reaper-setlist-temp.lua
cat build/reaper-setlist-temp.lua >> build/reaper-setlist.lua
rm build/reaper-setlist-temp.lua
