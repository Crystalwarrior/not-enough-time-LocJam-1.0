love.graphics.setDefaultFilter("nearest", "nearest")
love.mouse.setVisible(false)
local g = require("global")
local os = love.system.getOS()
local extension = os == "Windows" and "dll" or os == "Linux" and "so" or os == "OS X" and "dylib" or os == "Web" and "web" or nil
assert(extension, "This application is only supported on Linux, macos, and Windows.")
local base_dir = love.filesystem.getSourceBaseDirectory()
if extension ~= "web" then
  package.cpath = string.format("%s/?.%s;%s", base_dir, extension, package.cpath)
end
g.base_dir = base_dir
local lc = require("engine")
tr = function(...)
  local a1, a2 = ...
  if type(a1) == "string" then
    return a1
  elseif type(a1) == "number" then
    return lc.tr_text and lc.tr_text[a1] or a2
  end
end
INES = tr
PRESIDENT_INES = tr
LEE = tr
HOLEEGRAM = tr
COLLECTOR = tr
ANDREA = tr
PAOLO = tr
PEPPE = tr
TEXT = tr
LOOK = tr
ECHO = tr
NOECHO = tr
g = require("global")
local thread_registry = lc.ThreadRegistry()
g.thread_registry = thread_registry
g.start_thread = function(f)
  return thread_registry:start(f)
end
local blocking_threads_running = 0
g.blocking_thread = function(f)
  g.blocked = true
  blocking_threads_running = blocking_threads_running + 1
  local t = thread_registry:new(f)
  lc.signals.connect(t, "finished", function()
    blocking_threads_running = blocking_threads_running - 1
    if blocking_threads_running == 0 then
      g.blocked = false
    end
    return love.mousemoved(love.mouse.getPosition())
  end)
  t:resume()
  return t
end
require("input")
require("draw")
require("update")
require("rooms")
require("characters")
require("text_translated")
require("text_credits")
local audio = require("audio")
love.quit = function()
  audio.quit()
  return false
end
local inventory = require("inventory")
local game = lc.game
game.set_room(g.rooms.present)
game.set_player(g.characters.ines)
g.characters.ines:change_room(game.room)
g.characters.ines:set_position(100, 100)
g.characters.holeegram:change_room(g.rooms.future)
g.characters.holeegram:set_position(117, 76)
g.characters.lee:change_room(g.rooms.present)
g.characters.andrea:change_room(g.rooms.past)
g.characters.paolo:change_room(g.rooms.past)
g.characters.peppe:change_room(g.rooms.past)
g.characters.collector:change_room(g.rooms.collector, g.characters.collector._position:unpack())
g.rooms.present._objects.exterior.hidden = false
local ui_inventory = require("ui.inventory")
ui_inventory.hidden = true
g.blocking_thread(function()
  while not g.game_started do
    wait_frame()
  end
  return lc.dialogues:new(require("dialogues.lee"))
end)
g.intro = require("intro")
g.intro:start()

gui = require("gui")
require("dialogues.navigator") -- g.switch_room is defined here