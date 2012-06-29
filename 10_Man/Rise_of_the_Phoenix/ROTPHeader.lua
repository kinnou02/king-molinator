-- Rise of the Phoenix Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTP_Settings = {}

local ROTP = {
	Directory = "10_Man/Rise_of_the_Phoenix/",
	File = "ROTPHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Rise of the Phoenix",
	Type = "10man",
	ID = "ROTP",
	Object = "ROTP",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod("Rise of the Phoenix", ROTP)

-- Header Dictionary
ROTP.Lang = {}
ROTP.Lang.Main = {}
ROTP.Lang.Main.ROTP = KBM.Language:Add(ROTP.Name)
ROTP.Lang.Main.ROTP:SetGerman("Aufstieg des Phönix")
ROTP.Lang.Main.ROTP:SetFrench("Envol du Ph\195\169nix")
ROTP.Lang.Main.ROTP:SetRussian("Возрождение Феникса")
ROTP.Lang.Main.ROTP:SetKorean("불사조 오르막")
ROTP.Name = ROTP.Lang.Main.ROTP[KBM.Lang]
ROTP.Descript = ROTP.Name

function ROTP:AddBosses(KBM_Boss)
end

function ROTP:InitVars()
end

function ROTP:LoadVars()
end

function ROTP:SaveVars()
end

function ROTP:Start()
	function self:Handler(bool)
	end
	ROTP.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "Sliver")
end