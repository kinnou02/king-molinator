-- Plutonus the Immortal Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSPI_Settings = nil
chKBMROSPI_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROS = KBM.BossMod["River of Souls"]

local PI = {
	Enabled = true,
	Instance = ROS.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Plutonus",	
}

PI.Plutonus = {
	Mod = PI,
	Level = "??",
	Active = false,
	Name = "Plutonus the Immortal",
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(PI.ID, PI)

PI.Lang.Plutonus = KBM.Language:Add(PI.Plutonus.Name)
PI.Lang.Plutonus.German = "Plutonus der Unsterbliche"
PI.Lang.Plutonus.French = "Plutonus l'Immortel"

PI.Plutonus.Name = PI.Lang.Plutonus[KBM.Lang]

function PI:AddBosses(KBM_Boss)
	self.Plutonus.Descript = self.Plutonus.Name
	self.MenuName = self.Plutonus.Descript
	self.Bosses = {
		[self.Plutonus.Name] = self.Plutonus,
	}
	KBM_Boss[self.Plutonus.Name] = self.Plutonus	
end

function PI:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Plutonus.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMROSPI_Settings = self.Settings
	chKBMROSPI_Settings = self.Settings
end

function PI:SwapSettings(bool)
	if bool then
		KBMROSPI_Settings = self.Settings
		self.Settings = chKBMROSPI_Settings
	else
		chKBMROSPI_Settings = self.Settings
		self.Settings = KBMROSPI_Settings
	end
end

function PI:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROSPI_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROSPI_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMROSPI_Settings = self.Settings
	else
		KBMROSPI_Settings = self.Settings
	end	
end

function PI:SaveVars()
	if KBM.Options.Character then
		chKBMROSPI_Settings = self.Settings
	else
		KBMROSPI_Settings = self.Settings
	end	
end

function PI:Castbar(units)
end

function PI:RemoveUnits(UnitID)
	if self.Plutonus.UnitID == UnitID then
		self.Plutonus.Available = false
		return true
	end
	return false
end

function PI:Death(UnitID)
	if self.Plutonus.UnitID == UnitID then
		self.Plutonus.Dead = true
		return true
	end
	return false
end

function PI:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Plutonus.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Plutonus.Dead = false
					self.Plutonus.CastBar:Create(unitID)
				end
				self.Plutonus.Casting = false
				self.Plutonus.UnitID = unitID
				self.Plutonus.Available = true
				return self.Plutonus
			end
		end
	end
end

function PI:Reset()
	self.EncounterRunning = false
	self.Plutonus.Available = false
	self.Plutonus.UnitID = nil
	self.Plutonus.CastBar:Remove()
	self.Plutonus.Dead = false
end

function PI:Timer()	
end

function PI.Plutonus:SetTimers(bool)	
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

function PI.Plutonus:SetAlerts(bool)
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

function PI:DefineMenu()
	self.Menu = ROS.Menu:CreateEncounter(self.Plutonus, self.Enabled)
end

function PI:Start()	
	self.Plutonus.CastBar = KBM.CastBar:Add(self, self.Plutonus)
	self:DefineMenu()
end