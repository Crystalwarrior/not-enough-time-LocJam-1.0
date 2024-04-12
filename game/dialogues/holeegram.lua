local g = require("global")
local skip = require("skip")
local ines, holeegram
do
  local _obj_0 = g.characters
  ines, holeegram = _obj_0.ines, _obj_0.holeegram
end
local inventory = require("inventory")
local first_time = true
local first_time_fix = true
local know_president = false
local explain_ingredients = false
return {
  main = function()
    if first_time then
      first_time = false
      g.flags.talked_to_holeegram = true
      return intro()
    elseif g.flags.asked_to_analyze_device and not g.flags.device_analyzed then
      return analyze_device()
    elseif explain_ingredients then
      return ingredients()
    else
      say(ines, INES(260, "I'm back."))
      return options()
    end
  end,
  analyze_device = function()
    g.flags.asked_to_analyze_device = true
    explain_ingredients = true
    say(holeegram, HOLEEGRAM(544, "Put the device in the opening below me, so I can analyse it."))
    return exit()
  end,
  intro = function()
    say(ines, INES(261, "...uncle Lee?"))
    say(holeegram, HOLEEGRAM(545, "Young Ines! I haven't seen you in forever!"))
    wait(1)
    say(ines, INES(262, "...what happened to you?"))
    say(holeegram, HOLEEGRAM(546, "I'm a HOLEEGRAM!"))
    say(ines, INES(263, "Of course you are."))
    say(ines, INES(264, "But why? Did something happen to you?"))
    say(holeegram, HOLEEGRAM(547, "Not at all, I just wanted to try something new."))
    say(holeegram, HOLEEGRAM(548, "I haven't felt this light since I was 105!"))
    say(holeegram, HOLEEGRAM(549, "But enough about me."))
    say(holeegram, HOLEEGRAM(550, "I imagine you got here using my marvellous temporal navigator™."))
    option(NOECHO(265, "I wouldn't call it \"marvellous\"..."), intro2)
    option(NOECHO(266, "You're lucky I cannot punch you."), intro2)
    option(NOECHO(267, "I'm here because you BUTT-DIALED a time machine."), intro2)
    return selection()
  end,
  intro2 = function()
    say(ines, INES(268, "...yes."))
    return options()
  end,
  options = function()
    option(ECHO(269, "How far into the future are we?"), function()
      echo(ines)
      say(holeegram, HOLEEGRAM(551, "Hundreds of years!"))
      return future_options()
    end)
    if first_time_fix then
      option(ECHO(270, "Can you help me get out of this time tunnel?"), function()
        echo(ines)
        first_time_fix = false
        say(holeegram, HOLEEGRAM(552, "Time tunnel?"))
        say(ines, INES(271, "You pressed your fancy button and disappeared, leaving me stranded."))
        say(ines, INES(272, "Does that ring a bell?"))
        say(holeegram, HOLEEGRAM(553, "Oh dear."))
        say(holeegram, HOLEEGRAM(554, "You'll have to be more specific."))
        say(holeegram, HOLEEGRAM(555, "I can think of at least five times that happened."))
        wait(1)
        say(ines, INES(273, "Great."))
        say(ines, INES(274, "The first one, I guess."))
        say(holeegram, HOLEEGRAM(556, "Ah, the Lake Fenfef trip!"))
        say(ines, INES(275, "Yep."))
        say(holeegram, HOLEEGRAM(557, "We'll need to fix your reality-fixing device™, right?"))
        say(ines, INES(276, "I don't know, YOU tell me."))
        wait(1)
        say(holeegram, HOLEEGRAM(558, "We'll need to fix your reality-fixing device™."))
        return analyze_device()
      end)
    elseif not inventory:has("device_new2") then
      option(ECHO(277, "What did you need to fix the device?"), function()
        echo(ines)
        say(holeegram, HOLEEGRAM(559, "I need a MAGNET and the COIN from the museum."))
        say(ines, INES(278, "Got it."))
        if g.flags.got_coin and g.flags.got_guitar then
          return options()
        else
          return ingredients_options()
        end
      end)
      option(ECHO(279, "It's ironic that we need to fix a reality-fixing device."), function()
        echo(ines)
        say(holeegram, HOLEEGRAM(560, "I know."))
        wait(1)
        say(holeegram, HOLEEGRAM(561, "If only I had not lost my reality-fixing-device-fixing device™."))
        option(ECHO(280, "And how would you fix a reality-fixing-device-fixing device™?"), function()
          echo(ines)
          say(holeegram, HOLEEGRAM(562, "Easy, with a reality-fixing-device-fixing-device-fixing device™."))
          wait(1)
          say(holeegram, HOLEEGRAM(563, "That one I have."))
          say(ines, INES(281, "Damn."))
          return options()
        end)
        return selection()
      end)
    end
    if g.flags.seen_president then
      option(ECHO(282, "Do you have any idea how to fix the inconsistency that's preventing me from using the device?"), function()
        echo(ines)
        say(holeegram, HOLEEGRAM(564, "Of course, I specialise in inconsistencies!"))
        say(holeegram, HOLEEGRAM(565, "If I remember correctly I only ever made one of these devices."))
        say(ines, INES(283, "But I remember having two of them at the same time."))
        say(holeegram, HOLEEGRAM(566, "Then maybe the inconsistency has something to do with that."))
        say(ines, INES(284, "...mmm."))
        return options()
      end)
    end
    option(ECHO(285, "OK, see you later."), function()
      echo(ines)
      say(holeegram, HOLEEGRAM(567, "Or earlier!"))
      return exit()
    end)
    return selection()
  end,
  future_options = function()
    option(ECHO(286, "What happened to me in this timeline?"), function()
      know_president = true
      echo(ines)
      say(holeegram, HOLEEGRAM(568, "You are the President!"))
      say(ines, INES(287, "Awesome!"))
      wait(1)
      say(ines, INES(288, "Wait, President of what?"))
      say(holeegram, HOLEEGRAM(569, "Yes, you are the President of W.H.A.T."))
      wait(1)
      say(ines, INES(289, "Never mind, just help me get out of this mess."))
      return future_options()
    end)
    option(ECHO(290, "What happened to your body?"), function()
      echo(ines)
      say(holeegram, HOLEEGRAM(570, "Well..."))
      wait(1)
      say(holeegram, HOLEEGRAM(571, "I'm not sure."))
      say(holeegram, HOLEEGRAM(572, "I kind of misplaced it."))
      say(ines, INES(291, "What!?"))
      say(holeegram, HOLEEGRAM(573, "Nothing to worry about, dear."))
      if know_president then
        say(holeegram, HOLEEGRAM(574, "President Ines is on the case and I'm sure she will find it in no time."))
      else
        say(holeegram, HOLEEGRAM(575, "Future Ines is on the case and I'm sure she will find it in no time."))
      end
      say(ines, INES(292, "The more I learn about this time, the less I want to know."))
      return future_options()
    end)
    option(ECHO(293, "What happened to the van?"), function()
      echo(ines)
      say(holeegram, HOLEEGRAM(576, "It's the \"Uncle Lee Museum\" now."))
      say(ines, INES(294, "You're famous now!?"))
      wait(1)
      say(holeegram, HOLEEGRAM(577, "Well, no."))
      wait(1)
      say(holeegram, HOLEEGRAM(578, "I'm the one who made the museum."))
      say(ines, INES(295, "Of course you did."))
      return future_options()
    end)
    option(ECHO(296, "Never mind."), function()
      echo(ines)
      return options()
    end)
    return selection()
  end,
  ingredients = function()
    explain_ingredients = false
    say(holeegram, HOLEEGRAM(579, "It'll need a couple of seconds."))
    say(holeegram, HOLEEGRAM(580, "It's an old model."))
    wait(2)
    say(holeegram, HOLEEGRAM(581, "Results are ready!"))
    wait(1)
    say(holeegram, HOLEEGRAM(582, "We're in luck!"))
    say(holeegram, HOLEEGRAM(583, "It's very easy."))
    say(holeegram, HOLEEGRAM(584, "We'll just need:"))
    say(holeegram, HOLEEGRAM(585, "A strong MAGNET..."))
    say(holeegram, HOLEEGRAM(586, "...and that COIN from the back of the museum."))
    return ingredients_options()
  end,
  ingredients_options = function()
    if not g.flags.got_guitar then
      option(ECHO(297, "Where can I find a magnet?"), function()
        echo(ines)
        say(ines, INES(298, "I imagine there are plenty here in the future."))
        say(holeegram, HOLEEGRAM(587, "Ehm, not anymore."))
        wait(1)
        say(holeegram, HOLEEGRAM(588, "Not since the accident."))
        wait(1)
        say(ines, INES(299, "...OK."))
        say(ines, INES(300, "Other timelines it is."))
        return ingredients_options()
      end)
    end
    if not g.flags.got_coin then
      option(ECHO(301, "The coin seems oddly specific."), function()
        echo(ines)
        say(holeegram, HOLEEGRAM(589, "Well, TECHNICALLY I just need some gold."))
        say(holeegram, HOLEEGRAM(590, "I just wanted to make it easy for you."))
        say(ines, INES(302, "But I can't get to it!"))
        say(ines, INES(303, "Can't I just search for another golden thingy instead?"))
        say(holeegram, HOLEEGRAM(591, "No, there's no other gold in this game."))
        wait(1)
        say(holeegram, HOLEEGRAM(592, "Sorry."))
        say(ines, INES(304, "Damn."))
        return ingredients_options()
      end)
    end
    option(ECHO(305, "Thanks, got it."), function()
      echo(ines)
      return options()
    end)
    return selection()
  end
}
