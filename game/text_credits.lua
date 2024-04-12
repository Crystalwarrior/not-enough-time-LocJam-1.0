local js = require "love.js"
local chunk = loadstring(js.runString("text_credits;"));
return chunk()
