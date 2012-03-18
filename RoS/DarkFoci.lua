-- Dark Foci Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSDF_Settings = nil
chKBMROSDF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROS = KBM.BossMod["River of Souls"]

local DF = {
	Enabled = true,
	Directory = ROS.Directory,
	File = "DarkFoci.lua",
	Instance = ROS.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Dark_Foci",
	Object = "DF",
}

DF.Foci = {
	Mod = DF,
	Level = "??",
	Active = false,
	Name = "Dark Focus",
	NameShort = "Foci",
	Dead = false,
	Available = false,
	Menu = {},
	AlertsRef = {},
	TimersRef = {},
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Ground = KBM.Defaults.AlertObj.Create("red"),
			Call = KBM.Defaults.AlertObj.Create("dark_green"),
			Soul = KBM.Defaults.AlertObj.Create("purple"),
		},
		TimersRef = {
			Enabled = true,
			Ground = KBM.Defaults.TimerObj.Create("red"),
			Call = KBM.Defaults.TimerObj.Create("dark_green"),
			Soul = KBM.Defaults.TimerObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(DF.ID, DF)

-- Main Unit Dictionary
DF.Lang.Unit = {}
DF.Lang.Unit.Foci = KBM.Language:Add(DF.Foci.Name)
DF.Lang.Unit.Foci:SetGerman("Finsterer Fokus")
DF.Lang.Unit.Foci:SetFrench("Balise ténébreuse")
DF.Lang.Unit.Foci:SetRussian("Темное средоточия")
-- Additional Unit Dictionary
DF.Lang.Unit.Force = KBM.Language:Add("Force of Corruption")
DF.Lang.Unit.Force:SetGerman("Verderbende Kraft")
DF.Lang.Unit.Force:SetFrench("Force de corruption")
DF.Lang.Unit.Force:SetRussian("Сила искажения")

-- Ability Dictionary
DF.Lang.Ability = {}
DF.Lang.Ability.Ground = KBM.Language:Add("Unhallowed Ground")
DF.Lang.Ability.Ground:SetGerman("Unheiliger Boden")
DF.Lang.Ability.Ground:SetFrench("Sol non consacré")
DF.Lang.Ability.Ground:SetRussian("Земля нечестивости")
DF.Lang.Ability.Call = KBM.Language:Add("Call Darkness")
DF.Lang.Ability.Call:SetGerman("Finsternis rufen")
DF.Lang.Ability.Call:SetFrench("Appel des ténèbres")
DF.Lang.Ability.Call:SetRussian("Призыв тьмы")
DF.Lang.Ability.Blast = KBM.Language:Add("Corrupt Blast")
DF.Lang.Ability.Blast:SetGerman("Sturmverderbnis")
DF.Lang.Ability.Blast:SetFrench("Souffle corrompu")
DF.Lang.Ability.Blast:SetRussian("Черный луч")

-- Debuff Dictionary
DF.Lang.Debuff = {}
DF.Lang.Debuff.Soul = KBM.Language:Add("Destabilize Soul")
DF.Lang.Debuff.Soul:SetGerman("Seele destabilisieren")
DF.Lang.Debuff.Soul:SetFrench("Âme déstabilisée")
DF.Lang.Debuff.Soul:SetRussian("Раскачать душу")

-- Phase Monitor Dictionary
DF.Lang.Phase = {}
DF.Lang.Phase.Force = KBM.Language:Add("Force")
DF.Lang.Phase.Force:SetGerman("Kraft")
DF.Lang.Phase.Force:SetFrench()
DF.Lang.Phase.Force:SetRussian("Адд")
DF.Lang.Phase.Foci = KBM.Language:Add("Foci")
DF.Lang.Phase.Foci:SetGerman("Fokus")
DF.Lang.Phase.Foci:SetFrench("Balise")
DF.Lang.Phase.Foci:SetRussian("Босс")

DF.Foci.NameShort = DF.Lang.Phase.Foci[KBM.Lang]

DF.Force = {
	Mod = DF,
	Level = "??",
	Active = false,
	Name = DF.Lang.Unit.Force[KBM.Lang],
	NameShort = DF.Lang.Phase.Force[KBM.Lang],
	Dead = false,
	Available = false,
	AlertsRef = {},
	UnitID = nil,
	Timout = 5,
	Triggers = {},
	Ignore = true,
	Menu = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Blast = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

DF.Foci.Name = DF.Lang.Unit.Foci[KBM.Lang]
DF.Descript = DF.Foci.Name


function DF:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Foci.Name] = self.Foci,
		[self.Force.Name] = self.Force,
	}
	KBM_Boss[self.Foci.Name] = self.Foci
	KBM.SubBoss[self.Force.Name] = self.Force
end

function DF:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		CastBar = {
			Multi = true,
			Override = true,
		},
		Foci = {
			CastBar = self.Foci.Settings.CastBar,
			TimersRef = self.Foci.Settings.TimersRef,
			AlertsRef = self.Foci.Settings.AlertsRef,
		},
		Force = {
			CastBar = self.Force.Settings.CastBar,
			AlertsRef = self.Force.Settings.AlertsRef,
		},
	}
	KBMROSDF_Settings = self.Settings
	chKBMROSDF_Settings = self.Settings
end

function DF:SwapSettings(bool)
	if bool then
		KBMROSDF_Settings = self.Settings
		self.Settings = chKBMROSDF_Settings
	else
		chKBMROSDF_Settings = self.Settings
		self.Settings = KBMROSDF_Settings
	end
end

function DF:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROSDF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROSDF_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMROSDF_Settings = self.Settings
	else
		KBMROSDF_Settings = self.Settings
	end
	
	self.Settings.CastBar.Multi = true
	self.Settings.CastBar.Override = true
	
	self.Settings.Foci.CastBar.Multi = true
	self.Settings.Force.CastBar.Multi = true
	self.Settings.Foci.CastBar.Override = true
	self.Settings.Force.CastBar.Override = true
end

function DF:SaveVars()
	if KBM.Options.Character then
		chKBMROSDF_Settings = self.Settings
	else
		KBMROSDF_Settings = self.Settings
	end	
end

function DF:Castbar(units)
end

function DF:RemoveUnits(UnitID)
	if self.Foci.UnitID == UnitID then
		self.Foci.Available = false
		return true
	end
	return false
end

function DF.PhaseForce()
	DF.PhaseObj.Objectives:Remove()
	DF.PhaseObj:SetPhase(DF.Lang.Phase.Force[KBM.Lang])
	DF.Phase = 2
	DF.PhaseObj.Objectives:AddPercent(DF.Force.Name, 0, 100)
end

function DF.PhaseFoci()
	DF.PhaseObj.Objectives:Remove()
	DF.PhaseObj:SetPhase(DF.Lang.Phase.Foci[KBM.Lang])
	DF.Phase = 1
	DF.PhaseObj.Objectives:AddPercent(DF.Foci.Name, 0, 100)
end

function DF:Death(UnitID)
	if self.Foci.UnitID == UnitID then
		self.Foci.Dead = true
		return true
	elseif self.Force.UnitID == UnitID then
		self.Force.CastBar:Remove()
		self.Force.Dead = true
		self.Force.UnitID = nil
		self.PhaseFoci()
	end
	return false
end

function DF:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Foci.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Foci.Dead = false
					self.Foci.Casting = false
					self.Foci.CastBar:Create(unitID)
					self.Force.UnitID = nil
					self.Phase = 1
					self.PhaseObj:SetPhase(self.Lang.Phase.Foci[KBM.Lang])
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Foci.Name, 0, 100)
				end
				self.Foci.UnitID = unitID
				self.Foci.Available = true
				return self.Foci
			elseif uDetails.name == self.Force.Name then
				if not self.Force.UnitID then
					self.Force.Casting = false
					self.Force.Dead = false
					self.Force.UnitID = unitID
					self.Force.Available = true
					self.Force.CastBar:Create(unitID)
					return self.Force
				end
			end
		end
	end
end

function DF:Reset()
	self.EncounterRunning = false
	self.Foci.Available = false
	self.Foci.UnitID = nil
	self.Foci.CastBar:Remove()
	self.Foci.Dead = false
	self.Force.Dead = false
	self.Force.UnitID = false
	self.Force.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function DF:Timer()	
end

function DF.Foci:SetTimers(bool)	
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

function DF.Foci:SetAlerts(bool)
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

function DF.Force:SetTimers(bool)	
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

function DF.Force:SetAlerts(bool)
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

function DF:DefineMenu()
	self.Menu = ROS.Menu:CreateEncounter(self.Foci, self.Enabled)
end

function DF:Start()
	-- Create Timers
	self.Foci.TimersRef.Ground = KBM.MechTimer:Add(self.Lang.Ability.Ground[KBM.Lang], 10)
	self.Foci.TimersRef.Call = KBM.MechTimer:Add(self.Lang.Ability.Call[KBM.Lang], 35)
	self.Foci.TimersRef.Soul = KBM.MechTimer:Add(self.Lang.Debuff.Soul[KBM.Lang], 40)
	KBM.Defaults.TimerObj.Assign(self.Foci)
	
	-- Create Alerts
	self.Foci.AlertsRef.Ground = KBM.Alert:Create(self.Lang.Ability.Ground[KBM.Lang], nil, true, true, "red")
	self.Foci.AlertsRef.Call = KBM.Alert:Create(self.Lang.Ability.Call[KBM.Lang], nil, true, true, "dark_green")
	self.Foci.AlertsRef.Soul = KBM.Alert:Create(self.Lang.Debuff.Soul[KBM.Lang], nil, true, true, "purple")
	self.Foci.AlertsRef.Soul:Important()
	self.Force.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], nil, false, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Foci)
	KBM.Defaults.AlertObj.Assign(self.Force)
	
	-- Assign Timers and Alerts to Triggers
	self.Foci.Triggers.Ground = KBM.Trigger:Create(self.Lang.Ability.Ground[KBM.Lang], "cast", self.Foci)
	self.Foci.Triggers.Ground:AddTimer(self.Foci.TimersRef.Ground)
	self.Foci.Triggers.Ground:AddAlert(self.Foci.AlertsRef.Ground)
	self.Foci.Triggers.Call = KBM.Trigger:Create(self.Lang.Ability.Call[KBM.Lang], "cast", self.Foci)
	self.Foci.Triggers.Call:AddTimer(self.Foci.TimersRef.Call)
	self.Foci.Triggers.Call:AddAlert(self.Foci.AlertsRef.Call)
	self.Foci.Triggers.Call:AddPhase(self.PhaseForce)
	self.Foci.Triggers.Soul = KBM.Trigger:Create(self.Lang.Debuff.Soul[KBM.Lang], "playerBuff", self.Foci)
	self.Foci.Triggers.Soul:AddTimer(self.Foci.TimersRef.Soul)
	self.Foci.Triggers.Soul:AddAlert(self.Foci.AlertsRef.Soul, true)
	
	self.Foci.CastBar = KBM.CastBar:Add(self, self.Foci)
	self.Force.CastBar = KBM.CastBar:Add(self, self.Force)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end