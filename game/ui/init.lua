local path = (...):gsub(".init$", "") .. '.'
local g = require("global")
local Atlas = require("engine.steelpan.atlas")
g.interface_atlas = Atlas("assets/spritesheets/interface.lua")
local lc = require("engine")
local skip = require("skip")
g.font_lowres = love.graphics.setNewFont("assets/fonts/LanaPixel_outline.fnt")
g.font_no_outline = love.graphics.newFont("assets/fonts/LanaPixel.fnt")
g.font_hires = g.font_lowres
g.font = g.font_lowres
g.hires_scale = g.font_lowres:getHeight() / g.font_hires:getHeight()
local cursor = require(path .. "cursor")
local look = require(path .. "look")
local inventory = require(path .. "inventory")
local dialogues = require(path .. "dialogues")
local cog = require(path .. "cog")
local M = { }
M.draw_canvas = function(self)
  if lc.dialogues:is_running() then
    dialogues:draw_canvas()
  else
    inventory:draw()
    if not require("gui").menu then
      look:draw_canvas()
    end
  end
  skip:draw_canvas()
  return cog:draw_canvas()
end
M.draw_screen = function(self)
  if lc.dialogues:is_running() then
    dialogues:draw_screen()
  else
    if not require("gui").menu then
      look:draw_screen()
    end
  end
  return cursor:draw()
end
M.update = function(self, dt)
  look:update()
  if lc.dialogues:is_running() then
    return dialogues:update()
  end
end
M.mousemoved = function(self, x, y, p)
  cursor:mousemoved(x, y)
  if lc.dialogues:is_running() then
    return dialogues:mousemoved(p.x, p.y)
  else
    return inventory:mousemoved(p.x, p.y)
  end
end
M.mousereleased = function(self)
  if lc.dialogues:is_running() then
    return dialogues:mousereleased()
  end
end
M.wheelmoved = function(self, x, y)
  if lc.dialogues:is_running() then
    return dialogues:wheelmoved(y)
  end
end
M.mouse_on_inventory = function(self, x, y)
  return inventory:mouse_on_inventory(x, y)
end
return M
