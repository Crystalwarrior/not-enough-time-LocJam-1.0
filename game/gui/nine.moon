Class = require "engine.steelpan.class"

NineBg = Class {
    __init: (atlas_sprite) =>
        @texture = atlas_sprite.spritesheet
        @padding = {x: (atlas_sprite.size.x - 1)/2, y: (atlas_sprite.size.y - 1)/2}
        ox, oy = atlas_sprite.quad\getViewport()
        sw, sh = atlas_sprite.quad\getTextureDimensions()
        @quads = {
            TL: love.graphics.newQuad(ox, oy, @padding.x, @padding.y, sw, sh)
            TR: love.graphics.newQuad(ox + @padding.x + 1, oy, @padding.x, @padding.y, sw, sh)
            BL: love.graphics.newQuad(ox, oy + @padding.y + 1, @padding.x, @padding.y, sw, sh)
            BR: love.graphics.newQuad(ox + @padding.x + 1, oy + @padding.y + 1, @padding.x, @padding.y, sw, sh)
            L: love.graphics.newQuad(ox,  oy + @padding.y, @padding.x, 1, sw, sh)
            R: love.graphics.newQuad(ox + @padding.x + 1,  oy + @padding.y, @padding.x, 1, sw, sh)
            T: love.graphics.newQuad(ox + @padding.x,  oy, 1, @padding.y, sw, sh)
            B: love.graphics.newQuad(ox + @padding.x,  oy + @padding.y + 1, 1, @padding.y, sw, sh)
            C: love.graphics.newQuad(ox + @padding.x,  oy + @padding.y, 1, 1, sw, sh)
        }
        

    draw: (x, y, w, h) =>
        love.graphics.push("all")
        love.graphics.translate(x, y)
        love.graphics.draw(@texture, @quads.TL, -@padding.x, -@padding.y)
        love.graphics.draw(@texture, @quads.TR, w, -@padding.y)
        love.graphics.draw(@texture, @quads.BL, -@padding.x, h)
        love.graphics.draw(@texture, @quads.BR, w, h)
        love.graphics.draw(@texture, @quads.C, 0, 0, 0, w, h)
        love.graphics.draw(@texture, @quads.T, 0, -@padding.y, 0, w, 1)
        love.graphics.draw(@texture, @quads.B, 0, h, 0, w, 1)
        love.graphics.draw(@texture, @quads.L, -@padding.x, 0, 0, 1, h)
        love.graphics.draw(@texture, @quads.R, w, 0, 0, 1, h)
        love.graphics.pop()

}


require "ui" -- to ensure atlas is loaded
atlas = g.interface_atlas
    
M = {}   
    
M.nineBgmenu = NineBg(atlas.ui_bg_normal)

return M