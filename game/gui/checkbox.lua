local Inky = require("3rd.inky")
local path = (...):gsub("[^%.]*$", "")
require("ui")
local atlas = g.interface_atlas
local M = { }
M.new = Inky.defineElement(function(self)
  self.props.checked = false
  self.props.size = atlas.check_on.size
  local pressed = false
  self:onPointer("press", function(self)
    pressed = true
  end)
  self:onPointer("release", function(self)
    if pressed then
      self.props.checked = not self.props.checked
      do
        local f = self.props.callback
        if f then
          f(self.props.checked)
        end
      end
    end
    pressed = false
  end)
  self:onPointerEnter(function(self) end)
  self:onPointerExit(function(self) end)
  return function(self, x, y, w, h)
    if self.props.checked then
      return atlas.check_on:draw(x, y)
    else
      return atlas.check_off:draw(x, y)
    end
  end
end)
M.size = atlas.check_on.size
M.yoffset = 0.5 * (g.font:getHeight() - M.size.y)
return M
