-- Beligosh Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOATDBEL_Settings = nil
chKBMPOATDBEL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["Tartaric_Depths"]

local BEL = {
    Directory = Instance.Directory,
    File = "Beligosh.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
    Lang = {},
    ID = "beligosh",
    Object = "BEL",
}

BEL.Beligosh = {
    Mod = BEL,
    Level = "72",
    Active = false,
    Name = "Beligosh",
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U660817DD7F651CD6",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
          Enabled = true,
        },
    },
}

BEL.Golem = {
    Mod = BEL,
    Level = "72",
    Name = "Alavaxian Golem",
    NameShort = "Alavaxian Golem",
    UnitList = {},
    Menu = {},
    UTID = "TODO",
    Ignore = true,
    Type = "multi",
}

KBM.RegisterMod(BEL.ID, BEL)

-- Main Unit Dictionary
BEL.Lang.Unit = {}
BEL.Lang.Unit.Beligosh = KBM.Language:Add(BEL.Beligosh.Name)

-- Ability Dictionary
BEL.Lang.Ability = {}

-- Verbose Dictionary
BEL.Lang.Verbose = {}

-- Buff Dictionary
BEL.Lang.Buff = {}

-- Debuff Dictionary
BEL.Lang.Debuff = {}

-- Description Dictionary
BEL.Lang.Main = {}
BEL.Descript = BEL.Lang.Unit.Beligosh[KBM.Lang]

function BEL:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.Beligosh.Name] = self.Beligosh,
    }
end

function BEL:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.Beligosh.Settings.CastBar,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        -- MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        -- TimersRef = self.Baird.Settings.TimersRef,
        AlertsRef = self.Beligosh.Settings.AlertsRef,
    }
    KBMPOATDBEL_Settings = self.Settings
    chKBMPOATDBEL_Settings = self.Settings
    
end

function BEL:SwapSettings(bool)

    if bool then
        KBMPOATDBEL_Settings = self.Settings
        self.Settings = chKBMPOATDBEL_Settings
    else
        chKBMPOATDBEL_Settings = self.Settings
        self.Settings = KBMPOATDBEL_Settings
    end

end

function BEL:LoadVars() 
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOATDBEL_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOATDBEL_Settings, self.Settings)
    end
    
    if KBM.Options.Character then
        chKBMPOATDBEL_Settings = self.Settings
    else
        KBMPOATDBEL_Settings = self.Settings
    end 
end

function BEL:SaveVars() 
    if KBM.Options.Character then
        chKBMPOATDBEL_Settings = self.Settings
    else
        KBMPOATDBEL_Settings = self.Settings
    end 
end

function BEL:Castbar(units)
end

function BEL:RemoveUnits(UnitID)
    if self.Beligosh.UnitID == UnitID then
        self.Beligosh.Available = false
        return true
    end
    return false
end

function BEL:Death(UnitID)
    if self.Beligosh.UnitID == UnitID then
        self.Beligosh.Dead = true
        return true
    end
    return false
end

function BEL:UnitHPCheck(uDetails, unitID)
    if uDetails and unitID then
        if uDetails.type == self.Beligosh.UTID then
            if not self.EncounterRunning then
                self.EncounterRunning = true
                self.StartTime = Inspect.Time.Real()
                self.HeldTime = self.StartTime
                self.TimeElapsed = 0
                self.Beligosh.Dead = false
                self.Beligosh.Casting = false
                self.Beligosh.CastBar:Create(unitID)
                self.PhaseObj:Start(self.StartTime)
                self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
                self.PhaseObj.Objectives:AddPercent(self.Beligosh, 70, 100)
                self.Phase = 1
            end
            self.Beligosh.UnitID = unitID
            self.Beligosh.Available = true
            return self.Beligosh
        end
    end
end

function BEL:Reset()
    self.EncounterRunning = false
    self.Beligosh.Available = false
    self.Beligosh.UnitID = nil
    self.Beligosh.CastBar:Remove()
        
    self.PhaseObj:End(Inspect.Time.Real())
end

function BEL:Timer()    
end


function BEL.PhaseTwo()
    MLF.PhaseObj.Objectives:Remove()
    if MLF.Phase == 2 then
        MLF.Phase = 3
        MLF.PhaseObj:SetPhase(3)
        MLF.PhaseObj.Objectives:AddPercent(BEL.Beligosh, 40, 70)
    else
        MLF.Phase = 5
        MLF.PhaseObj:SetPhase(5)
        MLF.PhaseObj.Objectives:AddPercent(BEL.Beligosh, 0, 40)
    end
end

function BEL.PhaseFive()
    MLF.PhaseObj.Objectives:Remove()
end

function BEL.AddPhase()
    MLF.PhaseObj.Objectives:Remove()
    if MLF.Phase == 1 then
        MLF.Phase = 2
        MLF.PhaseObj:SetPhase(2)
    else
        MLF.Phase = 4
        MLF.PhaseObj:SetPhase(4)
    end

    MLF.PhaseObj.Objectives:AddDeath(BEL.Golem.name, 3)
end



function BEL:Start()
    -- Create Timers

    -- Create Alerts

    -- Assign Alerts and Timers to Triggers
    self.Beligosh.CastBar = KBM.Castbar:Add(self, self.Beligosh)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)


    self.Beligosh.Triggers.AddPhase = KBM.Trigger:Create(70, "percent", self.Beligosh)
    self.Beligosh.Triggers.AddPhase:AddPhase(self.AddPhase)

--    self.Beligosh.Triggers.PhaseFinal = KBM.Trigger:Create(self.Lang.Notify.PhaseFinal[KBM.Lang], "notify", self.Maelforge)
    self.Beligosh.Triggers.PhaseTwo = KBM.Trigger:Create("Beligosh: Feel the wrath of Beligosh!", "notify", self.Beligosh)
    self.Beligosh.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)

    self.Beligosh.Triggers.AddPhase2 = KBM.Trigger:Create(40, "percent", self.Beligosh)
    self.Beligosh.Triggers.AddPhase2:AddPhase(self.AddPhase)
end
