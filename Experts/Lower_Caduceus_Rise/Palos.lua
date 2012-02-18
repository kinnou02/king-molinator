-- Hookmaster Palos Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXLCRHP_Settings = nil
chKBMEXLCRHP_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Lower_Caduceus_Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Palos.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Palos",
}

MOD.Palos = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Hookmaster Palos",
	NameShort = "Palos",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U63F0D8CA408E75A9",
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

MOD.Lang.Palos = KBM.Language:Add(MOD.Palos.Name)
MOD.Lang.Palos:SetGerman("Hakenmeister Palos") 
-- MOD.Lang.Palos:SetFrench("")
-- MOD.Lang.Palos:SetRussian("")
MOD.Palos.Name = MOD.Lang.Palos[KBM.Lang]
MOD.Descript = MOD.Palos.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Palos.Name] = self.Palos,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Palos.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Palos.Settings.TimersRef,
		-- AlertsRef = self.Palos.Settings.AlertsRef,
	}
	KBMEXLCRHP_Settings = self.Settings
	chKBMEXLCRHP_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXLCRHP_Settings = self.Settings
		self.Settings = chKBMEXLCRHP_Settings
	else
		chKBMEXLCRHP_Settings = self.Settings
		self.Settings = KBMEXLCRHP_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXLCRHP_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXLCRHP_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXLCRHP_Settings = self.Settings
	else
		KBMEXLCRHP_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXLCRHP_Settings = self.Settings
	else
		KBMEXLCRHP_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Palos.UnitID == UnitID then
		self.Palos.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Palos.UnitID == UnitID then
		self.Palos.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Palos.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Palos.Dead = false
					self.Palos.Casting = false
					self.Palos.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Palos.Name, 0, 100)
					self.Phase = 1
				end
				self.Palos.UnitID = unitID
				self.Palos.Available = true
				return self.Palos
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Palos.Available = false
	self.Palos.UnitID = nil
	self.Palos.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Palos:SetTimers(bool)	
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

function MOD.Palos:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Palos, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Palos)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Palos)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Palos.CastBar = KBM.CastBar:Add(self, self.Palos)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end