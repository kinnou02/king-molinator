-- Prince Hylas Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBPH_Settings = nil
chKBMGSBPH_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GSB = KBM.BossMod["Greenscales Blight"]

local PH = {
	Enabled = true,
	Directory = GSB.Directory,
	File = "Hylas.lua",
	Instance = GSB.Name,
	HasPhases = true,
	Lang = {},
	ID = "Hylas",
	HasChronicle = true,
	Object = "PH",
}

PH.Hylas = {
	Mod = PH,
	Level = "52",
	Active = false,
	Name = "Prince Hylas",
	NameShort = "Hylas",
	ChronicleID = "U48BA191868D74700",
	Menu = {},
	Castbar = nil,
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
			Duke = KBM.Defaults.TimerObj.Create("dark_green"),
			Johlen = KBM.Defaults.TimerObj.Create("dark_green"),
			Aleria = KBM.Defaults.TimerObj.Create("dark_green"),
			Wrath = KBM.Defaults.TimerObj.Create("red"),
			Soul = KBM.Defaults.TimerObj.Create("orange"),
			Cotton = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Duke = KBM.Defaults.AlertObj.Create("dark_green"),
			Johlen = KBM.Defaults.AlertObj.Create("dark_green"),
			Aleria = KBM.Defaults.AlertObj.Create("dark_green"),
			Wrath = KBM.Defaults.AlertObj.Create("red"),
			Soul = KBM.Defaults.AlertObj.Create("orange"),
			Cotton = KBM.Defaults.AlertObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(PH.ID, PH)

-- Main Unit Dictionary
PH.Lang.Unit = {}
PH.Lang.Unit.Hylas = KBM.Language:Add(PH.Hylas.Name)
PH.Lang.Unit.Hylas:SetGerman("Prinz Hylas")
PH.Lang.Unit.Hylas:SetFrench("Prince Hylas")
PH.Lang.Unit.Hylas:SetRussian("Принц Гилас")
-- Additional Unit Dictionary
PH.Lang.Unit.Duke = KBM.Language:Add("Duke Letareus")
PH.Lang.Unit.Duke:SetGerman("Herzog Letareus")
PH.Lang.Unit.Duke:SetFrench("Duc Letareus")
PH.Lang.Unit.Duke:SetRussian("Герцог Летареус")
PH.Lang.Unit.Johlen = KBM.Language:Add("Infiltrator Johlen")
PH.Lang.Unit.Johlen:SetGerman("Infiltrator Johlen")
PH.Lang.Unit.Johlen:SetFrench("Infiltrateur Johlen")
PH.Lang.Unit.Johlen:SetRussian("Лазутчик Джохлен")
PH.Lang.Unit.Aleria = KBM.Language:Add("Oracle Aleria")
PH.Lang.Unit.Aleria:SetGerman("Orakel Aleria")
PH.Lang.Unit.Aleria:SetFrench("Aleria l'Oracle")
PH.Lang.Unit.Aleria:SetRussian("Оракул Алерия")

-- Ability Dictionary
PH.Lang.Ability = {}
PH.Lang.Ability.Wrath = KBM.Language:Add("Prince's Wrath")
PH.Lang.Ability.Wrath:SetGerman("Zorn des Prinzen")
PH.Lang.Ability.Wrath:SetFrench("Courroux du Prince")
PH.Lang.Ability.Wrath:SetRussian("Гнев принца")
PH.Lang.Ability.Soul = KBM.Language:Add("Soul Fracture")
PH.Lang.Ability.Soul:SetGerman("Seelenfraktur")
PH.Lang.Ability.Soul:SetFrench("Fracture de l'âme")
PH.Lang.Ability.Soul:SetRussian("Распад души")
PH.Lang.Ability.Cotton = KBM.Language:Add("Contagious Cottontail")
PH.Lang.Ability.Cotton:SetGerman("Ansteckender Baumwollschweif")
PH.Lang.Ability.Cotton:SetFrench("Queue de coton contagieuse")
PH.Lang.Ability.Cotton:SetRussian("Заразный кролик")

-- Buff Dictionary
PH.Lang.Buff = {}
PH.Lang.Buff.Life = KBM.Language:Add("Invocation of Life")
PH.Lang.Buff.Life:SetGerman("Anrufung des Lebens")
PH.Lang.Buff.Life:SetFrench("Invocation de Vie")
PH.Lang.Buff.Life:SetRussian("Чары жизни")

-- Phase Monitor Dictionary
PH.Lang.Phase = {}
PH.Lang.Phase.Critters = KBM.Language:Add("Critters")
PH.Lang.Phase.Critters:SetGerman("Tiere")
PH.Lang.Phase.Critters:SetFrench("Apparitions")
PH.Lang.Phase.Critters:SetRussian("Зверушки")

-- Verbose Dictionary
PH.Lang.Verbose = {}
PH.Lang.Verbose.Reanimate = KBM.Language:Add(" is reanimated")
PH.Lang.Verbose.Reanimate:SetRussian(" оживает")
PH.Lang.Verbose.Reanimate:SetFrench(" est réanimé")
PH.Lang.Verbose.Reanimate:SetGerman(" ist auferstanden")

PH.Hylas.Name = PH.Lang.Unit.Hylas[KBM.Lang]
PH.Descript = PH.Hylas.Name

function PH:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Hylas.Name] = self.Hylas,
	}
	KBM_Boss[self.Hylas.Name] = self.Hylas
end

function PH:InitVars()
	self.Settings = {
		Enabled = true,
		Chronicle = true,
		CastBar = self.Hylas.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Hylas.Settings.TimersRef,
		AlertsRef = self.Hylas.Settings.AlertsRef,
	}
	KBMGSBPH_Settings = self.Settings
	chKBMGSBPH_Settings = self.Settings	
end

function PH:SwapSettings(bool)
	if bool then
		KBMGSBPH_Settings = self.Settings
		self.Settings = chKBMGSBPH_Settings
	else
		chKBMGSBPH_Settings = self.Settings
		self.Settings = KBMGSBPH_Settings
	end
end

function PH:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGSBPH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGSBPH_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGSBPH_Settings = self.Settings
	else
		KBMGSBPH_Settings = self.Settings
	end	
end

function PH:SaveVars()	
	if KBM.Options.Character then
		chKBMGSBPH_Settings = self.Settings
	else
		KBMGSBPH_Settings = self.Settings
	end	
end

function PH:Castbar(units)
end

function PH:RemoveUnits(UnitID)
	if self.Hylas.UnitID == UnitID then
		self.Hylas.Available = false
		return true
	end
	return false
end

function PH:Death(UnitID)
	if self.Hylas.UnitID == UnitID then
		self.Hylas.Dead = true
		return true
	end
	return false
end

function PH.PhaseOne()
	if PH.Phase == 1 then
		PH.PhaseObj.Objectives:AddPercent(PH.Lang.Unit.Duke[KBM.Lang], 0, 100)
	end
end

function PH.PhaseTwo()
	if PH.Phase < 2 then
		PH.PhaseObj.Objectives:AddPercent(PH.Lang.Unit.Johlen[KBM.Lang], 0, 100)
		PH.PhaseObj:SetPhase(2)
		PH.Phase = 2
	end
end

function PH.PhaseThree()
	if PH.Phase < 3 then
		PH.PhaseObj.Objectives:AddPercent(PH.Lang.Unit.Aleria[KBM.Lang], 0, 100)
		PH.PhaseObj:SetPhase(3)
		PH.Phase = 3
	end
end

function PH.PhaseFour()
	if PH.Phase < 4 then
		PH.PhaseObj.Objectives:Remove()
		PH.PhaseObj:SetPhase(PH.Lang.Phase.Critters[KBM.Lang])
		PH.Phase = 4
		KBM.MechTimer:AddRemove(PH.Hylas.TimersRef.Soul)
		KBM.MechTimer:AddRemove(PH.Hylas.TimersRef.Wrath)
		KBM.MechTimer:AddRemove(PH.Hylas.TimersRef.Cotton)
	end
end

function PH.PhaseFive()
	PH.PhaseObj.Objectives:Remove()
	PH.Phase = 5
	PH.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	PH.PhaseObj.Objectives:AddPercent(PH.Hylas.Name, 0, 50)
end

function PH:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Hylas.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Hylas.Dead = false
					self.Hylas.Casting = false
					self.Hylas.CastBar:Create(unitID)
					self.Phase = 1
					self.PhaseObj:SetPhase(1)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Hylas.Name, 11, 100)
					KBM.MechTimer:AddStart(self.Hylas.TimersRef.Duke)
				end
				self.Hylas.UnitID = unitID
				self.Hylas.Available = true
				return self.Hylas
			end
		end
	end
end

function PH:Reset()
	self.EncounterRunning = false
	self.Hylas.Available = false
	self.Hylas.UnitID = nil
	self.Hylas.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
	self.Phase = 1
end

function PH:Timer()	
end

function PH.Hylas:SetTimers(bool)	
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

function PH.Hylas:SetAlerts(bool)
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

function PH:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Hylas, self.Enabled)
end

PH.Custom = {}
PH.Custom.Encounter = {}
function PH.Custom.Encounter.Menu(Menu)

	local Callbacks = {}

	function Callbacks:Chronicle(bool)
		PH.Settings.Chronicle = bool
	end

	Header = Menu:CreateHeader(KBM.Language.Encounter.Chronicle[KBM.Lang], "check", "Encounter", "Main")
	Header:SetChecked(PH.Settings.Chronicle)
	Header:SetHook(Callbacks.Chronicle)
	
end

function PH:Start()	

	-- Create Timers
	self.Hylas.TimersRef.Duke = KBM.MechTimer:Add(self.Lang.Unit.Duke[KBM.Lang], 10)
	self.Hylas.TimersRef.Johlen = KBM.MechTimer:Add(self.Lang.Unit.Johlen[KBM.Lang], 35)
	self.Hylas.TimersRef.Aleria = KBM.MechTimer:Add(self.Lang.Unit.Aleria[KBM.Lang], 35)
	self.Hylas.TimersRef.Wrath = KBM.MechTimer:Add(self.Lang.Ability.Wrath[KBM.Lang], 26)
	self.Hylas.TimersRef.Soul = KBM.MechTimer:Add(self.Lang.Ability.Soul[KBM.Lang], 22)
	self.Hylas.TimersRef.Cotton = KBM.MechTimer:Add(self.Lang.Ability.Cotton[KBM.Lang], 25)
	KBM.Defaults.TimerObj.Assign(self.Hylas)
	
	-- Create Alerts
	self.Hylas.AlertsRef.Duke = KBM.Alert:Create(self.Lang.Unit.Duke[KBM.Lang]..self.Lang.Verbose.Reanimate[KBM.Lang], 2, true, false, "dark_green")
	self.Hylas.AlertsRef.Johlen = KBM.Alert:Create(self.Lang.Unit.Johlen[KBM.Lang]..self.Lang.Verbose.Reanimate[KBM.Lang], 2, true, false, "dark_green")
	self.Hylas.AlertsRef.Aleria = KBM.Alert:Create(self.Lang.Unit.Aleria[KBM.Lang]..self.Lang.Verbose.Reanimate[KBM.Lang], 2, true, false, "dark_green")
	self.Hylas.AlertsRef.Wrath = KBM.Alert:Create(self.Lang.Ability.Wrath[KBM.Lang], nil, true, true, "red")
	self.Hylas.AlertsRef.Soul = KBM.Alert:Create(self.Lang.Ability.Soul[KBM.Lang], 3, true, false, "orange")
	self.Hylas.AlertsRef.Cotton = KBM.Alert:Create(self.Lang.Ability.Cotton[KBM.Lang], 3, true, false, "purple")
	KBM.Defaults.AlertObj.Assign(self.Hylas)
	
	-- Assign Timers and Alerts to Triggers
	self.Hylas.Triggers.Duke = KBM.Trigger:Create(10, "time", self.Hylas)
	self.Hylas.Triggers.Duke:AddTimer(self.Hylas.TimersRef.Johlen)
	self.Hylas.Triggers.Duke:AddAlert(self.Hylas.AlertsRef.Duke)
	self.Hylas.Triggers.Duke:AddPhase(self.PhaseOne)
	self.Hylas.Triggers.Johlen = KBM.Trigger:Create(45, "time", self.Hylas)
	self.Hylas.Triggers.Johlen:AddTimer(self.Hylas.TimersRef.Aleria)
	self.Hylas.Triggers.Johlen:AddAlert(self.Hylas.AlertsRef.Johlen)
	self.Hylas.Triggers.Johlen:AddPhase(self.PhaseTwo)
	self.Hylas.Triggers.Aleria = KBM.Trigger:Create(80, "time", self.Hylas)
	self.Hylas.Triggers.Aleria:AddAlert(self.Hylas.AlertsRef.Aleria)
	self.Hylas.Triggers.Aleria:AddPhase(self.PhaseThree)
	self.Hylas.Triggers.Wrath = KBM.Trigger:Create(self.Lang.Ability.Wrath[KBM.Lang], "cast", self.Hylas)
	self.Hylas.Triggers.Wrath:AddTimer(self.Hylas.TimersRef.Wrath)
	self.Hylas.Triggers.Wrath:AddAlert(self.Hylas.AlertsRef.Wrath)
	self.Hylas.Triggers.Critter = KBM.Trigger:Create(11, "percent", self.Hylas)
	self.Hylas.Triggers.Critter:AddPhase(self.PhaseFour)
	self.Hylas.Triggers.Final = KBM.Trigger:Create(self.Lang.Buff.Life[KBM.Lang], "buffRemove", self.Hylas)
	self.Hylas.Triggers.Final:AddPhase(self.PhaseFive)
	self.Hylas.Triggers.Soul = KBM.Trigger:Create(self.Lang.Ability.Soul[KBM.Lang], "cast", self.Hylas)
	self.Hylas.Triggers.Soul:AddTimer(self.Hylas.TimersRef.Soul)
	self.Hylas.Triggers.Soul:AddAlert(self.Hylas.AlertsRef.Soul)
	self.Hylas.Triggers.Cotton = KBM.Trigger:Create(self.Lang.Ability.Cotton[KBM.Lang], "cast", self.Hylas)
	self.Hylas.Triggers.Cotton:AddTimer(self.Hylas.TimersRef.Cotton)
	self.Hylas.Triggers.Cotton:AddAlert(self.Hylas.AlertsRef.Cotton)
	
	self.Hylas.CastBar = KBM.CastBar:Add(self, self.Hylas)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end