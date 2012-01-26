-- Guurloth Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGPGH_Settings = nil
chKBMGPGH_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GP = KBM.BossMod["Guilded Prophecy"]

local GH = {
	Enabled = true,
	Instance = GP.Name,
	Lang = {},
	ID = "Guurloth",
	}

GH.Guurloth = {
	Mod = GH,
	Level = "??",
	Active = false,
	Name = "Guurloth",
	NameShort = "Guurloth",
	TimersRef = {},
	AlertsRef = {},
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			OrbFirst = KBM.Defaults.TimerObj.Create("orange"),
			Orb = KBM.Defaults.TimerObj.Create("orange"),
			CallFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			Call = KBM.Defaults.TimerObj.Create("purple"),
			Punish = KBM.Defaults.TimerObj.Create("red"),
			Geyser = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			OrbWarn = KBM.Defaults.AlertObj.Create("orange"),
			Orb = KBM.Defaults.AlertObj.Create("orange"),
			Rumbling = KBM.Defaults.AlertObj.Create("blue"),
			RumblingWarn = KBM.Defaults.AlertObj.Create("blue"),
			Call = KBM.Defaults.AlertObj.Create("purple"),
			Boulder = KBM.Defaults.AlertObj.Create("yellow"),
			Toil = KBM.Defaults.AlertObj.Create("dark_green"),
			ToilWarn = KBM.Defaults.AlertObj.Create("dark_green"),
			Punish = KBM.Defaults.AlertObj.Create("red"),
			Geyser = KBM.Defaults.AlertObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(GH.ID, GH)

GH.Lang.Guurloth = KBM.Language:Add(GH.Guurloth.Name)
GH.Guurloth.Name = GH.Lang.Guurloth[KBM.Lang]

-- Ability Dictionary
GH.Lang.Ability = {}
GH.Lang.Ability.Orb = KBM.Language:Add("Orb of Searing Power")
GH.Lang.Ability.Orb.German = "Kugel der sengenden Macht"
GH.Lang.Ability.Rumbling = KBM.Language:Add("Rumbling Earth")
GH.Lang.Ability.Rumbling.German = "Grollende Erde"
GH.Lang.Ability.Call = KBM.Language:Add("Guurloth's Call")
GH.Lang.Ability.Call.German = "Guurloths Ruf"
GH.Lang.Ability.Boulder = KBM.Language:Add("Boulder of Destruction")
GH.Lang.Ability.Boulder.German = "Fels der Zerstörung"
GH.Lang.Ability.Toil = KBM.Language:Add("Earthen Toil")
GH.Lang.Ability.Toil.German = "Irdene Mühe"
GH.Lang.Ability.Geyser = KBM.Language:Add("Earthen Geyser")
GH.Lang.Ability.Geyser.German = "Erdengeysir"

-- Debuff Dictionary
GH.Lang.Debuff = {}
GH.Lang.Debuff.Punish = KBM.Language:Add("Earthen Punishment")
GH.Lang.Debuff.Punish.German = "Erdenbestrafung"

-- Verbose Dictionary
GH.Lang.Verbose = {}
GH.Lang.Verbose.Orb = KBM.Language:Add("Look away now!")
GH.Lang.Verbose.Orb.German = "WEGSCHAUEN"
GH.Lang.Verbose.Rumbling = KBM.Language:Add("Jump!")
GH.Lang.Verbose.Rumbling.German = "SPRINGEN"
GH.Lang.Verbose.Call = KBM.Language:Add("Adds Spawn")
GH.Lang.Verbose.Call.German = "ADD kommt"
GH.Lang.Verbose.Toil = KBM.Language:Add("Run around!")
GH.Lang.Verbose.Toil.German = "LAUFEN"
GH.Lang.Verbose.Punish = KBM.Language:Add("Stop!")
GH.Lang.Verbose.Punish.German = "NICHTS MACHEN"

-- Menu Dictionary
GH.Lang.Menu = {}
GH.Lang.Menu.Orb = KBM.Language:Add("First "..GH.Lang.Ability.Orb[KBM.Lang])
GH.Lang.Menu.Orb.German = "Erste "..GH.Lang.Ability.Orb[KBM.Lang]
GH.Lang.Menu.OrbDuration = KBM.Language:Add(GH.Lang.Ability.Orb[KBM.Lang].." duration")
GH.Lang.Menu.OrbDuration.German = GH.Lang.Ability.Orb[KBM.Lang].." Dauer"
GH.Lang.Menu.Rumbling = KBM.Language:Add(GH.Lang.Ability.Rumbling[KBM.Lang].." duration")
GH.Lang.Menu.Rumbling.German = GH.Lang.Ability.Rumbling[KBM.Lang].." Dauer"
GH.Lang.Menu.CallFirst = KBM.Language:Add("First "..GH.Lang.Ability.Call[KBM.Lang])
GH.Lang.Menu.CallFirst.German = "Erster "..GH.Lang.Ability.Call[KBM.Lang]
GH.Lang.Menu.Toil = KBM.Language:Add(GH.Lang.Ability.Toil[KBM.Lang].." duration")
GH.Lang.Menu.Toil.German = GH.Lang.Ability.Toil[KBM.Lang].." Dauer"

GH.Descript = GH.Guurloth.Name

function GH:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Guurloth.Name] = self.Guurloth,
	}
	KBM_Boss[self.Guurloth.Name] = self.Guurloth	
end

function GH:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Guurloth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		AlertsRef = self.Guurloth.Settings.AlertsRef,
		TimersRef = self.Guurloth.Settings.TimersRef,
	}
	KBMGPGH_Settings = self.Settings
	chKBMGPGH_Settings = self.Settings
end

function GH:SwapSettings(bool)

	if bool then
		KBMGPGH_Settings = self.Settings
		self.Settings = chKBMGPGH_Settings
	else
		chKBMGPGH_Settings = self.Settings
		self.Settings = KBMGPGH_Settings
	end

end

function GH:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGPGH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGPGH_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGPGH_Settings = self.Settings
	else
		KBMGPGH_Settings = self.Settings
	end	
end

function GH:SaveVars()	
	if KBM.Options.Character then
		chKBMGPGH_Settings = self.Settings
	else
		KBMGPGH_Settings = self.Settings
	end	
end

function GH:Castbar(units)
end

function GH:RemoveUnits(UnitID)
	if self.Guurloth.UnitID == UnitID then
		self.Guurloth.Available = false
		return true
	end
	return false
end

function GH:Death(UnitID)
	if self.Guurloth.UnitID == UnitID then
		self.Guurloth.Dead = true
		return true
	end
	return false
end

function GH:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Guurloth.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Guurloth.Dead = false
					self.Guurloth.Casting = false
					self.Guurloth.CastBar:Create(unitID)
					KBM.MechTimer:AddStart(self.Guurloth.TimersRef.OrbFirst)
					KBM.MechTimer:AddStart(self.Guurloth.TimersRef.CallFirst)
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Guurloth.Name, 0, 100)
					self.PhaseObj:SetPhase("Single")
				end
				self.Guurloth.UnitID = unitID
				self.Guurloth.Available = true
				return self.Guurloth
			end
		end
	end
end

function GH:Reset()
	self.EncounterRunning = false
	self.Guurloth.Available = false
	self.Guurloth.UnitID = nil
	self.Guurloth.Dead = false
	self.Guurloth.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function GH:Timer()
	
end

function GH.Guurloth:SetTimers(bool)	
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

function GH.Guurloth:SetAlerts(bool)
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

function GH:DefineMenu()
	self.Menu = GP.Menu:CreateEncounter(self.Guurloth, self.Enabled)
end

function GH:Start()
	-- Create Timers
	self.Guurloth.TimersRef.OrbFirst = KBM.MechTimer:Add(self.Lang.Ability.Orb[KBM.Lang], 40)
	self.Guurloth.TimersRef.OrbFirst.MenuName = self.Lang.Menu.Orb[KBM.Lang]
	self.Guurloth.TimersRef.Orb = KBM.MechTimer:Add(self.Lang.Ability.Orb[KBM.Lang], 125)
	self.Guurloth.TimersRef.CallFirst = KBM.MechTimer:Add(self.Lang.Verbose.Call[KBM.Lang], 25)
	self.Guurloth.TimersRef.CallFirst.MenuName = self.Lang.Menu.CallFirst[KBM.Lang]
	self.Guurloth.TimersRef.Call = KBM.MechTimer:Add(self.Lang.Verbose.Call[KBM.Lang], 136)
	self.Guurloth.TimersRef.Call.MenuName = self.Lang.Ability.Call[KBM.Lang]
	self.Guurloth.TimersRef.Punish = KBM.MechTimer:Add(self.Lang.Debuff.Punish[KBM.Lang], 60)
	self.Guurloth.TimersRef.Geyser = KBM.MechTimer:Add(self.Lang.Ability.Geyser[KBM.Lang], 27)
	KBM.Defaults.TimerObj.Assign(self.Guurloth)
	
	-- Create Alerts
	self.Guurloth.AlertsRef.OrbWarn = KBM.Alert:Create(self.Lang.Verbose.Orb[KBM.Lang], nil, false, true, "orange")
	self.Guurloth.AlertsRef.OrbWarn.MenuName = self.Lang.Ability.Orb[KBM.Lang]
	self.Guurloth.AlertsRef.Orb = KBM.Alert:Create(self.Lang.Verbose.Orb[KBM.Lang], nil, true, true, "orange")
	self.Guurloth.AlertsRef.Orb.MenuName = self.Lang.Menu.OrbDuration[KBM.Lang]
	self.Guurloth.AlertsRef.RumblingWarn = KBM.Alert:Create(self.Lang.Verbose.Rumbling[KBM.Lang], nil, false, true, "blue")
	self.Guurloth.AlertsRef.RumblingWarn.MenuName = self.Lang.Ability.Rumbling[KBM.Lang]
	self.Guurloth.AlertsRef.Rumbling = KBM.Alert:Create(self.Lang.Verbose.Rumbling[KBM.Lang], nil, true, true, "blue")
	self.Guurloth.AlertsRef.Rumbling.MenuName = self.Lang.Menu.Rumbling[KBM.Lang]
	self.Guurloth.AlertsRef.Call = KBM.Alert:Create(self.Lang.Ability.Call[KBM.Lang], nil, true, true, "purple")
	self.Guurloth.AlertsRef.Boulder = KBM.Alert:Create(self.Lang.Ability.Boulder[KBM.Lang], nil, true, true, "yellow")
	self.Guurloth.AlertsRef.ToilWarn = KBM.Alert:Create(self.Lang.Verbose.Toil[KBM.Lang], nil, false, true, "dark_green")
	self.Guurloth.AlertsRef.ToilWarn.MenuName = self.Lang.Ability.Toil[KBM.Lang]
	self.Guurloth.AlertsRef.Toil = KBM.Alert:Create(self.Lang.Verbose.Toil[KBM.Lang], nil, true, true, "dark_green")
	self.Guurloth.AlertsRef.Toil.MenuName = self.Lang.Menu.Toil[KBM.Lang]
	self.Guurloth.AlertsRef.Punish = KBM.Alert:Create(self.Lang.Verbose.Punish[KBM.Lang], nil, true, true, "red")
	self.Guurloth.AlertsRef.Punish.MenuName = self.Lang.Debuff.Punish[KBM.Lang]
	self.Guurloth.AlertsRef.Geyser = KBM.Alert:Create(self.Lang.Ability.Geyser[KBM.Lang], nil, false, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Guurloth)
	
	-- Assign Timers and Alerts to Triggers
	self.Guurloth.Triggers.OrbWarn = KBM.Trigger:Create(self.Lang.Ability.Orb[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.OrbWarn:AddAlert(self.Guurloth.AlertsRef.OrbWarn)
	self.Guurloth.Triggers.OrbWarn:AddTimer(self.Guurloth.TimersRef.Orb)
	self.Guurloth.Triggers.Orb = KBM.Trigger:Create(self.Lang.Ability.Orb[KBM.Lang], "channel", self.Guurloth)
	self.Guurloth.Triggers.Orb:AddAlert(self.Guurloth.AlertsRef.Orb)
	self.Guurloth.Triggers.RumblingWarn = KBM.Trigger:Create(self.Lang.Ability.Rumbling[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.RumblingWarn:AddAlert(self.Guurloth.AlertsRef.RumblingWarn)
	self.Guurloth.Triggers.Rumbling = KBM.Trigger:Create(self.Lang.Ability.Rumbling[KBM.Lang], "channel", self.Guurloth)
	self.Guurloth.Triggers.Rumbling:AddAlert(self.Guurloth.AlertsRef.Rumbling)
	self.Guurloth.Triggers.Call = KBM.Trigger:Create(self.Lang.Ability.Call[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.Call:AddAlert(self.Guurloth.AlertsRef.Call)
	self.Guurloth.Triggers.Call:AddTimer(self.Guurloth.TimersRef.Call)
	self.Guurloth.Triggers.Boulder = KBM.Trigger:Create(self.Lang.Ability.Boulder[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.Boulder:AddAlert(self.Guurloth.AlertsRef.Boulder)
	self.Guurloth.Triggers.ToilWarn = KBM.Trigger:Create(self.Lang.Ability.Toil[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.ToilWarn:AddAlert(self.Guurloth.AlertsRef.ToilWarn)
	self.Guurloth.Triggers.Toil = KBM.Trigger:Create(self.Lang.Ability.Toil[KBM.Lang], "channel", self.Guurloth)
	self.Guurloth.Triggers.Toil:AddAlert(self.Guurloth.AlertsRef.Toil)
	self.Guurloth.Triggers.Punish = KBM.Trigger:Create(self.Lang.Debuff.Punish[KBM.Lang], "playerBuff", self.Guurloth)
	self.Guurloth.Triggers.Punish:AddAlert(self.Guurloth.AlertsRef.Punish, true)
	self.Guurloth.Triggers.Punish:AddTimer(self.Guurloth.TimersRef.Punish)
	self.Guurloth.Triggers.Geyser = KBM.Trigger:Create(self.Lang.Ability.Geyser[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.Geyser:AddAlert(self.Guurloth.AlertsRef.Geyser)
	self.Guurloth.Triggers.Geyser:AddTimer(self.Guurloth.TimersRef.Geyser)
	
	self.Guurloth.CastBar = KBM.CastBar:Add(self, self.Guurloth)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end