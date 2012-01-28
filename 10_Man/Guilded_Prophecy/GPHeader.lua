-- Gilded Prophecy Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGP_Settings = {}

local GP = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Gilded Prophecy",
	Type = "10man",
	ID = "GP",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.RegisterMod("Gilded Prophecy", GP)

KBM.Language:Add(GP.Name)
KBM.Language[GP.Name]:SetGerman("Güldene Prophezeiung")
KBM.Language[GP.Name]:SetFrench("Proph\195\169tie dor\195\169e")
KBM.Language[GP.Name]:SetRussian("Позолоченное пророчество")

GP.Name = KBM.Language[GP.Name][KBM.Lang]
GP.Descript = GP.Name

function GP:AddBosses(KBM_Boss)
end

function GP:InitVars()
end

function GP:LoadVars()
end

function GP:SaveVars()
end

function GP:Start()
	GP.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler)	
end