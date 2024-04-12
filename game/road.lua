local g = require("global")
local tunnel = require("tunnel")
local shake = require("shake")
local atlas = g.rooms.present._atlas
local M = { }
M.on = true
M.speed = 200
M.trees_speed = 80
M.clouds_speed = 1
M.offset = 0
M.trees_offset = 0
M.clouds_offset = 0
M.use_tunnel_shader = true
M.smoothness_step = 0.1
local xshift = 4
local ytop = g.game_height - 10
local ybottom = g.game_height - 7
local width = 50
local space = 30
local road_h = 50
local accum = 0
local DT = 1 / 24
M.update = function(self, dt)
  if not (self.on) then
    return 
  end
  self.offset = self.offset - (self.speed * dt)
  self.offset = self.offset % (width + space)
  self.trees_offset = self.trees_offset - (self.trees_speed * dt)
  self.trees_offset = self.trees_offset % g.game_width
  self.clouds_offset = self.clouds_offset - (self.clouds_speed * dt)
  self.clouds_offset = self.clouds_offset % g.game_width
end
local cloud_shader = love.graphics.newShader([[    uniform float width;

    vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
        vec4 col1 = Texel(tex, texture_coords);
        vec4 col2 = Texel(tex, texture_coords + vec2(-1.0/width, 0.0));
        return mix(col1, col2, color.a);
    }
]])
cloud_shader:send("width", atlas.clouds.spritesheet:getWidth())
M.draw = function(self)
  if not (self.on) then
    return 
  end
  love.graphics.push("all")
  local dx = shake.shaking and shake.dx or 0
  local dy = shake.shaking and shake.dy or 0
  love.graphics.setScissor(dx, dy, g.game_width, g.game_height)
  if self.use_tunnel_shader then
    love.graphics.setShader(tunnel.shader)
  end
  atlas.sky:draw()
  for i = -1, 1 do
    love.graphics.push("all")
    local factor = self.clouds_offset % 1
    factor = self.smoothness_step * math.floor(factor / self.smoothness_step)
    love.graphics.setShader(cloud_shader)
    love.graphics.setColor(1, 1, 1, factor)
    atlas.clouds:draw(math.floor(self.clouds_offset) + atlas.clouds.size.x * i)
    love.graphics.pop()
  end
  for i = -1, 1 do
    atlas.trees:draw(math.floor(self.trees_offset) + atlas.trees.size.x * i)
  end
  love.graphics.setColor(.3, .3, .3)
  love.graphics.rectangle("fill", 0, g.game_height - road_h, g.game_width, road_h)
  love.graphics.setColor(1, 1, 1)
  for i = -1, 3 do
    local xpos = math.floor(self.offset) + (width + space) * i
    local rshift = -(-1 + 2 * (xpos + width) / g.game_width) * xshift
    local lshift = -(-1 + 2 * xpos / g.game_width) * xshift
    love.graphics.polygon("fill", xpos + lshift, ytop, xpos + rshift + width, ytop, xpos + width, ybottom, xpos, ybottom)
  end
  love.graphics.setScissor()
  return love.graphics.pop()
end
return M
