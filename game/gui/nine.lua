local Class = require("engine.steelpan.class")
local NineBg = Class({
  __init = function(self, atlas_sprite)
    self.texture = atlas_sprite.spritesheet
    self.padding = {
      x = (atlas_sprite.size.x - 1) / 2,
      y = (atlas_sprite.size.y - 1) / 2
    }
    local ox, oy = atlas_sprite.quad:getViewport()
    local sw, sh = atlas_sprite.quad:getTextureDimensions()
    self.quads = {
      TL = love.graphics.newQuad(ox, oy, self.padding.x, self.padding.y, sw, sh),
      TR = love.graphics.newQuad(ox + self.padding.x + 1, oy, self.padding.x, self.padding.y, sw, sh),
      BL = love.graphics.newQuad(ox, oy + self.padding.y + 1, self.padding.x, self.padding.y, sw, sh),
      BR = love.graphics.newQuad(ox + self.padding.x + 1, oy + self.padding.y + 1, self.padding.x, self.padding.y, sw, sh),
      L = love.graphics.newQuad(ox, oy + self.padding.y, self.padding.x, 1, sw, sh),
      R = love.graphics.newQuad(ox + self.padding.x + 1, oy + self.padding.y, self.padding.x, 1, sw, sh),
      T = love.graphics.newQuad(ox + self.padding.x, oy, 1, self.padding.y, sw, sh),
      B = love.graphics.newQuad(ox + self.padding.x, oy + self.padding.y + 1, 1, self.padding.y, sw, sh),
      C = love.graphics.newQuad(ox + self.padding.x, oy + self.padding.y, 1, 1, sw, sh)
    }
  end,
  draw = function(self, x, y, w, h)
    love.graphics.push("all")
    love.graphics.translate(x, y)
    love.graphics.draw(self.texture, self.quads.TL, -self.padding.x, -self.padding.y)
    love.graphics.draw(self.texture, self.quads.TR, w, -self.padding.y)
    love.graphics.draw(self.texture, self.quads.BL, -self.padding.x, h)
    love.graphics.draw(self.texture, self.quads.BR, w, h)
    love.graphics.draw(self.texture, self.quads.C, 0, 0, 0, w, h)
    love.graphics.draw(self.texture, self.quads.T, 0, -self.padding.y, 0, w, 1)
    love.graphics.draw(self.texture, self.quads.B, 0, h, 0, w, 1)
    love.graphics.draw(self.texture, self.quads.L, -self.padding.x, 0, 0, 1, h)
    love.graphics.draw(self.texture, self.quads.R, w, 0, 0, 1, h)
    return love.graphics.pop()
  end
})
require("ui")
local atlas = g.interface_atlas
local M = { }
M.nineBgmenu = NineBg(atlas.ui_bg_normal)
return M
