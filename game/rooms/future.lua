local lc = require("engine")
local Vec2
Vec2 = lc.steelpan.Vec2
local g = require("global")
local common = require("rooms.common")
local inventory = require("inventory")
local glass_wall_line
glass_wall_line = function()
  return INES(28, "I can't reach it, it's behind this force field.")
end
local room = lc.Room("assets/rooms/future.tuba")
room._objects.wheels:start_animation("default")
room.order = 4
local HSV
HSV = function(h, s, v, a)
  local g
  if s <= 0 then
    return v, v, v
  end
  h = h * 6
  local c = v * s
  local x = (1 - math.abs((h % 2) - 1)) * c
  local m, r, b
  m, r, g, b = (v - c), 0, 0, 0
  if h < 1 then
    r, g, b = c, x, 0
  elseif h < 2 then
    r, g, b = x, c, 0
  elseif h < 3 then
    r, g, b = 0, c, x
  elseif h < 4 then
    r, g, b = 0, x, c
  elseif h < 5 then
    r, g, b = x, 0, c
  else
    r, g, b = c, 0, x
  end
  return r + m, g + m, b + m
end
local lights = room._objects.lights
g.start_thread(function()
  local t = 0
  while true do
    local intensity = 0.5 + 0.5 * math.sin(t) ^ 2
    lights._colour = {
      HSV(0.5 + 0.05 * math.sin(0.3 * t), 1, intensity)
    }
    t = t + wait_frame()
  end
end)
local coin = room._objects.coin
coin.look_text = function()
  if g.device_analyzed then
    return LOOK(29, "The only gold in this game.")
  else
    return LOOK(30, "That looks familiar.")
  end
end
coin.hotspot_text = function()
  return TEXT(31, "coin")
end
coin.interact_direction = "W"
coin.interact_position = Vec2(50, 95)
coin.interact = function()
  local ines = g.characters.ines
  return g.blocking_thread(function()
    if room._navigation:are_points_connected(ines._position, coin.interact_position) then
      wait(0.1)
      ines:start_animation_thread("W_pick_high")
      wait(0.1)
      coin.hidden = true
      inventory:add("coin")
      g.got_coin = true
      ines:start_animation_thread("W_stand")
      wait(1)
      say(ines, INES(32, "I thought there was no gold in this game!"))
      wait(1)
      ines:face2("S")
      say(ines, INES(33, "Hey, it's just gold plated."))
      wait(1)
      return say(ines, INES(34, "I hope this won't create any problems down the line."))
    else
      return say(ines, glass_wall_line())
    end
  end)
end
local plate = room._objects.plate
plate.look_text = function()
  return LOOK(35, "A plate with a description of the coin.")
end
plate.hotspot_text = function()
  return TEXT(36, "plate")
end
plate.interact_direction = coin.interact_direction
plate.interact_position = coin.interact_position
plate.interact = function()
  local ines = g.characters.ines
  return g.blocking_thread(function()
    if room._navigation:are_points_connected(ines._position, plate.interact_position) then
      say(ines, INES(37, "It says it's a reproduction of the first coin ever earned by uncle Lee."))
      say(ines, INES(38, "Apparently the original was lost when I was a kid."))
      ines:face2("S")
      wait(1)
      return say(ines, INES(39, "Heh heh."))
    else
      return say(ines, glass_wall_line())
    end
  end)
end
local holeegram = room._objects.holeegram
holeegram.look_text = function()
  if not g.talked_to_holeegram then
    return LOOK(40, "What has he gotten himself into, this time?")
  else
    return LOOK(41, "Somehow he keeps surprising me.")
  end
end
holeegram.hotspot_text = function()
  if not g.talked_to_holeegram then
    return TEXT(42, "uncle Lee?")
  else
    return TEXT(43, "holeegram")
  end
end
holeegram.interact_direction = "W"
holeegram.interact_position = Vec2(140, 97)
holeegram.look_point = Vec2(120, 100)
holeegram.interact = function()
  local ines = g.characters.ines
  if ines._position.x > 120 then
    return lc.dialogues:new(require("dialogues.holeegram"))
  else
    return g.blocking_thread(function()
      say(ines, INES(44, "Uncle Lee?"))
      wait(1)
      ines:face2("S")
      wait(0.5)
      return say(ines, INES(45, "He can't hear me behind this force field."))
    end)
  end
end
local opening = room._objects.opening
opening.look_text = function()
  return LOOK(46, "A beatiful hatch. You can't tell due to the resolution, but it's very ornate.")
end
opening.hotspot_text = function()
  return TEXT(47, "opening")
end
opening.interact_position = holeegram.interact_position
opening.look_point = holeegram.look_point
opening.interact_direction = holeegram.interact_direction
local remaining_objects = 2
local object_inserted
object_inserted = function(name)
  local ines = g.characters.ines
  local holee = g.characters.holeegram
  return g.blocking_thread(function()
    if ines._position.x < 120 then
      say(ines, INES(48, "I can't do that from here."))
      return 
    end
    if remaining_objects > 1 then
      say(ines, INES(49, "Here's one of the things you needed."))
    else
      say(ines, INES(50, "Here's the other thing you needed."))
    end
    ines:start_animation_thread("W_pick_low")
    wait(0.3)
    inventory:remove(name)
    ines:start_animation_thread("W_stand")
    remaining_objects = remaining_objects - 1
    if remaining_objects == 0 then
      say(holee, HOLEEGRAM(358, "Yummy!"))
      wait(1)
      say(ines, INES(51, "...what?"))
      say(holee, HOLEEGRAM(359, "I didn't say anything."))
      wait(1)
      say(ines, INES(52, "Never mind, can you fix this thing or not?"))
      say(holee, HOLEEGRAM(360, "Working on it."))
      wait(1)
      say(holee, HOLEEGRAM(361, "Beep Boop."))
      say(holee, HOLEEGRAM(362, "Bzzzzzzzzzzz."))
      wait(1)
      say(holee, HOLEEGRAM(363, "There you go."))
      ines:start_animation_thread("W_pick_low")
      wait(0.3)
      inventory:add("device_new2")
      return ines:start_animation_thread("W_stand")
    end
  end)
end
opening.use = {
  device_old = function()
    local ines = g.characters.ines
    return g.blocking_thread(function()
      if g.asked_to_analyze_device then
        ines:start_animation_thread("W_pick_low")
        wait(0.3)
        inventory:remove("device_old")
        ines:start_animation_thread("W_stand")
        g.device_analyzed = true
        return lc.dialogues:new(require("dialogues.holeegram"))
      else
        return say(ines, INES(53, "Why would I do that?"))
      end
    end)
  end,
  coin = function()
    return object_inserted("coin")
  end,
  pickup = function()
    return object_inserted("pickup")
  end
}
holeegram.use = opening.use
local drawer = common.drawer_setup(room)
local old_interact = drawer.interact
drawer.interact = function()
  local ines = g.characters.ines
  if ines._position.x > 120 then
    return old_interact()
  else
    return g.blocking_thread(function()
      return say(ines, glass_wall_line())
    end)
  end
end
local laser = room._objects.laser
local laser_side = room._objects.laser_side
local laser_tex = love.graphics.newImage("assets/single_sprites/laser.png")
local laser_base_alpha = 0.4
local laser_side_base_alpha = 0.6
laser._colour = {
  1,
  1,
  1,
  laser_base_alpha
}
laser_side._colour = {
  1,
  1,
  1,
  laser_side_base_alpha
}
laser._shader = love.graphics.newShader([[uniform float shift_up;
uniform float shift_down;
uniform Image laser_tex;
const float smoothing = 2.0/16.0;
const float outerEdgeCenter = 0.7;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texColor = Texel(tex, texture_coords);
    float laserUp = Texel(laser_tex, (screen_coords + vec2(0.0, shift_up))/vec2(240.0, 135.0)).r;
    float laserDown = Texel(laser_tex, (screen_coords + vec2(0.0, -shift_down))/vec2(240.0, 135.0)).g;
    return color*(texColor + texColor.a*(vec4(0.0, 0.0, 0.0, 0.5)*laserUp + vec4(0.0, 0.0, 0.0, 0.3)*laserDown*(1.0 - laserUp)));
}
]])
laser._shader:send("laser_tex", laser_tex)
g.start_thread(function()
  local t = 0
  local accum = math.huge
  while true do
    local shift_up = 15 * t % 15
    local shift_down = 10 * t % 10
    laser._shader:send("shift_up", shift_up)
    laser._shader:send("shift_down", shift_down)
    if accum > 1 / 30 then
      accum = 0
      local tmp = love.math.random()
      laser._colour[4] = laser_base_alpha + 0.1 * tmp
      laser_side._colour[4] = laser_side_base_alpha + 0.1 * tmp
    end
    local dt = wait_frame()
    t = t + dt
    accum = accum + dt
  end
end)
return room
