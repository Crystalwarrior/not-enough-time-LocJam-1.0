local dialogues
dialogues = require("engine").dialogues
local g = require("global")
local M = { }
local font_height = g.font_lowres:getHeight()
local padding = 3
local max_lines = 4
local buttons = {
  up = g.interface_atlas.scroll_up,
  down = g.interface_atlas.scroll_down
}
local buttons_vspacing = 1
local line_size = g.game_width - buttons.up.size.x - padding
local scroll_speed = 25
local scroll_wait = 0.5
local height = font_height * max_lines + 2 * padding
local y_offset = g.game_height - height
local normal_col = {
  1,
  1,
  1
}
local selected_col = {
  1,
  1,
  0.5
}
local selected_choice, choices
local show_up, show_down
local update_buttons
update_buttons = function()
  show_up = choices.scroll > 0
  show_down = #choices - choices.scroll > max_lines
end
M.update = function(self)
  local old_choices = choices
  choices = dialogues:get_choices()
  if not (choices) then
    return 
  end
  if choices ~= old_choices then
    choices.scroll = 0
    love.mousemoved(love.mouse.getPosition())
  end
  return update_buttons()
end
local draw_text
draw_text = function()
  love.graphics.push("all")
  love.graphics.setFont(g.use_hires_font and g.font_hires or g.font_lowres)
  local scale = g.use_hires_font and g.scale or 1
  local xshift = g.use_hires_font and g.xshift or 0
  local yshift = g.use_hires_font and g.yshift or 0
  love.graphics.scale(scale)
  love.graphics.translate(xshift, yshift)
  love.graphics.translate(padding, y_offset + padding)
  g.selected_dialogue_choice = nil
  for i = 1 + choices.scroll, math.min(max_lines + choices.scroll, #choices) do
    local c = choices[i]
    local j = i - choices.scroll
    love.graphics.setColor(selected_choice == i and selected_col or normal_col)
    love.graphics.setScissor(xshift + scale * (padding - 1), yshift + scale * (y_offset + padding + font_height * (j - 1)), xshift + scale * (line_size + 1), love.graphics.getHeight())
    local offset = math.floor(c.offset or 0)
    if g.use_hires_font then
      love.graphics.setShader(g.hires_shader_outer)
      love.graphics.print(c.text_sub, offset, font_height * (j - 1), 0, g.hires_scale)
      love.graphics.setShader(g.hires_shader_inner)
    end
    love.graphics.print(c.text_sub, offset, font_height * (j - 1), 0, g.use_hires_font and g.hires_scale or 1)
  end
  return love.graphics.pop()
end
M.draw_canvas = function(self)
  if not (choices) then
    return 
  end
  love.graphics.push("all")
  love.graphics.setColor(0, 0, 0, 0.3)
  love.graphics.rectangle("fill", 0, y_offset, g.game_width, height)
  love.graphics.translate(padding, y_offset + padding)
  if show_up then
    love.graphics.setColor(buttons.selected == buttons.up and selected_col or normal_col)
    buttons.up:draw(line_size, -padding)
  end
  if show_down then
    love.graphics.setColor(buttons.selected == buttons.down and selected_col or normal_col)
    buttons.down:draw(line_size, -padding + buttons.up.size.y + buttons_vspacing)
  end
  love.graphics.pop()
  if not g.use_hires_font then
    return draw_text()
  end
end
M.draw_screen = function(self)
  if not (choices) then
    return 
  end
  if g.use_hires_font then
    return draw_text()
  end
end
M.mousemoved = function(self, x, y)
  if not (choices) then
    return 
  end
  local old_choice = selected_choice
  selected_choice = nil
  buttons.selected = nil
  for i = 1 + choices.scroll, math.min(max_lines + choices.scroll, #choices) do
    local c = choices[i]
    local j = i - choices.scroll
    if x >= padding and x < padding + line_size and y >= y_offset + padding + font_height * (j - 1) and y < y_offset + padding + font_height * j then
      selected_choice = i
      c.size = c.size or g.font:getWidth(c.text_sub)
      c.size_hires = c.size_hires or g.hires_scale * g.font_hires:getWidth(c.text_sub)
      if (g.use_hires_font and c.size_hires > line_size) or (not g.use_hires_font and c.size > line_size) then
        if c.moving ~= 1 then
          c.moving = 1
          if c.thread then
            c.thread:stop()
          end
          c.thread = g.start_thread(function()
            c.offset = c.offset or 0
            if c.offset == 0 then
              wait(scroll_wait)
            end
            local size
            size = function()
              return g.use_hires_font and c.size_hires or c.size
            end
            while size() + c.offset > line_size do
              local dt = wait_frame()
              c.offset = c.offset - (scroll_speed * dt)
            end
            c.offset = line_size - size()
          end)
        end
      end
    end
  end
  if selected_choice ~= old_choice then
    do
      local c = choices[old_choice]
      if c then
        if c.moving == 1 then
          if c.thread then
            c.thread:stop()
          end
          c.moving = -1
          c.thread = g.start_thread(function()
            while c.offset < 0 do
              local dt = wait_frame()
              c.offset = c.offset + (scroll_speed * dt)
            end
            c.offset = 0
          end)
        end
      end
    end
  end
  if x >= padding + line_size and x < g.game_width then
    if show_up and y >= y_offset and y < y_offset + buttons.up.size.y then
      buttons.selected = buttons.up
    elseif show_down and y >= y_offset + buttons.up.size.y and y <= g.game_height then
      buttons.selected = buttons.down
    end
  end
end
M.mousereleased = function(self)
  if not (choices) then
    return 
  end
  if selected_choice then
    dialogues:select(selected_choice)
    selected_choice = nil
  elseif show_down and buttons.selected == buttons.down then
    choices.scroll = math.min(#choices - max_lines, choices.scroll + 1)
  elseif show_up and buttons.selected == buttons.up then
    choices.scroll = math.max(0, choices.scroll - 1)
  end
end
M.wheelmoved = function(self, y)
  if not (choices) then
    return 
  end
  local moved
  if show_down and y < 0 then
    choices.scroll = math.min(#choices - max_lines, choices.scroll + 1)
    moved = true
  elseif show_up and y > 0 then
    choices.scroll = math.max(0, choices.scroll - 1)
    moved = true
  end
  if moved then
    update_buttons()
    return love.mousemoved(love.mouse.getPosition())
  end
end
return M
