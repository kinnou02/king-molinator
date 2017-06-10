-- Gyel Fortress Header for King Boss Mods
-- Written by Maatang
-- July 2015

KBMPOAIGF_Settings = nil
chKBMPOAIGF_Settings = nil

local MOD = {
	Directory = "Experts/Prophecy of Ahnket/Gyel_Fortress/",
	File = "GF_Header.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Intrepid Gyel Fortress",
	Type = "Expert",
	ID = "Intrepid_Gyel_Fortress",
	Object = "MOD",
	Rift = "PoA",
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
MOD.Lang.Main.Name:SetFrench("Forteresse Gyel")


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
