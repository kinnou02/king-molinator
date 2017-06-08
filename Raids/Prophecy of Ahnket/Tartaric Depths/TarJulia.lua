-- TarJulia Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOATDTAR_Settings = nil
chKBMPOATDTAR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["Tartaric_Depths"]

local TAR = {
    Directory = Instance.Directory,
    File = "TarJulia.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
    Lang = {},
    ID = "TarJulia",
    Object = "TAR",
}

TAR.TarJulia = {
    Mod = TAR,
    Level = "??",
    Active = false,
    Name = "TarJulia",
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U1218D6C904266DB4",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
          Enabled = true,
          MoltenLava = KBM.Defaults.AlertObj.Create("red"),
        },
    },
}

TAR.Soul = {
    Mod = TAR,
    Level = "72",
    Name = "Infernal Soul",
    NameShort = "Infernal Soul",
    UnitList = {},
    Menu = {},
    UTID = "U60B1A0B31BAFAC42",
    Ignore = true,
    Type = "multi",
}

KBM.RegisterMod(TAR.ID, TAR)

-- Main Unit Dictionary
TAR.Lang.Unit = {}
TAR.Lang.Unit.TarJulia = KBM.Language:Add(TAR.TarJulia.Name)

TAR.Lang.Unit.Soul = KBM.Language:Add(TAR.Soul.Name)

-- Ability Dictionary
TAR.Lang.Ability = {}
TAR.Lang.Ability.MoltenLava = KBM.Language:Add("Molten Blast")

-- Verbose Dictionary
TAR.Lang.Verbose = {}
TAR.Lang.Verbose.MoltenLava = KBM.Language:Add("Go to a pillar!")

-- Buff Dictionary
TAR.Lang.Buff = {}

-- Debuff Dictionary
TAR.Lang.Debuff = {}

TAR.Lang.Notify = {}

-- Description Dictionary
TAR.Lang.Main = {}
TAR.Descript = TAR.Lang.Unit.TarJulia[KBM.Lang]

function TAR:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.TarJulia.Name] = self.TarJulia,
        [self.Soul.Name] = self.Soul,
    }
end

function TAR:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.TarJulia.Settings.CastBar,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        -- MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        -- TimersRef = self.Baird.Settings.TimersRef,
        AlertsRef = self.TarJulia.Settings.AlertsRef,
    }
    KBMPOATDTAR_Settings = self.Settings
    chKBMPOATDTAR_Settings = self.Settings

end

function TAR:SwapSettings(bool)

    if bool then
        KBMPOATDTAR_Settings = self.Settings
        self.Settings = chKBMPOATDTAR_Settings
    else
        chKBMPOATDTAR_Settings = self.Settings
        self.Settings = KBMPOATDTAR_Settings
    end

end

function TAR:LoadVars()
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOATDTAR_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOATDTAR_Settings, self.Settings)
    end

    if KBM.Options.Character then
        chKBMPOATDTAR_Settings = self.Settings
    else
        KBMPOATDTAR_Settings = self.Settings
    end 
end

function TAR:SaveVars()
    if KBM.Options.Character then
        chKBMPOATDTAR_Settings = self.Settings
    else
        KBMPOATDTAR_Settings = self.Settings
    end
end

function TAR:Castbar(units)
end

function TAR:RemoveUnits(UnitID)
    if self.TarJulia.UnitID == UnitID then
        self.TarJulia.Available = false
        return true
    end
    return false
end

function TAR:Death(UnitID)
    if self.TarJulia.UnitID == UnitID then
        self.TarJulia.Dead = true
        return true
    end
    if self.Soul.UnitList[UnitID] then
        if self.Soul.UnitList[UnitID].Dead == false then
            self.Soul.UnitList[UnitID].CastBar:Remove()
            self.Soul.UnitList[UnitID].CastBar = nil
            self.Soul.UnitList[UnitID].Dead = true
        end
    end
    return false
end


function TAR:UnitHPCheck(uDetails, unitID)
    if uDetails and unitID then
        if uDetails.type == self.TarJulia.UTID then
            if not self.EncounterRunning then
                self.EncounterRunning = true
                self.StartTime = Inspect.Time.Real()
                self.HeldTime = self.StartTime
                self.TimeElapsed = 0
                self.TarJulia.Dead = false
                self.TarJulia.Casting = false
                self.TarJulia.CastBar:Create(unitID)
                self.PhaseObj:Start(self.StartTime)
                self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
                self.PhaseObj.Objectives:AddPercent(self.TarJulia, 0, 100)
                self.PhaseObj.Objectives:AddDeath(TAR.Lang.Unit.Soul[KBM.Lang], 9)
                self.Phase = 1
            end
            self.TarJulia.UnitID = unitID
            self.TarJulia.Available = true
            return self.TarJulia
        end
        if uDetails.type == self.Soul.UTID then
           if not self.Bosses[uDetails.name].UnitList[unitID] then
                local SubBossObj = {
                    Mod = MOD,
                    Level = 72,
                    Name = uDetails.name,
                    Dead = false,
                    Casting = false,
                    UnitID = unitID,
                    Available = true,
                }
                self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
            else
                self.Bosses[uDetails.name].UnitList[unitID].Available = true
                self.Bosses[uDetails.name].UnitList[unitID].UnitID = UnitID
            end
            return self.Bosses[uDetails.name].UnitList[unitID]
        end
    end
end

function TAR:Reset()
    self.EncounterRunning = false
    self.TarJulia.Available = false
    self.TarJulia.UnitID = nil
    self.TarJulia.CastBar:Remove()
    self.Soul.UnitList = {}
    self.PhaseObj:End(Inspect.Time.Real())
end

function TAR:Timer()
end




function TAR:Start()
    -- Create Timers

    -- Create Alerts
    self.TarJulia.AlertsRef.MoltenLava = KBM.Alert:Create(self.Lang.Verbose.MoltenLava[KBM.Lang], 10, true, true, "red")
    KBM.Defaults.AlertObj.Assign(self.TarJulia)

    -- Assign Alerts and Timers to Triggers
    self.TarJulia.Triggers.MoltenLava = KBM.Trigger:Create(self.Lang.Ability.MoltenLava[KBM.Lang], "cast", self.TarJulia)
    self.TarJulia.Triggers.MoltenLava:AddAlert(self.TarJulia.AlertsRef.MoltenLava, true)

    self.TarJulia.CastBar = KBM.Castbar:Add(self, self.TarJulia)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)

end
