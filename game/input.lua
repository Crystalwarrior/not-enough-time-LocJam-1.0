local g = require("global")
local lc = require("engine")
local ui = require("ui")
local gui = require("gui")
local speak = require("say")
local skip = require("skip")
local game
game = lc.game
local Vec2
Vec2 = lc.steelpan.Vec2
local round
round = lc.steelpan.utils.math.round
local random_choice
random_choice = lc.steelpan.utils.random_choice
local dbg = g.debug and require("dbg")
g.screen_transform = love.math.newTransform()
love.resize = function(w, h)
  g.screen_transform:reset()
  g.scale = math.min(w / g.game_width, h / g.game_height)
  if g.integer_scaling then
    g.scale = math.max(1, math.floor(g.scale))
  end
  g.xshift = round(math.max(0, math.min((w / g.scale - g.game_width) / 2)))
  g.yshift = round(math.max(0, math.min((h / g.scale - g.game_height) / 2)))
  g.screen_transform:scale(g.scale)
  g.screen_transform:translate(g.xshift, g.yshift)
  if love.mousemoved then
    return love.mousemoved(love.mouse.getPosition())
  end
end
love.resize(love.graphics.getDimensions())
local p = Vec2()
love.mousemoved = function(x, y)
  local X = round(x / g.scale - g.xshift)
  local Y = round(y / g.scale - g.yshift)
  p = Vec2(X, Y)
  g.p = p
  if not g.blocked then
    local room = lc.game.room
    do
      local obj = room:get_hotspot(p)
      if obj then
        do
          local text = obj.hotspot_text and obj.hotspot_text()
          if text then
            g.hotspot_text = text
            g.hotspot.type = "room"
            g.hotspot.object = obj
            g.look_text = obj.look_text and obj.look_text() or nil
          else
            g.hotspot.type = nil
            g.hotspot.object = nil
            g.hotspot_text = nil
          end
        end
      else
        g.hotspot.type = nil
        g.hotspot.object = nil
        g.hotspot_text = nil
      end
    end
  end
  ui:mousemoved(x, y, p)
  return gui:mousemoved()
end
love.mousereleased = function(x, y)
  if gui.menu then
    gui:mousereleased()
    return 
  end
  if not g.start_click then
    g.start_click = true
  end
  if g.blocked then
    return 
  end
  if lc.dialogues:is_running() then
    ui:mousereleased()
    return 
  end
  if require("ui.cog"):is_mouse_on() then
    gui:set_menu("options")
    return 
  end
  local obj = g.hotspot.object
  if obj and g.hotspot.type == "inventory" then
    do
      local f = obj.interact
      if f then
        return f()
      else
        g.inventory_item = obj
        love.mousemoved(x, y)
        return 
      end
    end
  elseif ui:mouse_on_inventory(g.p.x, g.p.y) then
    g.inventory_item = nil
    return 
  elseif obj and g.inventory_item then
    do
      local thread = g.interaction_thread
      if thread then
        thread:stop()
      end
    end
    local inv_item = g.inventory_item
    g.interacting_obj = obj
    do
      local f = obj.use and obj.use[inv_item.name]
      if f then
        g.interaction_thread = g.start_thread(function()
          local pos = obj.use_position or obj.interact_position
          if pos then
            game.player:walk_thread(pos:unpack())
          end
          do
            p = obj.look_point
            if p then
              wait(0.1)
              game.player:face2point(p)
              wait(0.1)
            elseif obj.interact_direction then
              wait(0.1)
              game.player:face2(obj.interact_direction)
              wait(0.1)
            end
          end
          f()
          g.inventory_item = nil
          g.interacting_obj = nil
        end)
      else
        do
          f = obj.use_nowalk and obj.use_nowalk[inv_item.name]
          if f then
            g.interacting_obj = nil
            g.inventory_item = nil
            return f()
          else
            g.interaction_thread = g.blocking_thread(function()
              local sentence = random_choice({
                TEXT(1, "I can't do that."),
                TEXT(2, "That won't work."),
                TEXT(3, "Nah."),
                TEXT(4, "Maybe later.")
              })
              say(game.player, sentence)
              g.interacting_obj = nil
            end)
          end
        end
      end
    end
  elseif obj and obj.interact then
    if obj == g.interacting_obj then
      return 
    end
    do
      local thread = g.interaction_thread
      if thread then
        thread:stop()
      end
    end
    g.interacting_obj = obj
    g.interaction_thread = g.start_thread(function()
      if obj.interact_position then
        game.player:walk_thread(obj.interact_position:unpack())
      end
      if obj.look_point then
        wait(0.1)
        game.player:face2point(obj.look_point)
        wait(0.1)
      elseif obj.interact_direction then
        wait(0.1)
        game.player:face2(obj.interact_direction)
        wait(0.1)
      end
      obj.interact()
      g.interacting_obj = nil
    end)
  elseif not obj and g.inventory_item then
    g.inventory_item = nil
  else
    do
      local thread = g.interaction_thread
      if thread then
        thread:stop()
      end
    end
    g.interacting_obj = nil
    g.inventory_item = nil
    return game.player:walk(p.x, p.y)
  end
end
love.keypressed = function(key)
  if g.test_credits and key == "c" then
    if g.credits_thread then
      g.credits_thread:stop()
    end
    g.test_credits = false
    require("gui").menu = require("gui.start")
    g.draw_credits = nil
    return 
  end
  if gui:keypressed(key) then
    return 
  end
  local _exp_0 = key
  if g.key.skip == _exp_0 then
    g.time_rate = 4
    speak:start_skipping()
    speak:skip()
  elseif g.key.cutscene == _exp_0 then
    skip:start_hold()
  elseif g.key.pause == _exp_0 then
    g.paused = not g.paused
    if g.paused then
      gui:set_menu("options")
    else
      gui:set_menu(not g.game_started and "start" or nil)
    end
  end
  if dbg then
    return dbg.keypressed(key)
  end
end
love.keyreleased = function(key)
  local _exp_0 = key
  if g.key.skip == _exp_0 then
    g.time_rate = 1
    speak:stop_skipping()
  elseif g.key.cutscene == _exp_0 then
    skip:release_hold()
  end
end
love.wheelmoved = function(x, y)
  return ui:wheelmoved(x, y)
end
love.mousepressed = function(x, y, button)
  if gui:mousepressed(button) then
    return 
  end
  if g.skip_with_left and button == 1 or g.skip_with_right and button == 2 then
    return speak:skip()
  end
end
