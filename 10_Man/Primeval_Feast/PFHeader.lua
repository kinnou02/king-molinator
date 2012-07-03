-- Primeval Feast Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMPF_Settings = {}

local PF = {
	Directory = "10_Man/Primeval_Feast/",
	File = "PFHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Primeval Feast",
	Type = "10man",
	ID = "PF",
	Object = "PF",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(PF.Name, PF)

-- Header Dictionary
PF.Lang = {}
PF.Lang.Main = {}
PF.Lang.Main.PF = KBM.Language:Add(PF.Name)
PF.Lang.Main.PF:SetGerman("Urzeitlicher Schmaus")
PF.Name = PF.Lang.Main.PF[KBM.Lang]
PF.Descript = PF.Name

function PF:AddBosses(KBM_Boss)
end

function PF:InitVars()
end

function PF:LoadVars()
end

function PF:SaveVars()
end

function PF:Start()
	PF.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "Sliver")	
end