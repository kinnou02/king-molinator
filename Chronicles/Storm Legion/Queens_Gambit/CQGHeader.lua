-- Queens Gambit Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2013
--

KBMCRONSLQG_Settings = nil
chKBMCRONSLQG_Settings = nil

local MOD = {
	Directory = "Chronicles/Storm Legion/Queens_Gambit/",
	File = "CQGHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Queens Gambit",
	Type = "Normal",
	ID = "CRONQueens_Gambit",
	Object = "MOD",
	Rift = "SL",
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