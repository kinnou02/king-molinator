-- Hammerknell Header for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMHK_Settings = {}

local HK = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Hammerknell",
}

local KBM = KBM_RegisterMod("Hammerknell", HK)

function HK:AddBosses(KBM_Boss)
	if KBM.Lang == "German" then
	elseif KBM.Lang == "French" then
	end
end

function HK:InitVars()
end

function HK:LoadVars()
end

function HK:SaveVars()
end

function HK:Start()
	function self:Enabled(bool)
	
	end
	HK.Header = KBM.MainWin.Menu:CreateHeader(self.Name, self.Enabled, true)
	HK.Header.Check:SetEnabled(false)
end