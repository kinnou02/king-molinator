﻿-- Rorf Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFOLHRF_Settings = nil
chKBMEXFOLHRF_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Fall of Lantern Hook"]

local MOD = {
	Directory = Instance.Directory,
	File = "Rorf.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Rorf",
}

MOD.Rorf = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Rorf",
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

MOD.Lang.Rorf = KBM.Language:Add(MOD.Rorf.Name)
MOD.Lang.Rorf:SetGerman("Rorf")
-- MOD.Lang.Rorf:SetFrench("")
-- MOD.Lang.Rorf:SetRussian("")
MOD.Rorf.Name = MOD.Lang.Rorf[KBM.Lang]
MOD.Descript = MOD.Rorf.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Sneaky = KBM.Language:Add("Sneaky")
MOD.Lang.Unit.Sneaky.German = "Schleich"
MOD.Lang.Unit.Scratchy = KBM.Language:Add("Scratchy")
MOD.Lang.Unit.Scratchy.German = "Kratz"
MOD.Lang.Unit.Scary = KBM.Language:Add("Scary")
MOD.Lang.Unit.Scary.German = "Schreck" 

MOD.Sneaky = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Sneaky[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	ExpertID = "Expert",
	TimeOut = 5,
}

MOD.Scratchy = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Scratchy[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	ExpertID = "Expert",
	TimeOut = 5,
}

MOD.Scary = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Scary[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	ExpertID = "Expert",
	TimeOut = 5,
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Rorf.Name] = self.Rorf,
		[self.Sneaky.Name] = self.Sneaky,
		[self.Scratchy.Name] = self.Scratchy,
		[self.Scary.Name] = self.Scary,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Rorf.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Rorf.Settings.TimersRef,
		-- AlertsRef = self.Rorf.Settings.AlertsRef,
	}
	KBMEXFOLHRF_Settings = self.Settings
	chKBMEXFOLHRF_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFOLHRF_Settings = self.Settings
		self.Settings = chKBMEXFOLHRF_Settings
	else
		chKBMEXFOLHRF_Settings = self.Settings
		self.Settings = KBMEXFOLHRF_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFOLHRF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFOLHRF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFOLHRF_Settings = self.Settings
	else
		KBMEXFOLHRF_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFOLHRF_Settings = self.Settings
	else
		KBMEXFOLHRF_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Rorf.UnitID == UnitID then
		self.Rorf.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Rorf.UnitID == UnitID then
		self.Rorf.Dead = true
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
					if BossObj.Name == self.Rorf.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Rorf.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Sneaky.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Scratchy.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Scary.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Rorf.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Rorf
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
	end
	self.Rorf.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Rorf:SetTimers(bool)	
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

function MOD.Rorf:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Rorf, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Rorf)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Rorf)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Rorf.CastBar = KBM.CastBar:Add(self, self.Rorf)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end