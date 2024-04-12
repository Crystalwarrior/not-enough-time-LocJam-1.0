g = require "global"
lc = require "engine"

g.volume = 0.5

M = {}

if love.system.getOS() ~= "Web"
    fmod = require "fmodstudio"

    if fmod
        system = fmod.Studio.System.create()
        system\initialize(50, g.debug and fmod.FMOD_STUDIO_INIT_LIVEUPDATE or fmod.FMOD_STUDIO_INIT_NORMAL, fmod.FMOD_INIT_NORMAL)
        system\loadBankFile(g.base_dir .. "/audio/Master.bank", fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
        system\loadBankFile(g.base_dir .. "/audio/Master.strings.bank", fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)

        local music_instance

        M.get_system = ->
            return system

        M.set_volume = (v) ->
            g.volume = v
            if i = music_instance
                i\setVolume(v)

        M.start_music = ->
            music_instance = system\getEvent("event:/music")\createInstance()
            music_instance\start()
            music_instance\release()
            music_instance\setVolume(g.volume)
            return music_instance

        M.stop_music = ->
            if music_instance
                music_instance\stop(fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
            music_instance = nil

        M.set_parameter = (name, value) ->
            if music_instance
                music_instance\setParameterByName(name, value, 0)
                system\flushCommands()

        M.start_oneshot = (name) ->
            if music_instance
                music_instance\setParameterByName(name, 1, 0)
                system\flushCommands()

        M.restart_music = ->
            if music_instance
                pos = music_instance\getTimelinePosition()
                if pos > 66000
                    music_instance\setTimelinePosition(0)

        M.update = ->
            system\update()

        M.quit = ->
            system\release()

    else

        do_nothing = ->
        M.get_system = do_nothing
        M.set_volume = do_nothing
        M.start_music = do_nothing
        M.stop_music = do_nothing
        M.set_parameter = do_nothing
        M.start_oneshot = do_nothing
        M.restart_music = do_nothing
        M.update = do_nothing
        M.quit = do_nothing

else
    js = require("love.js")
    M.get_system = ->

    M.set_volume = (v) ->
        js.run(string.format("set_volume(%s);", v))
        g.volume = v


    M.start_ambient = (name, position) ->
        pos = string.format("[%f,%f]", position.x, position.y)
        js.run(string.format("start_ambient('%s', %s);", name, pos))

    M.stop_ambient = (name) ->

    M.start_music = ->
        js.run(string.format("start_music(%s);", g.volume))

    M.stop_music = ->
        js.run("stop_music();")

    M.set_parameter = (name, value) ->
        js.run(string.format("set_parameter('%s', %s);", name, value))

    M.start_oneshot = (name) ->
        js.run(string.format("start_oneshot('%s');", name))

    M.restart_music = ->
        js.run("restart_music();")

    M.update = ->

    M.quit = ->

M.switch_room = (room) ->
    local i
    switch room
        when g.rooms.present
            i = 2
        when g.rooms.past
            i = 0
        when g.rooms.collector
            i = 1
        when g.rooms.future
            i = 3
    M.set_parameter("room", i)

return M

