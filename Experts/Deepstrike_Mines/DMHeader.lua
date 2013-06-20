-- Deepstrike Mines Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDM_Settings = nil
chKBMEXDM_Settings = nil

local MOD = {
	Directory = "Experts/Deepstrike_Mines/",
	File = "DMHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Deepstrike Mines",
	Type = "Expert",
	ID = "Deepstrike_Mines",
	Object = "MOD",
	Rift = "Rift",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(MOD.Name, MOD)

-- Header Dictionary
MOD.Lang = {}
MOD.Lang.Main = {}
MOD.Lang.Main.Name = KBM.Language:Add(MOD.Name)
MOD.Lang.Main.Name:SetGerman("Tiefschlagmine") 
MOD.Lang.Main.Name:SetFrench("Mines de Couprofond")
MOD.Lang.Main.Name:SetRussian("Глубинные Копи")
MOD.Lang.Main.Name:SetKorean("황천 광산")

MOD.Name = MOD.Lang.Main.Name[KBM.Lang]
MOD.Descript = MOD.Name

function MOD:AddBosses(KBM_Boss)
end

function MOD:InitVars()
end

function MOD:LoadVars()
end

function MOD:SaveVars()
end

function MOD:Start()
	self.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "Expert")	
end