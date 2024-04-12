g = require "global"
rooms = require "rooms"

atlas = g.rooms.present._atlas

sprite_front = atlas.tunnel_front
sprite_pattern = atlas.tunnel_pattern

front_width = sprite_front.size.x
pattern_width = sprite_pattern.size.x
width = front_width + pattern_width

M = {}

M.shader = love.graphics.newShader [[
    uniform float intensity;
    vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )  {
        float factor = max(0.0, 1.0 - intensity)*(1.0 - intensity*pow(screen_coords.x/135.0, 2.0));
        vec4 texcolor = Texel(tex, texture_coords);
        return vec4(texcolor.rgb*factor, texcolor.a)*color;
    }
]]



M.on = false
M.speed = 150
M.offset = 0
M.one_loop = false
M.min_shift = M.speed*1/24
M.intensity = 0

accum = 0
DT = 1/30

M.update = (dt) =>
    return unless @on
    -- accum += dt
    -- if accum >= DT
    @offset += @speed*dt
    if not @one_loop and @offset >= front_width + g.game_width
        @one_loop = true
    if @one_loop
        @offset = @offset%(pattern_width)
    -- accum += dt
    -- if accum >= DT
    --     @offset += @speed*math.floor(accum/DT)*DT
    --     accum = accum%DT
    --     -- @offset = @offset%(width - g.game_width)

M.set_intensity = (value) =>
    @intensity = value
    @shader\send("intensity", value)

M.draw = =>
    return unless @on
    love.graphics.push("all")
    offset = math.floor(@offset)
    sprite_front\draw(g.game_width - offset,0) unless @one_loop
    min_i = @one_loop and -2 or 0
    love.graphics.setShader(@shader)
    for i = min_i, 2
        sprite_pattern\draw(g.game_width + front_width - offset + pattern_width*i,0)
    
    love.graphics.pop()

return M