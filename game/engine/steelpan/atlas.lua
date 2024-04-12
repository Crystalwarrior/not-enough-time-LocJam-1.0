local path = (...):gsub("[^%.]*$", "")
local Class = require(path .. "class")
local Vec2 = require(path .. "vectors")
local status, mod = pcall(require, "love")
local love = status and mod or nil
local loadstring = loadstring or load
local sprite_draw
sprite_draw = function(self, x, y, r, sx, sy, ox, oy, ...)
  if ox == nil then
    ox = 0
  end
  if oy == nil then
    oy = 0
  end
  ox = ox - self.offset_x
  oy = oy - self.offset_y
  return love.graphics.draw(self.spritesheet, self.quad, x, y, r, sx, sy, ox, oy, ...)
end
local Atlas = Class({
  __init = function(self, ...)
    local args = {
      ...
    }
    local filename, directory, tbl, external
    if type(args[1]) == 'string' then
      filename = args[1]
      external = args[2] or false
    elseif type(args[1]) == 'table' then
      tbl = args[1]
      directory = args[2]
      external = args[3] or false
    else
      error('wrong kind/number of arguments', 2)
    end
    if filename then
      local data
      if external then
        local f = assert(io.open(filename, 'r'))
        data = f:read('*all')
        f:close()
        data = love.filesystem.newFileData(data, filename):getString()
      else
        data = assert(love.filesystem.read(filename))
      end
      tbl = assert(loadstring(data))()
      directory = filename:gsub("[^/]*$", "")
    end
    local sprites = { }
    for _index_0 = 1, #tbl do
      local spritesheet = tbl[_index_0]
      filename = directory .. spritesheet.filename
      local img
      if external then
        local f = assert(io.open(filename, 'rb'))
        local data = f:read('*all')
        f:close()
        local fdata = love.filesystem.newFileData(data, filename)
        img = love.graphics.newImage(fdata)
      else
        img = love.graphics.newImage(filename)
      end
      local w, h = img:getDimensions()
      for _index_1 = 1, #spritesheet do
        local sprite = spritesheet[_index_1]
        local quad = love.graphics.newQuad(sprite.x, sprite.y, sprite.w, sprite.h, w, h)
        local offset_x, offset_y = sprite.offset_x, sprite.offset_y
        local size = Vec2(sprite.orig_w, sprite.orig_h)
        sprites[sprite.name] = {
          spritesheet = img,
          quad = quad,
          offset_x = offset_x,
          offset_y = offset_y,
          size = size,
          draw = sprite_draw
        }
      end
    end
    self.sprites = sprites
  end,
  __index = function(self, key)
    return self.sprites[key]
  end
})
return Atlas
