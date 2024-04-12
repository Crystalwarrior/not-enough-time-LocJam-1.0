local g = require("global")
local lc = require("engine")
local M = { }
M.shader = love.graphics.newShader([[uniform Image noise;
uniform float threshold;
uniform vec2 game_size;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texturecolor = Texel(tex, texture_coords);
    vec4 noisecolor = Texel(noise, screen_coords/game_size);
    float alpha = step(noisecolor.r, threshold);
    return vec4(texturecolor.rgb, alpha*texturecolor.a);
}

]])
local min_threshold = 0.5
local default_speed = 0.01
M.noise = love.graphics.newImage("assets/single_sprites/noise.png")
M.shader:send("noise", M.noise)
M.shader:send("threshold", min_threshold)
M.shader:send("game_size", {
  g.game_width,
  g.game_height
})
M.start_appear = function(self, speed)
  if speed == nil then
    speed = default_speed
  end
  return g.start_thread(function()
    local threshold = min_threshold
    self.shader:send("threshold", min_threshold)
    local t = 0
    while threshold < 1 do
      local dt = wait_frame()
      t = t + dt
      threshold = math.min(1, threshold + speed * t)
      M.shader:send("threshold", threshold)
    end
    return lc.signals.emit(self, "finished")
  end)
end
M.start_disappear = function(self, speed)
  if speed == nil then
    speed = default_speed
  end
  return g.start_thread(function()
    local threshold = 1.0
    self.shader:send("threshold", threshold)
    local t = 0
    while threshold > min_threshold do
      local dt = wait_frame()
      t = t + dt
      threshold = math.max(min_threshold, threshold - speed * t)
      M.shader:send("threshold", threshold)
    end
    return lc.signals.emit(self, "finished")
  end)
end
return M
