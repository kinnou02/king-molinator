-- High Thane Hergen Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXLCRHH_Settings = nil
chKBMEXLCRHH_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Lower_Caduceus_Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Hergen.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Hergen",
}

MOD.Hergen = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "High Thane Hergen",
	NameShort = "Hergen",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U468DE636207C8B0C",
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

MOD.Lang.Hergen = KBM.Language:Add(MOD.Hergen.Name)
-- MOD.Lang.Hergen:SetGerman("")
-- MOD.Lang.Hergen:SetFrench("")
-- MOD.Lang.Hergen:SetRussian("")
MOD.Hergen.Name = MOD.Lang.Hergen[KBM.Lang]
MOD.Descript = MOD.Hergen.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Hergen.Name] = self.Hergen,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Hergen.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Hergen.Settings.TimersRef,
		-- AlertsRef = self.Hergen.Settings.AlertsRef,
	}
	KBMEXLCRHH_Settings = self.Settings
	chKBMEXLCRHH_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXLCRHH_Settings = self.Settings
		self.Settings = chKBMEXLCRHH_Settings
	else
		chKBMEXLCRHH_Settings = self.Settings
		self.Settings = KBMEXLCRHH_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXLCRHH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXLCRHH_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXLCRHH_Settings = self.Settings
	else
		KBMEXLCRHH_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXLCRHH_Settings = self.Settings
	else
		KBMEXLCRHH_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Hergen.UnitID == UnitID then
		self.Hergen.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Hergen.UnitID == UnitID then
		self.Hergen.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Hergen.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Hergen.Dead = false
					self.Hergen.Casting = false
					self.Hergen.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Hergen.Name, 0, 100)
					self.Phase = 1
				end
				self.Hergen.UnitID = unitID
				self.Hergen.Available = true
				return self.Hergen
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Hergen.Available = false
	self.Hergen.UnitID = nil
	self.Hergen.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Hergen:SetTimers(bool)	
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

function MOD.Hergen:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Hergen, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Hergen)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Hergen)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Hergen.CastBar = KBM.CastBar:Add(self, self.Hergen)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end