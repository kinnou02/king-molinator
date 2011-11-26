-- Sicaron Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local SN = {
	ModEnabled = true,
	Sicaron = {
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
	ID = "Sicaron",
}

SN.Sicaron = {
	Mod = SN,
	Level = "??",
	Active = false,
	Name = "Sicaron",
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

KBM.RegisterMod(SN.ID, SN)

SN.Lang.Sicaron = KBM.Language:Add(SN.Sicaron.Name)

-- Notify Dictionary
SN.Lang.Notify = {}
SN.Lang.Notify.Contract = KBM.Language:Add("Sicaron forces (%a*) into an unholy contract")
SN.Lang.Notify.Contract.German = "Sicaron zwingt (%a*) in einen unheiligen Pakt"

-- Debuff Dictionary
SN.Lang.Debuff = {}
SN.Lang.Debuff.Contract = KBM.Language:Add("Unholy Contract")
SN.Lang.Debuff.Contract.German = "Unheiliger Vertrag"
SN.Lang.Debuff.Contract.French = "Contrat impie"

SN.Sicaron.Name = SN.Lang.Sicaron[KBM.Lang]

function SN:AddBosses(KBM_Boss)
	self.Sicaron.Descript = self.Sicaron.Name
	self.MenuName = self.Sicaron.Descript
	self.Bosses = {
		[self.Sicaron.Name] = true,
	}
	KBM_Boss[self.Sicaron.Name] = self.Sicaron	
end

function SN:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			Contract = true,
		},
		Alerts = {
			Enabled = true,
			Contract = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMSN_Settings = self.Settings
	chKBMSN_Settings = self.Settings
	
end

function SN:SwapSettings(bool)

	if bool then
		KBMSN_Settings = self.Settings
		self.Settings = chKBMSN_Settings
	else
		chKBMSN_Settings = self.Settings
		self.Settings = KBMSN_Settings
	end

end

function SN:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMSN_Settings
	else
		TargetLoad = KBMSN_Settings
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
		chKBMSN_Settings = self.Settings
	else
		KBMSN_Settings = self.Settings
	end
	
end

function SN:SaveVars()

	if KBM.Options.Settings then
		chKBMSN_Settings = self.Settings
	else
		KBMSN_Settings = self.Settings
	end
	
end

function SN:Castbar(units)
end

function SN:RemoveUnits(UnitID)
	if self.Sicaron.UnitID == UnitID then
		self.Sicaron.Available = false
		return true
	end
	return false
end

function SN:Death(UnitID)
	if self.Sicaron.UnitID == UnitID then
		self.Sicaron.Dead = true
		return true
	end
	return false
end

function SN:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Sicaron.Name then
				if not self.Sicaron.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Sicaron.Dead = false
					self.Sicaron.Casting = false
					self.Sicaron.CastBar:Create(unitID)
				end
				self.Sicaron.UnitID = unitID
				self.Sicaron.Available = true
				return self.Sicaron
			end
		end
	end
end

function SN:Reset()
	self.EncounterRunning = false
	self.Sicaron.Available = false
	self.Sicaron.UnitID = nil
	self.Sicaron.CastBar:Remove()
end

function SN:Timer()
	
end

function SN:SetTimers(bool)

	if bool then
		self.Sicaron.TimersRef.Contract.Enabled = self.Settings.Timers.Contract
	else
		self.Sicaron.TimersRef.Contract.Enabled = false
	end
	
end

function SN:SetAlerts(bool)

	if bool then
		self.Sicaron.AlertsRef.Contract.Enabled = self.Settings.Alerts.Contract
		self.Sicaron.AlertsRef.ContractRed.Enabled = self.Settings.Alerts.Contract
	else
		self.Sicaron.AlertsRef.Contract.Enabled = false
		self.Sicaron.AlertsRef.ContractRed.Enabled = false
	end
	
end

function SN.Sicaron:Options()

	-- Timer Options.
	function self:Timers(bool)
		SN.Settings.Timers.Enabled = bool
		SN:SetTimers(bool)
	end
	function self:ContractTimer(bool)
		SN.Settings.Timers.Contract = bool
		SN.Sicaron.TimersRef.Contract.Enabled = bool
	end
	
	-- Alert Options.
	function self:Alerts(bool)
		SN.Settings.Alerts.Enabled = bool
		SN:SetAlerts(bool)
	end
	function self:ContractAlert(bool)
		SN.Settings.Alerts.Contract = bool
		SN.Sicaron.AlertsRef.Contract.Enabled = bool
		SN.Sicaron.AlertsRef.ContractRed.Enabled = bool
	end
	
	-- Menu Options.
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.Timers, SN.Settings.Timers.Enabled)
	Timers:AddCheck(SN.Lang.Debuff.Contract[KBM.Lang], self.ContractTimer, SN.Settings.Timers.Contract)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, SN.Settings.Alerts.Enabled)
	Alerts:AddCheck(SN.Lang.Debuff.Contract[KBM.Lang], self.ContractAlert, SN.Settings.Alerts.Contract)
	
end

function SN:Start()
	
	-- Initiate Main Menu option.
	self.Header = KBM.HeaderList[self.Instance]
	self.Sicaron.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Sicaron, true, self.Header)
	self.Sicaron.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	self.Sicaron.TimersRef.Contract = KBM.MechTimer:Add(self.Lang.Debuff.Contract[KBM.Lang], 17)
	self:SetTimers(bool)
	
	-- Create Alerts
	self.Sicaron.AlertsRef.Contract = KBM.Alert:Create(self.Lang.Debuff.Contract[KBM.Lang], 12, false, true, "blue")
	self.Sicaron.AlertsRef.ContractRed = KBM.Alert:Create(self.Lang.Debuff.Contract[KBM.Lang], 5, true, true, "red")
	self:SetAlerts(bool)
	
	-- Assign Mechanics to Triggers
	self.Sicaron.Triggers.Contract = KBM.Trigger:Create(self.Lang.Notify.Contract[KBM.Lang], "notify", self.Sicaron)
	self.Sicaron.Triggers.Contract:AddTimer(self.Sicaron.TimersRef.Contract)
	self.Sicaron.Triggers.Contract:AddAlert(self.Sicaron.AlertsRef.Contract, true)
	self.Sicaron.AlertsRef.Contract:Important()
	self.Sicaron.AlertsRef.Contract:AlertEnd(self.Sicaron.AlertsRef.ContractRed)
	
	-- Assign Castbar object.
	self.Sicaron.CastBar = KBM.CastBar:Add(self, self.Sicaron, true)
	
end