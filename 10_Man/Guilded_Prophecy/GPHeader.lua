-- Guilded Prophecy Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGP_Settings = {}

local GP = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Guilded Prophecy",
	Type = "10man",
	ID = "GP",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.RegisterMod("Guilded Prophecy", GP)

KBM.Language:Add(GP.Name)
KBM.Language[GP.Name]:SetGerman("Güldene Prophezeiung")
KBM.Language[GP.Name]:SetFrench("Proph\195\169tie dor\195\169e")

GP.Name = KBM.Language[GP.Name][KBM.Lang]

function GP:AddBosses(KBM_Boss)
end

function GP:InitVars()
end

function GP:LoadVars()
end

function GP:SaveVars()
end

function GP:Start()

	function self:Enabled(bool)
	
	end
	GP.Header = KBM.MainWin.Menu:CreateHeader(self.Name, self.Enabled, true)
	
end

function KBMGP_Register()
	return GP
end