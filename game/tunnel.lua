local g = require("global")
local rooms = require("rooms")
local atlas = g.rooms.present._atlas
local sprite_front = atlas.tunnel_front
local sprite_pattern = atlas.tunnel_pattern
local front_width = sprite_front.size.x
local pattern_width = sprite_pattern.size.x
local width = front_width + pattern_width
local M = { }
M.shader = love.graphics.newShader([[    uniform float intensity;
    vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )  {
        float factor = max(0.0, 1.0 - intensity)*(1.0 - intensity*pow(screen_coords.x/135.0, 2.0));
        vec4 texcolor = Texel(tex, texture_coords);
        return vec4(texcolor.rgb*factor, texcolor.a)*color;
    }
]])
M.on = false
M.speed = 150
M.offset = 0
M.one_loop = false
M.min_shift = M.speed * 1 / 24
M.intensity = 0
local accum = 0
local DT = 1 / 30
M.update = function(self, dt)
  if not (self.on) then
    return 
  end
  self.offset = self.offset + (self.speed * dt)
  if not self.one_loop and self.offset >= front_width + g.game_width then
    self.one_loop = true
  end
  if self.one_loop then
    self.offset = self.offset % (pattern_width)
  end
end
M.set_intensity = function(self, value)
  self.intensity = value
  return self.shader:send("intensity", value)
end
M.draw = function(self)
  if not (self.on) then
    return 
  end
  love.graphics.push("all")
  local offset = math.floor(self.offset)
  if not (self.one_loop) then
    sprite_front:draw(g.game_width - offset, 0)
  end
  local min_i = self.one_loop and -2 or 0
  love.graphics.setShader(self.shader)
  for i = min_i, 2 do
    sprite_pattern:draw(g.game_width + front_width - offset + pattern_width * i, 0)
  end
  return love.graphics.pop()
end
return M
