-- The Binding Maelforge Header for King Boss Mods
-- Written by Lifeismystery
-- Copyright 2014
--

KBMSLRDBM_Settings = nil
chKBMSLRDBM_Settings = nil

local BM = {
	Directory = "Raids/Storm Legion/Binding Maelforge/",
	File = "BMHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "The Bindings of Blood: Maelforge",
	Type = "Raid",
	ID = "RBinding_Maelforge",
	Object = "BM",
	Rift = "SL",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(BM.ID, BM)

BM.Lang = {}
BM.Lang.Main = {}
BM.Lang.Main.BM = KBM.Language:Add(BM.Name)
BM.Lang.Main.BM:SetFrench("Lien de Sang: Maelforge")
--BM.Lang.Main.BM:SetGerman("Tor der Unendlichkeit")
BM.Name = BM.Lang.Main.BM[KBM.Lang]
BM.Descript = BM.Name

function BM:AddBosses(KBM_Boss)
end

function BM:InitVars()
end

function BM:LoadVars()
end

function BM:SaveVars()
end

function BM:Start()
	function self:Handler(bool)
	end
end