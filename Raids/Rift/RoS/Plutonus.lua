-- Plutonus the Immortal Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSPI_Settings = nil
chKBMROSPI_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local ROS = KBM.BossMod["River of Souls"]

local PI = {
	Enabled = true,
	Directory = ROS.Directory,
	File = "Plutonus.lua",
	Instance = ROS.Name,
	InstanceObj = ROS,
	HasPhases = true,
	Lang = {},
	ID = "Plutonus",
	Object = "PI",
}

PI.Plutonus = {
	Mod = PI,
	Level = "??",
	Active = false,
	Name = "Plutonus the Immortal",
	NameShort = "Plutonus",
	UTID = "U2DB0546F4CB868BE",
	Dead = false,
	Available = false,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Sleep = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Sleep = KBM.Defaults.AlertObj.Create("purple"),
			Forty = KBM.Defaults.AlertObj.Create("dark_green"),
			Thirty = KBM.Defaults.AlertObj.Create("yellow"),
			Twenty = KBM.Defaults.AlertObj.Create("orange"),
			Ten = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Sleep = KBM.Defaults.MechObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(PI.ID, PI)

-- Main Unit Dictionary
PI.Lang.Unit = {}
PI.Lang.Unit.Plutonus = KBM.Language:Add(PI.Plutonus.Name)
PI.Lang.Unit.Plutonus:SetGerman("Plutonus der Unsterbliche")
PI.Lang.Unit.Plutonus:SetFrench("Plutonus l'Immortel")
PI.Lang.Unit.Plutonus:SetRussian("Плутон Бессмертный")
PI.Lang.Unit.Plutonus:SetKorean("불멸의 플루토누스")
-- Ability Dictionary
PI.Lang.Ability = {}
PI.Lang.Ability.Sleep = KBM.Language:Add("Walking Sleep")
PI.Lang.Ability.Sleep:SetGerman("Wandelnder Schlaf")
PI.Lang.Ability.Sleep:SetFrench("Somnambulisme")
PI.Lang.Ability.Sleep:SetRussian("Сон на ходу")
PI.Lang.Ability.Sleep:SetKorean("몽유병")
PI.Plutonus.Name = PI.Lang.Unit.Plutonus[KBM.Lang]
PI.Descript = PI.Plutonus.Name

function PI:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Plutonus.Name] = self.Plutonus,
	}
end

function PI:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Plutonus.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		TimersRef = self.Plutonus.Settings.TimersRef,
		AlertsRef = self.Plutonus.Settings.AlertsRef,
		MechRef = self.Plutonus.Settings.MechRef,
	}
	KBMROSPI_Settings = self.Settings
	chKBMROSPI_Settings = self.Settings
end

function PI:SwapSettings(bool)
	if bool then
		KBMROSPI_Settings = self.Settings
		self.Settings = chKBMROSPI_Settings
	else
		chKBMROSPI_Settings = self.Settings
		self.Settings = KBMROSPI_Settings
	end
end

function PI:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROSPI_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROSPI_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMROSPI_Settings = self.Settings
	else
		KBMROSPI_Settings = self.Settings
	end	
end

function PI:SaveVars()
	if KBM.Options.Character then
		chKBMROSPI_Settings = self.Settings
	else
		KBMROSPI_Settings = self.Settings
	end	
end

function PI:Castbar(units)
end

function PI:RemoveUnits(UnitID)
	if self.Plutonus.UnitID == UnitID then
		self.Plutonus.Available = false
		return true
	end
	return false
end

function PI:Death(UnitID)
	if self.Plutonus.UnitID == UnitID then
		self.Plutonus.Dead = true
		return true
	end
	return false
end

function PI.PhaseTwo()
	PI.PhaseObj.Objectives:Remove()
	PI.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	PI.Phase = 2
	PI.PhaseObj.Objectives:AddPercent(PI.Plutonus, 0, 50)
end

function PI:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Plutonus.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Plutonus.Dead = false
					self.Plutonus.CastBar:Create(unitID)
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
					self.PhaseObj.Objectives:AddPercent(self.Plutonus, 50, 100)
				end
				self.Plutonus.Casting = false
				self.Plutonus.UnitID = unitID
				self.Plutonus.Available = true
				return self.Plutonus
			end
		end
	end
end

function PI:Reset()
	self.EncounterRunning = false
	self.Plutonus.Available = false
	self.Plutonus.UnitID = nil
	self.Plutonus.CastBar:Remove()
	self.Plutonus.Dead = false
	self.Phase = 1
	self.PhaseObj:End(Inspect.Time.Real())
end

function PI:Timer()	
end

function PI:DefineMenu()
	self.Menu = ROS.Menu:CreateEncounter(self.Plutonus, self.Enabled)
end

function PI:Start()
	-- Create Timers
	self.Plutonus.TimersRef.Sleep = KBM.MechTimer:Add(self.Lang.Ability.Sleep[KBM.Lang], 23)
	KBM.Defaults.TimerObj.Assign(self.Plutonus)

	-- Create Mechanic Spies
	self.Plutonus.MechRef.Sleep = KBM.MechSpy:Add(self.Lang.Ability.Sleep[KBM.Lang], nil, "playerBuff", self.Plutonus)
	KBM.Defaults.MechObj.Assign(self.Plutonus)
	
	-- Create Alerts
	self.Plutonus.AlertsRef.Sleep = KBM.Alert:Create(self.Lang.Ability.Sleep[KBM.Lang], nil, true, false, "purple")
	self.Plutonus.AlertsRef.Forty = KBM.Alert:Create("40%", 3, true, false, "dark_green")
	self.Plutonus.AlertsRef.Thirty = KBM.Alert:Create("30%", 3, true, false, "yellow")
	self.Plutonus.AlertsRef.Twenty = KBM.Alert:Create("20%", 3, true, false, "orange")
	self.Plutonus.AlertsRef.Ten = KBM.Alert:Create("10%", 3, true, false, "red")
	KBM.Defaults.AlertObj.Assign(self.Plutonus)
	
	-- Assign Alerts to Triggers
	self.Plutonus.Triggers.Sleep = KBM.Trigger:Create(self.Lang.Ability.Sleep[KBM.Lang], "playerBuff", self.Plutonus)
	self.Plutonus.Triggers.Sleep:AddTimer(self.Plutonus.TimersRef.Sleep)
	self.Plutonus.Triggers.Sleep:AddAlert(self.Plutonus.AlertsRef.Sleep)
	self.Plutonus.Triggers.Sleep:AddSpy(self.Plutonus.MechRef.Sleep)
	self.Plutonus.Triggers.SleepRemove = KBM.Trigger:Create(self.Lang.Ability.Sleep[KBM.Lang], "playerBuffRemove", self.Plutonus)
	self.Plutonus.Triggers.SleepRemove:AddStop(self.Plutonus.AlertsRef.Sleep)
	self.Plutonus.Triggers.SleepRemove:AddStop(self.Plutonus.MechRef.Sleep)
	self.Plutonus.Triggers.PhaseTwo = KBM.Trigger:Create(50, "percent", self.Plutonus)
	self.Plutonus.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Plutonus.Triggers.Forty = KBM.Trigger:Create(40, "percent", self.Plutonus)
	self.Plutonus.Triggers.Forty:AddAlert(self.Plutonus.AlertsRef.Forty)
	self.Plutonus.Triggers.Thirty = KBM.Trigger:Create(30, "percent", self.Plutonus)
	self.Plutonus.Triggers.Thirty:AddAlert(self.Plutonus.AlertsRef.Thirty)
	self.Plutonus.Triggers.Twenty = KBM.Trigger:Create(20, "percent", self.Plutonus)
	self.Plutonus.Triggers.Twenty:AddAlert(self.Plutonus.AlertsRef.Twenty)
	self.Plutonus.Triggers.Ten = KBM.Trigger:Create(10, "percent", self.Plutonus)
	self.Plutonus.Triggers.Ten:AddAlert(self.Plutonus.AlertsRef.Ten)
	
	self.Plutonus.CastBar = KBM.Castbar:Add(self, self.Plutonus)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end