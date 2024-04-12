local lc = require("engine")
local reel = lc.Animation.open_reel("assets/animations/lee.reel")
local lee = lc.Character(reel)
lee._spk.colour = {
  0.5,
  0.9,
  1
}
lee:face2("E")
lee._spk.point = lc.steelpan.Vec2(177, 45)
return lee
