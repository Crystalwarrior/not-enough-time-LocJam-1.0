g = require "global"
audio = require "audio"
import ines, lee, collector, peppe, paolo, andrea from g.characters
-- tunnel = require "tunnel"
road = require "road"
vortex = require "vortex"
-- inventory = require "inventory"
skip = require "skip"
shake = require "shake"
lc = require "engine"

ui_inventory = require "ui.inventory"


return {
    main: ->
        skip\start()

        room = g.rooms.present
        t = g.switch_room(room)
        wait_signal(t, "finished")
        vortex.on = false
        road.on = true
        road.use_tunnel_shader = false

        lee._shader = nil
        lee\change_room(room)

        ui_inventory.hidden = true
        lc.game.set_room(room)
        ines\change_room(room, ines._position\unpack())
        ines\start_animation_thread("W_stand")
        wait 0.5
        ines\face2("E")
        wait 0.5
        ines\face2("W")
        wait 0.5
        ines\face2("E")
        say ines, INES(316, "Is it over?")
        say ines, INES(317, "Is this the right time?")
        say lee, LEE(593, "Ines, dear!")
        ines\walk_thread(room._objects.lee.interact_position\unpack())
        say lee, LEE(594, "You made it!")
        say lee, LEE(595, "What took you so long?")
        say ines, INES(318, "WHAT DO YOU MEAN WHAT TOOK ME SO LONG!?")
        say ines, INES(319, "YOU LEFT ME STRANDED IN A TIME TUNNEL!")
        say lee, LEE(596, "I did?")
        say ines, INES(320, "Your stupid button only worked on you!")
        say lee, LEE(597, "Oh yes, I forgot about that.")
        wait 1
        say lee, LEE(598, "Well, you seem to have made it in one piece.")
        say lee, LEE(599, "You've always been very resourceful.")
        wait 1
        say ines, INES(321, "*Grumble*")
        wait 1
        say lee, LEE(600, "You didn't change anything in the past, did you?")
        wait 1
        say ines, INES(322, "Ehm...")
        say ines, INES(323, "Define \"change\".")
        say lee, LEE(601, "Oh my.")
        say lee, LEE(602, "You may want to take a few steps forward.")
        ines\walk_thread(200, 102)
        ines\face2("W")
        wait 0.5
        shake\start()
        wait_signal(shake, "finished")

        collector\change_room(room, 152, 5)
        collector._spk.point.x = collector._position.x
        peppe\change_room(room)
        paolo\change_room(room)
        andrea\change_room(room)

        collector\face2("E")
        collector\start_animation("E_stand")\set_visibility("headphones", false)
        collector._animations.E_talk\set_visibility("headphones", false)

        wait 1
        say collector, COLLECTOR(603, "What's going on here?")
        say ines, INES(324, "Oh no.")
        say collector, COLLECTOR(604, "Where's my collection!?")
        say paolo, PAOLO(605, "Woah!")
        collector\face2("W")
        wait 1
        say collector, COLLECTOR(606, "Oh.")
        say collector, COLLECTOR(607, "My.")
        say collector, COLLECTOR(608, "God.")
        say collector, COLLECTOR(609, "Are you...?")
        say andrea, ANDREA(610, "Guys, look at those eyes!")
        say paolo, PAOLO(611, "I think she's...")
        say paolo, PAOLO(612, "...A FAN!")
        say peppe, PEPPE(613, "Have you noticed that all our fans are a bit on the grumpy side?")
        say ines, INES(325, "I'm not your fan!")
        say lee, LEE(614, "I'm not grumpy!")
        collector\face2("E")
        wait 0.5
        say collector, COLLECTOR(615, "IT'S THE BAND!")
        say ines, INES(326, "What have I done.")

        wait 1
        say lee, LEE(616, "WHO WANTS TO GO TO LAKE FENFEF?")

        say peppe, PEPPE(617, "Me! Me!")
        say andrea, ANDREA(618, "Lake what?")
        say paolo, PAOLO(619, "Road trip! Yeah!")

        collector\face2("W")
        wait 0.2
        say collector, COLLECTOR(620, "I'll go wherever they go.")

        wait 1

        say ines, INES(327, "Shouldn't we try to send them back to their own timelines?")
        say lee, LEE(621, "Nah, we'll figure that out later.")
        say lee, LEE(622, "There's enough time.")
        wait 0.5
        ines\face2("S")
        wait 2
        ines\face2("W")

        skip\stop()


        wait 1

        say lee, LEE(623, "So, have you learned anything useful from this experience?")


        option ECHO(328, "Never trust your devices."), ->
            echo ines
            say lee, LEE(624, "You say that every time.")
            
        option ECHO(329, "You are even weirder in the future."), ->
            echo ines
            say lee, LEE(625, "I should hope so, I practice every day.")
        option ECHO(330, "I should run for President."), ->
            echo ines
            say lee, LEE(626, "\"President Ines\".")
            say lee, LEE(627, "Has a nice ring to it.")
        option ECHO(331, "Never pay $0 for a pay-what-you-want point & click adventure game."), ->
            echo ines
            say lee, LEE(628, "Wise words.")

        selection()

        wait 2
        say lee, LEE(629, "OK KIDS!")
        say lee, LEE(630, "LET'S SING SOME TRAVEL SONGS!")
        audio.start_oneshot("stop")
        say paolo, PAOLO(631, "We'll play!")
        say collector, COLLECTOR(632, "YES!!!")
        wait_frame()
        wait_frame()

        peppe\start_animation("play_anticipation", true)
        paolo\start_animation("play_anticipation", true)
        andrea\start_animation("play_anticipation", true)

        wait 1
        audio.stop_music()
        audio.start_music()
        audio.switch_room(g.rooms.past)
        peppe\start_animation("play_loop", false)
        paolo\start_animation("play_loop", false)
        andrea\start_animation("play_loop", false)
        collector\start_animation("W_distracted")\set_visibility("headphones", false)

        wait 2
        say ines, INES(332, "...this will be a long trip.")

        wait 3
        room._objects.exterior.hidden = false
        audio.set_parameter("room", 4)
        wait 1
        
        g.ending_shift = 0
        while g.ending_shift < g.game_width
            dt = wait_frame()
            g.ending_shift += 100*dt

        require "credits"
        while true
            wait_frame()
















        
        -- skip\start()

        

}