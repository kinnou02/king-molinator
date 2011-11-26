-- Grugonim Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGR_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local GR = {
	ModEnabled = true,
	Grugonim = {
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
	Enrage = 60 * 13,
	ID = "Grugonim",
}

GR.Grugonim = {
	Mod = GR,
	Level = "??",
	Active = false,
	Name = "Grugonim",
	Castbar = nil,
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

KBM.RegisterMod(GR.ID, GR)

GR.Lang.Grugonim = KBM.Language:Add(GR.Grugonim.Name)

-- Ability Dictionary
GR.Lang.Ability = {}
GR.Lang.Ability.Decay = KBM.Language:Add("Rampant Decay")
GR.Lang.Ability.Decay.German = "Wilder Verfall"
GR.Lang.Ability.Decay.French = "Pourriture rampante"
GR.Lang.Ability.Bile = KBM.Language:Add("Corrosive Bile")
GR.Lang.Ability.Bile.German = "Ätzende Galle"
GR.Lang.Ability.Bile.French = "Vase corrosive"

GR.Grugonim.Name = GR.Lang.Grugonim[KBM.Lang]

function GR:AddBosses(KBM_Boss)
	self.Grugonim.Descript = self.Grugonim.Name
	self.MenuName = self.Grugonim.Descript
	self.Bosses = {
		[self.Grugonim.Name] = true,
	}
	KBM_Boss[self.Grugonim.Name] = self.Grugonim	
end

function GR:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
		},
		Alerts = {
			Enabled = true,
			Decay = true,
			Bile = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMGR_Settings = self.Settings
	chKBMGR_Settings = self.Settings
	
end

function GR:SwapSettings(bool)

	if bool then
		KBMGR_Settings = self.Settings
		self.Settings = chKBMGR_Settings
	else
		chKBMGR_Settings = self.Settings
		self.Settings = KBMGR_Settings
	end

end

function GR:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMGR_Settings
	else
		TargetLoad = KBMGR_Settings
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
		chKBMGR_Settings = self.Settings
	else
		KBMGR_Settings = self.Settings
	end
	
end

function GR:SaveVars()

	if KBM.Options.Character then
		chKBMGR_Settings = self.Settings
	else
		KBMGR_Settings = self.Settings
	end
	
end

function GR:Castbar(units)
end

function GR:RemoveUnits(UnitID)
	if self.Grugonim.UnitID == UnitID then
		self.Grugonim.Available = false
		return true
	end
	return false
end

function GR:Death(UnitID)
	if self.Grugonim.UnitID == UnitID then
		self.Grugonim.Dead = true
		return true
	end
	return false
end

function GR:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Grugonim.Name then
				if not self.Grugonim.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Grugonim.Dead = false
					self.Grugonim.Casting = false
					self.Grugonim.CastBar:Create(unitID)
					KBM.TankSwap:Start("Heart Stopping Toxin")
				end
				self.Grugonim.UnitID = unitID
				self.Grugonim.Available = true
				return self.Grugonim
			end
		end
	end
end

function GR:Reset()
	self.EncounterRunning = false
	self.Grugonim.Available = false
	self.Grugonim.UnitID = nil
	self.Grugonim.CastBar:Remove()
end

function GR:Timer()
	
end

function GR:SetTimers(bool)

	if bool then
	
	else
	
	end

end

function GR:SetAlerts(bool)

	if bool then
		self.Grugonim.AlertsRef.Decay.Enabled = self.Settings.Alerts.Decay
		self.Grugonim.AlertsRef.Bile.Enabled = self.Settings.Alerts.Bile
	else
		self.Grugonim.AlertsRef.Decay.Enabled = false
		self.Grugonim.AlertsRef.Bile.Enabled = false
	end

end

function GR.Grugonim:Options()

	-- Alert Options
	function self:Alerts(bool)
		GR.Settings.Alerts.Enabled = bool
		GR:SetAlerts(bool)
	end
	function self:DecayAlert(bool)
		GR.Settings.Alerts.Decay = bool
		GR.Grugonim.AlertsRef.Decay.Enabled = bool
	end
	function self:BileAlert(bool)
		GR.Settings.Alerts.Bile = bool
		GR.Grugonim.AlertsRef.Bile.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, GR.Settings.Alerts.Enabled)
	Alerts:AddCheck(GR.Lang.Ability.Decay[KBM.Lang], self.DecayAlert, GR.Settings.Alerts.Decay)
	Alerts:AddCheck(GR.Lang.Ability.Bile[KBM.Lang], self.BileAlert, GR.Settings.Alerts.Bile)
	
end

function GR:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Grugonim.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Grugonim, true, self.Header)
	self.Grugonim.MenuItem.Check:SetEnabled(false)
	
	-- Add Alerts
	self.Grugonim.AlertsRef.Decay = KBM.Alert:Create(self.Lang.Ability.Decay[KBM.Lang], 3, true, true, "dark_green")
	self.Grugonim.AlertsRef.Bile = KBM.Alert:Create(self.Lang.Ability.Bile[KBM.Lang], 2, true, true, "purple")
	self:SetAlerts(self.Settings.Alerts.Enabled)
	
	-- Assign Mechanics to Triggers
	self.Grugonim.Triggers.Decay = KBM.Trigger:Create(self.Lang.Ability.Decay[KBM.Lang], "cast", self.Grugonim)
	self.Grugonim.Triggers.Decay:AddAlert(self.Grugonim.AlertsRef.Decay)
	self.Grugonim.Triggers.Bile = KBM.Trigger:Create(self.Lang.Ability.Bile[KBM.Lang], "cast", self.Grugonim)
	self.Grugonim.Triggers.Bile:AddAlert(self.Grugonim.AlertsRef.Bile)
	
	self.Grugonim.CastBar = KBM.CastBar:Add(self, self.Grugonim, true)
end