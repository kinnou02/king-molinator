-- Return to Iron Tomb Header for King Boss Mods
-- Written by Maatang
-- July 2015

KBMNTRTIT_Settings = nil
chKBMNTRTIT_Settings = nil

local MOD = {
	Directory = "Experts/Nightmare Tide/Return_to_Iron_Tomb/",
	File = "RTIT_Header.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Return to Iron Tomb",
	Type = "Expert",
	ID = "RTIron_Tomb",
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
MOD.Lang.Main.Name:SetFrench("Retour à Tombe de Fer")


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