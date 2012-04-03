-- Warboss Drak Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDWD_Settings = nil
chKBMINDWD_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local WD = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Drak.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Warboss Drak",
	Object = "WD",
}

WD.Drak = {
	Mod = WD,
	Level = "??",
	Active = false,
	Name = "Warboss Drak",
	NameShort = "Drak",
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

KBM.RegisterMod(WD.ID, WD)

-- Main Unit Dictionary
WD.Lang.Unit = {}
WD.Lang.Unit.Drak = KBM.Language:Add(WD.Drak.Name)
WD.Lang.Unit.Drak:SetFrench("Chef de guerre Drak")
WD.Lang.Unit.Drak:SetGerman("Kriegsboss Drak")

-- Ability Dictionary
WD.Lang.Ability = {}

WD.Drak.Name = WD.Lang.Unit.Drak[KBM.Lang]
WD.Descript = WD.Drak.Name

function WD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Drak.Name] = self.Drak,
	}
end

function WD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Drak.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Drak.Settings.TimersRef,
		-- AlertsRef = self.Drak.Settings.AlertsRef,
	}
	KBMINDWD_Settings = self.Settings
	chKBMINDWD_Settings = self.Settings
	
end

function WD:SwapSettings(bool)

	if bool then
		KBMINDWD_Settings = self.Settings
		self.Settings = chKBMINDWD_Settings
	else
		chKBMINDWD_Settings = self.Settings
		self.Settings = KBMINDWD_Settings
	end

end

function WD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDWD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDWD_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDWD_Settings = self.Settings
	else
		KBMINDWD_Settings = self.Settings
	end	
end

function WD:SaveVars()	
	if KBM.Options.Character then
		chKBMINDWD_Settings = self.Settings
	else
		KBMINDWD_Settings = self.Settings
	end	
end

function WD:Castbar(units)
end

function WD:RemoveUnits(UnitID)
	if self.Drak.UnitID == UnitID then
		self.Drak.Available = false
		return true
	end
	return false
end

function WD:Death(UnitID)
	if self.Drak.UnitID == UnitID then
		self.Drak.Dead = true
		return true
	end
	return false
end

function WD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Drak.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Drak.Dead = false
					self.Drak.Casting = false
					self.Drak.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Drak.Name, 0, 100)
					self.Phase = 1
				end
				self.Drak.UnitID = unitID
				self.Drak.Available = true
				return self.Drak
			end
		end
	end
end

function WD:Reset()
	self.EncounterRunning = false
	self.Drak.Available = false
	self.Drak.UnitID = nil
	self.Drak.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function WD:Timer()	
end

function WD.Drak:SetTimers(bool)	
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

function WD.Drak:SetAlerts(bool)
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

function WD:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Drak, self.Enabled)
end

function WD:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Drak)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Drak)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Drak.CastBar = KBM.CastBar:Add(self, self.Drak)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end