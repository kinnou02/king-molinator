-- Rhaza'de Canyons Header for King Boss Mods
-- Written by Maatang
-- July 2015

KBMNTRC_Settings = nil
chKBMNTRC_Settings = nil

local MOD = {
	Directory = "Experts/Nightmare Tide/Rhaza'de_Canyons/",
	File = "RC_Header.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Rhaza'de Canyons",
	Type = "Expert",
	ID = "Rhaza'de_Canyons",
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