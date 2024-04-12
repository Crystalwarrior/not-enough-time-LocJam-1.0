g = require "global"
lc = require "engine"

credits = {
    {
        title: -> TEXT(346, "Created, written, and designed by")
        text: -> "Andrea Cerbone\nPaolo Cotrone\nGiuseppe Sellaroli"
    }
    {
        title: -> TEXT(347, "Programmed by")
        text: -> "Giuseppe Sellaroli"
    }
    {
        title: -> TEXT(348, "Art and animation by")
        text: -> "Andrea Cerbone"
    }
    {
        title: -> TEXT(349, "Original music by")
        text: -> "Paolo Cotrone\n(shamisenorchestra.com)"
    }
    {
        title: -> TEXT(350, "Additional art by")
        text: -> "Giuseppe Sellaroli"
    }
    {
        title: -> TEXT(351, "Additional sound effects by")
        text: -> "Giuseppe Sellaroli"
    }
    {
        custom: true
    }
    {
        title: -> TEXT(653, "LanaPixel Font by")
        text: -> "eishiya\n(https://mastodon.art/@eishiya)"
    }
    {
        title: -> TEXT(352, "Made with")
        text: -> "LÖVE\nlove.js"
    }
    {
        title: -> TEXT(353, "Audio engine")
        text: -> "FMOD Studio by Firelight Technologies Pty Ltd."
    }
    {
        title: -> TEXT(354, "GUI framework")
        text: -> "Inky"
    }
    {
        title: -> ""
        text: -> TEXT(356, "Thanks for playing!")
        time: math.huge
    }
}

for i, t in ipairs(credits)
    if t.custom
        offset = i - 1
        table.remove(credits, i)
        for j, s in ipairs(require("text_credits"))
            tmp = {
                title: -> lc.tr_text == require("text_english") and s.title_english or s.title_translated
                text: -> lc.tr_text == require("text_english") and s.names_english or s.names_translated
            }
            table.insert(credits, offset + j, tmp)
        break

local current_credit, text1, text2
credit_time = 5

bg_color = {0.086, 0.09, 0.341, 0}
col1 = {0.922, 0.506, 0.22}
col2 = {0.949, 0.804, 0.647}

g.draw_credits = ->
    font_scale = g.use_hires_font and g.hires_scale or 1


    love.graphics.push("all")
    love.graphics.scale(g.scale)
    love.graphics.translate(g.xshift, g.yshift)
    love.graphics.setColor(bg_color)
    love.graphics.rectangle("fill", 0, 0, g.game_width, g.game_height)

    if g.test_credits
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Press C to exit credits", 5, 0)

    if current_credit
        if g.use_hires_font
            love.graphics.setFont(g.font_hires)
            love.graphics.setShader(g.hires_shader_outer)
            love.graphics.printf(text1, 0, g.game_height/3, g.game_width/font_scale, "center", 0, font_scale)
            love.graphics.printf(text2, 0, g.game_height/3 + g.font\getHeight(), g.game_width/font_scale, "center", 0, font_scale)
        
        love.graphics.setShader(g.hires_shader_inner) if g.use_hires_font
        love.graphics.setColor(col1)
        love.graphics.printf(text1, 0, g.game_height/3, g.game_width/font_scale, "center", 0, font_scale)
        love.graphics.setColor(col2)
        love.graphics.printf(text2, 0, g.game_height/3 + g.font\getHeight(), g.game_width/font_scale, "center", 0, font_scale)

    love.graphics.pop()

g.credits_thread = g.start_thread ->
    t = 0
    duration = 3
    final_alpha = 0.5

    while t < duration
        dt = wait_frame()
        t += dt
        bg_color[4] = final_alpha*math.min(t/duration, 1)

    wait 0.5
    for i, t in ipairs(credits)
        current_credit = t
        text1 = t.title()
        text2 = t.text()
        wait(t.time or credit_time)
        current_credit = nil
        wait 1

    if g.test_credits
        love.keypressed("c")
        return

    wait 1
    love.event.quit()
