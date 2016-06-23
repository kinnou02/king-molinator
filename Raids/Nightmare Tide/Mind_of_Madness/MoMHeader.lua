-- Mount Sharax Header for King Boss Mods
-- Written by Kapnia
--

KBMNTRDMOM_Settings = nil
chKBMNTRDMOM_Settings = nil

local MOM = {
	Directory = "Raids/Nightmare Tide/Mind_of_Madness/",
	File = "MOMHeader.lua",
	Header = nil,
	Menu = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Mind of Madness",
	Type = "Raid",
	ID = "RMoM",
	Object = "RMOM",
	Rift = "NT",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod("Mind_of_Madness", MOM)

-- Header Dictionary
MOM.Lang = {}
MOM.Lang.Main = {}
MOM.Lang.Main.MOM = KBM.Language:Add(MOM.Name)
MOM.Lang.Main.MOM:SetFrench("Esprit de la Folie")
MOM.Name = MOM.Lang.Main.MOM[KBM.Lang]
MOM.Descript = MOM.Name

function MOM:AddBosses(KBM_Boss)
end

function MOM:InitVars()
end

function MOM:LoadVars()
end

function MOM:SaveVars()
end

function MOM:Start()
	function self:Handler(bool)
	end
end