path = (...)\gsub(".init$", "") .. '.'

M = require(path .. 'main')

steelpan = {
    "class": "Class"
    "vectors": "Vec2"
    "atlas": "Atlas"
    "geometry": "geometry"
    "camera": "Camera"
    "cyclic": "CyclicList"
    "sets": "Set"
    "matrices": "matrices"
    "utils": "utils"
}

M.steelpan = {k, require(path .. "steelpan." .. m) for m, k in pairs(steelpan)}

modules = {
    'game'
    'animations'
    'characters'
    -- 'settings'
    'threads'
    'dialogue'
    -- 'debug'
    'navigation'
    'rooms'
    'mods'
}

for m in *modules do require(path .. m)

return M
