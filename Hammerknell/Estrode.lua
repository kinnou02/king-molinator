-- Estrode Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMES_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local ES = {
	ModEnabled = true,
	Estrode = {
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
	Enrage = 60 * 12,
	ID = "Estrode",
}

ES.Estrode = {
	Mod = ES,
	Level = "??",
	Active = false,
	Name = "Estrode",
	CastBar = nil,
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

KBM.RegisterMod(ES.ID, ES)

ES.Lang.Estrode = KBM.Language:Add(ES.Estrode.Name)

-- Ability Dictionary
ES.Lang.Ability = {}
ES.Lang.Ability.Soul = KBM.Language:Add("Soul Capture")
ES.Lang.Ability.Soul.German = "Seelenfang"
ES.Lang.Ability.Mind = KBM.Language:Add("Mind Control")
ES.Lang.Ability.Mind.German = "Gedankenkontrolle"
ES.Lang.Ability.Dancing = KBM.Language:Add("Dancing Steel")
ES.Lang.Ability.Dancing.German = "Tanzender Stahl"
ES.Lang.Ability.North = KBM.Language:Add("Rage of the North")
ES.Lang.Ability.North.German = "Wut des Nordens"
ES.Lang.Ability.Chastise = KBM.Language:Add("Chastise")
ES.Lang.Ability.Chastise.German = "Züchtigung"

-- Speak Dictionary
ES.Lang.Say = {}
ES.Lang.Say.Mind = KBM.Language:Add("Mmmm, you look delectable.")
ES.Lang.Say.Mind.German = "Hm, Ihr seht köstlich aus."

ES.Estrode.Name = ES.Lang.Estrode[KBM.Lang]

function ES:AddBosses(KBM_Boss)
	self.Estrode.Descript = self.Estrode.Name
	self.MenuName = self.Estrode.Descript
	self.Bosses = {
		[self.Estrode.Name] = true,
	}
	KBM_Boss[self.Estrode.Name] = self.Estrode	
end

function ES:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			Soul = true,
			Mind = true,
		},
		Alerts = {
			Enabled = true,
			Dancing = true,
			North = true,
			Chastise = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMES_Settings = self.Settings
	chKBMES_Settings = self.Settings
	
end

function ES:SwapSettings(bool)

	if bool then
		KBMES_Settings = self.Settings
		self.Settings = chKBMES_Settings
	else
		chKBMES_Settings = self.Settings
		self.Settings = KBMES_Settings
	end

end

function ES:LoadVars()

	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMES_Settings
	else
		TargetLoad = KBMES_Settings
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
		chKBMES_Settings = self.Settings
	else
		KBMES_Settings = self.Settings
	end
	
end

function ES:SaveVars()

	if KBM.Options.Character then
		chKBMES_Settings = self.Settings
	else
		KBMES_Settings = self.Settings
	end
	
end

function ES:Castbar(units)
end

function ES:RemoveUnits(UnitID)
	if self.Estrode.UnitID == UnitID then
		self.Estrode.Available = false
		return true
	end
	return false
end

function ES:Death(UnitID)
	if self.Estrode.UnitID == UnitID then
		self.Estrode.Dead = true
		return true
	end
	return false
end

function ES:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Estrode.Name then
				if not self.Estrode.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Estrode.Dead = false
					self.Estrode.Casting = false
					self.Estrode.CastBar:Create(unitID)
				end
				self.Estrode.UnitID = unitID
				self.Estrode.Available = true
				return self.Estrode
			end
		end
	end
end

function ES:Reset()
	self.EncounterRunning = false
	self.Estrode.Available = false
	self.Estrode.UnitID = nil
	self.Estrode.CastBar:Remove()
end

function ES:Timer()
	
end

function ES:SetTimers(bool)
	
	if bool then
		self.Estrode.TimersRef.Soul.Enabled = self.Settings.Timers.Soul
		self.Estrode.TimersRef.Mind.Enabled = self.Settings.Timers.Mind
	else
		self.Estrode.TimersRef.Soul.Enabled = false
		self.Estrode.TimersRef.Mind.Enabled = false
	end

end

function ES:SetAlerts(bool)

	if bool then
		self.Estrode.AlertsRef.Dancing.Enabled = self.Settings.Alerts.Dancing
		self.Estrode.AlertsRef.North.Enabled = self.Settings.Alerts.North
		self.Estrode.AlertsRef.Chastise.Enabled = self.Settings.Alerts.Chastise
	else
		self.Estrode.AlertsRef.Dancing.Enabled = false
		self.Estrode.AlertsRef.North.Enabled = false
		self.Estrode.AlertsRef.Chastise.Enabled = false
	end

end

function ES.Estrode:Options()
	-- Timer Options
	function self:Timers(bool)
		ES.Settings.Timers.Enabled = bool
		ES:SetTimers(bool)
	end
	function self:SoulEnabled(bool)
		ES.Settings.Timers.Soul = bool
		ES.Estrode.TimersRef.Soul.Enabled = bool
	end
	function self:MindEnabled(bool)
		ES.Settings.Timers.Mind = bool
		ES.Estrode.TimersRef.Mind.Enabled = bool
	end
	-- Alert Options
	function self:Alerts(bool)
		ES.Settings.Alerts.Enabled = bool
		ES:SetAlerts(bool)
	end
	function self:DancingAlert(bool)
		ES.Settings.Alerts.Dancing = bool
		ES.Estrode.AlertsRef.Dancing.Enabled = bool
	end
	function self:NorthAlert(bool)
		ES.Settings.Alerts.North = bool
		ES.Estrode.AlertsRef.North.Enabled = bool
	end
	function self:ChastiseAlert(bool)
		ES.Settings.Alerts.Chastise = bool
		ES.Estrode.AlertsRef.Chastise.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.Timers, ES.Settings.Timers.Enabled)
	Timers:AddCheck(ES.Lang.Ability.Soul[KBM.Lang], self.SoulEnabled, ES.Settings.Timers.Soul)
	Timers:AddCheck(ES.Lang.Ability.Mind[KBM.Lang], self.MindEnabled, ES.Settings.Timers.Mind)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, ES.Settings.Alerts.Enabled)
	Alerts:AddCheck(ES.Lang.Ability.Dancing[KBM.Lang], self.DancingAlert, ES.Settings.Alerts.Dancing)
	Alerts:AddCheck(ES.Lang.Ability.North[KBM.Lang], self.NorthAlert, ES.Settings.Alerts.North)
	Alerts:AddCheck(ES.Lang.Ability.Chastise[KBM.Lang], self.ChastiseAlert, ES.Settings.Alerts.Chastise)
	
end

function ES:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Estrode.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Estrode, true, self.Header)
	self.Estrode.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	self.Estrode.TimersRef.Soul = KBM.MechTimer:Add(self.Lang.Ability.Soul[KBM.Lang], 40)
	self.Estrode.TimersRef.Mind = KBM.MechTimer:Add(self.Lang.Ability.Mind[KBM.Lang], 60)
	self:SetTimers(self.Settings.Timers.Enabled)
	
	-- Screen Alerts
	self.Estrode.AlertsRef.Dancing = KBM.Alert:Create(self.Lang.Ability.Dancing[KBM.Lang], nil, true, true, "red")
	self.Estrode.AlertsRef.North = KBM.Alert:Create(self.Lang.Ability.North[KBM.Lang], nil, true, true, "orange")
	self.Estrode.AlertsRef.Chastise = KBM.Alert:Create(self.Lang.Ability.Chastise[KBM.Lang], nil, true, true, "yellow")
	self:SetAlerts(self.Settings.Alerts.Enabled)
	
	-- Assign Mechanics to Triggers
	self.Estrode.Triggers.Soul = KBM.Trigger:Create(self.Lang.Ability.Soul[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.Soul:AddTimer(self.Estrode.TimersRef.Soul)
	self.Estrode.Triggers.Mind = KBM.Trigger:Create(self.Lang.Say.Mind[KBM.Lang], "say", self.Estrode)
	self.Estrode.Triggers.Mind:AddTimer(self.Estrode.TimersRef.Mind)
	self.Estrode.Triggers.Dancing = KBM.Trigger:Create(self.Lang.Ability.Dancing[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.Dancing:AddAlert(self.Estrode.AlertsRef.Dancing)
	self.Estrode.Triggers.North = KBM.Trigger:Create(self.Lang.Ability.North[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.North:AddAlert(self.Estrode.AlertsRef.North)
	self.Estrode.Triggers.Chastise = KBM.Trigger:Create(self.Lang.Ability.Chastise[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.Chastise:AddAlert(self.Estrode.AlertsRef.Chastise)
	
	self.Estrode.CastBar = KBM.CastBar:Add(self, self.Estrode, true)
end