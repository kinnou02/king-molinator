-- Laethys Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDLT_Settings = nil
chKBMINDLT_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local LT = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Laethys.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Laethys",
	Object = "LT",
}

LT.Laethys = {
	Mod = LT,
	Level = "??",
	Active = false,
	Name = "Laethys",
	NameShort = "Laethys",
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

KBM.RegisterMod(LT.ID, LT)

-- Main Unit Dictionary
LT.Lang.Unit = {}
LT.Lang.Unit.Laethys = KBM.Language:Add(LT.Laethys.Name)
LT.Lang.Unit.Laethys:SetGerman()
LT.Lang.Unit.Laethys:SetFrench()
LT.Lang.Unit.Laethys:SetRussian("Лаэтис")

-- Ability Dictionary
LT.Lang.Ability = {}

LT.Laethys.Name = LT.Lang.Unit.Laethys[KBM.Lang]
LT.Descript = LT.Laethys.Name

function LT:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Laethys.Name] = self.Laethys,
	}
end

function LT:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Laethys.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Laethys.Settings.TimersRef,
		-- AlertsRef = self.Laethys.Settings.AlertsRef,
	}
	KBMINDLT_Settings = self.Settings
	chKBMINDLT_Settings = self.Settings
	
end

function LT:SwapSettings(bool)

	if bool then
		KBMINDLT_Settings = self.Settings
		self.Settings = chKBMINDLT_Settings
	else
		chKBMINDLT_Settings = self.Settings
		self.Settings = KBMINDLT_Settings
	end

end

function LT:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDLT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDLT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDLT_Settings = self.Settings
	else
		KBMINDLT_Settings = self.Settings
	end	
end

function LT:SaveVars()	
	if KBM.Options.Character then
		chKBMINDLT_Settings = self.Settings
	else
		KBMINDLT_Settings = self.Settings
	end	
end

function LT:Castbar(units)
end

function LT:RemoveUnits(UnitID)
	if self.Laethys.UnitID == UnitID then
		self.Laethys.Available = false
		return true
	end
	return false
end

function LT:Death(UnitID)
	if self.Laethys.UnitID == UnitID then
		self.Laethys.Dead = true
		return true
	end
	return false
end

function LT:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Laethys.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Laethys.Dead = false
					self.Laethys.Casting = false
					self.Laethys.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Laethys.Name, 0, 100)
					self.Phase = 1
				end
				self.Laethys.UnitID = unitID
				self.Laethys.Available = true
				return self.Laethys
			end
		end
	end
end

function LT:Reset()
	self.EncounterRunning = false
	self.Laethys.Available = false
	self.Laethys.UnitID = nil
	self.Laethys.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function LT:Timer()	
end

function LT.Laethys:SetTimers(bool)	
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

function LT.Laethys:SetAlerts(bool)
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

function LT:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Laethys, self.Enabled)
end

function LT:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Laethys)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Laethys)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Laethys.CastBar = KBM.CastBar:Add(self, self.Laethys)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end