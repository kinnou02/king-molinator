-- Tyrants Forge Header for King Boss Mods

KBMNTRDTF_Settings = nil
chKBMNTRDTF_Settings = nil

local TF = {
	Directory = "Raid/Nightmare Tide/Tyrants Forge/",
	File = "TFHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Tyrants Forge",
	Type = "Raid",
	ID = "RTyrants_Forge",
	Object = "TF",
	Rift = "NT",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(TF.ID, TF)

-- Header Dictionary
TF.Lang = {}
TF.Lang.Main = {}
TF.Lang.Main.TF = KBM.Language:Add(TF.Name)
TF.Lang.Main.TF:SetFrench("Forge du Tyran")
TF.Name = TF.Lang.Main.TF[KBM.Lang]
TF.Descript = TF.Name

function TF:AddBosses(KBM_Boss)
end

function TF:InitVars()
end

function TF:LoadVars()
end

function TF:SaveVars()
end

function TF:Start()
end