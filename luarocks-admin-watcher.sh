#!/usr/local/openresty/luajit/bin/luajit
package.loaded["luarocks.core.hardcoded"] = { SYSCONFDIR = [[/usr/local/etc/luarocks]] }
package.path=[[/usr/local/share/lua/5.1/?.lua;]] .. package.path
local list = package.searchers or package.loaders; table.insert(list, 1, function(name) if name:match("^luarocks%.") then return loadfile([[/usr/local/share/lua/5.1/]] .. name:gsub([[%.]], [[/]]) .. [[.lua]]) end end)

local inotify = require 'inotify'
local handle = inotify.init()

local cmd = require("luarocks.cmd")

local commands = {
   make_manifest = "luarocks.admin.cmd.make_manifest",
}

cmd.run_command('', commands, "luarocks.admin.cmd.external", 'make_manifest', '__ROCKS_DIR__')

-- Watch for new files and renames
handle:addwatch('__ROCKS_DIR__', inotify.IN_CREATE, inotify.IN_MOVE, inotify.IN_DELETE, inotify.IN_MODIFY)

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

for ev in handle:events() do
    if ends_with(ev.name, ".rock") then
      cmd.run_command('', commands, "luarocks.admin.cmd.external", 'make_manifest', '__ROCKS_DIR__')
    end
end