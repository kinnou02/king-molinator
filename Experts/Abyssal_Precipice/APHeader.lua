-- Abyssal Precipice Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXAP_Settings = nil
chKBMEXAP_Settings = nil

local MOD = {
	Directory = "Experts/Abyssal_Precipice/",
	File = "APHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Abyssal Precipice",
	Type = "Expert",
	ID = "Abyssal_Precipice",
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
MOD.Lang.Main.Name:SetGerman("Abgründige Kluft") 
MOD.Lang.Main.Name:SetFrench("Précipice abyssal")
MOD.Lang.Main.Name:SetRussian("Обрыв Глубинных")
MOD.Lang.Main.Name:SetKorean("심연의 벼랑")

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