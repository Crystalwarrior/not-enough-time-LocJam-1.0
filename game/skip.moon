g = require "global"

M = {}

g.time_rate = 1

M.time_rate = 50000

M.start = =>
    @skippable = true

M.stop = =>
    @skippable = false
    @skipping = false
    g.time_rate = 1

M.hold_time = 1
M.t = 0

M.start_hold = =>
    return unless @skippable
    @holding = true
    @t = 0

M.go = =>
    @holding = false
    return unless @skippable
    @skipping = true
    g.time_rate = @time_rate

M.release_hold = =>
    @holding = false

M.update = (dt) =>
    if @holding
        @t += dt
        if @t >= @hold_time
            @go()


            
M.radius = 8
M.lineWidth = 6
M.colour = {1, 1, 0.5}
M.padding = 3
M.distance_from_edge = M.padding + M.radius + 0.5*M.lineWidth

M.draw_canvas = =>
    return unless @holding
    love.graphics.push("all")
    love.graphics.setLineStyle("rough")
    factor = @t/@hold_time
    love.graphics.setColor(@colour)
    love.graphics.setLineWidth(@lineWidth)
    x = g.game_width - @distance_from_edge
    y = g.game_height - @distance_from_edge
    love.graphics.arc("line", "open", x, y, @radius, -0.5*math.pi, -0.5*math.pi + 2*math.pi*factor, 100*factor)
    love.graphics.pop()


return M