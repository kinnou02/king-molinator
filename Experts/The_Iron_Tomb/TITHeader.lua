-- The Iron Tomb Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXTIT_Settings = nil
chKBMEXTIT_Settings = nil

local MOD = {
	Directory = "Experts/The_Iron_Tomb/",
	File = "TITHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "The Iron Tomb",
	Type = "Expert",
	ID = "The_Iron_Tomb",
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
MOD.Lang.Main.Name:SetGerman("Das Eisengrab")
MOD.Lang.Main.Name:SetFrench("La Tombe de fer")
MOD.Lang.Main.Name:SetRussian("Железная Гробница")
MOD.Lang.Main.Name:SetKorean("무쇠 무덤")

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