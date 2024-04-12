Inky = require "3rd.inky"
path = (...)\gsub("[^%.]*$", "")

require "ui" -- to ensure atlas is loaded
atlas = g.interface_atlas

M = {}

M.new = Inky.defineElement () =>
	@props.checked = false
    @props.size = atlas.check_on.size
    pressed = false

    @onPointer "press", =>
        pressed = true

	@onPointer "release", =>
        if pressed
            @props.checked = not @props.checked
            if f = @props.callback
                f(@props.checked)
        pressed = false

    @onPointerEnter =>

    @onPointerExit =>

	return (x, y, w, h) =>
        if @props.checked
            atlas.check_on\draw(x, y)
        else
            atlas.check_off\draw(x, y)

M.size = atlas.check_on.size
M.yoffset = 0.5*(g.font\getHeight() - M.size.y)


return M

-- return setmetatable(M, mt)
