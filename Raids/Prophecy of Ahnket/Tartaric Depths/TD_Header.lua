-- Tartaric Depths Header for King Boss Mods
-- Written by Wicendawen

KBMPOATD_Settings = nil
chKBMPOATD_Settings = nil

local MOD = {
	Directory = "Raids/Prophecy of Ahnket/Tartaric Depths/",
	File = "TD_Header.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Tartaric Depths",
	Type = "Raid",
	ID = "Tartaric_Depths",
	Object = "MOD",
	Rift = "Prophecy of Ahnket",
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
MOD.Lang.Main.Name:SetFrench("Profondeur Tartare")


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
