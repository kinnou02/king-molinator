-- Commander Isiel Boss Mod for King Boss Mods
-- Written by Yarrellii

-- script print(Inspect.Unit.Detail('player.target').name)
-- script print(Inspect.Unit.Detail('player.target').type)
-- E. Class Soldier  U16C3B6FE6D522DF5
-- R.D.U.  U362FC592688DF7AC
-- Titan X U80000001B50004A8

KBMPOABOSCIS_Settings = nil
chKBMPOABOSCIS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["BoS"]

local CIS = {
    Directory = Instance.Directory,
    File = "CommanderIsiel.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
	TankSwap = true,
    Lang = {},
    ID = "CommanderIsiel",
    Object = "CIS",
	Enrage = (8 * 60),
}

-- Main Unit Dictionary
CIS.Lang.Unit = {}
CIS.Lang.Unit.CommanderIsiel = KBM.Language:Add("Commander Isiel")
CIS.Lang.Unit.CommanderIsiel:SetFrench("Commander Isiel")
CIS.Lang.Unit.CommanderIsiel:SetGerman("Commander Isiel")

CIS.Lang.Unit.VindicatorMKI = KBM.Language:Add("Vindicator MK 1")
CIS.Lang.Unit.VindicatorMKI:SetFrench("Vindicator MK 1")
CIS.Lang.Unit.VindicatorMKI:SetGerman("Vindicator MK 1")


CIS.CommanderIsiel = {
    Mod = CIS,
    Level = "??",
    Active = false,
    Name = CIS.Lang.Unit.CommanderIsiel[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
    MechRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U3C84FDFB6ED0AD1B",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        MechRef = {
            Enabled = true,
			HeartStrike= KBM.Defaults.MechObj.Create("red"),
			LightningWhirl = KBM.Defaults.MechObj.Create("blue"),
        },
    },
}

CIS.VindicatorMKI = {
    Mod = CIS,
    Level = "??",
    Active = false,
    Name = CIS.Lang.Unit.VindicatorMKI[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
    MechRef = {},
    Castbar = nil,
	CastFilters = {},
	HasCastFilters = true,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U077679702EF3B37A",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
		Filters = {
			Enabled = true,
			VoltaicThrust = KBM.Defaults.CastFilter.Create(),
			LightningBurst = KBM.Defaults.CastFilter.Create(),
		},
		AlertsRef = {
			Enabled = true,
			TimedCharge = KBM.Defaults.AlertObj.Create("red"),
			LightningBurst = KBM.Defaults.AlertObj.Create("blue"),
			ExplosiveRound = KBM.Defaults.AlertObj.Create("dark_green"),
		},
        TimersRef = {
			Enabled = true,
			TimedCharge = KBM.Defaults.TimerObj.Create("red"),
			FirstTimedCharge = KBM.Defaults.TimerObj.Create("red"),
			LightningBurst = KBM.Defaults.TimerObj.Create("blue"),
        },
        MechRef = {
            Enabled = true,
			TimedCharge= KBM.Defaults.MechObj.Create("red"),
			LightningBurst = KBM.Defaults.MechObj.Create("blue"),
			DrillerRound = KBM.Defaults.MechObj.Create("purple"),

        },
    },
}


KBM.RegisterMod(CIS.ID, CIS)

-- Ability Dictionary
CIS.Lang.Ability = {}
CIS.Lang.Ability.LightningBurst = KBM.Language:Add("Lightning Burst") --TODO transG 
CIS.Lang.Ability.LightningBurst:SetFrench("Balle foreuse")
CIS.Lang.Ability.VoltaicThrust = KBM.Language:Add("Voltaic Thrust") --TODO transG transF

-- Verbose Dictionary
CIS.Lang.Verbose = {}

-- Buff Dictionary
CIS.Lang.Buff = {}

-- Debuff Dictionary
CIS.Lang.Debuff = {}
CIS.Lang.Debuff.TimedCharge = KBM.Language:Add("Timed Charge") --TODO transF transG 
CIS.Lang.Debuff.DrillerRound = KBM.Language:Add("Driller Round") --TODO transF transG
CIS.Lang.Debuff.HeartStrike = KBM.Language:Add("Heart Strike") --TODO transF transG
CIS.Lang.Debuff.ExplosiveRound = KBM.Language:Add("Explosive Round") --TODO transF transG
 
-- Notify Dictionary
CIS.Lang.Notify = {}

-- Description Dictionary
CIS.Lang.Main = {}
CIS.Descript = CIS.Lang.Unit.CommanderIsiel[KBM.Lang]

-- Menu Dictionary
CIS.Lang.Menu = {}
CIS.Lang.Menu.FirstTimedCharge = KBM.Language:Add("First " .. CIS.Lang.Debuff.TimedCharge[KBM.Lang]) --TODO transF transG
CIS.Lang.Menu.FirstLightningBurst = KBM.Language:Add("First " .. CIS.Lang.Ability.LightningBurst[KBM.Lang]) --TODO transF transG


function CIS:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.VindicatorMKI.Name] = self.VindicatorMKI,
		[self.CommanderIsiel.Name] = self.CommanderIsiel,
    }
end

function CIS:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.CommanderIsiel.Settings.CastBar,
		CastFilters = self.CommanderIsiel.Settings.Filters,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        TimersRef = self.CommanderIsiel.Settings.TimersRef,
        AlertsRef = self.CommanderIsiel.Settings.AlertsRef,
		MechRef = self.CommanderIsiel.Settings.MechRef,
    }
    KBMPOABOSCIS_Settings = self.Settings
    chKBMPOABOSCIS_Settings = self.Settings

end

function CIS:SwapSettings(bool)

    if bool then
        KBMPOABOSCIS_Settings = self.Settings
        self.Settings = chKBMPOABOSCIS_Settings
    else
        chKBMPOABOSCIS_Settings = self.Settings
        self.Settings = KBMPOABOSCIS_Settings
    end

end

function CIS:LoadVars()
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOABOSCIS_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOABOSCIS_Settings, self.Settings)
    end

    if KBM.Options.Character then
        chKBMPOABOSCIS_Settings = self.Settings
    else
        KBMPOABOSCIS_Settings = self.Settings
    end 
end

function CIS:SaveVars()
    if KBM.Options.Character then
        chKBMPOABOSCIS_Settings = self.Settings
    else
        KBMPOABOSCIS_Settings = self.Settings
    end
end

function CIS:Castbar(units)
end

function CIS:RemoveUnits(UnitID)
    if self.CommanderIsiel.UnitID == UnitID then
        self.CommanderIsiel.Available = false
        return true
    elseif self.VindicatorMKI.UnitID == UnitID then
        self.VindicatorMKI.Available = false
        return true
    end
    return false
end

function CIS:Death(UnitID)
    if self.CommanderIsiel.UnitID == UnitID then
        self.CommanderIsiel.Dead = true
        return true
    elseif self.VindicatorMKI.UnitID == UnitID then
        self.VindicatorMKI.Dead = true
        return true
    end
    return false
end

function CIS:UnitHPCheck(uDetails, unitID)
    if uDetails and unitID then
        if uDetails.type == self.VindicatorMKI.UTID then
            if not self.EncounterRunning then
                self.EncounterRunning = true
                self.StartTime = Inspect.Time.Real()
                self.HeldTime = self.StartTime
                self.TimeElapsed = 0
                self.VindicatorMKI.Dead = false
                self.VindicatorMKI.Casting = false
                self.VindicatorMKI.CastBar:Create(unitID)
                self.PhaseObj:Start(self.StartTime)
                self.PhaseObj:SetPhase(self.VindicatorMKI.Name)
                self.PhaseObj.Objectives:AddPercent(self.VindicatorMKI, 60, 100)
                self.Phase = 1
                KBM.MechTimer:AddStart(CIS.VindicatorMKI.TimersRef.FirstTimedCharge)
                KBM.TankSwap:Start(self.Lang.Debuff.DrillerRound[KBM.Lang], unitID)
            end
            self.VindicatorMKI.UnitID = unitID
            self.VindicatorMKI.Available = true
            return self.VindicatorMKI
        elseif uDetails.type == self.CommanderIsiel.UTID then
            if not self.CommanderIsiel.Available then
                self.CommanderIsiel.Dead = false
                self.CommanderIsiel.Casting = false
                self.CommanderIsiel.CastBar:Create(unitID)
                self.PhaseObj:SetPhase(self.CommanderIsiel.Name)
                self.Phase = 2
				if KBM.TankSwap.Active then
					KBM.TankSwap:Remove()
				end	
            end
            self.CommanderIsiel.UnitID = unitID
            self.CommanderIsiel.Available = true
            return self.CommanderIsiel
		end
    end
end

function CIS:Reset()
    self.EncounterRunning = false
    self.VindicatorMKI.Available = false
	self.CommanderIsiel.Available = false
    self.VindicatorMKI.UnitID = nil
	self.CommanderIsiel.UnitID = nil
    self.VindicatorMKI.CastBar:Remove()
	self.CommanderIsiel.CastBar:Remove()
    self.PhaseObj:End(Inspect.Time.Real())
end

function CIS:Timer()
end


function CIS.PhaseTwo()
    CIS.PhaseObj.Objectives:Remove()
    CIS.Phase = 2
    CIS.PhaseObj:SetPhase(2)
    CIS.PhaseObj.Objectives:AddPercent(CIS.CommanderIsiel, 30, 100)
end

function CIS.PhaseThree()
    CIS.PhaseObj.Objectives:Remove()
    CIS.Phase = 3
    CIS.PhaseObj:SetPhase(3)
    CIS.PhaseObj.Objectives:AddPercent(CIS.CommanderIsiel, 0, 30)
end


function CIS:Start()
    -- Create Timers
    self.VindicatorMKI.TimersRef.FirstTimedCharge = KBM.MechTimer:Add(self.Lang.Debuff.TimedCharge[KBM.Lang], 10)
    self.VindicatorMKI.TimersRef.FirstTimedCharge.MenuName = self.Lang.Menu.FirstTimedCharge[KBM.Lang]
    self.VindicatorMKI.TimersRef.TimedCharge = KBM.MechTimer:Add(self.Lang.Debuff.TimedCharge[KBM.Lang], 27)

    self.VindicatorMKI.TimersRef.LightningBurst = KBM.MechTimer:Add(self.Lang.Ability.LightningBurst[KBM.Lang], 27)
    KBM.Defaults.TimerObj.Assign(self.VindicatorMKI)
	
    -- MechSpy
	self.VindicatorMKI.MechRef.DrillerRound = KBM.MechSpy:Add(self.Lang.Debuff.DrillerRound[KBM.Lang], nil, "playerDebuff", self.VindicatorMKI)
	
	self.CommanderIsiel.MechRef.HeartStrike = KBM.MechSpy:Add(self.Lang.Debuff.HeartStrike[KBM.Lang], nil, "playerDebuff", self.CommanderIsiel)

	KBM.Defaults.MechObj.Assign(self.VindicatorMKI)
	KBM.Defaults.MechObj.Assign(self.CommanderIsiel)

    -- Create Alerts
    self.VindicatorMKI.AlertsRef.LightningBurst = KBM.Alert:Create(self.Lang.Ability.LightningBurst[KBM.Lang], 2, true, true, "blue")
    self.VindicatorMKI.AlertsRef.TimedCharge = KBM.Alert:Create(self.Lang.Debuff.TimedCharge[KBM.Lang], 2, true, true, "red")
	self.VindicatorMKI.AlertsRef.ExplosiveRound = KBM.Alert:Create(self.Lang.Debuff.ExplosiveRound[KBM.Lang], 2, true, true, "dark_green")
    KBM.Defaults.AlertObj.Assign(self.VindicatorMKI) 

    -- Assign Alerts and Timers to Triggers
	CIS.VindicatorMKI.CastFilters[CIS.Lang.Ability.VoltaicThrust[KBM.Lang]] = {ID = "VoltaicThrust"}
	CIS.VindicatorMKI.CastFilters[CIS.Lang.Ability.LightningBurst[KBM.Lang]] = {ID = "LightningBurst"}
	KBM.Defaults.CastFilter.Assign(self.VindicatorMKI)
    self.VindicatorMKI.CastBar = KBM.Castbar:Add(self, self.VindicatorMKI)
	self.CommanderIsiel.CastBar = KBM.Castbar:Add(self, self.CommanderIsiel)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
    
    self.VindicatorMKI.Triggers.TimedCharge = KBM.Trigger:Create(self.Lang.Debuff.TimedCharge[KBM.Lang], "playerDebuff", self.VindicatorMKI)
    self.VindicatorMKI.Triggers.TimedCharge:AddAlert(self.VindicatorMKI.AlertsRef.TimedCharge, true)
    self.VindicatorMKI.Triggers.TimedCharge:AddTimer(self.VindicatorMKI.TimersRef.TimedCharge)
	
	self.VindicatorMKI.Triggers.DrillerRound = KBM.Trigger:Create(self.Lang.Debuff.DrillerRound[KBM.Lang], "playerDebuff", self.VindicatorMKI)
    self.VindicatorMKI.Triggers.DrillerRound:AddSpy(self.VindicatorMKI.MechRef.DrillerRound)

	self.CommanderIsiel.Triggers.HeartStrike = KBM.Trigger:Create(self.Lang.Debuff.HeartStrike[KBM.Lang], "playerDebuff", self.CommanderIsiel)
	self.CommanderIsiel.Triggers.HeartStrike:AddSpy(self.CommanderIsiel.MechRef.HeartStrike)
	
	self.CommanderIsiel.Triggers.HeartStrikeRemoved = KBM.Trigger:Create(self.Lang.Debuff.HeartStrike[KBM.Lang], "playerBuffRemove", self.CommanderIsiel)
	self.CommanderIsiel.Triggers.HeartStrikeRemoved:AddStop(self.CommanderIsiel.MechRef.HeartStrike)
	
	--ExplosiveRound = B2A466E1E35306E82
	self.VindicatorMKI.Triggers.ExplosiveRound = KBM.Trigger:Create(self.Lang.Debuff.ExplosiveRound[KBM.Lang], "playerDebuff", self.VindicatorMKI)
	self.VindicatorMKI.Triggers.ExplosiveRound:AddAlert(self.VindicatorMKI.AlertsRef.ExplosiveRound, true)
	
	self.CommanderIsiel.Triggers.ExplosiveRoundRemoved = KBM.Trigger:Create(self.Lang.Debuff.ExplosiveRound[KBM.Lang], "playerBuffRemove", self.VindicatorMKI)
	self.CommanderIsiel.Triggers.ExplosiveRoundRemoved:AddStop(self.VindicatorMKI.AlertsRef.ExplosiveRound)
	
    self.VindicatorMKI.Triggers.LightningBurst = KBM.Trigger:Create(self.Lang.Ability.LightningBurst[KBM.Lang], "channel", self.VindicatorMKI)
    self.VindicatorMKI.Triggers.LightningBurst:AddTimer(self.VindicatorMKI.TimersRef.LightningBurst)
    self.VindicatorMKI.Triggers.LightningBurst:AddAlert(self.VindicatorMKI.AlertsRef.LightningBurst)
	
	self.CommanderIsiel.Triggers.PhaseTwo = KBM.Trigger:Create(100, "percent", self.CommanderIsiel)
    self.CommanderIsiel.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
    
    self.CommanderIsiel.Triggers.PhaseThree = KBM.Trigger:Create(30, "percent", self.CommanderIsiel)
    self.CommanderIsiel.Triggers.PhaseThree:AddPhase(self.PhaseThree)
end
