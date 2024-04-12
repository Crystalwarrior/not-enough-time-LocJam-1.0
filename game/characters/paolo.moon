lc = require "engine"

reel = lc.Animation.open_reel("assets/animations/paolo.reel")
paolo = lc.Character(reel)
paolo._spk.colour = {1, 0.3, 0.3}
paolo\face2("E")

paolo._spk.point = lc.steelpan.Vec2(106, 53)




return paolo