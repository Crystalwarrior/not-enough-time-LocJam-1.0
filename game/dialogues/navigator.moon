g = require "global"
audio = require "audio"
import ines, lee from g.characters
tunnel = require "tunnel"
road = require "road"
vortex = require "vortex"
inventory = require "inventory"
ui_inventory = require "ui.inventory"
shake = require "shake"
lc = require "engine"

switch_room = (room, f) ->
    t =  g.blocking_thread ->
        ui_inventory.hidden = true
        audio.switch_room(room)
        shake\start()
        wait_signal(shake, "finished")
        lc.game.set_room(room)
        ines\change_room(room, ines._position\unpack())
        ui_inventory.hidden = false
        f() if f
    return t

g.switch_room = switch_room

return {

    main: ->          
        if lc.game.room ~= g.rooms.past
            option NOECHO(306, "Sixties."), sixties
        if lc.game.room ~= g.rooms.collector
            option NOECHO(307, "Nineties."), nineties
        if lc.game.room ~= g.rooms.present
            option NOECHO(308, "Present."), present
        if lc.game.room ~= g.rooms.future
            option NOECHO(309, "THE FUTURE."), future
        option NOECHO(310, "Stay here."), exit
        selection()

    sixties: ->
        switch_room(g.rooms.past, ->
            if not g.visited_past
                g.visited_past = true
                ui_inventory.hidden = true
                wait 0.5
                wilson = g.rooms.past._objects.wilson
                ines\walk_thread(wilson.interact_position\unpack())
                ines\face2(wilson.interact_direction)
                wait 2
                wilson.interact()
                ui_inventory.hidden = false
        )
       
        exit()
    
    nineties: ->
        switch_room(g.rooms.collector, ->
            if not g.collector_distracted
                g.characters.collector\face2("N")
            g.collector_looking = false
            if not g.visited_collector
                g.collector_looking = true
                g.visited_collector = true
                ui_inventory.hidden = true
                g.collector_looking = true
                wait 0.5
                collector = g.rooms.collector._objects.collector
                ines\walk_thread(collector.interact_position\unpack())
                ines\face2(collector.interact_direction)
                wait 0.5
                collector.interact()
                ui_inventory.hidden = false

            recorder = g.rooms.collector._objects.recorder
            if not g.at_recorder_spot and ines._position == recorder.interact_position
                ines._position.x += 4
                ines._wlk.prev_target = nil

        )
        exit()
    
    present: ->
        switch_room(g.rooms.present)
        exit()

    future: ->
        switch_room(g.rooms.future)
        exit()
        
}