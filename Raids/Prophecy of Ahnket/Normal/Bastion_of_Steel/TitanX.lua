-- TitanX Boss Mod for King Boss Mods
-- Written by Yarrellii

-- TODO: Infection move to Infector so this can be monitored, need a unit id
-- TODO: rocket volley from  R.D.U.

KBMPOABOSTX_Settings = nil
chKBMPOABOSTX_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
    return
end

local Instance = KBM.BossMod["BoS"]

local TX = {
    Directory = Instance.Directory,
    File = "TitanX.lua",
    Enabled = true,
    Instance = Instance.Name,
    InstanceObj = Instance,
    HasPhases = true,
    TankSwap = true,
    Lang = {},
    ID = "TitanX",
    Object = "TX",
	Enrage = (8 * 60),
}

-- Main Unit Dictionary
TX.Lang.Unit = {}
TX.Lang.Unit.TitanX = KBM.Language:Add("Titan X")
TX.Lang.Unit.TitanX:SetFrench("Titan X")
TX.Lang.Unit.TitanX:SetGerman("Titan X")

TX.Lang.Unit.EClassSoldier = KBM.Language:Add("E. Class Soldier")
TX.Lang.Unit.EClassSoldier:SetFrench("E. Class Soldier")
TX.Lang.Unit.EClassSoldier:SetGerman("E. Class Soldier")

TX.Lang.Unit.RDU = KBM.Language:Add("R.D.U.")
TX.Lang.Unit.RDU:SetFrench("R.D.U.")
TX.Lang.Unit.RDU:SetGerman("R.D.U.")


TX.TitanX = {
    Mod = TX,
    Level = "72",
    Active = false,
    Name = TX.Lang.Unit.TitanX[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
    MechRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U563E713033B0D82B", --"U80000001B50004A8",
    TimeOut = 5,
    Triggers = {},
    Settings = {
        CastBar = KBM.Defaults.Castbar(),
        AlertsRef = {
          Enabled = true,
          LegionPull = KBM.Defaults.AlertObj.Create("red"),
		  Infection = KBM.Defaults.AlertObj.Create("purple"),
        },
        TimersRef = {
            Enabled = true,
			LegionPull = KBM.Defaults.TimerObj.Create("red"),
		},
        MechRef = {
            Enabled = true,
            RangeModule = KBM.Defaults.MechObj.Create("purple"),
			LegionPull = KBM.Defaults.MechObj.Create("red"),
			Infection = KBM.Defaults.MechObj.Create("red"),
        },
    },
}

TX.EClassSoldier = {
    Mod = TX,
    Level = "72",
    Active = false,
    Name = TX.Lang.Unit.EClassSoldier[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
    MechRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U16C3B6FE6D522DF5",
    TimeOut = 5,
    Triggers = {},
    Settings = {},
}

TX.RDU = {
    Mod = TX,
    Level = "72",
    Active = false,
    Name = TX.Lang.Unit.RDU[KBM.Lang],
    Menu = {},
    AlertsRef = {},
    TimersRef = {},
    MechRef = {},
    Castbar = nil,
    Dead = false,
    Available = false,
    UnitID = nil,
    UTID = "U362FC592688DF7AC",
    TimeOut = 5,
    Triggers = {},
    Settings = {
		AlertsRef = {
			Enabled = true,
			RocketVolley = KBM.Defaults.AlertObj.Create("red"),
		},
	},
}

KBM.RegisterMod(TX.ID, TX)

-- Ability Dictionary
TX.Lang.Ability = {}
TX.Lang.Ability.LegionPull = KBM.Language:Add("Legion Pull") --TODO transF transG
TX.Lang.Ability.RocketVolley = KBM.Language:Add("Rocket Volley") --TODO transF transG

-- Verbose Dictionary
TX.Lang.Verbose = {}

-- Buff Dictionary
TX.Lang.Buff = {}

-- Debuff Dictionary
TX.Lang.Debuff = {}
TX.Lang.Debuff.RangeModule = KBM.Language:Add("Range Module") --TODO transF
TX.Lang.Debuff.RangeModule:SetGerman("Weitenmodul")
TX.Lang.Debuff.Infection = KBM.Language:Add("Infection") --TODO transF
TX.Lang.Debuff.Infection:SetGerman("Infektion")


-- Notify Dictionary
TX.Lang.Notify = {}

-- Description Dictionary
TX.Lang.Main = {}
TX.Descript = TX.Lang.Unit.TitanX[KBM.Lang]

-- Menu Dictionary
TX.Lang.Menu = {}
																								   
																							 
																						   


function TX:AddBosses(KBM_Boss)
    self.MenuName = self.Descript
    self.Bosses = {
        [self.EClassSoldier.Name] = self.EClassSoldier,
		[self.RDU.Name] = self.RDU,
		[self.TitanX.Name] = self.TitanX,
    }
end

function TX:InitVars()
    self.Settings = {
        Enabled = true,
        CastBar = self.TitanX.Settings.CastBar,
        EncTimer = KBM.Defaults.EncTimer(),
        PhaseMon = KBM.Defaults.PhaseMon(),
        MechTimer = KBM.Defaults.MechTimer(),
        Alerts = KBM.Defaults.Alerts(),
        TimersRef = self.TitanX.Settings.TimersRef,
        AlertsRef = self.TitanX.Settings.AlertsRef,
        MechRef = self.TitanX.Settings.MechRef,
        MechSpy = KBM.Defaults.MechSpy(),
    }
    KBMPOABOSTX_Settings = self.Settings
    chKBMPOABOSTX_Settings = self.Settings

end

function TX:SwapSettings(bool)

    if bool then
        KBMPOABOSTX_Settings = self.Settings
        self.Settings = chKBMPOABOSTX_Settings
    else
        chKBMPOABOSTX_Settings = self.Settings
        self.Settings = KBMPOABOSTX_Settings
    end

end

function TX:LoadVars()
    if KBM.Options.Character then
        KBM.LoadTable(chKBMPOABOSTX_Settings, self.Settings)
    else
        KBM.LoadTable(KBMPOABOSTX_Settings, self.Settings)
    end

    if KBM.Options.Character then
        chKBMPOABOSTX_Settings = self.Settings
    else
        KBMPOABOSTX_Settings = self.Settings
    end 
end

function TX:SaveVars()
    if KBM.Options.Character then
        chKBMPOABOSTX_Settings = self.Settings
    else
        KBMPOABOSTX_Settings = self.Settings
    end
end

function TX:Castbar(units)
end

function TX:RemoveUnits(UnitID)
    if self.TitanX.UnitID == UnitID then
        self.TitanX.Available = false
        return true
    end
    return false
end

function TX:Death(UnitID)
    if self.TitanX.UnitID == UnitID then
        self.TitanX.Dead = true
        return true
    end
    return false
end

function TX:UnitHPCheck(uDetails, unitID)
    if uDetails and unitID then
        if uDetails.type == self.TitanX.UTID then
            if not self.TitanX.Available then
				self.TitanX.Dead = false
                self.TitanX.Casting = false
                self.TitanX.CastBar:Create(unitID)
				TX.PhaseObj.Objectives:Remove()
				self.PhaseObj:SetPhase(self.TitanX.Name)
                self.PhaseObj.Objectives:AddPercent(self.TitanX, 70, 100)
                self.Phase = 2
																			
            end
            self.TitanX.UnitID = unitID
            self.TitanX.Available = true
            return self.TitanX
		else 
			if uDetails.type == self.EClassSoldier.UTID then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.EClassSoldier.Dead = false
					self.EClassSoldier.Casting = false
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.Phase = 1
					self.EClassSoldier.UnitID = unitID
					self.EClassSoldier.Available = true
					return self.EClassSoldier
				end
			elseif uDetails.type == self.RDU.UTID then
				self.RDU.Dead = false
				self.RDU.Casting = false
				self.RDU.UnitID = unitID
				self.RDU.Available = true
				return self.RDU
			end
		end
    end
end

function TX:Reset()
    self.EncounterRunning = false
    self.TitanX.Available = false
    self.TitanX.UnitID = nil
    self.TitanX.CastBar:Remove()
    self.PhaseObj:End(Inspect.Time.Real())
end

function TX:Timer()
end


function TX.PhaseTwo()
    TX.PhaseObj.Objectives:Remove()
    TX.Phase = 2
    TX.PhaseObj:SetPhase(2)
    TX.PhaseObj.Objectives:AddPercent(TX.TitanX, 70, 100)
end

function TX.PhaseThree()
    TX.PhaseObj.Objectives:Remove()
    TX.Phase = 3
    TX.PhaseObj:SetPhase(3)
    TX.PhaseObj.Objectives:AddPercent(TX.TitanX, 35, 70)
end

function TX.PhaseFour()
    TX.PhaseObj.Objectives:Remove()
    TX.Phase = 4
    TX.PhaseObj:SetPhase(4)
    TX.PhaseObj.Objectives:AddPercent(TX.TitanX, 0, 35)
end


function TX:Start()
    -- Create Timers
																										   
																							   
    self.TitanX.TimersRef.LegionPull = KBM.MechTimer:Add(self.Lang.Ability.LegionPull[KBM.Lang], 40)
    KBM.Defaults.TimerObj.Assign(self.TitanX)

    -- MechSpy
    self.TitanX.MechRef.Infection = KBM.MechSpy:Add(self.Lang.Debuff.Infection[KBM.Lang], nil, "playerDebuff", self.TitanX)
	self.TitanX.MechRef.RangeModule = KBM.MechSpy:Add(self.Lang.Debuff.RangeModule[KBM.Lang], nil, "playerDebuff", self.TitanX)
    KBM.Defaults.MechObj.Assign(self.TitanX)

    -- Create Alerts
    self.TitanX.AlertsRef.LegionPull = KBM.Alert:Create(self.Lang.Ability.LegionPull[KBM.Lang], 2, true, true, "red")
	self.RDU.AlertsRef.RocketVolley = KBM.Alert:Create(self.Lang.Ability.RocketVolley[KBM.Lang], 2, true, true, "red")
    self.TitanX.AlertsRef.Infection = KBM.Alert:Create(self.Lang.Debuff.Infection[KBM.Lang], 2, true, true, "yellow")
    KBM.Defaults.AlertObj.Assign(self.TitanX)
	KBM.Defaults.AlertObj.Assign(self.RDU)

    -- Assign Alerts and Timers to Triggers
    self.TitanX.CastBar = KBM.Castbar:Add(self, self.TitanX)
    self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
	self.TitanX.Triggers.Infection = KBM.Trigger:Create(self.Lang.Debuff.Infection[KBM.Lang], "playerDebuff", self.TitanX)
    self.TitanX.Triggers.Infection:AddAlert(self.TitanX.AlertsRef.Infection, true)
	self.TitanX.Triggers.Infection:AddSpy(self.TitanX.MechRef.Infection)

    self.RDU.Triggers.RocketVolley = KBM.Trigger:Create(self.Lang.Ability.RocketVolley[KBM.Lang], "channel", self.RDU)
    self.RDU.Triggers.RocketVolley:AddAlert(self.RDU.AlertsRef.RocketVolley, true)
	
    self.TitanX.Triggers.LegionPull = KBM.Trigger:Create(self.Lang.Ability.LegionPull[KBM.Lang], "channel", self.TitanX)
    self.TitanX.Triggers.LegionPull:AddAlert(self.TitanX.AlertsRef.LegionPull, true)
    self.TitanX.Triggers.LegionPull:AddTimer(self.TitanX.TimersRef.LegionPull)

    self.TitanX.Triggers.PhaseTwo = KBM.Trigger:Create(70, "percent", self.TitanX)
    self.TitanX.Triggers.PhaseTwo:AddPhase(self.PhaseThree)

    self.TitanX.Triggers.PhaseThree = KBM.Trigger:Create(35, "percent", self.TitanX)
    self.TitanX.Triggers.PhaseThree:AddPhase(self.PhaseFour)

end
