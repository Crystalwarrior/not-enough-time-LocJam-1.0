import dialogues from require "engine"
g = require "global"
M = {}

font_height = g.font_lowres\getHeight()
padding = 3
max_lines = 4

buttons = {
    up: g.interface_atlas.scroll_up
    down: g.interface_atlas.scroll_down
}

buttons_vspacing = 1

line_size = g.game_width - buttons.up.size.x - padding
scroll_speed = 25
scroll_wait = 0.5

height = font_height*max_lines + 2*padding
y_offset = g.game_height - height

normal_col = {1, 1, 1}
selected_col = {1, 1, 0.5}

local selected_choice, choices
local show_up, show_down

update_buttons = ->
    show_up = choices.scroll > 0
    show_down = #choices - choices.scroll > max_lines

M.update = =>
    old_choices = choices
    choices = dialogues\get_choices()
    return unless choices

    if choices ~= old_choices
        choices.scroll = 0
        love.mousemoved(love.mouse.getPosition())
    
    update_buttons()

draw_text = ->
    love.graphics.push("all")
    love.graphics.setFont(g.use_hires_font and g.font_hires or g.font_lowres)
    scale = g.use_hires_font and g.scale or 1
    xshift =  g.use_hires_font and g.xshift or 0
    yshift =  g.use_hires_font and g.yshift or 0
    love.graphics.scale(scale)
    love.graphics.translate(xshift, yshift)
    love.graphics.translate(padding, y_offset + padding)
    g.selected_dialogue_choice = nil
    for i = 1 + choices.scroll, math.min(max_lines + choices.scroll, #choices)
        c = choices[i]
        j = i - choices.scroll
        love.graphics.setColor(selected_choice == i and selected_col or normal_col)
        love.graphics.setScissor(xshift + scale*(padding - 1), yshift + scale*(y_offset + padding + font_height*(j-1)), xshift + scale*(line_size + 1), love.graphics.getHeight())--scale*font_height)
        offset = math.floor(c.offset or 0)
        if g.use_hires_font
            love.graphics.setShader(g.hires_shader_outer)
            love.graphics.print(c.text_sub, offset, font_height*(j-1), 0, g.hires_scale)
            love.graphics.setShader(g.hires_shader_inner)
        love.graphics.print(c.text_sub, offset, font_height*(j-1), 0, g.use_hires_font and g.hires_scale or 1)
    love.graphics.pop()



M.draw_canvas = =>
    return unless choices

    love.graphics.push("all")
    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", 0, y_offset, g.game_width, height)
    love.graphics.translate(padding, y_offset + padding)
    if show_up
        love.graphics.setColor(buttons.selected == buttons.up and selected_col or normal_col)
        buttons.up\draw(line_size, -padding)
    if show_down
        love.graphics.setColor(buttons.selected == buttons.down and selected_col or normal_col)
        buttons.down\draw(line_size, -padding + buttons.up.size.y + buttons_vspacing)
    love.graphics.pop()

    if not g.use_hires_font
        draw_text()
    

M.draw_screen = =>
    return unless choices
    if g.use_hires_font
        draw_text()


M.mousemoved = (x, y) =>
    return unless choices

    old_choice = selected_choice
    selected_choice = nil
    buttons.selected = nil
    for i = 1 + choices.scroll, math.min(max_lines + choices.scroll, #choices)
        c = choices[i]
        j = i - choices.scroll
        if x >= padding and x < padding + line_size and  y >= y_offset + padding + font_height*(j - 1) and y < y_offset + padding + font_height*j
            selected_choice = i

            c.size = c.size or g.font\getWidth(c.text_sub)
            c.size_hires = c.size_hires or g.hires_scale*g.font_hires\getWidth(c.text_sub)
            if (g.use_hires_font and c.size_hires > line_size) or (not g.use_hires_font and c.size > line_size)
                if c.moving ~= 1
                    c.moving = 1
                    c.thread\stop() if c.thread
                    c.thread = g.start_thread ->
                        c.offset = c.offset or 0
                        wait scroll_wait if c.offset == 0
                        size = -> return g.use_hires_font and c.size_hires or c.size
                        while size() + c.offset > line_size
                            dt = wait_frame()
                            c.offset -= scroll_speed*dt
                        c.offset = line_size - size()

    if selected_choice ~= old_choice
        if c = choices[old_choice]
            if c.moving == 1
                c.thread\stop() if c.thread
                c.moving = -1
                c.thread = g.start_thread ->
                    while c.offset < 0
                        dt = wait_frame()
                        c.offset += scroll_speed*dt
                    c.offset = 0

    if x >= padding + line_size and x < g.game_width
        if show_up and y >= y_offset and y < y_offset + buttons.up.size.y
            buttons.selected = buttons.up
        elseif show_down and y >= y_offset + buttons.up.size.y and y <= g.game_height
            buttons.selected = buttons.down

M.mousereleased = =>
    return unless choices
    if selected_choice
        dialogues\select(selected_choice)
        selected_choice = nil
    elseif show_down and buttons.selected == buttons.down
        choices.scroll = math.min(#choices - max_lines, choices.scroll + 1)
    elseif show_up and buttons.selected == buttons.up
        choices.scroll = math.max(0, choices.scroll - 1)

M.wheelmoved = (y) =>
    return unless choices
    local moved
    if show_down and y < 0
        choices.scroll = math.min(#choices - max_lines, choices.scroll + 1)
        moved = true
    elseif show_up and y > 0
        choices.scroll = math.max(0, choices.scroll - 1)
        moved = true

    if moved
        update_buttons()
        love.mousemoved(love.mouse.getPosition())
        

return M