-- Alsbeth the Discordant Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSAD_Settings = nil
chKBMROSAD_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROS = KBM.BossMod["River of Souls"]

local AD = {
	Enabled = true,
	Instance = ROS.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	Enrage = 60 * 19,
	ID = "Alsbeth",	
}

AD.Alsbeth = {
	Mod = AD,
	Level = "??",
	Active = false,
	Name = "Alsbeth the Discordant",
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(AD.ID, AD)

AD.Lang.Alsbeth = KBM.Language:Add(AD.Alsbeth.Name)
AD.Lang.Alsbeth.German = "Alsbeth die Streitsuchende"
AD.Lang.Alsbeth.French = "Alsbeth la Discordante"

AD.Alsbeth.Name = AD.Lang.Alsbeth[KBM.Lang]

function AD:AddBosses(KBM_Boss)
	self.Alsbeth.Descript = self.Alsbeth.Name
	self.MenuName = self.Alsbeth.Descript
	self.Bosses = {
		[self.Alsbeth.Name] = self.Alsbeth,
	}
	KBM_Boss[self.Alsbeth.Name] = self.Alsbeth	
end

function AD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Alsbeth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMROSAD_Settings = self.Settings
	chKBMROSAD_Settings = self.Settings
end

function AD:SwapSettings(bool)
	if bool then
		KBMROSAD_Settings = self.Settings
		self.Settings = chKBMROSAD_Settings
	else
		chKBMROSAD_Settings = self.Settings
		self.Settings = KBMROSAD_Settings
	end
end

function AD:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROSAD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROSAD_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMROSAD_Settings = self.Settings
	else
		KBMROSAD_Settings = self.Settings
	end	
end

function AD:SaveVars()
	if KBM.Options.Character then
		chKBMROSAD_Settings = self.Settings
	else
		KBMROSAD_Settings = self.Settings
	end	
end

function AD:Castbar(units)
end

function AD:RemoveUnits(UnitID)
	if self.Alsbeth.UnitID == UnitID then
		self.Alsbeth.Available = false
		return true
	end
	return false
end

function AD:Death(UnitID)
	if self.Alsbeth.UnitID == UnitID then
		self.Alsbeth.Dead = true
		return true
	end
	return false
end

function AD:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Alsbeth.Name then
				if not self.Alsbeth.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Alsbeth.Dead = false
					self.Alsbeth.Casting = false
					self.Alsbeth.CastBar:Create(unitID)
				end
				self.Alsbeth.UnitID = unitID
				self.Alsbeth.Available = true
				return self.Alsbeth
			end
		end
	end
end

function AD:Reset()
	self.EncounterRunning = false
	self.Alsbeth.Available = false
	self.Alsbeth.UnitID = nil
	self.Alsbeth.CastBar:Remove()
	self.Alsbeth.Dead = false
end

function AD:Timer()	
end

function AD.Alsbeth:SetTimers(bool)	
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

function AD.Alsbeth:SetAlerts(bool)
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

function AD:DefineMenu()
	self.Menu = ROS.Menu:CreateEncounter(self.Alsbeth, self.Enabled)
end

function AD:Start()	
	self.Alsbeth.CastBar = KBM.CastBar:Add(self, self.Alsbeth)
	self:DefineMenu()
end