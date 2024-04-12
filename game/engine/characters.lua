local path = (...):gsub("[^%.]*$", "")
local M = require(path .. 'main')
local game, Animation
game, Animation = M.game, M.Animation
local Vec2, Class
do
  local _obj_0 = M.steelpan
  Vec2, Class = _obj_0.Vec2, _obj_0.Class
end
local round, sgn
do
  local _obj_0 = M.steelpan.utils.math
  round, sgn = _obj_0.round, _obj_0.sgn
end
local dot
dot = Vec2.dot
local abs, cos, sin
do
  local _obj_0 = math
  abs, cos, sin = _obj_0.abs, _obj_0.cos, _obj_0.sin
end
local standing_animations = {
  'W_stand',
  'E_stand',
  'N_stand',
  'S_stand',
  'NW_stand',
  'NE_stand',
  'SW_stand',
  'SE_stand'
}
local walking_animations = {
  'W_walk',
  'E_walk',
  'N_walk',
  'S_walk',
  'NW_walk',
  'NE_walk',
  'SW_walk',
  'SE_walk'
}
local talking_animations = {
  'W_talk',
  'E_talk',
  'N_talk',
  'S_talk',
  'NW_talk',
  'NE_talk',
  'SW_talk',
  'SE_talk'
}
local Character, update_bounding_box
Character = Class({
  __init = function(self, animations)
    self._position = Vec2()
    self._colour = {
      1,
      1,
      1,
      1
    }
    self._animations = animations
    self._animations.W_stand = animations.W_stand or animations.E_stand:copy_flipped(Animation.FLIP_HORIZONTAL)
    self._animations.W_walk = animations.W_walk or animations.E_walk:copy_flipped(Animation.FLIP_HORIZONTAL)
    self._animations.W_talk = animations.W_talk or animations.E_talk:copy_flipped(Animation.FLIP_HORIZONTAL)
    if animations.NE_stand and animations.SE_stand and animations.NE_walk and animations.SE_walk then
      self._diagonal_directions = true
      self._animations.NW_stand = animations.NW_stand or animations.NE_stand:copy_flipped(Animation.FLIP_HORIZONTAL)
      self._animations.SW_stand = animations.SW_stand or animations.SE_stand:copy_flipped(Animation.FLIP_HORIZONTAL)
      self._animations.NW_walk = animations.NW_walk or animations.NE_walk:copy_flipped(Animation.FLIP_HORIZONTAL)
      self._animations.SW_walk = animations.SW_walk or animations.SE_walk:copy_flipped(Animation.FLIP_HORIZONTAL)
    end
    do
      local _accum_0 = { }
      local _len_0 = 1
      for _index_0 = 1, #standing_animations do
        local k = standing_animations[_index_0]
        _accum_0[_len_0] = self._animations[k]
        _len_0 = _len_0 + 1
      end
      self._standing_animations = _accum_0
    end
    do
      local _accum_0 = { }
      local _len_0 = 1
      for _index_0 = 1, #walking_animations do
        local k = walking_animations[_index_0]
        _accum_0[_len_0] = self._animations[k]
        _len_0 = _len_0 + 1
      end
      self._walking_animations = _accum_0
    end
    do
      local _accum_0 = { }
      local _len_0 = 1
      for _index_0 = 1, #talking_animations do
        local k = talking_animations[_index_0]
        _accum_0[_len_0] = self._animations[k]
        _len_0 = _len_0 + 1
      end
      self._talking_animations = _accum_0
    end
    self._wlk = {
      moving = false,
      t = 0,
      speed = Vec2(1, 1),
      path = { },
      distances = { },
      piece = 1,
      prev_target = nil
    }
    self._spk = {
      colour = {
        1,
        1,
        1,
        1
      }
    }
    self._direction = self.__class.direction.S
    self:face(self._direction)
    self._animation = self._standing_animations[self._direction]
    self._scale = Vec2(1, 1)
    self.nav_scale = 1
    self._angle = 0
    self._cos = 1
    self._sin = 0
    return update_bounding_box(self)
  end,
  face_location = function(self, point)
    local v = point - self._position
    v.x = v.x * sgn(self._scale.x)
    v.y = v.y * sgn(self._scale.y)
    if v.x == 0 and v.y == 0 then
      return 
    end
    if self._angle ~= 0 then
      local X = self._cos * v.x + self._sin * v.y
      local Y = self._cos * v.y - self._sin * v.x
      v.x, v.y = X, Y
    end
    local tan = v.y / v.x
    local a = self._diagonal_directions and 0.41421356 or 1
    local b = self._diagonal_directions and 1.41421356 or 1
    if tan >= -a and tan <= a then
      self._direction = v.x > 0 and self.__class.direction.E or self.__class.direction.W
    elseif tan > a and tan < b then
      self._direction = v.x > 0 and self.__class.direction.SE or self.__class.direction.NW
    elseif tan > -b and tan < -a then
      self._direction = v.x > 0 and self.__class.direction.NE or self.__class.direction.SW
    else
      self._direction = v.y > 0 and self.__class.direction.S or self.__class.direction.N
    end
  end,
  face = function(self, _direction)
    self._direction = _direction
  end,
  face2 = function(self, direction)
    self._direction = M.Character.direction[direction]
    self._animation = self._standing_animations[self._direction]
  end,
  face2point = function(self, point)
    self:face_location(point)
    self._animation = self._standing_animations[self._direction]
  end,
  walk = function(self, x, y)
    if not (game.room) then
      return 
    end
    local target = Vec2(x, y)
    if not (self._wlk.prev_target and self._wlk.prev_target == target) then
      self._wlk.prev_target = target
      path = game.room._navigation:shortest_path(self._position, target)
      do
        local _accum_0 = { }
        local _len_0 = 1
        for i = 1, #path - 1 do
          _accum_0[_len_0] = (path[i + 1] - path[i]):len()
          _len_0 = _len_0 + 1
        end
        self._wlk.distances = _accum_0
      end
      self._wlk.path = path
      if #path < 2 then
        return false
      end
      self._wlk.t = 0
      self._wlk.piece = 1
      self._wlk.moving = true
      local old_direction = self._direction
      self:face_location(path[2])
      if not self._animation._playing or self._direction ~= old_direction then
        local start_frame = 1
        if self._animation._playing then
          self._animation:stop()
          start_frame = self._animation._current_frame
        end
        self._animation = self._walking_animations[self._direction]
        self._animation:start(start_frame)
      end
      return true
    end
    return false
  end,
  stop_walking = function(self)
    if self._wlk.moving then
      self._wlk.moving = false
      self._animation:stop()
      self._animation = self._standing_animations[self._direction]
      return M.signals.emit(self, 'finished walking')
    end
  end,
  update = function(self, dt)
    self._animation:update(dt)
    if self._wlk.moving then
      local idx = self._wlk.piece
      local A, B = self._wlk.path[idx], self._wlk.path[idx + 1]
      if not (A and B) then
        self:stop_walking()
        return 
      end
      local v = B - A
      local speed = self.nav_scale * (self._wlk.speed.x * abs(v.x) + self._wlk.speed.y * abs(v.y)) / v:lenS()
      self._wlk.t = self._wlk.t + (dt * speed)
      if self._wlk.t > 1 then
        self._wlk.t = 1
      end
      local factor = self._wlk.t
      self._position = A * (1 - factor) + B * factor
      self.nav_scale = game.room._navigation:get_scale(self._position)
      if factor == 1 then
        if idx < #self._wlk.distances then
          self._wlk.piece = idx + 1
          self._wlk.t = 0
          local old_direction = self._direction
          self:face_location(self._wlk.path[self._wlk.piece + 1])
          if self._direction ~= old_direction then
            local start_frame = self._animation._current_frame
            self._animation:stop()
            self._animation = self._walking_animations[self._direction]
            return self._animation:start(start_frame)
          end
        else
          return self:stop_walking()
        end
      end
    end
  end,
  draw = function(self)
    if self.hidden then
      return 
    end
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
    local room_scale = game.room_scale()
    local position = round(self._position * room_scale)
    local scale = self.nav_scale * self._scale * room_scale
    self._animation:draw(position.x, position.y, self._angle, scale.x, scale.y)
    if self._colour then
      love.graphics.setColor(oldcolour)
    end
    if self._shader then
      return love.graphics.setShader(oldshader)
    end
  end,
  set_angle = function(self, radians)
    self._angle = radians
    self._cos = cos(radians)
    self._sin = sin(radians)
    return update_bounding_box(self)
  end,
  set_scale = function(self, xscale, yscale)
    if yscale == nil then
      yscale = xscale
    end
    self._scale = Vec2(xscale, yscale)
    return update_bounding_box(self)
  end,
  change_room = function(self, room, x, y, direction)
    if x == nil then
      x = 0
    end
    if y == nil then
      y = 0
    end
    if direction == nil then
      direction = self._direction
    end
    do
      local oldroom = self._room
      if oldroom then
        oldroom.characters[self] = nil
      end
    end
    self._room = room
    if room then
      room.characters[self] = true
      self._position.x, self._position.y = x, y
      self.nav_scale = room._navigation:get_scale(self._position)
      self._direction = direction
    end
  end,
  set_position = function(self, x, y)
    self._position.x = x
    self._position.y = y
  end,
  set_speed = function(self, x, y)
    self._wlk.speed.x = x
    self._wlk.speed.y = y
  end,
  set_colour = function(self, ...)
    do
      local t = select(1, ...)
      if t then
        if type(t) == "table" then
          self._colour = t
        else
          do
            local _accum_0 = { }
            local _len_0 = 1
            for i = 1, 4 do
              _accum_0[_len_0] = select(i, ...) or 1
              _len_0 = _len_0 + 1
            end
            self._colour = _accum_0
          end
        end
      else
        self._colour = nil
      end
    end
  end,
  set_shader = function(self, shader)
    self._shader = shader
  end,
  start_animation = function(self, name, play_once)
    if play_once == nil then
      play_once = false
    end
    self._animation = self._animations[name]
    self._animation:start(1, play_once)
    return self._animation
  end,
  start_animation_thread = function(self, name)
    local g = require("global")
    setfenv(1, g.thread_registry:get_thread_environment())
    self:start_animation(name, true)
    return wait_signal(self._animation, "finished")
  end,
  walk_thread = function(self, x, y)
    local g = require("global")
    setfenv(1, g.thread_registry:get_thread_environment())
    if self:walk(x, y) then
      return wait_signal(self, "finished walking")
    end
  end
})
Character.direction = {
  W = 1,
  E = 2,
  N = 3,
  S = 4,
  NW = 5,
  NE = 6,
  SW = 7,
  SE = 8
}
M.Character = Character
update_bounding_box = function(t) end
