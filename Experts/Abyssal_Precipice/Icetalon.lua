-- Icetalon Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXAPIN_Settings = nil
chKBMEXAPIN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Abyssal Precipice"]

local MOD = {
	Directory = Instance.Directory,
	File = "Icetalon.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Icetalon",
	Object = "MOD",
}

MOD.Icetalon = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Icetalon",
	NameShort = "Icetalon",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U78D537EE0C6B3A73",
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
MOD.Lang.Unit.Icetalon = KBM.Language:Add(MOD.Icetalon.Name)
MOD.Lang.Unit.Icetalon:SetGerman("Eiskralle") 
MOD.Lang.Unit.Icetalon:SetFrench("Serre de glace")
-- MOD.Lang.Unit.Icetalon:SetRussian("")
MOD.Icetalon.Name = MOD.Lang.Unit.Icetalon[KBM.Lang]
MOD.Descript = MOD.Icetalon.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Icetalon.Name] = self.Icetalon,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Icetalon.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Icetalon.Settings.TimersRef,
		-- AlertsRef = self.Icetalon.Settings.AlertsRef,
	}
	KBMEXAPKA_Settings = self.Settings
	chKBMEXAPKA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXAPIN_Settings = self.Settings
		self.Settings = chKBMEXAPIN_Settings
	else
		chKBMEXAPIN_Settings = self.Settings
		self.Settings = KBMEXAPIN_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXAPIN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXAPIN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXAPIN_Settings = self.Settings
	else
		KBMEXAPIN_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXAPIN_Settings = self.Settings
	else
		KBMEXAPIN_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Icetalon.UnitID == UnitID then
		self.Icetalon.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Icetalon.UnitID == UnitID then
		self.Icetalon.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Icetalon.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Icetalon.Dead = false
					self.Icetalon.Casting = false
					self.Icetalon.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Icetalon.Name, 0, 100)
					self.Phase = 1
				end
				self.Icetalon.UnitID = unitID
				self.Icetalon.Available = true
				return self.Icetalon
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Icetalon.Available = false
	self.Icetalon.UnitID = nil
	self.Icetalon.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Icetalon:SetTimers(bool)	
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

function MOD.Icetalon:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Icetalon, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Icetalon)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Icetalon)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Icetalon.CastBar = KBM.CastBar:Add(self, self.Icetalon)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end