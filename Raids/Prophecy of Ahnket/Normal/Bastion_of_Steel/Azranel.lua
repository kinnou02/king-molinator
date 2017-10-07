-- Azranel Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOABOSAZR_Settings = nil
chKBMPOABOSAZR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["BoS"]

local AZR = {
    Directory = Instance.Directory,
    File = "Azranel.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
    Lang = {},
    ID = "Azranel",
    Object = "AZR",
}

-- Main Unit Dictionary
AZR.Lang.Unit = {}
AZR.Lang.Unit.Azranel = KBM.Language:Add("Azranel")
--AZR.Lang.Unit.Azranel:SetFrench("Azranel") TODO transF
--AZR.Lang.Unit.Azranel:SetGerman("Azranel") TODO transG


AZR.Azranel = {
    Mod = AZR,
    Level = "72",
    Active = false,
    Name = AZR.Lang.Unit.Azranel[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U463D232719096CF0",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
          Enabled = true,
          MissileStorm = KBM.Defaults.AlertObj.Create("red"),
          CometShot = KBM.Defaults.AlertObj.Create("blue"),
        },
        TimersRef = {
            Enabled = true,
            FirstMissileStorm = KBM.Defaults.TimerObj.Create("red"),
            MissileStorm = KBM.Defaults.TimerObj.Create("red"),
            FirstCometShot = KBM.Defaults.TimerObj.Create("blue"),
            CometShot = KBM.Defaults.TimerObj.Create("blue"),
        },
    },
}


KBM.RegisterMod(AZR.ID, AZR)

-- Ability Dictionary
AZR.Lang.Ability = {}
AZR.Lang.Ability.MissileStorm = KBM.Language:Add("Missile Storm") --TODO transF transG
AZR.Lang.Ability.CometShot = KBM.Language:Add("Comet Shot") --TODO transF transG

-- Verbose Dictionary
AZR.Lang.Verbose = {}

-- Buff Dictionary
AZR.Lang.Buff = {}

-- Debuff Dictionary
AZR.Lang.Debuff = {}

-- Notify Dictionary
AZR.Lang.Notify = {}

-- Description Dictionary
AZR.Lang.Main = {}
AZR.Descript = AZR.Lang.Unit.Azranel[KBM.Lang]

-- Menu Dictionary
AZR.Lang.Menu = {}
AZR.Lang.Menu.FirstCometShot = KBM.Language:Add("First " .. AZR.Lang.Ability.CometShot[KBM.Lang])
AZR.Lang.Menu.FirstCometShot:SetFrench("Premier " .. AZR.Lang.Ability.CometShot[KBM.Lang])
AZR.Lang.Menu.FirstCometShot:SetGerman("Erste " .. AZR.Lang.Ability.CometShot[KBM.Lang])

AZR.Lang.Menu.FirstMissileStorm = KBM.Language:Add("First " .. AZR.Lang.Ability.MissileStorm[KBM.Lang])
AZR.Lang.Menu.FirstMissileStorm:SetFrench("Premier " .. AZR.Lang.Ability.MissileStorm[KBM.Lang])
AZR.Lang.Menu.FirstMissileStorm:SetGerman("Erste " .. AZR.Lang.Ability.MissileStorm[KBM.Lang])


function AZR:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.Azranel.Name] = self.Azranel,
    }
end

function AZR:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.Azranel.Settings.CastBar,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        -- TimersRef = self.Baird.Settings.TimersRef,
        AlertsRef = self.Azranel.Settings.AlertsRef,
    }
    KBMPOABOSAZR_Settings = self.Settings
    chKBMPOABOSAZR_Settings = self.Settings

end

function AZR:SwapSettings(bool)

    if bool then
        KBMPOABOSAZR_Settings = self.Settings
        self.Settings = chKBMPOABOSAZR_Settings
    else
        chKBMPOABOSAZR_Settings = self.Settings
        self.Settings = KBMPOABOSAZR_Settings
    end

end

function AZR:LoadVars()
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOABOSAZR_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOABOSAZR_Settings, self.Settings)
    end

    if KBM.Options.Character then
        chKBMPOABOSAZR_Settings = self.Settings
    else
        KBMPOABOSAZR_Settings = self.Settings
    end 
end

function AZR:SaveVars()
    if KBM.Options.Character then
        chKBMPOABOSAZR_Settings = self.Settings
    else
        KBMPOABOSAZR_Settings = self.Settings
    end
end

function AZR:Castbar(units)
end

function AZR:RemoveUnits(UnitID)
    if self.Azranel.UnitID == UnitID then
        self.Azranel.Available = false
        return true
    end
    return false
end

function AZR:Death(UnitID)
    if self.Azranel.UnitID == UnitID then
        self.Azranel.Dead = true
        return true
    end
    return false
end

function AZR:UnitHPCheck(uDetails, unitID)
    if uDetails and unitID then
        if uDetails.type == self.Azranel.UTID then
            if not self.EncounterRunning then
                self.EncounterRunning = true
                self.StartTime = Inspect.Time.Real()
                self.HeldTime = self.StartTime
                self.TimeElapsed = 0
                self.Azranel.Dead = false
                self.Azranel.Casting = false
                self.Azranel.CastBar:Create(unitID)
                self.PhaseObj:Start(self.StartTime)
                self.PhaseObj:SetPhase(self.Azranel.Name)
                self.PhaseObj.Objectives:AddPercent(self.Azranel, 0, 100)
                self.Phase = 1
                KBM.MechTimer:AddStart(AZR.Azranel.TimersRef.FirstCometShot)
                KBM.MechTimer:AddStart(AZR.Azranel.TimersRef.FirstMissileStorm)
            end
            self.Azranel.UnitID = unitID
            self.Azranel.Available = true
            return self.Azranel
        end
    end
end

function AZR:Reset()
    self.EncounterRunning = false
    self.Azranel.Available = false
    self.Azranel.UnitID = nil
    self.Azranel.CastBar:Remove()

    self.PhaseObj:End(Inspect.Time.Real())
end

function AZR:Timer()
end


function AZR:Start()
    -- Create Timers
    self.Azranel.TimersRef.FirstCometShot = KBM.MechTimer:Add(self.Lang.Ability.CometShot[KBM.Lang], 90)
    self.Azranel.TimersRef.FirstCometShot.MenuName = self.Lang.Menu.FirstCometShot[KBM.Lang]
    self.Azranel.TimersRef.CometShot = KBM.MechTimer:Add(self.Lang.Ability.CometShot[KBM.Lang], 115)
    
    self.Azranel.TimersRef.FirstMissileStorm = KBM.MechTimer:Add(self.Lang.Ability.MissileStorm[KBM.Lang], 20)
    self.Azranel.TimersRef.FirstMissileStorm.MenuName = self.Lang.Menu.FirstMissileStorm[KBM.Lang]
    self.Azranel.TimersRef.MissileStorm = KBM.MechTimer:Add(self.Lang.Ability.MissileStorm[KBM.Lang], 25)
    KBM.Defaults.TimerObj.Assign(self.Azranel)

    -- Create Alerts
    self.Azranel.AlertsRef.MissileStorm = KBM.Alert:Create(self.Lang.Ability.MissileStorm[KBM.Lang], 2, true, true, "red")
    self.Azranel.AlertsRef.CometShot = KBM.Alert:Create(self.Lang.Ability.CometShot[KBM.Lang], 2, true, true, "blue")
    KBM.Defaults.AlertObj.Assign(self.Azranel)

    -- Assign Alerts and Timers to Triggers
    self.Azranel.CastBar = KBM.Castbar:Add(self, self.Azranel)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
    
    self.Azranel.Triggers.MissileStorm = KBM.Trigger:Create(self.Lang.Ability.MissileStorm[KBM.Lang], "playerDebuff", self.Azranel)
    self.Azranel.Triggers.MissileStorm:AddAlert(self.Azranel.AlertsRef.MissileStorm)
    self.Azranel.Triggers.MissileStorm:AddTimer(self.Azranel.TimersRef.MissileStorm)
    
    
    self.Azranel.Triggers.CometShot = KBM.Trigger:Create(self.Lang.Ability.CometShot[KBM.Lang], "playerDebuff", self.Azranel)
    self.Azranel.Triggers.CometShot:AddAlert(self.Azranel.AlertsRef.CometShot)
    self.Azranel.Triggers.CometShot:AddTimer(self.Azranel.TimersRef.CometShot)
end
