g = require "global"
inventory = require "inventory"

atlas = g.interface_atlas

tile_size = 24

M = {}

M.draw = =>
    return if @hidden
    love.graphics.push("all")
    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", 0, g.game_height - tile_size, g.game_width, tile_size)
    love.graphics.setColor(1, 1, 1)
    atlas.bag\draw(0, g.game_height - tile_size)

    if g.inventory_item
        atlas.back\draw(tile_size, g.game_height - tile_size)
    else
        for i, obj in ipairs(inventory.bag)
            love.graphics.setColor(1, 1, 1, obj.alpha or 1)
            atlas[obj.name]\draw(tile_size*i, g.game_height - tile_size)
            love.graphics.setColor(1, 1, 1)
    love.graphics.pop()

-- M.selec

M.mousemoved = (x, y) =>
    return if g.inventory_item or @hidden

    if y >= g.game_height - tile_size and y <= g.game_height
        for i, obj in ipairs(inventory.bag)
            if x >= tile_size*i and x <= tile_size*(i + 1)
                g.hotspot_text = obj.description and obj.description()
                g.look_text = obj.look_text and obj.look_text()
                g.hotspot.type = "inventory"
                g.hotspot.object = obj
    
M.mouse_on_inventory = (x, y) =>
    return not @hidden and y >= g.game_height - tile_size and y <= g.game_height and x >=0 and x <= g.game_width

return M