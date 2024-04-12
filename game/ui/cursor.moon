g = require "global"
lc = require "engine"
atlas = g.interface_atlas
size = atlas.cursor_normal.size
padding_top = 1
padding_bottom = 0
round = lc.steelpan.utils.math.round

min_luminosity = 0.5
period = 1.5
factor = math.pi*2/period

M = {}

M.mousemoved = (@x, @y) =>

M\mousemoved(0, 0)

text_lowres = love.graphics.newText(g.font)
text_hires = love.graphics.newText(g.font_hires)

M.draw = =>
    luminosity = 1 - (min_luminosity/2)*(1 + math.sin(factor*love.timer.getTime()))
    local cursor

    menu_on = require("gui").menu
    mouse_on_cog = require("ui.cog")\is_mouse_on()

    if lc.dialogues\is_running()
        cursor = atlas.cursor_normal
        if not lc.dialogues\get_choices()
            return if not menu_on

    if menu_on
        cursor = atlas.cursor_normal
    elseif obj = g.inventory_item
        cursor = atlas[obj.name]
    elseif g.hotspot.object and g.hotspot.object.interact
        cursor = atlas.cursor_interact
    elseif mouse_on_cog
        cursor = atlas.cursor_interact       
    else
        cursor = atlas.cursor_normal

    halfsize = round(cursor.size/2)

    x, y = math.floor(@x - g.scale*halfsize.x), math.floor(@y - g.scale*halfsize.y)
    love.graphics.setColor(luminosity, luminosity, luminosity)
    cursor\draw(x, y, 0, g.scale)
    love.graphics.setColor(1, 1, 1)

    return if lc.dialogues\is_running() or menu_on

    if hotspot_text = (g.hotspot.object and g.hotspot_text) or (mouse_on_cog and TEXT(5, "options"))
        scale = g.use_hires_font and g.hires_scale or 1
        text = g.use_hires_font and text_hires or text_lowres
        text\set(hotspot_text)
        w, h = text\getDimensions()
        sw, sh = g.scale*scale*w, g.scale*scale*h
        x = math.max(math.floor(@x - sw/2), 0)
        x = math.min(x, love.graphics.getWidth() - sw)

        y = math.floor(@y + g.scale*(halfsize.y + padding_top))
        if y > love.graphics.getHeight() - sh
            y = math.floor(@y - g.scale*(halfsize.y + padding_bottom) - sh)
        love.graphics.push("all")
        if g.use_hires_font
            love.graphics.setShader(g.hires_shader_outer)
            love.graphics.draw(text_hires, x, y, 0, g.scale*scale)
            love.graphics.setShader(g.hires_shader_inner)
        love.graphics.draw(text, x, y, 0, g.scale*scale)
        love.graphics.pop()


return M