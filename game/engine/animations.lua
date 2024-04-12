local path = (...):gsub("[^%.]*$", "")
local M = require(path .. 'main')
local Atlas, Vec2, Class
do
  local _obj_0 = M.steelpan
  Atlas, Vec2, Class = _obj_0.Atlas, _obj_0.Vec2, _obj_0.Class
end
local simplify_path
simplify_path = M.steelpan.utils.simplify_path
local round
round = M.steelpan.utils.math.round
local fmod
fmod = math.fmod
local Animation = Class({
  __init = function(self, atlas, layers, fps, basepoint_position, basepoint_xshift, basepoint_yshift)
    if basepoint_position == nil then
      basepoint_position = self.__class.MIDDLE_CENTER
    end
    if basepoint_xshift == nil then
      basepoint_xshift = 0
    end
    if basepoint_yshift == nil then
      basepoint_yshift = 0
    end
    self._layers = { }
    self._layer_idxs = { }
    self._visibility_groups = { }
    for i, layer in ipairs(layers) do
      local frames
      do
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = layer.frames
        for _index_0 = 1, #_list_0 do
          local frame = _list_0[_index_0]
          _accum_0[_len_0] = atlas[frame] or false
          _len_0 = _len_0 + 1
        end
        frames = _accum_0
      end
      local offsets = layer.offsets and (function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = layer.offsets
        for _index_0 = 1, #_list_0 do
          local offset = _list_0[_index_0]
          _accum_0[_len_0] = Vec2(unpack(offset))
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)() or { }
      local name = layer.name
      local group
      if layer.group then
        do
          local t = self._visibility_groups[layer.group]
          if t then
            t[#t + 1] = name
            group = t
          else
            group = {
              name
            }
            self._visibility_groups[layer.group] = group
          end
        end
      end
      self._layers[i] = {
        frames = frames,
        offsets = offsets,
        visible = layer.visible,
        group = group
      }
      self._layer_idxs[layer.name] = i
    end
    local _list_0 = self._layers
    for _index_0 = 1, #_list_0 do
      local layer = _list_0[_index_0]
      local _list_1 = layer.frames
      for _index_1 = 1, #_list_1 do
        local frame = _list_1[_index_1]
        if frame then
          self._size = frame.size
          break
        end
      end
      if self._size then
        break
      end
    end
    assert(self._size, "All the frames are empty.")
    local w, h = self._size.x, self._size.y
    self._fps = fps
    self._num_frames = #self._layers[1].frames
    local _exp_0 = basepoint_position
    if self.__class.TOP_LEFT == _exp_0 then
      self._basepoint = Vec2(0, 0)
    elseif self.__class.TOP_CENTER == _exp_0 then
      self._basepoint = Vec2(round((w - 1) / 2), 0)
    elseif self.__class.TOP_RIGHT == _exp_0 then
      self._basepoint = Vec2(w - 1, 0)
    elseif self.__class.MIDDLE_LEFT == _exp_0 then
      self._basepoint = Vec2(0, round((h - 1) / 2))
    elseif self.__class.MIDDLE_CENTER == _exp_0 then
      self._basepoint = Vec2(round((w - 1) / 2), round((h - 1) / 2))
    elseif self.__class.MIDDLE_RIGHT == _exp_0 then
      self._basepoint = Vec2(w - 1, round((h - 1) / 2))
    elseif self.__class.BOTTOM_LEFT == _exp_0 then
      self._basepoint = Vec2(0, h - 1)
    elseif self.__class.BOTTOM_CENTER == _exp_0 then
      self._basepoint = Vec2(round((w - 1) / 2), h - 1)
    elseif self.__class.BOTTOM_RIGHT == _exp_0 then
      self._basepoint = Vec2(w - 1, h - 1)
    end
    self._basepoint = self._basepoint - Vec2(basepoint_xshift, -basepoint_yshift)
    self._current_frame = 1
    self._playing = false
  end,
  start = function(self, start_frame, play_once)
    if start_frame == nil then
      start_frame = 1
    end
    if play_once == nil then
      play_once = false
    end
    self._play_once = play_once
    if start_frame > self._num_frames then
      start_frame = math.fmod(start_frame - 1, self._num_frames) + 1
    end
    self._current_frame = start_frame
    self._playing = true
    self._t = 0
  end,
  stop = function(self, go_to_frame)
    self._playing = false
    if go_to_frame then
      self._current_frame = go_to_frame
    end
  end,
  set_visibility = function(self, layer_name, value)
    local layer = self._layers[self._layer_idxs[layer_name]]
    layer.visible = value
    if value then
      local _list_0 = (layer.group or { })
      for _index_0 = 1, #_list_0 do
        local name = _list_0[_index_0]
        if name ~= layer_name then
          self._layers[self._layer_idxs[name]].visible = false
        end
      end
    end
  end,
  toggle_visibility = function(self, layer_name)
    local value = self._layers[self._layer_idxs[layer_name]].visible
    return self:set_visibility(layer_name, not value)
  end,
  draw = function(self, x, y, angle, sx, sy)
    if sx == nil then
      sx = 1
    end
    if sy == nil then
      sy = 1
    end
    local _exp_0 = self._flipped
    if self.__class.FLIP_HORIZONTAL == _exp_0 then
      sx = -sx
    elseif self.__class.FLIP_VERTICAL == _exp_0 then
      sy = -sy
    elseif self.__class.FLIP_BOTH == _exp_0 then
      sx, sy = -sx, -sy
    end
    local i = self._current_frame
    local _list_0 = self._layers
    for _index_0 = 1, #_list_0 do
      local layer = _list_0[_index_0]
      if layer.visible then
        local o
        do
          local offsets = layer.offsets[i]
          if offsets then
            o = self._basepoint + offsets
          else
            o = self._basepoint
          end
        end
        local frame = layer.frames[i]
        if frame then
          frame:draw(x, y, angle, sx, sy, o:unpack())
        end
      end
    end
  end,
  update = function(self, dt)
    if self._playing then
      self._t = self._t + (dt * self._fps)
      if self._t >= self._num_frames and self._play_once then
        self._playing = false
        self._current_frame = self._num_frames
        return M.signals.emit(self, "finished")
      else
        self._t = math.fmod(self._t, self._num_frames)
        self._current_frame = math.floor(self._t) + 1
      end
    end
  end,
  copy_flipped = function(self, flip_direction)
    local animation
    do
      local _tbl_0 = { }
      for k, v in pairs(self) do
        _tbl_0[k] = v
      end
      animation = _tbl_0
    end
    animation._flipped = flip_direction
    return setmetatable(animation, getmetatable(self))
  end
})
Animation.TOP_LEFT = 1
Animation.TOP_CENTER = 2
Animation.TOP_RIGHT = 3
Animation.MIDDLE_LEFT = 4
Animation.MIDDLE_CENTER = 5
Animation.MIDDLE_RIGHT = 6
Animation.BOTTOM_LEFT = 7
Animation.BOTTOM_CENTER = 8
Animation.BOTTOM_RIGHT = 9
Animation.FLIP_HORIZONTAL = 1
Animation.FLIP_VERTICAL = 2
Animation.FLIP_BOTH = 3
Animation.open_reel = function(filename, external)
  local t
  if external then
    t = loadfile(filename)()
  else
    t = love.filesystem.load(filename)()
  end
  local directory = filename:gsub("[^/]*$", "")
  local atlas
  if t.atlas then
    atlas = Atlas(simplify_path(directory .. t.atlas))
  end
  local basepoint_position = t.basepoint_position and Animation[t.basepoint_position]
  local _tbl_0 = { }
  local _list_0 = t.animations
  for _index_0 = 1, #_list_0 do
    local a = _list_0[_index_0]
    _tbl_0[a.name] = Animation(atlas, a.layers, a.fps, basepoint_position, t.basepoint_xshift, t.basepoint_yshift)
  end
  return _tbl_0
end
M.Animation = Animation
