local lc = require("engine")
local Vec2
Vec2 = lc.steelpan.Vec2
local g = require("global")
local common = require("rooms.common")
local inventory = require("inventory")
local room = lc.Room("assets/rooms/collector.tuba")
room.order = 2
room._objects.wheels:start_animation("default")
local collector = room._objects.collector
collector.look_text = function()
  if not g.flags.collector_distracted then
    if g.characters.collector._direction == lc.Character.direction.N then
      return LOOK(62, "She's staring very intensely at that poster.")
    else
      return LOOK(63, "She's staring very intensely at me.")
    end
  else
    return LOOK(64, "She's listening very intensely to the demo tape.")
  end
end
collector.hotspot_text = function()
  if not g.flags.know_who_collector_is then
    return TEXT(65, "?")
  else
    return TEXT(66, "collector")
  end
end
collector.interact_position = Vec2(120, 101)
collector.interact_direction = "W"
collector.interact = function()
  return lc.dialogues:new(require("dialogues.collector"))
end
collector.use = {
  cassette_old = function()
    local ines = g.characters.ines
    local c = g.characters.collector
    return g.blocking_thread(function()
      say(ines, INES(67, "Here."))
      ines:start_animation_thread("W_pick_high")
      wait(0.1)
      inventory:remove("cassette_old")
      ines:start_animation_thread("W_stand")
      say(c, COLLECTOR(371, "Is this..."))
      say(c, COLLECTOR(372, "...is this what I think it is?"))
      say(ines, INES(68, "Yep."))
      say(c, COLLECTOR(373, "It looks genuine!"))
      say(c, COLLECTOR(374, "I can't believe it!"))
      say(c, COLLECTOR(375, "I will need to listen to it right away to make sure."))
      wait(1)
      say(c, COLLECTOR(376, "Please don't touch anything while I'm distracted."))
      c:start_animation("E_distracted")
      c._animations["E_talk"]:toggle_visibility("headphones")
      c._animations["E_stand"]:toggle_visibility("headphones")
      c._animations["E_distracted"]:toggle_visibility("headphones")
      g.flags.collector_distracted = true
      g:saveGame()
      return wait(1)
    end)
  end,
  cassette = function()
    local ines = g.characters.ines
    local c = g.characters.collector
    return g.blocking_thread(function()
      if g.flags.triedToGiveCassette then
        collector.use.cassette = nil
        return
      end
      g.flags.triedToGiveCassette = true
      say(ines, INES(69, "Here."))
      ines:start_animation_thread("W_pick_high")
      wait(0.1)
      inventory:remove("cassette")
      ines:start_animation_thread("W_stand")
      say(c, COLLECTOR(377, "What's this?"))
      if not g.flags.know_about_tape then
        say(ines, INES(70, "It's a demo tape from the band who used to own this van."))
      else
        say(ines, INES(71, "It's the demo tape you wanted so badly."))
      end
      say(c, COLLECTOR(378, "Impossible, this cassette looks brand new."))
      say(c, COLLECTOR(379, "You want me to believe it's from the sixties?"))
      say(ines, INES(72, "It is, I swear!"))
      wait(1)
      say(c, COLLECTOR(380, "A likely tale, future-girl."))
      say(c, COLLECTOR(381, "Take this garbage back."))
      ines:start_animation_thread("W_pick_high")
      wait(0.1)
      inventory:add("cassette")
      ines:start_animation_thread("W_stand")
      collector.use.cassette = nil
      g:saveGame()
    end)
  end
}
collector.use_nowalk = {
  cassette = function()
    local ines = g.characters.ines
    return g.blocking_thread(function()
      say(ines, INES(73, "I already tried, she doesn't believe it's the real thing."))
      return say(ines, INES(74, "Doesn't look old enough."))
    end)
  end
}
common.drawer_setup(room)
local pick = room._objects.pick
local poster = room._objects.poster
pick.hidden = true
pick.look_text = function()
  return LOOK(75, "Fishy.")
end
pick.hotspot_text = function()
  return TEXT(76, "pick")
end
pick.interact_position = Vec2(35, 96)
pick.interact = function()
  if g.flags.got_pick then return end

  local ines = g.characters.ines
  return g.blocking_thread(function()
    ines:start_animation_thread("E_pick_high")
    wait(0.1)
    inventory:add("pick")
    g.flags.got_pick = true
    poster:start_animation("no_pick", true)
    pick.hidden = true
    ines:start_animation_thread("E_stand")
    ines:face2("E")
    wait(0.5)
    say(ines, INES(77, "They used the actual pick to make the poster."))
    wait(0.2)
    ines:face2("S")
    wait(0.2)
    say(ines, INES(78, "A completely normal and sane thing to do."))
    g:saveGame()
    return
  end)
end

poster.look_text = function()
  if not g.flags.poster_changed then
    return LOOK(79, "A striking pose. The composition drives the focus to the pick.")
  else
    return LOOK(80, "Ahead of its time. Hey, wasn't it different before?")
  end
end
poster.hotspot_text = function()
  return TEXT(81, "poster")
end
poster.interact_direction = "E"
poster.interact_position = pick.interact_position
poster.interact = function()
  if g.flags.poster_interacted then return end

  local ines = g.characters.ines
  return g.blocking_thread(function()
    say(ines, INES(82, "Hey, the pick the guitar player is holding doesn't look flat."))
    ines:face2("S")
    say(ines, INES(83, "That is what artists would call \"in relief\"."))
    poster.interact = nil
    pick.hidden = false
    g.flags.poster_interacted = true
    g:saveGame()
  end)
end
local new_poster = room._objects.new_poster
new_poster.hidden = true
local poster_en = love.graphics.newImage("assets/single_sprites/poster_english.png")
local poster_tr = love.graphics.newImage("assets/single_sprites/poster_translated.png")
new_poster._image = function()
  return lc.tr_text == require("text_english") and poster_en or poster_tr
end
local recorder = room._objects.recorder

recorder.interact_position = Vec2(123, 99)
recorder.interact_direction = "N"
recorder.look_text = function()
  return LOOK(84, "An old style red tape recorder. I must have it.")
end
recorder.hotspot_text = function()
  return TEXT(85, "tape recorder")
end
recorder.interact = function()
  local ines = g.characters.ines
  local c = g.characters.collector
  return g.blocking_thread(function()
    wait(0.3)
    ines:start_animation_thread("take_recorder")
    wait(0.3)
    if g.flags.collector_looking then
      ines:start_animation_thread("N_stand")
      say(c, COLLECTOR(382, "Leave that alone!"))
      say(c, COLLECTOR(383, "It's priceless."))
      ines:face2("N")
      wait(0.1)
      return say(ines, INES(86, "Drats."))
    else
      inventory:add("recorder")
      g.flags.recorder_obtained = true
      recorder.hidden = true
      ines:start_animation_thread("N_stand")
      wait(0.5)
      ines:face2("E")
      wait(0.1)
      g:saveGame()
      return say(ines, INES(87, "Heh heh."))
    end
  end)
end

g.recorder_safeframes = 15

g.start_thread(function()
  wait_frame()
  local ines = g.characters.ines
  local c = g.characters.collector
  local warning = false
  while true do
    if lc.game.room == room then
      if g.flags.collector_distracted then
        break
      end
      if ines._wlk.moving then
        g.recorder_safeframes = g.recorder_safeframes - 1
        if g.recorder_safeframes <= 0 then
          g.recorder_safeframes = 15
          c:face2("E")
          if not g.flags.collector_looking then
            g.flags.collector_looking = true
            g.start_thread(function()
              return say(c, COLLECTOR(384, "Uh, it's you again."))
            end)
          end
        end
      end
      if not warning and ines._position.x < 82 then
        warning = true
        ines:stop_walking()
        if g.interaction_thread then
          g.interaction_thread:stop()
        end
        g.blocking_thread(function()
          c:face2("E")
          say(c, COLLECTOR(385, "HEY!"))
          say(c, COLLECTOR(386, "Get away from there!"))
          ines:walk_thread(collector.interact_position:unpack())
          say(c, COLLECTOR(387, "I don't want you anywhere near my one-of-a-kind poster."))
          warning = false
        end)
      end
    end
    wait_frame()
  end
end)
local plant = room._objects.plant
plant.hotspot_text = function()
  return TEXT(88, "plant")
end
plant.look_text = function()
  return LOOK(89, "Is this the same plant that uncle Lee keeps in the van?")
end
plant.interact_position = Vec2(42, 96)
plant.interact_direction = "W"
plant.use = {
  device_new2 = function()
    local ines = g.characters.ines
    local shake = require("shake")
    return g.blocking_thread(function()
      ines:face2("S")
      g:saveGame()
      say(ines, INES(90, "So..."))
      say(ines, INES(91, "...I found the working device that I gave uncle Lee in the plant vase."))
      say(ines, INES(92, "Which I guess was actually the very same device I have now."))
      say(ines, INES(93, "So to solve the inconsistency I have to put this in here, so past me can find it in the future."))
      say(ines, INES(94, "Which is actually the present."))
      wait(1)
      say(ines, INES(95, "...man."))
      say(ines, INES(96, "Time travel is TRIPPY."))
      wait(1)
      ines:face2("W")
      say(ines, INES(97, "I'll put the device inside the vase and then press the button from there."))
      ines:start_animation_thread("W_pick_low")
      wait(0.3)
      inventory:remove("device_new2")
      wait(0.5)
      return lc.dialogues:new(require("dialogues.ending"))
    end)
  end
}
local books = room._objects.books
books.hotspot_text = function()
  return TEXT(98, "books")
end
books.look_text = function()
  return LOOK(99, "They're all copies of the same book: \"A Band with No Drums\".")
end
local cds = room._objects.cds
cds.hotspot_text = function()
  return TEXT(100, "CDs")
end
cds.look_text = function()
  return LOOK(101, "They look newer than the rest of the stuff here.")
end
local lps = room._objects.lps
lps.hotspot_text = function()
  return TEXT(102, "LPs")
end
lps.look_text = function()
  return LOOK(103, "A bunch of vynils. Yes, I'm old enough to know what those are.")
end
local stereo = room._objects.stereo
stereo.hotspot_text = function()
  return TEXT(104, "stereo")
end
stereo.look_text = function()
  return LOOK(105, "State-of-the-art. Or at least it would have been a few decades ago.")
end
return room
