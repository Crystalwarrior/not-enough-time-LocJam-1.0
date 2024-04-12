path = (...)\gsub("[^%.]*$", "")
M = require(path .. 'main')

import game, Animation from M
import Vec2, Class from M.steelpan
import round, sgn from M.steelpan.utils.math
import dot from Vec2
import abs, cos, sin from math

standing_animations = {'W_stand', 'E_stand', 'N_stand', 'S_stand', 'NW_stand', 'NE_stand', 'SW_stand', 'SE_stand'}
walking_animations = {'W_walk', 'E_walk', 'N_walk', 'S_walk', 'NW_walk', 'NE_walk', 'SW_walk', 'SE_walk'}
talking_animations = {'W_talk', 'E_talk', 'N_talk', 'S_talk', 'NW_talk', 'NE_talk', 'SW_talk', 'SE_talk'}

local *

Character = Class {
    __init: (animations) =>
        -- `animations' is a table of animations for the character, indexed by their names. It should have at
        -- least the animations 'N_stand', 'S_stand', 'E_stand', 'W_stand', 'N_walk', 'S_walk', 'E_walk', 'W_walk'.
        -- If 'W_stand' or 'W_walk' are not specified, they will be flipped horizontally from the right
        -- versions.
        @_position = Vec2()
        @_colour = {1,1,1,1}

        -- TODO: check that walking animations are set (should they really be necessary? what if a character is not supposed to walk?)
        
        @_animations = animations
        @_animations.W_stand = animations.W_stand or animations.E_stand\copy_flipped(Animation.FLIP_HORIZONTAL)
        @_animations.W_walk = animations.W_walk or animations.E_walk\copy_flipped(Animation.FLIP_HORIZONTAL)
        @_animations.W_talk = animations.W_talk or animations.E_talk\copy_flipped(Animation.FLIP_HORIZONTAL)
        
        -- check if diagonal directions are set up
        if animations.NE_stand and animations.SE_stand and animations.NE_walk and animations.SE_walk
            @_diagonal_directions = true
            @_animations.NW_stand = animations.NW_stand or animations.NE_stand\copy_flipped(Animation.FLIP_HORIZONTAL)
            @_animations.SW_stand = animations.SW_stand or animations.SE_stand\copy_flipped(Animation.FLIP_HORIZONTAL)
            @_animations.NW_walk = animations.NW_walk or animations.NE_walk\copy_flipped(Animation.FLIP_HORIZONTAL)
            @_animations.SW_walk = animations.SW_walk or animations.SE_walk\copy_flipped(Animation.FLIP_HORIZONTAL)

        @_standing_animations = [@_animations[k] for k in *standing_animations]
        @_walking_animations = [@_animations[k] for k in *walking_animations]
        @_talking_animations = [@_animations[k] for k in *talking_animations]
        
        @_wlk = {
            moving: false
            t: 0
            speed: Vec2(1, 1)
            path: {}
            distances: {}
            piece: 1
            prev_target: nil
        }
        
        @_spk = {
            colour: {1,1,1,1}
        }
        
        @_direction = @@direction.S
        @face(@_direction)      
        
        @_animation = @_standing_animations[@_direction]
        
        @_scale = Vec2(1, 1)
        @nav_scale = 1
        @_angle = 0
        @_cos = 1
        @_sin = 0
        update_bounding_box(self)

    face_location: (point) =>
        v = point - @_position
        v.x = v.x*sgn(@_scale.x)
        v.y = v.y*sgn(@_scale.y)

        if v.x == 0 and v.y == 0
            return
        
        if @_angle ~= 0
            X = @_cos*v.x + @_sin*v.y
            Y = @_cos*v.y - @_sin*v.x
            v.x, v.y = X, Y

        tan = v.y/v.x
        a = @_diagonal_directions and 0.41421356 or 1
        b = @_diagonal_directions and 1.41421356 or 1

        if tan >= -a and tan <= a
            @_direction = v.x > 0 and @@direction.E or @@direction.W
        elseif tan > a and tan < b
            @_direction = v.x > 0 and @@direction.SE or @@direction.NW
        elseif tan > -b and tan < -a
            @_direction = v.x > 0 and @@direction.NE or @@direction.SW
        else
            @_direction = v.y > 0 and @@direction.S or @@direction.N

    face: (@_direction) =>

    face2: (direction) =>
        -- direction is a string
        @_direction = M.Character.direction[direction]
        @_animation = @_standing_animations[@_direction]

    face2point: (point) =>
        @face_location(point)
        @_animation = @_standing_animations[@_direction]

    walk: (x, y) =>
        return unless game.room
        target = Vec2(x, y)
        unless @_wlk.prev_target and @_wlk.prev_target == target
            @_wlk.prev_target = target
            path = game.room._navigation\shortest_path(@_position, target)
            @_wlk.distances = [(path[i + 1] - path[i])\len() for i = 1, #path - 1]
            @_wlk.path = path
            return false if #path < 2
            @_wlk.t = 0
            @_wlk.piece = 1
            @_wlk.moving = true
            old_direction = @_direction
            @face_location(path[2])
            if not @_animation._playing or @_direction ~= old_direction
                start_frame = 1
                if @_animation._playing
                    @_animation\stop()
                    start_frame = @_animation._current_frame

                @_animation = @_walking_animations[@_direction]
                @_animation\start(start_frame)
            return true
        return false

    stop_walking: =>
        if @_wlk.moving
            @_wlk.moving = false
            @_animation\stop()
            @_animation = @_standing_animations[@_direction]
            M.signals.emit(self, 'finished walking')

    update: (dt) =>
        -- TODO: continue on next piece if @_wlk.t >= 1
        -- TODO: more precise speed calculation based on nav.scale?
        @_animation\update(dt)
        if @_wlk.moving
            idx = @_wlk.piece
            A, B =  @_wlk.path[idx], @_wlk.path[idx + 1]
            unless A and B
                @stop_walking()
                return
            v = B - A
            speed = @nav_scale*(@_wlk.speed.x*abs(v.x) + @_wlk.speed.y*abs(v.y))/v\lenS()
            @_wlk.t += dt*speed
            @_wlk.t = 1 if @_wlk.t > 1
            factor = @_wlk.t
            @_position = A*(1 - factor) + B*factor
            @nav_scale = game.room._navigation\get_scale(@_position)
            if factor == 1
                if idx < #@_wlk.distances
                    @_wlk.piece = idx + 1
                    @_wlk.t = 0
                    
                    old_direction = @_direction
                    @face_location(@_wlk.path[@_wlk.piece + 1])
                    if @_direction ~= old_direction
                        start_frame = @_animation._current_frame
                        @_animation\stop()
                        @_animation = @_walking_animations[@_direction]
                        @_animation\start(start_frame)
                else
                    @stop_walking()

    draw: =>
        return if @hidden
        local oldshader, oldcolour
        if @_shader
            oldshader = love.graphics.getShader()
            love.graphics.setShader(@_shader)
        if @_colour
            oldcolour = {love.graphics.getColor()}
            love.graphics.setColor(@_colour)
        room_scale = game.room_scale()
        position = round(@_position*room_scale)
        scale = @nav_scale*@_scale*room_scale
        @_animation\draw(position.x, position.y, @_angle, scale.x, scale.y)
        if @_colour
            love.graphics.setColor(oldcolour)
        if @_shader
            love.graphics.setShader(oldshader)

    set_angle: (radians) =>
        @_angle = radians
        @_cos = cos(radians)
        @_sin = sin(radians)
        update_bounding_box(self)

    set_scale: (xscale, yscale=xscale) =>
        @_scale = Vec2(xscale, yscale)
        update_bounding_box(self)

    change_room: (room, x=0, y=0, direction=@_direction) =>
        if oldroom = @_room
            oldroom.characters[self] = nil
        @_room = room
        if room
            room.characters[self] = true
            @_position.x, @_position.y = x, y
            @nav_scale = room._navigation\get_scale(@_position)
            @_direction = direction

    set_position: (x, y) =>
        @_position.x = x
        @_position.y = y

    set_speed: (x, y) =>
        @_wlk.speed.x = x
        @_wlk.speed.y = y

    set_colour: (...) =>
        if t = select(1, ...)
            if type(t) == "table"
                @_colour = t
            else
                @_colour = [select(i, ...) or 1 for i = 1, 4]
        else
            @_colour = nil

    set_shader: (shader) =>
        @_shader = shader

    start_animation: (name, play_once=false) =>
        @_animation = @_animations[name]
        @_animation\start(1, play_once)
        return @_animation

    start_animation_thread: (name) =>
        g = require "global"
        setfenv(1, g.thread_registry\get_thread_environment())
        @start_animation(name, true)
        wait_signal(@_animation, "finished")

    
    walk_thread: (x, y) =>
        g = require "global"
        setfenv(1, g.thread_registry\get_thread_environment())
        if @walk(x, y)
            wait_signal(self, "finished walking")

}

Character.direction = {
    W: 1
    E: 2
    N: 3
    S: 4
    NW: 5
    NE: 6
    SW: 7
    SE: 8
}

M.Character = Character

-- transform = (t, P) ->
--     X = t.cos*t.scale.x*P.x - t.sin*t.scale.y*P.y
--     Y = t.sin*t.scale.x*P.x + t.cos*t.scale.y*P.y
--     Vec2(X, Y)

update_bounding_box = (t) ->
    
-- function udpate_boundign_box(t)
--     local tmp = {}
--     local vertices = {}
--     vertices[#vertices + 1] = transform(t, -anim.basepoint)
--     vertices[#vertices + 1] = transform(anim, Vec2(0, anim.size.y) - anim.basepoint)
--     vertices[#vertices + 1] = transform(anim, Vec2(anim.size.x, anim.size.y) - anim.basepoint)
--     vertices[#vertices + 1] = transform(anim, Vec2(anim.size.x, 0) - anim.basepoint)
    
--     tmp.left, tmp.right, tmp.top, tmp.bottom = huge, -huge, huge, -huge
--     for _, P in ipairs(vertices) do
--         tmp.left = min(P.x, tmp.left)
--         tmp.right = max(P.x, tmp.right)
--         tmp.top = min(P.y, tmp.top)
--         tmp.bottom = max(P.y, tmp.bottom)
--     end

--     anim.bounding_box = tmp
-- end