-- Beruhast Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPBT_Settings = nil
chKBMROTPBT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROTP = KBM.BossMod["Rise of the Phoenix"]

local BT = {
	Enabled = true,
	Instance = ROTP.Name,
	HasPhases = false,
	Lang = {},
	ID = "Beruhast",
	Menu = {},
	Enrage = 60 * 8,
}

BT.Beruhast = {
	Mod = BT,
	Level = "??",
	Menu = {},
	Active = false,
	Name = "Beruhast",
	Castbar = nil,
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
			FlameStart = KBM.Defaults.TimerObj.Create("orange"),
			Flame = KBM.Defaults.TimerObj.Create("orange"),
			Summon = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Inferno = KBM.Defaults.TimerObj.Create("yellow"),
		},
	},
}

KBM.RegisterMod(BT.ID, BT)

BT.Lang.Beruhast = KBM.Language:Add(BT.Beruhast.Name)

-- Ability Dictionary
BT.Lang.Ability = {}
BT.Lang.Ability.Inferno = KBM.Language:Add("Inferno Lash")
BT.Lang.Ability.Inferno.French = "Fouet des limbes"
BT.Lang.Ability.Inferno.German = "Infernopeitsche"
BT.Lang.Ability.Flame = KBM.Language:Add("Leaping Flame")
BT.Lang.Ability.Flame.French = "Flamme bondissante"
BT.Lang.Ability.Flame.German = "Springende Flamme"
BT.Lang.Ability.Vortex = KBM.Language:Add("Flaming Vortex")
BT.Lang.Ability.Vortex.French = "Embrasement"
BT.Lang.Ability.Vortex.German = "Flammenwirbel"

-- Unit Dictionary
BT.Lang.Unit = {}
BT.Lang.Unit.Summon = KBM.Language:Add("Summoned Flame")
BT.Lang.Unit.Summon.German = "Beschworene Flamme"

-- Notify Dictionary
BT.Lang.Notify = {}
BT.Lang.Notify.Summon = KBM.Language:Add('Beruhast says, "A pet from Maelforge should keep you warm."')
BT.Lang.Notify.Summon.German = 'Beruhast sagt: "Ein Begleiter von Flammenmaul sollte Euch warmhalten."'

BT.Beruhast.Name = BT.Lang.Beruhast[KBM.Lang]

function BT:AddBosses(KBM_Boss)
	self.Beruhast.Descript = self.Beruhast.Name
	self.MenuName = self.Beruhast.Descript
	self.Bosses = {
		[self.Beruhast.Name] = self.Beruhast,
	}
	KBM_Boss[self.Beruhast.Name] = self.Beruhast	
end

function BT:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Beruhast.Settings.CastBar,
		MechTimer = KBM.Defaults.MechTimer(),
		EncTimer = KBM.Defaults.EncTimer(),
		AlertsRef = self.Beruhast.Settings.AlertsRef,
		TimersRef = self.Beruhast.Settings.TimersRef,
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMROTPBT_Settings = self.Settings
	chKBMROTPBT_Settings = self.Settings
end

function BT:SwapSettings(bool)
	if bool then
		KBMROTPBT_Settings = self.Settings
		self.Settings = chKBMROTPBT_Settings
	else
		chKBMROTPBT_Settings = self.Settings
		self.Settings = KBMROTPBT_Settings
	end
end

function BT:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROTPBT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROTPBT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMROTPBT_Settings = self.Settings
	else
		KBMROTPBT_Settings = self.Settings
	end
end

function BT:SaveVars()
	if KBM.Options.Character then
		chKBMROTPBT_Settings = self.Settings
	else
		KBMROTPBT_Settings = self.Settings
	end
end

function BT:Castbar(units)
end

function BT:RemoveUnits(UnitID)
	if self.Beruhast.UnitID == UnitID then
		self.Beruhast.Available = false
		return true
	end
	return false
end

function BT:Death(UnitID)
	if self.Beruhast.UnitID == UnitID then
		self.Beruhast.Dead = true
		return true
	end
	return false
end

function BT:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Beruhast.Name then
				if not self.Beruhast.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Beruhast.Casting = false
					self.Beruhast.CastBar:Create(unitID)
					self.Beruhast.TimersRef.FlameStart:Start(Inspect.Time.Real())
				end
				self.Beruhast.UnitID = unitID
				self.Beruhast.Available = true
				return self.Beruhast
			end
		end
	end
end

function BT:Reset()
	self.EncounterRunning = false
	self.Beruhast.Available = false
	self.Beruhast.UnitID = nil
	self.Beruhast.CastBar:Remove()
	self.Beruhast.Dead = false
end

function BT:Timer()
end

function BT.Beruhast:SetTimers(bool)	
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

function BT.Beruhast:SetAlerts(bool)
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

function BT:DefineMenu()
	self.Menu = ROTP.Menu:CreateEncounter(self.Beruhast, self.Enabled)
end

function BT:Start()
	-- Alerts
	self.Beruhast.AlertsRef.Inferno = KBM.Alert:Create(self.Lang.Ability.Inferno[KBM.Lang], 2, true, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Beruhast)
	
	-- Timers
	self.Beruhast.TimersRef.Flame = KBM.MechTimer:Add(self.Lang.Ability.Flame[KBM.Lang], 70)
	self.Beruhast.TimersRef.FlameStart = KBM.MechTimer:Add(self.Lang.Ability.Flame[KBM.Lang], 30)
	self.Beruhast.TimersRef.FlameStart.MenuName = self.Lang.Ability.Flame[KBM.Lang].." (Until First)"
	self.Beruhast.TimersRef.Summon = KBM.MechTimer:Add(self.Lang.Unit.Summon[KBM.Lang], 70)
	KBM.Defaults.TimerObj.Assign(self.Beruhast)
	
	-- Assign Mechanics to Triggers
	self.Beruhast.Triggers.Inferno = KBM.Trigger:Create(self.Lang.Ability.Inferno[KBM.Lang], "cast", self.Beruhast)
	self.Beruhast.Triggers.Inferno:AddAlert(self.Beruhast.AlertsRef.Inferno)
	self.Beruhast.Triggers.Flame = KBM.Trigger:Create(self.Lang.Ability.Flame[KBM.Lang], "cast", self.Beruhast)
	self.Beruhast.Triggers.Flame:AddTimer(self.Beruhast.TimersRef.Flame)
	self.Beruhast.Triggers.Summon = KBM.Trigger:Create(self.Lang.Notify.Summon[KBM.Lang], "notify", self.Beruhast)
	self.Beruhast.Triggers.Summon:AddTimer(self.Beruhast.TimersRef.Summon)
	
	self.Beruhast.CastBar = KBM.CastBar:Add(self, self.Beruhast, true)
	self:DefineMenu()
end