local g = require("global")
local ines, collector
do
  local _obj_0 = g.characters
  ines, collector = _obj_0.ines, _obj_0.collector
end
local collect_list = {
  idx = 1,
  function()
    return ECHO(219, "Do you collect leather jackets?")
  end,
  function()
    return ECHO(220, "Do you collect gold barometers?")
  end,
  function()
    return ECHO(221, "Do you collect medieval instruments of torture?")
  end,
  function()
    return ECHO(222, "Do you collect oddly shaped vegetables?")
  end,
  function()
    return ECHO(223, "Do you collect angsty teenage poetry?")
  end,
  function()
    return ECHO(224, "Do you collect seafood miniatures?")
  end,
  function()
    return ECHO(225, "Do you collect TV series from the early 2000s?")
  end,
  function()
    return ECHO(226, "Do you collect pulp magazines from the fifties?")
  end,
  {
    (function()
      return ECHO(227, "Do you collect my yearly class photos?")
    end),
    (function()
      return INES(228, "Whew.")
    end)
  },
  function()
    return ECHO(229, "Do you collect sports almanacs?")
  end,
  function()
    return ECHO(230, "Do you collect bags of chips with a prize in them?")
  end,
  function()
    return ECHO(231, "Do you collect indecent keychains?")
  end,
  function()
    return ECHO(232, "Do you collect decent keychains?")
  end,
  function()
    return ECHO(233, "Do you collect grossly overstated music themes?")
  end,
  function()
    return ECHO(234, "Do you collect no-longer-intact swords?")
  end,
  function()
    return ECHO(235, "Do you collect collectors?")
  end
}
return {
  main = function()
    if not g.flags.collector_intro then
      return intro()
    else
      say(ines, INES(236, "Hello."))
      collector:face2("E")
      say(collector, COLLECTOR(505, "You're still here."))
      return options()
    end
  end,
  leave = function()
    if g.flags.collector_distracted then
      collector:start_animation("E_distracted")
    end
    return exit()
  end,
  intro = function()
    collector:face2("E")
    say(collector, COLLECTOR(506, "WHO ARE YOU!?"))
    wait(1)
    say(ines, INES(237, "...time traveller, I guess?"))
    say(collector, COLLECTOR(507, "Oh no, are you associated with that weird guy with the big moustache?"))
    say(ines, INES(238, "Hey, only I can call uncle Lee \"weird\"."))
    wait(1)
    say(collector, COLLECTOR(508, "Whatever."))
    say(collector, COLLECTOR(509, "Leave."))
    say(collector, COLLECTOR(510, "NOW."))
    wait(1)
    say(collector, COLLECTOR(511, "Or at least don't touch anything."))
    g.flags.collector_intro = true
    g:saveGame()
    return leave()
  end,
  options = function()
    g:saveGame()
    if not g.flags.know_who_collector_is then
      option(ECHO(239, "The van looks different."), function()
        g.flags.know_who_collector_is = true
        echo(ines)
        say(ines, INES(240, "What's all this junk?"))
        say(collector, COLLECTOR(512, "Junk?"))
        say(collector, COLLECTOR(513, "JUNK!?"))
        say(collector, COLLECTOR(514, "This is a collection of the highest value!"))
        wait(1)
        say(collector, COLLECTOR(515, "You wouldn't understand."))
        say(ines, INES(241, "Are you a collector?"))
        say(collector, COLLECTOR(516, "I am THE collector."))
        
        return options()
      end)
    else
      option(ECHO(242, "What kind of stuff do you collect?"), function()
        echo(ines)
        say(collector, COLLECTOR(517, "Please refrain from referring to these priceless artifacts as *stuff*."))
        say(collector, COLLECTOR(518, "I specialise in objects about and/or previously owned by THE BAND."))
        say(collector, COLLECTOR(519, "I have posters, EPs, LPs, CD remasters (that I made myself)..."))
        say(collector, COLLECTOR(520, "...even these very walls were owned by THE BAND."))
        say(ines, INES(243, "You mean the van?"))
        say(collector, COLLECTOR(521, "It's the ultimate collection."))
        if not (g.flags.collector_distracted) then
          wait(1)
          say(collector, COLLECTOR(522, "...or it would be, if only..."))
        end
        return collect_options()
      end)
    end
    option(ECHO(244, "Fine, I'll leave."), function()
      echo(ines)
      say(collector, COLLECTOR(523, "Wonderful."))
      return leave()
    end)
    return selection()
  end,
  collect_options = function()
    g:saveGame()
    if g.flags.know_about_pick and not g.flags.got_pick then
      option(ECHO(245, "Do you have the band's lost pick?"), function()
        echo(ines)
        say(collector, COLLECTOR(524, "Which one?"))
        say(collector, COLLECTOR(525, "Do you have any idea of how many picks a band can lose over their career?"))
        say(collector, COLLECTOR(526, "I have hundreds!"))
        say(ines, INES(246, "The... the important one?"))
        say(collector, COLLECTOR(527, "They are ALL important!"))
        say(collector, COLLECTOR(528, "They belonged to THE BAND!"))
        say(ines, INES(247, "...man."))
        return collect_options()
      end)
    end
    if not (g.flags.collector_distracted) then
      option(ECHO(248, "Is your collection missing something?"), function()
        echo(ines)
        say(collector, COLLECTOR(529, "Legend says that THE BAND wrote a most magnificent song."))
        say(collector, COLLECTOR(530, "A song so heavenly that nearby birds who heard it would sing it too."))
        say(collector, COLLECTOR(531, "Unfortunately, the song was lost."))
        say(collector, COLLECTOR(532, "There are rumours, however, that a recording has been made."))
        wait(1)
        say(collector, COLLECTOR(533, "A DEMO TAPE!!!"))
        wait(1)
        say(collector, COLLECTOR(534, "...I'd really like to have that."))
        wait(1)
        say(ines, INES(249, "I see."))
        g.flags.know_about_tape = true
        return collect_options()
      end)
    end
    if g.flags.device_analyzed then
      if not g.flags.got_coin then
        option(ECHO(250, "Do you collect any gold?"), function()
          echo(ines)
          say(collector, COLLECTOR(535, "No, there's no gold in this game."))
          say(ines, INES(251, "Damn."))
          return collect_options()
        end)
      end
      if not g.flags.got_guitar then
        option(ECHO(252, "Do you collect any magnets?"), function()
          echo(ines)
          if not g.flags.asked_about_magnets then
            g.flags.asked_about_magnets = true
            say(collector, COLLECTOR(536, "What kind of weirdo would collect raw magnets?"))
            wait(1)
            say(ines, INES(253, "...uncle Lee."))
            wait(0.5)
            say(ines, INES(254, "Do you collect anything that has magnets INSIDE?"))
            say(collector, COLLECTOR(537, "The guitars, I guess."))
            say(ines, INES(255, "Guitars have magnets in them!?"))
            say(collector, COLLECTOR(538, "Of course they do."))
            say(ines, INES(256, "Cool!"))
            wait(1)
            say(ines, INES(257, "...I don't see any guitars."))
            say(collector, COLLECTOR(539, "They are in the deposit."))
            say(collector, COLLECTOR(540, "It's a rotating collection."))
            say(ines, INES(258, "Damn."))
            
          else
            say(collector, COLLECTOR(541, "I told you, the guitars have magnets in them."))
            say(collector, COLLECTOR(542, "But I don't have any here."))
          end
          return collect_options()
        end)
      end
    end
    local t = collect_list[collect_list.idx]
    option(type(t) == "table" and t[1]() or t(), function()
      echo(ines)
      say(collector, COLLECTOR(543, "No."))
      if type(t) == "table" then
        say(ines, t[2]())
      end
      if collect_list.idx == #collect_list then
        collect_list.idx = 1
      else
        collect_list.idx = collect_list.idx + 1
      end
      return collect_options()
    end)
    option(ECHO(259, "Boring."), function()
      echo(ines)
      return options()
    end)
    return selection()
  end
}
