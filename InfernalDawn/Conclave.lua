-- The Ember Conclave Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDEC_Settings = nil
chKBMINDEC_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local EC = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Conclave.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "The Ember Conclave",
	Object = "EC",
}

EC.Conclave = {
	Mod = EC,
	Level = "??",
	Active = false,
	Name = "The Ember Conclave",
	NameShort = "Conclave",
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

KBM.RegisterMod(EC.ID, EC)

-- Main Unit Dictionary
EC.Lang.Unit = {}
EC.Lang.Unit.Conclave = KBM.Language:Add(EC.Conclave.Name)
-- EC.Lang.Unit.Conclave:SetGerman("")
-- EC.Lang.Unit.Conclave:SetFrench("")
-- EC.Lang.Unit.Conclave:SetRussian("")

-- Ability Dictionary
EC.Lang.Ability = {}

EC.Conclave.Name = EC.Lang.Unit.Conclave[KBM.Lang]
EC.Descript = EC.Conclave.Name

function EC:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Conclave.Name] = self.Conclave,
	}
end

function EC:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Conclave.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Conclave.Settings.TimersRef,
		-- AlertsRef = self.Conclave.Settings.AlertsRef,
	}
	KBMINDEC_Settings = self.Settings
	chKBMINDEC_Settings = self.Settings
	
end

function EC:SwapSettings(bool)

	if bool then
		KBMINDEC_Settings = self.Settings
		self.Settings = chKBMINDEC_Settings
	else
		chKBMINDEC_Settings = self.Settings
		self.Settings = KBMINDEC_Settings
	end

end

function EC:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDEC_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDEC_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDEC_Settings = self.Settings
	else
		KBMINDEC_Settings = self.Settings
	end	
end

function EC:SaveVars()	
	if KBM.Options.Character then
		chKBMINDEC_Settings = self.Settings
	else
		KBMINDEC_Settings = self.Settings
	end	
end

function EC:Castbar(units)
end

function EC:RemoveUnits(UnitID)
	if self.Conclave.UnitID == UnitID then
		self.Conclave.Available = false
		return true
	end
	return false
end

function EC:Death(UnitID)
	if self.Conclave.UnitID == UnitID then
		self.Conclave.Dead = true
		return true
	end
	return false
end

function EC:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Conclave.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Conclave.Dead = false
					self.Conclave.Casting = false
					self.Conclave.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Conclave.Name, 0, 100)
					self.Phase = 1
				end
				self.Conclave.UnitID = unitID
				self.Conclave.Available = true
				return self.Conclave
			end
		end
	end
end

function EC:Reset()
	self.EncounterRunning = false
	self.Conclave.Available = false
	self.Conclave.UnitID = nil
	self.Conclave.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function EC:Timer()	
end

function EC.Conclave:SetTimers(bool)	
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

function EC.Conclave:SetAlerts(bool)
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

function EC:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Conclave, self.Enabled)
end

function EC:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Conclave)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Conclave)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Conclave.CastBar = KBM.CastBar:Add(self, self.Conclave)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end