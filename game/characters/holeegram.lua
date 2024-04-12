local lc = require("engine")
local shader = love.graphics.newShader([[    uniform float height;
    uniform float width;
    uniform float glitch_row;
    uniform float glitch_dir;
    uniform float intensity;
    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
        float row = floor(texture_coords.y*height);
        float shift = float(glitch_row == row);
        texture_coords.x -= glitch_dir*shift/width;
        vec4 texturecolor = Texel(tex, texture_coords);
        texturecolor.rga -= 0.1*(1.0 - mod(row, 2.0));
        texturecolor.a *= intensity;
        return texturecolor;
    }
]])
local reel = lc.Animation.open_reel("assets/animations/holeegram.reel")
local holeegram = lc.Character(reel)
holeegram.height = 30
holeegram._spk.colour = {
  0.5,
  0.9,
  1
}
holeegram:set_shader(shader)
holeegram:face2("E")
shader:send("glitch_row", -1)
shader:send("glitch_dir", 0)
shader:send("intensity", 0.8)
local w, h = holeegram._animation._layers[1].frames[1].spritesheet:getDimensions()
shader:send("height", h)
shader:send("width", w)
local holeegram_quad
local accum = 0
local DT = 1 / 12
g.update_holeegram = function(dt)
  accum = accum + dt
  if accum >= DT then
    accum = accum % DT
    local row = love.math.random(38) - 1
    local dir = love.math.random(5) - 3
    local intensity = 0.5 + 0.4 * love.math.random()
    shader:send("glitch_row", row)
    shader:send("glitch_dir", dir)
    return shader:send("intensity", intensity)
  end
end
return holeegram
