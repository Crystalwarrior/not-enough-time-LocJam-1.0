path = (...)\gsub("[^%.]*$", "")
Class = require path .. 'class'
Vec2 = require path .. 'vectors'

status, mod = pcall(require, "love")
love = status and mod or nil

Camera = Class {
    __init: =>
        @transform = love.math.newTransform()
        @x, @y, @angle, @sx, @sy, @ox, @oy = 0, 0, 0, 1, 1, 0, 0

    push: =>
        love.graphics.push()
        love.graphics.applyTransform(@transform)

    pop: =>
        love.graphics.pop()

    set: (x, y, angle, sx, sy, ox, oy) =>
        @x = x or @x
        @y = y or @y
        @angle = angle or @angle
        @sx = sx or @sx
        @sy = sy or @sy
        @ox = ox or @ox
        @oy = oy or @oy
        @transform\setTransformation(@x, @y, @angle, @sx, @sy)
        @on_move() if @on_move

    reset: =>
        @x, @y, @angle, @sx, @sy, @ox, @oy = 0, 0, 0, 1, 1, 0, 0
        @transform\reset()

    move: (dx, dy) =>
        @set(@x - dx, @y - dy)

    get_coordinates: (x, y) =>
        return @transform\inverseTransformPoint(x, y)

    get_coordinates_vector: (v) =>
        return Vec2(@get_coordinates(v.x, v.y))

    set_callback: (f) =>
        @on_move = f
}

return Camera