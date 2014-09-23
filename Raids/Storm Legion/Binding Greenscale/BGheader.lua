-- The Infinity Gate Header for King Boss Mods
-- Written by Ivnedar
-- Copyright 2013
--

KBMSLRDBG_Settings = nil
chKBMSLRDBG_Settings = nil

local BG = {
	Directory = "Raids/Storm Legion/Binding Greenscale/",
	File = "BGHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "The Bindings of Bloods: Lord Greenscale",
	Type = "Raid",
	ID = "RBinding_Greenscale",
	Object = "BG",
	Rift = "SL",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(BG.ID, BG)

BG.Lang = {}
BG.Lang.Main = {}
BG.Lang.Main.BG = KBM.Language:Add(BG.Name)
BG.Lang.Main.BG:SetFrench("Lien de Sang: Seigneur Vertécaille")
--BG.Lang.Main.BG:SetGerman("Tor der Unendlichkeit")
BG.Name = BG.Lang.Main.BG[KBM.Lang]
BG.Descript = BG.Name

function BG:AddBosses(KBM_Boss)
end

function BG:InitVars()
end

function BG:LoadVars()
end

function BG:SaveVars()
end

function BG:Start()
	function self:Handler(bool)
	end
end