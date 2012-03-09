-- Itualxi Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDIX_Settings = nil
chKBMINDIX_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local IX = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Itualxi.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Itualxi",
	Object = "IX",
}

IX.Itualxi = {
	Mod = IX,
	Level = "??",
	Active = false,
	Name = "Itualxi",
	NameShort = "Itualxi",
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

KBM.RegisterMod(IX.ID, IX)

-- Main Unit Dictionary
IX.Lang.Unit = {}
IX.Lang.Unit.Itualxi = KBM.Language:Add(IX.Itualxi.Name)
-- IX.Lang.Unit.Itualxi:SetGerman("")
-- IX.Lang.Unit.Itualxi:SetFrench("")
-- IX.Lang.Unit.Itualxi:SetRussian("")

-- Ability Dictionary
IX.Lang.Ability = {}

IX.Itualxi.Name = IX.Lang.Unit.Itualxi[KBM.Lang]
IX.Descript = IX.Itualxi.Name

function IX:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Itualxi.Name] = self.Itualxi,
	}
end

function IX:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Itualxi.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Itualxi.Settings.TimersRef,
		-- AlertsRef = self.Itualxi.Settings.AlertsRef,
	}
	KBMINDIX_Settings = self.Settings
	chKBMINDIX_Settings = self.Settings
	
end

function IX:SwapSettings(bool)

	if bool then
		KBMINDIX_Settings = self.Settings
		self.Settings = chKBMINDIX_Settings
	else
		chKBMINDIX_Settings = self.Settings
		self.Settings = KBMINDIX_Settings
	end

end

function IX:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDIX_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDIX_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDIX_Settings = self.Settings
	else
		KBMINDIX_Settings = self.Settings
	end	
end

function IX:SaveVars()	
	if KBM.Options.Character then
		chKBMINDIX_Settings = self.Settings
	else
		KBMINDIX_Settings = self.Settings
	end	
end

function IX:Castbar(units)
end

function IX:RemoveUnits(UnitID)
	if self.Itualxi.UnitID == UnitID then
		self.Itualxi.Available = false
		return true
	end
	return false
end

function IX:Death(UnitID)
	if self.Itualxi.UnitID == UnitID then
		self.Itualxi.Dead = true
		return true
	end
	return false
end

function IX:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Itualxi.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Itualxi.Dead = false
					self.Itualxi.Casting = false
					self.Itualxi.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Itualxi.Name, 0, 100)
					self.Phase = 1
				end
				self.Itualxi.UnitID = unitID
				self.Itualxi.Available = true
				return self.Itualxi
			end
		end
	end
end

function IX:Reset()
	self.EncounterRunning = false
	self.Itualxi.Available = false
	self.Itualxi.UnitID = nil
	self.Itualxi.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function IX:Timer()	
end

function IX.Itualxi:SetTimers(bool)	
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

function IX.Itualxi:SetAlerts(bool)
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

function IX:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Itualxi, self.Enabled)
end

function IX:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Itualxi)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Itualxi)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Itualxi.CastBar = KBM.CastBar:Add(self, self.Itualxi)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end