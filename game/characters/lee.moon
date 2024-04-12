lc = require "engine"

reel = lc.Animation.open_reel("assets/animations/lee.reel")
lee = lc.Character(reel)
-- lee.height = 50
lee._spk.colour = {0.5, 0.9, 1}
lee\face2("E")

lee._spk.point = lc.steelpan.Vec2(177, 45)




return lee