-- Shatterhorn Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRCSHA_Settings = nil
chKBMNTRCSHA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Rhaza'de_Canyons"]

local MOD = {
	Directory = Instance.Directory,
	File = "Shatterhorn.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RC_Shatterhorn",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Shatterhorn = KBM.Language:Add("Shatterhorn")
MOD.Lang.Unit.Shatterhorn:SetFrench("Cornofracas")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Charge = KBM.Language:Add("Preparing to Charge...")
MOD.Lang.Ability.Charge:SetFrench("Préparation de charge en cours...")
MOD.Lang.Ability.Fury = KBM.Language:Add("Building Fury")
MOD.Lang.Ability.Fury:SetFrench("Montée de fureur")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

MOD.Shatterhorn = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Shatterhorn[KBM.Lang],
	--NameShort = "Shatterhorn",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U0792F9C900ACF0F2",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Charge = KBM.Defaults.AlertObj.Create("orange"),
			Fury = KBM.Defaults.AlertObj.Create("red"), 
			}
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Shatterhorn[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Shatterhorn.Name] = self.Shatterhorn,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Shatterhorn.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Shatterhorn.Settings.TimersRef,
		AlertsRef = self.Shatterhorn.Settings.AlertsRef,
	}
	KBMNTRCSHA_Settings = self.Settings
	chKBMNTRCSHA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRCSHA_Settings = self.Settings
		self.Settings = chKBMNTRCSHA_Settings
	else
		chKBMNTRCSHA_Settings = self.Settings
		self.Settings = KBMNTRCSHA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRCSHA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRCSHA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRCSHA_Settings = self.Settings
	else
		KBMNTRCSHA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRCSHA_Settings = self.Settings
	else
		KBMNTRCSHA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Shatterhorn.UnitID == UnitID then
		self.Shatterhorn.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Shatterhorn.UnitID == UnitID then
		self.Shatterhorn.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Shatterhorn.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Shatterhorn.Dead = false
				self.Shatterhorn.Casting = false
				self.Shatterhorn.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Shatterhorn.Name, 0, 100)
				self.Phase = 1
			end
			self.Shatterhorn.UnitID = unitID
			self.Shatterhorn.Available = true
			return self.Shatterhorn
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Shatterhorn.Available = false
	self.Shatterhorn.UnitID = nil
	self.Shatterhorn.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Shatterhorn)
	
	-- Create Alerts
	self.Shatterhorn.AlertsRef.Charge = KBM.Alert:Create(self.Lang.Ability.Charge[KBM.Lang], nil, false, true, "orange")
	self.Shatterhorn.AlertsRef.Fury = KBM.Alert:Create(self.Lang.Ability.Fury[KBM.Lang], nil, false, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Shatterhorn)
	
	-- Assign Alerts and Timers to Triggers
	self.Shatterhorn.Triggers.Charge = KBM.Trigger:Create(self.Lang.Ability.Charge[KBM.Lang], "cast", self.Shatterhorn)
	self.Shatterhorn.Triggers.Charge:AddAlert(self.Shatterhorn.AlertsRef.Charge, true)
	
	self.Shatterhorn.Triggers.Fury = KBM.Trigger:Create(self.Lang.Ability.Fury[KBM.Lang], "cast", self.Shatterhorn)
	self.Shatterhorn.Triggers.Fury:AddAlert(self.Shatterhorn.AlertsRef.Fury)
	
	self.Shatterhorn.Triggers.FuryStop = KBM.Trigger:Create(self.Lang.Ability.Fury[KBM.Lang], "interrupt", self.Shatterhorn)
	self.Shatterhorn.Triggers.FuryStop:AddStop(self.Shatterhorn.AlertsRef.Fury)
	
	self.Shatterhorn.CastBar = KBM.Castbar:Add(self, self.Shatterhorn)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end