-- Greenscale's Blight Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSB_Settings = {}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end

local GSB = {
	Directory = "GSB",
	File = "GSBHeader",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Greenscale's Blight",
	Type = "Raid",
	ID = "GSB",
	Object = "GSB",
}

KBM.RegisterMod("Greenscales Blight", GSB)

-- Header Dictionary
GSB.Lang = {}
GSB.Lang.Main = {}
GSB.Lang.Main.GSB = KBM.Language:Add(GSB.Name)
GSB.Lang.Main.GSB:SetGerman("Grünschuppes Pesthauch")
GSB.Lang.Main.GSB:SetFrench("Fl\195\169au de Vert\195\169caille")
GSB.Lang.Main.GSB:SetRussian("Темница Зеленокожа")
GSB.Lang.Main.GSB:SetKorean("그린스케일 황무지")
GSB.Name = GSB.Lang.Main.GSB[KBM.Lang]
GSB.Descript = GSB.Name

function GSB:AddBosses(KBM_Boss)
end

function GSB:InitVars()
end

function GSB:LoadVars()
end

function GSB:SaveVars()
end

function GSB:Start()
	function self:Handler(bool)
	end
	GSB.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler)	
end