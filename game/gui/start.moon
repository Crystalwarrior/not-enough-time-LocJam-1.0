path = (...)\gsub("[^%.]*$", "")

Inky = require "3rd.inky"
Button = require path .. "button"
Checkbox = require path .. "checkbox"
Spin = require path .. "spin"
g = require "global"
lc = require "engine"

import nineBgmenu from require path .. "nine"

scene = Inky.scene()
pointer = Inky.pointer(scene)

buttons = {
    start: Button.new(scene)
    options: Button.new(scene)
    spin: Button.new(scene)
}
buttons.start.props.text = -> TEXT(344, "Start game")
buttons.options.props.text = -> TEXT(345, "Options")

buttons.start.props.callback = ->
    g.game_started = true
    require("gui")\set_menu(nil)

buttons.options.props.callback = ->
    require("gui")\set_menu("options")

buttons.spin.props.disabled = true
buttons.spin.props.text = ""

spins = {lang: Spin.new(scene)}

lc.tr_text = require "text_translated"

translated_language = TEXT(652, "<translated language>")
english = "English"
w1 = g.font\getWidth(translated_language)
w2 = g.font\getWidth(english)
spin_width = math.max(w1, w2) + 10

spins.lang.props.text = translated_language

buttons.spin.props.callback = (selected) ->
    if lc.tr_text == require "text_translated"
        lc.tr_text = require "text_english"
        spins.lang.props.text = english
    else
        lc.tr_text = require "text_translated"
        spins.lang.props.text = translated_language

M = {}

M.update = =>
    pointer\setPosition(g.p.x, g.p.y)

M.draw = =>
    scene\beginFrame()

    love.graphics.push("all")
    love.graphics.setFont(g.use_hires_font and g.font_hires or g.font_no_outline)
    font_scale = g.use_hires_font and g.hires_scale or 1

    love.graphics.scale(g.scale)
    love.graphics.translate(g.xshift, g.yshift)

    w1 = love.graphics.getFont()\getWidth(buttons.start.props.text())*font_scale + 10
    w2 = love.graphics.getFont()\getWidth(buttons.options.props.text())*font_scale + 10
    w = math.max(w1, w2, spin_width + 4)

    y = 88
    buttons.start\render((g.game_width - w)/2, y, w, Button.height)
    y += Button.height + 1
    buttons.options\render((g.game_width - w)/2, y, w, Button.height)
    y += Button.height + 1
    buttons.spin\render((g.game_width - w)/2, y, w, Button.height)
    spins.lang\render((g.game_width - spin_width)/2, y, spin_width, Button.height)

    scene\finishFrame()

    love.graphics.pop()


M.mousereleased = =>
    pointer\raise("release")

M.mousepressed = (button) =>
    pointer\raise("press")

M.keypressed = (key) =>
    if key == "c"
        g.test_credits = true
        require("credits")
        package.loaded.credits = nil
        require("gui").menu = nil

M.mousemoved = =>
    pointer\raise("move")

return M