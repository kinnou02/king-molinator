-- Duke Fyragnos Boss Mod for King Boss Mods
-- Written by Elinare
-- Copyright 2016
--

KBMNTFYR_Settings = nil
cCOABMNTFYR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local COA = KBM.BossMod["RCometOfAhnket"]

local FYR = {
	Directory = COA.Directory,
	File = "Fyragnos.lua",
	Enabled = true,
	HasPhases = true,
	Instance = COA.Name,
	InstanceObj = COA,
	Lang = {},
	Enrage = 510,
	ID = "Fyragnos",
	Object = "FYR",
}

FYR.Fyr = {
	Mod = FYR,
	Menu = {},
	Level = "??",
	Active = false,
	Name = "Fyragnos",
	UTID = "U7019822A010E9049",
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
			Flammestrom = KBM.Defaults.CastFilter.Create("red"),
			AppelDrake = KBM.Defaults.CastFilter.Create("purple"),
			Embrasement = KBM.Defaults.CastFilter.Create("yellow"),
			Explosion = KBM.Defaults.CastFilter.Create("pink"),
			FlammeDeDesespoir = KBM.Defaults.CastFilter.Create("dark_green"),
		},
		TimersRef = {
			Enabled = true,
		},
		AlertsRef = {
			Enabled = true,
			Flammestrom = KBM.Defaults.AlertObj.Create("red"),
			AppelDrake = KBM.Defaults.AlertObj.Create("purple"),
			Embrasement = KBM.Defaults.AlertObj.Create("yellow"),
			Explosion = KBM.Defaults.AlertObj.Create("pink"),
			FlammeDeDesespoir = KBM.Defaults.AlertObj.Create("dark_green"),
		},
		MechRef = {
			Enabled = true,
		},
	}
}

KBM.RegisterMod("Fyragnos", FYR)

-- Main Unit Dictionary
FYR.Lang.Unit = {}
FYR.Lang.Unit.Fyragnos = KBM.Language:Add(FYR.Fyr.Name)
FYR.Lang.Unit.Fyragnos:SetGerman("Fyragnos")
FYR.Lang.Unit.Fyragnos:SetFrench("Fyragnos")
FYR.Lang.Unit.Fyragnos:SetRussian("??????????")
FYR.Lang.Unit.Fyragnos:SetKorean("????")
FYR.Fyr.Name = FYR.Lang.Unit.Fyragnos[KBM.Lang]
FYR.Descript = FYR.Lang.Unit.Fyragnos[KBM.Lang]

-- Ability Dictionary
FYR.Lang.Ability = {}
FYR.Lang.Ability.Flammestrom = KBM.Language:Add("Summon Flamestrom")
FYR.Lang.Ability.Flammestrom:SetFrench("Flammeström")
FYR.Lang.Ability.Flammestrom:SetGerman("Flammenstrom beschwören")
FYR.Lang.Ability.Flammestrom:SetRussian("????????? ????")
FYR.Lang.Ability.Flammestrom:SetKorean("?? ??")
FYR.Lang.Ability.AppelDrake = KBM.Language:Add("Call of the Drake")
FYR.Lang.Ability.AppelDrake:SetFrench("Appel du drake")
FYR.Lang.Ability.AppelDrake:SetGerman("Ruf der Draken")
FYR.Lang.Ability.AppelDrake:SetRussian("???????? ????")
FYR.Lang.Ability.AppelDrake:SetKorean("??? ??")
FYR.Lang.Ability.Embrasement = KBM.Language:Add("Withering Blaze")
FYR.Lang.Ability.Embrasement:SetFrench("Embrasement desséchant")
FYR.Lang.Ability.Embrasement:SetGerman("Embrasement desséchant")
FYR.Lang.Ability.Embrasement:SetRussian("???????? ????")
FYR.Lang.Ability.Embrasement:SetKorean("??? ??")
FYR.Lang.Ability.Explosion = KBM.Language:Add("Magma Blast")
FYR.Lang.Ability.Explosion:SetFrench("Explosion de magma")
FYR.Lang.Ability.Explosion:SetGerman("Explosion de magma")
FYR.Lang.Ability.Explosion:SetRussian("???????? ????")
FYR.Lang.Ability.Explosion:SetKorean("??? ??")
FYR.Lang.Ability.FlammeDeDesespoir = KBM.Language:Add("Flame of Despair")
FYR.Lang.Ability.FlammeDeDesespoir:SetFrench("Flamme de désespoir")
FYR.Lang.Ability.FlammeDeDesespoir:SetGerman("Flamme de désespoir")
FYR.Lang.Ability.FlammeDeDesespoir:SetRussian("???????? ????")
FYR.Lang.Ability.FlammeDeDesespoir:SetKorean("??? ??")


-- Verbose Dictionary
FYR.Lang.Verbose = {}
FYR.Lang.Verbose.Flammestrom = KBM.Language:Add("Tornado!")
FYR.Lang.Verbose.Flammestrom:SetFrench("Tornade!")
FYR.Lang.Verbose.Flammestrom:SetGerman("Flammenstrom!")
FYR.Lang.Verbose.Flammestrom:SetRussian("Tornado!")
FYR.Lang.Verbose.Flammestrom:SetKorean("Tornado!")
FYR.Lang.Verbose.Explosion = KBM.Language:Add("Spread!")
FYR.Lang.Verbose.Explosion:SetFrench("Spread!")
FYR.Lang.Verbose.Explosion:SetGerman("Geh Weg!")
FYR.Lang.Verbose.Explosion:SetRussian("Spread!")
FYR.Lang.Verbose.Explosion:SetKorean("Spread!")
FYR.Lang.Verbose.FlammeDeDesespoir = KBM.Language:Add("Cleanse!")
FYR.Lang.Verbose.FlammeDeDesespoir:SetFrench("Dispel!")
FYR.Lang.Verbose.FlammeDeDesespoir:SetGerman("Reinigen!")
FYR.Lang.Verbose.FlammeDeDesespoir:SetRussian("Cleanse!")
FYR.Lang.Verbose.FlammeDeDesespoir:SetKorean("Cleanse!")


-- Debuff Dictionary
FYR.Lang.Debuff = {}

function FYR:AddBosses(KBM_Boss)
	self.MenuName = self.Fyr.Name
	self.Bosses = {
		[self.Fyr.Name] = self.Fyr
	}
end

function FYR:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		CastBar = FYR.Fyr.Settings.CastBar,
		MechTimer = KBM.Defaults.MechTimer(),
		TimersRef = FYR.Fyr.Settings.TimersRef,
		AlertsRef = FYR.Fyr.Settings.AlertsRef,
		Alerts = KBM.Defaults.Alerts(),
		CastFilters = FYR.Fyr.Settings.Filters,
		MechSpy = KBM.Defaults.MechSpy(),
		MechRef = FYR.Fyr.Settings.MechRef,
	}
	KBMNTFYR_Settings = self.Settings
	cCOABMNTFYR_Settings = self.Settings	
end

function FYR:SwapSettings(bool)
	if bool then
		KBMNTRDFYR_Settings = self.Settings
		self.Settings = chKBMNTRDFYR_Settings
	else
		chKBMNTRDFYR_Settings = self.Settings
		self.Settings = KBMNTRDFYR_Settings
	end
end

function FYR:LoadVars()		
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDFYR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDFYR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRDFYR_Settings = self.Settings
	else
		KBMNTRDFYR_Settings = self.Settings
	end	
	
	self.Fyr.CastFilters[self.Lang.Ability.Flammestrom[KBM.Lang]] = {ID = "Flammestrom"}
	self.Fyr.CastFilters[self.Lang.Ability.AppelDrake[KBM.Lang]] = {ID = "AppelDrake"}
	self.Fyr.CastFilters[self.Lang.Ability.Embrasement[KBM.Lang]] = {ID = "Embrasement"}
	self.Fyr.CastFilters[self.Lang.Ability.Explosion[KBM.Lang]] = {ID = "Explosion"}
	self.Fyr.CastFilters[self.Lang.Ability.FlammeDeDesespoir[KBM.Lang]] = {ID = "FlammeDeDesespoir"}
	KBM.Defaults.CastFilter.Assign(self.Fyr)
	
end

function FYR:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRDFYR_Settings = self.Settings
	else
		KBMNTRDFYR_Settings = self.Settings
	end	
end

function FYR:Castbar()
end

function FYR:RemoveUnits(UnitID)
	if self.Fyr.UnitID == UnitID then
		self.Fyr.Available = false
		return true
	end
	return false	
end

function FYR:Death(UnitID)
	if self.Fyr.UnitID == UnitID then
		self.Fyr.Dead = true
		return true
	end
	return false	
end

function FYR:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Fyr.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Fyr.Dead = false
					self.Fyr.Casting = false
					self.Fyr.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
					self.PhaseObj.Objectives:AddPercent(self.Fyr, 85, 100)
				end
				self.Fyr.Casting = false
				self.Fyr.UnitID = unitID
				self.Fyr.Available = true
				return self.Fyr
			end
		end
	end
end

function FYR:Reset()
	self.EncounterRunning = false
	self.Fyr.UnitID = nil
	self.Fyr.Dead = false
	self.Fyr.Available = false
	self.Fyr.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())	
end

function FYR:Timer()	
end



function FYR:Start()	
	-- Create Timers
	KBM.Defaults.TimerObj.Assign(self.Fyr)
	
	-- Create Alerts
	self.Fyr.AlertsRef.Flammestrom = KBM.Alert:Create(self.Lang.Ability.Flammestrom[KBM.Lang], nil, false, true, "red")
	self.Fyr.AlertsRef.AppelDrake = KBM.Alert:Create(self.Lang.Ability.AppelDrake[KBM.Lang], nil, false, true, "purple")
	self.Fyr.AlertsRef.Embrasement = KBM.Alert:Create(self.Lang.Ability.Embrasement[KBM.Lang], nil, false, true, "yellow")
	self.Fyr.AlertsRef.Explosion = KBM.Alert:Create(self.Lang.Ability.Explosion[KBM.Lang], nil, false, true, "pink")
	self.Fyr.AlertsRef.FlammeDeDesespoir = KBM.Alert:Create(self.Lang.Ability.FlammeDeDesespoir[KBM.Lang], nil, false, true, "dark_green")
	KBM.Defaults.AlertObj.Assign(self.Fyr)
	
	-- Create Spy
	
	KBM.Defaults.MechObj.Assign(self.Fyr)
	
	self.Fyr.Triggers.Flammestrom = KBM.Trigger:Create(self.Lang.Ability.Flammestrom[KBM.Lang], "cast", self.Fyr)
	self.Fyr.Triggers.Flammestrom:AddAlert(self.Fyr.AlertsRef.Flammestrom)
	
	self.Fyr.Triggers.AppelDrake = KBM.Trigger:Create(self.Lang.Ability.AppelDrake[KBM.Lang], "cast", self.Fyr)
	self.Fyr.Triggers.AppelDrake:AddAlert(self.Fyr.AlertsRef.AppelDrake)
	
	self.Fyr.Triggers.Embrasement = KBM.Trigger:Create(self.Lang.Ability.Embrasement[KBM.Lang], "cast", self.Fyr)
	self.Fyr.Triggers.Embrasement:AddAlert(self.Fyr.AlertsRef.Embrasement)
	
	self.Fyr.Triggers.Explosion = KBM.Trigger:Create(self.Lang.Ability.Explosion[KBM.Lang], "cast", self.Fyr)
	self.Fyr.Triggers.Explosion:AddAlert(self.Fyr.AlertsRef.Explosion)
	
	self.Fyr.Triggers.FlammeDeDesespoir = KBM.Trigger:Create(self.Lang.Ability.FlammeDeDesespoir[KBM.Lang], "cast", self.Fyr)
	self.Fyr.Triggers.FlammeDeDesespoir:AddAlert(self.Fyr.AlertsRef.FlammeDeDesespoir)
	
	
	
	-- Assign Castbar object.
	self.Fyr.CastBar = KBM.Castbar:Add(self, self.Fyr)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end