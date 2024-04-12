local lc = require("engine")
local M = { }
M.interval = 1 / 60
M.start = function(self, duration, max_step)
  if duration == nil then
    duration = 1
  end
  if max_step == nil then
    max_step = 3
  end
  self.duration, self.max_step = duration, max_step
  self.t = 0
  self.factor = 0
  self.shaking = true
  return self:_randomize()
end
M._randomize = function(self)
  self.dx = love.math.random(-self.max_step, self.max_step)
  self.dy = love.math.random(-self.max_step, self.max_step)
end
M.stop = function(self)
  self.shaking = false
  return lc.signals.emit(self, "finished")
end
M.update = function(self, dt)
  if not (self.shaking) then
    return 
  end
  self.t = self.t + dt
  local oldfactor = self.factor
  self.factor = math.floor(self.t / self.interval)
  if self.factor > oldfactor then
    self:_randomize()
  end
  if self.t > self.duration then
    return self:stop()
  end
end
M.push = function(self)
  if not (self.shaking) then
    return 
  end
  love.graphics.push()
  return love.graphics.translate(self.dx, self.dy)
end
M.pop = function(self)
  if not (self.shaking) then
    return 
  end
  return love.graphics.pop()
end
return M
