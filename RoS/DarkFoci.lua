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
	Instance = ROS.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Dark_Foci",	
}

DF.Foci = {
	Mod = DF,
	Level = "??",
	Active = false,
	Name = "Dark Foci",
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(DF.ID, DF)

DF.Lang.Foci = KBM.Language:Add(DF.Foci.Name)
DF.Lang.Foci.German = "Finsterer Fokus"
DF.Lang.Foci.French = "Balises T\195\169n\195\169breuses"

DF.Foci.Name = DF.Lang.Foci[KBM.Lang]

function DF:AddBosses(KBM_Boss)
	self.Foci.Descript = self.Foci.Name
	self.MenuName = self.Foci.Descript
	self.Bosses = {
		[self.Foci.Name] = self.Foci,
	}
	KBM_Boss[self.Foci.Name] = self.Foci	
end

function DF:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Foci.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
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

function DF:Death(UnitID)
	if self.Foci.UnitID == UnitID then
		self.Foci.Dead = true
		return true
	end
	return false
end

function DF:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Foci.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Foci.Dead = false
					self.Foci.Casting = false
					self.Foci.CastBar:Create(unitID)
				end
				self.Foci.UnitID = unitID
				self.Foci.Available = true
				return self.Foci
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

function DF:DefineMenu()
	self.Menu = ROS.Menu:CreateEncounter(self.Foci, self.Enabled)
end

function DF:Start()	
	self.Foci.CastBar = KBM.CastBar:Add(self, self.Foci)
	self:DefineMenu()
end