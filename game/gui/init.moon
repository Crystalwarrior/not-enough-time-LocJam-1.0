path = (...)\gsub(".init$", "") .. '.'

menus = {
    options: require path .. "options"
    start: require path .. "start"
}


M = {}

M.update = =>
    if m = @menu
        m\update()

M.draw = =>
    if m = @menu
        m\draw()
    
M.mousereleased = =>
    if m = @menu
        return m\mousereleased()

M.mousepressed = (button) =>
    if m = @menu
        return m\mousepressed(button)

M.keypressed = (key) =>
    if m = @menu
        return m\keypressed(key)

M.mousemoved = () =>
    if m = @menu
        return m\mousemoved(key) if m.mousemoved

M.set_menu = (name) =>
    @menu = menus[name]

return M