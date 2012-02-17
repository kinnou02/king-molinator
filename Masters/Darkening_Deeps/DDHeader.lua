-- Darkening Deeps Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMMDD_Settings = nil
chKBMMMDD_Settings = nil

local MOD = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	HasMaster = true,
	Name = "Darkening Deeps",
	Type = "Master",
	ID = "MM_Darkening_Deeps",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.RegisterMod(MOD.ID, MOD)

KBM.Language:Add(MOD.Name)
KBM.Language[MOD.Name]:SetGerman("Finstere Tiefen")
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
	self.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "Master")	
end