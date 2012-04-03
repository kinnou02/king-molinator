-- Ituziel Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDIZ_Settings = nil
chKBMINDIZ_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local IZ = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Ituziel.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Ituziel",
	Object = "IZ",
}

IZ.Ituziel = {
	Mod = IZ,
	Level = "??",
	Active = false,
	Name = "Ituziel",
	NameShort = "Ituziel",
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

KBM.RegisterMod(IZ.ID, IZ)

-- Main Unit Dictionary
IZ.Lang.Unit = {}
IZ.Lang.Unit.Ituziel = KBM.Language:Add(IZ.Ituziel.Name)
IZ.Lang.Unit.Ituziel:SetFrench()
IZ.Lang.Unit.Ituziel:SetGerman() 

-- Ability Dictionary
IZ.Lang.Ability = {}

IZ.Ituziel.Name = IZ.Lang.Unit.Ituziel[KBM.Lang]
IZ.Descript = IZ.Ituziel.Name

function IZ:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ituziel.Name] = self.Ituziel,
	}
	KBM_Boss[self.Ituziel.Name] = self.Ituzial
end

function IZ:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ituziel.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Ituziel.Settings.TimersRef,
		-- AlertsRef = self.Ituziel.Settings.AlertsRef,
	}
	KBMINDIZ_Settings = self.Settings
	chKBMINDIZ_Settings = self.Settings
	
end

function IZ:SwapSettings(bool)

	if bool then
		KBMINDIZ_Settings = self.Settings
		self.Settings = chKBMINDIZ_Settings
	else
		chKBMINDIZ_Settings = self.Settings
		self.Settings = KBMINDIZ_Settings
	end

end

function IZ:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDIZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDIZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDIZ_Settings = self.Settings
	else
		KBMINDIZ_Settings = self.Settings
	end	
end

function IZ:SaveVars()	
	if KBM.Options.Character then
		chKBMINDIZ_Settings = self.Settings
	else
		KBMINDIZ_Settings = self.Settings
	end	
end

function IZ:Castbar(units)
end

function IZ:RemoveUnits(UnitID)
	if self.Ituziel.UnitID == UnitID then
		self.Ituziel.Available = false
		return true
	end
	return false
end

function IZ:Death(UnitID)
	if self.Ituziel.UnitID == UnitID then
		self.Ituziel.Dead = true
		return true
	end
	return false
end

function IZ:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Ituziel.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ituziel.Dead = false
					self.Ituziel.Casting = false
					self.Ituziel.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Ituziel.Name, 0, 100)
					self.Phase = 1
				end
				self.Ituziel.UnitID = unitID
				self.Ituziel.Available = true
				return self.Ituziel
			end
		end
	end
end

function IZ:Reset()
	self.EncounterRunning = false
	self.Ituziel.Available = false
	self.Ituziel.UnitID = nil
	self.Ituziel.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function IZ:Timer()	
end

function IZ.Ituziel:SetTimers(bool)	
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

function IZ.Ituziel:SetAlerts(bool)
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

function IZ:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Ituziel, self.Enabled)
end

function IZ:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Ituziel)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Ituziel)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Ituziel.CastBar = KBM.CastBar:Add(self, self.Ituziel)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end