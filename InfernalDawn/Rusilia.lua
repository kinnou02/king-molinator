-- Rusilia Dreadblade Boss Mod for King Boss Mods
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
	File = "Rusilia.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Rusilia Dreadblade",
	Object = "RS",
}

RS.Rusilia = {
	Mod = RS,
	Level = "??",
	Active = false,
	Name = "Rusilia Dreadblade",
	NameShort = "Rusilia",
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
RS.Lang.Unit.Rusilia = KBM.Language:Add(RS.Rusilia.Name)
-- RS.Lang.Unit.Rusilia:SetGerman("")
-- RS.Lang.Unit.Rusilia:SetFrench("")
-- RS.Lang.Unit.Rusilia:SetRussian("")

-- Ability Dictionary
RS.Lang.Ability = {}

RS.Rusilia.Name = RS.Lang.Unit.Rusilia[KBM.Lang]
RS.Descript = RS.Rusilia.Name

function RS:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Rusilia.Name] = self.Rusilia,
	}
end

function RS:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Rusilia.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Rusilia.Settings.TimersRef,
		-- AlertsRef = self.Rusilia.Settings.AlertsRef,
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
	if self.Rusilia.UnitID == UnitID then
		self.Rusilia.Available = false
		return true
	end
	return false
end

function RS:Death(UnitID)
	if self.Rusilia.UnitID == UnitID then
		self.Rusilia.Dead = true
		return true
	end
	return false
end

function RS:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Rusilia.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Rusilia.Dead = false
					self.Rusilia.Casting = false
					self.Rusilia.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Rusilia.Name, 0, 100)
					self.Phase = 1
				end
				self.Rusilia.UnitID = unitID
				self.Rusilia.Available = true
				return self.Rusilia
			end
		end
	end
end

function RS:Reset()
	self.EncounterRunning = false
	self.Rusilia.Available = false
	self.Rusilia.UnitID = nil
	self.Rusilia.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function RS:Timer()	
end

function RS.Rusilia:SetTimers(bool)	
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

function RS.Rusilia:SetAlerts(bool)
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
	self.Menu = IND.Menu:CreateEncounter(self.Rusilia, self.Enabled)
end

function RS:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Rusilia)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Rusilia)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Rusilia.CastBar = KBM.CastBar:Add(self, self.Rusilia)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end