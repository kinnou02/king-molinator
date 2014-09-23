-- The Infinity Gate Header for King Boss Mods
-- Written by Ivnedar
-- Copyright 2013
--

KBMSLRDBA_Settings = nil
chKBMSLRDBA_Settings = nil

local BA = {
	Directory = "Raids/Storm Legion/Binding Akylios/",
	File = "BAHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "The Bindings of Bloods: Akylios",
	Type = "Raid",
	ID = "RBinding_Akylios",
	Object = "BA",
	Rift = "SL",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(BA.ID, BA)

BA.Lang = {}
BA.Lang.Main = {}
BA.Lang.Main.BA = KBM.Language:Add(BA.Name)
BA.Lang.Main.BA:SetFrench("Lien de Sang: Akylios")
--BA.Lang.Main.BA:SetGerman("Tor der Unendlichkeit")
BA.Name = BA.Lang.Main.BA[KBM.Lang]
BA.Descript = BA.Name

function BA:AddBosses(KBM_Boss)
end

function BA:InitVars()
end

function BA:LoadVars()
end

function BA:SaveVars()
end

function BA:Start()
	function self:Handler(bool)
	end
end