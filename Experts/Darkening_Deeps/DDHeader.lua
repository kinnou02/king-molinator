-- Darkening Deeps Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDD_Settings = nil
chKBMEXDD_Settings = nil

local MOD = {
	Directory = "Experts/Darkening_Deeps/",
	File = "DDHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	HasMaster = true,
	Name = "Darkening Deeps",
	Type = "Expert",
	ID = "Darkening_Deeps",
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
MOD.Lang.Main.Name:SetGerman("Finstere Tiefen")
-- MOD.Lang.Main.Name:SetFrench("")
-- MOD.Lang.Main.Name:SetRussian("")

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