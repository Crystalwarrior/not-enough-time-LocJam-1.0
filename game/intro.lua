local g = require("global")
local dissolve = require("dissolve")
local lc = require("engine")
local M = { }
local logo = love.graphics.newImage("assets/single_sprites/fmod.png")
local noise = love.graphics.newImage("assets/single_sprites/noise.png")
local title_en = love.graphics.newImage("assets/single_sprites/title_english.png")
local title_tr = love.graphics.newImage("assets/single_sprites/title_translated.png")
local title
title = function()
  return lc.tr_text == require("text_english") and title_en or title_tr
end
local dissolve_shader = love.graphics.newShader([[uniform Image noise;
uniform float threshold;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texturecolor = Texel(tex, texture_coords);
    vec4 noisecolor = Texel(noise, texture_coords);
    float alpha = step(noisecolor.r, threshold);
    return vec4(texturecolor.rgb, texturecolor.a*alpha);
}

]])
dissolve_shader:send("noise", noise)
local min_threshold = 0.6
local letter_threshold = 1
local opacity = 0
local r_opacity = 1
local accel = 1
local num_letters = 13
local draw_title
M.draw = function(self)
  if not draw_title then
    love.graphics.setColor(0, 0, 0, r_opacity)
    love.graphics.rectangle("fill", 0, 0, g.game_width, g.game_height)
    love.graphics.setColor(1, 1, 1, opacity)
    love.graphics.draw(logo, 0, offset)
    love.graphics.setColor(1, 1, 1)
    return love.graphics.setShader()
  else
    love.graphics.setShader(dissolve.shader)
    love.graphics.draw(title())
    return love.graphics.setShader()
  end
end
M.start = function(self)
  return g.start_thread(function()
    wait(0.2)
    local t = 0
    while opacity < 1 do
      local dt = wait_frame()
      t = t + dt
      opacity = math.min(1, opacity + 0.5 * t ^ 2)
    end
    wait(2)
    t = 0
    while opacity > 0 do
      local dt = wait_frame()
      t = t + dt
      opacity = math.max(0, opacity - 0.1 * accel * t)
      r_opacity = opacity
    end
    draw_title = true
    wait(1)
    dissolve:start_appear()
    wait_signal(dissolve, "finished")
    wait(1)
    return require("gui"):set_menu("start")
  end)
end
return M
