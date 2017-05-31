-- Tartaric Depths Header for King Boss Mods
-- Written by Wicendawen

KBMPOATD_Settings = nil
chKBMPOATD_Settings = nil

local TD = {
    Directory = "Raids/Prophecy of Ahnket/Tartaric Depths/",
    File = "TD_Header.lua",
    Header = nil,
    Enabled = true,
    IsInstance = true,
    Name = "Tartaric Depths",
    Type = "Raid",
    ID = "Tartaric_Depths",
    Object = "TD",
    Rift = "PoA",
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
TD.Lang.Main.Name:SetFrench("Profondeur Tartare")


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
