-- Ravalos Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXKBRS_Settings = nil
chKBMEXKBRS_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Kings Breach"]

local MOD = {
	Directory = Instance.Directory,
	File = "Ravalos.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ravalos",
	Object = "MOD",
}

MOD.Ravalos = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Ravalos",
	--NameShort = "Ravalos",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U6A58D2FC2645834E",
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
MOD.Lang.Unit.Ravalos = KBM.Language:Add(MOD.Ravalos.Name)
MOD.Lang.Unit.Ravalos:SetGerman()
MOD.Lang.Unit.Ravalos:SetFrench()
MOD.Lang.Unit.Ravalos:SetRussian("Равалос")
MOD.Lang.Unit.Ravalos:SetKorean("라발로스")
MOD.Ravalos.Name = MOD.Lang.Unit.Ravalos[KBM.Lang]
MOD.Descript = MOD.Ravalos.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ravalos.Name] = self.Ravalos,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ravalos.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Ravalos.Settings.TimersRef,
		-- AlertsRef = self.Ravalos.Settings.AlertsRef,
	}
	KBMEXKBRS_Settings = self.Settings
	chKBMEXKBRS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXKBRS_Settings = self.Settings
		self.Settings = chKBMEXKBRS_Settings
	else
		chKBMEXKBRS_Settings = self.Settings
		self.Settings = KBMEXKBRS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXKBRS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXKBRS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXKBRS_Settings = self.Settings
	else
		KBMEXKBRS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXKBRS_Settings = self.Settings
	else
		KBMEXKBRS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Ravalos.UnitID == UnitID then
		self.Ravalos.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Ravalos.UnitID == UnitID then
		self.Ravalos.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Ravalos.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ravalos.Dead = false
					self.Ravalos.Casting = false
					self.Ravalos.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Ravalos.Name, 0, 100)
					self.Phase = 1
				end
				self.Ravalos.UnitID = unitID
				self.Ravalos.Available = true
				return self.Ravalos
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Ravalos.Available = false
	self.Ravalos.UnitID = nil
	self.Ravalos.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Ravalos:SetTimers(bool)	
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

function MOD.Ravalos:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Ravalos, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Ravalos)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Ravalos)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Ravalos.CastBar = KBM.CastBar:Add(self, self.Ravalos)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end