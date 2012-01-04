-- Soulrender Zilas Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSZ_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local SZ = {
	Enabled = true,
	Instance = HK.Name,
	PhaseObj = nil,
	Phase = 1,
	Timers = {},
	Lang = {},
	ID = "Zilas",
}

SZ.Zilas = {
	Mod = SZ,
	Level = "??",
	Active = false,
	Name = "Soulrender Zilas",
	NameShort = "Zilas",
	CastFilters = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Grasp = KBM.Defaults.TimerObj.Create(),
			GraspFirst = KBM.Defaults.TimerObj.Create(),
		},
		AlertsRef = {
			Enabled = true,
			GraspWarn = KBM.Defaults.AlertObj.Create("orange"),
			Grasp = KBM.Defaults.AlertObj.Create("red"),
		},		
	},
}

KBM.RegisterMod(SZ.ID, SZ)

SZ.Lang.Zilas = KBM.Language:Add(SZ.Zilas.Name)
SZ.Lang.Zilas.German = "Seelenreißer Zilas"
SZ.Lang.Zilas.French = "\195\137tripeur d'\195\162mes Zilas"
SZ.Zilas.Name = SZ.Lang.Zilas[KBM.Lang]

-- Ability Dictionary
SZ.Lang.Ability = {}
SZ.Lang.Ability.Grasp = KBM.Language:Add("Soulrender's Grasp")
SZ.Lang.Ability.Grasp.German = "Seelenreißer Griff"
SZ.Lang.Ability.Grasp.French = "Poigne d'\195\137tripeur d'\195\162mes"

-- Menu Dictionary
SZ.Lang.Menu = {}
SZ.Lang.Menu.Grasp = KBM.Language:Add("First "..SZ.Lang.Ability.Grasp[KBM.Lang])

function SZ:AddBosses(KBM_Boss)
	self.Zilas.Descript = self.Zilas.Name
	self.MenuName = self.Zilas.Descript
	self.Bosses = {
		[self.Zilas.Name] = self.Zilas,
	}
	KBM_Boss[self.Zilas.Name] = self.Zilas	
end

function SZ:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),		
		Alerts = KBM.Defaults.Alerts(),
		CastBar = self.Zilas.Settings.CastBar,
		TimersRef = self.Zilas.Settings.TimersRef,
		AlertsRef = self.Zilas.Settings.AlertsRef,
	}
	KBMSZ_Settings = self.Settings
	chKBMSZ_Settings = self.Settings
	
end

function SZ:SwapSettings(bool)

	if bool then
		KBMSZ_Settings = self.Settings
		self.Settings = chKBMSZ_Settings
	else
		chKBMSZ_Settings = self.Settings
		self.Settings = KBMSZ_Settings
	end

end

function SZ:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSZ_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMSZ_Settings = self.Settings
	else
		KBMSZ_Settings = self.Settings
	end
	
	self.Zilas.Settings.AlertsRef.Grasp.Enabled = true
	
end

function SZ:SaveVars()
	
	if KBM.Options.Settings then
		chKBMSZ_Settings = self.Settings
	else
		KBMSZ_Settings = self.Settings
	end
	
end

function SZ:Castbar(units)
end

function SZ:RemoveUnits(UnitID)
	if self.Zilas.UnitID == UnitID then
		self.Zilas.Available = false
		return true
	end
	return false
end

function SZ:Death(UnitID)
	if self.Zilas.UnitID == UnitID then
		self.Zilas.Dead = true
		return true
	end
	return false
end

function SZ:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Zilas.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Zilas.CastBar:Create(unitID)
					self.PhaseObj.Objectives:AddPercent(self.Zilas.Name, 80, 100)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
				end
				self.Zilas.Dead = false
				self.Zilas.Casting = false
				self.Zilas.UnitID = unitID
				self.Zilas.Available = true
				return self.Zilas
			end
		end
	end
end

function SZ.PhaseTwo()
	SZ.Phase = 2
	SZ.PhaseObj.Objectives:Remove()
	SZ.PhaseObj:SetPhase(2)
	SZ.PhaseObj.Objectives:AddPercent(SZ.Zilas.Name, 60, 80)
	print("Phase 2 Starting!")
end

function SZ.PhaseThree()
	SZ.Phase = 3
	SZ.PhaseObj.Objectives:Remove()
	SZ.PhaseObj:SetPhase(3)
	SZ.PhaseObj.Objectives:AddPercent(SZ.Zilas.Name, 40, 60)
	print("Phase 3 Starting!")
end

function SZ.PhaseFour()
	SZ.Phase = 4
	SZ.PhaseObj.Objectives:Remove()
	SZ.PhaseObj:SetPhase(4)
	SZ.PhaseObj.Objectives:AddPercent(SZ.Zilas.Name, 20, 40)
	print("Phase 4 Starting!")	
end

function SZ.PhaseFive()
	SZ.Phase = 5
	SZ.PhaseObj.Objectives:Remove()
	SZ.PhaseObj:SetPhase("Final")
	SZ.PhaseObj.Objectives:AddPercent(SZ.Zilas.Name, 0, 20)
	print("Final Phase!")
end

function SZ:Reset()
	self.EncounterRunning = false
	self.Zilas.Available = false
	self.Zilas.UnitID = nil
	self.Zilas.CastBar:Remove()
	self.PhaseObj:End(self.TimeElapsed)
	self.Phase = 1	
end

function SZ:Timer()
end

function SZ.Zilas:SetTimers(bool)	
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

function SZ.Zilas:SetAlerts(bool)
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

function SZ:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Zilas, self.Enabled)
end

function SZ:Start()
	-- Create Timers
	self.Zilas.TimersRef.Grasp = KBM.MechTimer:Add(self.Lang.Ability.Grasp[KBM.Lang], 58)
	self.Zilas.TimersRef.GraspFirst = KBM.MechTimer:Add(self.Lang.Ability.Grasp[KBM.Lang], 42)
	self.Zilas.TimersRef.GraspFirst.MenuName = self.Lang.Menu.Grasp[KBM.Lang]
	
	-- Create Alerts
	self.Zilas.AlertsRef.GraspWarn = KBM.Alert:Create(self.Lang.Ability.Grasp[KBM.Lang], 5, true, true)
	self.Zilas.AlertsRef.Grasp = KBM.Alert:Create(self.Lang.Ability.Grasp[KBM.Lang], 9, false, true)
	self.Zilas.AlertsRef.Grasp:NoMenu()

	KBM.Defaults.TimerObj.Assign(self.Zilas)
	KBM.Defaults.AlertObj.Assign(self.Zilas)
	
	-- Assign Mechanics to Triggers.
	self.Zilas.Triggers.Grasp = KBM.Trigger:Create(self.Lang.Ability.Grasp[KBM.Lang], "cast", self.Zilas)
	self.Zilas.Triggers.Grasp:AddTimer(self.Zilas.TimersRef.Grasp)
	self.Zilas.Triggers.Grasp:AddAlert(self.Zilas.AlertsRef.GraspWarn)
	self.Zilas.AlertsRef.GraspWarn:AlertEnd(self.Zilas.AlertsRef.Grasp)
	self.Zilas.Triggers.PhaseTwo = KBM.Trigger:Create(80, "percent", self.Zilas)
	self.Zilas.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Zilas.Triggers.Grasp = KBM.Trigger:Create(70, "percent", self.Zilas)
	self.Zilas.Triggers.Grasp:AddTimer(self.Zilas.TimersRef.GraspFirst)
	self.Zilas.Triggers.PhaseThree = KBM.Trigger:Create(60, "percent", self.Zilas)
	self.Zilas.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Zilas.Triggers.PhaseFour = KBM.Trigger:Create(40, "percent", self.Zilas)
	self.Zilas.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Zilas.Triggers.PhaseFive = KBM.Trigger:Create(20, "percent", self.Zilas)
	self.Zilas.Triggers.PhaseFive:AddPhase(self.PhaseFive)
	
	-- Assign Castbar object.
	self.Zilas.CastBar = KBM.CastBar:Add(self, self.Zilas, true)
	
	-- Assing Phase Tracking.
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end