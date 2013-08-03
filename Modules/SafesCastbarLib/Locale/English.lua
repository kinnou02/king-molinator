-- LibSCast Locale File
-- Written by Paul Snart
-- Copyright 2013
--

local LSCIni, LibSCast = ...

local Supported = {
	English = true,
	French = true,
	German = true,
	Russian = true,
}

if Supported[LibSCast.Language] then
	if LibSCast.Language ~= "English" then
		return
	end
end

-- Define Language Variables
LibSCast.Lang.Interrupted = "Interrupted"
LibSCast.Lang.Stopped = "Stopped"
