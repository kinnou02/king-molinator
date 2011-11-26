-- Hammerknell Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMHK_Settings = {}
chKBMHK_Settings = {}

local HK = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Hammerknell Fortress",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.RegisterMod("Hammerknell", HK)

KBM.Language:Add(HK.Name)
KBM.Language[HK.Name]:SetFrench("Glasmarteau")
KBM.Language[HK.Name]:SetGerman("Festung Hammerhall")
HK.Name = KBM.Language[HK.Name][KBM.Lang]

function HK:AddBosses(KBM_Boss)
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
end

function HK.Register()
	return HK
end