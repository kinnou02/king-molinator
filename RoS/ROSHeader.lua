-- River of Souls Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROS_Settings = {}

local ROS = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "River Of Souls",
	Type = "20man",
	ID = "ROS",
}

local KBM = KBM_RegisterMod("River Of Souls", ROS)

KBM.Language:Add(ROS.Name)
KBM.Language[ROS.Name]:SetGerman("Seelenfluss")

ROS.Name = KBM.Language[ROS.Name][KBM.Lang]

function ROS:AddBosses(KBM_Boss)
end

function ROS:InitVars()
end

function ROS:LoadVars()
end

function ROS:SaveVars()
end

function ROS:Start()
	function self:Enabled(bool)
	
	end
	ROS.Header = KBM.MainWin.Menu:CreateHeader(self.Name, self.Enabled, true)
	ROS.Header.Check:SetEnabled(false)
end

function KBMROS_Register()
	return ROS
end