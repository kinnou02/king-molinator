-- Hammerknell Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMHK_Settings = {}
chKBMHK_Settings = {}

local HK = {
	Directory = "Raids/Nightmare Tide/Hammerknell/",
	File = "HKHeader.lua",
	Header = nil,
	Menu = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Hammerknell Fortress",
	Type = "Raid",
	ID = "HK",
	Object = "HK",
	Rift = "NT",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod("Hammerknell", HK)

HK.Lang = {}
HK.Lang.Main = {}
HK.Lang.Main.Hammerknell = KBM.Language:Add(HK.Name)
HK.Lang.Main.Hammerknell:SetFrench("Glasmarteau")
HK.Lang.Main.Hammerknell:SetGerman("Festung Hammerhall")
HK.Lang.Main.Hammerknell:SetRussian("Крепость Молотозвона")
HK.Lang.Main.Hammerknell:SetKorean("망치소리 요새")
HK.Name = HK.Lang.Main.Hammerknell[KBM.Lang]
HK.Descript = HK.Name

function HK:AddBosses(KBM_Boss)
end

function HK:InitVars()
end

function HK:LoadVars()
end

function HK:SaveVars()
end

function HK:Start()

	function self:Handler(bool)
	
	end
	
	
end

function HK.Register()
	return HK
end