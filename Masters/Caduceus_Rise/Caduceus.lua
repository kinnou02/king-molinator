-- Caduceus Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMMCRCS_Settings = nil
chKBMMMCRCS_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Caduceus Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Caduceus.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "MM_Caduceus",
}

MOD.Caduceus = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Caduceus",
	--NameShort = "Caduceus",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	MasterID = "Master",
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

MOD.Lang.Caduceus = KBM.Language:Add(MOD.Caduceus.Name)
MOD.Lang.Caduceus:SetGerman("Hermesstab")
-- MOD.Lang.Caduceus:SetFrench("")
-- MOD.Lang.Caduceus:SetRussian("")
MOD.Caduceus.Name = MOD.Lang.Caduceus[KBM.Lang]
MOD.Descript = MOD.Caduceus.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Caduceus.Name] = self.Caduceus,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Caduceus.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Caduceus.Settings.TimersRef,
		-- AlertsRef = self.Caduceus.Settings.AlertsRef,
	}
	KBMMMCRCS_Settings = self.Settings
	chKBMMMCRCS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMMMCRCS_Settings = self.Settings
		self.Settings = chKBMMMCRCS_Settings
	else
		chKBMMMCRCS_Settings = self.Settings
		self.Settings = KBMMMCRCS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMMCRCS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMMCRCS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMMMCRCS_Settings = self.Settings
	else
		KBMMMCRCS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMMMCRCS_Settings = self.Settings
	else
		KBMMMCRCS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Caduceus.UnitID == UnitID then
		self.Caduceus.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Caduceus.UnitID == UnitID then
		self.Caduceus.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Caduceus.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Caduceus.Dead = false
					self.Caduceus.Casting = false
					self.Caduceus.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Caduceus.Name, 0, 100)
					self.Phase = 1
				end
				self.Caduceus.UnitID = unitID
				self.Caduceus.Available = true
				return self.Caduceus
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Caduceus.Available = false
	self.Caduceus.UnitID = nil
	self.Caduceus.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Caduceus:SetTimers(bool)	
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

function MOD.Caduceus:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Caduceus, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Caduceus)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Caduceus)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Caduceus.CastBar = KBM.CastBar:Add(self, self.Caduceus)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end