-- Jultharin Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXCCJN_Settings = nil
chKBMEXCCJN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Charmer's Caldera"]

local MOD = {
	Directory = Instance.Directory,
	File = "Jultharin.lua",
	Enabled = true,
	Instance = Instance.Name,
	HasPhases = true,
	Lang = {},
	ID = "Jultharin",
}

MOD.Jultharin = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Jultharin",
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

MOD.Lang.Jultharin = KBM.Language:Add(MOD.Jultharin.Name)
MOD.Lang.Jultharin:SetGerman("Jultharin") 
-- MOD.Lang.Jultharin:SetFrench("")
-- MOD.Lang.Jultharin:SetRussian("")
MOD.Jultharin.Name = MOD.Lang.Jultharin[KBM.Lang]
MOD.Descript = MOD.Jultharin.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Jultharin.Name] = self.Jultharin,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Jultharin.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Jultharin.Settings.TimersRef,
		-- AlertsRef = self.Jultharin.Settings.AlertsRef,
	}
	KBMEXCCJN_Settings = self.Settings
	chKBMEXCCJN_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXCCJN_Settings = self.Settings
		self.Settings = chKBMEXCCJN_Settings
	else
		chKBMEXCCJN_Settings = self.Settings
		self.Settings = KBMEXCCJN_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXCCJN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXCCJN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXCCJN_Settings = self.Settings
	else
		KBMEXCCJN_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXCCJN_Settings = self.Settings
	else
		KBMEXCCJN_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Jultharin.UnitID == UnitID then
		self.Jultharin.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Jultharin.UnitID == UnitID then
		self.Jultharin.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Jultharin.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Jultharin.Dead = false
					self.Jultharin.Casting = false
					self.Jultharin.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Jultharin.Name, 0, 100)
					self.Phase = 1
				end
				self.Jultharin.UnitID = unitID
				self.Jultharin.Available = true
				return self.Jultharin
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Jultharin.Available = false
	self.Jultharin.UnitID = nil
	self.Jultharin.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Jultharin:SetTimers(bool)	
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

function MOD.Jultharin:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Jultharin, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Jultharin)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Jultharin)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Jultharin.CastBar = KBM.CastBar:Add(self, self.Jultharin)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end