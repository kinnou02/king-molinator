-- Tower of the Shattered Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXTOS_Settings = nil
chKBMSLEXTOS_Settings = nil

local MOD = {
	Directory = "Experts/Storm Legion/Tower_of_the_Shattered/",
	File = "TOSHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Tower of the Shattered",
	Type = "Expert",
	ID = "ETower_of_the_Shattered",
	Object = "MOD",
	Rift = "SL",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(MOD.ID, MOD)

-- Header Dictionary
MOD.Lang = {}
MOD.Lang.Main = {}
MOD.Lang.Main.Name = KBM.Language:Add(MOD.Name)
MOD.Lang.Main.Name:SetGerman("Turm der Zerschmetterten") 
MOD.Lang.Main.Name:SetFrench("Tour des Fracassés")

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
	self.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "SLExpert")	
end