local path = (...):gsub("[^%.]*$", "")
local Inky = require("3rd.inky")
local Button = require(path .. "button")
local Checkbox = require(path .. "checkbox")
local Spin = require(path .. "spin")
local g = require("global")
local lc = require("engine")
local nineBgmenu
nineBgmenu = require(path .. "nine").nineBgmenu
local scene = Inky.scene()
local pointer = Inky.pointer(scene)
local buttons = {
  start = Button.new(scene),
  options = Button.new(scene),
  spin = Button.new(scene)
}
buttons.start.props.text = function()
  return TEXT(344, "Start game")
end
buttons.options.props.text = function()
  return TEXT(345, "Options")
end
buttons.start.props.callback = function()
  g.game_started = true
  return require("gui"):set_menu(nil)
end
buttons.options.props.callback = function()
  return require("gui"):set_menu("options")
end
buttons.spin.props.disabled = true
buttons.spin.props.text = ""
local spins = {
  lang = Spin.new(scene)
}
lc.tr_text = require("text_translated")
local translated_language = TEXT(652, "<translated language>")
local english = "English"
local w1 = g.font:getWidth(translated_language)
local w2 = g.font:getWidth(english)
local spin_width = math.max(w1, w2) + 10
spins.lang.props.text = translated_language
buttons.spin.props.callback = function(selected)
  if lc.tr_text == require("text_translated") then
    lc.tr_text = require("text_english")
    spins.lang.props.text = english
  else
    lc.tr_text = require("text_translated")
    spins.lang.props.text = translated_language
  end
end
local M = { }
M.update = function(self)
  return pointer:setPosition(g.p.x, g.p.y)
end
M.draw = function(self)
  scene:beginFrame()
  love.graphics.push("all")
  love.graphics.setFont(g.use_hires_font and g.font_hires or g.font_no_outline)
  local font_scale = g.use_hires_font and g.hires_scale or 1
  love.graphics.scale(g.scale)
  love.graphics.translate(g.xshift, g.yshift)
  w1 = love.graphics.getFont():getWidth(buttons.start.props.text()) * font_scale + 10
  w2 = love.graphics.getFont():getWidth(buttons.options.props.text()) * font_scale + 10
  local w = math.max(w1, w2, spin_width + 4)
  local y = 88
  buttons.start:render((g.game_width - w) / 2, y, w, Button.height)
  y = y + (Button.height + 1)
  buttons.options:render((g.game_width - w) / 2, y, w, Button.height)
  y = y + (Button.height + 1)
  buttons.spin:render((g.game_width - w) / 2, y, w, Button.height)
  spins.lang:render((g.game_width - spin_width) / 2, y, spin_width, Button.height)
  scene:finishFrame()
  return love.graphics.pop()
end
M.mousereleased = function(self)
  return pointer:raise("release")
end
M.mousepressed = function(self, button)
  return pointer:raise("press")
end
M.keypressed = function(self, key)
  if key == "c" then
    g.test_credits = true
    require("credits")
    package.loaded.credits = nil
    require("gui").menu = nil
  end
end
M.mousemoved = function(self)
  return pointer:raise("move")
end
return M
