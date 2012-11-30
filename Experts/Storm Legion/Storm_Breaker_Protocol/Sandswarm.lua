-- Sandswarm Onslaught Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXSBPSSO_Settings = nil
chKBMSLEXSBPSSO_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EStorm_Breaker_Protocol"]

local MOD = {
	Directory = Instance.Directory,
	File = "Sandswarm.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Sandswarm",
	Object = "MOD",
}

MOD.Sandswarm = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Sandswarm Onslaught",
	NameShort = "Sandswarm",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "none",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Sandswarm = KBM.Language:Add(MOD.Sandswarm.Name)
MOD.Lang.Unit.Sandswarm:SetGerman("Sandschwarm-Ansturm")
MOD.Lang.Unit.Sandswarm:SetFrench("assaut des Sablenuées")
MOD.Sandswarm.Name = MOD.Lang.Unit.Sandswarm[KBM.Lang]
MOD.Descript = MOD.Sandswarm.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Sandswarm")
MOD.Lang.Unit.AndShort:SetGerman("Sandschwarm")
MOD.Lang.Unit.AndShort:SetFrench("Sablenuées")
MOD.Sandswarm.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Sandswarm.Name] = self.Sandswarm,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Sandswarm.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Sandswarm.Settings.TimersRef,
		-- AlertsRef = self.Sandswarm.Settings.AlertsRef,
	}
	KBMSLEXSBPSSO_Settings = self.Settings
	chKBMSLEXSBPSSO_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXSBPSSO_Settings = self.Settings
		self.Settings = chKBMSLEXSBPSSO_Settings
	else
		chKBMSLEXSBPSSO_Settings = self.Settings
		self.Settings = KBMSLEXSBPSSO_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXSBPSSO_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXSBPSSO_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXSBPSSO_Settings = self.Settings
	else
		KBMSLEXSBPSSO_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXSBPSSO_Settings = self.Settings
	else
		KBMSLEXSBPSSO_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Sandswarm.UnitID == UnitID then
		self.Sandswarm.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Sandswarm.UnitID == UnitID then
		self.Sandswarm.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Sandswarm.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Sandswarm.Dead = false
					self.Sandswarm.Casting = false
					self.Sandswarm.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Sandswarm.Name, 0, 100)
					self.Phase = 1
				end
				self.Sandswarm.UnitID = unitID
				self.Sandswarm.Available = true
				return self.Sandswarm
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Sandswarm.Available = false
	self.Sandswarm.UnitID = nil
	self.Sandswarm.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Sandswarm, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Sandswarm)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Sandswarm)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Sandswarm.CastBar = KBM.CastBar:Add(self, self.Sandswarm)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end