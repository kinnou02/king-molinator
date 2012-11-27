-- Atrophinius the Fallen Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXRDAF_Settings = nil
chKBMEXRDAF_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Runic Descent"]

local MOD = {
	Directory = Instance.Directory,
	File = "Atrophinius.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Atrophinius",
	Object = "MOD",
}

MOD.Atrophinius = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Atrophinius the Fallen",
	NameShort = "Atrophinius",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U40F731D921A7F4EF",
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
MOD.Lang.Unit.Atrophinius = KBM.Language:Add(MOD.Atrophinius.Name)
MOD.Lang.Unit.Atrophinius:SetGerman("Atrophinius der Gefallene") 
MOD.Lang.Unit.Atrophinius:SetFrench("Atrophinius le Déchu")
MOD.Lang.Unit.Atrophinius:SetRussian("Atrophinius the Fallen")
MOD.Lang.Unit.Atrophinius:SetKorean("몰락자 아트로피니우스")
MOD.Atrophinius.Name = MOD.Lang.Unit.Atrophinius[KBM.Lang]
MOD.Descript = MOD.Atrophinius.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Atrophinius.Name] = self.Atrophinius,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Atrophinius.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Atrophinius.Settings.TimersRef,
		-- AlertsRef = self.Atrophinius.Settings.AlertsRef,
	}
	KBMEXRDAF_Settings = self.Settings
	chKBMEXRDAF_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXRDAF_Settings = self.Settings
		self.Settings = chKBMEXRDAF_Settings
	else
		chKBMEXRDAF_Settings = self.Settings
		self.Settings = KBMEXRDAF_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXRDAF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXRDAF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXRDAF_Settings = self.Settings
	else
		KBMEXRDAF_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXRDAF_Settings = self.Settings
	else
		KBMEXRDAF_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Atrophinius.UnitID == UnitID then
		self.Atrophinius.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Atrophinius.UnitID == UnitID then
		self.Atrophinius.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Atrophinius.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Atrophinius.Dead = false
					self.Atrophinius.Casting = false
					self.Atrophinius.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Atrophinius.Name, 0, 100)
					self.Phase = 1
				end
				self.Atrophinius.UnitID = unitID
				self.Atrophinius.Available = true
				return self.Atrophinius
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Atrophinius.Available = false
	self.Atrophinius.UnitID = nil
	self.Atrophinius.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Atrophinius:SetTimers(bool)	
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

function MOD.Atrophinius:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Atrophinius, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Atrophinius)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Atrophinius)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Atrophinius.CastBar = KBM.CastBar:Add(self, self.Atrophinius)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end