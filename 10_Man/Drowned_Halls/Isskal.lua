-- Isskal Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHIL_Settings = nil
chKBMDHIL_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local DH = KBM.BossMod["Drowned Halls"]

local IL = {
	Enabled = true,
	Instance = DH.Name,
	Lang = {},
	ID = "Isskal",
	}

IL.Isskal = {
	Mod = IL,
	Level = "??",
	Active = false,
	Name = "Isskal",
	Menu = {},
	Dead = false,
	Available = false,
	AlertsRef = {},
	TimersRef = {},
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Shard = KBM.Defaults.AlertObj.Create("yellow"),
			Whirlpool = KBM.Defaults.AlertObj.Create("blue"),
		},
		TimersRef = {
			Enabled = true,
			WhirlpoolFirst = KBM.Defaults.TimerObj.Create("blue"),
			Whirlpool = KBM.Defaults.TimerObj.Create("blue"),
			Anti = KBM.Defaults.TimerObj.Create("blue"),
			Clock = KBM.Defaults.TimerObj.Create("blue"),
			Wave = KBM.Defaults.TimerObj.Create("red"),
		},
	},
}

KBM.RegisterMod(IL.ID, IL)

IL.Lang.Isskal = KBM.Language:Add(IL.Isskal.Name)

-- Ability Dictionary
IL.Lang.Ability = {}
IL.Lang.Ability.Shard = KBM.Language:Add("Ice Shard")
IL.Lang.Ability.Shard.German = "Eissplitter"
IL.Lang.Ability.Wave = KBM.Language:Add("Glacial Wave")
IL.Lang.Ability.Wave.German = "Gletscherwelle"

-- Mechanic Dictionary
IL.Lang.Mechanic = {}
IL.Lang.Mechanic.Whirlpool = KBM.Language:Add("Whirlpool")
IL.Lang.Mechanic.Anti = KBM.Language:Add("Anti-Clockwise")
IL.Lang.Mechanic.Anti.German = "Gegen Uhrzeigersinn"
IL.Lang.Mechanic.Clock = KBM.Language:Add("Clockwise")
IL.Lang.Mechanic.Clock.German = "Im Uhrzeigersinn"

-- Mechanic Notify
IL.Lang.Notify = {}
IL.Lang.Notify.Whirlpool = KBM.Language:Add("Go with the current - or die!")
IL.Lang.Notify.Whirlpool.German = "Folgt dem Strom, oder sterbt!"
IL.Lang.Notify.Clock = KBM.Language:Add("You're going the wrong way, fools!")
IL.Lang.Notify.Clock.German = "Ihr Narren geht in die falsche Richtung!"

-- Menu Dictionary
IL.Lang.Menu = {}
IL.Lang.Menu.WhirlpoolFirst = KBM.Language:Add("First "..IL.Lang.Mechanic.Whirlpool[KBM.Lang])
IL.Lang.Menu.WhirlpoolFirst.German = "Erste "..IL.Lang.Mechanic.Whirlpool[KBM.Lang]

IL.Isskal.Name = IL.Lang.Isskal[KBM.Lang]

function IL:AddBosses(KBM_Boss)
	self.Isskal.Descript = self.Isskal.Name
	self.MenuName = self.Isskal.Descript
	self.Bosses = {
		[self.Isskal.Name] = self.Isskal,
	}
	KBM_Boss[self.Isskal.Name] = self.Isskal	
end

function IL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Isskal.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alert = KBM.Defaults.Alerts(),
		AlertsRef = self.Isskal.Settings.AlertsRef,
		TimersRef = self.Isskal.Settings.TimersRef,
	}
	KBMDHIL_Settings = self.Settings
	chKBMDHIL_Settings = self.Settings
end

function IL:SwapSettings(bool)

	if bool then
		KBMDHIL_Settings = self.Settings
		self.Settings = chKBMDHIL_Settings
	else
		chKBMDHIL_Settings = self.Settings
		self.Settings = KBMDHIL_Settings
	end

end

function IL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMDHIL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMDHIL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMDHIL_Settings = self.Settings
	else
		KBMDHIL_Settings = self.Settings
	end	
end

function IL:SaveVars()	
	if KBM.Options.Character then
		chKBMDHIL_Settings = self.Settings
	else
		KBMDHIL_Settings = self.Settings
	end	
end

function IL:Castbar(units)
end

function IL:RemoveUnits(UnitID)
	if self.Isskal.UnitID == UnitID then
		self.Isskal.Available = false
		return true
	end
	return false
end

function IL:Death(UnitID)
	if self.Isskal.UnitID == UnitID then
		self.Isskal.Dead = true
		return true
	end
	return false
end

function IL:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Isskal.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Isskal.Dead = false
					self.Isskal.Casting = false
					self.Isskal.CastBar:Create(unitID)
					KBM.MechTimer:AddStart(self.Isskal.TimersRef.WhirlpoolFirst)
				end
				self.Isskal.UnitID = unitID
				self.Isskal.Available = true
				return self.Isskal
			end
		end
	end
end

function IL:Reset()
	self.EncounterRunning = false
	self.Isskal.Available = false
	self.Isskal.UnitID = nil
	self.Isskal.Dead = false
	self.Isskal.CastBar:Remove()
end

function IL:Timer()
	
end

function IL.Isskal:SetTimers(bool)	
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

function IL.Isskal:SetAlerts(bool)
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

function IL:DefineMenu()
	self.Menu = DH.Menu:CreateEncounter(self.Isskal, self.Enabled)
end

function IL:Start()
	-- Create Timers
	self.Isskal.TimersRef.WhirlpoolFirst = KBM.MechTimer:Add(self.Lang.Mechanic.Whirlpool[KBM.Lang], 32)
	self.Isskal.TimersRef.WhirlpoolFirst.MenuName = self.Lang.Menu.WhirlpoolFirst[KBM.Lang]
	self.Isskal.TimersRef.Whirlpool = KBM.MechTimer:Add(self.Lang.Mechanic.Whirlpool[KBM.Lang], 62)
	self.Isskal.TimersRef.Anti = KBM.MechTimer:Add(self.Lang.Mechanic.Anti[KBM.Lang], 14)
	self.Isskal.TimersRef.Clock = KBM.MechTimer:Add(self.Lang.Mechanic.Clock[KBM.Lang], 14)
	self.Isskal.TimersRef.Wave = KBM.MechTimer:Add(self.Lang.Ability.Wave[KBM.Lang], 50)
	self.Isskal.TimersRef.Wave:AddTimer(self.Isskal.TimersRef.Whirlpool, 0)
	KBM.Defaults.TimerObj.Assign(self.Isskal)
	
	-- Create Alerts
	self.Isskal.AlertsRef.Shard = KBM.Alert:Create(self.Lang.Ability.Shard[KBM.Lang], nil, true, true, "yellow")
	self.Isskal.AlertsRef.Whirlpool = KBM.Alert:Create(self.Lang.Mechanic.Whirlpool[KBM.Lang], 2, true, false, "blue")
	KBM.Defaults.AlertObj.Assign(self.Isskal)

	-- Assign Timers and Alerts to triggers.
	self.Isskal.Triggers.Shard = KBM.Trigger:Create(self.Lang.Ability.Shard[KBM.Lang], "cast", self.Isskal)
	self.Isskal.Triggers.Shard:AddAlert(self.Isskal.AlertsRef.Shard)
	self.Isskal.Triggers.Whirlpool = KBM.Trigger:Create(self.Lang.Notify.Whirlpool[KBM.Lang], "notify", self.Isskal)
	self.Isskal.Triggers.Whirlpool:AddAlert(self.Isskal.AlertsRef.Whirlpool)
	self.Isskal.Triggers.Whirlpool:AddTimer(self.Isskal.TimersRef.Anti)
	self.Isskal.Triggers.Whirlpool:AddTimer(self.Isskal.TimersRef.Wave)
	self.Isskal.Triggers.Clock = KBM.Trigger:Create(self.Lang.Notify.Clock[KBM.Lang], "notify", self.Isskal)
	self.Isskal.Triggers.Clock:AddTimer(self.Isskal.TimersRef.Clock)
	
	self.Isskal.CastBar = KBM.CastBar:Add(self, self.Isskal, true)
	self:DefineMenu()
end