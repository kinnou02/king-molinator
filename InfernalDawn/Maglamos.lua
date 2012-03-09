-- Maglamos the Scryer Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDML_Settings = nil
chKBMINDML_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local ML = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Maglamos.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Maglamos the Scryer",
	Object = "ML",
}

ML.Maglamos = {
	Mod = ML,
	Level = "??",
	Active = false,
	Name = "Maglamos the Scryer",
	NameShort = "Maglamos",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

KBM.RegisterMod(ML.ID, ML)

-- Main Unit Dictionary
ML.Lang.Unit = {}
ML.Lang.Unit.Maglamos = KBM.Language:Add(ML.Maglamos.Name)
-- ML.Lang.Unit.Maglamos:SetGerman("")
-- ML.Lang.Unit.Maglamos:SetFrench("")
-- ML.Lang.Unit.Maglamos:SetRussian("")

-- Ability Dictionary
ML.Lang.Ability = {}

ML.Maglamos.Name = ML.Lang.Unit.Maglamos[KBM.Lang]
ML.Descript = ML.Maglamos.Name

function ML:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maglamos.Name] = self.Maglamos,
	}
end

function ML:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maglamos.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Maglamos.Settings.TimersRef,
		-- AlertsRef = self.Maglamos.Settings.AlertsRef,
	}
	KBMINDML_Settings = self.Settings
	chKBMINDML_Settings = self.Settings
	
end

function ML:SwapSettings(bool)

	if bool then
		KBMINDML_Settings = self.Settings
		self.Settings = chKBMINDML_Settings
	else
		chKBMINDML_Settings = self.Settings
		self.Settings = KBMINDML_Settings
	end

end

function ML:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDML_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDML_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDML_Settings = self.Settings
	else
		KBMINDML_Settings = self.Settings
	end	
end

function ML:SaveVars()	
	if KBM.Options.Character then
		chKBMINDML_Settings = self.Settings
	else
		KBMINDML_Settings = self.Settings
	end	
end

function ML:Castbar(units)
end

function ML:RemoveUnits(UnitID)
	if self.Maglamos.UnitID == UnitID then
		self.Maglamos.Available = false
		return true
	end
	return false
end

function ML:Death(UnitID)
	if self.Maglamos.UnitID == UnitID then
		self.Maglamos.Dead = true
		return true
	end
	return false
end

function ML:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Maglamos.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Maglamos.Dead = false
					self.Maglamos.Casting = false
					self.Maglamos.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Maglamos.Name, 0, 100)
					self.Phase = 1
				end
				self.Maglamos.UnitID = unitID
				self.Maglamos.Available = true
				return self.Maglamos
			end
		end
	end
end

function ML:Reset()
	self.EncounterRunning = false
	self.Maglamos.Available = false
	self.Maglamos.UnitID = nil
	self.Maglamos.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function ML:Timer()	
end

function ML.Maglamos:SetTimers(bool)	
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

function ML.Maglamos:SetAlerts(bool)
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

function ML:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Maglamos, self.Enabled)
end

function ML:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Maglamos)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Maglamos)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Maglamos.CastBar = KBM.CastBar:Add(self, self.Maglamos)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end