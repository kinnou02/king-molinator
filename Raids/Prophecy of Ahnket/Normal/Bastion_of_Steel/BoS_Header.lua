-- Bastion of Steel Header for King Boss Mods
-- Written by Wicendawen

KBMPOABOS_Settings = nil
chKBMPOABOS_Settings = nil

local TD = {
    Directory = "Raids/Prophecy of Ahnket/Normal/Bastion_of_Steel/",
    File = "BoS_Header.lua",
    Header = nil,
    Enabled = true,
    IsInstance = true,
    Name = "Bastion of Steel",
    Type = "Raid",
    ID = "BoS",
    Object = "bos",
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
TD.Lang.Main.Name:SetFrench("Le Bastion d'Acier")
TD.Lang.Main.Name:SetGerman("Die stählerne Festung")

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
