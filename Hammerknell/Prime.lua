-- Vladmal Prime Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMVP_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local VP = {
	ModEnabled = true,
	Prime = {
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
	Enrage = 60 * 11, 
	ID = "Prime",
}

VP.Prime = {
	Mod = VP,
	Level = "??",
	Active = false,
	Name = "Vladmal Prime",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Alerts =  {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
}

KBM.RegisterMod(VP.ID, VP)

VP.Lang.Prime = KBM.Language:Add(VP.Prime.Name)
VP.Lang.Flames = KBM.Language:Add("Ancient Flames")
VP.Lang.Flames.French = "Flammes anciennes"
VP.Lang.Flames.German = "Uralte Flamme"

VP.Prime.Name = VP.Lang.Prime[KBM.Lang]

function VP:AddBosses(KBM_Boss)
	self.Prime.Descript = self.Prime.Name
	self.MenuName = self.Prime.Descript
	self.Bosses = {
		[self.Prime.Name] = true,
	}
	KBM_Boss[self.Prime.Name] = self.Prime	
end

function VP:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			Flames = true,
		},
		Alerts = {
			Enabled = true,
			Flames = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMVP_Settings = self.Settings
	chKBMVP_Settings = self.Settings
	
end

function VP:SwapSettings(bool)

	if bool then
		KBMVP_Settings = self.Settings
		self.Settings = chKBMVP_Settings
	else
		chKBMVP_Settings = self.Settings
		self.Settings = KBMVP_Settings
	end

end

function VP:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMVP_Settings
	else
		TargetLoad = KBMVP_Settings
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
		chKBMVP_Settings = self.Settings
	else
		KBMVP_Settings = self.Settings
	end
	
end

function VP:SaveVars()

	if KBM.Options.Character then
		chKBMVP_Settings = self.Settings
	else
		KBMVP_Settings = self.Settings
	end	
		
end

function VP:Castbar(units)
end

function VP:RemoveUnits(UnitID)
	if self.Prime.UnitID == UnitID then
		self.Prime.Available = false
		return true
	end
	return false
end

function VP:Death(UnitID)
	if self.Prime.UnitID == UnitID then
		self.Prime.Dead = true
		return true
	end
	return false
end

function VP:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Prime.Name then
				if not self.Prime.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Prime.Dead = false
					self.Prime.Casting = false
					self.Prime.CastBar:Create(unitID)
				end
				self.Prime.UnitID = unitID
				self.Prime.Available = true
				return self.Prime
			end
		end
	end
end

function VP:Reset()
	self.EncounterRunning = false
	self.Prime.Available = false
	self.Prime.UnitID = nil
	self.Prime.CastBar:Remove()
end

function VP:Timer()
	
end

function VP:SetTimers(bool)

	if bool then
		self.Prime.TimersRef.Flames.Enabled = self.Settings.Timers.Flames
	else
		self.Prime.TimersRef.Flames.Enabled = false
	end

end

function VP:SetAlerts(bool)

	if bool then
		self.Prime.AlertsRef.Flames.Enabled = self.Settings.Alerts.Flames
	else
		self.Prime.AlertsRef.Flames.Enabled = false
	end

end

function VP.Prime:Options()

	-- Timers Options
	function self:Timers(bool)
		VP.Settings.Timers.Enabled = bool
		VP:SetTimers(bool)
	end
	function self:FlamesTimer(bool)
		VP.Settings.Timers.Flames = bool
		VP.Prime.TimersRef.Flames.Enabled = bool
	end
	-- Alerts Options
	function self:Alerts(bool)
		VP.Settings.Alerts.Enabled = bool
		VP:SetAlerts(bool)
	end
	function self:FlamesAlert(bool)
		VP.Settings.Alerts.Flames = bool
		VP.Prime.AlertsRef.Flames.Enabled = bool
	end
	
	-- Menu Options
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.Timers, VP.Settings.Timers.Enabled)
	Timers:AddCheck(VP.Lang.Flames[KBM.Lang], self.FlamesTimer, VP.Settings.Timers.Flames)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, VP.Settings.Alerts.Enabled)
	Alerts:AddCheck(VP.Lang.Flames[KBM.Lang], self.FlamesAlert, VP.Settings.Alerts.Flames)
	
end

function VP:Start()

	-- Intitiate Main Menu option.
	self.Header = KBM.HeaderList[self.Instance]
	self.Prime.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Prime, true, self.Header)
	self.Prime.MenuItem.Check:SetEnabled(false)
	
	-- Timers
	self.Prime.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], 31)
	self:SetTimers(self.Settings.Timers.Enabled)
	
	-- Alerts
	self.Prime.AlertsRef.Flames = KBM.Alert:Create(self.Lang.Flames[KBM.Lang], 13, false, true, "orange")
	self:SetAlerts(self.Settings.Alerts.Enabled)
	
	-- Add Mechanics to Triggers
	self.Prime.Triggers.Flames = KBM.Trigger:Create(self.Lang.Flames[KBM.Lang], "cast", self.Prime)
	self.Prime.Triggers.Flames:AddTimer(self.Prime.TimersRef.Flames)
	self.Prime.Triggers.FlamesDebuff = KBM.Trigger:Create(self.Lang.Flames[KBM.Lang], "buff", self.Prime)
	self.Prime.Triggers.FlamesDebuff:AddAlert(self.Prime.AlertsRef.Flames, true)
	
	self.Prime.CastBar = KBM.CastBar:Add(self, self.Prime, true)
end