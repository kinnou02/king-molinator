-- Intrepid Drowned Halls Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSLSLIDH_Settings = {}

local IDH = {
	Directory = "Slivers/Storm Legion/Intrepid_Drowned_Halls/",
	File = "IDHHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Intrepid Drowned Halls",
	Type = "Sliver",
	ID = "SLSIDH",
	Object = "IDH",
	Rift = "SL",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod("Intrepid Drowned Halls", IDH)

-- Header Dictionary
IDH.Lang = {}
IDH.Lang.Main = {}
IDH.Lang.Main.IDH = KBM.Language:Add(IDH.Name)
IDH.Lang.Main.IDH:SetGerman("Überflutete Hallen")
IDH.Lang.Main.IDH:SetFrench("Salles englouties")
IDH.Lang.Main.IDH:SetRussian("Затопленные Залы")
IDH.Lang.Main.IDH:SetKorean("수중 전당")
IDH.Name = IDH.Lang.Main.IDH[KBM.Lang]
IDH.Descript = IDH.Name

function IDH:AddBosses(KBM_Boss)
end

function IDH:InitVars()
end

function IDH:LoadVars()
end

function IDH:SaveVars()
end

function IDH:Start()
end