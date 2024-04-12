g = require "global"
audio = require "audio"
import ines, lee from g.characters
tunnel = require "tunnel"
road = require "road"
vortex = require "vortex"
inventory = require "inventory"
skip = require "skip"

cutscene_done = false
asked_navigator_what = false
asked_navigator_why = false
asked_van = false

return {
    main: ->
        if not cutscene_done
            cutscene()
        else
            regular()
            

    cutscene: ->

        skip\start()

        wait 1

        g.rooms.present._objects.exterior.hidden = true
        g.intro = false
    
        audio.start_music()
        audio.set_parameter("room", 2)

        wait 2       
        ines\face2("E")
        say ines, INES(144, "Uncle Lee, are you sure you don't want me to drive?")
        say lee, LEE(391, "It's ok, Ines dear! Just enjoy the view.")
        say ines, INES(145, "I would enjoy it more if you kept your eyes on the road.")
        say lee, LEE(392, "I saw it plenty of times, there's nothing special about it.")
        say ines, INES(146, "*Sigh* Are you sure you are going in the right direction, at least?")
        tunnel.on = true
        say lee, LEE(393, "Why of course! I could drive us to Lake Fenfef with my eyes closed!")
        say ines, INES(147, "That wouldn't be very different from what you are doing now.")
        wait(1)
        t = love.timer.getTime()
        while tunnel.intensity < 1
            wait_frame()
            newt = love.timer.getTime()
            dt = newt - t
            dt *= g.time_rate
            t = newt
            tunnel\set_intensity(tunnel.intensity + 0.3*dt)
        
        road.on = false
        wait 2
        say ines, INES(148, "...haven't we been in this tunnel for a while now?")
        say lee, LEE(394, "These tunnels seem ENDLESS!")
        wait 0.5
        say ines, INES(149, "Uncle Lee.")
        wait 0.5
        say lee, LEE(395, "Oh my.")
        tunnel.on = false
        vortex.on = true
        skip\stop()
        skip\start()
        -- unless skip.skipping
        audio.start_oneshot("danger")

        wait 12

        say ines, INES(150, "UNCLE LEE.")


        say lee, LEE(396, "I must have sat on the temporal navigator.")
        say lee, LEE(397, "That's why I couldn't find it anywhere.")
        say ines, INES(151, "TEMPORAL NAVIGATOR!?")

        say lee, LEE(398, "Nothing to worry about.")
        say lee, LEE(399, "I carry around this reality-fixing device™ just for these occasions.")
        wait 1
        lee\start_animation_thread("remote_up")
        wait 0.5
        lee\start_animation_thread("remote_down")
        wait 0.5
        say lee, LEE(400, "Oh. I think it's broken.")
        say ines, INES(152, "Wonderful.")
        say lee, LEE(401, "There should be a spare one somewhere around here.")
        wait 1
        say lee, LEE(402, "Keep this one too.")
        ines\walk_thread(142, 96)
        ines\start_animation_thread("E_pick_high")
        wait 0.5
        ines\start_animation_thread("E_stand")
        inventory\add("device_old")
        require("ui.inventory").hidden = false

        cutscene_done = true
        audio\restart_music()
        skip\stop()
        exit()      

    regular: ->
        say ines, INES(153, "Uncle Lee?")
        say lee, LEE(403, "Yes, dear?")
        regular_options()
        
    regular_options: ->
        unless inventory\has("device_new")
            option ECHO(154, "Where should I look for the device?"), device
        option ECHO(155, "What's this temporal navigator?"), navigator
        option ECHO(156, "This van looks bigger than it should be."), van
        option ECHO(157, "OK, bye."), ->
            echo ines
            say lee, LEE(404, "Bye!")
            exit()

        selection()

    device: ->
        echo ines
        say lee, LEE(405, "I don't know.")
        say lee, LEE(406, "Where would YOU have put it?")
        wait 1
        say ines, INES(158, "ME!?")
        say ines, INES(159, "You're the one who put it away!")
        say lee, LEE(407, "Allegedly.")
        regular_options()

    navigator: ->
        echo ines
        say lee, LEE(408, "It's my latest (and greatest) invention!")
        say lee, LEE(409, "It's so new that I didn't add the ™ to the name yet!")
        navigator_options()

    navigator_options: ->
        if not asked_navigator_what
            option ECHO(160, "What does it do?"), navigator2
        else
            option ECHO(161, "Remind me what it does."), navigator2
        if not asked_navigator_why
            option ECHO(162, "Why would you make such a thing?"), navigator3
        else
            option ECHO(163, "Remind me why you made it?"), navigator3
        option ECHO(164, "Never mind."), ->
            echo ines
            regular_options()
        selection()

    navigator2: ->
        echo ines
        if not asked_navigator_what
            asked_navigator_what = true
            say lee, LEE(410, "What a silly question!")
            say lee, LEE(411, "It's a device to navigate through time.")
            wait 0.5
            say lee, LEE(412, "It's right there in the name.")
            say ines, INES(165, "Isn't that dangerous?")
            say lee, LEE(413, "Not if you know what you are doing.")
            wait 1
            say ines, INES(166, "And do YOU know what you are doing?")
            say lee, LEE(414, "More or less.")
        else
            say lee, LEE(415, "It's a device to navigate through time.")
        navigator_options()

    navigator3: ->
        echo ines
        if not asked_navigator_why
            asked_navigator_why = true
            say lee, LEE(416, "Well, the other day I was cooking and I realised that I ran out of forks.")
            say ines, INES(167, "You shouldn't be using single-use utensils, uncle Lee!")
            say ines, INES(168, "It's bad for the environment!")
            say lee, LEE(417, "Of course, all my forks are reusable.")
            wait 1
            say ines, INES(169, "And you ran out of them?")
            say lee, LEE(418, "Yes.")
            say lee, LEE(419, "As I was saying, I rembembered that I had some the day before.")
            say lee, LEE(420, "So I decided to make a time machine to go back and grab them.")
            wait 1
            say lee, LEE(421, "Come to think of it, that's probably why I ran out in the first place.")
            wait 0.5
            ines\face2("S")
            wait 2
            ines\face2("E")
            wait 1
        else
            say lee, LEE(422, "To go back in time and steal some forks.")
            say lee, LEE(423, "From myself.")
            say ines, INES(170, "Right.")
        navigator_options()


    van: ->
        echo ines
        if not asked_van
            asked_van = true
            say lee, LEE(424, "They tried to draw it with realistic proportions but that wasn't working well.")
            wait 1
            say ines, INES(171, "...what?")
            say lee, LEE(425, "I MEAN, it's because it's a special model. It was custom built for a band of musicians in the sixties.")
            say ines, INES(172, "How did you end up with it?")
            say lee, LEE(426, "I got it from a collector.")
            say ines, INES(173, "That must have been very expensive!")
            say lee, LEE(427, "Expensive?")
            wait 1
            say ines, INES(174, "Uncle Lee, did you steal it?")
            say lee, LEE(428, "I won it, fair and square.")
            wait 1
            say lee, LEE(429, "It's not my fault if she didn't know how to play briscola.")
        else
            say lee, LEE(430, "It's a custom model built for a band of musicians in the sixties.")
            say lee, LEE(431, "I got it from a collector.")
        regular_options()

}