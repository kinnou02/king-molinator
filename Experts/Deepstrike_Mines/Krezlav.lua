-- Gregori Krezlav Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDMGK_Settings = nil
chKBMEXDMGK_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Deepstrike Mines"]

local MOD = {
	Directory = Instance.Directory,
	File = "Krezlav.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Krezlav",
	Object = "MOD",
}

MOD.Krezlav = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Gregori Krezlav",
	NameShort = "Krezlav",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U6C237E5B7A00B2C3",
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
MOD.Lang.Unit.Krezlav = KBM.Language:Add(MOD.Krezlav.Name)
MOD.Lang.Unit.Krezlav:SetGerman() 
MOD.Lang.Unit.Krezlav:SetFrench()
-- MOD.Lang.Unit.Krezlav:SetRussian("")
MOD.Krezlav.Name = MOD.Lang.Unit.Krezlav[KBM.Lang]
MOD.Descript = MOD.Krezlav.Name
MOD.Lang.Unit.KrezShort = KBM.Language:Add("Krezlav")
MOD.Lang.Unit.KrezShort:SetGerman()
MOD.Lang.Unit.KrezShort:SetFrench()
MOD.Krezlav.NameShort = MOD.Lang.Unit.KrezShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Krezlav.Name] = self.Krezlav,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Krezlav.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Krezlav.Settings.TimersRef,
		-- AlertsRef = self.Krezlav.Settings.AlertsRef,
	}
	KBMEXDMGK_Settings = self.Settings
	chKBMEXDMGK_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXDMGK_Settings = self.Settings
		self.Settings = chKBMEXDMGK_Settings
	else
		chKBMEXDMGK_Settings = self.Settings
		self.Settings = KBMEXDMGK_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXDMGK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXDMGK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXDMGK_Settings = self.Settings
	else
		KBMEXDMGK_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXDMGK_Settings = self.Settings
	else
		KBMEXDMGK_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Krezlav.UnitID == UnitID then
		self.Krezlav.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Krezlav.UnitID == UnitID then
		self.Krezlav.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Krezlav.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Krezlav.Dead = false
					self.Krezlav.Casting = false
					self.Krezlav.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Krezlav.Name, 0, 100)
					self.Phase = 1
				end
				self.Krezlav.UnitID = unitID
				self.Krezlav.Available = true
				return self.Krezlav
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Krezlav.Available = false
	self.Krezlav.UnitID = nil
	self.Krezlav.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Krezlav:SetTimers(bool)	
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

function MOD.Krezlav:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Krezlav, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Krezlav)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Krezlav)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Krezlav.CastBar = KBM.CastBar:Add(self, self.Krezlav)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end