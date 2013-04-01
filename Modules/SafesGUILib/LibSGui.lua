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
		window = LibSata:Create(),
	},
	objects = {
		window = LibSata:Create(),
		check = LibSata:Create(),
		scollbar = LibSata:Create(),
		group = LibSata:Create(),
	},
}

-- Enviroment Tracking and Management
_int._context:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
_int._context:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT")
_int.env = {
	w = UIParent:GetWidth() or 0,
	h = UIParent:GetHeight() or 0,
}
function _int._context.Event.Size()
	_int.env.w = UIParent:GetWidth()
	_int.env.h = UIParent:GetHeight()
end

local _typeList = {
	["window"] = {
		w = 400,
		h = 400,
	},
	["check"] = {
	},
	["scrollbar"] = {
	},
	["group"] = {
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
		frame:SetParent(_parent)
		--print("New Frame count is: "..self.base.frame:Count())
		return frame
	end
end

function _int:pushFrame(frame)
	if frame then
		frame:SetVisible(false)
		frame:SetBackgroundColor(0,0,0,0)
		frame:ClearAll()
		frame:SetParent(self._context)
		frame:SetLayer(1)
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

function _int:pullButton(_parent)
	local button
	local Count = self.base.button:Count()
	if Count == 0 then
		button = UI.CreateFrame("RiftButton", "LibSGui_Button_"..Count, _parent)
		button.defaultEvents = {}
		for _eventID, _eventTable in pairs(button.Event) do
			button.defaultEvents[_eventID] = button.Event[_eventID]
		end
		return button
	else
		--print("Button available in cache of "..Count)
		local buttonObj, button = self.base.button:Last()
		self.base.button:Remove(buttonObj)
		button:SetParent(_parent)
		--print("New Button count is: "..self.base.button:Count())
		return button
	end
end

function _int:pushButton(button)
	if button then
		button:ClearAll()
		button:SetParent(self._context)
		button:SetSkin("default")
		button:SetLayer(1)
		for _eventID, _eventTable in pairs(button.Event) do
			--print("Setting event: ".._eventID.." to nil")
			button.Event[_eventID] = button.defaultEvents[_eventID]
		end
		self.base.button:Add(button)
		--print("Button added to cache: Total available = "..self.base.button:Count())
	else
		error("No window supplied in: _int:pushWindow(window)")
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
				offsetX = 0,
				offsetY = 0,
				_cradle = self:pullFrame(_parent),
				_type = _type,
				_active = false,
				_drag = false,
				User = {},
				_callbacks = {},
			}
			if base.w then
				base._cradle:SetWidth(base.w)
			end
			if base.h then
				base._cradle:SetHeight(base.h)
			end
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

function LibSGui:CreateCheck()

end

function LibSGui:CreateScrollbar()

end

function LibSGui:CreateGroup()

end

function LibSGui:_internal()
	return _int
end