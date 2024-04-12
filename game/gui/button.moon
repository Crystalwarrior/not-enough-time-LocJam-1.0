Inky = require "3rd.inky"

require "ui"

atlas = g.interface_atlas

M = {}
M.new = Inky.defineElement () =>
	@props.selected = false
    
    pressed = false

    @onPointer "press", ->
        pressed = true
        
    @onPointer "release", ->
        if pressed
            @props.callback()
        
        pressed = false

    @onPointerEnter =>
        return true if @props.disabled
        @props.selected = true

    @onPointerExit =>
        return true if @props.disabled
        @props.selected = false

	return (x, y, w, h) =>
        text = type(@props.text) == "function" and @props.text() or @props.text

        atlas.button_side\draw(x, y)
        atlas.button_side\draw(x + w - 1, y)

        if @props.selected
            atlas.button2\draw(x + 1, y, 0, w - 2, 1)
        else
            atlas.button1\draw(x + 1, y, 0, w - 2, 1)

        love.graphics.setShader(g.hires_shader_inner) if g.use_hires_font
        font_scale = g.use_hires_font and g.hires_scale or 1
        if not @props.selected
            love.graphics.setColor(0.922, 0.506, 0.22)
		love.graphics.printf(text, x, y, w/font_scale, "center", nil, font_scale)
        love.graphics.setShader() if g.use_hires_font
        love.graphics.setColor(1, 1, 1)


M.height = g.font\getHeight()

return M