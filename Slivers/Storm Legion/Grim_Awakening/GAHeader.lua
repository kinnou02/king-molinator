-- Grim Awakening Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLSLGA_Settings = nil
chKBMSLSLGA_Settings = nil

local GA = {
	Directory = "Slivers/Storm Legion/Grim_Awakening/",
	File = "GAHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Grim Awakening",
	Type = "Sliver",
	ID = "SGrim_Awakening",
	Object = "GA",
	Rift = "SL",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(GA.ID, GA)

-- Header Dictionary
GA.Lang = {}
GA.Lang.Main = {}
GA.Lang.Main.GA = KBM.Language:Add(GA.Name)
GA.Lang.Main.GA:SetFrench("Éveil sinistre")
GA.Name = GA.Lang.Main.GA[KBM.Lang]
GA.Descript = GA.Name

function GA:AddBosses(KBM_Boss)
end

function GA:InitVars()
end

function GA:LoadVars()
end

function GA:SaveVars()
end

function GA:Start()
end