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

-- Main Unit Dictionary
TAR.Lang.Unit = {}
TAR.Lang.Unit.TarJulia = KBM.Language:Add("TarJulia")
TAR.Lang.Unit.TarJulia:SetFrench("TarJulia")
TAR.Lang.Unit.TarJulia:SetGerman("Tarjulia")

TAR.Lang.Unit.Soul = KBM.Language:Add("Infernal Soul")
TAR.Lang.Unit.Soul:SetFrench("Âme infernale")
TAR.Lang.Unit.Soul:SetGerman("Infernalische Seele")

TAR.TarJulia = {
    Mod = TAR,
    Level = "??",
    Active = false,
    Name = TAR.Lang.Unit.TarJulia[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
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
        TimersRef = {
            Enabled = true,
            MoltenLava = KBM.Defaults.TimerObj.Create("red"),
            FirstMoltenLava = KBM.Defaults.TimerObj.Create("red"),
        },
    },
}

TAR.Soul = {
    Mod = TAR,
    Level = "72",
    Name = TAR.Lang.Unit.Soul[KBM.Lang],
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
TAR.Lang.Unit.TarJulia:SetFrench(TAR.TarJulia.Name)
TAR.Lang.Unit.TarJulia:SetGerman("Tarjulia")

TAR.Lang.Unit.Soul = KBM.Language:Add(TAR.Soul.Name)
TAR.Lang.Unit.Soul:SetFrench("Âme infernale")
TAR.Lang.Unit.Soul:SetGerman("Infernalische Seele")

-- Ability Dictionary
TAR.Lang.Ability = {}
TAR.Lang.Ability.MoltenLava = KBM.Language:Add("Molten Blast")
TAR.Lang.Ability.MoltenLava:SetFrench("Explosion de magma")
TAR.Lang.Ability.MoltenLava:SetGerman("Geschmolzene Explosion")

-- Verbose Dictionary
TAR.Lang.Verbose = {}
TAR.Lang.Verbose.MoltenLava = KBM.Language:Add("Go to a pillar!")
TAR.Lang.Verbose.MoltenLava:SetFrench("Allez au pillier!")
TAR.Lang.Verbose.MoltenLava:SetGerman("Geh zur Säule!")

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
        MechTimer = KBM.Defaults.MechTimer(),
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
                KBM.MechTimer:AddStart(self.TarJulia.TimersRef.FirstMoltenLava)
            end
            self.TarJulia.UnitID = unitID
            self.TarJulia.Available = true
            return self.TarJulia
        end
        if uDetails.type == self.Soul.UTID then
           if not self.Bosses[uDetails.name].UnitList[unitID] then
                local SubBossObj = {
                    Mod = TAR,
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
                self.Bosses[uDetails.name].UnitList[unitID].UnitID = unitID
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
    self.TarJulia.TimersRef.FirstMoltenLava = KBM.MechTimer:Add(self.Lang.Ability.MoltenLava[KBM.Lang], 20)
    self.TarJulia.TimersRef.FirstMoltenLava.MenuName = "first molten lava"
    self.TarJulia.TimersRef.MoltenLava = KBM.MechTimer:Add(self.Lang.Ability.MoltenLava[KBM.Lang], 40)
    KBM.Defaults.TimerObj.Assign(self.TarJulia)

    -- Create Alerts
    self.TarJulia.AlertsRef.MoltenLava = KBM.Alert:Create(self.Lang.Verbose.MoltenLava[KBM.Lang], 10, true, true, "red")
    KBM.Defaults.AlertObj.Assign(self.TarJulia)

    -- Assign Alerts and Timers to Triggers
    self.TarJulia.Triggers.MoltenLava = KBM.Trigger:Create(self.Lang.Ability.MoltenLava[KBM.Lang], "cast", self.TarJulia)
    self.TarJulia.Triggers.MoltenLava:AddAlert(self.TarJulia.AlertsRef.MoltenLava, true)
    self.TarJulia.Triggers.MoltenLava:AddTimer(self.TarJulia.TimersRef.MoltenLava)

    self.TarJulia.CastBar = KBM.Castbar:Add(self, self.TarJulia)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)

end
