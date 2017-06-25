-- Malannon Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOATDMAL_Settings = nil
chKBMPOATDMAL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["Tartaric_Depths"]

local MAL = {
    Directory = Instance.Directory,
    File = "Malannon.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
    Lang = {},
    ID = "malannon",
    Object = "MAL",
}

MAL.Malannon = {
    Mod = MAL,
    Level = "??",
    Active = false,
    Name = "Malannon",
    Menu = {},
    AlertsRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U2C9845D71E916D65",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
            Enabled = true,
            Meteor = KBM.Defaults.AlertObj.Create("red"),
            Blastback = KBM.Defaults.AlertObj.Create("blue"),
            MarkOfAcrimony = KBM.Defaults.AlertObj.Create("purple"),
            MarkOfSupremacy = KBM.Defaults.AlertObj.Create("yellow"),
        },
    },
}

KBM.RegisterMod(MAL.ID, MAL)

-- Main Unit Dictionary
MAL.Lang.Unit = {}
MAL.Lang.Unit.Malannon = KBM.Language:Add(MAL.Malannon.Name)
MAL.Lang.Unit.Malannon:SetFrench("Malannon")
MAL.Lang.Unit.Malannon:SetGerman("Malannon")

-- Ability Dictionary
MAL.Lang.Ability = {}
MAL.Lang.Ability.Meteor = KBM.Language:Add("Meteor")
MAL.Lang.Ability.Meteor:SetFrench("Météore")
MAL.Lang.Ability.Meteor:SetGerman("Meteor")

-- Verbose Dictionary
MAL.Lang.Verbose = {}
MAL.Lang.Verbose.Meteor = KBM.Language:Add("Pack!")
MAL.Lang.Verbose.Meteor:SetFrench("Pack!")
MAL.Lang.Verbose.Meteor:SetGerman("Sammeln!")

MAL.Lang.Verbose.Blastback = KBM.Language:Add("Spread out!")
MAL.Lang.Verbose.Blastback:SetFrench("Spread out!")
MAL.Lang.Verbose.Blastback:SetGerman("Verteilen!")

MAL.Lang.Verbose.MarkOfAcrimony = KBM.Language:Add("Go to purple circle!")
MAL.Lang.Verbose.MarkOfAcrimony:SetFrench("Allez dans le cercle violet!")
MAL.Lang.Verbose.MarkOfAcrimony:SetGerman("Geh in den lilanen Kreis!")

MAL.Lang.Verbose.MarkOfSupremacy = KBM.Language:Add("Go to yellow circle!")
MAL.Lang.Verbose.MarkOfSupremacy:SetFrench("Allez dans le cercle jaune!")
MAL.Lang.Verbose.MarkOfSupremacy:SetGerman("Geh in den gelben Kreis!")


-- Buff Dictionary
MAL.Lang.Buff = {}

-- Debuff Dictionary
MAL.Lang.Debuff = {}
MAL.Lang.Debuff.Blastback = KBM.Language:Add("Blastback")
MAL.Lang.Debuff.Blastback:SetGerman("Rückdruckwelle")

MAL.Lang.Debuff.MarkOfAcrimony = KBM.Language:Add("Mark of Acrimony")
MAL.Lang.Debuff.MarkOfAcrimony:SetGerman("Signum der Verbitterung")
MAL.Lang.Debuff.MarkOfAcrimony:SetFrench("Marque d'amertume")

MAL.Lang.Debuff.MarkOfSupremacy = KBM.Language:Add("Mark of Supremacy")
MAL.Lang.Debuff.MarkOfSupremacy:SetGerman("Signum der Vormachtstellung")
-- MAL.Lang.Debuff.MarkOfAcrimony:SetFrench("Marque d'amertume") -- Seems to be the wrong Mark which is triggered in French


MAL.Lang.Notify = {}

-- Description Dictionary
MAL.Lang.Main = {}
MAL.Descript = MAL.Lang.Unit.Malannon[KBM.Lang]

function MAL:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.Malannon.Name] = self.Malannon,
    }
end

function MAL:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.Malannon.Settings.CastBar,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        -- MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        -- TimersRef = self.Baird.Settings.TimersRef,
        AlertsRef = self.Malannon.Settings.AlertsRef,
    }
    KBMPOATDMAL_Settings = self.Settings
    chKBMPOATDMAL_Settings = self.Settings

end

function MAL:SwapSettings(bool)

    if bool then
        KBMPOATDMAL_Settings = self.Settings
        self.Settings = chKBMPOATDMAL_Settings
    else
        chKBMPOATDMAL_Settings = self.Settings
        self.Settings = KBMPOATDMAL_Settings
    end

end

function MAL:LoadVars() 
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOATDMAL_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOATDMAL_Settings, self.Settings)
    end

    if KBM.Options.Character then
        chKBMPOATDMAL_Settings = self.Settings
    else
        KBMPOATDMAL_Settings = self.Settings
    end
end

function MAL:SaveVars() 
    if KBM.Options.Character then
        chKBMPOATDMAL_Settings = self.Settings
    else
        KBMPOATDMAL_Settings = self.Settings
    end 
end

function MAL:Castbar(units)
end

function MAL:RemoveUnits(UnitID)
    if self.Malannon.UnitID == UnitID then
        self.Malannon.Available = false
        return true
    end
    return false
end

function MAL:Death(UnitID)
    if self.Malannon.UnitID == UnitID then
        self.Malannon.Dead = true
        return true
    end
    return false
end

function MAL:UnitHPCheck(uDetails, unitID)
    if uDetails and unitID then
        if uDetails.type == self.Malannon.UTID then
            if not self.EncounterRunning then
                self.EncounterRunning = true
                self.StartTime = Inspect.Time.Real()
                self.HeldTime = self.StartTime
                self.TimeElapsed = 0
                self.Malannon.Dead = false
                self.Malannon.Casting = false
                self.Malannon.CastBar:Create(unitID)
                self.PhaseObj:Start(self.StartTime)
                self.PhaseObj:SetPhase(self.Malannon.Name)
                self.PhaseObj.Objectives:AddPercent(self.Malannon, 60, 100)
                self.Phase = 1
            end
            self.Malannon.UnitID = unitID
            self.Malannon.Available = true
            return self.Malannon
        end
    end
end

function MAL:Reset()
    self.EncounterRunning = false
    self.Malannon.Available = false
    self.Malannon.UnitID = nil
    self.Malannon.CastBar:Remove()

    self.PhaseObj:End(Inspect.Time.Real())
end

function MAL:Timer()
end


function MAL.PhaseTwo()
    MAL.PhaseObj.Objectives:Remove()
    MAL.Phase = 2
    MAL.PhaseObj:SetPhase(2)
    MAL.PhaseObj.Objectives:AddPercent(MAL.Malannon, 30, 60)
end

function MAL.PhaseThree()
    MAL.PhaseObj.Objectives:Remove()
    MAL.Phase = 3
    MAL.PhaseObj:SetPhase(3)
    MAL.PhaseObj.Objectives:AddPercent(MAL.Malannon, 0, 30)
end




function MAL:Start()
    -- Create Timers

    -- Create Alerts
    self.Malannon.AlertsRef.Meteor = KBM.Alert:Create(self.Lang.Verbose.Meteor[KBM.Lang], 9, true, true, "red")
    self.Malannon.AlertsRef.Blastback = KBM.Alert:Create(self.Lang.Verbose.Blastback[KBM.Lang], 5, true, true, "blue")
    self.Malannon.AlertsRef.MarkOfAcrimony = KBM.Alert:Create(self.Lang.Verbose.MarkOfAcrimony[KBM.Lang], 5, true, true, "purple")
    self.Malannon.AlertsRef.MarkOfSupremacy = KBM.Alert:Create(self.Lang.Verbose.MarkOfSupremacy[KBM.Lang], 5, true, true, "yellow")
    KBM.Defaults.AlertObj.Assign(self.Malannon)

    -- Assign Alerts and Timers to Triggers
    self.Malannon.CastBar = KBM.Castbar:Add(self, self.Malannon)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)

    self.Malannon.Triggers.Meteor = KBM.Trigger:Create(self.Lang.Ability.Meteor[KBM.Lang], "cast", self.Malannon)
    self.Malannon.Triggers.Meteor:AddAlert(self.Malannon.AlertsRef.Meteor)

    self.Malannon.Triggers.Blastback = KBM.Trigger:Create(self.Lang.Debuff.Blastback[KBM.Lang], "playerDebuff", self.Malannon)
    self.Malannon.Triggers.Blastback:AddAlert(self.Malannon.AlertsRef.Blastback)

    self.Malannon.Triggers.MarkOfAcrimony = KBM.Trigger:Create(self.Lang.Debuff.MarkOfAcrimony[KBM.Lang], "playerDebuff", self.Malannon)
    self.Malannon.Triggers.MarkOfAcrimony:AddAlert(self.Malannon.AlertsRef.MarkOfAcrimony, true)
	
    self.Malannon.Triggers.MarkOfSupremacy = KBM.Trigger:Create(self.Lang.Debuff.MarkOfSupremacy[KBM.Lang], "playerDebuff", self.Malannon)
    self.Malannon.Triggers.MarkOfSupremacy:AddAlert(self.Malannon.AlertsRef.MarkOfSupremacy, true)

    self.Malannon.Triggers.PhaseTwo = KBM.Trigger:Create(60, "percent", self.Malannon)
    self.Malannon.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)

    self.Malannon.Triggers.PhaseThree = KBM.Trigger:Create(40, "percent", self.Malannon)
    self.Malannon.Triggers.PhaseThree:AddPhase(self.PhaseThree)
end
