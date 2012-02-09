-- Scarn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDDSN_Settings = nil
chKBMEXDDSN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Darkening Deeps"]

local MOD = {
	Directory = Instance.Directory,
	File = "Scarn.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Scarn",
}

MOD.Scarn = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Scarn",
	--NameShort = "Scarn",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
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

MOD.Lang.Scarn = KBM.Language:Add(MOD.Scarn.Name)
-- MOD.Lang.Scarn:SetGerman("")
-- MOD.Lang.Scarn:SetFrench("")
-- MOD.Lang.Scarn:SetRussian("")
MOD.Scarn.Name = MOD.Lang.Scarn[KBM.Lang]
MOD.Descript = MOD.Scarn.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Scarn.Name] = self.Scarn,
	}
	KBM_Boss[self.Scarn.Name] = self.Scarn	
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Scarn.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Scarn.Settings.TimersRef,
		-- AlertsRef = self.Scarn.Settings.AlertsRef,
	}
	KBMEXDDSN_Settings = self.Settings
	chKBMEXDDSN_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXDDSN_Settings = self.Settings
		self.Settings = chKBMEXDDSN_Settings
	else
		chKBMEXDDSN_Settings = self.Settings
		self.Settings = KBMEXDDSN_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXDDSN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXDDSN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXDDSN_Settings = self.Settings
	else
		KBMEXDDSN_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXDDSN_Settings = self.Settings
	else
		KBMEXDDSN_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Scarn.UnitID == UnitID then
		self.Scarn.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Scarn.UnitID == UnitID then
		self.Scarn.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Scarn.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Scarn.Dead = false
					self.Scarn.Casting = false
					self.Scarn.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Scarn.Name, 0, 100)
					self.Phase = 1
				end
				self.Scarn.UnitID = unitID
				self.Scarn.Available = true
				return self.Scarn
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Scarn.Available = false
	self.Scarn.UnitID = nil
	self.Scarn.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Scarn:SetTimers(bool)	
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

function MOD.Scarn:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Scarn, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Scarn)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Scarn)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Scarn.CastBar = KBM.CastBar:Add(self, self.Scarn)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end