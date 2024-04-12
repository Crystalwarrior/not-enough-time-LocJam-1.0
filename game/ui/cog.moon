g = require "global"
lc = require "engine"
sprite = g.interface_atlas.cog
size = sprite.size
padding = 1


M = {}

M.full_width = sprite.size.x + padding

is_hidden = -> return g.blocked or lc.dialogues\is_running() or require("gui").menu

M.draw_canvas = =>
    return if is_hidden()
    sprite\draw(g.game_width - padding - size.x, padding)

M.is_mouse_on = =>
    return if is_hidden()
    x, y = g.p\unpack()
    return x >= g.game_width - padding - size.x and x <= g.game_width - padding and y >= padding and y <= padding + size.y


return M