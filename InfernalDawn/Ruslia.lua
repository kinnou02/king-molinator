-- Ruslia Dreadblade Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDRS_Settings = nil
chKBMINDRS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local RS = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Ruslia.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Ruslia Dreadblade",
	Object = "RS",
}

RS.Ruslia = {
	Mod = RS,
	Level = "??",
	Active = false,
	Name = "Ruslia Dreadblade",
	NameShort = "Ruslia",
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

KBM.RegisterMod(RS.ID, RS)

-- Main Unit Dictionary
RS.Lang.Unit = {}
RS.Lang.Unit.Ruslia = KBM.Language:Add(RS.Ruslia.Name)
-- RS.Lang.Unit.Ruslia:SetGerman("")
-- RS.Lang.Unit.Ruslia:SetFrench("")
-- RS.Lang.Unit.Ruslia:SetRussian("")

-- Ability Dictionary
RS.Lang.Ability = {}

RS.Ruslia.Name = RS.Lang.Unit.Ruslia[KBM.Lang]
RS.Descript = RS.Ruslia.Name

function RS:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ruslia.Name] = self.Ruslia,
	}
end

function RS:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ruslia.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Ruslia.Settings.TimersRef,
		-- AlertsRef = self.Ruslia.Settings.AlertsRef,
	}
	KBMINDRS_Settings = self.Settings
	chKBMINDRS_Settings = self.Settings
	
end

function RS:SwapSettings(bool)

	if bool then
		KBMINDRS_Settings = self.Settings
		self.Settings = chKBMINDRS_Settings
	else
		chKBMINDRS_Settings = self.Settings
		self.Settings = KBMINDRS_Settings
	end

end

function RS:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDRS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDRS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDRS_Settings = self.Settings
	else
		KBMINDRS_Settings = self.Settings
	end	
end

function RS:SaveVars()	
	if KBM.Options.Character then
		chKBMINDRS_Settings = self.Settings
	else
		KBMINDRS_Settings = self.Settings
	end	
end

function RS:Castbar(units)
end

function RS:RemoveUnits(UnitID)
	if self.Ruslia.UnitID == UnitID then
		self.Ruslia.Available = false
		return true
	end
	return false
end

function RS:Death(UnitID)
	if self.Ruslia.UnitID == UnitID then
		self.Ruslia.Dead = true
		return true
	end
	return false
end

function RS:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Ruslia.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ruslia.Dead = false
					self.Ruslia.Casting = false
					self.Ruslia.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Ruslia.Name, 0, 100)
					self.Phase = 1
				end
				self.Ruslia.UnitID = unitID
				self.Ruslia.Available = true
				return self.Ruslia
			end
		end
	end
end

function RS:Reset()
	self.EncounterRunning = false
	self.Ruslia.Available = false
	self.Ruslia.UnitID = nil
	self.Ruslia.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function RS:Timer()	
end

function RS.Ruslia:SetTimers(bool)	
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

function RS.Ruslia:SetAlerts(bool)
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

function RS:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Ruslia, self.Enabled)
end

function RS:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Ruslia)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Ruslia)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Ruslia.CastBar = KBM.CastBar:Add(self, self.Ruslia)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end