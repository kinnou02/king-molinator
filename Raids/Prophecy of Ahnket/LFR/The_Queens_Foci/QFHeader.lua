-- The Queen's Foci Header for King Boss Mods
-- Written by Rikard Blixt
-- Copyright 2017
--

KBMPOAQF_Settings = nil
chKBMPOAQF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end

local MOD = {
	Directory = "Raids/Prophecy of Ahnket/LFR/The_Queens_Foci/",
	File = "QFHeader",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "The Queen's Foci",
	Type = "Sliver",
	ID = "The_Queens_Foci",
	Object = "MOD",
	Rift = "PA",
}

KBM.RegisterMod(MOD.ID, MOD)

-- Header Dictionary
MOD.Lang = {}
MOD.Lang.Main = {}
MOD.Lang.Main.Name = KBM.Language:Add(MOD.Name)
MOD.Lang.Main.Name:SetGerman("Die Foki der Königin")

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
	function self:Handler(bool)
	end
end
