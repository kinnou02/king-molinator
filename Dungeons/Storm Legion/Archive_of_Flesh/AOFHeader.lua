-- Archive of Flesh Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMAOF_Settings = nil
chKBMSLNMAOF_Settings = nil

local MOD = {
	Directory = "Dungeons/Storm Legion/Archive_of_Flesh/",
	File = "AOFHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Archive of Flesh",
	Type = "Normal",
	ID = "NArchive_of_Flesh",
	Object = "MOD",
	Rift = "SL",
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
MOD.Lang.Main.Name:SetGerman("Fleisch-Archiv")
MOD.Lang.Main.Name:SetFrench("Archive de chair")

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
	self.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "SLGroup")	
end