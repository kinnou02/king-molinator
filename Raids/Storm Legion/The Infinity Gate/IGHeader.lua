-- The Infinity Gate Header for King Boss Mods
-- Written by Ivnedar
-- Copyright 2013
--

KBMSLRDIG_Settings = nil
chKBMSLRDIG_Settings = nil

local IG = {
	Directory = "Raids/The Infinity Gate/",
	File = "IGHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "The Infinity Gate",
	Type = "Raid",
	ID = "RInfinity_Gate",
	Object = "IG",
	Rift = "SL",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(IG.ID, IG)

IG.Lang = {}
IG.Lang.Main = {}
IG.Lang.Main.IG = KBM.Language:Add(IG.Name)
IG.Lang.Main.IG:SetFrench("Porte de l'Infini")
IG.Name = IG.Lang.Main.IG[KBM.Lang]
IG.Descript = IG.Name

function IG:AddBosses(KBM_Boss)
end

function IG:InitVars()
end

function IG:LoadVars()
end

function IG:SaveVars()
end

function IG:Start()
	function self:Handler(bool)
	end
end