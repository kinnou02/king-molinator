-- Infernal Dawn Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMIND_Settings = {}

local IND = {
	Directory = "InfernalDawn/",
	File = "INDHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Infernal Dawn",
	Type = "20man",
	ID = "IND",
	Object = "IND",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod("Infernal Dawn", IND)

IND.Lang = {}
IND.Lang.Main = {}
IND.Lang.Main.IND = KBM.Language:Add(IND.Name)
IND.Lang.Main.IND:SetGerman("Höllendämmerung")
IND.Lang.Main.IND:SetFrench("Aurore infernale")
IND.Lang.Main.IND:SetRussian("Пламенный Восход")
IND.Lang.Main.IND:SetKorean("화염지옥 여명지")
IND.Name = IND.Lang.Main.IND[KBM.Lang]
IND.Descript = IND.Name

function IND:AddBosses(KBM_Boss)
end

function IND:InitVars()
end

function IND:LoadVars()
end

function IND:SaveVars()
end

function IND:Start()
	function self:Handler(bool)
	end
	IND.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler)	
end