global = require "global"

global.rooms = {
    present: require "rooms.present"
    collector: require "rooms.collector"
    future: require "rooms.future"
    past: require "rooms.past"
}