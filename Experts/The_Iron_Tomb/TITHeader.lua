-- The Iron Tomb Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXAP_Settings = nil
chKBMEXAP_Settings = nil

local MOD = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "The Iron Tomb",
	Type = "Expert",
	ID = "MOD",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.RegisterMod(MOD.Name, MOD)

KBM.Language:Add(MOD.Name)
-- KBM.Language[MOD.Name]:SetGerman("")
-- KBM.Language[MOD.Name]:SetFrench("")
-- KBM.Language[MOD.Name]:SetRussian("")

MOD.Name = KBM.Language[MOD.Name][KBM.Lang]
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
	self.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "Group")	
end