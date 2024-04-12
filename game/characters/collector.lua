local lc = require("engine")
local reel = lc.Animation.open_reel("assets/animations/collector.reel")
local collector = lc.Character(reel)
collector._animations.W_distracted = reel.E_distracted:copy_flipped(lc.Animation.FLIP_HORIZONTAL)
collector._spk.colour = {
  1,
  0.3,
  0.3
}
collector:face2("N")
collector._spk.point = lc.steelpan.Vec2(94, 38)
collector:set_position(94, 0)
return collector
