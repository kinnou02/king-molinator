-- Runic Descent Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXRD_Settings = nil
chKBMEXRD_Settings = nil

local MOD = {
	Directory = "Experts/Runic_Descent/",
	File = "RDHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Runic Descent",
	Type = "Expert",
	ID = "Runic_Descent",
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
MOD.Lang.Main.Name:SetGerman("Runental")
MOD.Lang.Main.Name:SetFrench("Descente runique")
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