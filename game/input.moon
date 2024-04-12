g = require "global"
lc = require "engine"
ui = require "ui"
gui = require "gui"
speak = require "say"
skip = require "skip"
import game from lc
import Vec2 from lc.steelpan
import round from lc.steelpan.utils.math
import random_choice from lc.steelpan.utils


dbg = g.debug and require "dbg"

g.screen_transform = love.math.newTransform()

love.resize = (w, h) ->
    g.screen_transform\reset()
    g.scale = math.min(w/g.game_width, h/g.game_height)
    if g.integer_scaling
        g.scale = math.max(1, math.floor(g.scale))
    g.xshift = round(math.max(0, math.min((w/g.scale - g.game_width)/2)))
    g.yshift = round(math.max(0, math.min((h/g.scale - g.game_height)/2)))
    g.screen_transform\scale(g.scale)
    g.screen_transform\translate(g.xshift, g.yshift)

    if love.mousemoved
        love.mousemoved(love.mouse.getPosition())

-- if love.system.getOS() ~= "Web"
--     g.fullscreen = true
--     love.window.setFullscreen(true)

love.resize(love.graphics.getDimensions())

p = Vec2()

love.mousemoved = (x, y) ->

    X = round(x/g.scale - g.xshift)
    Y = round(y/g.scale - g.yshift)
    p = Vec2(X, Y)
    g.p = p



    if not g.blocked
        room = lc.game.room
        if obj = room\get_hotspot(p)
            if text = obj.hotspot_text and obj.hotspot_text()
                g.hotspot_text = text
                g.hotspot.type = "room"
                g.hotspot.object = obj
                g.look_text = obj.look_text and obj.look_text() or nil
            else
                g.hotspot.type = nil
                g.hotspot.object = nil
                g.hotspot_text = nil
        else
            g.hotspot.type = nil
            g.hotspot.object = nil
            g.hotspot_text = nil

    ui\mousemoved(x, y, p)
    gui\mousemoved()





love.mousereleased = (x, y) ->

    if gui.menu
        gui\mousereleased()
        return

    if not g.start_click
        g.start_click = true

    return if g.blocked

    if lc.dialogues\is_running()
        ui\mousereleased()
        return

    if require("ui.cog")\is_mouse_on()
        gui\set_menu("options")
        return
    
    -- interactions   
    obj = g.hotspot.object

    if obj and g.hotspot.type == "inventory"
        if f = obj.interact
            f()
        else
            g.inventory_item = obj
            love.mousemoved(x, y)
            return
    
    elseif ui\mouse_on_inventory(g.p.x, g.p.y)
        g.inventory_item = nil
        return

    elseif obj and g.inventory_item
        if thread = g.interaction_thread
            thread\stop()
        inv_item = g.inventory_item
        g.interacting_obj = obj
        if f = obj.use and obj.use[inv_item.name]
            g.interaction_thread = g.start_thread( ->
                pos = obj.use_position or obj.interact_position
                game.player\walk_thread(pos\unpack()) if pos
                if p = obj.look_point
                    wait 0.1
                    game.player\face2point(p)
                    wait 0.1
                elseif obj.interact_direction
                    wait 0.1
                    game.player\face2(obj.interact_direction)
                    wait 0.1
                f()
                g.inventory_item = nil
                g.interacting_obj = nil
            )
        elseif f = obj.use_nowalk and obj.use_nowalk[inv_item.name]
            g.interacting_obj = nil
            g.inventory_item = nil
            f()
        else
            g.interaction_thread = g.blocking_thread( ->
                sentence = random_choice {
                    TEXT(1, "I can't do that.")
                    TEXT(2, "That won't work.")
                    TEXT(3, "Nah.")
                    TEXT(4, "Maybe later.")
                }
                say game.player, sentence
                g.interacting_obj = nil
            )  

    elseif obj and obj.interact
        return if obj == g.interacting_obj
        if thread = g.interaction_thread
            thread\stop()
        g.interacting_obj = obj
        g.interaction_thread = g.start_thread( ->
            game.player\walk_thread(obj.interact_position\unpack()) if obj.interact_position
            if obj.look_point
                wait 0.1
                game.player\face2point(obj.look_point)
                wait 0.1
            elseif obj.interact_direction
                wait 0.1
                game.player\face2(obj.interact_direction)
                wait 0.1
            obj.interact()
            g.interacting_obj = nil
        )
    elseif not obj and g.inventory_item
        g.inventory_item = nil

    else
        if thread = g.interaction_thread
            thread\stop()
        g.interacting_obj = nil
        g.inventory_item = nil
        game.player\walk(p.x, p.y)

    
love.keypressed = (key) ->
    if g.test_credits and key == "c"
        if g.credits_thread
            g.credits_thread\stop()
        g.test_credits = false
        require("gui").menu = require("gui.start")
        g.draw_credits = nil
        return

    if gui\keypressed(key)
        return
    switch key
        when g.key.skip
            speak\skip() if not g.skip_with_mouse
        when g.key.cutscene
            skip\start_hold()
        
    dbg.keypressed(key) if dbg

love.keyreleased = (key) ->
    switch key
        when "escape"
            skip\release_hold()


love.wheelmoved = (x, y) ->
    ui\wheelmoved(x, y)

love.mousepressed = (x, y, button) ->
    return if gui\mousepressed(button)
    
    if g.skip_with_left and button == 1 or g.skip_with_right and button == 2
        speak\skip()