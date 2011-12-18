-- Prince Hylas Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBPH_Settings = nil
chKBMGSBPH_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GSB = KBM.BossMod["Greenscales Blight"]

local PH = {
	Enabled = true,
	Instance = GSB.Name,
	HasPhases = true,
	Lang = {},
	ID = "Hylas",
}

PH.Hylas = {
	Mod = PH,
	Level = "52",
	Active = false,
	Name = "Prince Hylas",
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

KBM.RegisterMod(PH.ID, PH)

PH.Lang.Hylas = KBM.Language:Add(PH.Hylas.Name)
PH.Lang.Hylas.German = "Prinz Hylas"

PH.Hylas.Name = PH.Lang.Hylas[KBM.Lang]

function PH:AddBosses(KBM_Boss)
	self.Hylas.Descript = self.Hylas.Name
	self.MenuName = self.Hylas.Descript
	self.Bosses = {
		[self.Hylas.Name] = self.Hylas,
	}
	KBM_Boss[self.Hylas.Name] = self.Hylas	
end

function PH:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Hylas.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMGSBPH_Settings = self.Settings
	chKBMGSBPH_Settings = self.Settings	
end

function PH:SwapSettings(bool)
	if bool then
		KBMGSBPH_Settings = self.Settings
		self.Settings = chKBMGSBPH_Settings
	else
		chKBMGSBPH_Settings = self.Settings
		self.Settings = KBMGSBPH_Settings
	end
end

function PH:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGSBPH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGSBPH_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGSBPH_Settings = self.Settings
	else
		KBMGSBPH_Settings = self.Settings
	end	
end

function PH:SaveVars()	
	if KBM.Options.Character then
		chKBMGSBPH_Settings = self.Settings
	else
		KBMGSBPH_Settings = self.Settings
	end	
end

function PH:Castbar(units)
end

function PH:RemoveUnits(UnitID)
	if self.Hylas.UnitID == UnitID then
		self.Hylas.Available = false
		return true
	end
	return false
end

function PH:Death(UnitID)
	if self.Hylas.UnitID == UnitID then
		self.Hylas.Dead = true
		return true
	end
	return false
end

function PH:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Hylas.Name then
				if not self.Hylas.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Hylas.Dead = false
					self.Hylas.Casting = false
					self.Hylas.CastBar:Create(unitID)
				end
				self.Hylas.UnitID = unitID
				self.Hylas.Available = true
				return self.Hylas
			end
		end
	end
end

function PH:Reset()
	self.EncounterRunning = false
	self.Hylas.Available = false
	self.Hylas.UnitID = nil
	self.Hylas.CastBar:Remove()
end

function PH:Timer()	
end

function PH.Hylas:SetTimers(bool)	
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

function PH.Hylas:SetAlerts(bool)
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

function PH:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Hylas, self.Enabled)
end

function PH:Start()	
	self.Hylas.CastBar = KBM.CastBar:Add(self, self.Hylas)
	self:DefineMenu()
end