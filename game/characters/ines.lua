local lc = require("engine")
local reel = lc.Animation.open_reel("assets/animations/ines.reel")
local ines = lc.Character(reel)
ines._animations.W_pick_high = reel.E_pick_high:copy_flipped(lc.Animation.FLIP_HORIZONTAL)
ines._animations.W_pick_low = reel.E_pick_low:copy_flipped(lc.Animation.FLIP_HORIZONTAL)
ines:set_speed(50, 25)
ines.height = 60
ines._spk.colour = {
  0.9,
  0.5,
  1
}
return ines
