-- The Infinity Gate Header for King Boss Mods
-- Written by Ivnedar
-- Copyright 2013
--

KBMSLRDBL_Settings = nil
chKBMSLRDBL_Settings = nil

local BL = {
	Directory = "Raids/Storm Legion/Binding Laethys/",
	File = "BLHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "The Bindings of Bloods: Laethys",
	Type = "Raid",
	ID = "RBinding_Laethys",
	Object = "BL",
	Rift = "SL",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(BL.ID, BL)

BL.Lang = {}
BL.Lang.Main = {}
BL.Lang.Main.BL = KBM.Language:Add(BL.Name)
BL.Lang.Main.BL:SetFrench("Lien de Sang: Laethys")
--BL.Lang.Main.BL:SetGerman("Tor der Unendlichkeit")
BL.Name = BL.Lang.Main.BL[KBM.Lang]
BL.Descript = BL.Name

function BL:AddBosses(KBM_Boss)
end

function BL:InitVars()
end

function BL:LoadVars()
end

function BL:SaveVars()
end

function BL:Start()
	function self:Handler(bool)
	end
end