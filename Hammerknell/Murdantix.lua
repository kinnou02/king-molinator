-- Murdantix Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMX_Settings = nil
chKBMMX_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local MX = {
	Enabled = true,
	Murdantix = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		Name = "Murdantix",
	},
	Instance = HK.Name,
	HasPhases = true,
	Phase = 1,
	Timers = {},
	Lang = {},
	TankSwap = true,
	Enrage = 60 * 10,
	ID = "Murdantix",
}

MX.Murd = {
	Mod = MX,
	Menu = {},
	Level = "??",
	Active = false,
	Name = "Murdantix",
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = false,
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Descript = "Murdantix",
	TimeOut = 5,
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Crush = KBM.Defaults.TimerObj.Create(),
			Pound = KBM.Defaults.TimerObj.Create(),
			Blast = KBM.Defaults.TimerObj.Create(),
			Trauma = KBM.Defaults.TimerObj.Create(),
		},
		AlertsRef = {
			Enabled = true,
			Trauma = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

KBM.RegisterMod("Murdantix", MX)

MX.Lang.Murdantix = KBM.Language:Add(MX.Murd.Name)

-- Ability Dictionary
MX.Lang.Crush = KBM.Language:Add("Mangling Crush")
MX.Lang.Crush.French = "Essorage"
MX.Lang.Crush.German = "Erdrückender Stoss"
MX.Lang.Pound = KBM.Language:Add("Ferocious Pound")
MX.Lang.Pound.French = "Attaque f\195\169roce"
MX.Lang.Pound.German = "Wildes Zuschlagen"
MX.Lang.Blast = KBM.Language:Add("Demonic Blast")
MX.Lang.Blast.French = "Explosion d\195\169moniaque"
MX.Lang.Blast.German = "Dämonische Explosion"
MX.Lang.Trauma = KBM.Language:Add("Soul Trauma")
MX.Lang.Trauma.French = "Traumatisme d'\195\162me"
MX.Lang.Trauma.German = "Seelentrauma"

-- Debuff Dictionary
MX.Lang.Debuff = {}
MX.Lang.Debuff.Mangled = KBM.Language:Add("Mangled")
MX.Lang.Debuff.Mangled.German = "Üble Blessur"

function MX:AddBosses(KBM_Boss)
	self.MenuName = self.Murd.Name
	KBM_Boss[self.Murd.Name] = self.Murd
	self.Bosses = {
		[self.Murd.Name] = self.Murd
	}
end

function MX:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		CastBar = MX.Murd.Settings.CastBar,
		MechTimer = KBM.Defaults.MechTimer(),
		TimersRef = MX.Murd.Settings.TimersRef,
		AlertsRef = MX.Murd.Settings.AlertsRef,
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMMX_Settings = self.Settings
	chKBMMX_Settings = self.Settings	
end

function MX:SwapSettings(bool)
	if bool then
		KBMMX_Settings = self.Settings
		self.Settings = chKBMMX_Settings
	else
		chKBMMX_Settings = self.Settings
		self.Settings = KBMMX_Settings
	end
end

function MX:LoadVars()	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMX_Settings, MX.Settings)
	else
		KBM.LoadTable(KBMMX_Settings, MX.Settings)
	end
		
	if KBM.Options.Character then
		chKBMMX_Settings = MX.Settings
	else
		KBMMX_Settings = MX.Settings
	end	
end

function MX:SaveVars()	
	if KBM.Options.Character then
		chKBMMX_Settings = MX.Settings
	else
		KBMMX_Settings = MX.Settings
	end	
end

function MX:Castbar()
end

function MX:RemoveUnits(UnitID)
	if self.Murd.UnitID == UnitID then
		self.Murd.Available = false
		return true
	end
	return false	
end

function MX:Death(UnitID)
	if self.Murd.UnitID == UnitID then
		self.Murd.Dead = true
		return true
	end
	return false	
end

function MX.PhaseTwo()
	MX.PhaseObj.Objectives:Remove()
	MX.Phase = 2
	MX.PhaseObj:SetPhase(2)
	MX.PhaseObj.Objectives:AddPercent(MX.Murd.Name, 50, 75)	
end

function MX.PhaseThree()
	MX.PhaseObj.Objectives:Remove()
	MX.Phase = 3
	MX.PhaseObj:SetPhase(3)
	MX.PhaseObj.Objectives:AddPercent(MX.Murd.Name, 25, 50)	
end

function MX.PhaseFour()
	MX.PhaseObj.Objectives:Remove()
	MX.Phase = 4
	MX.PhaseObj:SetPhase("Final")
	MX.PhaseObj.Objectives:AddPercent(MX.Murd.Name, 0, 25)	
end

function MX:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Murd.Name then
				if not self.Murd.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Murd.Dead = false
					self.Murd.Casting = false
					self.Phase = 1
					self.Murd.CastBar:Create(unitID)
					KBM.TankSwap:Start(self.Lang.Debuff.Mangled[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Murd.Name, 75, 100)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
				end
				self.Murd.UnitID = unitID
				self.Murd.Available = true
				return self.Murd
			end
		end
	end
end

function MX:Reset()
	self.EncounterRunning = false
	self.Murd.UnitID = nil
	self.Murd.CastBar:Remove()
	self.Phase = 1
	self.PhaseObj:End(Inspect.Time.Real())	
end

function MX:Timer()	
end

function MX.Murd:SetTimers(bool)	
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

function MX.Murd:SetAlerts(bool)
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

function MX:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Murd, self.Enabled)
end

function MX:Start()	
	-- Create Timers
	self.Murd.TimersRef.Crush = KBM.MechTimer:Add(self.Lang.Crush[KBM.Lang], 12)
	self.Murd.TimersRef.Pound = KBM.MechTimer:Add(self.Lang.Pound[KBM.Lang], 35)
	self.Murd.TimersRef.Blast = KBM.MechTimer:Add(self.Lang.Blast[KBM.Lang], 16)
	self.Murd.TimersRef.Trauma = KBM.MechTimer:Add(self.Lang.Trauma[KBM.Lang], 9)
	KBM.Defaults.TimerObj.Assign(self.Murd)
	
	-- Create Alerts
	self.Murd.AlertsRef.Trauma = KBM.Alert:Create(self.Lang.Trauma[KBM.Lang], 2, true, nil, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Murd)
	
	-- Assign Mechanics to Triggers
	self.Murd.Triggers.Crush = KBM.Trigger:Create(self.Lang.Crush[KBM.Lang], "damage", self.Murd)
	self.Murd.Triggers.Crush:AddTimer(self.Murd.TimersRef.Crush)
	self.Murd.Triggers.Pound = KBM.Trigger:Create(self.Lang.Pound[KBM.Lang], "damage", self.Murd)
	self.Murd.Triggers.Pound:AddTimer(self.Murd.TimersRef.Pound)
	self.Murd.Triggers.Blast = KBM.Trigger:Create(self.Lang.Blast[KBM.Lang], "cast", self.Murd)
	self.Murd.Triggers.Blast:AddTimer(self.Murd.TimersRef.Blast)
	self.Murd.Triggers.Trauma = KBM.Trigger:Create(self.Lang.Trauma[KBM.Lang], "cast", self.Murd)
	self.Murd.Triggers.Trauma:AddTimer(self.Murd.TimersRef.Trauma)
	self.Murd.Triggers.Trauma:AddAlert(self.Murd.AlertsRef.Trauma)
	self.Murd.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Murd)
	self.Murd.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Murd.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Murd)
	self.Murd.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Murd.Triggers.PhaseFour = KBM.Trigger:Create(25, "percent", self.Murd)
	self.Murd.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	-- Assign Castbar object.
	self.Murd.CastBar = KBM.CastBar:Add(self, self.Murd)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end