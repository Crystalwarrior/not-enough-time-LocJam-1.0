local path = (...):gsub("[^%.]*$", "")
local M = require(path .. 'main')
local game = { }
M.game = game
game.set_room = function(room)
  game.room = room
end
game.room_scale = function()
  return game.room and game.room.scale or game.global_room_scale or 1
end
game.set_player = function(character)
  game.player = character
end
game.update = function(dt)
  if game.room then
    return game.room:update(dt)
  end
end
