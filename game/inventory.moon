shake = require "shake"
lc = require "engine"
skip = require "skip"

objects = {}

new_object = (name, description) ->
    t =  {:name, :description}
    objects[name] = t
    return t

M = {}

M.bag = {}

navigator = new_object("navigator", (-> TEXT(114, "navigator")))
navigator.look_text = -> LOOK(115, "It's the temporal navigator that started this mess.")
navigator.interact = ->
    lc.dialogues\new(require "dialogues.navigator")

coin = new_object("coin", (-> TEXT(116, "coin")))
coin.look_text = -> LOOK(117, "I wonder if there's chocolate inside.")

device_new = new_object("device_new", (-> TEXT(118, "reality-fixing device™")))
device_new.look_text = -> LOOK(119, "WHO put it in that vase, and WHY?")

device_new2 = new_object("device_new2", (-> TEXT(120, "reality-fixing device™ (hopefully working)")))
device_new2.look_text = ->
    if not g.seen_president
        LOOK(121, "Fixed and ready to go.")
    else
        LOOK(122, "Of course it couldn't be that easy.")
device_new2.interact = ->
    ines = g.characters.ines
    president_ines = g.characters.president_ines
    g.blocking_thread ->
        skip\start()
        ines\walk_thread(100, 102)
        ines\face2("E")
        say ines, INES(123, "Let's see if this thing actually works.")
        wait 0.5
        shake\start()
        wait_signal(shake, "finished")
        president_ines\change_room(ines._room)
        president_ines\set_position(145, 102)
        president_ines\face2("W")
        say president_ines, PRESIDENT_INES(633, "Stop right there!")
        wait 1
        say ines, INES(124, "...what!?")
        say ines, INES(125, "Who are you?")
        say president_ines, PRESIDENT_INES(634, "Right.")
        say president_ines, PRESIDENT_INES(635, "Don't panic, I'm you from the future.")
        wait 0.5
        
        switch lc.game.room
            when g.rooms.future
                say g.characters.holeegram, HOLEEGRAM(388, "Hi Ines!")
            when g.rooms.past
                say g.characters.andrea, ANDREA(389, "Woah!")
        say ines, INES(126, "Holy sh--")
        say president_ines, PRESIDENT_INES(636, "No time for dilly-dallying.")
        say president_ines, PRESIDENT_INES(637, "I have important stuff to get back to.")
        say president_ines, PRESIDENT_INES(638, "I'm the PRESIDENT.")
        say ines, INES(127, "That's so co--")
        say president_ines, PRESIDENT_INES(639, "What did I just say?")
        say ines, INES(128, "Sorry ma'am.")
        say president_ines, PRESIDENT_INES(640, "I came here to stop you from destroying the space-time continuum.")
        say president_ines, PRESIDENT_INES(641, "Pressing that button right now would result in a temporal inconsistency error.")
        say president_ines, PRESIDENT_INES(642, "You'll need to resolve the inconsistency before using the device.")
        say ines, INES(129, "Can you tell me how?")
        say president_ines, PRESIDENT_INES(643, "I wish I could, but when I was (quite literally) in your shoes, future Ines didn't tell me how.")
        say president_ines, PRESIDENT_INES(644, "So telling you would create another inconsistency.")
        wait 1
        say ines, INES(130, "Damn.")
        say president_ines, PRESIDENT_INES(645, "That's what I said.")
        wait 0.5
        say president_ines, PRESIDENT_INES(646, "I'll leave you to it.")
        say president_ines, PRESIDENT_INES(647, "Duty calls.")
        if lc.game.room == g.rooms.future
            say g.characters.holeegram, HOLEEGRAM(390, "Bye Ines!")
        shake\start()
        wait_signal(shake, "finished")
        president_ines\set_position(-100, -100)
        g.seen_president = true
        device_new2.interact = nil
        skip\stop()






device_old = new_object("device_old", (-> TEXT(131, "reality-fixing device™ (broken)")))
device_old.look_text = -> LOOK(132, "Cheap uncle Lee stuff.")

pick = new_object("pick", (-> TEXT(133, "guitar pick")))
pick.look_text = -> LOOK(134, "Is that blood?")

recorder = new_object("recorder", (-> TEXT(135, "tape recorder")))
recorder.look_text = -> LOOK(136, "It already has a tape inside. How convenient.")

guitar = new_object("guitar", (-> TEXT(137, "electric guitar")))

cassette = new_object("cassette", (-> TEXT(138, "cassette tape")))
cassette.look_text = -> LOOK(139, "I wonder if this is legal.")

cassette_old = new_object("cassette_old", (-> TEXT(140, "aged cassette tape")))
cassette_old.look_text = -> LOOK(141, "I wonder if aging it improved it.")


pickup = new_object("pickup", (-> TEXT(142, "magnetic pickup")))
pickup.look_text = -> LOOK(143, "Getting this was quite satisfying.")

M.add = (name) =>
    @bag[#@bag + 1] = objects[name]
    g.start_thread ->
        obj = objects[name]
        obj.alpha = 1
        counter = 0
        while counter < 4
            accum = 0
            while accum < 0.3
                accum += wait_frame()
            obj.alpha = 1 - obj.alpha
            counter += 1

M.remove = (name) =>
    for i, obj in ipairs(@bag)
        if obj.name == name
            table.remove(@bag, i)
            return
        
M.has = (name) =>
    for i, obj in ipairs(@bag)
        if obj.name == name
            return true
    return false

return M