-- Kaler Andrenos Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXAPKA_Settings = nil
chKBMEXAPKA_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Abyssal Precipice"]

local MOD = {
	Directory = Instance.Directory,
	File = "Andrenos.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Andrenos",
}

MOD.Andrenos = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Kaler Andrenos",
	NameShort = "Andrenos",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	ExpertID = "Expert",
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

MOD.Lang.Andrenos = KBM.Language:Add(MOD.Andrenos.Name)
MOD.Lang.Andrenos:SetGerman("Kaler Andrenos")
-- MOD.Lang.Andrenos:SetFrench("")
-- MOD.Lang.Andrenos:SetRussian("")
MOD.Andrenos.Name = MOD.Lang.Andrenos[KBM.Lang]
MOD.Descript = MOD.Andrenos.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Andrenos.Name] = self.Andrenos,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Andrenos.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Andrenos.Settings.TimersRef,
		-- AlertsRef = self.Andrenos.Settings.AlertsRef,
	}
	KBMEXAPKA_Settings = self.Settings
	chKBMEXAPKA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXAPKA_Settings = self.Settings
		self.Settings = chKBMEXAPKA_Settings
	else
		chKBMEXAPKA_Settings = self.Settings
		self.Settings = KBMEXAPKA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXAPKA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXAPKA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXAPKA_Settings = self.Settings
	else
		KBMEXAPKA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXAPKA_Settings = self.Settings
	else
		KBMEXAPKA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Andrenos.UnitID == UnitID then
		self.Andrenos.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Andrenos.UnitID == UnitID then
		self.Andrenos.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Andrenos.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Andrenos.Dead = false
					self.Andrenos.Casting = false
					self.Andrenos.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Andrenos.Name, 0, 100)
					self.Phase = 1
				end
				self.Andrenos.UnitID = unitID
				self.Andrenos.Available = true
				return self.Andrenos
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Andrenos.Available = false
	self.Andrenos.UnitID = nil
	self.Andrenos.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Andrenos:SetTimers(bool)	
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

function MOD.Andrenos:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Andrenos, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Andrenos)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Andrenos)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Andrenos.CastBar = KBM.CastBar:Add(self, self.Andrenos)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end