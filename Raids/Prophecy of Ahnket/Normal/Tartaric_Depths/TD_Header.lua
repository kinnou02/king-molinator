-- Tartaric Depths Header for King Boss Mods
-- Written by Wicendawen

KBMPOANMTD_Settings = nil
chKBMPOANMTD_Settings = nil

local TD = {
    Directory = "Raids/Prophecy of Ahnket/Normal/Tartaric_Depths/",
    File = "TD_Header.lua",
    Header = nil,
    Enabled = true,
    IsInstance = true,
    Name = "Tartaric Depths Normal Mode",
    Type = "Raid",
    ID = "NMTD",
    Object = "TD",
    Rift = "PA",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
    return
end

KBM.RegisterMod(TD.ID, TD)

-- Header Dictionary
TD.Lang = {}
TD.Lang.Main = {}
TD.Lang.Main.Name = KBM.Language:Add(TD.Name)
TD.Lang.Main.Name:SetFrench("Profondeur Tartare Mode Normal")
TD.Lang.Main.Name:SetGerman("Tartarische Tiefen")

TD.Name = TD.Lang.Main.Name[KBM.Lang]
TD.Descript = TD.Name

function TD:AddBosses(KBM_Boss)
end

function TD:InitVars()
end

function TD:LoadVars()
end

function TD:SaveVars()
end

function TD:Start()
end
