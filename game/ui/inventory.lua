local g = require("global")
local inventory = require("inventory")
local atlas = g.interface_atlas
local tile_size = 24
local M = { }
M.draw = function(self)
  if self.hidden then
    return 
  end
  love.graphics.push("all")
  love.graphics.setColor(0, 0, 0, 0.3)
  love.graphics.rectangle("fill", 0, g.game_height - tile_size, g.game_width, tile_size)
  love.graphics.setColor(1, 1, 1)
  atlas.bag:draw(0, g.game_height - tile_size)
  if g.inventory_item then
    atlas.back:draw(tile_size, g.game_height - tile_size)
  else
    for i, obj in ipairs(inventory.bag) do
      love.graphics.setColor(1, 1, 1, obj.alpha or 1)
      atlas[obj.name]:draw(tile_size * i, g.game_height - tile_size)
      love.graphics.setColor(1, 1, 1)
    end
  end
  return love.graphics.pop()
end
M.mousemoved = function(self, x, y)
  if g.inventory_item or self.hidden then
    return 
  end
  if y >= g.game_height - tile_size and y <= g.game_height then
    for i, obj in ipairs(inventory.bag) do
      if x >= tile_size * i and x <= tile_size * (i + 1) then
        g.hotspot_text = obj.description and obj.description()
        g.look_text = obj.look_text and obj.look_text()
        g.hotspot.type = "inventory"
        g.hotspot.object = obj
      end
    end
  end
end
M.mouse_on_inventory = function(self, x, y)
  return not self.hidden and y >= g.game_height - tile_size and y <= g.game_height and x >= 0 and x <= g.game_width
end
return M
