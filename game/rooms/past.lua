local lc = require("engine")
local Vec2
Vec2 = lc.steelpan.Vec2
local g = require("global")
local common = require("rooms.common")
local inventory = require("inventory")
local room = lc.Room("assets/rooms/past.tuba")
room.order = 1
room._objects.wheels:start_animation("default")
common.drawer_setup(room)
local wilson = room._objects.wilson
wilson.look_text = function()
  return LOOK(54, "They're sitting very still. Must be uncomfortable.")
end
wilson.hotspot_text = function()
  return TEXT(55, "musicians of low moral fiber")
end
wilson.interact_position = Vec2(154, 101)
wilson.interact_direction = "W"
wilson.interact = function()
  return lc.dialogues:new(require("dialogues.wilson"))
end
wilson.use_position = Vec2(96, 101)
local destroy_position = Vec2(119, 104)
wilson.use = {
  pick = function()
    local ines = g.characters.ines
    local peppe = g.characters.peppe
    local andrea = g.characters.andrea
    local paolo = g.characters.paolo
    return g.blocking_thread(function()
      if not g.flags.know_about_pick then
        say(ines, INES(56, "Why would I do that?"))
        return 
      end
      say(ines, INES(57, "Is this the pick you are looking for?"))
      ines:start_animation_thread("W_pick_high")
      wait(0.3)
      inventory:remove("pick")
      ines:start_animation_thread("W_stand")
      wait(1)
      say(peppe, PEPPE(364, "My pick!"))
      say(peppe, PEPPE(365, "My beautiful pick!"))
      say(paolo, PAOLO(366, "We missed you so much, li'l buddy!"))
      say(andrea, ANDREA(367, "Don't ever scare us like that again!"))
      wait(1)
      say(ines, INES(58, "Now can I have your guitar?"))
      say(peppe, PEPPE(368, "Sure thing, I'll get one from the deposit."))
      wait(1)
      peppe:start_animation_thread("give_guitar")
      wait(0.3)
      ines:start_animation_thread("W_pick_high")
      wait(0.3)
      inventory:add("guitar")
      peppe:start_animation_thread("E_stand")
      ines:start_animation_thread("W_stand")
      g.flags.got_guitar = true
      wait(1)
      ines:walk_thread(destroy_position:unpack())
      inventory:remove("guitar")
      local old_pos_y = ines._position.y
      ines._position.y = -100
      local a = room._objects.destroy:start_animation("on", true)
      wait_signal(a, "finished")
      room._objects.destroy.hidden = true
      ines._position.y = old_pos_y
      inventory:add("pickup")
      wait(2)
      say(peppe, PEPPE(369, "That hurt."))
      wait(1)
      say(paolo, PAOLO(370, "This gives me an idea for an album cover."))
      g.poster_changed = true
      g.rooms.collector._objects.poster:start_animation("changed", true)
      g.rooms.collector._objects.new_poster.hidden = false
    end)
  end
}
wilson.use_nowalk = {
  recorder = function()
    local ines = g.characters.ines
    return g.blocking_thread(function()
      ines:face2("S")
      say(ines, INES(59, "I'll turn it on if we talk about anything interesting."))
      wait(0.3)
      ines:walk_thread(wilson.interact_position:unpack())
      ines:face2(wilson.interact_direction)
      g.recorder_on = true
      return lc.dialogues:new(require("dialogues.wilson"))
    end)
  end
}
local plant = room._objects.plant
plant.look_text = function()
  return LOOK(60, "That doesn't look like the same plant as uncle Lee's.")
end
plant.hotspot_text = function()
  return TEXT(61, "suspicious plant")
end
return room
