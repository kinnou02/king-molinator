-- The Rhen of Fate Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMNTSLROF_Settings = nil
chKBMNTSLROF_Settings = nil

local ROF = {
	Directory = "Slivers/Nightmare Tide/The_Rhen_of_Fate/",
	File = "ROFHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "The Rhen of Fate",
	Type = "Sliver",
	ID = "SThe_Rhen_of_Fate",
	Object = "ROF",
	Rift = "NT",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(ROF.ID, ROF)

-- Header Dictionary
ROF.Lang = {}
ROF.Lang.Main = {}
ROF.Lang.Main.ROF = KBM.Language:Add(ROF.Name)
--ROF.Lang.Main.ROF:SetFrench("Éveil sinistre")
--ROF.Lang.Main.ROF:SetGerman("Böses Erwachen")
ROF.Name = ROF.Lang.Main.ROF[KBM.Lang]
ROF.Descript = ROF.Name

function ROF:AddBosses(KBM_Boss)
end

function ROF:InitVars()
end

function ROF:LoadVars()
end

function ROF:SaveVars()
end

function ROF:Start()
end