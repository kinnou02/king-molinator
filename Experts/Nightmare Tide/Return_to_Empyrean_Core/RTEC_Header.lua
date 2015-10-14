-- Return to Empyrean Core Header for King Boss Mods
-- Written by Maatang
-- July 2015

KBMNTRTEC_Settings = nil
chKBMNTRTEC_Settings = nil

local MOD = {
	Directory = "Experts/Nightmare Tide/Return_to_Empyrean_Core/",
	File = "RTEC_Header.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Return to Empyrean Core",
	Type = "Expert",
	ID = "RTEmpyrean_Core",
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
MOD.Lang.Main.Name:SetFrench("Retour à Cœur Empyréen")


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