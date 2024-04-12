local path = (...):gsub("[^%.]*$", "")
local M = require(path .. 'main')
local Class
Class = M.steelpan.Class
local _Thread
_Thread = M._Thread
local setfenv
setfenv = require(path .. "third-party.compat_env").setfenv
local dialogues = { }
dialogues._clear = function(self)
  self._thread = nil
  self._env = nil
end
dialogues.new = function(self, t)
  assert(not self._current_dialogue, "A dialogue is already running.")
  local thread = _Thread(function()
    main()
    return exit()
  end)
  local env = thread._env
  env.say = say
  env.exit = function()
    self:_clear()
    coroutine.yield()
    return love.mousemoved(love.mouse.getPosition())
  end
  env._choices = { }
  env.option = function(text, f)
    return table.insert(env._choices, {
      text = text,
      f = f,
      text_sub = text:gsub("\n", "")
    })
  end
  env.selection = function()
    while #env._choices > 0 do
      coroutine.yield()
    end
    do
      local f = env._selection and env._selection.f
      if f then
        return f()
      end
    end
  end
  env.echo = function(character)
    do
      local text = env._selection and env._selection.text
      if text then
        return env.say(character, text)
      end
    end
  end
  for k, v in pairs(t) do
    env[k] = env[k] or v
    if type(v) == "function" then
      setfenv(v, env)
    end
  end
  thread:resume()
  self._thread = thread
  self._env = env
end
dialogues.update = function(self, dt)
  do
    local t = self._thread
    if t then
      return t:update(dt)
    end
  end
end
dialogues.get_choices = function(self)
  if #self._env._choices > 0 then
    self._env._choices.out = self._env._choices.out or (function()
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = self._env._choices
      for _index_0 = 1, #_list_0 do
        local c = _list_0[_index_0]
        _accum_0[_len_0] = {
          text = c.text,
          text_sub = c.text_sub
        }
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end)()
    return self._env._choices.out
  end
end
dialogues.select = function(self, i)
  do
    local c = assert(self._env._choices[i], "Invalid choice.")
    if c then
      self._env._choices = { }
      assert(type(c.f) == "function", "Invalid function for this choice.")
      self._env._selection = c
      return self._thread:resume()
    end
  end
end
dialogues.is_running = function(self)
  return not not self._thread
end
M.dialogues = dialogues
