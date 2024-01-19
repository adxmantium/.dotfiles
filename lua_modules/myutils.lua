local io = require("io")

local util = {}

util.exec = function(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	return result
end

util.trim = function(str)
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

return util
