local js = require "love.js"
local chunk = loadstring(js.runString("text_translated;"));
return chunk()
