path = (...)\gsub("[^%.]*$", "")
Class = require path .. "class"
Vec2 = require path .. "vectors"

status, mod = pcall(require, "love")
love = status and mod or nil

loadstring = loadstring or load

sprite_draw = (x, y, r, sx, sy, ox=0, oy=0, ...) =>
    ox -= @offset_x
    oy -= @offset_y
    love.graphics.draw(@spritesheet, @quad, x, y, r, sx, sy, ox, oy, ...)

Atlas = Class {
    __init: (...) =>
        --arguments: (filename, external) or (tbl, directory, external)
        args = {...}
        local filename, directory, tbl, external
        --external is a boolean value, if true it allows importing from outside the love filesystem
        if type(args[1]) == 'string'
            filename = args[1]
            external = args[2] or false
        elseif type(args[1]) == 'table'
            tbl = args[1]
            directory = args[2]
            external = args[3] or false
        else
            error('wrong kind/number of arguments', 2)

        if filename then
            local data
            if external
                f = assert(io.open(filename, 'r'))
                data = f\read('*all')
                f\close()
                data = love.filesystem.newFileData(data, filename)\getString()
            else
                data = assert(love.filesystem.read(filename))

            tbl = assert(loadstring(data))()
            directory = filename\gsub("[^/]*$","")

        sprites = {}
        for spritesheet in *tbl
            filename = directory .. spritesheet.filename
            local img
            if external
                f = assert(io.open(filename, 'rb'))
                data = f\read('*all')
                f\close()
                fdata = love.filesystem.newFileData(data, filename)
                img = love.graphics.newImage(fdata)
            else
                img = love.graphics.newImage(filename)

            w, h = img\getDimensions()
            for sprite in *spritesheet
                quad = love.graphics.newQuad(sprite.x, sprite.y, sprite.w, sprite.h, w, h)
                offset_x, offset_y = sprite.offset_x, sprite.offset_y
                size = Vec2(sprite.orig_w, sprite.orig_h)
                sprites[sprite.name] = {spritesheet:img, :quad, :offset_x, :offset_y, :size, draw:sprite_draw}

        @sprites = sprites

    __index: (key) => @sprites[key]
}

return Atlas