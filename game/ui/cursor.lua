local g = require("global")
local lc = require("engine")
local atlas = g.interface_atlas
local size = atlas.cursor_normal.size
local padding_top = 1
local padding_bottom = 0
local round = lc.steelpan.utils.math.round
local min_luminosity = 0.5
local period = 1.5
local factor = math.pi * 2 / period
local M = { }
M.mousemoved = function(self, x, y)
  self.x, self.y = x, y
end
M:mousemoved(0, 0)
local text_lowres = love.graphics.newText(g.font)
local text_hires = love.graphics.newText(g.font_hires)
M.draw = function(self)
  local luminosity = 1 - (min_luminosity / 2) * (1 + math.sin(factor * love.timer.getTime()))
  local cursor
  local menu_on = require("gui").menu
  local mouse_on_cog = require("ui.cog"):is_mouse_on()
  if lc.dialogues:is_running() then
    cursor = atlas.cursor_normal
    if not lc.dialogues:get_choices() then
      if not menu_on then
        return 
      end
    end
  end
  if menu_on then
    cursor = atlas.cursor_normal
  else
    do
      local obj = g.inventory_item
      if obj then
        cursor = atlas[obj.name]
      elseif g.hotspot.object and g.hotspot.object.interact then
        cursor = atlas.cursor_interact
      elseif mouse_on_cog then
        cursor = atlas.cursor_interact
      else
        cursor = atlas.cursor_normal
      end
    end
  end
  local halfsize = round(cursor.size / 2)
  local x, y = math.floor(self.x - g.scale * halfsize.x), math.floor(self.y - g.scale * halfsize.y)
  love.graphics.setColor(luminosity, luminosity, luminosity)
  cursor:draw(x, y, 0, g.scale)
  love.graphics.setColor(1, 1, 1)
  if lc.dialogues:is_running() or menu_on then
    return 
  end
  do
    local hotspot_text = (g.hotspot.object and g.hotspot_text) or (mouse_on_cog and TEXT(5, "options"))
    if hotspot_text then
      local scale = g.use_hires_font and g.hires_scale or 1
      local text = g.use_hires_font and text_hires or text_lowres
      text:set(hotspot_text)
      local w, h = text:getDimensions()
      local sw, sh = g.scale * scale * w, g.scale * scale * h
      x = math.max(math.floor(self.x - sw / 2), 0)
      x = math.min(x, love.graphics.getWidth() - sw)
      y = math.floor(self.y + g.scale * (halfsize.y + padding_top))
      if y > love.graphics.getHeight() - sh then
        y = math.floor(self.y - g.scale * (halfsize.y + padding_bottom) - sh)
      end
      love.graphics.push("all")
      if g.use_hires_font then
        love.graphics.setShader(g.hires_shader_outer)
        love.graphics.draw(text_hires, x, y, 0, g.scale * scale)
        love.graphics.setShader(g.hires_shader_inner)
      end
      love.graphics.draw(text, x, y, 0, g.scale * scale)
      return love.graphics.pop()
    end
  end
end
return M
