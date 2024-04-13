local g = require("global")
local M = { }
g.time_rate = 1
M.time_rate = 50000
M.skipping = false
M.start = function(self)
  self.skippable = true
end
M.stop = function(self)
  M.skipping = false
  self.skippable = false
  self.holding = false
  g.time_rate = 1
end
M.hold_time = 1
M.t = 0
M.start_hold = function(self)
  if not (self.skippable) then
    return 
  end
  self.holding = true
  self.t = 0
end
M.go = function(self)
  self.holding = false
  if not (self.skippable) then
    return 
  end
  M.skipping = true
  g.time_rate = self.time_rate
end
M.release_hold = function(self)
  self.holding = false
end
M.update = function(self, dt)
  if self.holding then
    self.t = self.t + dt
    if self.t >= self.hold_time then
      return self:go()
    end
  end
end
M.radius = 8
M.lineWidth = 6
M.colour = {
  1,
  1,
  0.5
}
M.padding = 3
M.distance_from_edge = M.padding + M.radius + 0.5 * M.lineWidth
M.draw_canvas = function(self)
  if not (self.holding) then
    return 
  end
  love.graphics.push("all")
  love.graphics.setLineStyle("rough")
  local factor = self.t / self.hold_time
  love.graphics.setColor(self.colour)
  love.graphics.setLineWidth(self.lineWidth)
  local x = g.game_width - self.distance_from_edge
  local y = g.game_height - self.distance_from_edge
  love.graphics.arc("line", "open", x, y, self.radius, -0.5 * math.pi, -0.5 * math.pi + 2 * math.pi * factor, 100 * factor)
  return love.graphics.pop()
end
return M
