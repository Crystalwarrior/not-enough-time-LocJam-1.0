g = require "global"
tunnel = require "tunnel"
shake = require "shake"
atlas = g.rooms.present._atlas

M = {}

M.on = true
M.speed = 200
M.trees_speed = 80
M.clouds_speed = 1
M.offset = 0
M.trees_offset = 0
M.clouds_offset = 0
M.use_tunnel_shader = true
M.smoothness_step = 0.1

xshift = 4
ytop = g.game_height - 10
ybottom = g.game_height - 7
width = 50
space = 30

road_h = 50

accum = 0
DT = 1/24

M.update = (dt) =>
    return unless @on
    @offset -= @speed*dt
    @offset = @offset%(width + space)
    @trees_offset -= @trees_speed*dt
    @trees_offset = @trees_offset%g.game_width
    @clouds_offset -= @clouds_speed*dt
    @clouds_offset = @clouds_offset%g.game_width
    -- accum += dt
    -- if accum >= DT
    --     @offset -= @speed*math.floor(accum/DT)*DT
    --     accum = accum%DT
    --     @offset = @offset%(width + space)

cloud_shader = love.graphics.newShader [[
    uniform float width;

    vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
        vec4 col1 = Texel(tex, texture_coords);
        vec4 col2 = Texel(tex, texture_coords + vec2(-1.0/width, 0.0));
        return mix(col1, col2, color.a);
    }
]]

cloud_shader\send("width", atlas.clouds.spritesheet\getWidth())

M.draw = =>
    return unless @on
    love.graphics.push("all")
    dx = shake.shaking and shake.dx or 0
    dy = shake.shaking and shake.dy or 0
    love.graphics.setScissor(dx, dy, g.game_width, g.game_height)

    love.graphics.setShader(tunnel.shader) if @use_tunnel_shader

    atlas.sky\draw()
    for i = -1, 1
        love.graphics.push("all")
        factor = @clouds_offset%1
        factor = @smoothness_step*math.floor(factor/@smoothness_step)
        love.graphics.setShader(cloud_shader)
        love.graphics.setColor(1, 1, 1, factor)
        atlas.clouds\draw(math.floor(@clouds_offset) + atlas.clouds.size.x*i)
        love.graphics.pop()

    for i = -1, 1
        atlas.trees\draw(math.floor(@trees_offset) + atlas.trees.size.x*i)

    love.graphics.setColor(.3, .3, .3)
    love.graphics.rectangle("fill", 0, g.game_height - road_h, g.game_width, road_h)
    love.graphics.setColor(1, 1, 1)
    for i = -1, 3
        xpos = math.floor(@offset) + (width + space)*i
        rshift = -(-1 + 2*(xpos + width)/g.game_width)*xshift
        lshift = -(-1 + 2*xpos/g.game_width)*xshift
        love.graphics.polygon("fill", xpos + lshift, ytop, xpos + rshift + width, ytop, xpos + width, ybottom, xpos, ybottom)
    
    love.graphics.setScissor()
    love.graphics.pop()

return M