g = require "global"

love.conf =  function(t)
    t.identity = "Not enough time"
    t.window.title = "Not enough time"
    t.window.width = g.game_width*g.scale
    t.window.height = g.game_height*g.scale
    t.window.resizable = true
    t.window.usedpiscale = false
    
    t.modules.audio = false
    t.modules.data = false
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.sound = false
    t.modules.thread = false
    t.modules.video = false
    t.console = true
end
