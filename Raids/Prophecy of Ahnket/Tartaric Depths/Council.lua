-- Council of Fate Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOATDCOF_Settings = nil
chKBMPOATDCOF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["Tartaric_Depths"]

local COF = {
    Directory = Instance.Directory,
    File = "Council.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
    Lang = {},
    ID = "CouncilOfFate",
    Object = "COF",
}

COF.Danazhal = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = "Countessa Danazhal",
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U6551B8383D9BAB5C",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
          Enabled = true,
		  Flamescape = KBM.Defaults.AlertObj.Create("red"),
        },
    },
}

COF.Boldoch = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = "Marchioness Boldoch",
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U71F642FE4F016DEA",
    TimeOut = 5,
    Triggers = {},
}

COF.Pleuzhal = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = "Count Pleuzhal",
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U56368121432B6952",
    TimeOut = 5,
    Triggers = {},
}

COF.DanazhalSoul = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = "Danazhal's Soul",
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U585E5F376A56877C",
    TimeOut = 5,
    Triggers = {},
}

COF.BoldochSoul = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = "Boldoch's Soul",
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U46F19E3B49A30FA8",
    TimeOut = 5,
    Triggers = {},
}

COF.PleuzhalSoul = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = "Pleuzhal's Soul",
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U0E00E54B0D012A6C",
    TimeOut = 5,
    Triggers = {},
}


KBM.RegisterMod(COF.ID, COF)

-- Main Unit Dictionary
COF.Lang.Unit = {}

-- Ability Dictionary
COF.Lang.Ability = {}

-- Verbose Dictionary
COF.Lang.Verbose = {}
COF.Lang.Verbose.Flamescape = KBM.Language:Add("Go into the circle")

-- Buff Dictionary
COF.Lang.Buff = {}

-- Debuff Dictionary
COF.Lang.Debuff = {}


COF.Lang.Notify = {}
COF.Lang.Notify.Flamescape = KBM.Language:Add("The Flamescape begins.")

-- Description Dictionary
COF.Lang.Main = {}
COF.Lang.Main.Descript = KBM.Language:Add("The Council of Fate")
COF.Descript = COF.Lang.Main.Descript[KBM.Lang]

function COF:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.Pleuzhal.Name] = self.Pleuzhal,
        [self.Boldoch.Name] = self.Boldoch,
        [self.Danazhal.Name] = self.Danazhal,
        [self.PleuzhalSoul.Name] = self.PleuzhalSoul,
        [self.BoldochSoul.Name] = self.BoldochSoul,
        [self.DanazhalSoul.Name] = self.DanazhalSoul,
    }
end

function COF:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.Danazhal.Settings.CastBar,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        -- MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        -- TimersRef = self.Baird.Settings.TimersRef,
        AlertsRef = self.Danazhal.Settings.AlertsRef,
    }
    KBMPOATDCOF_Settings = self.Settings
    chKBMPOATDCOF_Settings = self.Settings

end

function COF:SwapSettings(bool)

    if bool then
        KBMPOATDCOF_Settings = self.Settings
        self.Settings = chKBMPOATDCOF_Settings
    else
        chKBMPOATDCOF_Settings = self.Settings
        self.Settings = KBMPOATDCOF_Settings
    end

end

function COF:LoadVars()
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOATDCOF_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOATDCOF_Settings, self.Settings)
    end

    if KBM.Options.Character then
        chKBMPOATDCOF_Settings = self.Settings
    else
        KBMPOATDCOF_Settings = self.Settings
    end
end

function COF:SaveVars()
    if KBM.Options.Character then
        chKBMPOATDCOF_Settings = self.Settings
    else
        KBMPOATDCOF_Settings = self.Settings
    end
end

function COF:Castbar(units)
end

function COF:RemoveUnits(UnitID)
    return false
end

function COF:SetObjectives()
    COF.PhaseObj.Objectives:Remove()
    if not COF.Danazhal.Dead then
        COF.PhaseObj.Objectives:AddPercent(COF.Danazhal, 0, 100)
    end
    if not COF.Boldoch.Dead then
        COF.PhaseObj.Objectives:AddPercent(COF.Boldoch, 0, 100)
    end
    if not COF.Pleuzhal.Dead then
        COF.PhaseObj.Objectives:AddPercent(COF.Pleuzhal, 0, 100)
    end
end

function COF:Death(UnitID)
    if self.Danazhal.UnitID == UnitID then
        self.Danazhal.Dead = true
        self.SetObjectives()
    end
    if self.Boldoch.UnitID == UnitID then
        self.Boldoch.Dead = true
        self.SetObjectives()
    end
    if self.Pleuzhal.UnitID == UnitID then
        self.Pleuzhal.Dead = true
        self.SetObjectives()
    end
    if self.Danazhal.Dead and self.Boldoch.Dead and self.Pleuzhal.Dead then
        return true
    end
    return false
end

function COF:UnitHPCheck(uDetails, unitID)
    if uDetails and unitID then
        if self.Bosses[uDetails.name] then
            local BossObj = self.Bosses[uDetails.name]
            if not self.EncounterRunning then
                self.EncounterRunning = true
                self.StartTime = Inspect.Time.Real()
                self.HeldTime = self.StartTime
                self.TimeElapsed = 0
                self.PhaseObj:Start(self.StartTime)
                self.PhaseObj:SetPhase("1")
                self.Phase = 1
                self.SetObjectives()
            end
            BossObj.Dead = false
            BossObj.Casting = false
            --BossObj.CastBar:Create(unitID)
            BossObj.UnitID = unitID
            BossObj.Available = true
            return BossObj
        end
    end
end

function COF:Reset()
    self.EncounterRunning = false
    self.Danazhal.Available = false
    self.Boldoch.Available = false
    self.Pleuzhal.Available = false
    self.Danazhal.UnitID = nil
    self.Boldoch.UnitID = nil
    self.Pleuzhal.UnitID = nil
    self.Danazhal.CastBar:Remove()
    self.Boldoch.CastBar:Remove()
    self.Pleuzhal.CastBar:Remove()

    self.PhaseObj:End(Inspect.Time.Real())
end

function COF:Timer()
end



function COF:Start()
    -- Create Timers

    -- Create Alerts
    self.Danazhal.AlertsRef.Flamescape = KBM.Alert:Create(self.Lang.Verbose.Flamescape[KBM.Lang], 3, true, true, "red")
    KBM.Defaults.AlertObj.Assign(self.Danazhal)

    -- Assign Alerts and Timers to Triggers
    self.Danazhal.Triggers.Flamescape = KBM.Trigger:Create(self.Lang.Notify.Flamescape[KBM.Lang], "notify", self.Danazhal)
    self.Danazhal.Triggers.Flamescape:AddAlert(self.Danazhal.AlertsRef.Flamescape)

    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)

end
