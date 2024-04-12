lc = require "engine"

M = {}

M.interval = 1/60

M.start = (@duration=1, @max_step=3) => 
    @t = 0
    @factor = 0
    @shaking = true
    @_randomize()

M._randomize = =>
    @dx = love.math.random(-@max_step, @max_step)
    @dy = love.math.random(-@max_step, @max_step)

M.stop = =>
    @shaking = false
    lc.signals.emit(self, "finished")

M.update = (dt) =>
    return unless @shaking
    @t += dt
    oldfactor = @factor
    @factor = math.floor(@t/@interval)
    if @factor > oldfactor
        @_randomize()
    if @t > @duration
        @stop()

M.push = =>
    return unless @shaking
    love.graphics.push()
    love.graphics.translate(@dx, @dy)

M.pop = =>
    return unless @shaking
    love.graphics.pop()

return M