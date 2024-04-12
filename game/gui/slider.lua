local Inky = require("3rd.inky")
require("ui")
local atlas = g.interface_atlas
local M = { }
M.new = Inky.defineElement(function(self)
  local set_progress
  set_progress = function(pointer_x)
    local x, _, w
    x, _, w, _ = self:getView()
    local progress = ((pointer_x - x) / w)
    progress = math.max(progress, 0)
    progress = math.min(progress, 1)
    self.props.progress = progress
    return self.props.callback(progress)
  end
  self:onPointer("press", function(_, pointer)
    pointer:captureElement(self)
    return set_progress(pointer:getPosition())
  end)
  self:onPointer("release", function(_, pointer)
    return pointer:captureElement(self, false)
  end)
  self:onPointer("drag", function(_, pointer)
    return set_progress(pointer:getPosition())
  end)
  self:onPointerExit(function(_, pointer) end)
  return function(self, x, y, w, h)
    local text = type(self.props.text) == "function" and self.props.text() or self.props.text
    atlas.slider_side:draw(x, y)
    atlas.slider_side:draw(x + w - 1, y)
    local progress_w = (w - 2) * self.props.progress
    atlas.slider1:draw(x + 1, y, 0, progress_w, 1)
    atlas.slider2:draw(x + 1 + progress_w, y, 0, w - 2 - progress_w, 1)
    return atlas.slider_marker:draw(x - 2 + progress_w, y)
  end
end)
M.height = atlas.slider1.size.y
M.yoffset = 0.5 * (g.font:getHeight() - M.height)
return M
