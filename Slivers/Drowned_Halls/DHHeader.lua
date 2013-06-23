-- Drowned Halls Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDH_Settings = {}

local DH = {
	Directory = "Slivers/Drowned_Halls/",
	File = "DHHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Drowned Halls",
	Type = "Sliver",
	ID = "DH",
	Object = "DH",
	Rift = "Rift",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod("Drowned Halls", DH)

-- Header Dictionary
DH.Lang = {}
DH.Lang.Main = {}
DH.Lang.Main.DH = KBM.Language:Add(DH.Name)
DH.Lang.Main.DH:SetGerman("Überflutete Hallen")
DH.Lang.Main.DH:SetFrench("Salles englouties")
DH.Lang.Main.DH:SetRussian("Затопленные Залы")
DH.Lang.Main.DH:SetKorean("수중 전당")
DH.Name = DH.Lang.Main.DH[KBM.Lang]
DH.Descript = DH.Name

function DH:AddBosses(KBM_Boss)
end

function DH:InitVars()
end

function DH:LoadVars()
end

function DH:SaveVars()
end

function DH:Start()
end