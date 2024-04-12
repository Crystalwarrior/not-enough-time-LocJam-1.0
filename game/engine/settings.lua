local path = (...):gsub("[^%.]*$", "")
local M = require(path .. 'main')
local status, mod = pcall(require, "love")
local love = status and mod or nil
local SettingsCategory = M.class({
  __init = function(self, tbl)
    self.__default = tbl
    self.__current = { }
  end,
  set = function(self, tbl)
    for k, v in pairs(tbl) do
      self.__current[k] = v
    end
  end,
  __index = function(t, key)
    return t.__current[key] or t.__default[key]
  end
})
local settings = { }
M.settings = settings
local speaking = {
  font = love and love.graphics.getFont(),
  max_lines = 3,
  max_width_ratio = 0.5,
  xpadding = 4,
  ypadding = 2,
  distance_from_character = 10
}
settings.speaking = SettingsCategory(speaking)
local debug = {
  print = false
}
settings.debug = SettingsCategory(debug)
