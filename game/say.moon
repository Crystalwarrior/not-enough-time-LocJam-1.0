lc = require "engine"
g = require "global"
utf8 = require("utf8")
import round from lc.steelpan.utils.math

wait_after = 0.3
time_per_character = 0.1
tmin = 1

box_width = 156
distance_from_character = 10
padding = 3

M = {}

local current_character, current_text_lowres, current_text_hires, t, tmax, cursor_oldstatus

say = (character, text, time) ->
    cursor = require "ui.cursor"
    -- cursor_oldstatus = cursor.hidden
    -- cursor.hidden = true
    setfenv(1, g.thread_registry\get_thread_environment())
    t = 0
    len = utf8.len(text)
    tmax = time or math.max(time_per_character*len, tmin)
    current_character = character
    current_text_lowres = love.graphics.newText(g.font_lowres)
    current_text_hires = love.graphics.newText(g.font_hires)
    current_text_hires\setf(text, box_width/g.hires_scale, "center")
    current_text_lowres\setf(text, box_width, "center")
    unless character.fake
        character\stop_walking()
        character._animation = character._talking_animations[character._direction]
        character._animation\start()
    wait_signal(character, "finished talking")

    unless character.fake
        character._animation = character._standing_animations[character._direction]
    wait(wait_after)

lc.extend_global_thread_environment({say: say})

finish = ->
    lc.signals.emit(current_character, "finished talking")
    current_character, current_text_lowres, current_text_hires = nil
    cursor = require "ui.cursor"
    -- cursor.hidden = cursor_oldstatus

M.update = (dt) ->
    return unless current_text_lowres
    t += dt
    if t > tmax
        finish()

M.skip = ->
    return unless current_text_lowres
    finish()

left_shift = box_width/2

draw = ->
    current_text = g.use_hires_font and current_text_hires or current_text_lowres
    font_scale = g.use_hires_font and g.hires_scale or 1
    h = font_scale*current_text\getHeight()
    local pos_x, pos_y
    if current_character.height
        pos_x = current_character._position.x
        pos_y = math.max(padding, current_character._position.y - current_character.height)
    else
        pos_x, pos_y = current_character._spk.point\unpack()

    pos_y = math.max(padding, pos_y - distance_from_character - h)
    w = round(font_scale*current_text\getWidth()/2)
    pos_x = math.max(w + padding, pos_x)
    pos_x = math.min(g.game_width - w - padding, pos_x)


    scale = g.use_hires_font and g.scale or 1
    xshift =  g.use_hires_font and g.xshift or 0
    yshift =  g.use_hires_font and g.yshift or 0

    love.graphics.push("all")
    love.graphics.setColor(current_character._spk.colour)
    love.graphics.scale(scale)
    love.graphics.translate(xshift, yshift)
    love.graphics.setFont(g.use_hires_font and g.font_hires or g.font_lowres)

    if g.use_hires_font
        love.graphics.setShader(g.hires_shader_outer)
        love.graphics.draw(current_text, pos_x - left_shift + 1, pos_y, 0, font_scale)
        love.graphics.setShader(g.hires_shader_inner)
    love.graphics.draw(current_text, pos_x - left_shift + 1, pos_y, 0, font_scale)
    love.graphics.pop()

M.draw_canvas = ->
    return unless current_text_lowres
    if not g.use_hires_font
        draw()
    
M.draw_screen = ->
    return unless current_text_lowres
    if g.use_hires_font
        draw()

M.is_on = =>
    return not not current_text_lowres

return M