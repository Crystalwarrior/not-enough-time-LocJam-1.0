local vortex = require("vortex")
local inventory = require("inventory")
local road = require("road")
local tunnel = require("tunnel")
local shake = require("shake")
local speak = require("say")
local ui = require("ui")
local gui = require("gui")
local skip = require("skip")
local game
game = require("engine").game
local dbg = g.debug and require("dbg" or nil)
local canvas = love.graphics.newCanvas(g.game_width, g.game_height)
vortex:set_position(158, 46)
love.draw = function()
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0, 0, 0, 1)
  if not (skip.skipping) then
    shake:push()
    vortex:draw()
    road:draw()
    tunnel:draw()
    love.graphics.push()
    love.graphics.translate(g.ending_shift or 0, 0)
    game.room:draw()
    love.graphics.pop()
    ui:draw_canvas()
    speak.draw_canvas()
    shake:pop()
  end
  if g.intro then
    g.intro:draw()
  end
  love.graphics.setCanvas()
  love.graphics.push()
  love.graphics.applyTransform(g.screen_transform)
  love.graphics.draw(canvas)
  love.graphics.pop()
  speak.draw_screen()
  gui:draw()
  if g.draw_credits then
    g.draw_credits()
  end
  if not g.blocked or gui.menu then
    ui:draw_screen()
  end
  if g.debug then
    return dbg.draw()
  end
end
