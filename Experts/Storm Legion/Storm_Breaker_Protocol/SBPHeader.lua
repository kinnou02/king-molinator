-- Storm Breaker Protocol Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXSBP_Settings = nil
chKBMSLEXSBP_Settings = nil

local MOD = {
	Directory = "Experts/Storm Legion/Storm_Breaker_Protocol/",
	File = "SBPHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Storm Breaker Protocol",
	Type = "Expert",
	ID = "EStorm_Breaker_Protocol",
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
MOD.Lang.Main.Name:SetGerman("Sturmbrecher-Protokoll")
MOD.Lang.Main.Name:SetFrench("Stratagème de Brise-tempête")

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