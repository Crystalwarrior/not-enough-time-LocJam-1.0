path = (...)\gsub("[^%.]*$", "")
M = require(path .. 'main')
import Set from M.steelpan

debug = {}
M.debug = debug

flags = Set {
        'navigation'
    }

debug.enable = (flag) ->
    if flags\contains(flag)
        debug[flag] = true
    elseif flag == 'all'
        debug[f] = true for f in flags\iterator()


debug.disable = (flag) ->
    if flags\contains(flag)
        debug[flag] = nil
    elseif flag == 'all'
        debug[f] = nil for f in flags\iterator()

debug.printf = (s, ...) -> print(s\format(...))
