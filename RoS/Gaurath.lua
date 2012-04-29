-- Herald Gaurath Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSHG_Settings = nil
chKBMROSHG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROS = KBM.BossMod["River of Souls"]

local HG = {
	Enabled = true,
	Directory = ROS.Directory,
	File = "Gaurath",
	Instance = ROS.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	RaiseCounter = 0,
	Enrage = 60 * 9.5,
	ID = "Herald_Gaurath",
	Object = "HG",
}

HG.Gaurath = {
	Mod = HG,
	Level = "??",
	Active = false,
	Name = "Herald Gaurath",
	NameShort = "Gaurath",
	Dead = false,
	Available = false,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Breath = KBM.Defaults.TimerObj.Create("purple"),
			Raise = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Breath = KBM.Defaults.AlertObj.Create("purple"),
			Raise = KBM.Defaults.AlertObj.Create("dark_green"),
			Tidings = KBM.Defaults.AlertObj.Create("orange"),
		},
		MechRef = {
			Enabled = true,
			Tidings = KBM.Defaults.MechObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(HG.ID, HG)

-- Main Unit Dictionary
HG.Lang.Unit = {}
HG.Lang.Unit.Gaurath = KBM.Language:Add(HG.Gaurath.Name)
HG.Lang.Unit.Gaurath:SetGerman("Herold Gaurath")
HG.Lang.Unit.Gaurath:SetFrench("Héraut Gaurath")
HG.Lang.Unit.Gaurath:SetRussian("Глашатай Гораф")
HG.Lang.Unit.Defiler = KBM.Language:Add("Ancient Defiler")
HG.Lang.Unit.Defiler:SetFrench("Profanateur ancien ")
HG.Lang.Unit.Defiler:SetGerman("Alter Schänder")

-- Ability Dictionary
HG.Lang.Ability = {}
HG.Lang.Ability.Breath = KBM.Language:Add("Breath of the Void")
HG.Lang.Ability.Breath:SetGerman("Odem der Leere")
HG.Lang.Ability.Breath:SetFrench("Souffle du Néant")
HG.Lang.Ability.Breath:SetRussian("Дыхание Пустоты")
HG.Lang.Ability.Raise = KBM.Language:Add("Raise the Dead")
HG.Lang.Ability.Raise:SetGerman("Erweckung der Toten")
HG.Lang.Ability.Raise:SetFrench("Résurrection des Morts")
HG.Lang.Ability.Raise:SetRussian("Поднять мертвых")
HG.Lang.Ability.Tidings = KBM.Language:Add("Tidings of Woe")
HG.Lang.Ability.Tidings:SetGerman("Leidvolle Kunde")
HG.Lang.Ability.Tidings:SetFrench("Nouvelles du Malheur")
HG.Lang.Ability.Tidings:SetRussian("Плохие известия")
HG.Lang.Ability.Storm = KBM.Language:Add("Defiling Storm")
HG.Lang.Ability.Storm:SetGerman("Schändender Sturm")
HG.Lang.Ability.Storm:SetFrench("Tempête profanatrice")

-- Verbose Dictionary
HG.Lang.Verbose = {}
HG.Lang.Verbose.Raise = KBM.Language:Add("Death group rise")
HG.Lang.Verbose.Raise:SetGerman("Erweckung der Toten")
HG.Lang.Verbose.Raise:SetFrench("Résurrection des Morts")
HG.Lang.Verbose.Raise:SetRussian("Призыв аддов")

-- Notify Dictionary
HG.Lang.Notify = {}
HG.Lang.Notify.Tidings = KBM.Language:Add("Herald Gaurath unleashes woeful tidings upon (%a*)")
HG.Lang.Notify.Tidings:SetFrench("Héraut Gaurath déchaîne son pouvoir sur (%a*)")
HG.Lang.Notify.Tidings:SetGerman("Herold Gaurath entfesselt traurige Kunde auf (%a*)")
HG.Lang.Notify.Tidings:SetRussian("Глашатай Гораф сообщает скорбные вести в надежде, что (%a*) придет в уныние.")

HG.Gaurath.Name = HG.Lang.Unit.Gaurath[KBM.Lang]
HG.Descript = HG.Gaurath.Name

HG.Defiler = {
	Mod = HG,
	Level = "??",
	Name = HG.Lang.Unit.Defiler[KBM.Lang],
	UnitList = {},
	Menu = {},
	AlertsRef = {},
	Ignore = true,
	Type = "multi",
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Storm = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

function HG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Gaurath.Name] = self.Gaurath,
		[self.Defiler.Name] = self.Defiler,
	}
	KBM_Boss[self.Gaurath.Name] = self.Gaurath	
	KBM.SubBoss[self.Defiler.Name] = self.Defiler
end

function HG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Gaurath.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Gaurath = {
			TimersRef = self.Gaurath.Settings.TimersRef,
			AlertsRef = self.Gaurath.Settings.AlertsRef,
			MechRef = self.Gaurath.Settings.MechRef,
		},
		Defiler = {
			AlertsRef = self.Defiler.Settings.AlertsRef,
		},
	}
	KBMROSHG_Settings = self.Settings
	chKBMROSHG_Settings = self.Settings
end

function HG:SwapSettings(bool)
	if bool then
		KBMROSHG_Settings = self.Settings
		self.Settings = chKBMROSHG_Settings
	else
		chKBMROSHG_Settings = self.Settings
		self.Settings = KBMROSHG_Settings
	end
end

function HG:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROSHG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROSHG_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMROSHG_Settings = self.Settings
	else
		KBMROSHG_Settings = self.Settings
	end	
end

function HG:SaveVars()
	if KBM.Options.Character then
		chKBMROSHG_Settings = self.Settings
	else
		KBMROSHG_Settings = self.Settings
	end	
end

function HG:Castbar(units)
end

function HG:RemoveUnits(UnitID)
	if self.Gaurath.UnitID == UnitID then
		self.Gaurath.Available = false
		return true
	end
	return false
end

function HG:Death(UnitID)
	if self.Gaurath.UnitID == UnitID then
		self.Gaurath.Dead = true
		return true
	elseif self.Defiler.UnitList[UnitID] then
		if self.Defiler.UnitList[UnitID].CastBar then
			self.Defiler.UnitList[UnitID].CastBar:Remove()
		end
		self.Defiler.UnitList[UnitID].Dead = true
		self.Defiler.UnitList[UnitID].CastBar = nil
	end
	return false
end

function HG.AirPhase()
	HG.PhaseObj:SetPhase(KBM.Language.Options.Air[KBM.Lang])
	HG.Phase = 2
	HG.RaiseCounter = 0
end

function HG.GroundPhase()
	HG.RaiseObj:Update(0)
	HG.PhaseObj:SetPhase(KBM.Language.Options.Ground[KBM.Lang])
	HG.Phase = 1
end

function HG.RaiseCount()
	HG.RaiseCounter = HG.RaiseCounter + 1
	if HG.RaiseCounter == 2 then
		HG.AirPhase()
	end
	HG.RaiseObj:Update(HG.RaiseCounter)
	KBM.MechTimer:AddRemove(HG.Gaurath.TimersRef.Breath)
end

function HG:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Gaurath.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Gaurath.Dead = false
					self.Gaurath.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Ground[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Gaurath.Name, 0, 100)
					self.RaiseObj = self.PhaseObj.Objectives:AddMeta(self.Lang.Ability.Raise[KBM.Lang], 2, 0)
					self.RaiseCounter = 0
				end
				self.Gaurath.Casting = false
				self.Gaurath.UnitID = unitID
				self.Gaurath.Available = true
				return self.Gaurath
			elseif self.EncounterRunning then
				if self.Bosses[uDetails.name] then
					if not self.Bosses[uDetails.name].UnitList[unitID] then
						SubBossObj = {
							Mod = HG,
							Level = "??",
							Name = uDetails.name,
							Dead = false,
							Casting = false,
							UnitID = unitID,
							Available = true,
						}
						self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
						if uDetails.name == self.Defiler.Name then
							SubBossObj.CastBar = KBM.CastBar:Add(self, self.Defiler, false, true)
							SubBossObj.CastBar:Create(unitID)
						end
					else
						self.Bosses[uDetails.name].UnitList[unitID].Available = true
						self.Bosses[uDetails.name].UnitList[unitID].UnitID = unitID
					end
					return self.Bosses[uDetails.name].UnitList[unitID]
				end
			end
		end
	end
end

function HG:Reset()
	self.EncounterRunning = false
	self.Gaurath.Available = false
	self.Gaurath.UnitID = nil
	self.Gaurath.CastBar:Remove()
	self.Gaurath.Dead = false
	self.RaiseObj = nil
	self.RaiseCounter = 0
	for UnitID, BossObj in pairs(self.Defiler.UnitList) do
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
			BossObj.CastBar = nil
		end
	end	
	self.PhaseObj:End(Inspect.Time.Real())
end

function HG:Timer()	
end

function HG.Gaurath:SetTimers(bool)	
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

function HG.Gaurath:SetAlerts(bool)
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

function HG:DefineMenu()
	self.Menu = ROS.Menu:CreateEncounter(self.Gaurath, self.Enabled)
end

function HG:Start()	
	-- Create Timers
	self.Gaurath.TimersRef.Breath = KBM.MechTimer:Add(self.Lang.Ability.Breath[KBM.Lang], 26)
	self.Gaurath.TimersRef.Raise = KBM.MechTimer:Add(self.Lang.Verbose.Raise[KBM.Lang], 7)
	KBM.Defaults.TimerObj.Assign(self.Gaurath)
	
	-- Create Mechanic Spies
	self.Gaurath.MechRef.Tidings = KBM.MechSpy:Add(self.Lang.Ability.Tidings[KBM.Lang], 8, "mechanic", self.Gaurath)
	KBM.Defaults.MechObj.Assign(self.Gaurath)
	
	-- Create Alerts
	-- Herald
	self.Gaurath.AlertsRef.Breath = KBM.Alert:Create(self.Lang.Ability.Breath[KBM.Lang], nil, false, true, "purple")
	self.Gaurath.AlertsRef.Raise = KBM.Alert:Create(self.Lang.Ability.Raise[KBM.Lang], nil, true, true, "dark_green")
	self.Gaurath.AlertsRef.Raise:TimerEnd(self.Gaurath.TimersRef.Raise)
	self.Gaurath.AlertsRef.Tidings = KBM.Alert:Create(self.Lang.Ability.Tidings[KBM.Lang], 8, false, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Gaurath)
	-- Ancient Defiler
	self.Defiler.AlertsRef.Storm = KBM.Alert:Create(self.Lang.Ability.Storm[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Defiler)

	-- Assign Timers and Alerts to Triggers
	self.Gaurath.Triggers.Breath = KBM.Trigger:Create(self.Lang.Ability.Breath[KBM.Lang], "cast", self.Gaurath)
	self.Gaurath.Triggers.Breath:AddTimer(self.Gaurath.TimersRef.Breath)
	self.Gaurath.Triggers.Breath:AddAlert(self.Gaurath.AlertsRef.Breath)
	self.Gaurath.Triggers.Raise = KBM.Trigger:Create(self.Lang.Ability.Raise[KBM.Lang], "cast", self.Gaurath)
	self.Gaurath.Triggers.Raise:AddAlert(self.Gaurath.AlertsRef.Raise)
	self.Gaurath.Triggers.Raise:AddPhase(self.RaiseCount)
	self.Gaurath.Triggers.TidingsCast = KBM.Trigger:Create(self.Lang.Ability.Tidings[KBM.Lang], "cast", self.Gaurath)
	self.Gaurath.Triggers.TidingsCast:AddAlert(self.Gaurath.AlertsRef.Tidings)
	self.Gaurath.Triggers.TidingsCast:AddPhase(self.GroundPhase)
	self.Gaurath.Triggers.Tidings = KBM.Trigger:Create(self.Lang.Notify.Tidings[KBM.Lang], "notify", self.Gaurath)
	self.Gaurath.Triggers.Tidings:AddSpy(self.Gaurath.MechRef.Tidings)
	self.Defiler.Triggers.Storm = KBM.Trigger:Create(self.Lang.Ability.Storm[KBM.Lang], "personalCast", self.Defiler)
	self.Defiler.Triggers.Storm:AddAlert(self.Defiler.AlertsRef.Storm, true)
	self.Defiler.Triggers.StormInt = KBM.Trigger:Create(self.Lang.Ability.Storm[KBM.Lang], "personalInterrupt", self.Defiler)
	self.Defiler.Triggers.StormInt:AddStop(self.Defiler.AlertsRef.Storm)
	
	self.Gaurath.CastBar = KBM.CastBar:Add(self, self.Gaurath)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end