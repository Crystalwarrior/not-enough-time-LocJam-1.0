local shake = require("shake")
local lc = require("engine")
local skip = require("skip")
local objects = { }
local new_object
new_object = function(name, description)
  local t = {
    name = name,
    description = description
  }
  objects[name] = t
  return t
end
local M = { }
M.bag = { }
local navigator = new_object("navigator", (function()
  return TEXT(114, "navigator")
end))
navigator.look_text = function()
  return LOOK(115, "It's the temporal navigator that started this mess.")
end
navigator.interact = function()
  return lc.dialogues:new(require("dialogues.navigator"))
end
local coin = new_object("coin", (function()
  return TEXT(116, "coin")
end))
coin.look_text = function()
  return LOOK(117, "I wonder if there's chocolate inside.")
end
local device_new = new_object("device_new", (function()
  return TEXT(118, "reality-fixing device™")
end))
device_new.look_text = function()
  return LOOK(119, "WHO put it in that vase, and WHY?")
end
local device_new2 = new_object("device_new2", (function()
  return TEXT(120, "reality-fixing device™ (hopefully working)")
end))
device_new2.look_text = function()
  if not g.seen_president then
    return LOOK(121, "Fixed and ready to go.")
  else
    return LOOK(122, "Of course it couldn't be that easy.")
  end
end
device_new2.interact = function()
  local ines = g.characters.ines
  local president_ines = g.characters.president_ines
  return g.blocking_thread(function()
    skip:start()
    ines:walk_thread(100, 102)
    ines:face2("E")
    say(ines, INES(123, "Let's see if this thing actually works."))
    wait(0.5)
    shake:start()
    wait_signal(shake, "finished")
    president_ines:change_room(ines._room)
    president_ines:set_position(145, 102)
    president_ines:face2("W")
    say(president_ines, PRESIDENT_INES(633, "Stop right there!"))
    wait(1)
    say(ines, INES(124, "...what!?"))
    say(ines, INES(125, "Who are you?"))
    say(president_ines, PRESIDENT_INES(634, "Right."))
    say(president_ines, PRESIDENT_INES(635, "Don't panic, I'm you from the future."))
    wait(0.5)
    local _exp_0 = lc.game.room
    if g.rooms.future == _exp_0 then
      say(g.characters.holeegram, HOLEEGRAM(388, "Hi Ines!"))
    elseif g.rooms.past == _exp_0 then
      say(g.characters.andrea, ANDREA(389, "Woah!"))
    end
    say(ines, INES(126, "Holy sh--"))
    say(president_ines, PRESIDENT_INES(636, "No time for dilly-dallying."))
    say(president_ines, PRESIDENT_INES(637, "I have important stuff to get back to."))
    say(president_ines, PRESIDENT_INES(638, "I'm the PRESIDENT."))
    say(ines, INES(127, "That's so co--"))
    say(president_ines, PRESIDENT_INES(639, "What did I just say?"))
    say(ines, INES(128, "Sorry ma'am."))
    say(president_ines, PRESIDENT_INES(640, "I came here to stop you from destroying the space-time continuum."))
    say(president_ines, PRESIDENT_INES(641, "Pressing that button right now would result in a temporal inconsistency error."))
    say(president_ines, PRESIDENT_INES(642, "You'll need to resolve the inconsistency before using the device."))
    say(ines, INES(129, "Can you tell me how?"))
    say(president_ines, PRESIDENT_INES(643, "I wish I could, but when I was (quite literally) in your shoes, future Ines didn't tell me how."))
    say(president_ines, PRESIDENT_INES(644, "So telling you would create another inconsistency."))
    wait(1)
    say(ines, INES(130, "Damn."))
    say(president_ines, PRESIDENT_INES(645, "That's what I said."))
    wait(0.5)
    say(president_ines, PRESIDENT_INES(646, "I'll leave you to it."))
    say(president_ines, PRESIDENT_INES(647, "Duty calls."))
    if lc.game.room == g.rooms.future then
      say(g.characters.holeegram, HOLEEGRAM(390, "Bye Ines!"))
    end
    shake:start()
    wait_signal(shake, "finished")
    president_ines:set_position(-100, -100)
    g.seen_president = true
    device_new2.interact = nil
    return skip:stop()
  end)
end
local device_old = new_object("device_old", (function()
  return TEXT(131, "reality-fixing device™ (broken)")
end))
device_old.look_text = function()
  return LOOK(132, "Cheap uncle Lee stuff.")
end
local pick = new_object("pick", (function()
  return TEXT(133, "guitar pick")
end))
pick.look_text = function()
  return LOOK(134, "Is that blood?")
end
local recorder = new_object("recorder", (function()
  return TEXT(135, "tape recorder")
end))
recorder.look_text = function()
  return LOOK(136, "It already has a tape inside. How convenient.")
end
local guitar = new_object("guitar", (function()
  return TEXT(137, "electric guitar")
end))
local cassette = new_object("cassette", (function()
  return TEXT(138, "cassette tape")
end))
cassette.look_text = function()
  return LOOK(139, "I wonder if this is legal.")
end
local cassette_old = new_object("cassette_old", (function()
  return TEXT(140, "aged cassette tape")
end))
cassette_old.look_text = function()
  return LOOK(141, "I wonder if aging it improved it.")
end
local pickup = new_object("pickup", (function()
  return TEXT(142, "magnetic pickup")
end))
pickup.look_text = function()
  return LOOK(143, "Getting this was quite satisfying.")
end
M.add = function(self, name)
  self.bag[#self.bag + 1] = objects[name]
  return g.start_thread(function()
    local obj = objects[name]
    obj.alpha = 1
    local counter = 0
    while counter < 4 do
      local accum = 0
      while accum < 0.3 do
        accum = accum + wait_frame()
      end
      obj.alpha = 1 - obj.alpha
      counter = counter + 1
    end
  end)
end
M.remove = function(self, name)
  for i, obj in ipairs(self.bag) do
    if obj.name == name then
      table.remove(self.bag, i)
      return 
    end
  end
end
M.has = function(self, name)
  for i, obj in ipairs(self.bag) do
    if obj.name == name then
      return true
    end
  end
  return false
end
return M
