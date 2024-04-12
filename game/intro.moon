g = require "global"
dissolve = require "dissolve"
lc = require "engine"

M = {}

logo = love.graphics.newImage("assets/single_sprites/fmod.png")
noise = love.graphics.newImage("assets/single_sprites/noise.png")
title_en = love.graphics.newImage("assets/single_sprites/title_english.png")
title_tr = love.graphics.newImage("assets/single_sprites/title_translated.png")
title = -> lc.tr_text == require("text_english") and title_en or title_tr

dissolve_shader = love.graphics.newShader [[
uniform Image noise;
uniform float threshold;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texturecolor = Texel(tex, texture_coords);
    vec4 noisecolor = Texel(noise, texture_coords);
    float alpha = step(noisecolor.r, threshold);
    return vec4(texturecolor.rgb, texturecolor.a*alpha);
}

]]

dissolve_shader\send("noise", noise)

min_threshold = 0.6
letter_threshold = 1
opacity = 0
r_opacity = 1
accel = 1
num_letters = 13

local draw_title

M.draw = =>
    if not draw_title
        love.graphics.setColor(0, 0, 0, r_opacity)
        love.graphics.rectangle("fill", 0, 0, g.game_width, g.game_height)

        love.graphics.setColor(1, 1, 1, opacity)
        love.graphics.draw(logo, 0, offset)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setShader()
    else
        love.graphics.setShader(dissolve.shader)
        love.graphics.draw(title())
        love.graphics.setShader()




M.start = =>
    g.start_thread ->
        wait 0.2
        t = 0
        while opacity < 1
            dt = wait_frame()
            t += dt
            opacity = math.min(1, opacity + 0.5*t^2)

        
        wait 2
        t = 0
        while opacity > 0
            dt = wait_frame()
            t += dt
            opacity = math.max(0, opacity - 0.1*accel*t)
            r_opacity = opacity

        draw_title = true

        wait 1

        dissolve\start_appear()
        wait_signal(dissolve, "finished")

        wait 1

        require("gui")\set_menu("start")



        -- g.intro = nil


return M