-- QF Header for King Boss Mods
-- Written by Wicendawen

KBMPOAQF_Settings = nil
chKBMPOAQF_Settings = nil

local QF = {
    Directory = "Raids/Prophecy of Ahnket/Queen foci/",
    File = "QF_Header.lua",
    Header = nil,
    Enabled = true,
    IsInstance = true,
    Name = "The Queen's Foci",
    Type = "Raid",
    ID = "QF",
    Object = "QF",
    Rift = "PoA",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
    return
end

KBM.RegisterMod(QF.ID, QF)

-- Header Dictionary
QF.Lang = {}
QF.Lang.Main = {}
QF.Lang.Main.Name = KBM.Language:Add(QF.Name)
QF.Lang.Main.Name:SetFrench("Les Focus de la Reine")


QF.Name = QF.Lang.Main.Name[KBM.Lang]
QF.Descript = QF.Name

function QF:AddBosses(KBM_Boss)
end

function QF:InitVars()
end

function QF:LoadVars()
end

function QF:SaveVars()
end

function QF:Start()
end
