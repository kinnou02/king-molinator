-- Lord Greenscale Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBLG_Settings = nil
chKBMGSBLG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local GSB = KBM.BossMod["Greenscales Blight"]

local LG = {
	Enabled = true,
	Directory = GSB.Directory,
	File = "Greenscale.lua",
	Instance = GSB.Name,
	HasPhases = true,
	Lang = {},
	Enrage = 60 * 14.5,	
	ID = "Greenscale",
	HasChronicle = true,
	Object = "LG",
}

LG.Greenscale = {
	Mod = LG,
	Level = "52",
	Active = false,
	Name = "Lord Greenscale",
	NameShort = "Greenscale",
	ChronicleID = "U1930C7F350FEC7B3",
	RaidID = "U633EAF7811771C3D",
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
			Blight = KBM.Defaults.TimerObj.Create("red"),
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

-- Main Unit Dictionary
LG.Lang.Unit = {}
LG.Lang.Unit.Greenscale = KBM.Language:Add(LG.Greenscale.Name)
LG.Lang.Unit.Greenscale:SetGerman("Fürst Grünschuppe")
LG.Lang.Unit.Greenscale:SetFrench("Seigneur Vert\195\169caille")
LG.Lang.Unit.Greenscale:SetRussian("Лорд Зеленокож")
LG.Lang.Unit.Greenscale:SetKorean("그린스케일 군주")
-- Unit Dictionary
LG.Lang.Unit.Verdant = KBM.Language:Add("Verdant Annihilator")
LG.Lang.Unit.Verdant:SetGerman("Grüner Auslöscher")
LG.Lang.Unit.Verdant:SetFrench("Annihilateur verdoyant")
LG.Lang.Unit.Verdant:SetRussian("Лиственный расщепитель")

-- Ability Dictionary
LG.Lang.Ability = {}
LG.Lang.Ability.Blight = KBM.Language:Add("Strangling Blight")
LG.Lang.Ability.Blight:SetGerman("Würgende Plage")
LG.Lang.Ability.Blight:SetFrench("Fléau étrangleur")
LG.Lang.Ability.Blight:SetRussian("Удушающая болезнь")
LG.Lang.Ability.Blight:SetKorean("목조르는 식물")
LG.Lang.Ability.Fumes = KBM.Language:Add("Noxious Fumes")
LG.Lang.Ability.Fumes:SetGerman("Giftige Dämpfe")
LG.Lang.Ability.Fumes:SetFrench("Émanations nocives")
LG.Lang.Ability.Fumes:SetRussian("Ядовитые пары")
LG.Lang.Ability.Fumes:SetKorean("유독 연기")

-- Mechanic Dictionary (Verbose)
LG.Lang.Mechanic = {}
LG.Lang.Mechanic.Death = KBM.Language:Add("Protective Shield")
LG.Lang.Mechanic.Death:SetGerman("Schutzschild")
LG.Lang.Mechanic.Death:SetFrench("Bouclier protecteur")
LG.Lang.Mechanic.Death:SetRussian("Защитный купол")

LG.Greenscale.Name = LG.Lang.Unit.Greenscale[KBM.Lang]
LG.Descript = LG.Greenscale.Name

LG.Verdant = {
	Mod = LG,
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
	RaidID = "U52347B1D400FD113",
}

function LG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
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
		Chronicle = true,
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
					self.LastPhase = 1
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

function LG.AirPhaseOne()
	if LG.Phase == 1 then
		LG.PhaseObj.Objectives:Remove()
		LG.PhaseObj:SetPhase(KBM.Language.Options.Air[KBM.Lang])
		LG.PhaseObj.Objectives:AddPercent(LG.Greenscale.Name, 50, 75)
		LG.PhaseObj.Objectives:AddPercent(LG.Verdant.Name, 0, 100)
	end
end

function LG.AirPhaseTwo()
	if LG.Phase == 2 then
		LG.PhaseObj.Objectives:Remove()
		LG.PhaseObj:SetPhase(KBM.Language.Options.Air[KBM.Lang])
		LG.PhaseObj.Objectives:AddPercent(LG.Greenscale.Name, 25, 50)
		LG.PhaseObj.Objectives:AddPercent(LG.Verdant.Name, 0, 100)
	end
end

function LG.AirPhaseThree()
	if LG.Phase == 3 then
		LG.PhaseObj.Objectives:Remove()
		LG.PhaseObj:SetPhase(KBM.Language.Options.Air[KBM.Lang])
		LG.PhaseObj.Objectives:AddPercent(LG.Greenscale.Name, 0, 25)
		LG.PhaseObj.Objectives:AddPercent(LG.Verdant.Name, 0, 100)
	end
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
	LG.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
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

LG.Custom = {}
LG.Custom.Encounter = {}
function LG.Custom.Encounter.Menu(Menu)

	local Callbacks = {}

	function Callbacks:Chronicle(bool)
		LG.Settings.Chronicle = bool
	end

	Header = Menu:CreateHeader(KBM.Language.Encounter.Chronicle[KBM.Lang], "check", "Encounter", "Main")
	Header:SetChecked(LG.Settings.Chronicle)
	Header:SetHook(Callbacks.Chronicle)
	
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
	self.Greenscale.Triggers.PhaseTwo:AddPhase(self.AirPhaseOne)
	self.Greenscale.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Greenscale)
	self.Greenscale.Triggers.PhaseThree:AddPhase(self.AirPhaseTwo)
	self.Greenscale.Triggers.PhaseFour = KBM.Trigger:Create(25, "percent", self.Greenscale)
	self.Greenscale.Triggers.PhaseFour:AddPhase(self.AirPhaseThree)
	
	self.Greenscale.CastBar = KBM.CastBar:Add(self, self.Greenscale)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end