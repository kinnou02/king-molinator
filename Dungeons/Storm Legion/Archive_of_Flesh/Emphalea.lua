-- Emphalea Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMAOFEMP_Settings = nil
chKBMSLNMAOFEMP_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Archive of Flesh"]

local MOD = {
	Directory = Instance.Directory,
	File = "Emphalea.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Emphalea",
	Object = "MOD",
}

MOD.Emphalea = {
	Mod = MOD,
	Level = "59",
	Active = false,
	Name = "Emphalea",
	NameShort = "Emphalea",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFFDAFE516E2DAA41",
	TimeOut = 5,
	Triggers = {},
	AlertsRef = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Flood = KBM.Defaults.AlertObj.Create("blue"),
			FloodChannel = KBM.Defaults.AlertObj.Create("cyan"),
		},
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Emphalea = KBM.Language:Add(MOD.Emphalea.Name)
MOD.Lang.Unit.Emphalea:SetGerman()
MOD.Lang.Unit.Emphalea:SetFrench()
MOD.Emphalea.Name = MOD.Lang.Unit.Emphalea[KBM.Lang]
MOD.Descript = MOD.Emphalea.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Emphalea")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Emphalea.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Flood = KBM.Language:Add("Flood the Halls")

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.Flood = KBM.Language:Add("Flood the Halls (Duration)")

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Emphalea.Name] = self.Emphalea,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Emphalea.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Emphalea.Settings.TimersRef,
		AlertsRef = self.Emphalea.Settings.AlertsRef,
	}
	KBMSLNMAOFEMP_Settings = self.Settings
	chKBMSLNMAOFEMP_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMAOFEMP_Settings = self.Settings
		self.Settings = chKBMSLNMAOFEMP_Settings
	else
		chKBMSLNMAOFEMP_Settings = self.Settings
		self.Settings = KBMSLNMAOFEMP_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMAOFEMP_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMAOFEMP_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMAOFEMP_Settings = self.Settings
	else
		KBMSLNMAOFEMP_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMAOFEMP_Settings = self.Settings
	else
		KBMSLNMAOFEMP_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Emphalea.UnitID == UnitID then
		self.Emphalea.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Emphalea.UnitID == UnitID then
		self.Emphalea.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Emphalea.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Emphalea.Dead = false
					self.Emphalea.Casting = false
					self.Emphalea.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Emphalea.Name, 0, 100)
					self.Phase = 1
				end
				self.Emphalea.UnitID = unitID
				self.Emphalea.Available = true
				return self.Emphalea
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Emphalea.Available = false
	self.Emphalea.UnitID = nil
	self.Emphalea.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Emphalea)
	
	-- Create Alerts
	self.Emphalea.AlertsRef.Flood = KBM.Alert:Create(self.Lang.Ability.Flood[KBM.Lang], nil, false, true, "blue")
	self.Emphalea.AlertsRef.FloodChannel = KBM.Alert:Create(self.Lang.Ability.Flood[KBM.Lang], nil, false, true, "cyan")
	self.Emphalea.AlertsRef.FloodChannel.MenuName = self.Lang.Verbose.Flood[KBM.Lang]
	KBM.Defaults.AlertObj.Assign(self.Emphalea)
	
	-- Assign Alerts and Timers to Triggers
	self.Emphalea.Triggers.Flood = KBM.Trigger:Create(self.Lang.Ability.Flood[KBM.Lang], "cast", self.Emphalea)
	self.Emphalea.Triggers.Flood:AddAlert(self.Emphalea.AlertsRef.Flood)
	self.Emphalea.Triggers.FloodChannel = KBM.Trigger:Create(self.Lang.Ability.Flood[KBM.Lang], "channel", self.Emphalea)
	self.Emphalea.Triggers.FloodChannel:AddAlert(self.Emphalea.AlertsRef.FloodChannel)
	
	self.Emphalea.CastBar = KBM.Castbar:Add(self, self.Emphalea)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
end