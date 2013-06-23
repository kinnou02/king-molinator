-- Triumph of the Dragon Queen Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLSLTQ_Settings = nil
chKBMSLSLTQ_Settings = nil

local TDQ = {
	Directory = "Slivers/Storm Legion/Triumph_of_the_Dragon_Queen/",
	File = "TDQHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Triumph of the Dragon Queen",
	Type = "Sliver",
	ID = "STriumph_of_the_Dragon_Queen",
	Object = "TDQ",
	Rift = "SL",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(TDQ.ID, TDQ)

-- Header Dictionary
TDQ.Lang = {}
TDQ.Lang.Main = {}
TDQ.Lang.Main.TDQ = KBM.Language:Add(TDQ.Name)
TDQ.Lang.Main.TDQ:SetGerman("Triumph der Drachenkönigin")
TDQ.Lang.Main.TDQ:SetFrench("Triomphe de la reine dragon")
TDQ.Name = TDQ.Lang.Main.TDQ[KBM.Lang]
TDQ.Descript = TDQ.Name

function TDQ:AddBosses(KBM_Boss)
end

function TDQ:InitVars()
end

function TDQ:LoadVars()
end

function TDQ:SaveVars()
end

function TDQ:Start()
end