g = require "global"
import ines, collector from g.characters

first_time = true
g.asked_about_magnets = false

collect_list = {
    idx: 1
    -> ECHO(219, "Do you collect leather jackets?")
    -> ECHO(220, "Do you collect gold barometers?")
    -> ECHO(221, "Do you collect medieval instruments of torture?")
    -> ECHO(222, "Do you collect oddly shaped vegetables?")
    -> ECHO(223, "Do you collect angsty teenage poetry?")
    -> ECHO(224, "Do you collect seafood miniatures?")
    -> ECHO(225, "Do you collect TV series from the early 2000s?")
    -> ECHO(226, "Do you collect pulp magazines from the fifties?")
    {(-> ECHO(227, "Do you collect my yearly class photos?")), (-> INES(228, "Whew."))}
    -> ECHO(229, "Do you collect sports almanacs?")
    -> ECHO(230, "Do you collect bags of chips with a prize in them?")
    -> ECHO(231, "Do you collect indecent keychains?")
    -> ECHO(232, "Do you collect decent keychains?")
    -> ECHO(233, "Do you collect grossly overstated music themes?")
    -> ECHO(234, "Do you collect no-longer-intact swords?")
    -> ECHO(235, "Do you collect collectors?")
}

return {
    main: ->
        if first_time
            intro()
        else
            say ines, INES(236, "Hello.")
            collector\face2("E")
            say collector, COLLECTOR(505, "You're still here.")
            options()


    leave: ->
        if g.collector_distracted
            collector\start_animation("E_distracted")
        exit()


    intro: ->
        collector\face2("E")
        say collector, COLLECTOR(506, "WHO ARE YOU!?")
        wait 1
        say ines, INES(237, "...time traveller, I guess?")
        say collector, COLLECTOR(507, "Oh no, are you associated with that weird guy with the big moustache?")
        say ines, INES(238, "Hey, only I can call uncle Lee \"weird\".")
        wait 1
        say collector, COLLECTOR(508, "Whatever.")
        say collector, COLLECTOR(509, "Leave.")
        say collector, COLLECTOR(510, "NOW.")
        wait 1
        say collector, COLLECTOR(511, "Or at least don't touch anything.")

        first_time = false
        leave()     

    options: ->

        if not g.know_who_collector_is
            option ECHO(239, "The van looks different."), ->
                g.know_who_collector_is = true
                echo ines
                say ines, INES(240, "What's all this junk?")
                say collector, COLLECTOR(512, "Junk?")
                say collector, COLLECTOR(513, "JUNK!?")
                say collector, COLLECTOR(514, "This is a collection of the highest value!")
                wait 1
                say collector, COLLECTOR(515, "You wouldn't understand.")
                say ines, INES(241, "Are you a collector?")
                say collector, COLLECTOR(516, "I am THE collector.")
                options()


        else
            option ECHO(242, "What kind of stuff do you collect?"), ->
                echo ines
                say collector, COLLECTOR(517, "Please refrain from referring to these priceless artifacts as *stuff*.")
                say collector, COLLECTOR(518, "I specialise in objects about and/or previously owned by THE BAND.")
                say collector, COLLECTOR(519, "I have posters, EPs, LPs, CD remasters (that I made myself)...")
                say collector, COLLECTOR(520, "...even these very walls were owned by THE BAND.")
                say ines, INES(243, "You mean the van?")
                say collector, COLLECTOR(521, "It's the ultimate collection.")
                unless g.collector_distracted
                    wait 1
                    say collector, COLLECTOR(522, "...or it would be, if only...")
                collect_options()


        option ECHO(244, "Fine, I'll leave."), ->
            echo ines
            say collector, COLLECTOR(523, "Wonderful.")
            leave()

        selection()

    collect_options: ->
        if g.know_about_pick and not g.got_pick
            option ECHO(245, "Do you have the band's lost pick?"), ->
                echo ines
                say collector, COLLECTOR(524, "Which one?")
                say collector, COLLECTOR(525, "Do you have any idea of how many picks a band can lose over their career?")
                say collector, COLLECTOR(526, "I have hundreds!")
                say ines, INES(246, "The... the important one?")
                say collector, COLLECTOR(527, "They are ALL important!")
                say collector, COLLECTOR(528, "They belonged to THE BAND!")
                say ines, INES(247, "...man.")
                collect_options()

        unless g.collector_distracted
            option ECHO(248, "Is your collection missing something?"), ->
                echo ines
                say collector, COLLECTOR(529, "Legend says that THE BAND wrote a most magnificent song.")
                say collector, COLLECTOR(530, "A song so heavenly that nearby birds who heard it would sing it too.")
                say collector, COLLECTOR(531, "Unfortunately, the song was lost.")
                say collector, COLLECTOR(532, "There are rumours, however, that a recording has been made.")
                wait 1
                say collector, COLLECTOR(533, "A DEMO TAPE!!!")
                wait 1
                say collector, COLLECTOR(534, "...I'd really like to have that.")
                wait 1
                say ines, INES(249, "I see.")
                g.know_about_tape = true
                collect_options()

        if g.device_analyzed
            if not g.got_coin
                option ECHO(250, "Do you collect any gold?"), ->
                    echo ines
                    say collector, COLLECTOR(535, "No, there's no gold in this game.")
                    say ines, INES(251, "Damn.")
                    collect_options()
            if not g.got_guitar
                option ECHO(252, "Do you collect any magnets?"), ->
                    echo ines
                    if not g.asked_about_magnets
                        g.asked_about_magnets = true
                        say collector, COLLECTOR(536, "What kind of weirdo would collect raw magnets?")
                        wait 1
                        say ines, INES(253, "...uncle Lee.")
                        wait 0.5
                        say ines, INES(254, "Do you collect anything that has magnets INSIDE?")
                        say collector, COLLECTOR(537, "The guitars, I guess.")
                        say ines, INES(255, "Guitars have magnets in them!?")
                        say collector, COLLECTOR(538, "Of course they do.")
                        say ines, INES(256, "Cool!")
                        wait 1
                        say ines, INES(257, "...I don't see any guitars.")
                        say collector, COLLECTOR(539, "They are in the deposit.")
                        say collector, COLLECTOR(540, "It's a rotating collection.")
                        say ines, INES(258, "Damn.")   
                    else
                        say collector, COLLECTOR(541, "I told you, the guitars have magnets in them.")
                        say collector, COLLECTOR(542, "But I don't have any here.")
                    collect_options()

        t = collect_list[collect_list.idx]
        option type(t) == "table" and t[1]() or t(), ->
            echo ines
            say collector, COLLECTOR(543, "No.")
            if  type(t) == "table"
                say ines, t[2]()

            if collect_list.idx == #collect_list
                collect_list.idx = 1
            else
                collect_list.idx += 1

            collect_options()

        option ECHO(259, "Boring."), ->
            echo ines
            options()


        selection()


        -- option ECHO("Is there anything from the band you don't have and would really like?"), ->
        --     echo ines
        --     say ines, INES("Something so valuable that if I gave it to you you would stop being so mean?")
        --     wait 1
        --     say collector, COLLECTOR("No.")
        --     say collector, COLLECTOR("No.")










}