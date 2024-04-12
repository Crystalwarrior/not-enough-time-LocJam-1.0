local g = require("global")
local audio = require("audio")
local ines, lee
do
  local _obj_0 = g.characters
  ines, lee = _obj_0.ines, _obj_0.lee
end
local tunnel = require("tunnel")
local road = require("road")
local vortex = require("vortex")
local inventory = require("inventory")
local ui_inventory = require("ui.inventory")
local shake = require("shake")
local lc = require("engine")
local switch_room
switch_room = function(room, f)
  local t = g.blocking_thread(function()
    ui_inventory.hidden = true
    audio.switch_room(room)
    shake:start()
    wait_signal(shake, "finished")
    lc.game.set_room(room)
    ines:change_room(room, ines._position:unpack())
    ui_inventory.hidden = false
    if f then
      return f()
    end
  end)
  return t
end
g.switch_room = switch_room
return {
  main = function()
    if lc.game.room ~= g.rooms.past then
      option(NOECHO(306, "Sixties."), sixties)
    end
    if lc.game.room ~= g.rooms.collector then
      option(NOECHO(307, "Nineties."), nineties)
    end
    if lc.game.room ~= g.rooms.present then
      option(NOECHO(308, "Present."), present)
    end
    if lc.game.room ~= g.rooms.future then
      option(NOECHO(309, "THE FUTURE."), future)
    end
    option(NOECHO(310, "Stay here."), exit)
    return selection()
  end,
  sixties = function()
    switch_room(g.rooms.past, function()
      if not g.visited_past then
        g.visited_past = true
        ui_inventory.hidden = true
        wait(0.5)
        local wilson = g.rooms.past._objects.wilson
        ines:walk_thread(wilson.interact_position:unpack())
        ines:face2(wilson.interact_direction)
        wait(2)
        wilson.interact()
        ui_inventory.hidden = false
      end
    end)
    return exit()
  end,
  nineties = function()
    switch_room(g.rooms.collector, function()
      if not g.collector_distracted then
        g.characters.collector:face2("N")
      end
      g.collector_looking = false
      if not g.visited_collector then
        g.collector_looking = true
        g.visited_collector = true
        ui_inventory.hidden = true
        g.collector_looking = true
        wait(0.5)
        local collector = g.rooms.collector._objects.collector
        ines:walk_thread(collector.interact_position:unpack())
        ines:face2(collector.interact_direction)
        wait(0.5)
        collector.interact()
        ui_inventory.hidden = false
      end
      local recorder = g.rooms.collector._objects.recorder
      if not g.at_recorder_spot and ines._position == recorder.interact_position then
        ines._position.x = ines._position.x + 4
        ines._wlk.prev_target = nil
      end
    end)
    return exit()
  end,
  present = function()
    switch_room(g.rooms.present)
    return exit()
  end,
  future = function()
    switch_room(g.rooms.future)
    return exit()
  end
}
