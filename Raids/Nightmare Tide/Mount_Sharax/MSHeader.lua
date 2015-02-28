-- Mount Sharax Header for King Boss Mods
-- Written by Kapnia
--

KBMNTRDMS_Settings = nil
chKBMNTRDMS_Settings = nil

local MS = {
	Directory = "Raids/Nightmare Tide/Mount_Sharax/",
	File = "MSHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Mount Sharax",
	Type = "Raid",
	ID = "RMount_Sharax",
	Object = "MS",
	Rift = "NT",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(MS.ID, MS)

-- Header Dictionary
MS.Lang = {}
MS.Lang.Main = {}
MS.Lang.Main.MS = KBM.Language:Add(MS.Name)
MS.Name = MS.Lang.Main.MS[KBM.Lang]
MS.Descript = MS.Name

function MS:AddBosses(KBM_Boss)
end

function MS:InitVars()
end

function MS:LoadVars()
end

function MS:SaveVars()
end

function MS:Start()
	function self:Handler(bool)
	end
end