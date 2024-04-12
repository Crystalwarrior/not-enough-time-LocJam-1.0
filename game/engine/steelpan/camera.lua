local path = (...):gsub("[^%.]*$", "")
local Class = require(path .. 'class')
local Vec2 = require(path .. 'vectors')
local status, mod = pcall(require, "love")
local love = status and mod or nil
local Camera = Class({
  __init = function(self)
    self.transform = love.math.newTransform()
    self.x, self.y, self.angle, self.sx, self.sy, self.ox, self.oy = 0, 0, 0, 1, 1, 0, 0
  end,
  push = function(self)
    love.graphics.push()
    return love.graphics.applyTransform(self.transform)
  end,
  pop = function(self)
    return love.graphics.pop()
  end,
  set = function(self, x, y, angle, sx, sy, ox, oy)
    self.x = x or self.x
    self.y = y or self.y
    self.angle = angle or self.angle
    self.sx = sx or self.sx
    self.sy = sy or self.sy
    self.ox = ox or self.ox
    self.oy = oy or self.oy
    self.transform:setTransformation(self.x, self.y, self.angle, self.sx, self.sy)
    if self.on_move then
      return self:on_move()
    end
  end,
  reset = function(self)
    self.x, self.y, self.angle, self.sx, self.sy, self.ox, self.oy = 0, 0, 0, 1, 1, 0, 0
    return self.transform:reset()
  end,
  move = function(self, dx, dy)
    return self:set(self.x - dx, self.y - dy)
  end,
  get_coordinates = function(self, x, y)
    return self.transform:inverseTransformPoint(x, y)
  end,
  get_coordinates_vector = function(self, v)
    return Vec2(self:get_coordinates(v.x, v.y))
  end,
  set_callback = function(self, f)
    self.on_move = f
  end
})
return Camera
