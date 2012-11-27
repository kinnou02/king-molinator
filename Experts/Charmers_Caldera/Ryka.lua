-- Ryka Dharvos Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXCCRD_Settings = nil
chKBMEXCCRD_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Charmer's Caldera"]

local MOD = {
	Directory = Instance.Directory,
	File = "Ryka.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ryka",
	Object = "MOD",
}

MOD.Ryka = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Ryka Dharvos",
	NameShort = "Ryka",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U33BFA2635B9791ED",
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
MOD.Lang.Unit.Ryka = KBM.Language:Add(MOD.Ryka.Name)
MOD.Lang.Unit.Ryka:SetGerman()
MOD.Lang.Unit.Ryka:SetFrench()
MOD.Lang.Unit.Ryka:SetRussian("Рика Дарвос")
MOD.Lang.Unit.Ryka:SetKorean("리카 다브로스")
MOD.Ryka.Name = MOD.Lang.Unit.Ryka[KBM.Lang]
MOD.Descript = MOD.Ryka.Name
MOD.Lang.Unit.RykaShort = KBM.Language:Add("Ryka")
MOD.Lang.Unit.RykaShort:SetGerman()
MOD.Lang.Unit.RykaShort:SetFrench()
MOD.Lang.Unit.RykaShort:SetRussian("Рика")
MOD.Lang.Unit.RykaShort:SetKorean("리카")
MOD.Ryka.NameShort = MOD.Lang.Unit.RykaShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ryka.Name] = self.Ryka,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ryka.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Ryka.Settings.TimersRef,
		-- AlertsRef = self.Ryka.Settings.AlertsRef,
	}
	KBMEXCCRD_Settings = self.Settings
	chKBMEXCCRD_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXCCRD_Settings = self.Settings
		self.Settings = chKBMEXCCRD_Settings
	else
		chKBMEXCCRD_Settings = self.Settings
		self.Settings = KBMEXCCRD_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXCCRD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXCCRD_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXCCRD_Settings = self.Settings
	else
		KBMEXCCRD_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXCCRD_Settings = self.Settings
	else
		KBMEXCCRD_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Ryka.UnitID == UnitID then
		self.Ryka.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Ryka.UnitID == UnitID then
		self.Ryka.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Ryka.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ryka.Dead = false
					self.Ryka.Casting = false
					self.Ryka.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Ryka.Name, 0, 100)
					self.Phase = 1
				end
				self.Ryka.UnitID = unitID
				self.Ryka.Available = true
				return self.Ryka
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Ryka.Available = false
	self.Ryka.UnitID = nil
	self.Ryka.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Ryka:SetTimers(bool)	
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

function MOD.Ryka:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Ryka, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Ryka)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Ryka)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Ryka.CastBar = KBM.CastBar:Add(self, self.Ryka)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end