path = (...)\gsub("[^%.]*$", "")
M = require path .. 'main'

import Atlas, Vec2, Class from M.steelpan
import simplify_path from M.steelpan.utils
import round from  M.steelpan.utils.math
import fmod from math

Animation = Class {
    __init: (atlas, layers, fps, basepoint_position=@@MIDDLE_CENTER, basepoint_xshift=0, basepoint_yshift=0) =>
        @_layers = {}
        @_layer_idxs = {}
        @_visibility_groups = {}

        for i, layer in ipairs(layers)
            frames = [atlas[frame] or false for frame in *layer.frames]
            offsets = layer.offsets and [Vec2(unpack(offset)) for offset in *layer.offsets] or {}
            name = layer.name
            local group
            if layer.group
                if t = @_visibility_groups[layer.group] then
                    t[#t + 1] = name
                    group = t
                else
                    group = {name}
                    @_visibility_groups[layer.group] = group
            @_layers[i] = {:frames, :offsets, visible:layer.visible, :group}
            @_layer_idxs[layer.name] = i

        -- The sprites are assumed to be of equal size, so just get the size from the first non-empty one
        for layer in *@_layers
            for frame in *layer.frames
                if frame
                    @_size = frame.size
                    break
            break if @_size
        
        assert(@_size, "All the frames are empty.")
        w, h = @_size.x, @_size.y
        
        @_fps = fps
        @_num_frames = #@_layers[1].frames
        
        @_basepoint = switch basepoint_position
            when @@TOP_LEFT then Vec2(0, 0)
            when @@TOP_CENTER then Vec2(round((w - 1)/2), 0)
            when @@TOP_RIGHT then Vec2(w - 1, 0)
            when @@MIDDLE_LEFT then Vec2(0, round((h - 1)/2))
            when @@MIDDLE_CENTER then Vec2(round((w - 1)/2), round((h - 1)/2))
            when @@MIDDLE_RIGHT then Vec2(w - 1, round((h - 1)/2))
            when @@BOTTOM_LEFT then Vec2(0, h - 1)
            when @@BOTTOM_CENTER then Vec2(round((w - 1)/2), h - 1)
            when @@BOTTOM_RIGHT then Vec2(w - 1, h - 1)

        @_basepoint -= Vec2(basepoint_xshift, -basepoint_yshift)
        @_current_frame = 1
        @_playing = false


    start: (start_frame=1, play_once=false) =>
        @_play_once = play_once
        if start_frame > @_num_frames
            start_frame = math.fmod(start_frame - 1, @_num_frames) + 1
        @_current_frame = start_frame
        @_playing = true
        @_t = 0

    stop: (go_to_frame) =>
        @_playing = false
        if go_to_frame then @_current_frame = go_to_frame


    set_visibility: (layer_name, value) =>
        layer = @_layers[@_layer_idxs[layer_name]]
        layer.visible = value
        if value
            for name in *(layer.group or {})
                if name ~= layer_name
                    @_layers[@_layer_idxs[name]].visible = false


    toggle_visibility: (layer_name) =>
        value = @_layers[@_layer_idxs[layer_name]].visible
        @set_visibility(layer_name, not value)

    draw: (x, y, angle, sx=1, sy=1) =>
        switch @_flipped
            when @@FLIP_HORIZONTAL then sx = -sx
            when @@FLIP_VERTICAL then sy = -sy
            when @@FLIP_BOTH then sx, sy = -sx, -sy

        i = @_current_frame
        for layer in *@_layers
            if layer.visible
                o = if offsets = layer.offsets[i] then @_basepoint + offsets else @_basepoint
                frame = layer.frames[i]
                frame\draw(x, y, angle, sx, sy, o\unpack()) if frame


    update: (dt) =>
        if @_playing
            @_t += dt*@_fps
            if @_t >= @_num_frames and @_play_once
                @_playing = false
                @_current_frame = @_num_frames
                M.signals.emit(self, "finished")
            else
                @_t = math.fmod(@_t, @_num_frames)
                @_current_frame = math.floor(@_t) + 1


    copy_flipped: (flip_direction) =>
        -- Note: this assumes the original animation is not flipped!
        animation = {k, v for k, v in pairs(self)}
        animation._flipped = flip_direction
        return setmetatable(animation, getmetatable(self))
}

Animation.TOP_LEFT = 1
Animation.TOP_CENTER = 2
Animation.TOP_RIGHT = 3
Animation.MIDDLE_LEFT = 4
Animation.MIDDLE_CENTER = 5
Animation.MIDDLE_RIGHT = 6
Animation.BOTTOM_LEFT = 7
Animation.BOTTOM_CENTER = 8
Animation.BOTTOM_RIGHT = 9

Animation.FLIP_HORIZONTAL = 1
Animation.FLIP_VERTICAL = 2
Animation.FLIP_BOTH = 3

Animation.open_reel = (filename, external) ->
    -- external is a boolean value, if true it allows importing from outside the love filesystem       
    t = if external
        loadfile(filename)()
    else
        love.filesystem.load(filename)()

    directory = filename\gsub("[^/]*$", "")
    atlas = Atlas(simplify_path(directory .. t.atlas)) if t.atlas
    basepoint_position = t.basepoint_position and Animation[t.basepoint_position]

    return {a.name, Animation(atlas, a.layers, a.fps, basepoint_position, t.basepoint_xshift, t.basepoint_yshift) for a in *t.animations}


M.Animation = Animation
