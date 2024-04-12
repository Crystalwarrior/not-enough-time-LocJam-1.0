lc = require "engine"

reel = lc.Animation.open_reel("assets/animations/andrea.reel")
andrea = lc.Character(reel)
andrea._spk.colour = {0.9, 1, 0.3}
andrea\face2("E")

andrea._spk.point = lc.steelpan.Vec2(131, 50)




return andrea