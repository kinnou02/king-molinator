-- High Priest Arakhurn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPHA_Settings = nil
chKBMROTPHA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROTP = KBM.BossMod["Rise of the Phoenix"]

local HA = {
	Directory = ROTP.Directory,
	File = "Arakhurn.lua",
	Enabled = true,
	Instance = ROTP.Name,
	HasPhases = true,
	Lang = {},
	ID = "Arakhurn",
}

HA.Arakhurn = {
	Mod = HA,
	Level = "52",
	Active = false,
	Name = "High Priest Arakhurn",
	NameShort = "Arakhurn",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(HA.ID, HA)

HA.Lang.Arakhurn = KBM.Language:Add(HA.Arakhurn.Name)
HA.Lang.Arakhurn.German = "Hohepriester Arakhurn"
HA.Lang.Arakhurn.French = "Grand Pr\195\170tre Arakhurn"

HA.Arakhurn.Name = HA.Lang.Arakhurn[KBM.Lang]

function HA:AddBosses(KBM_Boss)
	self.Arakhurn.Descript = self.Arakhurn.Name
	self.MenuName = self.Arakhurn.Descript
	self.Bosses = {
		[self.Arakhurn.Name] = self.Arakhurn,
	}
	KBM_Boss[self.Arakhurn.Name] = self.Arakhurn	
end

function HA:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Arakhurn.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMROTPHA_Settings = self.Settings
	chKBMROTPHA_Settings = self.Settings
	
end

function HA:SwapSettings(bool)
	if bool then
		KBMROTPHA_Settings = self.Settings
		self.Settings = chKBMROTPHA_Settings
	else
		chKBMROTPGS_Settings = self.Settings
		self.Settings = KBMROTPHA_Settings
	end
end

function HA:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROTPHA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROTPHA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMROTPHA_Settings = self.Settings
	else
		KBMROTPHA_Settings = self.Settings
	end	
end

function HA:SaveVars()	
	if KBM.Options.Character then
		chKBMROTPHA_Settings = self.Settings
	else
		KBMROTPHA_Settings = self.Settings
	end	
end

function HA:Castbar(units)
end

function HA:RemoveUnits(UnitID)
	if self.Arakhurn.UnitID == UnitID then
		self.Arakhurn.Available = false
		return true
	end
	return false
end

function HA:Death(UnitID)
	if self.Arakhurn.UnitID == UnitID then
		self.Arakhurn.Dead = true
		return true
	end
	return false
end

function HA:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Arakhurn.Name then
				if not self.Arakhurn.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Arakhurn.Dead = false
					self.Arakhurn.Casting = false
					self.Arakhurn.CastBar:Create(unitID)
				end
				self.Arakhurn.UnitID = unitID
				self.Arakhurn.Available = true
				return self.Arakhurn
			end
		end
	end
end

function HA:Reset()
	self.EncounterRunning = false
	self.Arakhurn.Available = false
	self.Arakhurn.UnitID = nil
	self.Arakhurn.CastBar:Remove()
end

function HA:Timer()	
end

function HA.Arakhurn:SetTimers(bool)	
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

function HA.Arakhurn:SetAlerts(bool)
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

function HA:DefineMenu()
	self.Menu = ROTP.Menu:CreateEncounter(self.Arakhurn, self.Enabled)
end

function HA:Start()	
	self.Arakhurn.CastBar = KBM.CastBar:Add(self, self.Arakhurn)
	self:DefineMenu()
end