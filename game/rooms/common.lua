local g = require("global")
local lc = require("engine")
local inventory = require("inventory")
local Vec2
Vec2 = lc.steelpan.Vec2
local cassette_inside = false
local cassette_room_order = 1
local M = { }
M.drawer_setup = function(room)
  local obj = room._objects.drawer
  obj.look_text = function()
    return LOOK(106, "I've never seen anyone keep gloves in here.")
  end
  obj.hotspot_text = function()
    return TEXT(107, "glove compartment")
  end
  obj.interact_position = Vec2(226, 50)
  obj.interact_direction = "E"
  obj.interact = function()
    local ines = g.characters.ines
    return g.blocking_thread(function()
      ines:start_animation_thread("E_pick_low")
      wait(0.2)
      obj:start_animation("open", true)
      if not cassette_inside or lc.game.room.order < cassette_room_order then
        say(ines, INES(108, "It's empty."))
      else
        cassette_inside = false
        say(ines, INES(109, "I'll take the cassette."))
        ines:start_animation_thread("E_pick_low")
        wait(0.2)
        if lc.game.room.order > cassette_room_order then
          inventory:add("cassette_old")
          say(ines, INES(110, "Perfectly ripe."))
          say(ines, INES(111, "Good thing no one used this compartment in all these years."))
        else
          inventory:add("cassette")
        end
        ines:start_animation_thread("E_stand")
        wait(0.2)
      end
      ines:start_animation_thread("E_pick_low")
      wait(0.2)
      obj:start_animation("closed", true)
      return ines:start_animation_thread("E_stand")
    end)
  end
  obj.use = {
    cassette = function()
      local ines = g.characters.ines
      return g.blocking_thread(function()
        cassette_inside = true
        cassette_room_order = lc.game.room.order
        say(ines, INES(112, "I'll put it inside."))
        ines:start_animation_thread("E_pick_low")
        wait(0.2)
        obj:start_animation("open", true)
        ines:start_animation_thread("E_stand")
        wait(0.2)
        ines:start_animation_thread("E_pick_low")
        wait(0.2)
        inventory:remove("cassette")
        ines:start_animation_thread("E_stand")
        wait(0.2)
        ines:start_animation_thread("E_pick_low")
        wait(0.2)
        obj:start_animation("closed", true)
        return ines:start_animation_thread("E_stand")
      end)
    end,
    cassette_old = function()
      local ines = g.characters.ines
      return g.blocking_thread(function()
        return say(ines, INES(113, "There's no need, I already aged it."))
      end)
    end
  }
  return obj
end
return M
