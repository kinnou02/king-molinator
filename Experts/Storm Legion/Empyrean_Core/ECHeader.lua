-- EEmpyrean_Core Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXEC_Settings = nil
chKBMSLEXEC_Settings = nil

local MOD = {
	Directory = "Experts/Storm Legion/Empyrean_Core/",
	File = "ECHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Empyrean Core",
	Type = "Expert",
	ID = "EEmpyrean_Core",
	Object = "MOD",
	Rift = "SL",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(MOD.ID, MOD)

-- Header Dictionary
MOD.Lang = {}
MOD.Lang.Main = {}
MOD.Lang.Main.Name = KBM.Language:Add(MOD.Name)
MOD.Lang.Main.Name:SetGerman("Empyreum-Kern")
MOD.Lang.Main.Name:SetFrench("Cœur Empyréen")

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
	self.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "SLExpert")	
end