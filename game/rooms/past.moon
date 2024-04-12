lc = require "engine"
import Vec2 from lc.steelpan
g = require "global"
common = require "rooms.common"
inventory = require "inventory"

-- inventory = require "inventory"
-- shake = require "shake"
-- audio = require "audio"

room = lc.Room("assets/rooms/past.tuba")
room.order = 1

room._objects.wheels\start_animation("default")

common.drawer_setup(room)

wilson = room._objects.wilson
wilson.look_text = -> LOOK(54, "They're sitting very still. Must be uncomfortable.")
wilson.hotspot_text = -> TEXT(55, "musicians of low moral fiber")
wilson.interact_position = Vec2(154, 101)
wilson.interact_direction = "W"
wilson.interact = ->
    lc.dialogues\new(require "dialogues.wilson")

wilson.use_position = Vec2(96, 101)

destroy_position =  Vec2(119, 104)


wilson.use = {
    pick: ->
        ines = g.characters.ines
        peppe = g.characters.peppe
        andrea = g.characters.andrea
        paolo = g.characters.paolo
        g.blocking_thread ->
            if not g.know_about_pick
                say ines, INES(56, "Why would I do that?")
                return
            
            say ines, INES(57, "Is this the pick you are looking for?")
            ines\start_animation_thread("W_pick_high")
            wait 0.3
            inventory\remove("pick")
            ines\start_animation_thread("W_stand")
            wait 1
            say peppe, PEPPE(364, "My pick!")
            say peppe, PEPPE(365, "My beautiful pick!")
            say paolo, PAOLO(366, "We missed you so much, li'l buddy!")
            say andrea, ANDREA(367, "Don't ever scare us like that again!")
            wait 1
            say ines, INES(58, "Now can I have your guitar?")
            say peppe, PEPPE(368, "Sure thing, I'll get one from the deposit.")
            wait 1
            peppe\start_animation_thread("give_guitar")
            wait 0.3
            ines\start_animation_thread("W_pick_high")
            wait 0.3
            inventory\add("guitar")
            peppe\start_animation_thread("E_stand")
            ines\start_animation_thread("W_stand")
            g.got_guitar = true

            wait 1
            ines\walk_thread(destroy_position\unpack())
            inventory\remove("guitar")
            old_pos_y = ines._position.y
            ines._position.y = -100
            a = room._objects.destroy\start_animation("on", true)
            wait_signal(a, "finished")
            room._objects.destroy.hidden = true
            ines._position.y = old_pos_y
            inventory\add("pickup")

            wait 2
            say peppe, PEPPE(369, "That hurt.")

            wait 1
            say paolo, PAOLO(370, "This gives me an idea for an album cover.")

            g.poster_changed = true
            g.rooms.collector._objects.poster\start_animation("changed", true)
            g.rooms.collector._objects.new_poster.hidden = false
}

wilson.use_nowalk = {
    recorder: ->
        ines = g.characters.ines
        g.blocking_thread ->
            ines\face2("S")
            say ines, INES(59, "I'll turn it on if we talk about anything interesting.")
            wait 0.3
            ines\walk_thread(wilson.interact_position\unpack())
            ines\face2(wilson.interact_direction)
            g.recorder_on = true
            lc.dialogues\new(require "dialogues.wilson")

}

plant = room._objects.plant
plant.look_text = -> LOOK(60, "That doesn't look like the same plant as uncle Lee's.")
plant.hotspot_text = -> TEXT(61, "suspicious plant")


return room
