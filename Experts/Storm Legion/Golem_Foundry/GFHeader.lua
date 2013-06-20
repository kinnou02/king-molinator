-- Golem Foundry Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXGF_Settings = nil
chKBMSLEXGF_Settings = nil

local MOD = {
	Directory = "Experts/Storm Legion/Golem_Foundry/",
	File = "GFHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Golem Foundry",
	Type = "Expert",
	ID = "EGolem_Foundry",
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
MOD.Lang.Main.Name:SetGerman("Golem-Gießerei")
MOD.Lang.Main.Name:SetFrench("Fabrique de Golems")

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