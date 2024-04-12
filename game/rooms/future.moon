lc = require "engine"
import Vec2 from lc.steelpan
g = require "global"
common = require "rooms.common"

inventory = require "inventory"
-- shake = require "shake"
-- audio = require "audio"

-- lights = room._objects.lights
-- g.start_thread ->
--     t = 0
--     while true
--         intensity = 0.5 + 0.5*sin(t)^2
--         lights._colour = {intensity, intensity, intensity}
--         dt = wait_frame()


glass_wall_line = -> INES(28, "I can't reach it, it's behind this force field.")

room = lc.Room("assets/rooms/future.tuba")
room._objects.wheels\start_animation("default")
room.order = 4

HSV = (h, s, v, a) ->
    local g
    if s <= 0 then return v,v,v
    h = h*6
    c = v*s
    x = (1-math.abs((h%2)-1))*c
    m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    return r+m, g+m, b+m

lights = room._objects.lights
g.start_thread ->
    t = 0
    while true
        intensity = 0.5 + 0.5*math.sin(t)^2
        -- intensity = 1
        lights._colour = {HSV(0.5 + 0.05*math.sin(0.3*t), 1, intensity)}
        t += wait_frame()

coin = room._objects.coin
coin.look_text = ->
    if g.device_analyzed
        LOOK(29, "The only gold in this game.")
    else
        LOOK(30, "That looks familiar.")
coin.hotspot_text = -> TEXT(31, "coin")
coin.interact_direction = "W"
coin.interact_position = Vec2(50, 95)
coin.interact = ->
    ines = g.characters.ines
    g.blocking_thread ->
        if room._navigation\are_points_connected(ines._position, coin.interact_position)
            wait 0.1
            ines\start_animation_thread("W_pick_high")
            wait 0.1
            coin.hidden = true
            inventory\add("coin")
            g.got_coin = true
            ines\start_animation_thread("W_stand")
            wait 1
            say ines, INES(32, "I thought there was no gold in this game!")
            wait 1
            ines\face2("S")
            say ines, INES(33, "Hey, it's just gold plated.")
            wait 1
            say ines, INES(34, "I hope this won't create any problems down the line.")

        else
            say ines, glass_wall_line()

plate = room._objects.plate
plate.look_text = -> LOOK(35, "A plate with a description of the coin.")
plate.hotspot_text = -> TEXT(36, "plate")
plate.interact_direction = coin.interact_direction
plate.interact_position = coin.interact_position

plate.interact = ->
    ines = g.characters.ines
    g.blocking_thread ->
        if room._navigation\are_points_connected(ines._position, plate.interact_position)
            say ines, INES(37, "It says it's a reproduction of the first coin ever earned by uncle Lee.")
            say ines, INES(38, "Apparently the original was lost when I was a kid.")
            ines\face2("S")
            wait 1
            say ines, INES(39, "Heh heh.")
        else
            say ines, glass_wall_line()

-- add interaction

holeegram = room._objects.holeegram
holeegram.look_text = ->
    if not g.talked_to_holeegram
        LOOK(40, "What has he gotten himself into, this time?")
    else
        LOOK(41, "Somehow he keeps surprising me.")
holeegram.hotspot_text = ->
    if not g.talked_to_holeegram
        TEXT(42, "uncle Lee?")
    else
        TEXT(43, "holeegram")
holeegram.interact_direction = "W"
holeegram.interact_position = Vec2(140, 97)
holeegram.look_point = Vec2(120, 100)
holeegram.interact = ->
    ines = g.characters.ines
    if ines._position.x > 120
        lc.dialogues\new(require "dialogues.holeegram")
    else
        g.blocking_thread ->
            say ines, INES(44, "Uncle Lee?")
            wait 1
            ines\face2("S")
            wait 0.5
            say ines, INES(45, "He can't hear me behind this force field.")

opening = room._objects.opening
opening.look_text = -> LOOK(46, "A beatiful hatch. You can't tell due to the resolution, but it's very ornate.")
opening.hotspot_text = -> TEXT(47, "opening")
opening.interact_position = holeegram.interact_position
opening.look_point = holeegram.look_point
opening.interact_direction = holeegram.interact_direction


remaining_objects = 2

object_inserted = (name) ->
    ines = g.characters.ines
    holee = g.characters.holeegram
    g.blocking_thread ->
        if ines._position.x < 120
            say ines, INES(48, "I can't do that from here.")
            return

        if remaining_objects > 1
            say ines, INES(49, "Here's one of the things you needed.")
        else
            say ines, INES(50, "Here's the other thing you needed.")

        ines\start_animation_thread("W_pick_low")
        wait 0.3
        inventory\remove(name)
        ines\start_animation_thread("W_stand")
        remaining_objects -= 1

        if remaining_objects == 0
            say holee, HOLEEGRAM(358, "Yummy!")
            wait 1
            say ines, INES(51, "...what?")
            say holee, HOLEEGRAM(359, "I didn't say anything.")
            wait 1
            say ines, INES(52, "Never mind, can you fix this thing or not?")
            say holee, HOLEEGRAM(360, "Working on it.")
            wait 1
            say holee, HOLEEGRAM(361, "Beep Boop.")
            say holee, HOLEEGRAM(362, "Bzzzzzzzzzzz.")
            wait 1
            say holee, HOLEEGRAM(363, "There you go.")

            ines\start_animation_thread("W_pick_low")
            wait 0.3
            inventory\add("device_new2")
            ines\start_animation_thread("W_stand")













opening.use = {
    device_old: ->
        ines = g.characters.ines
        g.blocking_thread ->
            if g.asked_to_analyze_device
                ines\start_animation_thread("W_pick_low")
                wait 0.3
                inventory\remove("device_old")
                ines\start_animation_thread("W_stand")
                g.device_analyzed = true
                lc.dialogues\new(require "dialogues.holeegram")
            else
                say ines, INES(53, "Why would I do that?")

    coin: ->
        object_inserted("coin")

    pickup: ->
        object_inserted("pickup")

}

holeegram.use = opening.use

drawer = common.drawer_setup(room)
old_interact = drawer.interact

drawer.interact = ->
    ines = g.characters.ines
    if ines._position.x > 120
        old_interact()
    else
        g.blocking_thread ->
            say ines, glass_wall_line()


laser = room._objects.laser
laser_side = room._objects.laser_side

laser_tex = love.graphics.newImage("assets/single_sprites/laser.png")


laser_base_alpha = 0.4
laser_side_base_alpha = 0.6
laser._colour = {1, 1, 1, laser_base_alpha}
laser_side._colour = {1, 1, 1, laser_side_base_alpha}
laser._shader = love.graphics.newShader [[
uniform float shift_up;
uniform float shift_down;
uniform Image laser_tex;
const float smoothing = 2.0/16.0;
const float outerEdgeCenter = 0.7;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texColor = Texel(tex, texture_coords);
    float laserUp = Texel(laser_tex, (screen_coords + vec2(0.0, shift_up))/vec2(240.0, 135.0)).r;
    float laserDown = Texel(laser_tex, (screen_coords + vec2(0.0, -shift_down))/vec2(240.0, 135.0)).g;
    return color*(texColor + texColor.a*(vec4(0.0, 0.0, 0.0, 0.5)*laserUp + vec4(0.0, 0.0, 0.0, 0.3)*laserDown*(1.0 - laserUp)));
}
]]

laser._shader\send("laser_tex", laser_tex)

g.start_thread ->
    t = 0
    accum = math.huge
    while true
        shift_up = 15*t%15
        shift_down = 10*t%10
        laser._shader\send("shift_up", shift_up)
        laser._shader\send("shift_down", shift_down)

        if accum > 1/30
            accum = 0
            tmp =  love.math.random()
            laser._colour[4] =  laser_base_alpha + 0.1*tmp
            laser_side._colour[4] =  laser_side_base_alpha + 0.1*tmp


        dt = wait_frame()
        t += dt
        accum += dt




return room
