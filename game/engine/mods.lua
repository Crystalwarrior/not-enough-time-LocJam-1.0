local path = (...):gsub("[^%.]*$", "")
local lc = require(path .. 'main')
lc.game.set_room = function(room)
  local game = lc.game
  game.room = room
  love.mousemoved(love.mouse.getPosition())
  if not (game.player) then
    return 
  end
  local nav = room._navigation
  if not nav:is_point_inside(game.player._position) then
    game.player._position = nav:closest_boundary_point(game.player._position)
  end
end
