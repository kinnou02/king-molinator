-- Hammerknell Header for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMHK_Settings = {}

local HK = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	MenuName = "Hammerknell",
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

function HK:Start(KBM_MainWin)
	function self:Enabled(bool)
	
	end
	HK.Header = KBM_MainWin.Menu:CreateHeader("Hammerknell", self.Enabled, true)
	HK.Header.Check:SetEnabled(false)
end