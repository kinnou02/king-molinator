-- Estrode Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMES_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local ES = {
	Enabled = true,
	Estrode = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = HK.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Lang = {},
	Enrage = 60 * 12,
	ID = "Estrode",
}

ES.Estrode = {
	Mod = ES,
	Level = "??",
	Active = false,
	Name = "Estrode",
	CastBar = nil,
	CastFilters = {},
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
			Soul = KBM.Defaults.TimerObj.Create(),
			Mind = KBM.Defaults.TimerObj.Create(),
			North = KBM.Defaults.TimerObj.Create(),
		},
		AlertsRef = {
			Enabled = true,
			Dancing = KBM.Defaults.AlertObj.Create("red", false),
			DancingWarn = KBM.Defaults.AlertObj.Create("red"),
			North = KBM.Defaults.AlertObj.Create("orange"),
			Chastise = KBM.Defaults.AlertObj.Create("yellow"),
			Rift = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(ES.ID, ES)

ES.Lang.Estrode = KBM.Language:Add(ES.Estrode.Name)

-- Ability Dictionary
ES.Lang.Ability = {}
ES.Lang.Ability.Soul = KBM.Language:Add("Soul Capture")
ES.Lang.Ability.Soul.German = "Seelenfang"
ES.Lang.Ability.Mind = KBM.Language:Add("Mind Control")
ES.Lang.Ability.Mind.German = "Gedankenkontrolle"
ES.Lang.Ability.Dancing = KBM.Language:Add("Dancing Steel")
ES.Lang.Ability.Dancing.German = "Tanzender Stahl"
ES.Lang.Ability.North = KBM.Language:Add("Rage of the North")
ES.Lang.Ability.North.German = "Wut des Nordens"
ES.Lang.Ability.Chastise = KBM.Language:Add("Chastise")
ES.Lang.Ability.Chastise.German = "Züchtigung"
ES.Lang.Ability.Rift = KBM.Language:Add("Mistress of the Rift")

-- Speak Dictionary
ES.Lang.Say = {}
ES.Lang.Say.Mind = KBM.Language:Add("Mmmm, you look delectable.")
ES.Lang.Say.Mind.German = "Hm, Ihr seht köstlich aus."

ES.Estrode.Name = ES.Lang.Estrode[KBM.Lang]

function ES:AddBosses(KBM_Boss)
	self.Estrode.Descript = self.Estrode.Name
	self.MenuName = self.Estrode.Descript
	self.Bosses = {
		[self.Estrode.Name] = self.Estrode,
	}
	KBM_Boss[self.Estrode.Name] = self.Estrode	
end

function ES:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),		
		Alerts = KBM.Defaults.Alerts(),
		CastBar = self.Estrode.Settings.CastBar,
		TimersRef = self.Estrode.Settings.TimersRef,
		AlertsRef = self.Estrode.Settings.AlertsRef,
	}
	KBMES_Settings = self.Settings
	chKBMES_Settings = self.Settings	
end

function ES:SwapSettings(bool)
	if bool then
		KBMES_Settings = self.Settings
		self.Settings = chKBMES_Settings
	else
		chKBMES_Settings = self.Settings
		self.Settings = KBMES_Settings
	end
end

function ES:LoadVars()
	local TargetLoad = nil	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMES_Settings, self.Settings)
	else
		KBM.LoadTable(KBMES_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMES_Settings = self.Settings
	else
		KBMES_Settings = self.Settings
	end	
end

function ES:SaveVars()
	if KBM.Options.Character then
		chKBMES_Settings = self.Settings
	else
		KBMES_Settings = self.Settings
	end	
end

function ES:Castbar(units)
end

function ES:RemoveUnits(UnitID)
	if self.Estrode.UnitID == UnitID then
		self.Estrode.Available = false
		return true
	end
	return false
end

function ES:Death(UnitID)
	if self.Estrode.UnitID == UnitID then
		self.Estrode.Dead = true
		return true
	end
	return false
end

function ES:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Estrode.Name then
				if not self.Estrode.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Estrode.Dead = false
					self.Estrode.Casting = false
					self.Estrode.CastBar:Create(unitID)
				end
				self.Estrode.UnitID = unitID
				self.Estrode.Available = true
				return self.Estrode
			end
		end
	end
end

function ES:Reset()
	self.EncounterRunning = false
	self.Estrode.Available = false
	self.Estrode.UnitID = nil
	self.Estrode.CastBar:Remove()	
end

function ES:Timer()
	
end

function ES.Estrode:SetTimers(bool)	
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

function ES.Estrode:SetAlerts(bool)
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

function ES:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Estrode, self.Enabled)
end

function ES:Start()	
	-- Create Timers
	self.Estrode.TimersRef.Soul = KBM.MechTimer:Add(self.Lang.Ability.Soul[KBM.Lang], 40)
	self.Estrode.TimersRef.Mind = KBM.MechTimer:Add(self.Lang.Ability.Mind[KBM.Lang], 60)
	self.Estrode.TimersRef.North = KBM.MechTimer:Add(self.Lang.Ability.North[KBM.Lang], 8)
	
	-- Screen Alerts
	self.Estrode.AlertsRef.DancingWarn = KBM.Alert:Create(self.Lang.Ability.Dancing[KBM.Lang], nil, false, true, "red")
	self.Estrode.AlertsRef.Dancing = KBM.Alert:Create(self.Lang.Ability.Dancing[KBM.Lang], 6, true, true, "red")
	self.Estrode.AlertsRef.North = KBM.Alert:Create(self.Lang.Ability.North[KBM.Lang], nil, true, true, "orange")
	self.Estrode.AlertsRef.Chastise = KBM.Alert:Create(self.Lang.Ability.Chastise[KBM.Lang], nil, true, true, "yellow")
	self.Estrode.AlertsRef.Rift = KBM.Alert:Create(self.Lang.Ability.Rift[KBM.Lang], 2, true, true, "orange")
	
	KBM.Defaults.TimerObj.Assign(self.Estrode)
	KBM.Defaults.AlertObj.Assign(self.Estrode)
	
	-- Assign Mechanics to Triggers
	self.Estrode.Triggers.Soul = KBM.Trigger:Create(self.Lang.Ability.Soul[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.Soul:AddTimer(self.Estrode.TimersRef.Soul)
	self.Estrode.Triggers.Soul:AddStop(self.Estrode.TimersRef.North)
	self.Estrode.Triggers.Mind = KBM.Trigger:Create(self.Lang.Say.Mind[KBM.Lang], "say", self.Estrode)
	self.Estrode.Triggers.Mind:AddTimer(self.Estrode.TimersRef.Mind)
	self.Estrode.Triggers.Dancing = KBM.Trigger:Create(self.Lang.Ability.Dancing[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.Dancing:AddAlert(self.Estrode.AlertsRef.DancingWarn)
	self.Estrode.AlertsRef.DancingWarn:AlertEnd(self.Estrode.AlertsRef.Dancing)	
	self.Estrode.Triggers.North = KBM.Trigger:Create(self.Lang.Ability.North[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.North:AddAlert(self.Estrode.AlertsRef.North)
	self.Estrode.Triggers.North:AddTimer(self.Estrode.TimersRef.North)
	self.Estrode.Triggers.Chastise = KBM.Trigger:Create(self.Lang.Ability.Chastise[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.Chastise:AddAlert(self.Estrode.AlertsRef.Chastise)
	self.Estrode.Triggers.Rift = KBM.Trigger:Create(self.Lang.Ability.Rift[KBM.Lang], "buff", self.Estrode)
	self.Estrode.Triggers.Rift:AddAlert(self.Estrode.AlertsRef.Rift)
	
	self.Estrode.CastBar = KBM.CastBar:Add(self, self.Estrode, true)
	self:DefineMenu()	
end