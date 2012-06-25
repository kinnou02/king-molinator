-- Konstantin Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXKBKN_Settings = nil
chKBMEXKBKN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Kings Breach"]

local MOD = {
	Directory = Instance.Directory,
	File = "Konstantin.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Konstantin",
	Object = "MOD",
}

MOD.Konstantin = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Konstantin",
	--NameShort = "Konstantin",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U5454BF1F1A43E2CD",
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
MOD.Lang.Unit.Konstantin = KBM.Language:Add(MOD.Konstantin.Name)
MOD.Lang.Unit.Konstantin:SetGerman()
MOD.Lang.Unit.Konstantin:SetFrench()
MOD.Lang.Unit.Konstantin:SetRussian("Константин")
MOD.Lang.Unit.Konstantin:SetKorean("콘스탄틴")
MOD.Konstantin.Name = MOD.Lang.Unit.Konstantin[KBM.Lang]
MOD.Descript = MOD.Konstantin.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Konstantin.Name] = self.Konstantin,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Konstantin.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Konstantin.Settings.TimersRef,
		-- AlertsRef = self.Konstantin.Settings.AlertsRef,
	}
	KBMEXKBKN_Settings = self.Settings
	chKBMEXKBKN_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXKBKN_Settings = self.Settings
		self.Settings = chKBMEXKBKN_Settings
	else
		chKBMEXKBKN_Settings = self.Settings
		self.Settings = KBMEXKBKN_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXKBKN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXKBKN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXKBKN_Settings = self.Settings
	else
		KBMEXKBKN_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXKBKN_Settings = self.Settings
	else
		KBMEXKBKN_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Konstantin.UnitID == UnitID then
		self.Konstantin.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Konstantin.UnitID == UnitID then
		self.Konstantin.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Konstantin.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Konstantin.Dead = false
					self.Konstantin.Casting = false
					self.Konstantin.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Konstantin.Name, 0, 100)
					self.Phase = 1
				end
				self.Konstantin.UnitID = unitID
				self.Konstantin.Available = true
				return self.Konstantin
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Konstantin.Available = false
	self.Konstantin.UnitID = nil
	self.Konstantin.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Konstantin:SetTimers(bool)	
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

function MOD.Konstantin:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Konstantin, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Konstantin)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Konstantin)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Konstantin.CastBar = KBM.CastBar:Add(self, self.Konstantin)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end