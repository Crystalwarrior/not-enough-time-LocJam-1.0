path = (...)\gsub("[^%.]*$", "")
M = require(path .. 'main')

status, mod = pcall(require, "love")
love = status and mod or nil

SettingsCategory = M.class {
	__init: (tbl) =>
	    self.__default = tbl
	    self.__current = {}

	set: (tbl) => self.__current[k] = v for k, v in pairs(tbl)

	__index: (t, key) -> t.__current[key] or t.__default[key]
}

settings = {}
M.settings = settings

-- speaking settings
speaking = {
	font: love and love.graphics.getFont()
	max_lines: 3
	max_width_ratio: 0.5
	xpadding: 4
	ypadding: 2
	distance_from_character: 10
}
settings.speaking = SettingsCategory(speaking)

-- debug settings
debug = {
	print: false
}
settings.debug = SettingsCategory(debug)





