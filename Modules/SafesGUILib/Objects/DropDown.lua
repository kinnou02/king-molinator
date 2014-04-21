-- Drop Down Object
-- Written by Paul Snart
-- Copyright 2014
--

local AddonDetails, LibSGui = ...
local _int = LibSGui:_internal()
local LibSata = Inspect.Addon.Detail("SafesTableLib").data

local TH = _int.TH

-- Define Drop Down Events
LibSGui.Event.DropDown = {}
LibSGui.Event.DropDown.Scrollbar = {}
LibSGui.Event.DropDown.Scrollbar.Change = Utility.Event.Create("SafesGUILib", "DropDown.Scrollbar.Change")
LibSGui.Event.DropDown.Scrollbar.Active = Utility.Event.Create("SafesGUILib", "DropDown.Scrollbar.Active")
LibSGui.Event.DropDown.Change = Utility.Event.Create("SafesGUILib", "DropDown.Change")

-- Define Area
LibSGui.DropDown = {}

function LibSGui.DropDown:Create(title, _parent, pTable)
	pTable = pTable or {}
	
	local dropDown = _int:buildBase("dropdown", _parent)

	dropDown.Title = title
	dropDown.Data = LibSata:Create()
	
	return dropDown
end