local json = require("3rd.json")

local M = {
    hotspot = {},
    game_width = 240,
    game_height = 135,
    scale = 6,

    key = {
        skip = ".",
        cutscene = "space",
        pause = "escape",
    },
    skip_with_left = false,
    skip_with_right = false,
    debug = false,

    flags = {
        
    },
    bag = {},
    room = nil,
    savepath = "data.json"
}

M.saveOptions = function()
    local save_data = {
        skip_with_left = M.skip_with_left,
        skip_with_right = M.skip_with_right,
    }
    love.filesystem.write(M.savepath, json.encode(save_data))
    print("saving options")
end

M.loadOptions = function()
    local file = love.filesystem.getInfo(M.savepath)
    if not file then return end

    -- Load the save data
    local data = love.filesystem.read(M.savepath)
    print(data)
    local save_data = json.decode(data)
    M.skip_with_left = save_data.skip_with_left
    M.skip_with_right = save_data.skip_with_right
    print("loading options")
end
return M