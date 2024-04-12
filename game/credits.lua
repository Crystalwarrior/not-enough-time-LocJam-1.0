local g = require("global")
local lc = require("engine")
local credits = {
  {
    title = function()
      return TEXT(346, "Created, written, and designed by")
    end,
    text = function()
      return "Andrea Cerbone\nPaolo Cotrone\nGiuseppe Sellaroli"
    end
  },
  {
    title = function()
      return TEXT(347, "Programmed by")
    end,
    text = function()
      return "Giuseppe Sellaroli"
    end
  },
  {
    title = function()
      return TEXT(348, "Art and animation by")
    end,
    text = function()
      return "Andrea Cerbone"
    end
  },
  {
    title = function()
      return TEXT(349, "Original music by")
    end,
    text = function()
      return "Paolo Cotrone\n(shamisenorchestra.com)"
    end
  },
  {
    title = function()
      return TEXT(350, "Additional art by")
    end,
    text = function()
      return "Giuseppe Sellaroli"
    end
  },
  {
    title = function()
      return TEXT(351, "Additional sound effects by")
    end,
    text = function()
      return "Giuseppe Sellaroli"
    end
  },
  {
    custom = true
  },
  {
    title = function()
      return TEXT(653, "LanaPixel Font by")
    end,
    text = function()
      return "eishiya\n(https://mastodon.art/@eishiya)"
    end
  },
  {
    title = function()
      return TEXT(352, "Made with")
    end,
    text = function()
      return "LÖVE\nlove.js"
    end
  },
  {
    title = function()
      return TEXT(353, "Audio engine")
    end,
    text = function()
      return "FMOD Studio by Firelight Technologies Pty Ltd."
    end
  },
  {
    title = function()
      return TEXT(354, "GUI framework")
    end,
    text = function()
      return "Inky"
    end
  },
  {
    title = function()
      return ""
    end,
    text = function()
      return TEXT(356, "Thanks for playing!")
    end,
    time = math.huge
  }
}
for i, t in ipairs(credits) do
  if t.custom then
    local offset = i - 1
    table.remove(credits, i)
    for j, s in ipairs(require("text_credits")) do
      local tmp = {
        title = function()
          return lc.tr_text == require("text_english") and s.title_english or s.title_translated
        end,
        text = function()
          return lc.tr_text == require("text_english") and s.names_english or s.names_translated
        end
      }
      table.insert(credits, offset + j, tmp)
    end
    break
  end
end
local current_credit, text1, text2
local credit_time = 5
local bg_color = {
  0.086,
  0.09,
  0.341,
  0
}
local col1 = {
  0.922,
  0.506,
  0.22
}
local col2 = {
  0.949,
  0.804,
  0.647
}
g.draw_credits = function()
  local font_scale = g.use_hires_font and g.hires_scale or 1
  love.graphics.push("all")
  love.graphics.scale(g.scale)
  love.graphics.translate(g.xshift, g.yshift)
  love.graphics.setColor(bg_color)
  love.graphics.rectangle("fill", 0, 0, g.game_width, g.game_height)
  if g.test_credits then
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press C to exit credits", 5, 0)
  end
  if current_credit then
    if g.use_hires_font then
      love.graphics.setFont(g.font_hires)
      love.graphics.setShader(g.hires_shader_outer)
      love.graphics.printf(text1, 0, g.game_height / 3, g.game_width / font_scale, "center", 0, font_scale)
      love.graphics.printf(text2, 0, g.game_height / 3 + g.font:getHeight(), g.game_width / font_scale, "center", 0, font_scale)
    end
    if g.use_hires_font then
      love.graphics.setShader(g.hires_shader_inner)
    end
    love.graphics.setColor(col1)
    love.graphics.printf(text1, 0, g.game_height / 3, g.game_width / font_scale, "center", 0, font_scale)
    love.graphics.setColor(col2)
    love.graphics.printf(text2, 0, g.game_height / 3 + g.font:getHeight(), g.game_width / font_scale, "center", 0, font_scale)
  end
  return love.graphics.pop()
end
g.credits_thread = g.start_thread(function()
  local t = 0
  local duration = 3
  local final_alpha = 0.5
  while t < duration do
    local dt = wait_frame()
    t = t + dt
    bg_color[4] = final_alpha * math.min(t / duration, 1)
  end
  wait(0.5)
  for i, t in ipairs(credits) do
    current_credit = t
    text1 = t.title()
    text2 = t.text()
    wait(t.time or credit_time)
    current_credit = nil
    wait(1)
  end
  if g.test_credits then
    love.keypressed("c")
    return 
  end
  wait(1)
  return love.event.quit()
end)
