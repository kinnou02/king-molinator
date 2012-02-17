﻿-- Flesheater Autoch Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFOLHAM_Settings = nil
chKBMEXFOLHAM_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Kings Breach"]

local MOD = {
	Directory = Instance.Directory,
	File = "Autoch.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Autoch",
}

MOD.Autoch = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Flesheater Autoch",
	NameShort = "Autoch",
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

MOD.Lang.Autoch = KBM.Language:Add(MOD.Autoch.Name)
MOD.Lang.Autoch:SetGerman("Fleischfresser Autoch")
-- MOD.Lang.Autoch:SetFrench("")
-- MOD.Lang.Autoch:SetRussian("")
MOD.Autoch.Name = MOD.Lang.Autoch[KBM.Lang]
MOD.Descript = MOD.Autoch.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Mondrach = KBM.Language:Add("Soulflayer Mondrach")
MOD.Lang.Unit.Mondrach.German = "Seelenschinder Mondrach"

MOD.Mondrach = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Mondrach[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "Expert",
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Autoch.Name] = self.Autoch,
		[self.Mondrach.Name] = self.Mondrach,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Autoch.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Autoch.Settings.TimersRef,
		-- AlertsRef = self.Autoch.Settings.AlertsRef,
	}
	KBMEXFOLHAM_Settings = self.Settings
	chKBMEXFOLHAM_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFOLHAM_Settings = self.Settings
		self.Settings = chKBMEXFOLHAM_Settings
	else
		chKBMEXFOLHAM_Settings = self.Settings
		self.Settings = KBMEXFOLHAM_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFOLHAM_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFOLHAM_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFOLHAM_Settings = self.Settings
	else
		KBMEXFOLHAM_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFOLHAM_Settings = self.Settings
	else
		KBMEXFOLHAM_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Autoch.UnitID == UnitID then
		self.Autoch.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Autoch.UnitID == UnitID then
		self.Autoch.Dead = true
	elseif self.Mondrach.UnitID == UnitID then
		self.Mondrach.Dead = true
	end
	if self.Autoch.Dead and self.Mondrach.Dead then
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if self.Bosses[unitDetails.name] then
				local BossObj = self.Bosses[unitDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Autoch.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Autoch.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Mondrach.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Autoch.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Autoch
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
	end
	self.Autoch.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Autoch:SetTimers(bool)	
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

function MOD.Autoch:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Autoch, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Autoch)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Autoch)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Autoch.CastBar = KBM.CastBar:Add(self, self.Autoch)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end