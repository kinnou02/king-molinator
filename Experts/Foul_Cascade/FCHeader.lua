-- Foul Cascade Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFC_Settings = nil
chKBMEXFC_Settings = nil

local MOD = {
	Directory = "Experts/Foul_Cascade/",
	File = "FCHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Foul Cascade",
	Type = "Expert",
	ID = "Foul_Cascade",
	Object = "MOD",
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
MOD.Lang.Main.Name:SetGerman("Ekelkaskade") 
MOD.Lang.Main.Name:SetFrench("Cascade Infecte")
MOD.Lang.Main.Name:SetRussian("Зловещий Водопад")
MOD.Lang.Main.Name:SetKorean("타락 폭포")

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
	self.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "Group")	
end