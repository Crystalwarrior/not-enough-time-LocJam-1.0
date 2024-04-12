local path = (...):gsub("[^%.]*$", "")
local M = require(path .. 'main')
local signals
signals = M.signals
local Class, Set
do
  local _obj_0 = M.steelpan
  Class, Set = _obj_0.Class, _obj_0.Set
end
local xtype = M.steelpan.utils.type
local setfenv
setfenv = require(path .. "third-party.compat_env").setfenv
local status, mod = pcall(require, "love")
local love = status and mod or nil
local current_thread
local thread_env = setmetatable({ }, {
  __index = _G
})
local Thread = Class({
  __init = function(self, f)
    local env = setmetatable({ }, {
      __index = thread_env
    })
    setfenv(f, env)
    self._thread = coroutine.create(f)
    self._env = env
  end,
  update = function(self, dt, ...)
    if dt == nil then
      dt = 0
    end
    if self._dead then
      return 
    end
    local old_thread = current_thread
    current_thread = self
    assert(coroutine.resume(self._thread, dt, ...))
    self._dead = coroutine.status(self._thread) == "dead"
    current_thread = old_thread
  end,
  stop = function(self)
    self._dead = true
  end,
  resume = function(self)
    return self:update()
  end,
  extend_environment = function(self, t)
    if t then
      for k, v in pairs(t) do
        self._env[k] = v
      end
    end
    return self._env
  end
})
M._Thread = Thread
M.ThreadRegistry = Class({
  __init = function(self)
    self.threads = { }
  end,
  new = function(self, f)
    local t = Thread(f)
    self.threads[t] = true
    return t
  end,
  start = function(self, f)
    local t = self:new(f)
    t:resume()
    return t
  end,
  update = function(self, dt)
    for t in pairs(self.threads) do
      if t._dead then
        self.threads[t] = nil
        signals.emit(t, "finished")
      else
        t:update(dt)
      end
    end
  end,
  get_thread_environment = function(self)
    return thread_env
  end
})
M.extend_global_thread_environment = function(t)
  for k, v in pairs(t) do
    thread_env[k] = v
  end
end
M.inside_coroutine = function()
  return not not current_thread
end
signals = { }
M.signals = signals
local signals_table = setmetatable({ }, {
  __mode = "k"
})
signals.connect = function(object, name, f)
  signals_table[object] = signals_table[object] or {
    names = { },
    n = 0
  }
  local t = signals_table[object]
  if not t.names[name] then
    t.names[name] = Set()
    t.n = t.n + 1
  end
  return t.names[name]:add(f)
end
signals.disconnect = function(object, name, f)
  local t = signals_table[object]
  do
    local s = t and t.names[name]
    if s then
      s:remove(f)
      if s:size() == 0 then
        t.names[name] = nil
        t.n = t.n - 1
        if t.n == 0 then
          signals_table[object] = nil
        end
      end
    end
  end
end
signals.emit = function(object, name, ...)
  local t = signals_table[object]
  do
    local s = t and t.names[name]
    if s then
      for f in s:iterator() do
        if type(f) == 'function' then
          f(...)
        elseif xtype(f) == Thread then
          f:update(0, object, name)
        end
      end
    end
  end
end
thread_env.wait = function(t)
  if current_thread then
    while t > 0 do
      t = t - coroutine.yield()
    end
  end
end
thread_env.wait_random = function(tmin, tmax)
  local t = tmin + (tmax - tmin) * love.math.random()
  thread_env.wait(t)
  return t
end
thread_env.wait_signal = function(...)
  local n = select("#", ...)
  assert(n % 2 == 0, "Number of arguments should be even.")
  do
    local t = current_thread
    if t then
      for i = 1, n, 2 do
        local object, name = select(i, ...)
        signals.connect(object, name, t)
      end
      while true do
        local _, object, name = coroutine.yield()
        local outer_break = false
        for i = 1, n, 2 do
          local object_i, name_i = select(i, ...)
          if object_i == object and name_i == name then
            outer_break = true
            break
          end
        end
        if outer_break then
          break
        end
      end
      for i = 1, n, 2 do
        local object, name = select(i, ...)
        signals.disconnect(object, name, t)
      end
    end
  end
end
thread_env.wait_frame = function()
  return coroutine.yield()
end
