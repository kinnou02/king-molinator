-- Caelia the Stormtouched Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXCCCS_Settings = nil
chKBMEXCCCS_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Charmer's Caldera"]

local MOD = {
	Directory = Instance.Directory,
	File = "Caelia.lua",
	Enabled = true,
	Instance = Instance.Name,
	HasPhases = true,
	Lang = {},
	ID = "Caelia",
}

MOD.Caelia = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Caelia the Stormtouched",
	NameShort = "Caelia",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "Expert",
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

MOD.Lang.Caelia = KBM.Language:Add(MOD.Caelia.Name)
MOD.Lang.Caelia:SetGerman("Caelia die Sturmberührte") 
-- MOD.Lang.Caelia:SetFrench("")
-- MOD.Lang.Caelia:SetRussian("")
MOD.Caelia.Name = MOD.Lang.Caelia[KBM.Lang]
MOD.Descript = MOD.Caelia.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Caelia.Name] = self.Caelia,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Caelia.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Caelia.Settings.TimersRef,
		-- AlertsRef = self.Caelia.Settings.AlertsRef,
	}
	KBMEXCCCS_Settings = self.Settings
	chKBMEXCCCS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXCCCS_Settings = self.Settings
		self.Settings = chKBMEXCCCS_Settings
	else
		chKBMEXCCCS_Settings = self.Settings
		self.Settings = KBMEXCCCS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXCCCS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXCCCS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXCCCS_Settings = self.Settings
	else
		KBMEXCCCS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXCCCS_Settings = self.Settings
	else
		KBMEXCCCS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Caelia.UnitID == UnitID then
		self.Caelia.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Caelia.UnitID == UnitID then
		self.Caelia.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Caelia.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Caelia.Dead = false
					self.Caelia.Casting = false
					self.Caelia.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Caelia.Name, 0, 100)
					self.Phase = 1
				end
				self.Caelia.UnitID = unitID
				self.Caelia.Available = true
				return self.Caelia
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Caelia.Available = false
	self.Caelia.UnitID = nil
	self.Caelia.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Caelia:SetTimers(bool)	
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

function MOD.Caelia:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Caelia, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Caelia)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Caelia)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Caelia.CastBar = KBM.CastBar:Add(self, self.Caelia)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end