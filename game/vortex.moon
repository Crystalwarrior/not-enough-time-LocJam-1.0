Class = require "engine.steelpan.class"

M = {}

divisions = 15
speed = 20
min_radius = 10
rot_speed = 0.4
time_step = 0.4
center = {120, 66.5}
colours = {
    {love.math.colorFromBytes(105, 245, 183)}
    {love.math.colorFromBytes(95, 205, 228)}
    {1, 1, 1}
}
rough = true

center_displacement_stdev = 0.5
center_displacement = {0, 0}
displacement_step = 0.15
displacement_t = 0
needs_update = false

angle = 2*math.pi/divisions
t = 0

local first_circle

Circle = Class {
    __init: (dr=0) =>
        @radius= min_radius + dr
        @angle = 0

        pieces = 0
        while pieces < 2
            pieces = 0
            @segments = {}
            for i = 1, divisions
                if love.math.random(2) ~= 1
                    @segments[i] = colours[love.math.random(#colours)]
                    pieces += 1
                else
                    @segments[i] = false
        
        @next = first_circle
        first_circle.prev = self if first_circle
        first_circle = self

    draw: =>
        return if @radius < min_radius
        love.graphics.push("all")
        love.graphics.translate((1 - center[1]/120)*@radius, 0)
        love.graphics.rotate(@angle)
        for i = 1, divisions
            if col = @segments[i]
                love.graphics.setColor(col)
                love.graphics.arc("line", "open", 0, 0, @radius, angle*(i - 1) + 0.1, angle*i - 0.1, 20)
        love.graphics.pop()

}

Circle()

M.update = (dt) =>
    dt = math.min(dt, 1/30) -- otherwise problems with cutscene skipping
    return unless @on
    return unless needs_update
    circle = first_circle
    while circle
        circle.radius += speed*dt*0.05*circle.radius
        circle.angle += rot_speed*dt
        circle.angle = circle.angle%(2*math.pi)

        if circle.radius > 375
            if circle == first_circle
                first_circle = nil
            else
                circle.prev.next = nil
        circle = circle.next

    t += dt
    if t > time_step
        t = t - time_step
        Circle(t*speed)

    displacement_t += dt
    if displacement_t > displacement_step
        displacement_t = displacement_t%displacement_step
        center_displacement = {love.math.randomNormal(center_displacement_stdev), love.math.randomNormal(center_displacement_stdev)}
    
    needs_update = false

M.draw = =>
    return unless @on
    needs_update = true
    love.graphics.push("all")
    love.graphics.setLineStyle("rough") if rough
    love.graphics.setLineWidth(2)

    x = center[1] + center_displacement[1]
    y = center[2] + center_displacement[2]
    love.graphics.translate(x, y)

    love.graphics.push()
    love.graphics.translate((1 - center[1]/120)*min_radius, 0)
    love.graphics.circle("line", 0, 0, min_radius)
    love.graphics.pop()

    circle = first_circle
    while circle
        circle\draw()
        circle = circle.next

    love.graphics.pop()

M.set_zoom = (zoom) =>
    min_radius /= zoom

M.set_position = (x, y) =>
    center[1], center[2] = x, y

M.get_position = =>
    return center[1], center[2]

return M