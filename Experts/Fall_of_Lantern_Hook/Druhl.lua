-- Flamebringer Druhl Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFOLHFB_Settings = nil
chKBMEXFOLHFB_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Fall of Lantern Hook"]

local MOD = {
	Directory = Instance.Directory,
	File = "Druhl.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Druhl",
	Object = "MOD",
}

MOD.Druhl = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Flamebringer Druhl",
	NameShort = "Druhl",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U74BD8CD2731575AF",
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
MOD.Lang.Unit.Druhl = KBM.Language:Add(MOD.Druhl.Name)
MOD.Lang.Unit.Druhl:SetGerman("Flammenbringer Druhl") 
MOD.Lang.Unit.Druhl:SetFrench("Druhl le Porte-flammes")
-- MOD.Lang.Unit.Druhl:SetRussian("")
MOD.Druhl.Name = MOD.Lang.Unit.Druhl[KBM.Lang]
MOD.Descript = MOD.Druhl.Name
MOD.Lang.Unit.DruShort = KBM.Language:Add("Druhl")
MOD.Lang.Unit.DruShort:SetGerman()
MOD.Lang.Unit.DruShort:SetFrench()
MOD.Druhl.NameShort = MOD.Lang.Unit.DruShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Druhl.Name] = self.Druhl,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Druhl.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Druhl.Settings.TimersRef,
		-- AlertsRef = self.Druhl.Settings.AlertsRef,
	}
	KBMEXFOLHFB_Settings = self.Settings
	chKBMEXFOLHFB_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFOLHFB_Settings = self.Settings
		self.Settings = chKBMEXFOLHFB_Settings
	else
		chKBMEXFOLHFB_Settings = self.Settings
		self.Settings = KBMEXFOLHFB_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFOLHFB_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFOLHFB_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFOLHFB_Settings = self.Settings
	else
		KBMEXFOLHFB_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFOLHFB_Settings = self.Settings
	else
		KBMEXFOLHFB_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Druhl.UnitID == UnitID then
		self.Druhl.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Druhl.UnitID == UnitID then
		self.Druhl.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Druhl.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Druhl.Dead = false
					self.Druhl.Casting = false
					self.Druhl.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Druhl.Name, 0, 100)
					self.Phase = 1
				end
				self.Druhl.UnitID = unitID
				self.Druhl.Available = true
				return self.Druhl
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Druhl.Available = false
	self.Druhl.UnitID = nil
	self.Druhl.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Druhl:SetTimers(bool)	
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

function MOD.Druhl:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Druhl, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Druhl)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Druhl)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Druhl.CastBar = KBM.CastBar:Add(self, self.Druhl)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end