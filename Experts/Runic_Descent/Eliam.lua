-- Eliam the Corrupted Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXRDEC_Settings = nil
chKBMEXRDEC_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Runic Descent"]

local MOD = {
	Directory = Instance.Directory,
	File = "Eliam.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Eliam",
	Object = "MOD",
}

MOD.Eliam = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Eliam the Corrupted",
	NameShort = "Eliam",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U115ACF3868DD6535",
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
MOD.Lang.Unit.Eliam = KBM.Language:Add(MOD.Eliam.Name)
MOD.Lang.Unit.Eliam:SetGerman("Eliam der Verderbte") 
-- MOD.Lang.Unit.Eliam:SetFrench("")
-- MOD.Lang.Unit.Eliam:SetRussian("")
MOD.Eliam.Name = MOD.Lang.Unit.Eliam[KBM.Lang]
MOD.Descript = MOD.Eliam.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Eliam.Name] = self.Eliam,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Eliam.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Eliam.Settings.TimersRef,
		-- AlertsRef = self.Eliam.Settings.AlertsRef,
	}
	KBMEXRDEC_Settings = self.Settings
	chKBMEXRDEC_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXRDEC_Settings = self.Settings
		self.Settings = chKBMEXRDEC_Settings
	else
		chKBMEXRDEC_Settings = self.Settings
		self.Settings = KBMEXRDEC_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXRDEC_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXRDEC_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXRDEC_Settings = self.Settings
	else
		KBMEXRDEC_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXRDEC_Settings = self.Settings
	else
		KBMEXRDEC_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Eliam.UnitID == UnitID then
		self.Eliam.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Eliam.UnitID == UnitID then
		self.Eliam.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Eliam.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Eliam.Dead = false
					self.Eliam.Casting = false
					self.Eliam.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Eliam.Name, 0, 100)
					self.Phase = 1
				end
				self.Eliam.UnitID = unitID
				self.Eliam.Available = true
				return self.Eliam
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Eliam.Available = false
	self.Eliam.UnitID = nil
	self.Eliam.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Eliam:SetTimers(bool)	
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

function MOD.Eliam:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Eliam, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Eliam)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Eliam)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Eliam.CastBar = KBM.CastBar:Add(self, self.Eliam)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end