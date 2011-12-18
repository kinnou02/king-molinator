﻿-- Warmaster Galenir Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSWG_Settings = nil
chKBMROSWG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROS = KBM.BossMod["River of Souls"]

local WG = {
	Enabled = true,
	Instance = ROS.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	Enrage = 60 * 5.5,
	ID = "Warmaster Galenir",	
}

WG.Galenir = {
	Mod = WG,
	Level = "??",
	Active = false,
	Name = "Warmaster Galenir",
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(WG.ID, WG)

WG.Lang.Galenir = KBM.Language:Add(WG.Galenir.Name)
WG.Lang.Galenir.German = "Kriegsmeister Galenir"
WG.Lang.Galenir.French = "Ma\195\174tre de Guerre Galenir"

-- Debuff Dictionary
WG.Lang.Debuff = {}
WG.Lang.Debuff.Festering = KBM.Language:Add("Festering Infection")

WG.Galenir.Name = WG.Lang.Galenir[KBM.Lang]

function WG:AddBosses(KBM_Boss)
	self.Galenir.Descript = self.Galenir.Name
	self.MenuName = self.Galenir.Descript
	self.Bosses = {
		[self.Galenir.Name] = self.Galenir,
	}
	KBM_Boss[self.Galenir.Name] = self.Galenir	
end

function WG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Galenir.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMROSWG_Settings = self.Settings
	chKBMROSWG_Settings = self.Settings
end

function WG:SwapSettings(bool)
	if bool then
		KBMROSWG_Settings = self.Settings
		self.Settings = chKBMROSWG_Settings
	else
		chKBMROSWG_Settings = self.Settings
		self.Settings = KBMROSWG_Settings
	end
end

function WG:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROSWG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROSWG_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMROSWG_Settings = self.Settings
	else
		KBMROSWG_Settings = self.Settings
	end	
end

function WG:SaveVars()
	if KBM.Options.Character then
		chKBMROSWG_Settings = self.Settings
	else
		KBMROSWG_Settings = self.Settings
	end	
end

function WG:Castbar(units)
end

function WG:RemoveUnits(UnitID)
	if self.Galenir.UnitID == UnitID then
		self.Galenir.Available = false
		return true
	end
	return false
end

function WG:Death(UnitID)
	if self.Galenir.UnitID == UnitID then
		self.Galenir.Dead = true
		return true
	end
	return false
end

function WG:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Galenir.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Galenir.Dead = false
					self.Galenir.Casting = false
					self.Galenir.CastBar:Create(unitID)
					KBM.TankSwap:Start(KBM.Lang.Debuff.Festering[KBM.Lang])
				end
				self.Galenir.UnitID = unitID
				self.Galenir.Available = true
				return self.Galenir
			end
		end
	end
end

function WG:Reset()
	self.EncounterRunning = false
	self.Galenir.Available = false
	self.Galenir.UnitID = nil
	self.Galenir.CastBar:Remove()
	self.Galenir.Dead = false
end

function WG:Timer()	
end

function WG.Galenir:SetTimers(bool)	
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

function WG.Galenir:SetAlerts(bool)
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

function WG:DefineMenu()
	self.Menu = ROS.Menu:CreateEncounter(self.Galenir, self.Enabled)
end

function WG:Start()	
	self.Galenir.CastBar = KBM.CastBar:Add(self, self.Galenir)
	self:DefineMenu()
end