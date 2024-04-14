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
g:loadOptions()
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
  print("THE BEGINNING")
  g:loadGame()
  if g.flags.cutscene_done then
    g.rooms.present._objects.exterior.hidden = true
    g.intro = false
    require("vortex").on = true
    require("road").on = false
    require("ui.inventory").hidden = false
    -- initialize flag-based hidden-ness, this is kind of awful but we're on a time limit.
    g.rooms.collector._objects.pick.hidden = not g.flags.poster_interacted or g.flags.got_pick

    if g.flags.got_pick then
      g.rooms.collector._objects.poster:start_animation("no_pick", true)
    end

    if g.flags.poster_changed then
      g.rooms.collector._objects.poster:start_animation("changed", true)
    end

    g.rooms.collector._objects.new_poster.hidden = not g.flags.poster_changed

    g.rooms.collector._objects.recorder.hidden = g.flags.recorder_obtained
    g.rooms.future._objects.coin.hidden = g.flags.got_coin
    g.rooms.present._objects.navigator.hidden = not g.flags.navigator_available

    g.rooms.present._objects.lee.hidden = g.flags.hide_lee
    if g.rooms.present._objects.lee.hidden then
      g.characters.lee:change_room(nil)
    end

    local collector = g.characters.collector
    if g.flags.collector_distracted then
      collector:start_animation("E_distracted")
      collector._animations["E_talk"]:toggle_visibility("headphones")
      collector._animations["E_stand"]:toggle_visibility("headphones")
      collector._animations["E_distracted"]:toggle_visibility("headphones")
    elseif g.flags.collector_looking then
      collector:face2("E")
    end

    print("Save data loaded!")
    return
  end
  return lc.dialogues:new(require("dialogues.lee"))
end)
g.intro = require("intro")
g.intro:start()

gui = require("gui")
require("dialogues.navigator") -- g.switch_room is defined here