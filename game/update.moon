vortex = require "vortex"
ui = require "ui"
g = require "global"
lc = require "engine"
say = require "say"
shake = require "shake"
road = require "road"
tunnel = require "tunnel"
audio = require "audio"
skip = require "skip"
gui = require "gui"

love.update = (dt) ->
    return if g.paused
    
    dt = math.min(dt, 1/30)
    dt *= g.time_rate

    lc.dialogues\update(dt)

    g.thread_registry\update(dt)

    vortex\update(dt)
    shake\update(dt)
    ui\update(dt)
    lc.game.update(dt)
    road\update(dt)
    tunnel\update(dt)
    say.update(dt)

    g.update_holeegram(dt)

    audio\update(dt)

    skip\update(dt)

    gui\update()
    
    


