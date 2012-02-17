-- Gatekeeper Kaleida Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDMGA_Settings = nil
chKBMEXDMGA_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Deepstrike Mines"]

local MOD = {
	Directory = Instance.Directory,
	File = "Kaleida.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Kaleida",
}

MOD.Kaleida = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Gatekeeper Kaleida",
	NameShort = "Kaleida",
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

MOD.Lang.Kaleida = KBM.Language:Add(MOD.Kaleida.Name)
MOD.Lang.Kaleida:SetGerman("Torwächterin Kaleida") 
-- MOD.Lang.Kaleida:SetFrench("")
-- MOD.Lang.Kaleida:SetRussian("")
MOD.Kaleida.Name = MOD.Lang.Kaleida[KBM.Lang]
MOD.Descript = MOD.Kaleida.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kaleida.Name] = self.Kaleida,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kaleida.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Kaleida.Settings.TimersRef,
		-- AlertsRef = self.Kaleida.Settings.AlertsRef,
	}
	KBMEXDMGA_Settings = self.Settings
	chKBMEXDMGA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXDMGA_Settings = self.Settings
		self.Settings = chKBMEXDMGA_Settings
	else
		chKBMEXDMGA_Settings = self.Settings
		self.Settings = KBMEXDMGA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXDMGA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXDMGA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXDMGA_Settings = self.Settings
	else
		KBMEXDMGA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXDMGA_Settings = self.Settings
	else
		KBMEXDMGA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Kaleida.UnitID == UnitID then
		self.Kaleida.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Kaleida.UnitID == UnitID then
		self.Kaleida.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Kaleida.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Kaleida.Dead = false
					self.Kaleida.Casting = false
					self.Kaleida.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Kaleida.Name, 0, 100)
					self.Phase = 1
				end
				self.Kaleida.UnitID = unitID
				self.Kaleida.Available = true
				return self.Kaleida
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Kaleida.Available = false
	self.Kaleida.UnitID = nil
	self.Kaleida.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Kaleida:SetTimers(bool)	
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

function MOD.Kaleida:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Kaleida, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Kaleida)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Kaleida)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Kaleida.CastBar = KBM.CastBar:Add(self, self.Kaleida)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end