-- Matron Zamira Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMZ_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local MZ = {
	Directory = HK.Directory,
	File = "Matron.lua",
	Enabled = true,
	Instance = HK.Name,
	HasPhases = true,
	PhaseObj = nil,
	Timers = {},
	Lang = {},
	ID = "Matron",
}

MZ.Matron = {
	Mod = MZ,
	Level = "??",
	Active = false,
	Name = "Matron Zamira",
	NameShort = "Zamira",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Concussion = KBM.Defaults.TimerObj.Create(),
			Mark = KBM.Defaults.TimerObj.Create(),
			Shadow = KBM.Defaults.TimerObj.Create(),
			Blast = KBM.Defaults.TimerObj.Create(),
			Ichor = KBM.Defaults.TimerObj.Create(),
			Adds = KBM.Defaults.TimerObj.Create(),
			Spiritual = KBM.Defaults.TimerObj.Create(),
		},
		AlertsRef = {
			Enabled = true,
			Concussion = KBM.Defaults.AlertObj.Create("red"),
			Blast = KBM.Defaults.AlertObj.Create("yellow"),
			Mark = KBM.Defaults.AlertObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(MZ.ID, MZ)

MZ.Lang.Matron = KBM.Language:Add(MZ.Matron.Name)
MZ.Lang.Matron.German = "Matrone Zamira"
MZ.Lang.Matron.French = "Matrone Zamira"

-- Ability Dictionary
MZ.Lang.Ability = {}
MZ.Lang.Ability.Concussion = KBM.Language:Add("Dark Concussion")
MZ.Lang.Ability.Concussion.German = "Dunkle Erschütterung"
MZ.Lang.Ability.Concussion.French = "Concussion sombre"
MZ.Lang.Ability.Blast = KBM.Language:Add("Hideous Blast")
MZ.Lang.Ability.Blast.German = "Schrecklicher Schlag"
MZ.Lang.Ability.Blast.French = "Explosion atroce"
MZ.Lang.Ability.Mark = KBM.Language:Add("Mark of Oblivion")
MZ.Lang.Ability.Mark.German = "Zeichen der Vergessenheit"
MZ.Lang.Ability.Mark.French = "Marque de l'oubli"
MZ.Lang.Ability.Shadow = KBM.Language:Add("Shadow Strike")
MZ.Lang.Ability.Shadow.German = "Schattenschlag"
MZ.Lang.Ability.Ichor = KBM.Language:Add("Revolting Ichor")
MZ.Lang.Ability.Ichor.German = "Abscheulicher Eiter"

-- Debuff Dictionary
MZ.Lang.Debuff = {}
MZ.Lang.Debuff.Curse = KBM.Language:Add("Matron's Curse")
MZ.Lang.Debuff.Curse.German = "Fluch der Matrone"
MZ.Lang.Debuff.Curse.French = "Mal\195\169diction de la matrone"
MZ.Lang.Debuff.Spiritual = KBM.Language:Add("Spiritual Exhaustion")
MZ.Lang.Debuff.Spiritual.German = "Spirituelle Erschöpfung"

-- Verbose Dictionary
MZ.Lang.Verbose = {}
MZ.Lang.Verbose.Adds = KBM.Language:Add("Adds spawn")
MZ.Lang.Verbose.Adds.German = "Adds spawnen"
MZ.Lang.Verbose.Spiritual = KBM.Language:Add(MZ.Lang.Debuff.Spiritual[KBM.Lang].." fades")
MZ.Lang.Verbose.Spiritual.German = MZ.Lang.Debuff.Spiritual[KBM.Lang].." ausgelaufen!"

MZ.Matron.Name = MZ.Lang.Matron[KBM.Lang]
MZ.Descript = MZ.Matron.Name

function MZ:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Matron.Name] = self.Matron,
	}
	KBM_Boss[self.Matron.Name] = self.Matron	
end

function MZ:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),		
		Alerts = KBM.Defaults.Alerts(),
		CastBar = self.Matron.Settings.CastBar,
		TimersRef = self.Matron.Settings.TimersRef,
		AlertsRef = self.Matron.Settings.AlertsRef,
	}
	KBMMZ_Settings = self.Settings
	chKBMMZ_Settings = self.Settings
	
end

function MZ:SwapSettings(bool)

	if bool then
		KBMMZ_Settings = self.Settings
		self.Settings = chKBMMZ_Settings
	else
		chKBMMZ_Settings = self.Settings
		self.Settings = KBMMZ_Settings
	end

end

function MZ:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMZ_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMMZ_Settings = self.Settings
	else
		KBMMZ_Settings = self.Settings
	end
	
end

function MZ:SaveVars()

	if KBM.Options.Character then
		chKBMMZ_Settings = self.Settings
	else
		KBMMZ_Settings = self.Settings
	end
	
end

function MZ:Castbar(units)
end

function MZ:RemoveUnits(UnitID)
	if self.Matron.UnitID == UnitID then
		self.Matron.Available = false
		return true
	end
	return false
end

function MZ:Death(UnitID)
	if self.Matron.UnitID == UnitID then
		self.Matron.Dead = true
		return true
	end
	return false
end

function MZ.PhaseTwo()	
	MZ.Phase = 2
	MZ.PhaseObj.Objectives:Remove()
	MZ.PhaseObj:SetPhase(2)
	MZ.PhaseObj.Objectives:AddPercent(MZ.Matron.Name, 30, 40)	
end

function MZ.PhaseThree()
	MZ.Phase = 3
	MZ.PhaseObj.Objectives:Remove()
	MZ.PhaseObj:SetPhase("Final")
	MZ.PhaseObj.Objectives:AddPercent(MZ.Matron.Name, 0, 30)	
end

function MZ:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Matron.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Matron.Dead = false
					self.Matron.Casting = false
					self.Matron.CastBar:Create(unitID)
					KBM.TankSwap:Start(MZ.Lang.Debuff.Curse[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Matron.Name, 40, 100)
					self.PhaseObj:Start(self.StartTime)
				end
				self.Matron.UnitID = unitID
				self.Matron.Available = true
				return self.Matron
			end
		end
	end
end

function MZ:Reset()
	self.EncounterRunning = false
	self.Matron.Available = false
	self.Matron.UnitID = nil
	self.Matron.CastBar:Remove()
	self.PhaseObj:End(self.TimeElapsed)	
end

function MZ:Timer()	
end

function MZ.Matron:SetTimers(bool)	
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

function MZ.Matron:SetAlerts(bool)
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

function MZ:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Matron, self.Enabled)
end

function MZ:Start()		
	-- Create Timers
	self.Matron.TimersRef.Concussion = KBM.MechTimer:Add(self.Lang.Ability.Concussion[KBM.Lang], 13)
	self.Matron.TimersRef.Mark = KBM.MechTimer:Add(self.Lang.Ability.Mark[KBM.Lang], 24)
	self.Matron.TimersRef.Shadow = KBM.MechTimer:Add(self.Lang.Ability.Shadow[KBM.Lang], 11)
	self.Matron.TimersRef.Blast = KBM.MechTimer:Add(self.Lang.Ability.Blast[KBM.Lang], 8)
	self.Matron.TimersRef.Ichor = KBM.MechTimer:Add(self.Lang.Ability.Ichor[KBM.Lang], 5)
	self.Matron.TimersRef.Adds = KBM.MechTimer:Add(self.Lang.Verbose.Adds[KBM.Lang], 10)
	self.Matron.TimersRef.Spiritual = KBM.MechTimer:Add(self.Lang.Verbose.Spiritual[KBM.Lang], 60)
	
	-- Create Alerts
	self.Matron.AlertsRef.Concussion = KBM.Alert:Create(self.Lang.Ability.Concussion[KBM.Lang], 2, true, false, "red")
	self.Matron.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], nil, false, true, "yellow")
	self.Matron.AlertsRef.Mark = KBM.Alert:Create(self.Lang.Ability.Mark[KBM.Lang], 5, false, true, "purple")

	KBM.Defaults.TimerObj.Assign(self.Matron)
	KBM.Defaults.AlertObj.Assign(self.Matron)
	
	-- Assign Mechanics to Triggers
	self.Matron.Triggers.Concussion = KBM.Trigger:Create(self.Lang.Ability.Concussion[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.Concussion:AddTimer(self.Matron.TimersRef.Concussion)
	self.Matron.Triggers.Concussion:AddAlert(self.Matron.AlertsRef.Concussion)
	self.Matron.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Blast:AddAlert(self.Matron.AlertsRef.Blast)
	self.Matron.Triggers.Blast:AddTimer(self.Matron.TimersRef.Blast)
	self.Matron.Triggers.BlastInt = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "interrupt", self.Matron)
	self.Matron.Triggers.BlastInt:AddStop(self.Matron.AlertsRef.Blast)
	self.Matron.Triggers.Ichor = KBM.Trigger:Create(self.Lang.Ability.Ichor[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Ichor:AddTimer(self.Matron.TimersRef.Ichor)
	self.Matron.Triggers.Mark = KBM.Trigger:Create(self.Lang.Ability.Mark[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Mark:AddTimer(self.Matron.TimersRef.Mark)
	self.Matron.Triggers.MarkDamage = KBM.Trigger:Create(self.Lang.Ability.Mark[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.MarkDamage:AddAlert(self.Matron.AlertsRef.Mark, true)
	self.Matron.AlertsRef.Mark:Important()
	self.Matron.Triggers.Shadow = KBM.Trigger:Create(self.Lang.Ability.Shadow[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.Shadow:AddTimer(self.Matron.TimersRef.Shadow)
	self.Matron.Triggers.PhaseTwo = KBM.Trigger:Create(40, "percent", self.Matron)
	self.Matron.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Matron.Triggers.PhaseThree = KBM.Trigger:Create(30, "percent", self.Matron)
	self.Matron.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Matron.Triggers.Spiritual = KBM.Trigger:Create(self.Lang.Debuff.Spiritual[KBM.Lang], "playerBuff", self.Matron)
	self.Matron.Triggers.Spiritual:AddTimer(self.Matron.TimersRef.Adds)
	self.Matron.Triggers.Spiritual:AddTimer(self.Matron.TimersRef.Spiritual)
	
	-- Assign Castbar object
	self.Matron.CastBar = KBM.CastBar:Add(self, self.Matron, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()		
end