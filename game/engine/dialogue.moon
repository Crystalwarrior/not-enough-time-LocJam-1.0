path = (...)\gsub("[^%.]*$", "")
M = require(path .. 'main')

import Class from M.steelpan
import _Thread from M

-- use setfenv from compat-env if using Lua 5.2 or newer
import setfenv from require(path .. "third-party.compat_env")

-- say = (character, text) ->
--     print(character, text)
--     -- wait(2)


dialogues = {}

dialogues._clear = =>
    @_thread = nil
    @_env = nil

dialogues.new = (t) =>
    assert(not @_current_dialogue, "A dialogue is already running.")
    thread = _Thread(->
        main()
        exit()
    )
    env = thread._env
    env.say = say
    env.exit = ->
        @_clear()
        coroutine.yield()
        love.mousemoved(love.mouse.getPosition())

    env._choices = {}

    env.option = (text, f) ->
        table.insert(env._choices, {:text, :f, text_sub: text\gsub("\n", "")})

    env.selection = ->
        while #env._choices > 0
            coroutine.yield()
        if f = env._selection and env._selection.f
            f()

    env.echo = (character) ->
        if text = env._selection and env._selection.text
            env.say(character, text)
    
    for k, v in pairs(t)
        env[k] = env[k] or v
        if type(v) == "function"
            setfenv(v, env)
    
    thread\resume()
    @_thread = thread
    @_env = env

dialogues.update = (dt) =>
    if t = @_thread
        t\update(dt)

dialogues.get_choices = =>
    if #@_env._choices > 0
        @_env._choices.out = @_env._choices.out or [{text: c.text, text_sub: c.text_sub} for c in *@_env._choices]
        return @_env._choices.out

dialogues.select = (i) =>
    if c = assert(@_env._choices[i], "Invalid choice.")
        @_env._choices = {}
        assert(type(c.f) == "function", "Invalid function for this choice.")
        @_env._selection = c
        @_thread\resume()

dialogues.is_running = => return not not @_thread

M.dialogues = dialogues