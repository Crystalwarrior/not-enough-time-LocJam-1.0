g = require "global"

paddingX = 3
paddingY = 1

M = {}

M.colour = {1, 0.9, 0.5}

M.text_lowres = love.graphics.newText(g.font)
M.text_hires = love.graphics.newText(g.font_hires)

M.update = =>
    if t = g.hotspot.object and g.look_text
        w = g.game_width - 2*paddingX - require("ui.cog").full_width
        @text_lowres\setf(t, w, "left")
        @text_hires\setf(t, w/g.hires_scale, "left")
        return
    @text_lowres\clear()
    @text_hires\clear()

draw = ->
    text = g.use_hires_font and M.text_hires or M.text_lowres
    xshift = g.use_hires_font and g.xshift or 0
    yshift = g.use_hires_font and g.yshift or 0
    scale = g.use_hires_font and g.scale or 1
    font_scale = g.use_hires_font and g.hires_scale or 1
    love.graphics.push("all")
    love.graphics.scale(scale)
    love.graphics.translate(xshift, yshift)
    love.graphics.setColor(M.colour)
    if g.use_hires_font
        love.graphics.setShader(g.hires_shader_outer)
        love.graphics.draw(text, paddingX, paddingY, 0, font_scale)
        love.graphics.setShader(g.hires_shader_inner)
    love.graphics.draw(text, paddingX, paddingY, 0, font_scale)
    love.graphics.pop()

M.draw_canvas = =>
    return if g.blocked
    if not g.use_hires_font
        draw()

M.draw_screen = =>
    return if g.blocked
    if g.use_hires_font
        draw()


return M