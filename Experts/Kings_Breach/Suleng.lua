-- Hunter Suleng Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXKBHS_Settings = nil
chKBMEXKBHS_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Kings Breach"]

local MOD = {
	Directory = Instance.Directory,
	File = "Suleng.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Suleng",
}

MOD.Suleng = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Hunter Suleng",
	NameShort = "Suleng",
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

MOD.Lang.Suleng = KBM.Language:Add(MOD.Suleng.Name)
-- MOD.Lang.Suleng:SetGerman("")
-- MOD.Lang.Suleng:SetFrench("")
-- MOD.Lang.Suleng:SetRussian("")
MOD.Suleng.Name = MOD.Lang.Suleng[KBM.Lang]
MOD.Descript = MOD.Suleng.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Suleng.Name] = self.Suleng,
	}
	KBM_Boss[self.Suleng.Name] = self.Suleng	
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Suleng.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Suleng.Settings.TimersRef,
		-- AlertsRef = self.Suleng.Settings.AlertsRef,
	}
	KBMEXKBHS_Settings = self.Settings
	chKBMEXKBHS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXKBHS_Settings = self.Settings
		self.Settings = chKBMEXKBHS_Settings
	else
		chKBMEXKBHS_Settings = self.Settings
		self.Settings = KBMEXKBHS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXKBHS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXKBHS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXKBHS_Settings = self.Settings
	else
		KBMEXKBHS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXKBHS_Settings = self.Settings
	else
		KBMEXKBHS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Suleng.UnitID == UnitID then
		self.Suleng.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Suleng.UnitID == UnitID then
		self.Suleng.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Suleng.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Suleng.Dead = false
					self.Suleng.Casting = false
					self.Suleng.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Suleng.Name, 0, 100)
					self.Phase = 1
				end
				self.Suleng.UnitID = unitID
				self.Suleng.Available = true
				return self.Suleng
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Suleng.Available = false
	self.Suleng.UnitID = nil
	self.Suleng.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Suleng:SetTimers(bool)	
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

function MOD.Suleng:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Suleng, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Suleng)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Suleng)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Suleng.CastBar = KBM.CastBar:Add(self, self.Suleng)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end