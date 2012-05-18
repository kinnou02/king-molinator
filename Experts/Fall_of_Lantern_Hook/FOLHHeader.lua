-- Fall of Lantern Hook Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFOLH_Settings = nil
chKBMEXFOLH_Settings = nil

local MOD = {
	Directory = "Experts/Fall_of_Lantern_Hook/",
	File = "FOLHHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Fall of Lantern Hook",
	Type = "Expert",
	ID = "Fall_of_Lantern_Hook",
	Object = "MOD",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.RegisterMod(MOD.Name, MOD)

-- Header Dictionary
MOD.Lang = {}
MOD.Lang.Main = {}
MOD.Lang.Main.Name = KBM.Language:Add(MOD.Name)
MOD.Lang.Main.Name:SetGerman("Untergang von Laternenhaken") 
MOD.Lang.Main.Name:SetFrench("Chute de Saillant de Lanterne")
MOD.Lang.Main.Name:SetRussian("Павший Фонарный Утес")

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
	self.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "Group")	
end