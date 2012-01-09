-- Herald Gaurath Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSHG_Settings = nil
chKBMROSHG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROS = KBM.BossMod["River of Souls"]

local HG = {
	Enabled = true,
	Instance = ROS.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	RaiseCounter = 0,
	Enrage = 60 * 9.5,
	ID = "Herald_Gaurath",	
}

HG.Gaurath = {
	Mod = HG,
	Level = "??",
	Active = false,
	Name = "Herald Gaurath",
	NameShort = "Gaurath",
	Dead = false,
	Available = false,
	TimersRef = {},
	AlertsRef = {},
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Breath = KBM.Defaults.TimerObj.Create("purple"),
			Raise = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Breath = KBM.Defaults.AlertObj.Create("purple"),
			Raise = KBM.Defaults.AlertObj.Create("dark_green"),
			Tidings = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(HG.ID, HG)

HG.Lang.Gaurath = KBM.Language:Add(HG.Gaurath.Name)
HG.Lang.Gaurath.German = "Herold Gaurath"
HG.Lang.Gaurath.French = "H\195\169raut Gaurath"

-- Ability Dictionary
HG.Lang.Ability = {}
HG.Lang.Ability.Breath = KBM.Language:Add("Breath of the Void")
HG.Lang.Ability.Breath.German = "Odem der Leere"
HG.Lang.Ability.Raise = KBM.Language:Add("Raise the Dead")
HG.Lang.Ability.Raise.German = "Erweckung der Toten"
HG.Lang.Ability.Tidings = KBM.Language:Add("Tidings of Woe")
HG.Lang.Ability.Tidings.German = "Leidvolle Kunde"

-- Verbose Dictionary
HG.Lang.Verbose = {}
HG.Lang.Verbose.Raise = KBM.Language:Add("Death group rise")
HG.Lang.Verbose.Raise.German = "Erweckung der Toten"

-- Notify Dictionary
HG.Lang.Notify = {}
HG.Lang.Notify.Tidings = KBM.Language:Add("unleashes woeful tidings upon (%a*)")
HG.Lang.Notify.Tidings.German = "entfesselt traurige Kunde auf (%a*)"

HG.Gaurath.Name = HG.Lang.Gaurath[KBM.Lang]
HG.Descript = HG.Gaurath.Name

function HG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Gaurath.Name] = self.Gaurath,
	}
	KBM_Boss[self.Gaurath.Name] = self.Gaurath	
end

function HG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Gaurath.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		TimersRef = self.Gaurath.Settings.TimersRef,
		AlertsRef = self.Gaurath.Settings.AlertsRef,
	}
	KBMROSHG_Settings = self.Settings
	chKBMROSHG_Settings = self.Settings
end

function HG:SwapSettings(bool)
	if bool then
		KBMROSHG_Settings = self.Settings
		self.Settings = chKBMROSHG_Settings
	else
		chKBMROSHG_Settings = self.Settings
		self.Settings = KBMROSHG_Settings
	end
end

function HG:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROSHG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROSHG_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMROSHG_Settings = self.Settings
	else
		KBMROSHG_Settings = self.Settings
	end	
end

function HG:SaveVars()
	if KBM.Options.Character then
		chKBMROSHG_Settings = self.Settings
	else
		KBMROSHG_Settings = self.Settings
	end	
end

function HG:Castbar(units)
end

function HG:RemoveUnits(UnitID)
	if self.Gaurath.UnitID == UnitID then
		self.Gaurath.Available = false
		return true
	end
	return false
end

function HG:Death(UnitID)
	if self.Gaurath.UnitID == UnitID then
		self.Gaurath.Dead = true
		return true
	end
	return false
end

function HG.AirPhase()
	HG.PhaseObj:SetPhase("Air")
	HG.Phase = 2
	HG.RaiseCounter = 0
end

function HG.GroundPhase()
	HG.RaiseObj:Update(0)
	HG.PhaseObj:SetPhase("Ground")
	HG.Phase = 1
end

function HG.RaiseCount()
	HG.RaiseCounter = HG.RaiseCounter + 1
	if HG.RaiseCounter == 2 then
		HG.AirPhase()
	end
	HG.RaiseObj:Update(HG.RaiseCounter)
	KBM.MechTimer:AddRemove(HG.Gaurath.TimersRef.Breath)
end

function HG:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Gaurath.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Gaurath.Dead = false
					self.Gaurath.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Ground")
					self.PhaseObj.Objectives:AddPercent(self.Gaurath.Name, 0, 100)
					self.RaiseObj = self.PhaseObj.Objectives:AddMeta(self.Lang.Ability.Raise[KBM.Lang], 2, 0)
					self.RaiseCounter = 0
				end
				self.Gaurath.Casting = false
				self.Gaurath.UnitID = unitID
				self.Gaurath.Available = true
				return self.Gaurath
			end
		end
	end
end

function HG:Reset()
	self.EncounterRunning = false
	self.Gaurath.Available = false
	self.Gaurath.UnitID = nil
	self.Gaurath.CastBar:Remove()
	self.Gaurath.Dead = false
	self.RaiseObj = nil
	self.RaiseCounter = 0
	self.PhaseObj:End(Inspect.Time.Real())
end

function HG:Timer()	
end

function HG.Gaurath:SetTimers(bool)	
	if bool then
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function HG.Gaurath:SetAlerts(bool)
	if bool then
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end

function HG:DefineMenu()
	self.Menu = ROS.Menu:CreateEncounter(self.Gaurath, self.Enabled)
end

function HG:Start()	
	-- Create Timers
	self.Gaurath.TimersRef.Breath = KBM.MechTimer:Add(self.Lang.Ability.Breath[KBM.Lang], 26)
	self.Gaurath.TimersRef.Raise = KBM.MechTimer:Add(self.Lang.Verbose.Raise[KBM.Lang], 7)
	KBM.Defaults.TimerObj.Assign(self.Gaurath)
	
	-- Create Alerts
	self.Gaurath.AlertsRef.Breath = KBM.Alert:Create(self.Lang.Ability.Breath[KBM.Lang], nil, false, true, "purple")
	self.Gaurath.AlertsRef.Raise = KBM.Alert:Create(self.Lang.Ability.Raise[KBM.Lang], nil, true, true, "dark_green")
	self.Gaurath.AlertsRef.Raise:TimerEnd(self.Gaurath.TimersRef.Raise)
	self.Gaurath.AlertsRef.Tidings = KBM.Alert:Create(self.Lang.Ability.Tidings[KBM.Lang], 8, false, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Gaurath)
	
	-- Assign Timers and Alerts to Triggers
	self.Gaurath.Triggers.Breath = KBM.Trigger:Create(self.Lang.Ability.Breath[KBM.Lang], "cast", self.Gaurath)
	self.Gaurath.Triggers.Breath:AddTimer(self.Gaurath.TimersRef.Breath)
	self.Gaurath.Triggers.Breath:AddAlert(self.Gaurath.AlertsRef.Breath)
	self.Gaurath.Triggers.Raise = KBM.Trigger:Create(self.Lang.Ability.Raise[KBM.Lang], "cast", self.Gaurath)
	self.Gaurath.Triggers.Raise:AddAlert(self.Gaurath.AlertsRef.Raise)
	self.Gaurath.Triggers.Raise:AddPhase(self.RaiseCount)
	self.Gaurath.Triggers.Tidings = KBM.Trigger:Create(self.Lang.Ability.Tidings[KBM.Lang], "cast", self.Gaurath)
	self.Gaurath.Triggers.Tidings:AddAlert(self.Gaurath.AlertsRef.Tidings)
	self.Gaurath.Triggers.Tidings:AddPhase(self.GroundPhase)
	
	self.Gaurath.CastBar = KBM.CastBar:Add(self, self.Gaurath)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end