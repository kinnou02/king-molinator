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
    Enrage = 480,
}

-- Main Unit Dictionary
AZR.Lang.Unit = {}
AZR.Lang.Unit.Azranel = KBM.Language:Add("Azranel")
AZR.Lang.Unit.Azranel:SetFrench("Azranel")
AZR.Lang.Unit.Azranel:SetGerman("Azranel")


AZR.Azranel = {
    Mod = AZR,
    Level = "72",
    Active = false,
    Name = AZR.Lang.Unit.Azranel[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
    MechRef = {},
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
          MissileStorm = KBM.Defaults.AlertObj.Create("yellow"),
          CometShot = KBM.Defaults.AlertObj.Create("red"),
          DefensiveSpin = KBM.Defaults.AlertObj.Create("purple"),
        },
        TimersRef = {
            Enabled = true,
            FirstMissileStorm = KBM.Defaults.TimerObj.Create("yellow"),
            MissileStorm = KBM.Defaults.TimerObj.Create("yellow"),
            FirstCometShot = KBM.Defaults.TimerObj.Create("red"),
            CometShot = KBM.Defaults.TimerObj.Create("red"),
            DefensiveSpin = KBM.Defaults.TimerObj.Create("purple"),
        },
        MechRef = {
            Enabled = true,
            MissileStorm = KBM.Defaults.MechObj.Create("yellow"),
        },
    },
}


KBM.RegisterMod(AZR.ID, AZR)

-- Ability Dictionary
AZR.Lang.Ability = {}
AZR.Lang.Ability.MissileStorm = KBM.Language:Add("Missile Storm") --TODO transG
AZR.Lang.Ability.MissileStorm:SetFrench("Tempête de missiles")

AZR.Lang.Ability.CometShot = KBM.Language:Add("Comet Shot") --TODO transG
AZR.Lang.Ability.MissileStorm:SetFrench("Tir de comète")

AZR.Lang.Ability.DefensiveSpin = KBM.Language:Add("Defensive Spin") --TODO transG
AZR.Lang.Ability.DefensiveSpin:SetFrench("Defensive Spin")

-- Verbose Dictionary
AZR.Lang.Verbose = {}

-- Buff Dictionary
AZR.Lang.Buff = {}

-- Debuff Dictionary
AZR.Lang.Debuff = {}
AZR.Lang.Debuff.LaserCutter = KBM.Language:Add("Laser Cutter")--TODO transG
AZR.Lang.Debuff.LaserCutter:SetFrench("Coupeur Laser")

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
        MechSpy = KBM.Defaults.MechSpy(),
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
                self.PhaseObj.Objectives:AddPercent(self.Azranel, 0, 75)
                self.Phase = 1
                KBM.MechTimer:AddStart(AZR.Azranel.TimersRef.FirstCometShot)
                KBM.MechTimer:AddStart(AZR.Azranel.TimersRef.FirstMissileStorm)
                KBM.TankSwap:Start(self.Lang.Debuff.LaserCutter[KBM.Lang], unitID)
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


function AZR.PhaseTwo()
    AZR.PhaseObj.Objectives:Remove()
    AZR.Phase = 2
    AZR.PhaseObj:SetPhase(2)
    AZR.PhaseObj.Objectives:AddPercent(AZR.Azranel, 50, 75)
end

function AZR.PhaseThree()
    AZR.PhaseObj.Objectives:Remove()
    AZR.Phase = 3
    AZR.PhaseObj:SetPhase(3)
    AZR.PhaseObj.Objectives:AddPercent(AZR.Azranel, 0, 50)
end


function AZR:Start()
    -- Create Timers
    self.Azranel.TimersRef.FirstCometShot = KBM.MechTimer:Add(self.Lang.Ability.CometShot[KBM.Lang], 90)
    self.Azranel.TimersRef.FirstCometShot.MenuName = self.Lang.Menu.FirstCometShot[KBM.Lang]
    self.Azranel.TimersRef.CometShot = KBM.MechTimer:Add(self.Lang.Ability.CometShot[KBM.Lang], 115)
    
    self.Azranel.TimersRef.FirstMissileStorm = KBM.MechTimer:Add(self.Lang.Ability.MissileStorm[KBM.Lang], 20)
    self.Azranel.TimersRef.FirstMissileStorm.MenuName = self.Lang.Menu.FirstMissileStorm[KBM.Lang]
    self.Azranel.TimersRef.MissileStorm = KBM.MechTimer:Add(self.Lang.Ability.MissileStorm[KBM.Lang], 25)

    self.Azranel.TimersRef.DefensiveSpin = KBM.MechTimer:Add(self.Lang.Ability.DefensiveSpin[KBM.Lang], 46)
    KBM.Defaults.TimerObj.Assign(self.Azranel)
    
    -- MechSpy
    self.Azranel.MechRef.MissileStorm = KBM.MechSpy:Add(self.Lang.Ability.MissileStorm[KBM.Lang], nil, "playerDebuff", self.Azranel)
    KBM.Defaults.MechObj.Assign(self.Azranel)

    -- Create Alerts
    self.Azranel.AlertsRef.MissileStorm = KBM.Alert:Create(self.Lang.Ability.MissileStorm[KBM.Lang], nil, true, true, "yellow")
    self.Azranel.AlertsRef.CometShot = KBM.Alert:Create(self.Lang.Ability.CometShot[KBM.Lang], 2, true, true, "red")

    self.Azranel.AlertsRef.DefensiveSpin = KBM.Alert:Create(self.Lang.Ability.DefensiveSpin[KBM.Lang], 2, true, true, "purple")
    KBM.Defaults.AlertObj.Assign(self.Azranel)

    -- Assign Alerts and Timers to Triggers
    self.Azranel.CastBar = KBM.Castbar:Add(self, self.Azranel)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
    
    self.Azranel.Triggers.MissileStorm = KBM.Trigger:Create(self.Lang.Ability.MissileStorm[KBM.Lang], "playerDebuff", self.Azranel)
    self.Azranel.Triggers.MissileStorm:AddAlert(self.Azranel.AlertsRef.MissileStorm, true)
    self.Azranel.Triggers.MissileStorm:AddTimer(self.Azranel.TimersRef.MissileStorm)
    self.Azranel.Triggers.MissileStorm:AddSpy(self.Azranel.MechRef.MissileStorm)
    
    
    self.Azranel.Triggers.CometShot = KBM.Trigger:Create(self.Lang.Ability.CometShot[KBM.Lang], "playerDebuff", self.Azranel)
    self.Azranel.Triggers.CometShot:AddAlert(self.Azranel.AlertsRef.CometShot)
    self.Azranel.Triggers.CometShot:AddTimer(self.Azranel.TimersRef.CometShot)

    self.Azranel.Triggers.DefensiveSpin = KBM.Trigger:Create(self.Lang.Ability.DefensiveSpin[KBM.Lang], "channel", self.Azranel)
    self.Azranel.Triggers.DefensiveSpin:AddTimer(self.Azranel.TimersRef.DefensiveSpin)
    self.Azranel.Triggers.DefensiveSpin:AddAlert(self.Azranel.AlertsRef.DefensiveSpin)
    
    self.Azranel.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Azranel)
    self.Azranel.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
    
    self.Azranel.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Azranel)
    self.Azranel.Triggers.PhaseThree:AddPhase(self.PhaseThree)
end
