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
    savepath = "data.json",
    gamesavepath = "save.json"
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

M.saveGame = function()
    local save_data = {
        bag = M.bag,
        room = M.room,
        ines_position_x = g.characters.ines._position.x,
        ines_position_y = g.characters.ines._position.y,
    }
    love.filesystem.write(M.gamesavepath, json.encode(save_data))
    print("saving video game")
end

M.loadGame = function()
    local file = love.filesystem.getInfo(M.gamesavepath)
    if not file then return end

    -- Load the save data
    local data = love.filesystem.read(M.gamesavepath)
    print(data)
    local save_data = json.decode(data)

    if save_data.bag then
        M.bag = save_data.bag
    end
    if save_data.ines_position_x and save_data.ines_position_y then
        -- g.characters.ines.set_position(save_data.ines_position_x, save_data.ines_position_y)
    end
    if save_data.room then
        g.switch_room(save_data.room)
    end
    print("loading video game")
end

return M