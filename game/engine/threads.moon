path = (...)\gsub("[^%.]*$", "")
M = require(path .. 'main')
import signals from M
import Class, Set from M.steelpan
xtype = M.steelpan.utils.type

-- use setfenv from compat-env if using Lua 5.2 or newer
import setfenv from require(path .. "third-party.compat_env")

status, mod = pcall(require, "love")
love = status and mod or nil

-- Thread

local current_thread
thread_env = setmetatable({}, {__index:_G})

Thread = Class {
    __init: (f) =>
        env = setmetatable({}, {__index:thread_env})
        setfenv(f, env)
        @_thread = coroutine.create(f)
        @_env = env

    update: (dt=0, ...) =>
        return if @_dead
        old_thread = current_thread
        current_thread = self
        assert(coroutine.resume(@_thread, dt, ...))
        @_dead = coroutine.status(@_thread) == "dead"
        current_thread = old_thread

    stop: => @_dead = true

    resume: => @update()

    extend_environment: (t) =>
        if t
            for k, v in pairs(t)
                @_env[k] = v
        return @_env
}
M._Thread = Thread

M.ThreadRegistry = Class {
    __init: =>
        @threads = {}

    new: (f) =>
        t = Thread(f)
        @threads[t] = true
        return t

    start: (f) =>
        t = @new(f)
        t\resume()
        return t

    update: (dt) =>
        for t in pairs(@threads)
            if t._dead
                @threads[t] = nil
                signals.emit(t, "finished")
            else
                t\update(dt)
    
    get_thread_environment: =>
        return thread_env
}

M.extend_global_thread_environment = (t) ->
    for k, v in pairs(t)
        thread_env[k] = v

M.inside_coroutine = -> return not not current_thread


-- signals

signals = {}
M.signals = signals
signals_table = setmetatable({}, {__mode:"k"})

signals.connect = (object, name, f) ->
    signals_table[object] = signals_table[object] or {names:{}, n:0}
    t = signals_table[object]
    if not t.names[name]
        t.names[name] = Set()
        t.n += 1
    t.names[name]\add(f)

signals.disconnect = (object, name, f) ->
    t = signals_table[object]
    if s = t and t.names[name]
        s\remove(f)
        if s\size() == 0
            t.names[name] = nil
            t.n -= 1
            if t.n == 0
                signals_table[object] = nil


signals.emit = (object, name, ...) ->
    t = signals_table[object]
    if s = t and t.names[name]
        for f in s\iterator()
            if type(f) == 'function'
                f(...)
            elseif xtype(f) == Thread
                f\update(0, object, name)

-- thread global functions

thread_env.wait = (t) ->
    if current_thread
        while t > 0
        	t = t - coroutine.yield()

thread_env.wait_random = (tmin, tmax) ->
    t = tmin + (tmax - tmin)*love.math.random()
	thread_env.wait(t)
    return t

thread_env.wait_signal = (...) ->
    -- input is of the form object1, name1, object2, name2, ...
    n = select("#", ...)
    assert(n%2 == 0, "Number of arguments should be even.")
    if t = current_thread
        for i = 1, n, 2
            object, name = select(i, ...)
            signals.connect(object, name, t)
        while true
            _, object, name = coroutine.yield()
            outer_break = false
            for i = 1, n, 2
                object_i, name_i = select(i, ...)
                if object_i == object and name_i == name
                    outer_break = true
                    break
            break if outer_break
        for i = 1, n, 2
            object, name = select(i, ...)
            signals.disconnect(object, name, t)

thread_env.wait_frame = ->
    return coroutine.yield()
