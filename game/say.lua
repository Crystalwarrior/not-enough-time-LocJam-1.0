local lc = require("engine")
local g = require("global")
local utf8 = require("utf8")
local round
round = lc.steelpan.utils.math.round
local wait_after = 0.3
local time_per_character = 0.1
local tmin = 1
local box_width = 156
local distance_from_character = 10
local padding = 3
local M = { }
local skipping
local current_character, current_text_lowres, current_text_hires, t, tmax, cursor_oldstatus
local say
say = function(character, text, time)
  local cursor = require("ui.cursor")
  setfenv(1, g.thread_registry:get_thread_environment())
  t = 0
  local len = utf8.len(text)
  tmax = time or math.max(time_per_character * len, tmin)
  current_character = character
  current_text_lowres = love.graphics.newText(g.font_lowres)
  current_text_hires = love.graphics.newText(g.font_hires)
  current_text_hires:setf(text, box_width / g.hires_scale, "center")
  current_text_lowres:setf(text, box_width, "center")
  if not (character.fake) then
    character:stop_walking()
    character._animation = character._talking_animations[character._direction]
    character._animation:start()
  end
  wait_signal(character, "finished talking")
  if not (character.fake) then
    character._animation = character._standing_animations[character._direction]
  end
  if skipping then
    wait(0.1)
  end
  return wait(wait_after)
end
lc.extend_global_thread_environment({
  say = say
})
local finish
finish = function()
  lc.signals.emit(current_character, "finished talking")
  current_character, current_text_lowres, current_text_hires = nil
  local cursor = require("ui.cursor")
end
M.update = function(dt)
  if not (current_text_lowres) then
    return 
  end
  t = t + dt
  if t > tmax or (skipping and t > wait_after) then
    return finish()
  end
end
M.skip = function()
  if not (current_text_lowres) then
    return 
  end
  return finish()
end
M.start_skipping = function()
  skipping = true
end
M.stop_skipping = function()
  skipping = false
end
local left_shift = box_width / 2
local draw
draw = function()
  local current_text = g.use_hires_font and current_text_hires or current_text_lowres
  local font_scale = g.use_hires_font and g.hires_scale or 1
  local h = font_scale * current_text:getHeight()
  local pos_x, pos_y
  if current_character.height then
    pos_x = current_character._position.x
    pos_y = math.max(padding, current_character._position.y - current_character.height)
  else
    pos_x, pos_y = current_character._spk.point:unpack()
  end
  pos_y = math.max(padding, pos_y - distance_from_character - h)
  local w = round(font_scale * current_text:getWidth() / 2)
  pos_x = math.max(w + padding, pos_x)
  pos_x = math.min(g.game_width - w - padding, pos_x)
  local scale = g.use_hires_font and g.scale or 1
  local xshift = g.use_hires_font and g.xshift or 0
  local yshift = g.use_hires_font and g.yshift or 0
  love.graphics.push("all")
  love.graphics.setColor(current_character._spk.colour)
  love.graphics.scale(scale)
  love.graphics.translate(xshift, yshift)
  love.graphics.setFont(g.use_hires_font and g.font_hires or g.font_lowres)
  if g.use_hires_font then
    love.graphics.setShader(g.hires_shader_outer)
    love.graphics.draw(current_text, pos_x - left_shift + 1, pos_y, 0, font_scale)
    love.graphics.setShader(g.hires_shader_inner)
  end
  love.graphics.draw(current_text, pos_x - left_shift + 1, pos_y, 0, font_scale)
  return love.graphics.pop()
end
M.draw_canvas = function()
  if not (current_text_lowres) then
    return 
  end
  if not g.use_hires_font then
    return draw()
  end
end
M.draw_screen = function()
  if not (current_text_lowres) then
    return 
  end
  if g.use_hires_font then
    return draw()
  end
end
M.is_on = function(self)
  return not not current_text_lowres
end
return M
