lc = require "engine"

reel = lc.Animation.open_reel("assets/animations/president_ines.reel")
ines = lc.Character(reel)
ines\set_speed(50,25)
ines\set_position(140,102)
ines.height = 60
ines._spk.colour = {1, 0.7, 1}

return ines