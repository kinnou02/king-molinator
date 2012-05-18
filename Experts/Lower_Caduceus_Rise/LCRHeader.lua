-- Lower Caduceus Rise Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXLCR_Settings = nil
chKBMEXLCR_Settings = nil

local MOD = {
	Directory = "Experts/Lower_Caduceus_Rise/",
	File = "LCRHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Lower Caduceus Rise",
	Type = "Expert",
	ID = "Lower_Caduceus_Rise",
	Object = "MOD",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.RegisterMod(MOD.ID, MOD)

-- Header Dictionary
MOD.Lang = {}
MOD.Lang.Main = {}
MOD.Lang.Main.Name = KBM.Language:Add(MOD.Name)
MOD.Lang.Main.Name:SetGerman("Hermesstab-Anhöhe")
MOD.Lang.Main.Name:SetFrench("Butte du Caducée inférieure")
MOD.Lang.Main.Name:SetRussian("Восход Кадуцея")

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