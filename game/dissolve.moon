
g = require "global"
lc = require "engine"

M = {}

M.shader = love.graphics.newShader [[
uniform Image noise;
uniform float threshold;
uniform vec2 game_size;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texturecolor = Texel(tex, texture_coords);
    vec4 noisecolor = Texel(noise, screen_coords/game_size);
    float alpha = step(noisecolor.r, threshold);
    return vec4(texturecolor.rgb, alpha*texturecolor.a);
}

]]

min_threshold = 0.5
default_speed = 0.01

M.noise = love.graphics.newImage("assets/single_sprites/noise.png")
M.shader\send("noise", M.noise)
M.shader\send("threshold", min_threshold)
M.shader\send("game_size", {g.game_width, g.game_height})




M.start_appear = (speed=default_speed) =>
    g.start_thread ->
        threshold = min_threshold
        @shader\send("threshold", min_threshold)
        t = 0
        while threshold < 1
            dt = wait_frame()
            t += dt
            threshold = math.min(1, threshold + speed*t)
            M.shader\send("threshold", threshold)

        lc.signals.emit(self, "finished")

M.start_disappear = (speed=default_speed) =>
    g.start_thread ->
        threshold = 1.0
        @shader\send("threshold", threshold)
        t = 0
        while threshold > min_threshold
            dt = wait_frame()
            t += dt
            threshold = math.max(min_threshold, threshold - speed*t)
            M.shader\send("threshold", threshold)

        lc.signals.emit(self, "finished")

return M
