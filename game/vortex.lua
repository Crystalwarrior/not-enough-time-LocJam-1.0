local Class = require("engine.steelpan.class")
local M = { }
local divisions = 15
local speed = 20
local min_radius = 10
local rot_speed = 0.4
local time_step = 0.4
local center = {
  120,
  66.5
}
local colours = {
  {
    love.math.colorFromBytes(105, 245, 183)
  },
  {
    love.math.colorFromBytes(95, 205, 228)
  },
  {
    1,
    1,
    1
  }
}
local rough = true
local center_displacement_stdev = 0.5
local center_displacement = {
  0,
  0
}
local displacement_step = 0.15
local displacement_t = 0
local needs_update = false
local angle = 2 * math.pi / divisions
local t = 0
local first_circle
local Circle = Class({
  __init = function(self, dr)
    if dr == nil then
      dr = 0
    end
    self.radius = min_radius + dr
    self.angle = 0
    local pieces = 0
    while pieces < 2 do
      pieces = 0
      self.segments = { }
      for i = 1, divisions do
        if love.math.random(2) ~= 1 then
          self.segments[i] = colours[love.math.random(#colours)]
          pieces = pieces + 1
        else
          self.segments[i] = false
        end
      end
    end
    self.next = first_circle
    if first_circle then
      first_circle.prev = self
    end
    first_circle = self
  end,
  draw = function(self)
    if self.radius < min_radius then
      return 
    end
    love.graphics.push("all")
    love.graphics.translate((1 - center[1] / 120) * self.radius, 0)
    love.graphics.rotate(self.angle)
    for i = 1, divisions do
      do
        local col = self.segments[i]
        if col then
          love.graphics.setColor(col)
          love.graphics.arc("line", "open", 0, 0, self.radius, angle * (i - 1) + 0.1, angle * i - 0.1, 20)
        end
      end
    end
    return love.graphics.pop()
  end
})
Circle()
M.update = function(self, dt)
  dt = math.min(dt, 1 / 30)
  if not (self.on) then
    return 
  end
  if not (needs_update) then
    return 
  end
  local circle = first_circle
  while circle do
    circle.radius = circle.radius + (speed * dt * 0.05 * circle.radius)
    circle.angle = circle.angle + (rot_speed * dt)
    circle.angle = circle.angle % (2 * math.pi)
    if circle.radius > 375 then
      if circle == first_circle then
        first_circle = nil
      else
        circle.prev.next = nil
      end
    end
    circle = circle.next
  end
  t = t + dt
  if t > time_step then
    t = t - time_step
    Circle(t * speed)
  end
  displacement_t = displacement_t + dt
  if displacement_t > displacement_step then
    displacement_t = displacement_t % displacement_step
    center_displacement = {
      love.math.randomNormal(center_displacement_stdev),
      love.math.randomNormal(center_displacement_stdev)
    }
  end
  needs_update = false
end
M.draw = function(self)
  if not (self.on) then
    return 
  end
  needs_update = true
  love.graphics.push("all")
  if rough then
    love.graphics.setLineStyle("rough")
  end
  love.graphics.setLineWidth(2)
  local x = center[1] + center_displacement[1]
  local y = center[2] + center_displacement[2]
  love.graphics.translate(x, y)
  love.graphics.push()
  love.graphics.translate((1 - center[1] / 120) * min_radius, 0)
  love.graphics.circle("line", 0, 0, min_radius)
  love.graphics.pop()
  local circle = first_circle
  while circle do
    circle:draw()
    circle = circle.next
  end
  return love.graphics.pop()
end
M.set_zoom = function(self, zoom)
  min_radius = min_radius / zoom
end
M.set_position = function(self, x, y)
  center[1], center[2] = x, y
end
M.get_position = function(self)
  return center[1], center[2]
end
return M
