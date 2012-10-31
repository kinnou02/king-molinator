-- Gilded Prophecy Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGP_Settings = {}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end

local GP = {
	Directory = "Sliver/Gilded_Prophecy/",
	File = "GPHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Gilded Prophecy",
	Type = "Sliver",
	ID = "GP",
	Object = "GP",
}

KBM.RegisterMod("Gilded Prophecy", GP)

-- Header Dictionary
GP.Lang = {}
GP.Lang.Main = {}
GP.Lang.Main.GP = KBM.Language:Add(GP.Name)
GP.Lang.Main.GP:SetGerman("Güldene Prophezeiung")
GP.Lang.Main.GP:SetFrench("Proph\195\169tie dor\195\169e")
GP.Lang.Main.GP:SetRussian("Позолоченное пророчество")
GP.Name = GP.Lang.Main.GP[KBM.Lang]
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
	GP.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "Sliver")	
end