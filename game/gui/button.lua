local Inky = require("3rd.inky")
require("ui")
local atlas = g.interface_atlas
local M = { }
M.new = Inky.defineElement(function(self)
  self.props.selected = false
  local pressed = false
  self:onPointer("press", function()
    pressed = true
  end)
  self:onPointer("release", function()
    if pressed then
      self.props.callback()
    end
    pressed = false
  end)
  self:onPointerEnter(function(self)
    if self.props.disabled then
      return true
    end
    self.props.selected = true
  end)
  self:onPointerExit(function(self)
    if self.props.disabled then
      return true
    end
    self.props.selected = false
  end)
  return function(self, x, y, w, h)
    local text = type(self.props.text) == "function" and self.props.text() or self.props.text
    atlas.button_side:draw(x, y)
    atlas.button_side:draw(x + w - 1, y)
    if self.props.selected then
      atlas.button2:draw(x + 1, y, 0, w - 2, 1)
    else
      atlas.button1:draw(x + 1, y, 0, w - 2, 1)
    end
    if g.use_hires_font then
      love.graphics.setShader(g.hires_shader_inner)
    end
    local font_scale = g.use_hires_font and g.hires_scale or 1
    if not self.props.selected then
      love.graphics.setColor(0.922, 0.506, 0.22)
    end
    love.graphics.printf(text, x, y, w / font_scale, "center", nil, font_scale)
    if g.use_hires_font then
      love.graphics.setShader()
    end
    return love.graphics.setColor(1, 1, 1)
  end
end)
M.height = g.font:getHeight()
return M
