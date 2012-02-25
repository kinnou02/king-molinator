-- Smouldaron Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXCCSN_Settings = nil
chKBMEXCCSN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Charmer's Caldera"]

local MOD = {
	Directory = Instance.Directory,
	File = "Smouldaron.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Smouldaron",
}

MOD.Smouldaron = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Smouldaron",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U0CF6D91C2CFA0570",
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

MOD.Lang.Smouldaron = KBM.Language:Add(MOD.Smouldaron.Name)
MOD.Lang.Smouldaron:SetGerman("Smouldaron")
-- MOD.Lang.Smouldaron:SetFrench("")
-- MOD.Lang.Smouldaron:SetRussian("")
MOD.Smouldaron.Name = MOD.Lang.Smouldaron[KBM.Lang]
MOD.Descript = MOD.Smouldaron.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Smouldaron.Name] = self.Smouldaron,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Smouldaron.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Smouldaron.Settings.TimersRef,
		-- AlertsRef = self.Smouldaron.Settings.AlertsRef,
	}
	KBMEXCCSN_Settings = self.Settings
	chKBMEXCCSN_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXCCSN_Settings = self.Settings
		self.Settings = chKBMEXCCSN_Settings
	else
		chKBMEXCCSN_Settings = self.Settings
		self.Settings = KBMEXCCSN_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXCCSN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXCCSN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXCCSN_Settings = self.Settings
	else
		KBMEXCCSN_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXCCSN_Settings = self.Settings
	else
		KBMEXCCSN_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Smouldaron.UnitID == UnitID then
		self.Smouldaron.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Smouldaron.UnitID == UnitID then
		self.Smouldaron.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Smouldaron.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Smouldaron.Dead = false
					self.Smouldaron.Casting = false
					self.Smouldaron.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Smouldaron.Name, 0, 100)
					self.Phase = 1
				end
				self.Smouldaron.UnitID = unitID
				self.Smouldaron.Available = true
				return self.Smouldaron
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Smouldaron.Available = false
	self.Smouldaron.UnitID = nil
	self.Smouldaron.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Smouldaron:SetTimers(bool)	
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

function MOD.Smouldaron:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Smouldaron, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Smouldaron)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Smouldaron)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Smouldaron.CastBar = KBM.CastBar:Add(self, self.Smouldaron)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end