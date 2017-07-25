-- Council of Fate Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOANMTDCOF_Settings = nil
chKBMPOANMTDCOF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["NMTD"]

local COF = {
    Directory = Instance.Directory,
    File = "Council.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
    Lang = {},
    ID = "NMCouncilOfFate",
    Object = "COF",
}

-- Main Unit Dictionary
COF.Lang.Unit = {}
COF.Lang.Unit.Boldoch = KBM.Language:Add("Marchioness Boldoch")
COF.Lang.Unit.Boldoch:SetGerman("Markgräfin Boldoch")
COF.Lang.Unit.Boldoch:SetFrench("Marquise Boldoch")

COF.Lang.Unit.Danazhal = KBM.Language:Add("Countessa Danazhal")
COF.Lang.Unit.Danazhal:SetGerman("Gräfin Danazhal")
COF.Lang.Unit.Danazhal:SetFrench("Countessa Danazhal")

COF.Lang.Unit.Pleuzhal = KBM.Language:Add("Count Pleuzhal")
COF.Lang.Unit.Pleuzhal:SetGerman("Graf Pleuzhal")
COF.Lang.Unit.Pleuzhal:SetFrench("Comte Pluezhal")

COF.Lang.Unit.BoldochSoul = KBM.Language:Add("Boldoch's Soul")
COF.Lang.Unit.BoldochSoul:SetGerman("Boldochs Seele")
COF.Lang.Unit.BoldochSoul:SetFrench("Âme de Boldoch")

COF.Lang.Unit.DanazhalSoul = KBM.Language:Add("Danazhal's Soul")
COF.Lang.Unit.DanazhalSoul:SetGerman("Danazhals Seele")
COF.Lang.Unit.DanazhalSoul:SetFrench("Âme de Danazhal")

COF.Lang.Unit.PleuzhalSoul = KBM.Language:Add("Pleuzhal's Soul")
COF.Lang.Unit.PleuzhalSoul:SetGerman("Pleuzhals Seele")
COF.Lang.Unit.PleuzhalSoul:SetFrench("Âme de Pluezhal")

COF.Lang.Unit.Void = KBM.Language:Add("VOID")
COF.Lang.Unit.Void:SetGerman("LEERE")
COF.Lang.Unit.Void:SetFrench("NÉANT")

COF.Danazhal = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = COF.Lang.Unit.Danazhal[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "UFFF856927624DD2B",
    TimeOut = 60,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
            Enabled = true,
            Flamescape = KBM.Defaults.AlertObj.Create("red"),
            Void = KBM.Defaults.AlertObj.Create("blue"),
        },
        TimersRef = {
            Enabled = true,
            FirstFlamescape = KBM.Defaults.TimerObj.Create("red"),
            Flamescape = KBM.Defaults.TimerObj.Create("red"),
        },
    },
}

COF.Boldoch = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = COF.Lang.Unit.Boldoch[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U1758766E2477C75B",
    TimeOut = 15,
    Triggers = {},
}

COF.Pleuzhal = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = COF.Lang.Unit.Pleuzhal[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U2A504B2C6EA2DBD1",
    TimeOut = 15,
    Triggers = {},
}

COF.DanazhalSoul = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = COF.Lang.Unit.DanazhalSoul[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U2064EA8577C6F272",
    TimeOut = 15,
    Triggers = {},
}

COF.BoldochSoul = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = COF.Lang.Unit.BoldochSoul[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U7A7C09BA76C48142",
    TimeOut = 15,
    Triggers = {},
}

COF.PleuzhalSoul = {
    Mod = COF,
    Level = "??",
    Active = false,
    Name = COF.Lang.Unit.PleuzhalSoul[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U2999D7887984DE0F",
    TimeOut = 15,
    Triggers = {},
}

COF.Void = {
    Mod = COF,
    Level = "72",
    Name = COF.Lang.Unit.Void[KBM.Lang],
    UnitList = {},
    UTID = "U16EAD450095AF958",
    TimeOut = 15,
    Ignore = true,
    Type = "multi",
}

KBM.RegisterMod(COF.ID, COF)


-- Ability Dictionary
COF.Lang.Ability = {}
COF.Lang.Ability.Flamescape = KBM.Language:Add("Flamescape")
COF.Lang.Ability.Flamescape:SetGerman("Flammenformen")
COF.Lang.Ability.Flamescape:SetFrench("Pyroformation")

-- Verbose Dictionary
COF.Lang.Verbose = {}
COF.Lang.Verbose.Flamescape = KBM.Language:Add("Flamescape")
-- TODO: transF, transG (check themm, got it from above)
COF.Lang.Verbose.Flamescape:SetGerman("Flammenformen")
COF.Lang.Verbose.Flamescape:SetFrench("Pyroformation")

-- Buff Dictionary
COF.Lang.Buff = {}

-- Debuff Dictionary
COF.Lang.Debuff = {}

-- Notify Dictionary
COF.Lang.Notify = {}
COF.Lang.Notify.Flamescape = KBM.Language:Add("The Flamescape begins.")
COF.Lang.Notify.Flamescape:SetGerman("Das Flammenformen beginnt.")
 COF.Lang.Notify.Flamescape:SetFrench("La Pyroformation commence.")

COF.Lang.Notify.DanazhalPop = KBM.Language:Add('Contessa Danazhal, "Did you release me? Wonderful! I shall escape after I fest on your souls!"')
COF.Lang.Notify.DanazhalPop:SetGerman('Gräfin Danazhal: "Ihr wart es, der mich befreite? Wunderbar! Nachdem ich mich an Euren Seelen gelabt habe, werde ich das Weite suchen!"')
COF.Lang.Notify.DanazhalPop:SetFrench('Countessa Danazhal : "Vous m\'avez libérée ? Magnifique ! Je m\'enfuirai dès que j\'aurai dévoré vos âmes !"')

-- Menu Dictionary
COF.Lang.Menu = {}
COF.Lang.Menu.FirstFlamescape = KBM.Language:Add("First " .. COF.Lang.Ability.Flamescape[KBM.Lang])
COF.Lang.Menu.FirstFlamescape:SetFrench("Première " .. COF.Lang.Ability.Flamescape[KBM.Lang])
COF.Lang.Menu.FirstFlamescape:SetGerman("Erstes ".. COF.Lang.Ability.Flamescape[KBM.Lang])

-- Description Dictionary
COF.Lang.Main = {}
COF.Lang.Main.Descript = KBM.Language:Add("The Council of Fate")
COF.Lang.Main.Descript:SetGerman("Rat des Schicksals")
COF.Lang.Main.Descript:SetFrench("Council du destin")

COF.Descript = COF.Lang.Main.Descript[KBM.Lang]

function COF:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.Danazhal.Name] = self.Danazhal,
        [self.Pleuzhal.Name] = self.Pleuzhal,
        [self.Boldoch.Name] = self.Boldoch,
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
        MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        TimersRef = self.Danazhal.Settings.TimersRef,
        AlertsRef = self.Danazhal.Settings.AlertsRef,
    }
    KBMPOANMTDCOF_Settings = self.Settings
    chKBMPOANMTDCOF_Settings = self.Settings

end

function COF:SwapSettings(bool)

    if bool then
        KBMPOANMTDCOF_Settings = self.Settings
        self.Settings = chKBMPOANMTDCOF_Settings
    else
        chKBMPOANMTDCOF_Settings = self.Settings
        self.Settings = KBMPOANMTDCOF_Settings
    end

end

function COF:LoadVars()
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOANMTDCOF_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOANMTDCOF_Settings, self.Settings)
    end

    if KBM.Options.Character then
        chKBMPOANMTDCOF_Settings = self.Settings
    else
        KBMPOANMTDCOF_Settings = self.Settings
    end
end

function COF:SaveVars()
    if KBM.Options.Character then
        chKBMPOANMTDCOF_Settings = self.Settings
    else
        KBMPOANMTDCOF_Settings = self.Settings
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

function COF:ResetTimers()
    KBM.MechTimer:AddRemove(self.Danazhal.TimersRef.Flamescape)
    if not self.Danazhal.Dead then
        KBM.MechTimer:AddStart(self.Danazhal.TimersRef.FirstFlamescape)
    end
end

function COF:Death(UnitID)
    if self.Danazhal.UnitID == UnitID then
        self.Danazhal.Dead = true
        self.SetObjectives()
        self:ResetTimers()
    end
    if self.Boldoch.UnitID == UnitID then
        self.Boldoch.Dead = true
        self.SetObjectives()
        self:ResetTimers()
    end
    if self.Pleuzhal.UnitID == UnitID then
        self.Pleuzhal.Dead = true
        self.SetObjectives()
        self:ResetTimers()
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
                KBM.MechTimer:AddStart(self.Danazhal.TimersRef.FirstFlamescape)
            end
            BossObj.Dead = false
            BossObj.Casting = false
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

    self.PhaseObj:End(Inspect.Time.Real())
end

function COF:Timer()
end

function COF:Start()
    -- Create Timers
    self.Danazhal.TimersRef.FirstFlamescape = KBM.MechTimer:Add(self.Lang.Ability.Flamescape[KBM.Lang], 22)
    self.Danazhal.TimersRef.FirstFlamescape.MenuName = self.Lang.Menu.FirstFlamescape[KBM.Lang]
    self.Danazhal.TimersRef.Flamescape = KBM.MechTimer:Add(self.Lang.Ability.Flamescape[KBM.Lang], 40)
    KBM.Defaults.TimerObj.Assign(self.Danazhal)

    -- Create Alerts
    self.Danazhal.AlertsRef.Flamescape = KBM.Alert:Create(self.Lang.Verbose.Flamescape[KBM.Lang], 5, true, true, "red")
    self.Danazhal.AlertsRef.Void = KBM.Alert:Create(self.Lang.Unit.Void[KBM.Lang], nil, true, true, "blue")
    KBM.Defaults.AlertObj.Assign(self.Danazhal)

    -- Assign Alerts and Timers to Triggers
    self.Danazhal.Triggers.Flamescape = KBM.Trigger:Create(self.Lang.Notify.Flamescape[KBM.Lang], "notify", self.Danazhal)
    self.Danazhal.Triggers.Flamescape:AddAlert(self.Danazhal.AlertsRef.Flamescape)
    self.Danazhal.Triggers.Flamescape:AddTimer(self.Danazhal.TimersRef.Flamescape)

    self.Danazhal.Triggers.Flamescape = KBM.Trigger:Create(self.Lang.Notify.DanazhalPop[KBM.Lang], "notify", self.Danazhal)
    self.Danazhal.Triggers.Flamescape:AddTimer(self.Danazhal.TimersRef.FirstFlamescape)

    self.Danazhal.Triggers.Void = KBM.Trigger:Create("", "npcDamage", self.Void)
    self.Danazhal.Triggers.Void:AddAlert(self.Danazhal.AlertsRef.Void)

    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)

end
