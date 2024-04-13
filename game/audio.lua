local g = require("global")
local lc = require("engine")
local M = { }
if not g.volume then
  g.volume = 0.5
end
if love.system.getOS() ~= "Web" then
  local fmod = require("fmodstudio")
  if fmod then
    local system = fmod.Studio.System.create()
    system:initialize(50, g.debug and fmod.FMOD_STUDIO_INIT_LIVEUPDATE or fmod.FMOD_STUDIO_INIT_NORMAL, fmod.FMOD_INIT_NORMAL)
    system:loadBankFile(g.base_dir .. "/audio/Master.bank", fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
    system:loadBankFile(g.base_dir .. "/audio/Master.strings.bank", fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
    local music_instance
    M.get_system = function()
      return system
    end
    M.set_volume = function(v)
      g.volume = v
      do
        local i = music_instance
        if i then
          return i:setVolume(v)
        end
      end
    end
    M.start_music = function()
      music_instance = system:getEvent("event:/music"):createInstance()
      music_instance:start()
      music_instance:release()
      music_instance:setVolume(g.volume)
      return music_instance
    end
    M.stop_music = function()
      if music_instance then
        music_instance:stop(fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
      end
      music_instance = nil
    end
    M.set_parameter = function(name, value)
      if music_instance then
        music_instance:setParameterByName(name, value, 0)
        return system:flushCommands()
      end
    end
    M.start_oneshot = function(name)
      if music_instance then
        music_instance:setParameterByName(name, 1, 0)
        return system:flushCommands()
      end
    end
    M.restart_music = function()
      if music_instance then
        local pos = music_instance:getTimelinePosition()
        if pos > 66000 then
          return music_instance:setTimelinePosition(0)
        end
      end
    end
    M.update = function()
      return system:update()
    end
    M.quit = function()
      return system:release()
    end
  else
    local do_nothing
    do_nothing = function() end
    M.get_system = do_nothing
    M.set_volume = do_nothing
    M.start_music = do_nothing
    M.stop_music = do_nothing
    M.set_parameter = do_nothing
    M.start_oneshot = do_nothing
    M.restart_music = do_nothing
    M.update = do_nothing
    M.quit = do_nothing
  end
else
  local js = require("love.js")
  M.get_system = function() end
  M.set_volume = function(v)
    js.run(string.format("set_volume(%s);", v))
    g.volume = v
  end
  M.start_ambient = function(name, position)
    local pos = string.format("[%f,%f]", position.x, position.y)
    return js.run(string.format("start_ambient('%s', %s);", name, pos))
  end
  M.stop_ambient = function(name) end
  M.start_music = function()
    return js.run(string.format("start_music(%s);", g.volume))
  end
  M.stop_music = function()
    return js.run("stop_music();")
  end
  M.set_parameter = function(name, value)
    return js.run(string.format("set_parameter('%s', %s);", name, value))
  end
  M.start_oneshot = function(name)
    return js.run(string.format("start_oneshot('%s');", name))
  end
  M.restart_music = function()
    return js.run("restart_music();")
  end
  M.update = function() end
  M.quit = function() end
end
M.switch_room = function(room)
  local i
  local _exp_0 = room
  if g.rooms.present == _exp_0 then
    i = 2
  elseif g.rooms.past == _exp_0 then
    i = 0
  elseif g.rooms.collector == _exp_0 then
    i = 1
  elseif g.rooms.future == _exp_0 then
    i = 3
  end
  return M.set_parameter("room", i)
end
return M
