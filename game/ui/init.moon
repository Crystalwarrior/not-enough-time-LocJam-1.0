path = (...)\gsub(".init$", "") .. '.'

g = require "global"
Atlas = require "engine.steelpan.atlas"
g.interface_atlas = Atlas("assets/spritesheets/interface.lua")

lc = require "engine"

skip = require "skip"

-- NLay = require "3rd.nlay"

-- NLay.update(0, 0, love.graphics.getDimensions())

-- root = NLay
-- g.nlay_inside_root = NLay.inside(root, 0)

-- rect = g.nlay_inside_root\constraint(root, root)\size(g.game_width, g.game_height)\bias(0,0)
-- g.nlay_inside_game = NLay.inside(rect, 0)

g.font_lowres = love.graphics.setNewFont("assets/fonts/LanaPixel_outline.fnt")
g.font_no_outline = love.graphics.newFont("assets/fonts/LanaPixel.fnt")
g.font_hires = g.font_lowres
-- love.graphics.newFont("assets/fonts/NotoSans JP.fnt")
-- g.font_hires\setFilter("linear", "linear")

g.font = g.font_lowres

g.hires_scale = g.font_lowres\getHeight()/g.font_hires\getHeight()

-- g.hires_shader_inner = love.graphics.newShader [[
-- const float smoothing = 2.0/16.0;
-- const float outerEdgeCenter = 0.7;

-- vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
--     float distance = Texel(tex, texture_coords).a;
--     float alpha = smoothstep(outerEdgeCenter - smoothing, outerEdgeCenter + smoothing, distance);
--     return vec4(color.rgb, color.a * alpha);
-- }
-- ]]

-- g.hires_shader_outer = love.graphics.newShader [[
-- const float smoothing = 1.0/16.0;
-- const float outlineWidth = 8.0/16.0;
-- const float outerEdgeCenter = 0.7 - outlineWidth;
-- const vec3 outlineColor = vec3(0.0, 0.0, 0.0);

-- vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
--     float distance = Texel(tex, texture_coords).a;
--     float alpha = smoothstep(outerEdgeCenter - smoothing, outerEdgeCenter + smoothing, distance);
--     return vec4(outlineColor, alpha);
-- }
-- ]]

cursor = require path .. "cursor"
look = require path .. "look"
inventory = require path .. "inventory"
dialogues = require path .. "dialogues"
cog = require path .. "cog"

M = {}

M.draw_canvas = =>
    if lc.dialogues\is_running()
        dialogues\draw_canvas()
    else
        inventory\draw()
        look\draw_canvas() if not require("gui").menu

    skip\draw_canvas()
    cog\draw_canvas()

M.draw_screen = =>
    if lc.dialogues\is_running()
        dialogues\draw_screen()
    else
        look\draw_screen() if not require("gui").menu
    cursor\draw()

M.update = (dt) =>
    look\update()
    if lc.dialogues\is_running()
        dialogues\update()

M.mousemoved = (x, y, p) =>
    cursor\mousemoved(x, y)
    if lc.dialogues\is_running()
        dialogues\mousemoved(p.x, p.y)
    else
        inventory\mousemoved(p.x, p.y)

M.mousereleased = =>
    if lc.dialogues\is_running()
        dialogues\mousereleased()

M.wheelmoved = (x, y) =>
    if lc.dialogues\is_running()
        dialogues\wheelmoved(y)

M.mouse_on_inventory = (x, y) => inventory\mouse_on_inventory(x, y)

return M
