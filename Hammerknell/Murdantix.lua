-- Murdantix Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMX_Settings = nil
chKBMMX_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local MX = {
	Directory = HK.Directory,
	File = "Murdantix.lua",
	Enabled = true,
	Instance = HK.Name,
	Phase = 1,
	HasPhases = true,
	Lang = {},
	TankSwap = true,
	Enrage = 60 * 10,
	ID = "Murdantix",
	HasChronicle = true,
	ChroniclePOver = 90,
	Object = "MX",
}

MX.Murd = {
	Mod = MX,
	Menu = {},
	Level = "??",
	Active = false,
	Name = "Murdantix",
	ChronicleID = "U6B8A9FEF19F94B1F",
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = true,
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		Filters = {
			Enabled = true,
			Trauma = KBM.Defaults.CastFilter.Create("yellow"),
			Blast = KBM.Defaults.CastFilter.Create("red"),
		},
		TimersRef = {
			Enabled = true,
			Crush = KBM.Defaults.TimerObj.Create("purple"),
			Pound = KBM.Defaults.TimerObj.Create("blue"),
			Blast = KBM.Defaults.TimerObj.Create("red"),
			Trauma = KBM.Defaults.TimerObj.Create("yellow"),
		},
		AlertsRef = {
			Enabled = true,
			Trauma = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

KBM.RegisterMod("Murdantix", MX)

-- Main Unit Dictionary
MX.Lang.Unit = {}
MX.Lang.Unit.Murdantix = KBM.Language:Add(MX.Murd.Name)
MX.Lang.Unit.Murdantix:SetGerman("Murdantix")
MX.Lang.Unit.Murdantix:SetFrench("Murdantix")
MX.Lang.Unit.Murdantix:SetRussian("Мурдантикс")
MX.Murd.Name = MX.Lang.Unit.Murdantix[KBM.Lang]
MX.Descript = MX.Lang.Unit.Murdantix[KBM.Lang]

-- Ability Dictionary
MX.Lang.Ability = {}
MX.Lang.Ability.Crush = KBM.Language:Add("Mangling Crush")
MX.Lang.Ability.Crush:SetFrench("Essorage")
MX.Lang.Ability.Crush:SetGerman("Erdrückender Stoss")
MX.Lang.Ability.Crush:SetRussian("Калечащий удар")
MX.Lang.Ability.Pound = KBM.Language:Add("Ferocious Pound")
MX.Lang.Ability.Pound:SetFrench("Poids féroce")
MX.Lang.Ability.Pound:SetGerman("Wildes Zuschlagen")
MX.Lang.Ability.Pound:SetRussian("Свирепый удар")
MX.Lang.Ability.Blast = KBM.Language:Add("Demonic Blast")
MX.Lang.Ability.Blast:SetFrench("Explosion démoniaque")
MX.Lang.Ability.Blast:SetGerman("Dämonische Explosion")
MX.Lang.Ability.Blast:SetRussian("Демонический Взрыв")
MX.Lang.Ability.Trauma = KBM.Language:Add("Soul Trauma")
MX.Lang.Ability.Trauma:SetFrench("Traumatisme d'âme")
MX.Lang.Ability.Trauma:SetGerman("Seelentrauma")
MX.Lang.Ability.Trauma:SetRussian("Травма души")

-- Debuff Dictionary
MX.Lang.Debuff = {}
MX.Lang.Debuff.Mangled = KBM.Language:Add("Mangled")
MX.Lang.Debuff.Mangled:SetGerman("Üble Blessur")
MX.Lang.Debuff.Mangled:SetFrench("Estropié")
MX.Lang.Debuff.Mangled:SetRussian("Искалечен")

function MX:AddBosses(KBM_Boss)
	self.MenuName = self.Murd.Name
	KBM_Boss[self.Murd.Name] = self.Murd
	self.Bosses = {
		[self.Murd.Name] = self.Murd
	}
end

function MX:InitVars()
	self.Settings = {
		Enabled = true,
		Chronicle = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		CastBar = MX.Murd.Settings.CastBar,
		MechTimer = KBM.Defaults.MechTimer(),
		TimersRef = MX.Murd.Settings.TimersRef,
		AlertsRef = MX.Murd.Settings.AlertsRef,
		Alerts = KBM.Defaults.Alerts(),
		CastFilters = MX.Murd.Settings.Filters,
	}
	KBMMX_Settings = self.Settings
	chKBMMX_Settings = self.Settings	
end

function MX:SwapSettings(bool)
	if bool then
		KBMMX_Settings = self.Settings
		self.Settings = chKBMMX_Settings
	else
		chKBMMX_Settings = self.Settings
		self.Settings = KBMMX_Settings
	end
end

function MX:LoadVars()		
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMX_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMX_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMMX_Settings = self.Settings
	else
		KBMMX_Settings = self.Settings
	end
	
	self.Murd.CastFilters[self.Lang.Ability.Trauma[KBM.Lang]] = {ID = "Trauma"}
	self.Murd.CastFilters[self.Lang.Ability.Blast[KBM.Lang]] = {ID = "Blast"}
	KBM.Defaults.CastFilter.Assign(self.Murd)
	
end

function MX:SaveVars()	
	if KBM.Options.Character then
		chKBMMX_Settings = self.Settings
	else
		KBMMX_Settings = self.Settings
	end	
end

function MX:Castbar()
end

function MX:RemoveUnits(UnitID)
	if self.Murd.UnitID == UnitID then
		self.Murd.Available = false
		return true
	end
	return false	
end

function MX:Death(UnitID)
	if self.Murd.UnitID == UnitID then
		self.Murd.Dead = true
		return true
	end
	return false	
end

function MX.PhaseTwo()
	MX.PhaseObj.Objectives:Remove()
	MX.Phase = 2
	MX.PhaseObj:SetPhase(2)
	MX.PhaseObj.Objectives:AddPercent(MX.Murd.Name, 50, 75)	
end

function MX.PhaseThree()
	MX.PhaseObj.Objectives:Remove()
	MX.Phase = 3
	MX.PhaseObj:SetPhase(3)
	MX.PhaseObj.Objectives:AddPercent(MX.Murd.Name, 25, 50)	
end

function MX.PhaseFour()
	MX.PhaseObj.Objectives:Remove()
	MX.Phase = 4
	MX.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	MX.PhaseObj.Objectives:AddPercent(MX.Murd.Name, 0, 25)	
end

function MX:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Murd.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Phase = 1
					self.Murd.Dead = false
					self.Murd.CastBar:Create(unitID)
					KBM.TankSwap:Start(self.Lang.Debuff.Mangled[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Murd.Name, 75, 100)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
				end
				self.Murd.Casting = false
				self.Murd.UnitID = unitID
				self.Murd.Available = true
				return self.Murd
			end
		end
	end
end

function MX:Reset()
	self.EncounterRunning = false
	self.Murd.UnitID = nil
	self.Murd.Dead = false
	self.Murd.Available = false
	self.Murd.CastBar:Remove()
	self.Phase = 1
	self.PhaseObj:End(Inspect.Time.Real())	
end

function MX:Timer()	
end

function MX.Murd:SetTimers(bool)	
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

function MX.Murd:SetAlerts(bool)
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

function MX:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Murd, self.Enabled)
end

MX.Custom = {}
MX.Custom.Encounter = {}
function MX.Custom.Encounter.Menu(Menu)

	local Callbacks = {}

	function Callbacks:Chronicle(bool)
		MX.Settings.Chronicle = bool
	end

	Header = Menu:CreateHeader(KBM.Language.Encounter.Chronicle[KBM.Lang], "check", "Encounter", "Main")
	Header:SetChecked(MX.Settings.Chronicle)
	Header:SetHook(Callbacks.Chronicle)
	
end

function MX:Start()	
	-- Create Timers
	self.Murd.TimersRef.Crush = KBM.MechTimer:Add(self.Lang.Ability.Crush[KBM.Lang], 12)
	self.Murd.TimersRef.Pound = KBM.MechTimer:Add(self.Lang.Ability.Pound[KBM.Lang], 35)
	self.Murd.TimersRef.Blast = KBM.MechTimer:Add(self.Lang.Ability.Blast[KBM.Lang], 16)
	self.Murd.TimersRef.Trauma = KBM.MechTimer:Add(self.Lang.Ability.Trauma[KBM.Lang], 9)
	KBM.Defaults.TimerObj.Assign(self.Murd)
	
	-- Create Alerts
	self.Murd.AlertsRef.Trauma = KBM.Alert:Create(self.Lang.Ability.Trauma[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Murd)
	
	-- Assign Mechanics to Triggers
	self.Murd.Triggers.Crush = KBM.Trigger:Create(self.Lang.Ability.Crush[KBM.Lang], "damage", self.Murd)
	self.Murd.Triggers.Crush:AddTimer(self.Murd.TimersRef.Crush)
	self.Murd.Triggers.Pound = KBM.Trigger:Create(self.Lang.Ability.Pound[KBM.Lang], "damage", self.Murd)
	self.Murd.Triggers.Pound:AddTimer(self.Murd.TimersRef.Pound)
	self.Murd.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "cast", self.Murd)
	self.Murd.Triggers.Blast:AddTimer(self.Murd.TimersRef.Blast)
	self.Murd.Triggers.Trauma = KBM.Trigger:Create(self.Lang.Ability.Trauma[KBM.Lang], "cast", self.Murd)
	self.Murd.Triggers.Trauma:AddTimer(self.Murd.TimersRef.Trauma)
	self.Murd.Triggers.Trauma:AddAlert(self.Murd.AlertsRef.Trauma)
	self.Murd.Triggers.TraumaInt = KBM.Trigger:Create(self.Lang.Ability.Trauma[KBM.Lang], "interrupt", self.Murd)
	self.Murd.Triggers.TraumaInt:AddStop(self.Murd.AlertsRef.Trauma)
	self.Murd.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Murd)
	self.Murd.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Murd.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Murd)
	self.Murd.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Murd.Triggers.PhaseFour = KBM.Trigger:Create(25, "percent", self.Murd)
	self.Murd.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	-- Assign Castbar object.
	self.Murd.CastBar = KBM.CastBar:Add(self, self.Murd)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end