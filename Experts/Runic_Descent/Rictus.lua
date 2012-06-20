-- Rictus Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXRDRS_Settings = nil
chKBMEXRDRS_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Runic Descent"]

local MOD = {
	Directory = Instance.Directory,
	File = "Rictus.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Rictus",
	Object = "MOD",
}

MOD.Rictus = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Rictus",
	--NameShort = "Rictus",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U06CF214A071F281B",
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
MOD.Lang.Unit.Rictus = KBM.Language:Add(MOD.Rictus.Name)
MOD.Lang.Unit.Rictus:SetGerman("Rictus") 
MOD.Lang.Unit.Rictus:SetFrench("Rictus")
MOD.Lang.Unit.Rictus:SetRussian("Риктус")
MOD.Lang.Unit.Rictus:SetKorean("릭터스")
MOD.Rictus.Name = MOD.Lang.Unit.Rictus[KBM.Lang]
MOD.Descript = MOD.Rictus.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Rictus.Name] = self.Rictus,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Rictus.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Rictus.Settings.TimersRef,
		-- AlertsRef = self.Rictus.Settings.AlertsRef,
	}
	KBMEXRDRS_Settings = self.Settings
	chKBMEXRDRS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXRDRS_Settings = self.Settings
		self.Settings = chKBMEXRDRS_Settings
	else
		chKBMEXRDRS_Settings = self.Settings
		self.Settings = KBMEXRDRS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXRDRS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXRDRS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXRDRS_Settings = self.Settings
	else
		KBMEXRDRS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXRDRS_Settings = self.Settings
	else
		KBMEXRDRS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Rictus.UnitID == UnitID then
		self.Rictus.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Rictus.UnitID == UnitID then
		self.Rictus.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Rictus.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Rictus.Dead = false
					self.Rictus.Casting = false
					self.Rictus.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Rictus.Name, 0, 100)
					self.Phase = 1
				end
				self.Rictus.UnitID = unitID
				self.Rictus.Available = true
				return self.Rictus
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Rictus.Available = false
	self.Rictus.UnitID = nil
	self.Rictus.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Rictus:SetTimers(bool)	
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

function MOD.Rictus:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Rictus, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Rictus)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Rictus)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Rictus.CastBar = KBM.CastBar:Add(self, self.Rictus)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end