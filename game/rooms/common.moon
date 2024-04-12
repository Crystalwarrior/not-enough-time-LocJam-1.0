g = require "global"
lc = require "engine"
inventory = require "inventory"
import Vec2 from lc.steelpan

cassette_inside = false
cassette_room_order = 1

M = {}

M.drawer_setup = (room) ->
    obj = room._objects.drawer
    obj.look_text = -> LOOK(106, "I've never seen anyone keep gloves in here.")
    obj.hotspot_text = -> TEXT(107, "glove compartment")
    obj.interact_position = Vec2(226, 50)
    obj.interact_direction = "E"
    obj.interact = ->
        ines = g.characters.ines
        g.blocking_thread ->
            ines\start_animation_thread("E_pick_low")
            wait 0.2
            obj\start_animation("open", true)
            if not cassette_inside or lc.game.room.order < cassette_room_order
                say ines, INES(108, "It's empty.")
            else
                cassette_inside = false
                say ines, INES(109, "I'll take the cassette.")
                ines\start_animation_thread("E_pick_low")
                wait 0.2
                if lc.game.room.order > cassette_room_order
                    inventory\add("cassette_old")
                    say ines, INES(110, "Perfectly ripe.")
                    say ines, INES(111, "Good thing no one used this compartment in all these years.")
                else
                    inventory\add("cassette")

                ines\start_animation_thread("E_stand")
                wait 0.2
            
            ines\start_animation_thread("E_pick_low")
            wait 0.2
            obj\start_animation("closed", true)
            ines\start_animation_thread("E_stand")

    obj.use = {
        cassette: ->
            ines = g.characters.ines
            g.blocking_thread ->
                cassette_inside = true
                cassette_room_order = lc.game.room.order

                say ines, INES(112, "I'll put it inside.")
                ines\start_animation_thread("E_pick_low")
                wait 0.2
                obj\start_animation("open", true)
                ines\start_animation_thread("E_stand")
                wait 0.2
                ines\start_animation_thread("E_pick_low")
                wait 0.2
                inventory\remove("cassette")
                ines\start_animation_thread("E_stand")
                wait 0.2
                ines\start_animation_thread("E_pick_low")
                wait 0.2
                obj\start_animation("closed", true)
                ines\start_animation_thread("E_stand")
        cassette_old: ->
            ines = g.characters.ines
            g.blocking_thread ->
                say ines, INES(113, "There's no need, I already aged it.")

    }

    return obj


-- M.drawer_setup = (room) ->
--     obj = room._objects.drawer
--     obj.look_text = -> LOOK("Weird that with all this space there's only one storage place.")
--     obj.hotspot_text = -> TEXT("glove compartment")
--     obj.interact_position = Vec2(226, 50)
--     obj.interact_direction = "E"
--     obj.interact = ->
--         ines = g.characters.ines
--         g.blocking_thread ->
--             if obj.open
--                 if device_taken
--                     say ines, INES("It's empty, I'll close it.")
--                 else
--                     say ines, INES("Let's see what's in there.")
--             ines\start_animation_thread("E_pick_low")
--             wait 0.1
--             if obj.open and not device_taken
--                     inventory\add("device_new")
--                     device_taken = true
--                     say ines, INES("It's another reality-fixing device™.")
--             else
--                 obj\start_animation(obj.open and "closed" or "open", true)
--                 obj.open = not obj.open
--             ines\start_animation_thread("E_stand")

--     return obj




return M