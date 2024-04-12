local lc = require("engine")
local Vec2
Vec2 = lc.steelpan.Vec2
local g = require("global")
local common = require("rooms.common")
local inventory = require("inventory")
local skip = require("skip")
local dissolve = require("dissolve")
local room = lc.Room("assets/rooms/present.tuba")
room.order = 3
local wheels = room._objects.wheels:start_animation("default")
local windows = room._objects.windows
windows.look_text = function()
  return LOOK(6, "Void. Void everywhere.")
end
windows.hotspot_text = function()
  return TEXT(7, "windows")
end
common.drawer_setup(room)
local lee = room._objects.lee

lee.look_text = function()
  return LOOK(8, "At least now he has a reason not to look at the road.")
end
lee.hotspot_text = function()
  return TEXT(9, "uncle Lee")
end
lee.interact_position = Vec2(148, 99)
lee.interact_direction = "E"
lee.interact = function()
  return lc.dialogues:new(require("dialogues.lee"))
end
lee.use = {
  device_new = function()
    local ines = g.characters.ines
    lee = g.characters.lee
    return g.blocking_thread(function()
      skip:start()
      say(ines, INES(10, "Here it is."))
      wait(0.5)
      ines:start_animation_thread("E_pick_high")
      wait(0.5)
      ines:start_animation_thread("E_stand")
      inventory:remove("device_new")
      say(ines, INES(11, "I hope this works, for your own sake."))
      say(ines, INES(12, "I'm not keen on being stuck in a temporal tunnel."))
      say(lee, LEE(357, "No worries, we'll be back in our own timeline in a jiffy."))
      lee:start_animation_thread("remote_up")
      wait(1)
      lee._shader = dissolve.shader
      dissolve:start_disappear(0.8)
      wait_signal(dissolve, "finished")
      lee:change_room(nil)
      g.rooms.present._objects.lee.hidden = true
      g.rooms.present._objects.navigator.hidden = false
      g.flags.hide_lee = true
      g.flags.navigator_available = true
      wait(1)
      ines:face2("S")
      wait(1)
      say(ines, INES(13, "I should have expected that."))
      g:saveGame()
      return skip:stop()
    end)
  end
}
lee.use_nowalk = {
  device_old = function()
    local ines = g.characters.ines
    return g.blocking_thread(function()
      return say(ines, INES(14, "There's no point, it's the broken one he gave me."))
    end)
  end
}
local navigator = room._objects.navigator
navigator.look_text = function()
  return LOOK(15, "Why uncle Lee, why?")
end
navigator.hotspot_text = function()
  return TEXT(16, "temporal navigator")
end
navigator.interact_position = Vec2(208, 98)
navigator.interact_direction = "W"
navigator.interact = function()
  local ines = g.characters.ines
  return g.blocking_thread(function()
    say(ines, INES(17, "It looks like a phone."))
    wait(0.5)
    ines:face2("S")
    say(ines, INES(18, "He made a time machine out of a phone!?"))
    wait(0.5)
    ines:face2("W")
    wait(0.5)
    ines:start_animation("W_pick_high")
    wait(0.5)
    navigator.hidden = true
    g.flags.navigator_available = false
    inventory:add("navigator")
    g:saveGame()
    return say(ines, INES(19, "There are some times on speed dial."))
  end)
end

local plant = room._objects.plant
plant.hotspot_text = function()
  return TEXT(20, "plant")
end
plant.look_text = function()
  return LOOK(21, "Why does uncle Lee keep a plant in a van?")
end
plant.interact_position = Vec2(92, 99)
plant.interact_direction = "W"

plant.interact = function()
  if g.flags.plant_interacted then return end

  local ines = g.characters.ines
  return g.blocking_thread(function()
    say(ines, INES(22, "There's something hidden in the vase!"))
    ines:start_animation_thread("W_pick_low")
    wait(0.3)
    inventory:add("device_new")
    ines:start_animation_thread("W_stand")
    wait(0.3)
    say(ines, INES(23, "It's a spare device."))
    ines:face2("S")
    say(ines, INES(24, "How did it get in there?"))
    g.flags.plant_interacted = true
    plant.interact = nil
    g:saveGame()
  end)
end
plant.use_nowalk = {
  device_new2 = function()
    local ines = g.characters.ines
    return g.blocking_thread(function()
      say(ines, INES(25, "I found the device in this vase earlier."))
      say(ines, INES(26, "I don't think putting it back in now would help."))
      return say(ines, INES(27, "But I feel like I'm on the right track."))
    end)
  end
}
return room
