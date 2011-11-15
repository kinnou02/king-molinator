-- Sicaron Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSN_Settings = nil
HK = KBMHK_Register()

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

local KBM = KBM_RegisterMod(SN.Sicaron.ID, SN)

SN.Lang.Sicaron = KBM.Language:Add(SN.Sicaron.Name)

-- Notify Dictionary
SN.Lang.Notify = {}
SN.Lang.Notify.Contract = KBM.Language:Add("Sicaron forces (%a*) in to an unholy contract")
SN.Lang.Notify.Contract.German = "Sicaron zwingt (%a*) in einen unheiligen Pakt"

-- Debuff Dictionary
SN.Lang.Debuff = {}
SN.Lang.Debuff.Contract = KBM.Language:Add("Unholy Contract")
SN.Lang.Debuff.Contract.German = "Unheiliger Vertrag"

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
end

function SN:LoadVars()
	if type(KBMSN_Settings) == "table" then
		for Setting, Value in pairs(KBMSN_Settings) do
			if type(KBMSN_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMSN_Settings[Setting]) do
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
end

function SN:SaveVars()
	KBMSN_Settings = self.Settings
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

function SN.Sicaron:Options()
	function self:Timers(bool)
	end
	function self:Alerts(bool)
	
	end
	function self:ContractTimer(bool)
	
	end
	function self:ContractAlert(bool)
	
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.Timers, SN.Settings.Timers.Enabled)
	Timers:AddCheck(SN.Lang.Debuff.Contract[KBM.Lang], self.ContractTimer, SN.Settings.Timers.Contract)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, SN.Settings.Alerts.Enabled)
	Alerts:AddCheck(SN.Lang.Debuff.Contract[KBM.Lang], self.ContractAlert, SN.Settings.Alerts.Contract)
	
end

function SN:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Sicaron.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Sicaron, true, self.Header)
	self.Sicaron.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	self.Sicaron.TimersRef.Contract = KBM.MechTimer:Add(self.Lang.Debuff.Contract[KBM.Lang], 17)
	self.Sicaron.TimersRef.Contract.Enabled = self.Settings.Timers.Contract
	
	-- Create Alerts
	self.Sicaron.AlertsRef.Contract = KBM.Alert:Create(self.Lang.Debuff.Contract[KBM.Lang], 12, false, true, "blue")
	self.Sicaron.AlertsRef.ContractRed = KBM.Alert:Create(self.Lang.Debuff.Contract[KBM.Lang], 5, true, true, "red")
	
	-- Assign Mechanics to Triggers
	self.Sicaron.Triggers.Contract = KBM.Trigger:Create(self.Lang.Notify.Contract[KBM.Lang], "notify", self.Sicaron)
	self.Sicaron.Triggers.Contract:AddTimer(self.Sicaron.TimersRef.Contract)
	self.Sicaron.Triggers.Contract:AddAlert(self.Sicaron.AlertsRef.Contract)
	self.Sicaron.AlertsRef.Contract:AlertEnd(self.Sicaron.AlertsRef.ContractRed)
		
	self.Sicaron.CastBar = KBM.CastBar:Add(self, self.Sicaron, true)
end