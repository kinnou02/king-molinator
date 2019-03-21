-- Enclave of Ahnket Header for King Boss Mods
-- Written by Yarrellii
-- March 2019

KBMPOAEA_Settings = nil
chKBMPOAEA_Settings = nil

local MOD = {
	Directory = "Experts/Prophecy of Ahnket/Enclave_Of_Ahnket/",
	File = "EA_Header.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Enclave Of Ahnket",
	Type = "Expert",
	ID = "Enclave_Of_Ahnket",
	Object = "MOD",
	Rift = "PA",
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
--MOD.Lang.Main.Name:SetFrench("")


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