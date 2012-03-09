-- Coalgut Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMMCRCT_Settings = nil
chKBMMMCRCT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Caduceus Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Coalgut.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "MM_Coalgut",
	Object = "MOD",
}

MOD.Coalgut = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Coalgut",
	--NameShort = "Coalgut",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	MasterID = "U012FD547618E995E",
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
MOD.Lang.Unit.Coalgut = KBM.Language:Add(MOD.Coalgut.Name)
MOD.Lang.Unit.Coalgut:SetGerman("Kohlbauch")
MOD.Lang.Unit.Coalgut:SetFrench("Orage de Cendres") 
-- MOD.Lang.Unit.Coalgut:SetRussian("")
MOD.Coalgut.Name = MOD.Lang.Unit.Coalgut[KBM.Lang]
MOD.Descript = MOD.Coalgut.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Coalgut.Name] = self.Coalgut,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Coalgut.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Coalgut.Settings.TimersRef,
		-- AlertsRef = self.Coalgut.Settings.AlertsRef,
	}
	KBMMMCRCT_Settings = self.Settings
	chKBMMMCRCT_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMMMCRCT_Settings = self.Settings
		self.Settings = chKBMMMCRCT_Settings
	else
		chKBMMMCRCT_Settings = self.Settings
		self.Settings = KBMMMCRCT_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMMCRCT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMMCRCT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMMMCRCT_Settings = self.Settings
	else
		KBMMMCRCT_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMMMCRCT_Settings = self.Settings
	else
		KBMMMCRCT_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Coalgut.UnitID == UnitID then
		self.Coalgut.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Coalgut.UnitID == UnitID then
		self.Coalgut.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Coalgut.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Coalgut.Dead = false
					self.Coalgut.Casting = false
					self.Coalgut.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Coalgut.Name, 0, 100)
					self.Phase = 1
				end
				self.Coalgut.UnitID = unitID
				self.Coalgut.Available = true
				return self.Coalgut
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Coalgut.Available = false
	self.Coalgut.UnitID = nil
	self.Coalgut.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Coalgut:SetTimers(bool)	
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

function MOD.Coalgut:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Coalgut, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Coalgut)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Coalgut)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Coalgut.CastBar = KBM.CastBar:Add(self, self.Coalgut)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end