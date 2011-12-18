-- Lord Greenscale Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBLG_Settings = nil
chKBMGSBLG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GSB = KBM.BossMod["Greenscales Blight"]

local LG = {
	Enabled = true,
	Instance = GSB.Name,
	HasPhases = true,
	Lang = {},
	Enrage = 60 * 14.5,	
	ID = "Greenscale",
}

LG.Greenscale = {
	Mod = LG,
	Level = "52",
	Active = false,
	Name = "Lord Greenscale",
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

KBM.RegisterMod(LG.ID, LG)

LG.Lang.Greenscale = KBM.Language:Add(LG.Greenscale.Name)
LG.Lang.Greenscale.German = "Fürst Grünschuppe"
LG.Lang.Greenscale.French = "Seigneur Vert\195\169caille"

LG.Greenscale.Name = LG.Lang.Greenscale[KBM.Lang]

function LG:AddBosses(KBM_Boss)
	self.Greenscale.Descript = self.Greenscale.Name
	self.MenuName = self.Greenscale.Descript
	self.Bosses = {
		[self.Greenscale.Name] = self.Greenscale,
	}
	KBM_Boss[self.Greenscale.Name] = self.Greenscale	
end

function LG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Greenscale.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMGSBLG_Settings = self.Settings
	chKBMGSBLG_Settings = self.Settings	
end

function LG:SwapSettings(bool)
	if bool then
		KBMGSBLG_Settings = self.Settings
		self.Settings = chKBMGSBLG_Settings
	else
		chKBMGSBLG_Settings = self.Settings
		self.Settings = KBMGSBLG_Settings
	end
end

function LG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGSBLG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGSBLG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGSBLG_Settings = self.Settings
	else
		KBMGSBLG_Settings = self.Settings
	end	
end

function LG:SaveVars()	
	if KBM.Options.Character then
		chKBMGSBLG_Settings = self.Settings
	else
		KBMGSBLG_Settings = self.Settings
	end	
end

function LG:Castbar(units)
end

function LG:RemoveUnits(UnitID)
	if self.Greenscale.UnitID == UnitID then
		self.Greenscale.Available = false
		return true
	end
	return false
end

function LG:Death(UnitID)
	if self.Greenscale.UnitID == UnitID then
		self.Greenscale.Dead = true
		return true
	end
	return false
end

function LG:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Greenscale.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Greenscale.Dead = false
					self.Greenscale.CastBar:Create(unitID)
				end
				self.Greenscale.Casting = false
				self.Greenscale.UnitID = unitID
				self.Greenscale.Available = true
				return self.Greenscale
			end
		end
	end
end

function LG:Reset()
	self.EncounterRunning = false
	self.Greenscale.Available = false
	self.Greenscale.UnitID = nil
	self.Greenscale.CastBar:Remove()
	self.Greenscale.Dead = false
end

function LG:Timer()	
end

function LG.Greenscale:SetTimers(bool)	
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

function LG.Greenscale:SetAlerts(bool)
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

function LG:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Greenscale, self.Enabled)
end

function LG:Start()	
	self.Greenscale.CastBar = KBM.CastBar:Add(self, self.Greenscale)
	self:DefineMenu()
end