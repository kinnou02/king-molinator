-- Hexatel Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOAQFHEX_Settings = nil
chKBMPOAQFHEX_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["QF"]

local HEX = {
    Directory = Instance.Directory,
    File = "Hexatel.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
    Lang = {},
    ID = "Hexatel",
    Object = "HEX",
}

HEX.Hexatel = {
    Mod = HEX,
    Level = "??",
    Active = false,
    Name = "Hexatel",
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U39EBAB5973E792B8",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
          Enabled = true,
        },
    },
}


KBM.RegisterMod(HEX.ID, HEX)

-- Main Unit Dictionary
HEX.Lang.Unit = {}
HEX.Lang.Unit.Hexatel = KBM.Language:Add(HEX.Hexatel.Name)

-- Ability Dictionary
HEX.Lang.Ability = {}

-- Verbose Dictionary
HEX.Lang.Verbose = {}

-- Buff Dictionary
HEX.Lang.Buff = {}

-- Debuff Dictionary
HEX.Lang.Debuff = {}

HEX.Lang.Notify = {}

-- Description Dictionary
HEX.Lang.Main = {}
HEX.Descript = HEX.Lang.Unit.Hexatel[KBM.Lang]

function HEX:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.Hexatel.Name] = self.Hexatel,
    }
end

function HEX:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.Hexatel.Settings.CastBar,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        -- MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        -- TimersRef = self.Baird.Settings.TimersRef,
        AlertsRef = self.Hexatel.Settings.AlertsRef,
    }
    KBMPOAQFHEX_Settings = self.Settings
    chKBMPOAQFHEX_Settings = self.Settings

end

function HEX:SwapSettings(bool)

    if bool then
        KBMPOAQFHEX_Settings = self.Settings
        self.Settings = chKBMPOAQFHEX_Settings
    else
        chKBMPOAQFHEX_Settings = self.Settings
        self.Settings = KBMPOAQFHEX_Settings
    end

end

function HEX:LoadVars()
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOAQFHEX_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOAQFHEX_Settings, self.Settings)
    end

    if KBM.Options.Character then
        chKBMPOAQFHEX_Settings = self.Settings
    else
        KBMPOAQFHEX_Settings = self.Settings
    end 
end

function HEX:SaveVars()
    if KBM.Options.Character then
        chKBMPOAQFHEX_Settings = self.Settings
    else
        KBMPOAQFHEX_Settings = self.Settings
    end
end

function HEX:Castbar(units)
end

function HEX:RemoveUnits(UnitID)
    if self.Hexatel.UnitID == UnitID then
        self.Hexatel.Available = false
        return true
    end
    return false
end

function HEX:Death(UnitID)
    if self.Hexatel.UnitID == UnitID then
        self.Hexatel.Dead = true
        return true
    end
    return false
end


function HEX:UnitHPCheck(uDetails, unitID)
    if uDetails and unitID then
        if uDetails.type == self.Hexatel.UTID then
            if not self.EncounterRunning then
                self.EncounterRunning = true
                self.StartTime = Inspect.Time.Real()
                self.HeldTime = self.StartTime
                self.TimeElapsed = 0
                self.Hexatel.Dead = false
                self.Hexatel.Casting = false
                self.Hexatel.CastBar:Create(unitID)
                self.PhaseObj:Start(self.StartTime)
                self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
                self.PhaseObj.Objectives:AddPercent(self.Hexatel, 0, 100)
                self.Phase = 1
            end
            self.Hexatel.UnitID = unitID
            self.Hexatel.Available = true
            return self.Hexatel
        end
    end
end

function HEX:Reset()
    self.EncounterRunning = false
    self.Hexatel.Available = false
    self.Hexatel.UnitID = nil
    self.Hexatel.CastBar:Remove()
    self.PhaseObj:End(Inspect.Time.Real())
end

function HEX:Timer()
end




function HEX:Start()
    -- Create Timers
    -- Create Alerts
    KBM.Defaults.AlertObj.Assign(self.Hexatel)

    -- Assign Alerts and Timers to Triggers
    self.Hexatel.CastBar = KBM.Castbar:Add(self, self.Hexatel)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)

end
