local path = (...):gsub("[^%.]*$", "")
local M = require(path .. 'main')
local Set
Set = M.steelpan.Set
local debug = { }
M.debug = debug
local flags = Set({
  'all'
})
debug.enable = function(flag)
  if flags:contains(flag) then
    debug[flag] = true
  elseif flag == 'all' then
    for f in flags:iterator() do
      debug[f] = true
    end
  end
end
debug.disable = function(flag)
  if flags:contains(flag) then
    debug[flag] = nil
  elseif flag == 'all' then
    for f in flags:iterator() do
      debug[f] = nil
    end
  end
end
debug.printf = function(s, ...)
  return print(s:format(...))
end
