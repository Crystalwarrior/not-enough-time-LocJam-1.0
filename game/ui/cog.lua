local g = require("global")
local lc = require("engine")
local sprite = g.interface_atlas.cog
local size = sprite.size
local padding = 1
local M = { }
M.full_width = sprite.size.x + padding
local is_hidden
is_hidden = function()
  return g.blocked or lc.dialogues:is_running() or require("gui").menu
end
M.draw_canvas = function(self)
  if is_hidden() then
    return 
  end
  return sprite:draw(g.game_width - padding - size.x, padding)
end
M.is_mouse_on = function(self)
  if is_hidden() then
    return 
  end
  local x, y = g.p:unpack()
  return x >= g.game_width - padding - size.x and x <= g.game_width - padding and y >= padding and y <= padding + size.y
end
return M
