local Inky = require("3rd.inky")
require("ui")
local atlas = g.interface_atlas
local M = { }
M.height = g.font:getHeight()
local arrow_width = atlas.arrow.size.x
local arrow_offset_y = (M.height - atlas.arrow.size.y) / 2
M.new = Inky.defineElement(function(self)
  self.props.selected = nil
  local pressed = false
  self:onPointer("press", function(self)
    pressed = self.props.selected and true
  end)
  self:onPointer("move", function(self, pointer)
    local X, _, w
    X, _, w, _ = self:getView()
    local x = pointer:getPosition()
    x = x - X
    if x >= 0 and x <= arrow_width then
      self.props.selected = "l"
    elseif x >= w - arrow_width and x <= w then
      self.props.selected = "r"
    else
      self.props.selected = nil
    end
  end)
  self:onPointer("release", function(self)
    if pressed then
      self.props.callback(self.props.selected)
    end
    pressed = false
  end)
  self:onPointerEnter(function(self)
    self.props.selected = true
  end)
  self:onPointerExit(function(self)
    self.props.selected = false
  end)
  return function(self, x, y, w, h)
    local text = type(self.props.text) == "function" and self.props.text() or self.props.text
    local arrow_l = self.props.selected == "l" and atlas.arrow_on or atlas.arrow
    local arrow_r = self.props.selected == "r" and atlas.arrow_on or atlas.arrow
    arrow_l:draw(x + arrow_width, y + arrow_offset_y, 0, -1, 1)
    arrow_r:draw(x + w - arrow_width, y + arrow_offset_y)
    if g.use_hires_font then
      love.graphics.setShader(g.hires_shader_inner)
    end
    local font_scale = g.use_hires_font and g.hires_scale or 1
    love.graphics.printf(text, x, y, w / font_scale, "center", nil, font_scale)
    if g.use_hires_font then
      return love.graphics.setShader()
    end
  end
end)
return M
