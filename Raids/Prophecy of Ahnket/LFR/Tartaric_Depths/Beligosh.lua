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

-- Main Unit Dictionary
BEL.Lang.Unit = {}
BEL.Lang.Unit.Beligosh = KBM.Language:Add("Beligosh")
BEL.Lang.Unit.Beligosh:SetFrench("Beligosh")
BEL.Lang.Unit.Beligosh:SetGerman("Beligosh")


BEL.Lang.Unit.Golem = KBM.Language:Add("Alavaxian Golem")
BEL.Lang.Unit.Golem:SetFrench("Golem alaviax")
BEL.Lang.Unit.Golem:SetGerman("Alavaxianischer Golem")

BEL.Beligosh = {
    Mod = BEL,
    Level = "72",
    Active = false,
    Name = BEL.Lang.Unit.Beligosh[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
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
          Wrath = KBM.Defaults.AlertObj.Create("red"),
          BurningGround = KBM.Defaults.AlertObj.Create("blue"),
        },
        TimersRef = {
            Enabled = true,
            SeedOfImmolation = KBM.Defaults.TimerObj.Create("purple"),
            VengeanceOfBeligosh = KBM.Defaults.TimerObj.Create("blue"),
            MagmaBreath = KBM.Defaults.TimerObj.Create("red"),
            Landing = KBM.Defaults.TimerObj.Create("red"),
        },
    },
}

BEL.Golem = {
    Mod = BEL,
    Level = "72",
    Name = BEL.Lang.Unit.Golem[KBM.Lang],
    NameShort = "Alavaxian Golem",
    UnitList = {},
    Menu = {},
    UTID = "U0C52392E243A6ACD",
    Ignore = true,
    Type = "multi",
}

KBM.RegisterMod(BEL.ID, BEL)


-- Ability Dictionary
BEL.Lang.Ability = {}
BEL.Lang.Ability.MagmaBreath = KBM.Language:Add("Magma Breath")

-- Verbose Dictionary
BEL.Lang.Verbose = {}
BEL.Lang.Verbose.Wrath = KBM.Language:Add("Go to the edge!")
BEL.Lang.Verbose.Wrath:SetFrench("Aller au bord!")
BEL.Lang.Verbose.Wrath:SetGerman("An den Rand!")

BEL.Lang.Verbose.BurningGround = KBM.Language:Add("Burning Ground")
BEL.Lang.Verbose.BurningGround:SetGerman("Brennende Erde")
BEL.Lang.Verbose.BurningGround:SetFrench("Terrain enflammé")

BEL.Lang.Verbose.Landing = KBM.Language:Add("Landing")

-- Buff Dictionary
BEL.Lang.Buff = {}

-- Debuff Dictionary
BEL.Lang.Debuff = {}
BEL.Lang.Debuff.VengeanceOfBeligosh = KBM.Language:Add("Vengeance of Beligosh")--tank debuff
BEL.Lang.Debuff.VengeanceOfBeligosh:SetGerman("Rache von Beligosh")
BEL.Lang.Debuff.VengeanceOfBeligosh:SetFrench("Vengeance de Beligosh")

BEL.Lang.Debuff.SeedOfImmolation = KBM.Language:Add("Seed of Immolation")--raid debuff
BEL.Lang.Debuff.SeedOfImmolation:SetGerman("Saat der Opferung")
BEL.Lang.Debuff.SeedOfImmolation:SetFrench("Graine d'immolation")

-- Notify Dictionary
BEL.Lang.Notify = {}
BEL.Lang.Notify.Wrath = KBM.Language:Add("Beligosh: Feel the wrath of Beligosh!")
BEL.Lang.Notify.Wrath:SetFrench("Beligosh : Sentez le courroux de Beligosh !")
BEL.Lang.Notify.Wrath:SetGerman("Beligosh: Spürt den Zorn von Beligosh!")

BEL.Lang.Notify.BurningGround1 = KBM.Language:Add("Your Weakness is your compassion")

BEL.Lang.Notify.BurningGround2 = KBM.Language:Add("Choose who lives, who dies.")
BEL.Lang.Notify.BurningGround2:SetFrench("Choisissez qui vivra et qui mourra")

BEL.Lang.Notify.BurningGround3 = KBM.Language:Add("Abandon your friend! Abandon your hope!")
BEL.Lang.Notify.BurningGround3:SetFrench("Abandonnez vos amis ! Abandonnez l'espoir !")

-- Description Dictionary
BEL.Lang.Main = {}
BEL.Descript = BEL.Lang.Unit.Beligosh[KBM.Lang]

function BEL:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.Beligosh.Name] = self.Beligosh,
        [self.Golem.Name] = self.Golem,
    }
end

function BEL:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.Beligosh.Settings.CastBar,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        MechTimer = KBM.Defaults.MechTimer(),
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
                self.PhaseObj:SetPhase(self.Beligosh.Name)
                self.PhaseObj.Objectives:AddPercent(self.Beligosh, 75, 100)
                self.Phase = 1
                KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.SeedOfImmolation)
                KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.VengeanceOfBeligosh)
                KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.MagmaBreath)
            end
            self.Beligosh.UnitID = unitID
            self.Beligosh.Available = true
            return self.Beligosh
        end
        if uDetails.type == self.Golem.UTID then
           if not self.Bosses[uDetails.name].UnitList[unitID] then
                local SubBossObj = {
                    Mod = BEL,
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

function BEL:Reset()
    self.EncounterRunning = false
    self.Beligosh.Available = false
    self.Beligosh.UnitID = nil
    self.Beligosh.CastBar:Remove()
    self.Golem.UnitList = {}

    self.PhaseObj:End(Inspect.Time.Real())
end

function BEL:Timer()
end


function BEL.PhaseTwo()
    BEL.PhaseObj.Objectives:Remove()
    if BEL.Phase == 2 then
        BEL.Phase = 3
        BEL.PhaseObj:SetPhase(3)
        BEL.PhaseObj.Objectives:AddPercent(BEL.Beligosh, 40, 75)
    else
        BEL.Phase = 5
        BEL.PhaseObj:SetPhase(5)
        BEL.PhaseObj.Objectives:AddPercent(BEL.Beligosh, 0, 40)
    end
    KBM.MechTimer:AddStart(BEL.Beligosh.TimersRef.Landing)
end

function BEL.AddPhase()
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.SeedOfImmolation)
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.VengeanceOfBeligosh)
    KBM.MechTimer:AddRemove(BEL.Beligosh.TimersRef.MagmaBreath)
    BEL.PhaseObj.Objectives:Remove()
    if BEL.Phase == 1 then
        BEL.Phase = 2
        BEL.PhaseObj:SetPhase(2)
    else
        BEL.Phase = 4
        BEL.PhaseObj:SetPhase(4)
    end
    BEL.PhaseObj.Objectives:AddDeath(BEL.Lang.Unit.Golem[KBM.Lang], 3)
end



function BEL:Start()
    -- Create Timers
    self.Beligosh.TimersRef.SeedOfImmolation = KBM.MechTimer:Add(self.Lang.Debuff.SeedOfImmolation[KBM.Lang], 24)
    self.Beligosh.TimersRef.VengeanceOfBeligosh = KBM.MechTimer:Add(self.Lang.Debuff.VengeanceOfBeligosh[KBM.Lang], 15)
    self.Beligosh.TimersRef.MagmaBreath = KBM.MechTimer:Add(self.Lang.Ability.MagmaBreath[KBM.Lang], 30)
    self.Beligosh.TimersRef.Landing = KBM.MechTimer:Add(self.Lang.Verbose.Landing[KBM.Lang], 10)
    KBM.Defaults.TimerObj.Assign(self.Beligosh)

    -- Create Alerts
    self.Beligosh.AlertsRef.Wrath = KBM.Alert:Create(self.Lang.Verbose.Wrath[KBM.Lang], 10, true, true, "red")
    self.Beligosh.AlertsRef.BurningGround = KBM.Alert:Create(self.Lang.Verbose.BurningGround[KBM.Lang], 3, true, true, "blue")
    KBM.Defaults.AlertObj.Assign(self.Beligosh)

    -- Assign Alerts and Timers to Triggers
    self.Beligosh.CastBar = KBM.Castbar:Add(self, self.Beligosh)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)


    self.Beligosh.Triggers.AddPhase = KBM.Trigger:Create(75, "percent", self.Beligosh)
    self.Beligosh.Triggers.AddPhase:AddPhase(self.AddPhase)

    self.Beligosh.Triggers.PhaseTwo = KBM.Trigger:Create(self.Lang.Notify.Wrath[KBM.Lang], "notify", self.Beligosh)
    self.Beligosh.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
    self.Beligosh.Triggers.PhaseTwo:AddAlert(self.Beligosh.AlertsRef.Wrath)

    self.Beligosh.Triggers.BurningGround1 = KBM.Trigger:Create(self.Lang.Notify.BurningGround1[KBM.Lang], "say", self.Beligosh)
    self.Beligosh.Triggers.BurningGround1:AddAlert(self.Beligosh.AlertsRef.BurningGround)

    self.Beligosh.Triggers.BurningGround2 = KBM.Trigger:Create(self.Lang.Notify.BurningGround2[KBM.Lang], "say", self.Beligosh)
    self.Beligosh.Triggers.BurningGround2:AddAlert(self.Beligosh.AlertsRef.BurningGround)

    self.Beligosh.Triggers.BurningGround3 = KBM.Trigger:Create(self.Lang.Notify.BurningGround3[KBM.Lang], "say", self.Beligosh)
    self.Beligosh.Triggers.BurningGround3:AddAlert(self.Beligosh.AlertsRef.BurningGround)

    self.Beligosh.Triggers.AddPhase2 = KBM.Trigger:Create(40, "percent", self.Beligosh)
    self.Beligosh.Triggers.AddPhase2:AddPhase(self.AddPhase)

    self.Beligosh.Triggers.SeedOfImmolation = KBM.Trigger:Create(self.Lang.Debuff.SeedOfImmolation[KBM.Lang], "playerDebuff", self.Beligosh)
    self.Beligosh.Triggers.SeedOfImmolation:AddTimer(self.Beligosh.TimersRef.SeedOfImmolation)

    self.Beligosh.Triggers.VengeanceOfBeligosh = KBM.Trigger:Create(self.Lang.Debuff.VengeanceOfBeligosh[KBM.Lang], "playerDebuff", self.Beligosh)
    self.Beligosh.Triggers.VengeanceOfBeligosh:AddTimer(self.Beligosh.TimersRef.VengeanceOfBeligosh)

    self.Beligosh.Triggers.MagmaBreath = KBM.Trigger:Create(self.Lang.Ability.MagmaBreath[KBM.Lang], "channel", self.Beligosh)
    self.Beligosh.Triggers.MagmaBreath:AddTimer(self.Beligosh.TimersRef.MagmaBreath)

    self.Beligosh.TimersRef.Landing:AddTimer(self.Beligosh.TimersRef.SeedOfImmolation, 0)
    self.Beligosh.TimersRef.Landing:AddTimer(self.Beligosh.TimersRef.VengeanceOfBeligosh, 0)
    self.Beligosh.TimersRef.Landing:AddTimer(self.Beligosh.TimersRef.MagmaBreath, 0)
end
