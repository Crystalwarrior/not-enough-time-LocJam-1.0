local path = (...):gsub("[^%.]*$", "")
local Inky = require("3rd.inky")
local Button = require(path .. "button")
local Checkbox = require(path .. "checkbox")
local Slider = require(path .. "slider")
local Spin = require(path .. "spin")
local MouseIcon = require(path .. "mouse_icon")
local nineBgmenu
nineBgmenu = require(path .. "nine").nineBgmenu
local g = require("global")
local lc = require("engine")
local scene = Inky.scene()
local pointer = Inky.pointer(scene)
local buttons = {
  delete_save = Button.new(scene),
  back = Button.new(scene),
}
local clicked_delete_save = false
local save_file_exists = g:saveGameExists()
buttons.delete_save.props.text = function()
  if clicked_delete_save then
    return TEXT(655, "Are You Sure?")
  end
  return TEXT(654, "Delete Save File")
end
buttons.delete_save.props.callback = function()
  if not save_file_exists then
    return
  end
  if not clicked_delete_save then
    clicked_delete_save = true
    return
  end
  g:wipeGame()
  save_file_exists = g:saveGameExists()
end
buttons.back.props.text = function()
  return TEXT(333, "Return to game")
end
buttons.back.props.callback = function()
  clicked_delete_save = false
  local gui = require("gui")
  g.paused = false
  g:saveOptions()
  return gui:set_menu(not g.game_started and "start" or nil)
end
local checkboxes = {
  skip_left = Checkbox.new(scene),
  skip_right = Checkbox.new(scene),
  fullscreen = Checkbox.new(scene)
}
checkboxes.skip_left.props.checked = g.skip_with_left
checkboxes.skip_left.props.callback = function(value)
  g.skip_with_left = value
end
checkboxes.skip_right.props.checked = g.skip_with_right
checkboxes.skip_right.props.callback = function(value)
  g.skip_with_right = value
end
checkboxes.fullscreen.props.checked = g.fullscreen
checkboxes.fullscreen.props.callback = function(value)
  g.fullscreen = not love.window.getFullscreen()
  love.window.setFullscreen(g.fullscreen, "desktop")
  love.resize(love.graphics.getDimensions())
  return love.mousemoved(love.mouse.getPosition())
end

local sliders = {
  volume = Slider.new(scene),
  say_speed = Slider.new(scene),
}
local audio = require("audio")
sliders.volume.props.progress = g.volume
sliders.volume.props.callback = function(progress)
  return audio.set_volume(progress)
end

sliders.say_speed.props.progress = g.say_speed
sliders.say_speed.props.callback = function(progress)
  g.say_speed = progress
end

local M = { }
M.update = function(self)
  pointer:setPosition(g.p.x, g.p.y)
  checkboxes.skip_left.props.checked = g.skip_with_left
  checkboxes.skip_right.props.checked = g.skip_with_right
  checkboxes.fullscreen.props.checked = g.fullscreen
end
local menu_padding = 11
local menu_width = g.game_width - 2 * menu_padding
local menu_height = g.game_height - 2 * menu_padding
local text_padding = 3
local button_width = 100
local slider_width = 75
local newline
newline = function(x, y)
  y = y + g.font:getHeight()
  love.graphics.setColor(0.694, 0.318, 0.055)
  love.graphics.rectangle("fill", x, y, menu_width, 1)
  love.graphics.setColor(1, 1, 1)
  y = y + 1
  return x, y
end
local print_text
print_text = function(text, x, y, limit)
  if limit == nil then
    limit = g.game_width
  end
  local _, wrappedtext = g.font:getWrap(text, limit)
  for i, t in ipairs(wrappedtext) do
    love.graphics.print(t, x, y)
    if i < #wrappedtext then
      y = y + g.font:getHeight()
    end
  end
  return y
end
local printf_text
printf_text = function(text, x, y, w, align, limit)
  local font_scale = g.use_hires_font and g.hires_scale or 1
  if g.use_hires_font then
    love.graphics.setShader(g.hires_shader_inner)
  end
  love.graphics.printf(text, x, y, w / font_scale, align, limit, font_scale)
  if g.use_hires_font then
    return love.graphics.setShader()
  end
end
M.draw = function(self)
  love.graphics.push("all")
  love.graphics.setFont(g.use_hires_font and g.font_hires or g.font_no_outline)
  local font_scale = g.use_hires_font and g.hires_scale or 1
  love.graphics.scale(g.scale)
  love.graphics.translate(g.xshift, g.yshift)
  love.graphics.setColor(0, 0, 0, 0.2)
  love.graphics.rectangle("fill", 0, 0, g.game_width, g.game_height)
  love.graphics.setColor(1, 1, 1)
  local x, y = menu_padding, menu_padding
  nineBgmenu:draw(x, y, menu_width, menu_height)
  y = y + 5
  scene:beginFrame()

  if save_file_exists then
    -- delete save button
    text = buttons.delete_save.props.text()
    w = love.graphics.getFont():getWidth(text) * font_scale + 10
    buttons.delete_save:render(x + (menu_width - w), y, w, Button.height)
    y = y + Button.height
  end

  -- music slider
  sliders.volume:render(x, y + Slider.yoffset, slider_width, Slider.height)
  y = print_text(TEXT(335, "Music volume"), x + text_padding + slider_width, y)
  x, y = newline(x, y)
  -- say speed slider
  sliders.say_speed:render(x, y + Slider.yoffset, slider_width, Slider.height)
  y = print_text(TEXT(656, "Speech speed"), x + text_padding + slider_width, y)
  x, y = newline(x, y)
  -- fullscreen toggle
  checkboxes.fullscreen:render(x, y + Checkbox.yoffset, Checkbox.size.x, Checkbox.size.y)
  y = print_text(TEXT(649, "Fullscreen"), x + text_padding + Checkbox.size.x, y)
  x, y = newline(x, y)

  -- setup for checkboxes
  local atlas = g.interface_atlas
  local mouse_icon_size_x = atlas.ui_mouse_lmb.size.x

  -- skip with LMB
  checkboxes.skip_left:render(x, y + Checkbox.yoffset, Checkbox.size.x, Checkbox.size.y)
  atlas.ui_mouse_lmb:draw(x + Checkbox.size.x, y)
  y = print_text(TEXT(650, "LMB to Skip dialogues"), x + text_padding + Checkbox.size.x + mouse_icon_size_x, y, menu_width - text_padding - Checkbox.size.x)
  x, y = newline(x, y)
  -- skip with RMB
  checkboxes.skip_right:render(x, y + Checkbox.yoffset, Checkbox.size.x, Checkbox.size.y)
  atlas.ui_mouse_rmb:draw(x + Checkbox.size.x, y)
  y = print_text(TEXT(651, "RMB to Skip dialogues"), x + text_padding + Checkbox.size.x + mouse_icon_size_x, y, menu_width - text_padding - Checkbox.size.x)
  x, y = newline(x, y)

  -- back button
  local text = buttons.back.props.text()
  local w = love.graphics.getFont():getWidth(text) * font_scale + 10
  buttons.back:render(x + (menu_width - w) / 2, menu_padding + menu_height - Button.height, w, Button.height)

  scene:finishFrame()
  return love.graphics.pop()
end
local skip_next_release
M.mousereleased = function(self)
  if skip_next_release then
    skip_next_release = false
    return 
  end
  return pointer:raise("release")
end
M.mousepressed = function(self, button)
  return pointer:raise("press")
end
M.keypressed = function(self, key) end
M.mousemoved = function(self)
  pointer:raise("move")
  if love.mouse.isDown(1) then
    return pointer:raise("drag")
  end
end
M.opened = function(self)
  save_file_exists = g:saveGameExists()
  sliders.volume.props.progress = g.volume
  sliders.say_speed.props.progress = g.say_speed
end
return M
