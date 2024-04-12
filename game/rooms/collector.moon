lc = require "engine"
import Vec2 from lc.steelpan
g = require "global"
common = require "rooms.common"
inventory = require "inventory"

room = lc.Room("assets/rooms/collector.tuba")
room.order = 2

room._objects.wheels\start_animation("default")


collector = room._objects.collector
collector.look_text = ->
    if not g.collector_distracted
        if g.characters.collector._direction == lc.Character.direction.N
            LOOK(62, "She's staring very intensely at that poster.")
        else
            LOOK(63, "She's staring very intensely at me.")
    else
        LOOK(64, "She's listening very intensely to the demo tape.")
collector.hotspot_text = ->
    if not g.know_who_collector_is
        TEXT(65, "?")
    else
        TEXT(66, "collector")

collector.interact_position = Vec2(120, 101)
collector.interact_direction = "W"
collector.interact = ->
    lc.dialogues\new(require "dialogues.collector")


collector.use = {
    cassette_old: ->
        ines = g.characters.ines
        c = g.characters.collector
        g.blocking_thread ->
            say ines, INES(67, "Here.")
            ines\start_animation_thread("W_pick_high")
            wait 0.1
            inventory\remove("cassette_old")
            ines\start_animation_thread("W_stand")
            say c, COLLECTOR(371, "Is this...")
            say c, COLLECTOR(372, "...is this what I think it is?")
            say ines, INES(68, "Yep.")
            say c, COLLECTOR(373, "It looks genuine!")
            say c, COLLECTOR(374, "I can't believe it!")
            say c, COLLECTOR(375, "I will need to listen to it right away to make sure.")
            wait 1
            say c, COLLECTOR(376, "Please don't touch anything while I'm distracted.")
            c\start_animation("E_distracted")
            c._animations["E_talk"]\toggle_visibility("headphones")
            c._animations["E_stand"]\toggle_visibility("headphones")
            c._animations["E_distracted"]\toggle_visibility("headphones")


            g.collector_distracted = true
            wait 1
    cassette: ->
        ines = g.characters.ines
        c = g.characters.collector
        g.blocking_thread ->
            g.triedToGiveCassette = true
            say ines, INES(69, "Here.")
            ines\start_animation_thread("W_pick_high")
            wait 0.1
            inventory\remove("cassette")
            ines\start_animation_thread("W_stand")
            say c, COLLECTOR(377, "What's this?")
            if not g.know_about_tape
                say ines, INES(70, "It's a demo tape from the band who used to own this van.")
            else
                say ines, INES(71, "It's the demo tape you wanted so badly.")
            say c, COLLECTOR(378, "Impossible, this cassette looks brand new.")
            say c, COLLECTOR(379, "You want me to believe it's from the sixties?")
            say ines, INES(72, "It is, I swear!")
            wait 1
            say c, COLLECTOR(380, "A likely tale, future-girl.")
            say c, COLLECTOR(381, "Take this garbage back.")
            ines\start_animation_thread("W_pick_high")
            wait 0.1
            inventory\add("cassette")
            ines\start_animation_thread("W_stand")
            collector.use.cassette = nil

}

collector.use_nowalk = {
    cassette: ->
        ines = g.characters.ines
        g.blocking_thread ->
            say ines, INES(73, "I already tried, she doesn't believe it's the real thing.")
            say ines, INES(74, "Doesn't look old enough.")

}

common.drawer_setup(room)

pick = room._objects.pick
poster = room._objects.poster

pick.look_text = -> LOOK(75, "Fishy.")
pick.hotspot_text = -> TEXT(76, "pick")
pick.interact_position = Vec2(35, 96)
pick.interact = ->
    ines = g.characters.ines
    g.blocking_thread ->
        ines\start_animation_thread("E_pick_high")
        wait 0.1
        inventory\add("pick")
        g.got_pick = true
        poster\start_animation("no_pick", true)
        pick.hidden = true

        ines\start_animation_thread("E_stand")
        ines\face2("E")
        wait 0.5
        say ines, INES(77, "They used the actual pick to make the poster.")
        wait 0.2
        ines\face2("S")
        wait 0.2
        say ines, INES(78, "A completely normal and sane thing to do.")

pick.hidden = true

poster.look_text = -> 
    if not g.poster_changed
        LOOK(79, "A striking pose. The composition drives the focus to the pick.")
    else
        LOOK(80, "Ahead of its time. Hey, wasn't it different before?")
poster.hotspot_text = -> TEXT(81, "poster")
poster.interact_direction = "E"
poster.interact_position = pick.interact_position 
poster.interact = ->
    ines = g.characters.ines
    g.blocking_thread ->
        say ines, INES(82, "Hey, the pick the guitar player is holding doesn't look flat.")
        ines\face2("S")
        say ines, INES(83, "That is what artists would call \"in relief\".")
        poster.interact = nil
        pick.hidden = false

new_poster = room._objects.new_poster
poster_en = love.graphics.newImage("assets/single_sprites/poster_english.png")
poster_tr = love.graphics.newImage("assets/single_sprites/poster_translated.png")
new_poster._image = -> lc.tr_text == require("text_english") and poster_en or poster_tr
new_poster.hidden = true


recorder = room._objects.recorder
recorder.interact_position = Vec2(123, 99)
recorder.interact_direction = "N"
recorder.look_text = -> LOOK(84, "An old style red tape recorder. I must have it.")
recorder.hotspot_text = -> TEXT(85, "tape recorder")
recorder.interact = ->
    ines = g.characters.ines
    c = g.characters.collector

    g.blocking_thread ->
        g.at_recorder_spot = true
        wait 0.3
        ines\start_animation_thread("take_recorder")
        wait 0.3
        if g.collector_looking
            ines\start_animation_thread("N_stand")
            say c, COLLECTOR(382, "Leave that alone!")
            say c, COLLECTOR(383, "It's priceless.")
            ines\face2("N")
            wait 0.1
            say ines, INES(86, "Drats.")
        else
            inventory\add("recorder")
            recorder.hidden = true
            ines\start_animation_thread("N_stand")
            wait 0.5
            ines\face2("E")
            wait 0.1
            say ines, INES(87, "Heh heh.")


g.start_thread ->
    wait_frame() -- wait so that g.characters is defined when it's called
    ines = g.characters.ines
    c = g.characters.collector
    warning = false
    while true
        if lc.game.room == room
            if g.collector_distracted
                break
            if ines._wlk.moving
                c\face2("E")
                if not g.collector_looking
                    g.collector_looking = true
                    g.start_thread ->
                        say c, COLLECTOR(384, "Uh, it's you again.")
            if not warning and ines._position.x < 82
                warning = true
                ines\stop_walking()
                g.interaction_thread\stop() if g.interaction_thread
                g.blocking_thread ->
                    c\face2("E")
                    say c, COLLECTOR(385, "HEY!")
                    say c, COLLECTOR(386, "Get away from there!")
                    ines\walk_thread(collector.interact_position\unpack())
                    say c, COLLECTOR(387, "I don't want you anywhere near my one-of-a-kind poster.")
                    warning = false
        else
            if ines._position ~= recorder.interact_position
                g.at_recorder_spot = false
        wait_frame()


plant = room._objects.plant
plant.hotspot_text = -> TEXT(88, "plant")
plant.look_text = -> LOOK(89, "Is this the same plant that uncle Lee keeps in the van?")
plant.interact_position = Vec2(42, 96)
plant.interact_direction = "W"

plant.use = {
    device_new2: ->
        ines = g.characters.ines
        shake = require "shake"
        g.blocking_thread ->
            ines\face2("S")
            say ines, INES(90, "So...")
            say ines, INES(91, "...I found the working device that I gave uncle Lee in the plant vase.")
            say ines, INES(92, "Which I guess was actually the very same device I have now.")
            say ines, INES(93, "So to solve the inconsistency I have to put this in here, so past me can find it in the future.")
            say ines, INES(94, "Which is actually the present.")
            wait 1
            say ines, INES(95, "...man.")
            say ines, INES(96, "Time travel is TRIPPY.")
            wait 1
            ines\face2("W")
            say ines, INES(97, "I'll put the device inside the vase and then press the button from there.")
            ines\start_animation_thread("W_pick_low")
            wait 0.3
            inventory\remove("device_new2")
            wait 0.5
            lc.dialogues\new(require "dialogues.ending")
}

books = room._objects.books
books.hotspot_text = -> TEXT(98, "books")
books.look_text = -> LOOK(99, "They're all copies of the same book: \"A Band with No Drums\".")

cds = room._objects.cds
cds.hotspot_text = -> TEXT(100, "CDs")
cds.look_text = -> LOOK(101, "They look newer than the rest of the stuff here.")

lps = room._objects.lps
lps.hotspot_text = -> TEXT(102, "LPs")
lps.look_text = -> LOOK(103, "A bunch of vynils. Yes, I'm old enough to know what those are.")

stereo = room._objects.stereo
stereo.hotspot_text = -> TEXT(104, "stereo")
stereo.look_text = -> LOOK(105, "State-of-the-art. Or at least it would have been a few decades ago.")
   

return room
