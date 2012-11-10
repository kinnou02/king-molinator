-- Unhallowed Boneforge Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMUBF_Settings = nil
chKBMSLNMUBF_Settings = nil

local MOD = {
	Directory = "Dungeons/Storm Legion/Unhallowed_Boneforge/",
	File = "UBFHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Unhallowed Boneforge",
	Type = "Normal",
	ID = "NUnhallowed_Boneforge",
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
MOD.Lang.Main.Name:SetGerman("Unheilige Knochenschmiede") 

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