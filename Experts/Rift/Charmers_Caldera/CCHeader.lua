-- Charmer's Caldera Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXCC_Settings = nil
chKBMEXCC_Settings = nil

local MOD = {
	Directory = "Experts/Rift/Charmers_Caldera/",
	File = "CCHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Charmer's Caldera",
	Type = "Expert",
	ID = "Charmers_Caldera",
	Object = "MOD",
	Rift = "Rift",
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
MOD.Lang.Main.Name:SetGerman("Zaubererkessel")
MOD.Lang.Main.Name:SetFrench("Caldera du Charmeur")
MOD.Lang.Main.Name:SetRussian("Воронка Заклинателя")
MOD.Lang.Main.Name:SetKorean("현혹의 칼데라")

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
end