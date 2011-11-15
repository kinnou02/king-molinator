-- Hammerknell Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSB_Settings = {}

local GSB = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Greenscale's Blight",
	ID = "GSB",
}

local KBM = KBM_RegisterMod("Greenscale's Blight", GSB)

KBM.Language:Add(GSB.Name)
KBM.Language[GSB.Name]:SetGerman("Grünschuppes Pesthauch")

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
	function self:Enabled(bool)
	
	end
	GSB.Header = KBM.MainWin.Menu:CreateHeader(self.Name, self.Enabled, true)
	GSB.Header.Check:SetEnabled(false)
end

function KBMGSB_Register()
	return GSB
end