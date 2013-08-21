-- Dichrom Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDMDM_Settings = nil
chKBMEXDMDM_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Deepstrike Mines"]

local MOD = {
	Directory = Instance.Directory,
	File = "Dichrom.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Dichrom",
	Object = "MOD",
}

MOD.Dichrom = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Dichrom",
	NameShort = "Dichrom",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U641AE08F44B7FFE3",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
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
MOD.Lang.Unit.Dichrom = KBM.Language:Add(MOD.Dichrom.Name)
MOD.Lang.Unit.Dichrom:SetGerman("Dichrom")
MOD.Lang.Unit.Dichrom:SetFrench("Dichrom")
MOD.Lang.Unit.Dichrom:SetRussian("Дихром")
MOD.Lang.Unit.Dichrom:SetKorean("다이크롬")
MOD.Dichrom.Name = MOD.Lang.Unit.Dichrom[KBM.Lang]
MOD.Descript = MOD.Dichrom.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Dichrom.Name] = self.Dichrom,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Dichrom.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Dichrom.Settings.TimersRef,
		-- AlertsRef = self.Dichrom.Settings.AlertsRef,
	}
	KBMEXDMDM_Settings = self.Settings
	chKBMEXDMDM_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXDMDM_Settings = self.Settings
		self.Settings = chKBMEXDMDM_Settings
	else
		chKBMEXDMDM_Settings = self.Settings
		self.Settings = KBMEXDMDM_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXDMDM_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXDMDM_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXDMDM_Settings = self.Settings
	else
		KBMEXDMDM_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXDMDM_Settings = self.Settings
	else
		KBMEXDMDM_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Dichrom.UnitID == UnitID then
		self.Dichrom.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Dichrom.UnitID == UnitID then
		self.Dichrom.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Dichrom.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Dichrom.Dead = false
					self.Dichrom.Casting = false
					self.Dichrom.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Dichrom.Name, 0, 100)
					self.Phase = 1
				end
				self.Dichrom.UnitID = unitID
				self.Dichrom.Available = true
				return self.Dichrom
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Dichrom.Available = false
	self.Dichrom.UnitID = nil
	self.Dichrom.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Dichrom:SetTimers(bool)	
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

function MOD.Dichrom:SetAlerts(bool)
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




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Dichrom)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Dichrom)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Dichrom.CastBar = KBM.Castbar:Add(self, self.Dichrom)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end