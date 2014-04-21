-- KBM Menu System: Group
-- Written by Paul Snart
-- Copyright 2014
--
local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local Menu = KBM.Menu

function Menu.Object:CreateGroup(Name, Settings, ID, Callback, Page)
	local GroupObj = {}
	Menu.UI.SetDefaults(GroupObj, Name, Settings, ID, Callback, Page)
	
	function GroupObj:Render()	
	end
			
	function GroupObj:Remove()
	end
	
	return GroupObj
end