-- Safe's GUI Library
-- Written By Paul Snart
-- Copyright 2012
--
--
-- To access this from within your Add-on.
--
-- In your RiftAddon.toc
-- ---------------------
-- Embed: SafesGUILib
-- Dependency: SafesGUILib, {"required", "before"}
--
-- In your Add-on's initialization
-- -------------------------------
-- local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local AddonIni, LibSGui = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data

local _int = {
	_context = UI.CreateContext("LibSGui_Parking_Context"),
	base = {
		frame = LibSata:Create(),
		texture = LibSata:Create(),
		scrollbar = LibSata:Create(),
		button = LibSata:Create(),
		checkbox = LibSata:Create(),
	},
	objects = {
		window = LibSata:Create(),
		check = LibSata:Create(),
		scollbar = LibSata:Create(),
		group = LibSata:Create(),
	},
}

local _typeList = {
	["window"] = {
		w = 200,
		h = 200,
	},
	["check"] = {
	},
	["scrollbar"] = {
	},
}

function _int:pullFrame(_parent, _visible)
	local frame
	local Count = self.base.frame:Count()
	if Count == 0 then
		frame = UI.CreateFrame("Frame", "LibSGui_Frame_"..Count, _parent)
		frame:SetVisible(_visible or false)
		return frame
	else
		--print("Frame available in cache of "..Count)
		local frameObj, frame = self.base.frame:Last()
		self.base.frame:Remove(frameObj)
		frame:SetVisible(_visible or false)
		--print("New Frame count is: "..self.base.frame:Count())
		return frame
	end
end

function _int:pushFrame(frame)
	if frame then
		frame:SetVisible(false)
		frame:SetBackgroundColor(1,1,1,1)
		frame:ClearAll()
		frame:SetParent(self._context)
		for _eventID, _eventTable in pairs(frame.Event) do
			--print("Setting event: ".._eventID.." to nil")
			frame.Event[_eventID] = nil
		end
		self.base.frame:Add(frame)
		--print("Frame added to cache: Total available = "..self.base.frame:Count())
	else
		error("No frame supplied in: _int:pushFrame(frame)")
	end
end

function _int:buildBase(_type, _parent)
	if type(_type) == "string" then
		if _typeList[_type] then
			local base = {
				x = _typeList[_type].x or false,
				y = _typeList[_type].y or false,
				w = _typeList[_type].w or false,
				h = _typeList[_type].h or false,
				cradle = self:pullFrame(_parent)
			}
			return base
		else
			print("Error: Available GUI types are as follows (Case sensitive);")
			for _id, _table in pairs(_typeList) do
				print(_id)
			end
			error("Expeting a valid GUI string:\nGot: "..tostring(_type))
		end
	else
		print("Error: _int:buildBase(string _type)")
		error("Expeting _type to be of type 'string'\nGot :"..type(_type))
	end
end

function LibSGui:CreateWindow(title, _parent, pTable)
	pTable = pTable or {}
	local window = {
		_type = "window",
		_parent = _parent,
		base = _int:buildBase("window", _parent),
	}
	function window:Remove()
		_int:pushFrame(self.base.cradle)
	end
	return window
end

function LibSGui:CreateCheck()

end

function LibSGui:CreateScrollbar()

end