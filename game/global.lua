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

    flags = {},
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
    local json_data = json.encode(save_data)
    love.filesystem.write(M.savepath, json_data)
    print(json_data)
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

M.saveGameExists = function()
    local file = love.filesystem.getInfo(M.gamesavepath)
    if not file then return false end
    return true
end

M.saveGame = function()
    local _room = "present"
    -- room object doesn't have a name attribute, so we're forced to do this
    if M.room == g.rooms.present then
        _room = "present"
    end
    if M.room == g.rooms.collector then
        _room = "collector"
    end
    if M.room == g.rooms.future then
        _room = "future"
    end
    if M.room == g.rooms.past then
        _room = "past"
    end
    local save_data = {
        flags = M.flags,
        bag = M.bag,
        room = _room,
        ines_position_x = g.characters.ines._position.x,
        ines_position_y = g.characters.ines._position.y,
    }
    local json_data = json.encode(save_data)
    love.filesystem.write(M.gamesavepath, json_data)
    print(json_data)
    print("saving video game")
end

M.loadGame = function()
    if not M:saveGameExists() then return end

    -- Load the save data
    local data = love.filesystem.read(M.gamesavepath)
    print(data)
    local save_data = json.decode(data)

    if save_data.flags then
        M.flags = save_data.flags
    end
    if save_data.bag then
        local inventory = require("inventory")
        for i, item in ipairs(save_data.bag) do
            inventory:add(item)
        end
    end
    if save_data.ines_position_x and save_data.ines_position_y then
        g.characters.ines:set_position(save_data.ines_position_x, save_data.ines_position_y)
    end
    if save_data.room then
        local _room = nil
        -- room object doesn't have a name attribute, so we're forced to do this
        if save_data.room == "present" then
            _room = g.rooms.present
        end
        if save_data.room == "collector" then
            _room = g.rooms.collector
        end
        if save_data.room == "future" then
            _room = g.rooms.future
        end
        if save_data.room == "past" then
            _room = g.rooms.past
        end
        -- this is ripped out of "dialogues.navigator" without the animation. Stuff of nightmares but you know how it is.
        local audio = require("audio")
        audio.stop_music()
        audio.start_music()
        audio.switch_room(_room)
        require("engine").game.set_room(_room)
        g.characters.ines:change_room(_room, g.characters.ines._position:unpack())
        g.room = _room
    end
    print("loading video game")
end

M.wipeGame = function()
    if not M:saveGameExists() then return end

    love.filesystem.remove(M.gamesavepath)
    print("wiping video game")
end

return M