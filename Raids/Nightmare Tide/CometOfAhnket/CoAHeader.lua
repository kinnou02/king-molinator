-- Comet Of Ahnket Header for King Boss Mods
-- Written by Elinare
--

KBMNTRDCOA_Settings = nil
chKBMNTRDCOA_Settings = nil

local COA = {
	Directory = "Raids/Nightmare Tide/CometOfAhnket/",
	File = "CoAHeader.lua",
	Header = nil,
	Menu = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Comet Of Ahnket",
	Type = "Raid",
	ID = "RCometOfAhnket",
	Object = "COA",
	Rift = "NT",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod("RCometOfAhnket", COA)

-- Header Dictionary
COA.Lang = {}
COA.Lang.Main = {}
COA.Lang.Main.COA = KBM.Language:Add(COA.Name)
COA.Lang.Main.COA:SetFrench("La comete d'Ahnket")
COA.Name = COA.Lang.Main.COA[KBM.Lang]
COA.Descript = COA.Name

function COA:AddBosses(KBM_Boss)
end

function COA:InitVars()
end

function COA:LoadVars()
end

function COA:SaveVars()
end

function COA:Start()
	function self:Handler(bool)
	end
end