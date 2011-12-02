﻿-- Matron Zamira Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMZ_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local MZ = {
	ModEnabled = true,
	Matron = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = HK.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	ID = "Matron",
}

MZ.Matron = {
	Mod = MZ,
	Level = "??",
	Active = false,
	Name = "Matron Zamira",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
}

KBM.RegisterMod(MZ.ID, MZ)

MZ.Lang.Matron = KBM.Language:Add(MZ.Matron.Name)
MZ.Lang.Matron.German = "Matrone Zamira"
MZ.Lang.Matron.French = "Matrone Zamira"

-- Ability Dictionary
MZ.Lang.Ability = {}
MZ.Lang.Ability.Concussion = KBM.Language:Add("Dark Concussion")
MZ.Lang.Ability.Concussion.German = "Dunkle Erschütterung"
MZ.Lang.Ability.Concussion.French = "Concussion sombre"
MZ.Lang.Ability.Blast = KBM.Language:Add("Hideous Blast")
MZ.Lang.Ability.Blast.German = "Schrecklicher Schlag"
MZ.Lang.Ability.Blast.French = "Explosion atroce"
MZ.Lang.Ability.Mark = KBM.Language:Add("Mark of Oblivion")
MZ.Lang.Ability.Mark.German = "Zeichen der Vergessenheit"
MZ.Lang.Ability.Mark.French = "Marque de l'oubli"
MZ.Lang.Ability.Shadow = KBM.Language:Add("Shadow Strike")
MZ.Lang.Ability.Shadow.German = "Schattenschlag"
MZ.Lang.Ability.Ichor = KBM.Language:Add("Revolting Ichor")

-- Debuff Dictionary
MZ.Lang.Debuff = {}
MZ.Lang.Debuff.Curse = KBM.Language:Add("Matron's Curse")
MZ.Lang.Debuff.Curse.German = "Fluch der Matrone"

MZ.Matron.Name = MZ.Lang.Matron[KBM.Lang]

function MZ:AddBosses(KBM_Boss)
	self.Matron.Descript = self.Matron.Name
	self.MenuName = self.Matron.Descript
	self.Bosses = {
		[self.Matron.Name] = true,
	}
	KBM_Boss[self.Matron.Name] = self.Matron	
end

function MZ:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			Concussion = true,
			Mark = true,
			Shadow = true,
			Blast = true,
			Ichor = true,
		},
		Alerts = {
			Enabled = true,
			Concussion = true,
			Blast = true,
			Mark = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMMZ_Settings = self.Settings
	chKBMMZ_Settings = self.Settings
	
end

function MZ:SwapSettings(bool)

	if bool then
		KBMMZ_Settings = self.Settings
		self.Settings = chKBMMZ_Settings
	else
		chKBMMZ_Settings = self.Settings
		self.Settings = KBMMZ_Settings
	end

end

function MZ:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMMZ_Settings
	else
		TargetLoad = KBMMZ_Settings
	end
	
	if type(TargetLoad) == "table" then
		for Setting, Value in pairs(TargetLoad) do
			if type(TargetLoad[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(TargetLoad[Setting]) do
						if self.Settings[Setting][tSetting] ~= nil then
							self.Settings[Setting][tSetting] = tValue
						end
					end
				end
			else
				if self.Settings[Setting] ~= nil then
					self.Settings[Setting] = Value
				end
			end
		end
	end
	
	if KBM.Options.Character then
		chKBMMZ_Settings = self.Settings
	else
		KBMMZ_Settings = self.Settings
	end
	
end

function MZ:SaveVars()

	if KBM.Options.Character then
		chKBMMZ_Settings = self.Settings
	else
		KBMMZ_Settings = self.Settings
	end
	
end

function MZ:Castbar(units)
end

function MZ:RemoveUnits(UnitID)
	if self.Matron.UnitID == UnitID then
		self.Matron.Available = false
		return true
	end
	return false
end

function MZ:Death(UnitID)
	if self.Matron.UnitID == UnitID then
		self.Matron.Dead = true
		return true
	end
	return false
end

function MZ:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Matron.Name then
				if not self.Matron.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Matron.Dead = false
					self.Matron.Casting = false
					self.Matron.CastBar:Create(unitID)
					KBM.TankSwap:Start(MZ.Lang.Debuff.Curse[KBM.Lang])
				end
				self.Matron.UnitID = unitID
				self.Matron.Available = true
				return self.Matron
			end
		end
	end
end

function MZ:Reset()
	self.EncounterRunning = false
	self.Matron.Available = false
	self.Matron.UnitID = nil
	self.Matron.CastBar:Remove()
end

function MZ:Timer()
	
end

function MZ:SetTimers(bool)

	if bool then
		self.Matron.TimersRef.Concussion.Enabled = self.Settings.Timers.Concussion
		self.Matron.TimersRef.Mark.Enabled = self.Settings.Timers.Mark
		self.Matron.TimersRef.Shadow.Enabled = self.Settings.Timers.Shadow
		self.Matron.TimersRef.Blast.Enabled = self.Settings.Timers.Blast
		self.Matron.TimersRef.Ichor.Enabled = self.Settings.Timers.Ichor
	else
		self.Matron.TimersRef.Concussion.Enabled = false
		self.Matron.TimersRef.Mark.Enabled = false
		self.Matron.TimersRef.Shadow.Enabled = false
		self.Matron.TimersRef.Blast.Enabled = false
		self.Matron.TimersRef.Ichor.Enabled = false
	end
	
end

function MZ:SetAlerts(bool)

	if bool then
		self.Matron.AlertsRef.Concussion.Enabled = self.Settings.Alerts.Concussion
		self.Matron.AlertsRef.Blast.Enabled = self.Settings.Alerts.Blast
		self.Matron.AlertsRef.Mark.Enabled = self.Settings.Alerts.Mark
	else
		self.Matron.AlertsRef.Concussion.Enabled = false
		self.Matron.AlertsRef.Blast.Enabled = false
		self.Matron.AlertsRef.Mark.Enabled = false
	end
	
end

function MZ.Matron:Options()
	-- Timer Options
	function self:TimersEnabled(bool)
		MZ.Settings.Timers.Enabled = bool
		MZ:SetTimers(bool)
	end
	function self:ConcussionTimer(bool)
		MZ.Settings.Timers.Concussion = bool
		MZ.Matron.TimersRef.Concussion.Enabled = bool
	end
	function self:MarkTimer(bool)
		MZ.Settings.Timers.Mark = bool
		MZ.Matron.TimersRef.Mark.Enabled = bool
	end
	function self:ShaodwTimer(bool)
		MZ.Settings.Timers.Shadow = bool
		MZ.Matron.TimersRef.Shadow.Enabled = bool
	end
	function self:BlastTimer(bool)
		MZ.Settings.Timers.Blast = bool
		MZ.Matron.TimersRef.Blast.Enabled = bool
	end
	function self:IchorTimer(bool)
		MZ.Settings.Timers.Ichor = bool
		MZ.Matron.TimersRef.Ichor.Enabled = bool
	end
	-- Alert Options
	function self:AlertsEnabled(bool)
		MZ.Settings.Alerts.Enabled = bool
		MZ:SetAlerts(bool)
	end
	function self:ConcussionAlert(bool)
		MZ.Settings.Alerts.Concussion = bool
		MZ.Matron.AlertsRef.Concussion.Enabled = bool
	end
	function self:BlastAlert(bool)
		MZ.Settings.Alerts.Blast = bool
		MZ.Matron.AlertsRef.Blast.Enabled = bool
	end
	function self:MarkAlert(bool)
		MZ.Settings.Alerts.Mark = bool
		MZ.Matron.AlertsRef.Mark.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, MZ.Settings.Timers.Enabled)
	Timers:AddCheck(MZ.Lang.Ability.Concussion[KBM.Lang], self.ConcussionTimer, MZ.Settings.Timers.Concussion)
	Timers:AddCheck(MZ.Lang.Ability.Mark[KBM.Lang], self.MarkTimer, MZ.Settings.Timers.Mark)
	Timers:AddCheck(MZ.Lang.Ability.Shadow[KBM.Lang], self.ShadowTimer, MZ.Settings.Timers.Shadow)
	Timers:AddCheck(MZ.Lang.Ability.Blast[KBM.Lang], self.BlastTimer, MZ.Settings.Timers.Blast)
	Timers:AddCheck(MZ.Lang.Ability.Ichor[KBM.Lang], self.IchorTimer, MZ.Settings.Timers.Ichor)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.AlertsEnabled, MZ.Settings.Alerts.Enabled)
	Alerts:AddCheck(MZ.Lang.Ability.Concussion[KBM.Lang], self.ConcussionAlert, MZ.Settings.Alerts.Concussion)
	Alerts:AddCheck(MZ.Lang.Ability.Blast[KBM.Lang], self.BlastAlert, MZ.Settings.Alerts.Blast)
	Alerts:AddCheck(MZ.Lang.Ability.Mark[KBM.Lang], self.MarkAlert, MZ.Settings.Alerts.Mark)
	
end

function MZ:Start()

	-- Initiate Main Menu option.
	self.Header = KBM.HeaderList[self.Instance]
	self.Matron.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Matron, true, self.Header)
	self.Matron.MenuItem.Check:SetEnabled(false)
		
	-- Create Timers
	self.Matron.TimersRef.Concussion = KBM.MechTimer:Add(self.Lang.Ability.Concussion[KBM.Lang], 13)
	self.Matron.TimersRef.Mark = KBM.MechTimer:Add(self.Lang.Ability.Mark[KBM.Lang], 24)
	self.Matron.TimersRef.Shadow = KBM.MechTimer:Add(self.Lang.Ability.Shadow[KBM.Lang], 11)
	self.Matron.TimersRef.Blast = KBM.MechTimer:Add(self.Lang.Ability.Blast[KBM.Lang], 8)
	self.Matron.TimersRef.Ichor = KBM.MechTimer:Add(self.Lang.Ability.Ichor[KBM.Lang], 5)
	self:SetTimers(self.Settings.Timers.Enabled)
	
	-- Create Alerts
	self.Matron.AlertsRef.Concussion = KBM.Alert:Create(self.Lang.Ability.Concussion[KBM.Lang], 2, true, false, "red")
	self.Matron.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], nil, true, false, "yellow")
	self.Matron.AlertsRef.Mark = KBM.Alert:Create(self.Lang.Ability.Mark[KBM.Lang], 6, false, true, "purple")
	self:SetAlerts(self.Settings.Alerts.Enabled)
	
	-- Assign Mechanics to Triggers
	self.Matron.Triggers.Concussion = KBM.Trigger:Create(self.Lang.Ability.Concussion[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.Concussion:AddTimer(self.Matron.TimersRef.Concussion)
	self.Matron.Triggers.Concussion:AddAlert(self.Matron.AlertsRef.Concussion)
	self.Matron.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Blast:AddAlert(self.Matron.AlertsRef.Blast)
	self.Matron.Triggers.Blast:AddTimer(self.Matron.TimersRef.Blast)
	self.Matron.Triggers.Ichor = KBM.Trigger:Create(self.Lang.Ability.Ichor[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Ichor:AddTimer(self.Matron.TimersRef.Ichor)
	self.Matron.Triggers.Mark = KBM.Trigger:Create(self.Lang.Ability.Mark[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Mark:AddTimer(self.Matron.TimersRef.Mark)
	self.Matron.Triggers.MarkDamage = KBM.Trigger:Create(self.Lang.Ability.Mark[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.MarkDamage:AddAlert(self.Matron.AlertsRef.Mark, true)
	self.Matron.AlertsRef.Mark:Important()
	self.Matron.Triggers.Shadow = KBM.Trigger:Create(self.Lang.Ability.Shadow[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.Shadow:AddTimer(self.Matron.TimersRef.Shadow)
	
	-- Assign Castbar object
	self.Matron.CastBar = KBM.CastBar:Add(self, self.Matron, true)
	
end