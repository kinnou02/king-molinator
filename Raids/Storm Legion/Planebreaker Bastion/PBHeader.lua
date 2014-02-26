-- Planebreaker Bastion Header for King Boss Mods
-- Written by Ivnedar
-- Copyright 2013
--

KBMSLRDPB_Settings = nil
chKBMSLRDPB_Settings = nil

local PB = {
	Directory = "Raids/Planebreaker Bastion",
	File = "PBHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Planebreaker Bastion",
	Type = "Raid",
	ID = "RPlanebreaker_Bastion",
	Object = "PB",
	Rift = "SL",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(PB.ID, PB)

PB.Lang = {}
PB.Lang.Main = {}
PB.Lang.Main.PB = KBM.Language:Add(PB.Name)
PB.Lang.Main.PB:SetFrench("Bastion des Planicides")
PB.Lang.Main.PB:SetGerman("Ebenenbrecher Bastion")
PB.Name = PB.Lang.Main.PB[KBM.Lang]
PB.Descript = PB.Name

function PB:AddBosses(KBM_Boss)
end

function PB:InitVars()
end

function PB:LoadVars()
end

function PB:SaveVars()
end

function PB:Start()
	function self:Handler(bool)
	end
end