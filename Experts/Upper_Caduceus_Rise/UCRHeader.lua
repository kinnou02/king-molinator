-- Upper Caduceus Rise Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXUCR_Settings = nil
chKBMEXUCR_Settings = nil

local MOD = {
	Directory = "Experts/Upper_Caduceus_Rise/",
	File = "UCRHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Upper Caduceus Rise",
	Type = "Expert",
	ID = "Upper_Caduceus_Rise",
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
MOD.Lang.Main.Name:SetGerman("Obere Hermesstab-Anhöhe")
MOD.Lang.Main.Name:SetFrench("Butte du Caducée supérieure")
MOD.Lang.Main.Name:SetRussian("Верхняя часть Восхода Кадуцея")
MOD.Lang.Main.Name:SetKorean("상부 카두세우스 오르막")

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