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
	Instance = ROS.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	Enrage = 60 * 9.5,
	ID = "Herald_Gaurath",	
}

HG.Gaurath = {
	Mod = HG,
	Level = "??",
	Active = false,
	Name = "Herald Gaurath",
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(HG.ID, HG)

HG.Lang.Gaurath = KBM.Language:Add(HG.Gaurath.Name)
HG.Lang.Gaurath.German = "Herold Gaurath"
HG.Lang.Gaurath.French = "H\195\169raut Gaurath"

HG.Gaurath.Name = HG.Lang.Gaurath[KBM.Lang]

function HG:AddBosses(KBM_Boss)
	self.Gaurath.Descript = self.Gaurath.Name
	self.MenuName = self.Gaurath.Descript
	self.Bosses = {
		[self.Gaurath.Name] = self.Gaurath,
	}
	KBM_Boss[self.Gaurath.Name] = self.Gaurath	
end

function HG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Gaurath.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
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
	end
	return false
end

function HG:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Gaurath.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Gaurath.Dead = false
					self.Gaurath.CastBar:Create(unitID)
				end
				self.Gaurath.Casting = false
				self.Gaurath.UnitID = unitID
				self.Gaurath.Available = true
				return self.Gaurath
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
	self.Gaurath.CastBar = KBM.CastBar:Add(self, self.Gaurath)
	self:DefineMenu()
end