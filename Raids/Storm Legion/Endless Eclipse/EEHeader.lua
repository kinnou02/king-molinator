-- Endless Eclipse Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEE_Settings = nil
chKBMSLRDEE_Settings = nil

local EE = {
	Directory = "Raids/Storm Legion/Endless Eclipse/",
	File = "EEHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Endless Eclipse",
	Type = "Raid",
	ID = "REndless_Eclipse",
	Object = "EE",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(EE.ID, EE)

EE.Lang = {}
EE.Lang.Main = {}
EE.Lang.Main.EE = KBM.Language:Add(EE.Name)
EE.Lang.Main.EE:SetGerman("Ewige Sonnenfinsternis")
EE.Lang.Main.EE:SetFrench("Éclipse Éternelle")
EE.Name = EE.Lang.Main.EE[KBM.Lang]
EE.Descript = EE.Name

function EE:AddBosses(KBM_Boss)
end

function EE:InitVars()
end

function EE:LoadVars()
end

function EE:SaveVars()
end

function EE:Start()
	function self:Handler(bool)
	end
	EE.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "SLRaid")	
end