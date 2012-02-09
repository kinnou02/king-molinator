-- Caretaker Arcanis Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDMCA_Settings = nil
chKBMEXDMCA_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Deepstrike Mines"]

local MOD = {
	Directory = Instance.Directory,
	File = "Arcanis.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Arcanis",
}

MOD.Arcanis = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Caretaker Arcanis",
	NameShort = "Arcanis",
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

MOD.Lang.Arcanis = KBM.Language:Add(MOD.Arcanis.Name)
-- MOD.Lang.Arcanis:SetGerman("")
-- MOD.Lang.Arcanis:SetFrench("")
-- MOD.Lang.Arcanis:SetRussian("")
MOD.Arcanis.Name = MOD.Lang.Arcanis[KBM.Lang]
MOD.Descript = MOD.Arcanis.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Arcanis.Name] = self.Arcanis,
	}
	KBM_Boss[self.Arcanis.Name] = self.Arcanis	
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Arcanis.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Arcanis.Settings.TimersRef,
		-- AlertsRef = self.Arcanis.Settings.AlertsRef,
	}
	KBMEXDMCA_Settings = self.Settings
	chKBMEXDMCA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXDMCA_Settings = self.Settings
		self.Settings = chKBMEXDMCA_Settings
	else
		chKBMEXDMCA_Settings = self.Settings
		self.Settings = KBMEXDMCA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXDMCA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXDMCA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXDMCA_Settings = self.Settings
	else
		KBMEXDMCA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXDMCA_Settings = self.Settings
	else
		KBMEXDMCA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Arcanis.UnitID == UnitID then
		self.Arcanis.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Arcanis.UnitID == UnitID then
		self.Arcanis.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Arcanis.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Arcanis.Dead = false
					self.Arcanis.Casting = false
					self.Arcanis.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Arcanis.Name, 0, 100)
					self.Phase = 1
				end
				self.Arcanis.UnitID = unitID
				self.Arcanis.Available = true
				return self.Arcanis
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Arcanis.Available = false
	self.Arcanis.UnitID = nil
	self.Arcanis.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Arcanis:SetTimers(bool)	
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

function MOD.Arcanis:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Arcanis, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Arcanis)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Arcanis)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Arcanis.CastBar = KBM.CastBar:Add(self, self.Arcanis)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end