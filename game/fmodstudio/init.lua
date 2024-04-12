local path = (...):gsub(".init$", "") .. "."

local status, ffi = pcall(require, "ffi")
if not status then
    return false
end

require(path .. "cdef")

local M = require(path .. "master")


-- search for fmod shared libraries in package.cpath
local paths = {
    fmod = package.searchpath(jit.os == "Windows" and "fmod" or "libfmod", package.cpath),
    fmodstudio = package.searchpath(jit.os == "Windows" and "fmodstudio" or "libfmodstudio", package.cpath)
}
if not (paths.fmod and paths.fmodstudio) then
    return false
end

-- pretend to load libfmod through Lua (it's going to fail but not raise any errors)
-- so that its location is known when loading libfmodstudio through ffi
package.loadlib(paths.fmod, "")
M.C = ffi.load(paths.fmodstudio)

require(path .. "enums")
require(path .. "constants")
require(path .. "wrap")
require(path .. "errors")

return M
