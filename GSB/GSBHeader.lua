-- Greenscale's Blight Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSB_Settings = {}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

local GSB = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Greenscale's Blight",
	Type = "20man",
	ID = "GSB",
}

KBM.RegisterMod("Greenscales Blight", GSB)

KBM.Language:Add(GSB.Name)
KBM.Language[GSB.Name]:SetGerman("Grünschuppes Pesthauch")
KBM.Language[GSB.Name]:SetFrench("Fl\195\169au de Vert\195\169caille")

GSB.Name = KBM.Language[GSB.Name][KBM.Lang]

function GSB:AddBosses(KBM_Boss)
end

function GSB:InitVars()
end

function GSB:LoadVars()
end

function GSB:SaveVars()
end

function GSB:Start()
	function self:Handler(bool)
	end
	GSB.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler)	
end