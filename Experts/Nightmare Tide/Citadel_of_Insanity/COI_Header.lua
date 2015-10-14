-- Citadel of Insanity Header for King Boss Mods
-- Written by Maatang
-- July 2015

KBMNTCOI_Settings = nil
chKBMNTCOI_Settings = nil

local MOD = {
	Directory = "Experts/Nightmare Tide/Citadel_of_Insanity/",
	File = "COI_Header.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Citadel of Insanity",
	Type = "Expert",
	ID = "Citadel_of_Insanity",
	Object = "MOD",
	Rift = "NT",
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
MOD.Lang.Main.Name:SetFrench("Citadelle de la Démence")


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