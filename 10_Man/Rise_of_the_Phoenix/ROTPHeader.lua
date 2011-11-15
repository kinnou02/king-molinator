-- Rise of the Phoenix Header for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTP_Settings = {}

local ROTP = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Rise of the Phoenix",
	Type = "10man",
	ID = "ROTP",
}

local KBM = KBM_RegisterMod("Rise of the Phoenix", ROTP)

KBM.Language:Add(ROTP.Name)
--KBM.Language[HK.Name]:SetFrench("Glasmarteau")

ROTP.Name = KBM.Language[ROTP.Name][KBM.Lang]

function ROTP:AddBosses(KBM_Boss)
end

function ROTP:InitVars()
end

function ROTP:LoadVars()
end

function ROTP:SaveVars()
end

function ROTP:Start()
	function self:Enabled(bool)
	
	end
	KBM.MenuGroup:SetTenMan()
	ROTP.Header = KBM.MainWin.Menu:CreateHeader(self.Name, self.Enabled, true)
	ROTP.Header.Check:SetEnabled(false)
end

function KBMROTP_Register()
	return ROTP
end