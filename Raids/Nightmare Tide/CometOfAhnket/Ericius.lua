-- Duke Hericius Boss Mod for King Boss Mods
-- Written by Elinare
-- Copyright 2016
--

KBMNTHER_Settings = nil
cCOABMNTHER_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local COA = KBM.BossMod["RCometOfAhnket"]

local HER = {
	Directory = COA.Directory,
	File = "Hericius.lua",
	Enabled = true,
	HasPhases = true,
	-- Phase = 1,
	-- TankSwap = true,
	Instance = COA.Name,
	InstanceObj = COA,
	Lang = {},
	Enrage = 60 * 7,
	ID = "Hericius",
	Object = "HER",
}

HER.Her = {
	Mod = HER,
	Menu = {},
	Level = "??",
	Active = false,
	Name = "Hericius",
	UTID = "U38F5DBB84ADCD4AF",
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = true,
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
		TimersRef = {
			Enabled = true,
			FirstMush = KBM.Defaults.TimerObj.Create("pink"),
			BurstHeal = KBM.Defaults.TimerObj.Create("cyan"),
			AddPop = KBM.Defaults.TimerObj.Create("yellow"),
		},
		Filters = {
			Enabled = true,
			Siphon = KBM.Defaults.CastFilter.Create("purple"),
			Chlorolance = KBM.Defaults.CastFilter.Create("yellow"),
			Mush1 = KBM.Defaults.CastFilter.Create("dark_green"),
			Mush2 = KBM.Defaults.CastFilter.Create("red"),
			Mush3 = KBM.Defaults.CastFilter.Create("cyan"),
		},
		AlertsRef = {
			Enabled = true,
			Siphon = KBM.Defaults.AlertObj.Create("purple"),
			SiphonWarn = KBM.Defaults.AlertObj.Create("purple"),
			Chlorolance = KBM.Defaults.AlertObj.Create("yellow"),
			ChlorolanceWarn = KBM.Defaults.AlertObj.Create("yellow"),
			Mush1 = KBM.Defaults.AlertObj.Create("dark_green"),
			Mush1Warn = KBM.Defaults.AlertObj.Create("dark_green"),
			Mush2 = KBM.Defaults.AlertObj.Create("red"),
			Mush2Warn = KBM.Defaults.AlertObj.Create("red"),
			Mush3 = KBM.Defaults.AlertObj.Create("cyan"),
			Mush3Warn = KBM.Defaults.AlertObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
		},
	}
}

KBM.RegisterMod("Hericius", HER)

-- Main Unit Dictionary
HER.Lang.Unit = {}
HER.Lang.Unit.Hericius = KBM.Language:Add(HER.Her.Name)
HER.Lang.Unit.Hericius:SetGerman("Hericius")
HER.Lang.Unit.Hericius:SetFrench("Hericius")
HER.Lang.Unit.Hericius:SetRussian("??????????")
HER.Lang.Unit.Hericius:SetKorean("????")
HER.Her.Name = HER.Lang.Unit.Hericius[KBM.Lang]
HER.Descript = HER.Lang.Unit.Hericius[KBM.Lang]

-- Ability Dictionary
HER.Lang.Ability = {}
HER.Lang.Ability.Siphon = KBM.Language:Add("Cleansing Siphon")
HER.Lang.Ability.Siphon:SetFrench("Siphon purificateur")
HER.Lang.Ability.Siphon:SetGerman("Cleansing Siphon")
HER.Lang.Ability.Siphon:SetRussian("????????? ????")
HER.Lang.Ability.Siphon:SetKorean("?? ??")
HER.Lang.Ability.Chlorolance = KBM.Language:Add("Chlorolance")
HER.Lang.Ability.Chlorolance:SetFrench("Chlorolance")
HER.Lang.Ability.Chlorolance:SetGerman("Chlorolance")
HER.Lang.Ability.Chlorolance:SetRussian("???????? ????")
HER.Lang.Ability.Chlorolance:SetKorean("??? ??")
HER.Lang.Ability.Mush1 = KBM.Language:Add("Caustic Spores")
HER.Lang.Ability.Mush1:SetFrench("Spores caustiques")
HER.Lang.Ability.Mush1:SetGerman("Caustic Spores")
HER.Lang.Ability.Mush1:SetRussian("???????? ????")
HER.Lang.Ability.Mush1:SetKorean("??? ??")
HER.Lang.Ability.Mush2 = KBM.Language:Add("Incendiary Spores")
HER.Lang.Ability.Mush2:SetFrench("Spores incendiaires")
HER.Lang.Ability.Mush2:SetGerman("Incendiary Spores")
HER.Lang.Ability.Mush2:SetRussian("???????? ????")
HER.Lang.Ability.Mush2:SetKorean("??? ??")
HER.Lang.Ability.Mush3 = KBM.Language:Add("Acidic Spores")
HER.Lang.Ability.Mush3:SetFrench("Spores acidiques")
HER.Lang.Ability.Mush3:SetGerman("Acidic Spores")
HER.Lang.Ability.Mush3:SetRussian("???????? ????")
HER.Lang.Ability.Mush3:SetKorean("??? ??")


-- Verbose Dictionary
HER.Lang.Verbose = {}
HER.Lang.Verbose.Siphon = KBM.Language:Add("Intercept!")
HER.Lang.Verbose.Siphon:SetFrench("Interceptez!")
HER.Lang.Verbose.Siphon:SetGerman("Intercept!")
HER.Lang.Verbose.Siphon:SetRussian("Intercept!")
HER.Lang.Verbose.Siphon:SetKorean("Intercept!")
HER.Lang.Verbose.Chlorolance = KBM.Language:Add("Intercept!")
HER.Lang.Verbose.Chlorolance:SetFrench("Interceptez!")
HER.Lang.Verbose.Chlorolance:SetGerman("Intercept!")
HER.Lang.Verbose.Chlorolance:SetRussian("Intercept!")
HER.Lang.Verbose.Chlorolance:SetKorean("Intercept!")
HER.Lang.Verbose.Mush1 = KBM.Language:Add("Go left!")
HER.Lang.Verbose.Mush1:SetFrench("A gauche!")
HER.Lang.Verbose.Mush1:SetGerman("Go left!")
HER.Lang.Verbose.Mush1:SetRussian("Go left!")
HER.Lang.Verbose.Mush1:SetKorean("Go left!")
HER.Lang.Verbose.Mush2 = KBM.Language:Add("Go straight!")
HER.Lang.Verbose.Mush2:SetFrench("En face!")
HER.Lang.Verbose.Mush2:SetGerman("Go straight!")
HER.Lang.Verbose.Mush2:SetRussian("Go straight!")
HER.Lang.Verbose.Mush2:SetKorean("Go straight!")
HER.Lang.Verbose.Mush3 = KBM.Language:Add("Go right!")
HER.Lang.Verbose.Mush3:SetFrench("A droite!")
HER.Lang.Verbose.Mush3:SetGerman("Go right!")
HER.Lang.Verbose.Mush3:SetRussian("Go right!")
HER.Lang.Verbose.Mush3:SetKorean("Go right!")
HER.Lang.Verbose.FirstMush = KBM.Language:Add("Mushrooms Stage")
HER.Lang.Verbose.FirstMush:SetGerman("Mushrooms Stage")
HER.Lang.Verbose.FirstMush:SetFrench("Mushrooms Stage")
HER.Lang.Verbose.FirstMush:SetFrench("Phase des champignons")
HER.Lang.Verbose.FirstMush:SetRussian("Mushrooms Stage")
HER.Lang.Verbose.FirstMush:SetKorean("Mushrooms Stage")
HER.Lang.Verbose.BurstHeal = KBM.Language:Add("Burst Heal")
HER.Lang.Verbose.BurstHeal:SetGerman("Burst Heal")
HER.Lang.Verbose.BurstHeal:SetFrench("Burst Heal")
HER.Lang.Verbose.BurstHeal:SetFrench("Burst Heal")
HER.Lang.Verbose.BurstHeal:SetRussian("Burst Heal")
HER.Lang.Verbose.BurstHeal:SetKorean("Burst Heal")
HER.Lang.Verbose.AddPop = KBM.Language:Add("Add Pop")
HER.Lang.Verbose.AddPop:SetGerman("Add Pop")
HER.Lang.Verbose.AddPop:SetFrench("Add Pop")
HER.Lang.Verbose.AddPop:SetFrench("Add Pop")
HER.Lang.Verbose.AddPop:SetRussian("Add Pop")
HER.Lang.Verbose.AddPop:SetKorean("Add Pop")

HER.Lang.Menu = {}
HER.Lang.Menu.FirstMush = KBM.Language:Add("First mushroom")
HER.Lang.Menu.FirstMush:SetGerman("First mushroom")
HER.Lang.Menu.FirstMush:SetFrench("Premier champignon")
HER.Lang.Menu.FirstMush:SetRussian("First mushroom")
HER.Lang.Menu.FirstMush:SetKorean("First mushroom")
HER.Lang.Menu.BurstHeal = KBM.Language:Add("Burst Heal")
HER.Lang.Menu.BurstHeal:SetGerman("Burst Heal")
HER.Lang.Menu.BurstHeal:SetFrench("Burst Heal")
HER.Lang.Menu.BurstHeal:SetRussian("Burst Heal")
HER.Lang.Menu.BurstHeal:SetKorean("Burst Heal")
HER.Lang.Menu.AddPop = KBM.Language:Add("Add Pop")
HER.Lang.Menu.AddPop:SetGerman("Add Pop")
HER.Lang.Menu.AddPop:SetFrench("Add Pop")
HER.Lang.Menu.AddPop:SetRussian("Add Pop")
HER.Lang.Menu.AddPop:SetKorean("Add Pop")

-- Debuff Dictionary
HER.Lang.Debuff = {}

function HER:AddBosses(KBM_Boss)
	self.MenuName = self.Her.Name
	self.Bosses = {
		[self.Her.Name] = self.Her
	}
end

function HER:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		CastBar = HER.Her.Settings.CastBar,
		MechTimer = KBM.Defaults.MechTimer(),
		TimersRef = HER.Her.Settings.TimersRef,
		AlertsRef = HER.Her.Settings.AlertsRef,
		Alerts = KBM.Defaults.Alerts(),
		CastFilters = HER.Her.Settings.Filters,
		MechSpy = KBM.Defaults.MechSpy(),
		MechRef = HER.Her.Settings.MechRef,
	}
	KBMNTHER_Settings = self.Settings
	cCOABMNTHER_Settings = self.Settings	
end

function HER:SwapSettings(bool)
	if bool then
		KBMNTRDHER_Settings = self.Settings
		self.Settings = chKBMNTRDHER_Settings
	else
		chKBMNTRDHER_Settings = self.Settings
		self.Settings = KBMNTRDHER_Settings
	end
end

function HER:LoadVars()		
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDHER_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDHER_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRDHER_Settings = self.Settings
	else
		KBMNTRDHER_Settings = self.Settings
	end	
	
	self.Her.CastFilters[self.Lang.Ability.Siphon[KBM.Lang]] = {ID = "Siphon"}
	self.Her.CastFilters[self.Lang.Ability.Mush2[KBM.Lang]] = {ID = "Mush2"}
	self.Her.CastFilters[self.Lang.Ability.Chlorolance[KBM.Lang]] = {ID = "Chlorolance"}
	self.Her.CastFilters[self.Lang.Ability.Mush3[KBM.Lang]] = {ID = "Mush3"}
	self.Her.CastFilters[self.Lang.Ability.Mush1[KBM.Lang]] = {ID = "Mush1"}
	KBM.Defaults.CastFilter.Assign(self.Her)
	
end

function HER:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRDHER_Settings = self.Settings
	else
		KBMNTRDHER_Settings = self.Settings
	end	
end

function HER:Castbar()
end

function HER:RemoveUnits(UnitID)
	if self.Her.UnitID == UnitID then
		self.Her.Available = false
		return true
	end
	return false	
end

function HER:Death(UnitID)
	if self.Her.UnitID == UnitID then
		self.Her.Dead = true
		return true
	end
	return false	
end


function HER:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Her.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Her.Dead = false
					self.Her.Casting = false
					self.Her.CastBar:Create(unitID)
					KBM.MechTimer:AddStart(self.Her.TimersRef.FirstMush)
					KBM.MechTimer:AddStart(self.Her.TimersRef.BurstHeal)
					KBM.MechTimer:AddStart(self.Her.TimersRef.AddPop)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
					self.PhaseObj.Objectives:AddPercent(self.Her, 85, 100)
				end
				self.Her.Casting = false
				self.Her.UnitID = unitID
				self.Her.Available = true
				return self.Her
			end
		end
	end
end

function HER:Reset()
	self.EncounterRunning = false
	self.Her.UnitID = nil
	self.Her.Dead = false
	self.Her.Available = false
	self.Her.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())	
end

function HER:Timer()	
end



function HER:Start()	
	-- Create Timers
	self.Her.TimersRef.FirstMush = KBM.MechTimer:Add(self.Lang.Verbose.FirstMush[KBM.Lang], 21)
	self.Her.TimersRef.FirstMush.MenuName = self.Lang.Menu.FirstMush[KBM.Lang]
	self.Her.TimersRef.BurstHeal = KBM.MechTimer:Add(self.Lang.Verbose.BurstHeal[KBM.Lang], 76)
	self.Her.TimersRef.BurstHeal.MenuName = self.Lang.Menu.BurstHeal[KBM.Lang]
	self.Her.TimersRef.AddPop = KBM.MechTimer:Add(self.Lang.Verbose.AddPop[KBM.Lang], 88)
	self.Her.TimersRef.AddPop.MenuName = self.Lang.Menu.AddPop[KBM.Lang]
	KBM.Defaults.TimerObj.Assign(self.Her)
	
	-- Create Alerts
	self.Her.AlertsRef.SiphonWarn = KBM.Alert:Create(self.Lang.Verbose.Siphon[KBM.Lang], nil, false, true, "purple")
	self.Her.AlertsRef.SiphonWarn.MenuName = self.Lang.Ability.Siphon[KBM.Lang]
	self.Her.AlertsRef.Siphon = KBM.Alert:Create(self.Lang.Ability.Siphon[KBM.Lang], nil, false, true, "purple")
	
	
	self.Her.AlertsRef.ChlorolanceWarn = KBM.Alert:Create(self.Lang.Verbose.Chlorolance[KBM.Lang], nil, false, true, "yellow")
	self.Her.AlertsRef.ChlorolanceWarn.MenuName = self.Lang.Ability.Chlorolance[KBM.Lang]
	self.Her.AlertsRef.Chlorolance = KBM.Alert:Create(self.Lang.Ability.Chlorolance[KBM.Lang], nil, false, true, "yellow")
	
	
	self.Her.AlertsRef.Mush1Warn = KBM.Alert:Create(self.Lang.Verbose.Mush1[KBM.Lang], nil, false, true, "dark_green")
	self.Her.AlertsRef.Mush1Warn.MenuName = self.Lang.Ability.Mush1[KBM.Lang]
	self.Her.AlertsRef.Mush1 = KBM.Alert:Create(self.Lang.Verbose.Mush1[KBM.Lang], nil, false, true, "dark_green")
	
	
	self.Her.AlertsRef.Mush2Warn = KBM.Alert:Create(self.Lang.Verbose.Mush2[KBM.Lang], nil, false, true, "red")
	self.Her.AlertsRef.Mush2Warn.MenuName = self.Lang.Ability.Mush2[KBM.Lang]
	self.Her.AlertsRef.Mush2 = KBM.Alert:Create(self.Lang.Verbose.Mush2[KBM.Lang], nil, false, true, "red")
	
	
	self.Her.AlertsRef.Mush3Warn = KBM.Alert:Create(self.Lang.Verbose.Mush3[KBM.Lang], nil, false, true, "cyan")
	self.Her.AlertsRef.Mush3Warn.MenuName = self.Lang.Ability.Mush3[KBM.Lang]
	self.Her.AlertsRef.Mush3 = KBM.Alert:Create(self.Lang.Verbose.Mush3[KBM.Lang], nil, false, true, "cyan")
	
	KBM.Defaults.AlertObj.Assign(self.Her)
	
	-- Create Spy
	
	KBM.Defaults.MechObj.Assign(self.Her)
	
	self.Her.Triggers.SiphonWarn = KBM.Trigger:Create(self.Lang.Ability.Siphon[KBM.Lang], "cast", self.Her)
	self.Her.Triggers.SiphonWarn:AddAlert(self.Her.AlertsRef.SiphonWarn)
	self.Her.Triggers.Siphon = KBM.Trigger:Create(self.Lang.Ability.Siphon[KBM.Lang], "cast", self.Her)
	self.Her.Triggers.Siphon:AddAlert(self.Her.AlertsRef.Siphon)
	
	self.Her.Triggers.ChlorolanceWarn = KBM.Trigger:Create(self.Lang.Ability.Chlorolance[KBM.Lang], "cast", self.Her)
	self.Her.Triggers.ChlorolanceWarn:AddAlert(self.Her.AlertsRef.ChlorolanceWarn)
	self.Her.Triggers.Chlorolance = KBM.Trigger:Create(self.Lang.Ability.Chlorolance[KBM.Lang], "cast", self.Her)
	self.Her.Triggers.Chlorolance:AddAlert(self.Her.AlertsRef.Chlorolance)
	
	self.Her.Triggers.Mush3Warn = KBM.Trigger:Create(self.Lang.Ability.Mush3[KBM.Lang], "cast", self.Her)
	self.Her.Triggers.Mush3Warn:AddAlert(self.Her.AlertsRef.Mush3Warn)
	self.Her.Triggers.Mush3 = KBM.Trigger:Create(self.Lang.Ability.Mush3[KBM.Lang], "channel", self.Her)
	self.Her.Triggers.Mush3:AddAlert(self.Her.AlertsRef.Mush3)
	
	self.Her.Triggers.Mush2Warn = KBM.Trigger:Create(self.Lang.Ability.Mush2[KBM.Lang], "cast", self.Her)
	self.Her.Triggers.Mush2Warn:AddAlert(self.Her.AlertsRef.Mush2Warn)
	self.Her.Triggers.Mush2 = KBM.Trigger:Create(self.Lang.Ability.Mush2[KBM.Lang], "channel", self.Her)
	self.Her.Triggers.Mush2:AddAlert(self.Her.AlertsRef.Mush2)
	
	self.Her.Triggers.Mush1Warn = KBM.Trigger:Create(self.Lang.Ability.Mush1[KBM.Lang], "cast", self.Her)
	self.Her.Triggers.Mush1Warn:AddAlert(self.Her.AlertsRef.Mush1Warn)
	self.Her.Triggers.Mush1 = KBM.Trigger:Create(self.Lang.Ability.Mush1[KBM.Lang], "channel", self.Her)
	self.Her.Triggers.Mush1:AddAlert(self.Her.AlertsRef.Mush1)
	
	
	-- Assign Castbar object.
	self.Her.CastBar = KBM.Castbar:Add(self, self.Her)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end