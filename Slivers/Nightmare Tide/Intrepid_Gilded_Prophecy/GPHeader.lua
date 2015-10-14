-- Gilded Prophecy Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMNTIGP_Settings = {}
chKBMNTIGP_Settings = {}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end

local IGP = {
	Directory = "Slivers/Nightmare Tide/Intrepid_Gilded_Prophecy/",
	File = "IGPHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Intrepid Gilded Prophecy",
	Type = "Sliver",
	ID = "IGP",
	Object = "IGP",
	Rift = "NT",
}

KBM.RegisterMod("Intrepid Gilded Prophecy", IGP)

-- Header Dictionary
IGP.Lang = {}
IGP.Lang.Main = {}
IGP.Lang.Main.IGP = KBM.Language:Add(IGP.Name)
IGP.Lang.Main.IGP:SetGerman("Güldene Prophezeiung")
IGP.Lang.Main.IGP:SetFrench("Proph\195\169tie dor\195\169e")
IGP.Lang.Main.IGP:SetRussian("Позолоченное пророчество")
IGP.Name = IGP.Lang.Main.IGP[KBM.Lang]
IGP.Descript = IGP.Name

function IGP:AddBosses(KBM_Boss)
end

function IGP:InitVars()
end

function IGP:LoadVars()
end

function IGP:SaveVars()
end

function IGP:Start()
end