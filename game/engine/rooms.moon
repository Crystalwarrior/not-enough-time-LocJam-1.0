path = (...)\gsub("[^%.]*$", "")
M = require(path .. 'main')

import Animation, Navigation, game from M
import Atlas, Vec2, Class from M.steelpan
import simplify_path from M.steelpan.utils
import round from M.steelpan.utils.math
import huge from math

baseline_sort = (a, b) -> a._baseline < b._baseline
position_sort = (a, b) -> a._position.y < b._position.y
layer_sort = (a, b) -> a.zsort < b.zsort

Hotspot = Class {
    __init: (t, position) =>
        @_xmin = t[1][1] + position.x
        @_xmax = t[2][1] + position.x
        @_ymin = t[1][2] + position.y
        @_ymax = t[2][2] + position.y

    is_mouse_inside: (p) =>
        x, y = p.x, p.y
        return x >= @_xmin and x <= @_xmax and
            y >= @_ymin and y <= @_ymax
}

Object = Class {
    __init: (t, atlas) =>
        @_name = t.name
        @_baseline = t.baseline or 0
        @_position = Vec2(unpack(t.position or {}))
        @_hotspot = Hotspot(t.hotspot, @_position) if t.hotspot
        @_animations = {}
        local first_animation
        for a in *(t.animations or {})
            first_animation = a.name if not first_animation
            if a.frames and #a.frames > 0
                layers = {{frames:a.frames, name:"", visible:true}}
                @_animations[a.name] = Animation(atlas, layers, a.fps or 10, Animation.TOP_LEFT)
        @_animation = @_animations[first_animation]

    start_animation: (name, play_once) =>
        @_animation = @_animations[name]
        return if not @_animation
        @_animation\start(nil, play_once)
        return @_animation


    draw: (x=0, y=0, scale=1) =>
        if a = @_animation
            local oldshader, oldcolour

            if @_shader
                oldshader = love.graphics.getShader()
                love.graphics.setShader(@_shader)
            if @_colour
                oldcolour = {love.graphics.getColor()}
                love.graphics.setColor(@_colour)
            a\draw(scale*@_position.x + x, scale*@_position.y + y, 0, scale, scale)
            if @_colour
                love.graphics.setColor(oldcolour)
            if @_shader
                love.graphics.setShader(oldshader)
        if im = @_image
            -- this is a hack meant for this game only!
            if type(im) == "function"
                im = im()
            love.graphics.draw(im, x, y)
}
M.Object = Object

Room = Class {
    __init: (filename, external) =>
        @open(filename, external) if filename

    open: (filename, external) =>
        -- external is a boolean value, if true it allows importing from outside the love filesystem       
        t = if external
            loadfile(filename)()
        else
            love.filesystem.load(filename)()

        directory = filename\gsub("[^/]*$", "")
        
        @_navigation = Navigation(t.navigation, t.scaling)
        @_atlas = Atlas(simplify_path(directory .. t.atlas)) if t.atlas
        @_background = t.background or {}
        @_layers = t.layers or {}
        @_bounds = t.bounds and [Vec2(unpack(v)) for v in *t.bounds] or {Vec2(), Vec2(100, 100)}
        
        objects_sorted = {bg:{}}
        objects_sorted[layer] = {} for layer in *@_layers
        objects = {}

        for object in *(t.objects or {})
            obj = Object(object, @_atlas)
            s = objects_sorted[@_layers[object.layer]] or objects_sorted.bg
            s[#s + 1] = obj
            objects[object.name] = obj
        table.sort(objects_sorted.bg, baseline_sort)
        table.sort(objects_sorted[layer], baseline_sort) for layer in *@_layers

        @_objects = objects
        @_objects_sorted = objects_sorted
        table.sort(@_layers, layer_sort)

        @characters = {}

    draw_layer: (layer) =>
        if layer.hidden then return
        -- x = round((layer.parallax[1] - 1)*camera.x/camera.scale)
        -- y = round((layer.parallax[2] - 1)*camera.y/camera.scale)
        for name in *layer
            @_atlas[name]\draw(x, y, 0, @scale) if @_atlas[name]
        for object in *@_objects_sorted[layer]
            object\draw(x, y, @scale) unless object.hidden

    draw_background: =>
        for name in *@_background
            @_atlas[name]\draw(0, 0, 0, @_scale) if @_atlas[name]

        for o in *@_objects_sorted.bg
            player =  game.player
            if o._baseline <= 0 or o._baseline*player._scale.y < player._position.y*player._scale.y
                o\draw(0, 0, @scale) unless o.hidden

        characters = [c for c in pairs(@characters or {})]
        table.sort(characters, position_sort)

        obj_idx, char_idx = 1, 1
        c = characters[1] or {_position:{y:huge}}
        while obj_idx <= #@_objects_sorted.bg
            o = @_objects_sorted.bg[obj_idx]
            if o._baseline < c._position.y
                o\draw(0, 0, @scale) unless o.hidden
                obj_idx += 1
            else
                while char_idx <= #characters
                    c\draw()
                    char_idx += 1
                    c = characters[char_idx] or {_position:{y:huge}}
                    if c._position.y > o._baseline
                        break
        for i = char_idx, #characters
            characters[i]\draw()

    draw: =>
        if @_atlas
            idx = 1
            for layer in *@_layers
                if layer.zsort < 0
                    @draw_layer(layer)
                    idx += 1
                else break
            @draw_background()
            for i = idx, #@_layers
                @draw_layer(@_layers[i])

    update: (dt) =>
        for character in pairs(@characters)
            character\update(dt)
        for name, object in pairs(@_objects)
            object._animation\update(dt) if object._animation

    get_hotspot: (p) =>
        t = @_objects_sorted.bg
        for i = #t, 1, -1
            obj = t[i]
            if not obj.hidden and obj._hotspot and obj._hotspot\is_mouse_inside(p)
                return obj

    get_object: (name) =>
        return @_objects[name]

}
M.Room = Room


