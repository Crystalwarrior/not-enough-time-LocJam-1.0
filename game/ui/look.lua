local g = require("global")
local paddingX = 3
local paddingY = 1
local M = { }
M.colour = {
  1,
  0.9,
  0.5
}
M.text_lowres = love.graphics.newText(g.font)
M.text_hires = love.graphics.newText(g.font_hires)
M.update = function(self)
  do
    local t = g.hotspot.object and g.look_text
    if t then
      local w = g.game_width - 2 * paddingX - require("ui.cog").full_width
      self.text_lowres:setf(t, w, "left")
      self.text_hires:setf(t, w / g.hires_scale, "left")
      return 
    end
  end
  self.text_lowres:clear()
  return self.text_hires:clear()
end
local draw
draw = function()
  local text = g.use_hires_font and M.text_hires or M.text_lowres
  local xshift = g.use_hires_font and g.xshift or 0
  local yshift = g.use_hires_font and g.yshift or 0
  local scale = g.use_hires_font and g.scale or 1
  local font_scale = g.use_hires_font and g.hires_scale or 1
  love.graphics.push("all")
  love.graphics.scale(scale)
  love.graphics.translate(xshift, yshift)
  love.graphics.setColor(M.colour)
  if g.use_hires_font then
    love.graphics.setShader(g.hires_shader_outer)
    love.graphics.draw(text, paddingX, paddingY, 0, font_scale)
    love.graphics.setShader(g.hires_shader_inner)
  end
  love.graphics.draw(text, paddingX, paddingY, 0, font_scale)
  return love.graphics.pop()
end
M.draw_canvas = function(self)
  if g.blocked then
    return 
  end
  if not g.use_hires_font then
    return draw()
  end
end
M.draw_screen = function(self)
  if g.blocked then
    return 
  end
  if g.use_hires_font then
    return draw()
  end
end
return M
