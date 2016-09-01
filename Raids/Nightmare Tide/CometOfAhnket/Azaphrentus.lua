-- Azaphrentus Boss Mod for King Boss Mods
-- Written by Elinare
-- Copyright 2016
--

KBMNTAZA_Settings = nil
cCOABMNTAZA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local COA = KBM.BossMod["RCometOfAhnket"]

local AZA = {
	Directory = COA.Directory,
	File = "Azaphrentus.lua",
	Enabled = true,
	Instance = COA.Name,
	InstanceObj = COA,
	Lang = {},
	Enrage = 60 * 5,
	ID = "Azaphrentus",
	Object = "AZA",
}

AZA.Aza = {
	Mod = AZA,
	Menu = {},
	Level = "??",
	Active = false,
	Name = "Azaphrentus",
	UTID = "U2DE24EF95E4A9B9F",
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = true,
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	MechRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		Filters = {
			Enabled = true,
			PopAdd = KBM.Defaults.CastFilter.Create("yellow"),
		},
		TimersRef = {
			Enabled = true,
			PopAdd = KBM.Defaults.TimerObj.Create("blue"),
			Rage = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			PopAdd = KBM.Defaults.AlertObj.Create("blue"),
			Rage = KBM.Defaults.AlertObj.Create("orange"),
		},
		MechRef = {
			Enabled = true,
			Rage = KBM.Defaults.MechObj.Create("orange"),
		},
	}
}

KBM.RegisterMod("Azaphrentus", AZA)

-- Main Unit Dictionary
AZA.Lang.Unit = {}
AZA.Lang.Unit.Azaphrentus = KBM.Language:Add(AZA.Aza.Name)
AZA.Lang.Unit.Azaphrentus:SetGerman("Azaphrentus")
AZA.Lang.Unit.Azaphrentus:SetFrench("Azaphrentus")
AZA.Lang.Unit.Azaphrentus:SetRussian("Azaphrentus")
AZA.Lang.Unit.Azaphrentus:SetKorean("Azaphrentus")
AZA.Aza.Name = AZA.Lang.Unit.Azaphrentus[KBM.Lang]
AZA.Descript = AZA.Lang.Unit.Azaphrentus[KBM.Lang]

-- Ability Dictionary
AZA.Lang.Ability = {}
AZA.Lang.Ability.PopAdd = KBM.Language:Add("​Manifest Scorn")
AZA.Lang.Ability.PopAdd:SetFrench("Manifestation de mépris")
AZA.Lang.Ability.PopAdd:SetGerman("Manifestierte Verachtung")
AZA.Lang.Ability.PopAdd:SetRussian("????????? ????")
AZA.Lang.Ability.PopAdd:SetKorean("?? ??")

-- Debuff Dictionary
AZA.Lang.Debuff = {}
AZA.Lang.Debuff.Rage = KBM.Language:Add("Rage of Azaphrentus")
AZA.Lang.Debuff.Rage:SetFrench("Rage d'Azaphrentus")
AZA.Lang.Debuff.Rage:SetGerman("Wut des Azaphrentus")
AZA.Lang.Debuff.Rage:SetRussian("Azaphrentus Rage")
AZA.Lang.Debuff.Rage:SetKorean("Azaphrentus Rage")

function AZA:AddBosses(KBM_Boss)
	self.MenuName = self.Aza.Name
	self.Bosses = {
		[self.Aza.Name] = self.Aza
	}
end

function AZA:InitVars()
	self.Settings = {
		Enabled = true,
		Chronicle = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		CastBar = AZA.Aza.Settings.CastBar,
		MechTimer = KBM.Defaults.MechTimer(),
		TimersRef = AZA.Aza.Settings.TimersRef,
		AlertsRef = AZA.Aza.Settings.AlertsRef,
		Alerts = KBM.Defaults.Alerts(),
		CastFilters = AZA.Aza.Settings.Filters,
		MechSpy = KBM.Defaults.MechSpy(),
		MechRef = AZA.Aza.Settings.MechRef,
	}
	KBMNTAZA_Settings = self.Settings
	cCOABMNTAZA_Settings = self.Settings	
end

function AZA:SwapSettings(bool)
	if bool then
		KBMNTRDAZA_Settings = self.Settings
		self.Settings = chKBMNTRDAZA_Settings
	else
		chKBMNTRDAZA_Settings = self.Settings
		self.Settings = KBMNTRDAZA_Settings
	end
end

function AZA:LoadVars()		
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDAZA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDAZA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRDAZA_Settings = self.Settings
	else
		KBMNTRDAZA_Settings = self.Settings
	end	
	
	self.Aza.CastFilters[self.Lang.Ability.PopAdd[KBM.Lang]] = {ID = "PopAdd"}
	KBM.Defaults.CastFilter.Assign(self.Aza)
	
end

function AZA:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRDAZA_Settings = self.Settings
	else
		KBMNTRDAZA_Settings = self.Settings
	end	
end

function AZA:Castbar()
end

function AZA:RemoveUnits(UnitID)
	if self.Aza.UnitID == UnitID then
		self.Aza.Available = false
		return true
	end
	return false	
end

function AZA:Death(UnitID)
	if self.Aza.UnitID == UnitID then
		self.Aza.Dead = true
		return true
	end
	return false	
end

function AZA:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Aza.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Phase = 1
					self.Aza.Dead = false
					self.Aza.CastBar:Create(unitID)
					self.PhaseObj.Objectives:AddPercent(self.Aza, 0, 100)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
				end
				self.Aza.Casting = false
				self.Aza.UnitID = unitID
				self.Aza.Available = true
				return self.Aza
			end
		end
	end
end

function AZA:Reset()
	self.EncounterRunning = false
	self.Aza.UnitID = nil
	self.Aza.Dead = false
	self.Aza.Available = false
	self.Aza.CastBar:Remove()
	self.Phase = 1
	self.PhaseObj:End(Inspect.Time.Real())	
end

function AZA:Timer()	
end

AZA.Custom = {}

function AZA:Start()	
	-- Create Timers
	self.Aza.TimersRef.PopAdd = KBM.MechTimer:Add(self.Lang.Ability.PopAdd[KBM.Lang], nil)
	self.Aza.TimersRef.Rage = KBM.MechTimer:Add(self.Lang.Debuff.Rage[KBM.Lang], nil)
	
	KBM.Defaults.TimerObj.Assign(self.Aza)
	
	-- Create Alerts
	self.Aza.AlertsRef.PopAdd = KBM.Alert:Create(self.Lang.Ability.PopAdd[KBM.Lang], nil, false, true, "yellow")
	self.Aza.AlertsRef.Rage = KBM.Alert:Create(self.Lang.Debuff.Rage[KBM.Lang], nil, false, true, "orange")
	
	KBM.Defaults.AlertObj.Assign(self.Aza)
	
	-- Create Spy
	
	self.Aza.MechRef.Rage = KBM.MechSpy:Add(self.Lang.Debuff.Rage[KBM.Lang], nil, "debuff", self.Aza)
	KBM.Defaults.MechObj.Assign(self.Aza)
	
	-- Assign Mechanics to Triggers
	self.Aza.Triggers.PopAdd = KBM.Trigger:Create(self.Lang.Ability.PopAdd[KBM.Lang], "cast", self.Aza)
	self.Aza.Triggers.PopAdd:AddTimer(self.Aza.TimersRef.PopAdd)
	self.Aza.Triggers.PopAdd:AddAlert(self.Aza.AlertsRef.PopAdd)
	
	self.Aza.Triggers.Rage = KBM.Trigger:Create(self.Lang.Debuff.Rage[KBM.Lang], "buff", self.Aza)
	self.Aza.Triggers.Rage:AddTimer(self.Aza.TimersRef.Rage)
	self.Aza.Triggers.Rage:AddAlert(self.Aza.AlertsRef.Rage)
	
	-- Assign Castbar object.
	self.Aza.CastBar = KBM.Castbar:Add(self, self.Aza)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end