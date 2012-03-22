-- Maelforge Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDMF_Settings = nil
chKBMINDMF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local MF = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Maelforge.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Maelforge",
	Object = "MF",
}

MF.Maelforge = {
	Mod = MF,
	Level = "??",
	Active = false,
	Name = "Maelforge",
	NameShort = "Maelforge",
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

KBM.RegisterMod(MF.ID, MF)

-- Main Unit Dictionary
MF.Lang.Unit = {}
MF.Lang.Unit.Maelforge = KBM.Language:Add(MF.Maelforge.Name)
MF.Lang.Unit.Maelforge:SetGerman()
MF.Lang.Unit.Maelforge:SetFrench()
MF.Lang.Unit.Maelforge:SetRussian("Маэлфорж")

-- Ability Dictionary
MF.Lang.Ability = {}

MF.Maelforge.Name = MF.Lang.Unit.Maelforge[KBM.Lang]
MF.Descript = MF.Maelforge.Name

function MF:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maelforge.Name] = self.Maelforge,
	}
end

function MF:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maelforge.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Maelforge.Settings.TimersRef,
		-- AlertsRef = self.Maelforge.Settings.AlertsRef,
	}
	KBMINDMF_Settings = self.Settings
	chKBMINDMF_Settings = self.Settings
	
end

function MF:SwapSettings(bool)

	if bool then
		KBMINDMF_Settings = self.Settings
		self.Settings = chKBMINDMF_Settings
	else
		chKBMINDMF_Settings = self.Settings
		self.Settings = KBMINDMF_Settings
	end

end

function MF:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDMF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDMF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDMF_Settings = self.Settings
	else
		KBMINDMF_Settings = self.Settings
	end	
end

function MF:SaveVars()	
	if KBM.Options.Character then
		chKBMINDMF_Settings = self.Settings
	else
		KBMINDMF_Settings = self.Settings
	end	
end

function MF:Castbar(units)
end

function MF:RemoveUnits(UnitID)
	if self.Maelforge.UnitID == UnitID then
		self.Maelforge.Available = false
		return true
	end
	return false
end

function MF:Death(UnitID)
	if self.Maelforge.UnitID == UnitID then
		self.Maelforge.Dead = true
		return true
	end
	return false
end

function MF:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Maelforge.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Maelforge.Dead = false
					self.Maelforge.Casting = false
					self.Maelforge.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Maelforge.Name, 0, 100)
					self.Phase = 1
				end
				self.Maelforge.UnitID = unitID
				self.Maelforge.Available = true
				return self.Maelforge
			end
		end
	end
end

function MF:Reset()
	self.EncounterRunning = false
	self.Maelforge.Available = false
	self.Maelforge.UnitID = nil
	self.Maelforge.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MF:Timer()	
end

function MF.Maelforge:SetTimers(bool)	
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

function MF.Maelforge:SetAlerts(bool)
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

function MF:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Maelforge, self.Enabled)
end

function MF:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Maelforge)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Maelforge)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Maelforge.CastBar = KBM.CastBar:Add(self, self.Maelforge)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end