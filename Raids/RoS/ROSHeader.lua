-- River of Souls Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROS_Settings = {}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end

local ROS = {
	Directory = "Raids/RoS/",
	File = "ROSHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "River of Souls",
	Type = "Raid",
	ID = "ROS",
	Object = "ROS",
}

KBM.RegisterMod("River of Souls", ROS)

-- Header Name Dictionary
ROS.Lang = {}
ROS.Lang.Main = {}
ROS.Lang.Main.ROS = KBM.Language:Add(ROS.Name)
ROS.Lang.Main.ROS:SetGerman("Seelenfluss")
ROS.Lang.Main.ROS:SetFrench("Fleuves des \195\130mes")
ROS.Lang.Main.ROS:SetRussian("Река Душ")
ROS.Lang.Main.ROS:SetKorean("영혼의 강")

ROS.Name = ROS.Lang.Main.ROS[KBM.Lang]
ROS.Descript = ROS.Name

function ROS:AddBosses(KBM_Boss)
end

function ROS:InitVars()
end

function ROS:LoadVars()
end

function ROS:SaveVars()
end

function ROS:Start()
	function self:Handler(bool)
	end
	ROS.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler)	
end