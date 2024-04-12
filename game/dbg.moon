g = require "global"
lc = require "engine"
audio = require "audio"
shake = require "shake"

M = {}

M.draw = ->
    -- v = g.characters.ines._position
    -- love.graphics.print("(#{v.x},#{v.y})", 0, 0, 0, 6)

M.keypressed = (key) ->
    game = lc.game
    local room

    switch key
        when "1"
            room = g.rooms.present
        when "2"
            room = g.rooms.collector
        when "3"
            room = g.rooms.future
        when "4"
            room = g.rooms.past
        when "space"
            g.paused = not g.paused

    if room
        g.blocking_thread ->
            audio.switch_room(room)
            shake\start()
            wait_signal(shake, "finished")
            game.set_room(room)
            game.player\change_room(room, game.player._position\unpack())


return M

