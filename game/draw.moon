vortex = require "vortex"
inventory = require "inventory"
road = require "road"
tunnel = require "tunnel"
shake = require "shake"
speak = require "say"
ui = require "ui"
gui = require "gui"
skip = require "skip"
import game from require "engine"

dbg = g.debug and require "dbg" or nil

canvas = love.graphics.newCanvas(g.game_width, g.game_height)

vortex\set_position(158, 46)

love.draw = ->
    
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 1)

    unless skip.skipping
        shake\push()
        vortex\draw()

        road\draw()
        tunnel\draw()
        love.graphics.push()
        love.graphics.translate(g.ending_shift or 0, 0)
        game.room\draw()
        love.graphics.pop()


        ui\draw_canvas()

        speak.draw_canvas()
        shake\pop()

    g.intro\draw() if g.intro
        



    love.graphics.setCanvas()
    love.graphics.push()
    love.graphics.applyTransform(g.screen_transform)
    love.graphics.draw(canvas)
    love.graphics.pop()

    speak.draw_screen()
    gui\draw()
    g.draw_credits() if g.draw_credits

    if not g.blocked or gui.menu
        ui\draw_screen()


    dbg.draw() if g.debug