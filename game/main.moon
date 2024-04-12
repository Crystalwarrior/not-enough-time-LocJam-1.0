
love.graphics.setDefaultFilter("nearest", "nearest")
love.mouse.setVisible(false)

g = require "global"

os = love.system.getOS()
extension = os == "Windows" and "dll" or os == "Linux" and "so" or os == "OS X" and "dylib" or os == "Web" and "web" or nil
assert(extension, "This application is only supported on Linux, macos, and Windows.") 
base_dir = love.filesystem.getSourceBaseDirectory()
if extension ~= "web"
    package.cpath = string.format("%s/?.%s;%s", base_dir, extension, package.cpath)
g.base_dir = base_dir

lc = require "engine"

export tr = (...) ->
    a1, a2 = ...
    if type(a1) == "string"
        return a1
    elseif type(a1) == "number"
        return lc.tr_text and lc.tr_text[a1] or a2

export INES = tr
export PRESIDENT_INES = tr
export LEE = tr
export HOLEEGRAM = tr
export COLLECTOR = tr
export ANDREA = tr
export PAOLO = tr
export PEPPE = tr
export TEXT = tr
export LOOK = tr
export ECHO = tr
export NOECHO = tr

g = require "global"

thread_registry = lc.ThreadRegistry()
g.thread_registry = thread_registry
g.start_thread = (f) -> thread_registry\start(f)

blocking_threads_running = 0
g.blocking_thread = (f) ->
    g.blocked = true
    blocking_threads_running += 1
    t = thread_registry\new(f)
    lc.signals.connect(t, "finished", ->
        blocking_threads_running -= 1
        g.blocked = false if blocking_threads_running == 0
        love.mousemoved(love.mouse.getPosition())
    )
    t\resume()
    return t


require "input"
require "draw"
require "update"
require "rooms"
require "characters"
require "text_translated"
require "text_credits"

audio = require "audio"


love.quit = ->
    audio.quit()
    return false

inventory = require "inventory"


game = lc.game
game.set_room(g.rooms.present)
game.set_player(g.characters.ines)
g.characters.ines\change_room(game.room)
g.characters.ines\set_position(100, 100)

g.characters.holeegram\change_room(g.rooms.future)
g.characters.holeegram\set_position(117, 76)

g.characters.lee\change_room(g.rooms.present)

g.characters.andrea\change_room(g.rooms.past)
g.characters.paolo\change_room(g.rooms.past)
g.characters.peppe\change_room(g.rooms.past)

g.characters.collector\change_room(g.rooms.collector, g.characters.collector._position\unpack())

g.rooms.present._objects.exterior.hidden = false

ui_inventory = require "ui.inventory"

ui_inventory.hidden = true

g.blocking_thread ->
    while not g.game_started
        wait_frame()

    lc.dialogues\new(require "dialogues.lee")
    
g.intro = require "intro"
g.intro\start()

-- return unless g.debug 

-- gui = require "gui"
-- require "dialogues.navigator" -- g.switch_room is defined here