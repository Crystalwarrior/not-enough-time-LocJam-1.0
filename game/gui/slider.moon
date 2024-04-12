Inky = require "3rd.inky"

require "ui"

atlas = g.interface_atlas

M = {}
M.new = Inky.defineElement () =>

    set_progress = (pointer_x) ->
        x, _, w, _ = @getView()
        progress = ((pointer_x - x)/w)
        progress = math.max(progress, 0)
        progress = math.min(progress, 1)
        @props.progress = progress
        @props.callback(progress)


    @onPointer "press", (_, pointer) ->
        pointer\captureElement(self)
        set_progress(pointer\getPosition())

    @onPointer "release", (_, pointer) ->
        pointer\captureElement(self, false)

        
    @onPointer "drag", (_, pointer) ->
        set_progress(pointer\getPosition())

    -- @onPointerEnter =>
    --     @props.selected = true

    @onPointerExit (_, pointer) ->
        -- pointer\captureElement(self, false)

	return (x, y, w, h) =>
        text = type(@props.text) == "function" and @props.text() or @props.text

        atlas.slider_side\draw(x, y)
        atlas.slider_side\draw(x + w - 1, y)

        progress_w = (w - 2)*@props.progress
        atlas.slider1\draw(x + 1, y, 0, progress_w, 1)
        atlas.slider2\draw(x + 1 + progress_w, y, 0, w - 2 - progress_w, 1)
        atlas.slider_marker\draw(x - 2 +  progress_w, y)

        -- if @props.selected
        --     atlas.button2\draw(x + 1, y, 0, w - 2, 1)
        -- else
        --     atlas.button1\draw(x + 1, y, 0, w - 2, 1)

        -- love.graphics.setShader(g.hires_shader_inner) if g.use_hires_font
        -- font_scale = g.use_hires_font and g.hires_scale or 1
        -- if not @props.selected
        --     love.graphics.setColor(0.922, 0.506, 0.22)
		-- love.graphics.printf(text, x, y, w/font_scale, "center", nil, font_scale)
        -- love.graphics.setShader() if g.use_hires_font
        -- love.graphics.setColor(1, 1, 1)


M.height = atlas.slider1.size.y
M.yoffset = 0.5*(g.font\getHeight() - M.height)

return M