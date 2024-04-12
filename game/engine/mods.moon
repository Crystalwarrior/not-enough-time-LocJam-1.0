path = (...)\gsub("[^%.]*$", "")
lc = require(path .. 'main')

lc.game.set_room = (room) ->
    game = lc.game
    game.room = room
    love.mousemoved(love.mouse.getPosition())

    -- move ines to the closest position
    return unless game.player
    nav = room._navigation
    if not nav\is_point_inside(game.player._position)
        game.player._position = nav\closest_boundary_point(game.player._position)