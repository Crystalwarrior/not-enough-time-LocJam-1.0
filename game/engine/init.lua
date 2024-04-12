local path = (...):gsub(".init$", "") .. '.'
local M = require(path .. 'main')
local steelpan = {
  ["class"] = "Class",
  ["vectors"] = "Vec2",
  ["atlas"] = "Atlas",
  ["geometry"] = "geometry",
  ["camera"] = "Camera",
  ["cyclic"] = "CyclicList",
  ["sets"] = "Set",
  ["matrices"] = "matrices",
  ["utils"] = "utils"
}
do
  local _tbl_0 = { }
  for m, k in pairs(steelpan) do
    _tbl_0[k] = require(path .. "steelpan." .. m)
  end
  M.steelpan = _tbl_0
end
local modules = {
  'game',
  'animations',
  'characters',
  'threads',
  'dialogue',
  'navigation',
  'rooms',
  'mods'
}
for _index_0 = 1, #modules do
  local m = modules[_index_0]
  require(path .. m)
end
return M
