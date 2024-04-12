local path = (...):gsub(".init$", "") .. '.'
local menus = {
  options = require(path .. "options"),
  start = require(path .. "start")
}
local M = { }
M.update = function(self)
  do
    local m = self.menu
    if m then
      return m:update()
    end
  end
end
M.draw = function(self)
  do
    local m = self.menu
    if m then
      return m:draw()
    end
  end
end
M.mousereleased = function(self)
  do
    local m = self.menu
    if m then
      return m:mousereleased()
    end
  end
end
M.mousepressed = function(self, button)
  do
    local m = self.menu
    if m then
      return m:mousepressed(button)
    end
  end
end
M.keypressed = function(self, key)
  do
    local m = self.menu
    if m then
      return m:keypressed(key)
    end
  end
end
M.mousemoved = function(self)
  do
    local m = self.menu
    if m then
      if m.mousemoved then
        return m:mousemoved(key)
      end
    end
  end
end
M.set_menu = function(self, name)
  self.menu = menus[name]
  local m = self.menu
  if m and m.opened then
    return m:opened()
  end
end
return M
