-- Lord Greenscale Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBLG_Settings = nil
chKBMGSBLG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GSB = KBM.BossMod["Greenscales Blight"]

local LG = {
	Enabled = true,
	Instance = GSB.Name,
	HasPhases = true,
	Lang = {},
	Enrage = 60 * 14.5,	
	ID = "Greenscale",
}

LG.Greenscale = {
	Mod = LG,
	Level = "52",
	Active = false,
	Name = "Lord Greenscale",
	NameShort = "Greenscale",
	Menu = {},
	Castbar = nil,
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Blight = KBM.Defaults.TimerObj.Create(),
			Fumes = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Blight = KBM.Defaults.AlertObj.Create("red"),
			FumesWarn = KBM.Defaults.AlertObj.Create("purple"),
			Fumes = KBM.Defaults.AlertObj.Create("purple"),
			Death = KBM.Defaults.AlertObj.Create("dark_green"),
		},
	}
}

KBM.RegisterMod(LG.ID, LG)

LG.Lang.Greenscale = KBM.Language:Add(LG.Greenscale.Name)
LG.Lang.Greenscale.German = "Fürst Grünschuppe"
LG.Lang.Greenscale.French = "Seigneur Vert\195\169caille"

-- Ability Dictionary
LG.Lang.Ability = {}
LG.Lang.Ability.Blight = KBM.Language:Add("Strangling Blight")
LG.Lang.Ability.Blight.German = "Würgende Plage"
LG.Lang.Ability.Fumes = KBM.Language:Add("Noxious Fumes")
LG.Lang.Ability.Fumes.German = "Giftige Dämpfe"

-- Unit Dictionary
LG.Lang.Unit = {}
LG.Lang.Unit.Verdant = KBM.Language:Add("Verdant Annihilator")
LG.Lang.Unit.Verdant.German = "Grüner Auslöscher" 

-- Mechanic Dictionary
LG.Lang.Mechanic = {}
LG.Lang.Mechanic.Death = KBM.Language:Add("Protective Shield")

LG.Greenscale.Name = LG.Lang.Greenscale[KBM.Lang]

LG.Verdant = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = LG.Lang.Unit.Verdant[KBM.Lang],
	Dead = false, 
	Available = false,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Ignore = true,
	Triggers = {},
}

function LG:AddBosses(KBM_Boss)
	self.Greenscale.Descript = self.Greenscale.Name
	self.MenuName = self.Greenscale.Descript
	self.Bosses = {
		[self.Greenscale.Name] = self.Greenscale,
		[self.Verdant.Name] = self.Verdant,
	}
	KBM_Boss[self.Greenscale.Name] = self.Greenscale
	KBM.SubBoss[self.Verdant.Name] = self.Verdant
end

function LG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Greenscale.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Greenscale.Settings.TimersRef,
		AlertsRef = self.Greenscale.Settings.AlertsRef,
	}
	KBMGSBLG_Settings = self.Settings
	chKBMGSBLG_Settings = self.Settings	
end

function LG:SwapSettings(bool)
	if bool then
		KBMGSBLG_Settings = self.Settings
		self.Settings = chKBMGSBLG_Settings
	else
		chKBMGSBLG_Settings = self.Settings
		self.Settings = KBMGSBLG_Settings
	end
end

function LG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGSBLG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGSBLG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGSBLG_Settings = self.Settings
	else
		KBMGSBLG_Settings = self.Settings
	end	
end

function LG:SaveVars()	
	if KBM.Options.Character then
		chKBMGSBLG_Settings = self.Settings
	else
		KBMGSBLG_Settings = self.Settings
	end	
end

function LG:Castbar(units)
end

function LG:RemoveUnits(UnitID)
	if self.Greenscale.UnitID == UnitID then
		self.Greenscale.Available = false
		return true
	end
	return false
end

function LG:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Greenscale.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Greenscale.Dead = false
					self.Greenscale.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.Phase = 1
					self.PhaseObj:SetPhase(1)
					self.PhaseObj.Objectives:AddPercent(self.Greenscale.Name, 75, 100)
					self.Verdant.UnitID = nil
				end
				self.Greenscale.Casting = false
				self.Greenscale.UnitID = unitID
				self.Greenscale.Available = true
				return self.Greenscale
			elseif uDetails.name == self.Verdant.Name then
				if self.Verdant.UnitID == nil then
					self.Verdant.Casting = false
					self.Verdant.Dead = false
					self.Verdant.UnitID = unitID
					self.Verdant.Available = true
					return self.Verdant
				end
			end
		end
	end
end

function LG.AirPhase()
	LG.PhaseObj.Objectives:Remove()
	LG.PhaseObj:SetPhase("Air")
	LG.PhaseObj.Objectives:AddPercent(LG.Verdant.Name, 0, 100)
end

function LG.PhaseTwo()
	LG.PhaseObj.Objectives:Remove()
	LG.Phase = 2
	LG.PhaseObj:SetPhase(2)
	LG.PhaseObj.Objectives:AddPercent(LG.Greenscale.Name, 50, 75)
end

function LG.PhaseThree()
	LG.PhaseObj.Objectives:Remove()
	LG.Phase = 3
	LG.PhaseObj:SetPhase(3)
	LG.PhaseObj.Objectives:AddPercent(LG.Greenscale.Name, 25, 50)	
end

function LG.PhaseFour()
	LG.PhaseObj.Objectives:Remove()
	LG.Phase = 4
	LG.PhaseObj:SetPhase("Final")
	LG.PhaseObj.Objectives:AddPercent(LG.Greenscale.Name, 0, 25)
end

function LG:Death(UnitID)
	if self.Greenscale.UnitID == UnitID then
		self.Greenscale.Dead = true
		return true
	elseif self.Verdant.UnitID == UnitID then
		if not self.Verdant.Dead then
			KBM.Alert:Start(self.Greenscale.AlertsRef.Death, Inspect.Time.Real())
			self.Verdant.Dead = true
			self.Verdant.UnitID = nil
			if self.Phase == 1 then
				self.PhaseTwo()
			elseif self.Phase == 2 then
				self.PhaseThree()
			elseif self.Phase == 3 then
				self.PhaseFour()
			end
		end
	end
	return false
end

function LG:Reset()
	self.EncounterRunning = false
	self.Greenscale.Available = false
	self.Greenscale.UnitID = nil
	self.Greenscale.CastBar:Remove()
	self.Greenscale.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function LG:Timer()	
end

function LG.Greenscale:SetTimers(bool)	
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

function LG.Greenscale:SetAlerts(bool)
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

function LG:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Greenscale, self.Enabled)
end

function LG:Start()
	-- Create Timers
	self.Greenscale.TimersRef.Blight = KBM.MechTimer:Add(self.Lang.Ability.Blight[KBM.Lang], 25)
	self.Greenscale.TimersRef.Fumes = KBM.MechTimer:Add(self.Lang.Ability.Fumes[KBM.Lang], 26)
	KBM.Defaults.TimerObj.Assign(self.Greenscale)

	-- Create Alerts
	self.Greenscale.AlertsRef.Blight = KBM.Alert:Create(self.Lang.Ability.Blight[KBM.Lang], nil, false, true, "red")
	self.Greenscale.AlertsRef.FumesWarn = KBM.Alert:Create(self.Lang.Ability.Fumes[KBM.Lang], nil, true, true, "purple")
	self.Greenscale.AlertsRef.Fumes = KBM.Alert:Create(self.Lang.Ability.Fumes[KBM.Lang], 3, false, true, "purple")
	self.Greenscale.AlertsRef.Fumes:NoMenu()
	self.Greenscale.AlertsRef.FumesWarn:AlertEnd(self.Greenscale.AlertsRef.Fumes)
	self.Greenscale.AlertsRef.Death = KBM.Alert:Create(self.Lang.Mechanic.Death[KBM.Lang], 3, true, true, "dark_green")
	KBM.Defaults.AlertObj.Assign(self.Greenscale)
	
	-- Assign Timers and Alerts to Triggers
	self.Greenscale.Triggers.Blight = KBM.Trigger:Create(self.Lang.Ability.Blight[KBM.Lang], "cast", self.Greenscale)
	self.Greenscale.Triggers.Blight:AddTimer(self.Greenscale.TimersRef.Blight)
	self.Greenscale.Triggers.Blight:AddAlert(self.Greenscale.AlertsRef.Blight)
	self.Greenscale.Triggers.Fumes = KBM.Trigger:Create(self.Lang.Ability.Fumes[KBM.Lang], "cast", self.Greenscale)
	self.Greenscale.Triggers.Fumes:AddTimer(self.Greenscale.TimersRef.Fumes)
	self.Greenscale.Triggers.Fumes:AddAlert(self.Greenscale.AlertsRef.FumesWarn)
	self.Greenscale.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Greenscale)
	self.Greenscale.Triggers.PhaseTwo:AddPhase(self.AirPhase)
	self.Greenscale.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Greenscale)
	self.Greenscale.Triggers.PhaseThree:AddPhase(self.AirPhase)
	self.Greenscale.Triggers.PhaseFour = KBM.Trigger:Create(25, "percent", self.Greenscale)
	self.Greenscale.Triggers.PhaseFour:AddPhase(self.AirPhase)
	
	self.Greenscale.CastBar = KBM.CastBar:Add(self, self.Greenscale)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end