-- Frozen Tempest Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDFT_Settings = nil
chKBMSLRDFT_Settings = nil

local FT = {
	Directory = "Raids/Frozen Tempest/",
	File = "FTHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Frozen Tempest",
	Type = "Raid",
	ID = "RFrozen_Tempest",
	Object = "FT",
	Rift = "SL",
}

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(FT.ID, FT)

FT.Lang = {}
FT.Lang.Main = {}
FT.Lang.Main.FT = KBM.Language:Add(FT.Name)
FT.Lang.Main.FT:SetGerman("Froststurm")
FT.Lang.Main.FT:SetFrench("Tempête de glace")
FT.Name = FT.Lang.Main.FT[KBM.Lang]
FT.Descript = FT.Name

function FT:AddBosses(KBM_Boss)
end

function FT:InitVars()
end

function FT:LoadVars()
end

function FT:SaveVars()
end

function FT:Start()
	function self:Handler(bool)
	end
	FT.Menu = KBM.MainWin.Menu:CreateInstance(self.Name, true, self.Handler, "SLRaid")	
end