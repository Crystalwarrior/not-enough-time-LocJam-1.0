lc = require "engine"

reel = lc.Animation.open_reel("assets/animations/peppe.reel")
peppe = lc.Character(reel)
peppe._spk.colour = {0.3, 1, 0.3}
peppe\face2("E")

peppe._spk.point = lc.steelpan.Vec2(67, 50)




return peppe