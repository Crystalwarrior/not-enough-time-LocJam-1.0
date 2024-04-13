local g = require("global")
local audio = require("audio")
local skip = require("skip")
local ines, andrea, paolo, peppe
do
  local _obj_0 = g.characters
  ines, andrea, paolo, peppe = _obj_0.ines, _obj_0.andrea, _obj_0.paolo, _obj_0.peppe
end
local inventory = require("inventory")
local asked_band = false

if not g.flags.asked_borrow then
  -- default value
  g.flags.asked_borrow = 0
end

return {
  main = function()
    if not g.flags.talked_to_wilson then
      return intro()
    else
      say(ines, INES(175, "Hello."))
      return options()
    end
  end,
  leave = function()
    if g.flags.recorder_on then
      ines:face2("S")
      g.flags.recorder_on = false
      if not g.flags.recorded then
        say(ines, INES(176, "Nothing worth recording."))
        say(ines, INES(177, "These guys are boring."))
      else
        say(ines, INES(178, "There."))
        say(ines, INES(179, "I wonder if this tape will be worth something one day."))
        inventory:remove("recorder")
        inventory:add("cassette")
        g:saveGame()
      end
    end
    return exit()
  end,
  intro = function()
    say(paolo, PAOLO(432, "Guys, you won't believe what I'm seeing!"))
    wait(1)
    say(paolo, PAOLO(433, "It's this grumpy girl with GREEN hair!"))
    say(paolo, PAOLO(434, "She looks MAD."))
    say(andrea, ANDREA(435, "We can all see her, you doofus."))
    say(peppe, PEPPE(436, "Must be another time-traveller."))
    say(paolo, PAOLO(437, "Woah."))
    g.flags.talked_to_wilson = true
    g:saveGame()
    return leave()
  end,
  options = function()
    if not g.flags.asked_band then
      option(ECHO(180, "So you're a band, uh?"), function()
        g.flags.asked_band = true
        echo(ines)
        say(andrea, ANDREA(438, "What gave it away?"))
        option(ECHO(181, "The guitars, duh."), function()
          echo(ines)
          say(paolo, PAOLO(439, "Why wasn't \"the drums\" one of the four options?"))
          return options_band()
        end)
        option(ECHO(182, "The unkept yet elaborate hairdos and the rebellious attitude."), function()
          echo(ines)
          say(peppe, PEPPE(440, "Look who's talking."))
          return options_band()
        end)
        option(ECHO(183, "Instinct."), function()
          echo(ines)
          say(andrea, ANDREA(441, "Sure."))
          return options_band()
        end)
        option(ECHO(184, "The hotspot label."), function()
          echo(ines)
          say(peppe, PEPPE(442, "Technically that doesn't say we are a band."))
          say(ines, INES(185, "Aren't you?"))
          say(peppe, PEPPE(443, "...yes."))
          return options_band()
        end)
        return selection()
      end)
    else
      option(ECHO(186, "About your band..."), function()
        echo(ines)
        return options_band()
      end)
    end
    if g.flags.device_analyzed then
      if not g.flags.got_coin or not g.flags.got_guitar then
        option(ECHO(187, "I'm looking for something."), function()
          echo(ines)
          return options_looking()
        end)
      end
    end
    option(ECHO(188, "That's all."), function()
      echo(ines)
      local i = love.math.random(1, 3)
      local _exp_0 = i
      if 1 == _exp_0 then
        say(andrea, ANDREA(444, "Bye."))
      elseif 2 == _exp_0 then
        say(paolo, PAOLO(445, "I don't trust you, green-haired vision."))
      elseif 3 == _exp_0 then
        say(peppe, PEPPE(446, "Feel free to stay and explore our humble van."))
      end
      return leave()
    end)
    return selection()
  end,
  options_band = function()
    g:saveGame()
    option(ECHO(189, "Is this van your reharsal space?"), function()
      echo(ines)
      say(paolo, PAOLO(447, "Yes, we had it custom built."))
      wait(1)
      say(andrea, ANDREA(448, "We also sleep here."))
      say(ines, INES(190, "Ingenious."))
      say(peppe, PEPPE(449, "We had to sell our houses to afford it."))
      say(paolo, PAOLO(450, "And my drums."))
      say(andrea, ANDREA(451, "But we have no regrets."))
      say(peppe, PEPPE(452, "Best decision of our lives."))
      wait(1)
      return options_band()
    end)
    option(ECHO(191, "Aren't you missing a drumkit?"), function()
      echo(ines)
      say(paolo, PAOLO(453, "Yes."))
      wait(1)
      say(ines, INES(192, "...isn't that a problem?"))
      say(paolo, PAOLO(454, "No."))
      return options_band()
    end)
    option(ECHO(193, "Are you working on some song?"), function()
      echo(ines)
      say(peppe, PEPPE(455, "We are, as a matter of fact."))
      say(andrea, ANDREA(456, "Our best one yet."))
      say(paolo, PAOLO(457, "We'll play it for you."))
      peppe:start_animation("play_anticipation", true)
      paolo:start_animation("play_anticipation", true)
      andrea:start_animation("play_anticipation", true)
      if g.flags.recorder_on then
        ines:face2("S")
        say(ines, INES(194, "I should probably record this."))
        ines:face2("W")
      else
        say(ines, INES(195, "That's not necessary--"))
      end
      skip:start()
      audio.start_oneshot("wilson")
      wait(0.1)
      peppe:start_animation("play_loop", false)
      paolo:start_animation("play_loop", false)
      andrea:start_animation("play_loop", false)
      wait(17)
      peppe:start_animation("E_stand", false)
      paolo:start_animation("E_stand", false)
      andrea:start_animation("E_stand", false)
      wait(1)
      audio:restart_music()
      skip:stop()
      wait_frame()
      if g.flags.recorder_on then
        g.flags.recorded = true
        return leave()
      else
        say(ines, INES(196, "That was relatively painless."))
        say(paolo, PAOLO(458, "Woah, that would be a cool name for an album."))
        return options_band()
      end
    end)
    option(ECHO(197, "Enough about you guys."), function()
      echo(ines)
      return options()
    end)
    return selection()
  end,
  options_looking = function()
    if not g.flags.asked_for_guitar then
      g.flags.asked_for_guitar = true
      say(paolo, PAOLO(459, "We're fresh out."))
      say(andrea, ANDREA(460, "And before you ask..."))
      say(peppe, PEPPE(461, "...the one in the back is for private use."))
      wait(1)
      say(ines, INES(198, "What!?"))
      say(ines, INES(199, "That's not what I meant."))
      say(ines, INES(200, "Why would you assume that?"))
      say(andrea, ANDREA(462, "Well, that's what the moustached guy usually wants."))
      say(paolo, PAOLO(463, "Funny chap."))
      wait(1)
      say(ines, INES(201, "...of course."))
    end
    g:saveGame()
    if not g.flags.got_coin then
      option(ECHO(202, "You guys wouldn't happen to have some gold hidden somewhere, uh?"), function()
        echo(ines)
        say(paolo, PAOLO(464, "You're not the first one to ask today."))
        say(peppe, PEPPE(465, "I was the first."))
        say(andrea, ANDREA(466, "I was a close second."))
        wait(1)
        say(paolo, PAOLO(467, "Anyway, there's no gold in this game."))
        say(ines, INES(203, "Damn."))
        return options_looking()
      end)
    end
    if not g.flags.asked_magnets_once or not g.flags.asked_about_magnets then
      option(ECHO(204, "Magnets. I need magnets."), function()
        g.flags.asked_magnets_once = true
        echo(ines)
        say(ines, INES(205, "Do you have any?"))
        say(peppe, PEPPE(468, "I don't think so."))
        say(andrea, ANDREA(469, "Improbable."))
        say(paolo, PAOLO(470, "I'd say quite unlikely."))
        say(ines, INES(206, "Damn."))
        return options_looking()
      end)
    elseif not g.flags.know_musicians_have_magnets then
      option(ECHO(207, "Are you REALLY sure you don't have magnets?"), function()
        g.flags.know_musicians_have_magnets = true
        echo(ines)
        say(andrea, ANDREA(471, "Quite sure."))
        say(peppe, PEPPE(472, "We have no reason to lie to you."))
        say(paolo, PAOLO(473, "Speak for yourself."))
        wait(1)
        say(ines, INES(208, "Well, I've been told that guitars have magnets in them."))
        wait(2)
        say(paolo, PAOLO(474, "Guitars have magnets in them!?"))
        say(andrea, ANDREA(475, "Woah!"))
        say(peppe, PEPPE(476, "Man, that's so cool!"))
        wait(1)
        say(peppe, PEPPE(477, "I guess we have magnets, then."))
        return options_looking()
      end)
    elseif not g.flags.got_guitar then
      if g.flags.asked_borrow == 0 then
        option(ECHO(209, "Can I borrow one of your guitars?"), function()
          g.flags.asked_borrow = 1
          echo(ines)
          say(paolo, PAOLO(478, "Sure, why n--"))
          say(andrea, ANDREA(479, "Absolutely not!"))
          say(peppe, PEPPE(480, "We need them."))
          say(andrea, ANDREA(481, "You know, being a band and all."))
          wait(1)
          say(ines, INES(210, "You don't have any backup ones?"))
          say(peppe, PEPPE(482, "Well, now that I think of it..."))
          say(andrea, ANDREA(483, "...we do have plenty in the deposit."))
          wait(1)
          say(ines, INES(211, "So, can I have one?"))
          say(peppe, PEPPE(484, "No."))
          return options_looking()
        end)
      else
        option(ECHO(212, "Is there anything I can do to persuade you to give me a guitar?"), function()
          if g.flags.asked_borrow == 1 then
            echo(ines)
            g.flags.asked_borrow = 2
            say(peppe, PEPPE(485, "Nope."))
            say(andrea, ANDREA(486, "Not a chance."))
            wait(1)
            say(paolo, PAOLO(487, "Guys, what about..."))
            say(paolo, PAOLO(488, "...THE PICK?"))
            wait(1)
            say(peppe, PEPPE(489, "Right."))
            say(peppe, PEPPE(490, "THE PICK."))
            wait(1)
            say(ines, INES(213, "The pick?"))
            say(peppe, PEPPE(491, "I used to have this guitar pick a while back."))
            say(peppe, PEPPE(492, "It was a true and faithful pick."))
            say(peppe, PEPPE(493, "It always listened, without judging."))
            say(paolo, PAOLO(494, "It always laughed at all of my jokes."))
            say(andrea, ANDREA(495, "It was basically the fourth member of the band."))
            say(paolo, PAOLO(496, "But we lost it one day, during practice."))
            say(peppe, PEPPE(497, "A day most foul."))
            say(andrea, ANDREA(498, "May it rest in peace."))
            wait(2)
            say(ines, INES(214, "...I see."))
            option(ECHO(215, "Would you give me a guitar if I found your pick?"), pick)
            return selection()
          else
            -- failsafe if the flag failed to trigger somehow
            g.flags.know_about_pick = true
            echo(ines)
            say(peppe, PEPPE(499, "Find my missing pick and we have a deal."))
            return options_looking()
          end
        end)
      end
    end
    option(ECHO(216, "Never mind."), function()
      echo(ines)
      return options()
    end)
    return selection()
  end,
  pick = function()
    echo(ines)
    say(peppe, PEPPE(500, "Sure!"))
    say(peppe, PEPPE(501, "It's way more valuable that anything or anyone in this van!"))
    say(andrea, ANDREA(502, "Hey!"))
    say(paolo, PAOLO(503, "No, he's right."))
    wait(1)
    say(ines, INES(217, "Any idea where it could be?"))
    say(peppe, PEPPE(504, "Somewhere in Woodstock, I guess."))
    wait(1)
    say(ines, INES(218, "Of course."))
    g.flags.know_about_pick = true
    g:saveGame()
    return options_looking()
  end
}
