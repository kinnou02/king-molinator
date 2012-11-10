-- Tower of the Shattered Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMTOS_Settings = nil
chKBMSLNMTOS_Settings = nil

local MOD = {
	Directory = "Dungeons/Storm Legion/Tower_of_the_Shattered/",
	File = "TOSHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Tower of the Shattered",
	Type = "Normal",
	ID = "NTower_of_the_Shattered",
	Object = "MOD",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(MOD.Name, MOD)

-- Header Dictionary
MOD.Lang = {}
MOD.Lang.Main = {}
MOD.Lang.Main.Name = KBM.Language:Add(MOD.Name)
MOD.Lang.Main.Name:SetGerman("Turm der Zerschmetterten") 

MOD.Name = MOD.Lang.Main.Name[KBM.Lang]
MOD.Descript = MOD.Name

function MOD:AddBosses(KBM_Boss)
end

function MOD:InitVars()
end

function MOD:LoadVars()
end

function MOD:SaveVars()
end

function MOD:Start()
	self.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "SLGroup")	
end