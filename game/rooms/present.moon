lc = require "engine"
import Vec2 from lc.steelpan
g = require "global"
common = require "rooms.common"
inventory = require "inventory"
skip = require "skip"
dissolve = require "dissolve"
-- shake = require "shake"
-- audio = require "audio"

room = lc.Room("assets/rooms/present.tuba")
room.order = 3

wheels = room._objects.wheels\start_animation("default")


windows = room._objects.windows
windows.look_text = -> LOOK(6, "Void. Void everywhere.")
windows.hotspot_text = -> TEXT(7, "windows")


common.drawer_setup(room)

lee = room._objects.lee
lee.look_text = -> LOOK(8, "At least now he has a reason not to look at the road.")
lee.hotspot_text = -> TEXT(9, "uncle Lee")
lee.interact_position = Vec2(148, 99)
lee.interact_direction = "E"
lee.interact = ->
    lc.dialogues\new(require "dialogues.lee")

lee.use = {
    device_new: ->
        ines = g.characters.ines
        lee = g.characters.lee
        g.blocking_thread ->
            skip\start()
            say ines, INES(10, "Here it is.")
            wait 0.5
            ines\start_animation_thread("E_pick_high")
            wait 0.5
            ines\start_animation_thread("E_stand")
            inventory\remove("device_new")

            say ines, INES(11, "I hope this works, for your own sake.")
            say ines, INES(12, "I'm not keen on being stuck in a temporal tunnel.")
            say lee, LEE(357, "No worries, we'll be back in our own timeline in a jiffy.")
            lee\start_animation_thread("remote_up")
            wait 1
            lee._shader = dissolve.shader
            dissolve\start_disappear(0.8)
            wait_signal(dissolve, "finished")
            lee\change_room(nil)
            g.rooms.present._objects.lee.hidden = true
            g.rooms.present._objects.navigator.hidden = false

            wait 1
            ines\face2("S")
            wait 1
            say ines, INES(13, "I should have expected that.")
            skip\stop()
}

lee.use_nowalk = {
    device_old: ->
        ines = g.characters.ines
        g.blocking_thread ->
            say ines, INES(14, "There's no point, it's the broken one he gave me.")
}

        


navigator = room._objects.navigator
navigator.look_text = -> LOOK(15, "Why uncle Lee, why?")
navigator.hotspot_text = -> TEXT(16, "temporal navigator")
navigator.interact_position = Vec2(208, 98)
navigator.interact_direction = "W"
navigator.interact = ->
    ines = g.characters.ines
    g.blocking_thread ->
        say ines, INES(17, "It looks like a phone.")
        wait 0.5
        ines\face2("S")
        say ines, INES(18, "He made a time machine out of a phone!?")
        wait 0.5
        ines\face2("W")
        wait 0.5
        ines\start_animation("W_pick_high")
        wait 0.5
        navigator.hidden = true
        inventory\add("navigator")

        say ines, INES(19, "There are some times on speed dial.")

navigator.hidden = true

plant = room._objects.plant
plant.hotspot_text = -> TEXT(20, "plant")
plant.look_text = -> LOOK(21, "Why does uncle Lee keep a plant in a van?")
plant.interact_position = Vec2(92, 99)
plant.interact_direction = "W"

plant.interact = ->
    ines = g.characters.ines
    g.blocking_thread ->
        say ines, INES(22, "There's something hidden in the vase!")
        ines\start_animation_thread("W_pick_low")
        wait 0.3
        inventory\add("device_new")
        ines\start_animation_thread("W_stand")
        wait 0.3
        say ines, INES(23, "It's a spare device.")
        ines\face2("S")
        say ines, INES(24, "How did it get in there?")
        plant.interact = nil

plant.use_nowalk = {
    device_new2: ->
        ines = g.characters.ines
        g.blocking_thread ->
            say ines, INES(25, "I found the device in this vase earlier.")
            say ines, INES(26, "I don't think putting it back in now would help.")
            say ines, INES(27, "But I feel like I'm on the right track.")
}







return room
