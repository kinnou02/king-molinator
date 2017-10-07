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

local Instance = KBM.BossMod["BOS"]

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
--AZR.Lang.Unit.Azranel:SetFrench("Azranel") todo transF
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
    UTID = "TODO",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
          Enabled = true,
        },
        TimersRef = {
            Enabled = true,
        },
    },
}


KBM.RegisterMod(AZR.ID, AZR)

-- Ability Dictionary
AZR.Lang.Ability = {}

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
    --KBM.Defaults.TimerObj.Assign(self.Azranel)

    -- Create Alerts
    --KBM.Defaults.AlertObj.Assign(self.Azranel)

    -- Assign Alerts and Timers to Triggers
    self.Azranel.CastBar = KBM.Castbar:Add(self, self.Azranel)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
end
