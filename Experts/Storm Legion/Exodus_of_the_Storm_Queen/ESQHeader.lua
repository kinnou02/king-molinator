-- EExodus_of_the_Storm_Queen Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXSQ_Settings = nil
chKBMSLEXSQ_Settings = nil

local MOD = {
	Directory = "Experts/Storm Legion/Exodus_of_the_Storm_Queen/",
	File = "ESQHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Exodus of the Storm Queen",
	Type = "Expert",
	ID = "EExodus_of_the_Storm_Queen",
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
MOD.Lang.Main.Name:SetGerman("Exodus der Sturmkönigin")
MOD.Lang.Main.Name:SetFrench("Exode de la Reine de la Tempête")

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