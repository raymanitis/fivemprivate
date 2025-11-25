local LEVEL_PREFIXES = {
	"^1[ERROR]",
	"^3[WARNING]",
	"^7[INFO]",
	"^4[VERBOSE]",
	"^6[DEBUG]",
}

local CURRENT_RESOURCE_NAME = GetCurrentResourceName()
local CONVAR_PRINT_LEVEL = GetConvarInt(CURRENT_RESOURCE_NAME .. ":printlevel", GetConvarInt("global:printlevel", 3))
local RESOURCE_PRINT_LEVEL = type(CONVAR_PRINT_LEVEL) == "number" and math.max(1, math.min(CONVAR_PRINT_LEVEL, 5)) or 3
local TEMPLATE = "%s %s^7"

---Process `string.format` param value(s).
---@param value unknown
---@return string Processed value
local function process_value(value)
	if type(value) == "function" then
		return tostring(value)
	end

	if type(value) == "nil" then return "nil" end

	return tostring(value)
end

---Processes all arguments.
---@param ... unknown
---@return table
local function process_args(...)
	local args = { ... }
	local argsLen = select("#", args)

	if argsLen <= 0 then
		return args
	end

	for i = 1, argsLen do
		args[i] = process_value(args[i])
	end

	return args
end

---Builds the log message string (non-formatted version).
---@param level integer The number of the level.
---@param ... unknown
---@return string? The complete message string or nil if level is filtered out
local function build_log_message(level, ...)
	if not LEVEL_PREFIXES[level] or level > RESOURCE_PRINT_LEVEL then return end

	return TEMPLATE:format(LEVEL_PREFIXES[level], table.unpack(process_args(...)))
end

---Builds the log message string (formatted version).
---@param level integer The number of the level.
---@param string string The string format pattern
---@param ... unknown
---@return string? The complete message string or nil if level is filtered out
local function build_logf_message(level, string, ...)
	if not LEVEL_PREFIXES[level] or level > RESOURCE_PRINT_LEVEL then return end

	-- Less readable but faster, especially when doing allot of logs which we shouldn't be but he which we shouldn't be but hey
	return TEMPLATE:format(LEVEL_PREFIXES[level], string:format(table.unpack(process_args(...))))
end

---@return CLogger
return {
	error = function(...)
		local msg = build_log_message(1, ...)

		if not msg then return end

		error(msg, 2)
	end,
	errorf = function(...)
		local msg = build_logf_message(1, ...)

		if not msg then return end

		error(msg, 2)
	end,
	warning = function(...)
		local msg = build_log_message(2, ...)

		if not msg then return end

		print(msg)
	end,
	warningf = function(...)
		local msg = build_logf_message(2, ...)

		if not msg then return end

		print(msg)
	end,
	info = function(...)
		local msg = build_log_message(3, ...)

		if not msg then return end

		print(msg)
	end,
	infof = function(...)
		local msg = build_logf_message(3, ...)

		if not msg then return end

		print(msg)
	end,
	verbose = function(...)
		local msg = build_log_message(4, ...)

		if not msg then return end

		print(msg)
	end,
	verbosef = function(...)
		local msg = build_logf_message(4, ...)

		if not msg then return end

		print(msg)
	end,
	debug = function(...)
		local msg = build_log_message(5, ...)

		if not msg then return end

		print(msg)
	end,
	debugf = function(...)
		local msg = build_logf_message(5, ...)

		if not msg then return end

		print(msg)
	end
}
