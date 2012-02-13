-- Warden Falidor Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXRDWF_Settings = nil
chKBMEXRDWF_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Runic Descent"]

local MOD = {
	Directory = Instance.Directory,
	File = "Falidor.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Falidor",
}

MOD.Falidor = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Warden Falidor",
	NameShort = "Falidor",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = nil,
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

MOD.Lang.Falidor = KBM.Language:Add(MOD.Falidor.Name)
-- MOD.Lang.Falidor:SetGerman("")
-- MOD.Lang.Falidor:SetFrench("")
-- MOD.Lang.Falidor:SetRussian("")
MOD.Falidor.Name = MOD.Lang.Falidor[KBM.Lang]
MOD.Descript = MOD.Falidor.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Falidor.Name] = self.Falidor,
	}
	KBM_Boss[self.Falidor.Name] = self.Falidor	
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Falidor.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Falidor.Settings.TimersRef,
		-- AlertsRef = self.Falidor.Settings.AlertsRef,
	}
	KBMEXRDWF_Settings = self.Settings
	chKBMEXRDWF_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXRDWF_Settings = self.Settings
		self.Settings = chKBMEXRDWF_Settings
	else
		chKBMEXRDWF_Settings = self.Settings
		self.Settings = KBMEXRDWF_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXRDWF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXRDWF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXRDWF_Settings = self.Settings
	else
		KBMEXRDWF_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXRDWF_Settings = self.Settings
	else
		KBMEXRDWF_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Falidor.UnitID == UnitID then
		self.Falidor.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Falidor.UnitID == UnitID then
		self.Falidor.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Falidor.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Falidor.Dead = false
					self.Falidor.Casting = false
					self.Falidor.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Falidor.Name, 0, 100)
					self.Phase = 1
				end
				self.Falidor.UnitID = unitID
				self.Falidor.Available = true
				return self.Falidor
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Falidor.Available = false
	self.Falidor.UnitID = nil
	self.Falidor.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Falidor:SetTimers(bool)	
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

function MOD.Falidor:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Falidor, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Falidor)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Falidor)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Falidor.CastBar = KBM.CastBar:Add(self, self.Falidor)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end