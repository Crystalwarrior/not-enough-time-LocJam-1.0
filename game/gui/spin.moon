Inky = require "3rd.inky"

require "ui"

atlas = g.interface_atlas

M = {}

M.height = g.font\getHeight()

arrow_width = atlas.arrow.size.x

arrow_offset_y = (M.height - atlas.arrow.size.y)/2

M.new = Inky.defineElement () =>
	@props.selected = nil
    
    pressed = false

    @onPointer "press", =>
        pressed = @props.selected and true

    @onPointer "move", ( pointer) =>
        X, _, w, _ = @getView()
        x = pointer\getPosition()
        x = x - X
        if x >= 0 and x <= arrow_width
            @props.selected = "l"
        elseif x >= w - arrow_width  and x <= w
            @props.selected = "r"
        else
            @props.selected = nil
    
    @onPointer "release", =>
        if pressed
            @props.callback(@props.selected)
        
        pressed = false

    @onPointerEnter =>
        @props.selected = true

    @onPointerExit =>
        @props.selected = false

	return (x, y, w, h) =>
        text = type(@props.text) == "function" and @props.text() or @props.text

        arrow_l = @props.selected == "l" and atlas.arrow_on or atlas.arrow
        arrow_r = @props.selected == "r" and atlas.arrow_on or atlas.arrow

        arrow_l\draw(x + arrow_width, y + arrow_offset_y, 0, -1, 1)
        arrow_r\draw(x + w - arrow_width, y + arrow_offset_y)

        love.graphics.setShader(g.hires_shader_inner) if g.use_hires_font
        font_scale = g.use_hires_font and g.hires_scale or 1
		love.graphics.printf(text, x, y, w/font_scale, "center", nil, font_scale)
        love.graphics.setShader() if g.use_hires_font


return M