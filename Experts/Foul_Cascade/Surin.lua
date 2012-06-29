-- Countess Surin Skenobar Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFCCS_Settings = nil
chKBMEXFCCS_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Foul Cascade"]

local MOD = {
	Directory = Instance.Directory,
	File = "Surin.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Surin",
	Object = "MOD",
}

MOD.Surin = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Countess Surin Skenobar",
	NameShort = "Surin",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U5FEBA8BF71086D4A",
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

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Surin = KBM.Language:Add(MOD.Surin.Name)
MOD.Lang.Unit.Surin:SetGerman("Gräfin Surin Skenobar")
MOD.Lang.Unit.Surin:SetFrench("Comtesse Surin Skenobar")
MOD.Lang.Unit.Surin:SetRussian("Графиня Сурин Скенобар")
MOD.Lang.Unit.Surin:SetKorean("수린 스케노바")
MOD.Surin.Name = MOD.Lang.Unit.Surin[KBM.Lang]
MOD.Descript = MOD.Surin.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Surin.Name] = self.Surin,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Surin.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Surin.Settings.TimersRef,
		-- AlertsRef = self.Surin.Settings.AlertsRef,
	}
	KBMEXFCCS_Settings = self.Settings
	chKBMEXFCCS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFCCS_Settings = self.Settings
		self.Settings = chKBMEXFCCS_Settings
	else
		chKBMEXFCCS_Settings = self.Settings
		self.Settings = KBMEXFCCS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFCCS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFCCS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFCCS_Settings = self.Settings
	else
		KBMEXFCCS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFCCS_Settings = self.Settings
	else
		KBMEXFCCS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Surin.UnitID == UnitID then
		self.Surin.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Surin.UnitID == UnitID then
		self.Surin.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Surin.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Surin.Dead = false
					self.Surin.Casting = false
					self.Surin.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Surin.Name, 0, 100)
					self.Phase = 1
				end
				self.Surin.UnitID = unitID
				self.Surin.Available = true
				return self.Surin
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Surin.Available = false
	self.Surin.UnitID = nil
	self.Surin.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Surin:SetTimers(bool)	
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

function MOD.Surin:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Surin, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Surin)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Surin)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Surin.CastBar = KBM.CastBar:Add(self, self.Surin)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end