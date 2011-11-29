-- Duke Letareus Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBDL_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GSB = KBM.BossMod["Greenscales Blight"]

local DL = {
	ModEnabled = true,
	Letareus = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = GSB.Name,
	Type = "20man",
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	ID = "Letareus",	
}

DL.Letareus = {
	Mod = DL,
	Level = "52",
	Active = false,
	Name = "Duke Letareus",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 3,
	Triggers = {},
}

KBM.RegisterMod(DL.ID, DL)

DL.Lang.Letareus = KBM.Language:Add(DL.Letareus.Name)
DL.Lang.Letareus.German = "Herzog Letareus"
DL.Lang.Letareus.French = "Duc Letareus"
DL.Letareus.Name = DL.Lang.Letareus[KBM.Lang]

-- Ability Dictionary
DL.Lang.Ability = {}
DL.Lang.Ability.Wrath = KBM.Language:Add("Duke's Wrath")

-- Mechanic Dictionary
DL.Lang.Mechanic = {}
DL.Lang.Mechanic.Tank = KBM.Language:Add("Tank Phase")

function DL:AddBosses(KBM_Boss)

	self.Letareus.Descript = self.Letareus.Name
	self.MenuName = self.Letareus.Descript
	self.Bosses = {
		[self.Letareus.Name] = self.Letareus,
	}
	KBM_Boss[self.Letareus.Name] = self.Letareus
	
end

function DL:InitVars()

	self.Settings = {
		Timers = {
			Enabled = true,
		},
		Alerts = {
			Enabled = true,
			Wrath = true,
			Tank = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMGSBDL_Settings = self.Settings
	chKBMGSBDL_Settings = self.Settings
	
end

function DL:LoadVars()

	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMGSBDL_Settings
	else
		TargetLoad = KBMGSBDL_Settings
	end
	
	if type(TargetLoad) == "table" then
		for Setting, Value in pairs(TargetLoad) do
			if type(TargetLoad[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(TargetLoad[Setting]) do
						if self.Settings[Setting][tSetting] ~= nil then
							self.Settings[Setting][tSetting] = tValue
						end
					end
				end
			else
				if self.Settings[Setting] ~= nil then
					self.Settings[Setting] = Value
				end
			end
		end
	end
	
	if KBM.Options.Character then
		chKBMGSBDL_Settings = self.Settings
	else
		KBMGSBDL_Settings = self.Settings
	end
	
end

function DL:SaveVars()
	
	if KBM.Options.Character then
		chKBMGSBDL_Settings = self.Settings
	else
		KBMGSBDL_Settings = self.Settings
	end
	
end

function DL:Castbar(units)
end

function DL:RemoveUnits(UnitID)
	if self.Letareus.UnitID == UnitID then
		self.Letareus.Available = false
		return true
	end
	return false
end

function DL:Death(UnitID)
	if self.Letareus.UnitID == UnitID then
		self.Letareus.Dead = true
		return true
	end
	return false
end

function DL:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Letareus.Name then
				if not self.Letareus.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Phase = 1
					self.Letareus.CastBar:Create(unitID)
					self.PhaseObj.Objectives:AddPercent(self.Letareus.Name, 86, 100)
					self.PhaseObj:Start(self.StartTime)
				end
				self.Letareus.Dead = false
				self.Letareus.Casting = false
				self.Letareus.UnitID = unitID
				self.Letareus.Available = true
				return self.Letareus
			end
		end
	end
	
end

function DL:PhaseTwo()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase("Kite")
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus.Name, 76, 86)	
end

function DL:PhaseThree()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase("Tank")
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus.Name, 61, 76)
end

function DL:PhaseFour()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase("Kite")
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus.Name, 51, 61)
end

function DL:PhaseFive()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase("Tank")
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus.Name, 36, 51)
end

function DL:PhaseSix()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase("Kite")
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus.Name, 26, 36)
end

function DL.PhaseSeven()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase("Tank")
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus.Name, 11, 26)
end

function DL.PhaseEight()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase("Kite")
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus.Name, 0, 11)
end

function DL:Reset()

	self.EncounterRunning = false
	self.Letareus.Available = false
	self.Letareus.UnitID = nil
	self.Letareus.CastBar:Remove()
	self.Phase = 1
	self.PhaseObj:End()
	
end

function DL:Timer()
	
end

function DL:SetAlerts(bool)

	if bool then
		self.Letareus.AlertsRef.Wrath.Enabled = self.Settings.Alerts.Trauma
		self.Letareus.AlertsRef.Tank.Enabled = self.Settings.Alerts.Tank
	else
		self.Letareus.AlertsRef.Wrath.Enabled = false
		self.Letareus.AlertsRef.Tank.Enabled = false
	end
	
end

function DL.Letareus:Options()

	-- Timer Settings.
	function self:Timers(bool)
	end
	-- Alert Settings
	function self:Alerts(bool)
		DL.Settings.Alerts.Enabled = bool
		DL:SetAlerts(bool)
	end
	function self:WrathAlert(bool)
		DL.Settings.Alerts.Wrath = bool
		DL.Letareus.AlertsRef.Wrath.Enabled = bool
	end
	function self:TankAlert(bool)
		DL.Settings.Alerts.Tank = bool
		DL.Letareus.AlertsRef.Tank.Enabled = bool
	end
	
	-- Create Options Page.
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, DL.Settings.Alerts.Enabled)
	Alerts:AddCheck(DL.Lang.Ability.Wrath[KBM.Lang], self.WrathAlert, DL.Settings.Alerts.Wrath)
	Alerts:AddCheck(DL.Lang.Mechanic.Tank[KBM.Lang], self.TankAlert, DL.Settings.Alerts.Tank)
	
end

function DL:Start()

	-- Create Options Menu.
	self.Header = KBM.HeaderList[self.Instance]
	self.Letareus.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Letareus, true, self.Header)
	self.Letareus.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	
	-- Create AlertsRef
	self.Letareus.AlertsRef.Wrath = KBM.Alert:Create(self.Lang.Ability.Wrath[KBM.Lang], nil, true, true, "red")
	self.Letareus.AlertsRef.Tank = KBM.Alert:Create(self.Lang.Mechanic.Tank[KBM.Lang], 2, true, false, "orange")
	self:SetAlerts(self.Settings.Alerts.Enabled)
	
	-- Assign Mechanics to Triggers
	self.Letareus.Triggers.Wrath = KBM.Trigger:Create(self.Lang.Ability.Wrath[KBM.Lang], "cast", self.Letareus)
	self.Letareus.Triggers.Wrath:AddAlert(self.Letareus.AlertsRef.Wrath)
	self.Letareus.Triggers.PhaseTwo = KBM.Trigger:Create(86, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Letareus.Triggers.PhaseThree = KBM.Trigger:Create(76, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Letareus.Triggers.PhaseThree:AddAlert(self.Letareus.AlertsRef.Tank)
	self.Letareus.Triggers.PhaseFour = KBM.Trigger:Create(61, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Letareus.Triggers.PhaseFive = KBM.Trigger:Create(51, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseFive:AddPhase(self.PhaseFive)
	self.Letareus.Triggers.PhaseFive:AddAlert(self.Letareus.AlertsRef.Tank)
	self.Letareus.Triggers.PhaseSix = KBM.Trigger:Create(36, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseSix:AddPhase(self.PhaseSix)
	self.Letareus.Triggers.PhaseSeven = KBM.Trigger:Create(26, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseSeven:AddPhase(self.PhaseSeven)
	self.Letareus.Triggers.PhaseSeven:AddAlert(self.Letareus.AlertsRef.Tank)
	self.Letareus.Triggers.PhaseEight = KBM.Trigger:Create(11, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseEight:AddPhase(self.PhaseEight)
		
	-- Initialize Castbar and Phase Object.
	self.Letareus.CastBar = KBM.CastBar:Add(self, self.Letareus, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create("Tank")
	
end