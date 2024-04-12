path = (...)\gsub("[^%.]*$", "")
M = require(path .. 'main')

game = {}
M.game = game

game.set_room = (room) -> game.room = room

game.room_scale = ->
	game.room and game.room.scale or game.global_room_scale or 1

game.set_player = (character) -> game.player = character


-- game.coordinates = (x, y) -> 
-- 	M.Vec2(M.camera.get_coordinates(x, y))/game.room_scale()

game.update = (dt) ->
    if game.room then game.room\update(dt)
    -- M._update_global_threads(dt)

-- game.draw = (override_camera) ->
--     M.camera.push() if not override_camera
--     game.room\draw() if game.room
--     M.camera.pop() if not override_camera