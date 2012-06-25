-- Renthar the Bloodwalker Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXAPRR_Settings = nil
chKBMEXAPRR_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Abyssal Precipice"]

local MOD = {
	Directory = Instance.Directory,
	File = "Renthar.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Renthar",
	Object = "MOD",
}

MOD.Renthar = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Renthar",
	NameShort = "Renthar",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U68C6F2E92EB4FEC9",
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
MOD.Lang.Unit.Renthar = KBM.Language:Add(MOD.Renthar.Name)
MOD.Lang.Unit.Renthar:SetGerman()
MOD.Lang.Unit.Renthar:SetFrench()
MOD.Lang.Unit.Renthar:SetRussian("Рентар")
MOD.Lang.Unit.Renthar:SetKorean("렌타르")
MOD.Renthar.Name = MOD.Lang.Unit.Renthar[KBM.Lang]
MOD.Descript = MOD.Renthar.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Renthar.Name] = self.Renthar,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Renthar.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Renthar.Settings.TimersRef,
		-- AlertsRef = self.Renthar.Settings.AlertsRef,
	}
	KBMEXAPKA_Settings = self.Settings
	chKBMEXAPKA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXAPRR_Settings = self.Settings
		self.Settings = chKBMEXAPRR_Settings
	else
		chKBMEXAPRR_Settings = self.Settings
		self.Settings = KBMEXAPRR_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXAPRR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXAPRR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXAPRR_Settings = self.Settings
	else
		KBMEXAPRR_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXAPRR_Settings = self.Settings
	else
		KBMEXAPRR_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Renthar.UnitID == UnitID then
		self.Renthar.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Renthar.UnitID == UnitID then
		self.Renthar.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Renthar.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Renthar.Dead = false
					self.Renthar.Casting = false
					self.Renthar.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Renthar.Name, 0, 100)
					self.Phase = 1
				end
				self.Renthar.UnitID = unitID
				self.Renthar.Available = true
				return self.Renthar
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Renthar.Available = false
	self.Renthar.UnitID = nil
	self.Renthar.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Renthar:SetTimers(bool)	
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

function MOD.Renthar:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Renthar, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Renthar)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Renthar)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Renthar.CastBar = KBM.CastBar:Add(self, self.Renthar)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end