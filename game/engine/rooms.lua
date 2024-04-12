local path = (...):gsub("[^%.]*$", "")
local M = require(path .. 'main')
local Animation, Navigation, game
Animation, Navigation, game = M.Animation, M.Navigation, M.game
local Atlas, Vec2, Class
do
  local _obj_0 = M.steelpan
  Atlas, Vec2, Class = _obj_0.Atlas, _obj_0.Vec2, _obj_0.Class
end
local simplify_path
simplify_path = M.steelpan.utils.simplify_path
local round
round = M.steelpan.utils.math.round
local huge
huge = math.huge
local baseline_sort
baseline_sort = function(a, b)
  return a._baseline < b._baseline
end
local position_sort
position_sort = function(a, b)
  return a._position.y < b._position.y
end
local layer_sort
layer_sort = function(a, b)
  return a.zsort < b.zsort
end
local Hotspot = Class({
  __init = function(self, t, position)
    self._xmin = t[1][1] + position.x
    self._xmax = t[2][1] + position.x
    self._ymin = t[1][2] + position.y
    self._ymax = t[2][2] + position.y
  end,
  is_mouse_inside = function(self, p)
    local x, y = p.x, p.y
    return x >= self._xmin and x <= self._xmax and y >= self._ymin and y <= self._ymax
  end
})
local Object = Class({
  __init = function(self, t, atlas)
    self._name = t.name
    self._baseline = t.baseline or 0
    self._position = Vec2(unpack(t.position or { }))
    if t.hotspot then
      self._hotspot = Hotspot(t.hotspot, self._position)
    end
    self._animations = { }
    local first_animation
    local _list_0 = (t.animations or { })
    for _index_0 = 1, #_list_0 do
      local a = _list_0[_index_0]
      if not first_animation then
        first_animation = a.name
      end
      if a.frames and #a.frames > 0 then
        local layers = {
          {
            frames = a.frames,
            name = "",
            visible = true
          }
        }
        self._animations[a.name] = Animation(atlas, layers, a.fps or 10, Animation.TOP_LEFT)
      end
    end
    self._animation = self._animations[first_animation]
  end,
  start_animation = function(self, name, play_once)
    self._animation = self._animations[name]
    if not self._animation then
      return 
    end
    self._animation:start(nil, play_once)
    return self._animation
  end,
  draw = function(self, x, y, scale)
    if x == nil then
      x = 0
    end
    if y == nil then
      y = 0
    end
    if scale == nil then
      scale = 1
    end
    do
      local a = self._animation
      if a then
        local oldshader, oldcolour
        if self._shader then
          oldshader = love.graphics.getShader()
          love.graphics.setShader(self._shader)
        end
        if self._colour then
          oldcolour = {
            love.graphics.getColor()
          }
          love.graphics.setColor(self._colour)
        end
        a:draw(scale * self._position.x + x, scale * self._position.y + y, 0, scale, scale)
        if self._colour then
          love.graphics.setColor(oldcolour)
        end
        if self._shader then
          love.graphics.setShader(oldshader)
        end
      end
    end
    do
      local im = self._image
      if im then
        if type(im) == "function" then
          im = im()
        end
        return love.graphics.draw(im, x, y)
      end
    end
  end
})
M.Object = Object
local Room = Class({
  __init = function(self, filename, external)
    if filename then
      return self:open(filename, external)
    end
  end,
  open = function(self, filename, external)
    local t
    if external then
      t = loadfile(filename)()
    else
      t = love.filesystem.load(filename)()
    end
    local directory = filename:gsub("[^/]*$", "")
    self._navigation = Navigation(t.navigation, t.scaling)
    if t.atlas then
      self._atlas = Atlas(simplify_path(directory .. t.atlas))
    end
    self._background = t.background or { }
    self._layers = t.layers or { }
    self._bounds = t.bounds and (function()
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = t.bounds
      for _index_0 = 1, #_list_0 do
        local v = _list_0[_index_0]
        _accum_0[_len_0] = Vec2(unpack(v))
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end)() or {
      Vec2(),
      Vec2(100, 100)
    }
    local objects_sorted = {
      bg = { }
    }
    local _list_0 = self._layers
    for _index_0 = 1, #_list_0 do
      local layer = _list_0[_index_0]
      objects_sorted[layer] = { }
    end
    local objects = { }
    local _list_1 = (t.objects or { })
    for _index_0 = 1, #_list_1 do
      local object = _list_1[_index_0]
      local obj = Object(object, self._atlas)
      local s = objects_sorted[self._layers[object.layer]] or objects_sorted.bg
      s[#s + 1] = obj
      objects[object.name] = obj
    end
    table.sort(objects_sorted.bg, baseline_sort)
    local _list_2 = self._layers
    for _index_0 = 1, #_list_2 do
      local layer = _list_2[_index_0]
      table.sort(objects_sorted[layer], baseline_sort)
    end
    self._objects = objects
    self._objects_sorted = objects_sorted
    table.sort(self._layers, layer_sort)
    self.characters = { }
  end,
  draw_layer = function(self, layer)
    if layer.hidden then
      return 
    end
    for _index_0 = 1, #layer do
      local name = layer[_index_0]
      if self._atlas[name] then
        self._atlas[name]:draw(x, y, 0, self.scale)
      end
    end
    local _list_0 = self._objects_sorted[layer]
    for _index_0 = 1, #_list_0 do
      local object = _list_0[_index_0]
      if not (object.hidden) then
        object:draw(x, y, self.scale)
      end
    end
  end,
  draw_background = function(self)
    local _list_0 = self._background
    for _index_0 = 1, #_list_0 do
      local name = _list_0[_index_0]
      if self._atlas[name] then
        self._atlas[name]:draw(0, 0, 0, self._scale)
      end
    end
    local _list_1 = self._objects_sorted.bg
    for _index_0 = 1, #_list_1 do
      local o = _list_1[_index_0]
      local player = game.player
      if o._baseline <= 0 or o._baseline * player._scale.y < player._position.y * player._scale.y then
        if not (o.hidden) then
          o:draw(0, 0, self.scale)
        end
      end
    end
    local characters
    do
      local _accum_0 = { }
      local _len_0 = 1
      for c in pairs(self.characters or { }) do
        _accum_0[_len_0] = c
        _len_0 = _len_0 + 1
      end
      characters = _accum_0
    end
    table.sort(characters, position_sort)
    local obj_idx, char_idx = 1, 1
    local c = characters[1] or {
      _position = {
        y = huge
      }
    }
    while obj_idx <= #self._objects_sorted.bg do
      local o = self._objects_sorted.bg[obj_idx]
      if o._baseline < c._position.y then
        if not (o.hidden) then
          o:draw(0, 0, self.scale)
        end
        obj_idx = obj_idx + 1
      else
        while char_idx <= #characters do
          c:draw()
          char_idx = char_idx + 1
          c = characters[char_idx] or {
            _position = {
              y = huge
            }
          }
          if c._position.y > o._baseline then
            break
          end
        end
      end
    end
    for i = char_idx, #characters do
      characters[i]:draw()
    end
  end,
  draw = function(self)
    if self._atlas then
      local idx = 1
      local _list_0 = self._layers
      for _index_0 = 1, #_list_0 do
        local layer = _list_0[_index_0]
        if layer.zsort < 0 then
          self:draw_layer(layer)
          idx = idx + 1
        else
          break
        end
      end
      self:draw_background()
      for i = idx, #self._layers do
        self:draw_layer(self._layers[i])
      end
    end
  end,
  update = function(self, dt)
    for character in pairs(self.characters) do
      character:update(dt)
    end
    for name, object in pairs(self._objects) do
      if object._animation then
        object._animation:update(dt)
      end
    end
  end,
  get_hotspot = function(self, p)
    local t = self._objects_sorted.bg
    for i = #t, 1, -1 do
      local obj = t[i]
      if not obj.hidden and obj._hotspot and obj._hotspot:is_mouse_inside(p) then
        return obj
      end
    end
  end,
  get_object = function(self, name)
    return self._objects[name]
  end
})
M.Room = Room
