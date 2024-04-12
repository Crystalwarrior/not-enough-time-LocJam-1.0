path = (...)\gsub("[^%.]*$", "")

Inky = require "3rd.inky"
Button = require path .. "button"
Checkbox = require path .. "checkbox"
Slider = require path .. "slider"
Spin = require path .. "spin"

import nineBgmenu from require path .. "nine"
g = require "global"

lc = require "engine"


scene = Inky.scene()
pointer = Inky.pointer(scene)

buttons = {
    back: Button.new(scene)
}
buttons.back.props.text = -> TEXT(333, "Return to game")
buttons.back.props.callback = ->
    gui = require "gui"
    gui\set_menu(not g.game_started and "start" or nil)

checkboxes = {
    skip_left: Checkbox.new(scene)
    skip_right: Checkbox.new(scene)
    fullscreen: Checkbox.new(scene)
}
checkboxes.skip_left.props.checked = not not g.skip_with_left
checkboxes.skip_left.props.callback = (value) ->
    g.skip_with_left = value

checkboxes.skip_right.props.checked = not not g.skip_with_right
checkboxes.skip_right.props.callback = (value) ->
    g.skip_with_right = value

checkboxes.fullscreen.props.checked = not not g.fullscreen
checkboxes.fullscreen.props.callback = (value) ->
    g.fullscreen = not love.window.getFullscreen()
    love.window.setFullscreen(g.fullscreen, "desktop")
    love.resize(love.graphics.getDimensions())
    love.mousemoved(love.mouse.getPosition())

sliders = {
    volume: Slider.new(scene)
}

audio = require "audio"

sliders.volume.props.progress = g.volume
sliders.volume.props.callback = (progress) ->
    audio.set_volume(progress)

M = {}

M.update = =>
    pointer\setPosition(g.p.x, g.p.y)
    checkboxes.fullscreen.props.checked = g.fullscreen

menu_padding = 11
menu_width = g.game_width - 2*menu_padding
menu_height = g.game_height - 2*menu_padding
text_padding = 3

button_width = 100
slider_width = 75

newline = (x, y) ->
    y += g.font\getHeight()
    love.graphics.setColor(0.694, 0.318, 0.055)
    love.graphics.rectangle("fill", x, y, menu_width, 1)
    love.graphics.setColor(1, 1, 1)
    y += 1
    return x, y

print_text = (text, x, y, limit=g.game_width) ->
    _, wrappedtext = g.font\getWrap(text, limit)
    for i, t in ipairs(wrappedtext)
        love.graphics.print(t, x, y)
        y += g.font\getHeight() if i < #wrappedtext
    return y

printf_text = (text, x, y, w, align, limit) ->
    font_scale = g.use_hires_font and g.hires_scale or 1
    love.graphics.setShader(g.hires_shader_inner) if g.use_hires_font
    love.graphics.printf(text, x, y, w/font_scale, align, limit, font_scale)
    love.graphics.setShader() if g.use_hires_font

M.draw = =>
    love.graphics.push("all")
    love.graphics.setFont(g.use_hires_font and g.font_hires or g.font_no_outline)
    font_scale = g.use_hires_font and g.hires_scale or 1

    love.graphics.scale(g.scale)
    love.graphics.translate(g.xshift, g.yshift)

    love.graphics.setColor(0,0,0, 0.2)
    love.graphics.rectangle("fill", 0, 0, g.game_width, g.game_height)
    love.graphics.setColor(1,1,1)

    x, y = menu_padding, menu_padding

    nineBgmenu\draw(x, y, menu_width, menu_height)
    
    y += 5

    scene\beginFrame()
    
    sliders.volume\render(x, y + Slider.yoffset, slider_width, Slider.height)
    y = print_text(TEXT(335, "Music volume"), x + text_padding + slider_width, y)
    x, y = newline(x, y)
    checkboxes.fullscreen\render(x , y + Checkbox.yoffset, Checkbox.size.x, Checkbox.size.y)
    y = print_text(TEXT(649, "Fullscreen"), x + text_padding + Checkbox.size.x, y)
    x, y = newline(x, y)
    checkboxes.skip_left\render(x , y + Checkbox.yoffset, Checkbox.size.x, Checkbox.size.y)
    y = print_text(TEXT(650, "Skip dialogues with left mouse button"), x + text_padding + Checkbox.size.x, y, menu_width - text_padding - Checkbox.size.x)
    x, y = newline(x, y)
    checkboxes.skip_right\render(x , y + Checkbox.yoffset, Checkbox.size.x, Checkbox.size.y)
    print_text(TEXT(651, "Skip dialogues with right mouse button"), x + text_padding + Checkbox.size.x, y, menu_width - text_padding - Checkbox.size.x)
        
    text = buttons.back.props.text()
    w = love.graphics.getFont()\getWidth(text)*font_scale + 10
    buttons.back\render(x + (menu_width - w)/2, menu_padding + menu_height - Button.height, w, Button.height)

    scene\finishFrame()

    love.graphics.pop()


local skip_next_release

M.mousereleased = =>
    if skip_next_release
        skip_next_release = false
        return
    pointer\raise("release")

M.mousepressed = (button) =>
    pointer\raise("press")


M.keypressed = (key) =>

M.mousemoved = =>
    pointer\raise("move")
    if love.mouse.isDown(1) then
        pointer\raise("drag")


return M