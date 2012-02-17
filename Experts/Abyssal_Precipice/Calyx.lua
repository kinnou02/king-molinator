﻿-- Calyx the Ancient Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXAPCA_Settings = nil
chKBMEXAPCA_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Abyssal Precipice"]

local MOD = {
	Directory = Instance.Directory,
	File = "Calyx.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Calyx",
}

MOD.Calyx = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Calyx the Ancient",
	NameShort = "Calyx",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "Expert",
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

KBM.RegisterMod(MOD.ID, MOD)

MOD.Lang.Calyx = KBM.Language:Add(MOD.Calyx.Name)
MOD.Lang.Calyx:SetGerman("Calyx der Alte")
-- MOD.Lang.Calyx:SetFrench("")
-- MOD.Lang.Calyx:SetRussian("")
MOD.Calyx.Name = MOD.Lang.Calyx[KBM.Lang]
MOD.Descript = MOD.Calyx.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Calyx.Name] = self.Calyx,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Calyx.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Calyx.Settings.TimersRef,
		-- AlertsRef = self.Calyx.Settings.AlertsRef,
	}
	KBMEXAPKA_Settings = self.Settings
	chKBMEXAPKA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXAPCA_Settings = self.Settings
		self.Settings = chKBMEXAPCA_Settings
	else
		chKBMEXAPCA_Settings = self.Settings
		self.Settings = KBMEXAPCA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXAPCA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXAPCA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXAPCA_Settings = self.Settings
	else
		KBMEXAPCA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXAPCA_Settings = self.Settings
	else
		KBMEXAPCA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Calyx.UnitID == UnitID then
		self.Calyx.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Calyx.UnitID == UnitID then
		self.Calyx.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Calyx.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Calyx.Dead = false
					self.Calyx.Casting = false
					self.Calyx.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Calyx.Name, 0, 100)
					self.Phase = 1
				end
				self.Calyx.UnitID = unitID
				self.Calyx.Available = true
				return self.Calyx
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Calyx.Available = false
	self.Calyx.UnitID = nil
	self.Calyx.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Calyx:SetTimers(bool)	
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

function MOD.Calyx:SetAlerts(bool)
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

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Calyx, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Calyx)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Calyx)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Calyx.CastBar = KBM.CastBar:Add(self, self.Calyx)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end