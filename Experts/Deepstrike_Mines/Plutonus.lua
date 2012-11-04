-- Plutonus Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDMPS_Settings = nil
chKBMEXDMPS_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Deepstrike Mines"]

local MOD = {
	Directory = Instance.Directory,
	File = "Plutonus.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "ExPlutonus",
	Object = "MOD",
}

MOD.Plutonus = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Plutonus",
	NameShort = "Plutonus",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U3EA4CAE94A4A0D48",
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
MOD.Lang.Unit.Plutonus = KBM.Language:Add(MOD.Plutonus.Name)
MOD.Lang.Unit.Plutonus:SetGerman("Plutonus") 
MOD.Lang.Unit.Plutonus:SetFrench("Plutonus")
MOD.Lang.Unit.Plutonus:SetRussian("Плутон")
MOD.Lang.Unit.Plutonus:SetKorean("플루토누스")
MOD.Plutonus.Name = MOD.Lang.Unit.Plutonus[KBM.Lang]
MOD.Descript = MOD.Plutonus.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Plutonus.Name] = self.Plutonus,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Plutonus.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Plutonus.Settings.TimersRef,
		-- AlertsRef = self.Plutonus.Settings.AlertsRef,
	}
	KBMEXDMPS_Settings = self.Settings
	chKBMEXDMPS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXDMPS_Settings = self.Settings
		self.Settings = chKBMEXDMPS_Settings
	else
		chKBMEXDMPS_Settings = self.Settings
		self.Settings = KBMEXDMPS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXDMPS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXDMPS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXDMPS_Settings = self.Settings
	else
		KBMEXDMPS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXDMPS_Settings = self.Settings
	else
		KBMEXDMPS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Plutonus.UnitID == UnitID then
		self.Plutonus.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Plutonus.UnitID == UnitID then
		self.Plutonus.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Plutonus.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Plutonus.Dead = false
					self.Plutonus.Casting = false
					self.Plutonus.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Plutonus.Name, 0, 100)
					self.Phase = 1
				end
				self.Plutonus.UnitID = unitID
				self.Plutonus.Available = true
				return self.Plutonus
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Plutonus.Available = false
	self.Plutonus.UnitID = nil
	self.Plutonus.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Plutonus:SetTimers(bool)	
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

function MOD.Plutonus:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Plutonus, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Plutonus)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Plutonus)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Plutonus.CastBar = KBM.CastBar:Add(self, self.Plutonus)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end