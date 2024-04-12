local Inky = require("3rd.inky")
local path = (...):gsub("[^%.]*$", "")
require("ui")
local atlas = g.interface_atlas
local M = { }
M.new = Inky.defineElement(function(self)
  self.props.right_button = false
  self.props.size = atlas.ui_mouse_lmb.size
  local pressed = false
  return function(self, x, y, w, h)
    if self.props.right_button then
      return atlas.ui_mouse_rmb:draw(x, y)
    else
      return atlas.ui_mouse_lmb:draw(x, y)
    end
  end
end)
M.size = atlas.ui_mouse_lmb.size
M.yoffset = 0.5 * (g.font:getHeight() - M.size.y)
return M
