local g = require("global")
local lc = require("engine")
local audio = require("audio")
local shake = require("shake")
local gui = require("gui")
local M = { }
M.draw = function() end
M.keypressed = function(key)
  local game = lc.game
  local room
  local _exp_0 = key
  if "1" == _exp_0 then
    room = g.rooms.present
  elseif "2" == _exp_0 then
    room = g.rooms.collector
  elseif "3" == _exp_0 then
    room = g.rooms.future
  elseif "4" == _exp_0 then
    room = g.rooms.past
  end
  if room then
    return g.blocking_thread(function()
      audio.switch_room(room)
      shake:start()
      wait_signal(shake, "finished")
      game.set_room(room)
      return game.player:change_room(room, game.player._position:unpack())
    end)
  end
end
return M
