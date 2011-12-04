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
	Instance = HK.Name,
	Timers = {},
	Lang = {},
	Enrage = 60 * 12,
	PhaseObj = nil,
	Phase = 1,
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

-- Ability Dictionary
SN.Lang.Ability = {}
SN.Lang.Ability.Hex = KBM.Language:Add("Excruciating Hex")
SN.Lang.Ability.Hex.German = "Quälende Verhexung"
SN.Lang.Ability.Decay = KBM.Language:Add("Moldering Decay")
SN.Lang.Ability.Decay.German = "Zerfallende Verwesung" 

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
			Hex = true,
			Decay = true,
		},
		Alerts = {
			Enabled = true,
			Contract = true,
			Hex = true,
			Decay = true,
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
					self.PhaseObj.Objectives:AddPercent(self.Sicaron.Name, 80, 100)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
				end
				self.Sicaron.UnitID = unitID
				self.Sicaron.Available = true
				return self.Sicaron
			end
		end
	end
end

function SN.PhaseTwo()

	SN.Phase = 2
	SN.PhaseObj.Objectives:Remove()
	SN.PhaseObj.Objectives:AddPercent(SN.Sicaron.Name, 50, 80)
	SN.PhaseObj:SetPhase(SN.Phase)
	print("Phase 2 Starting, 20s purges.")

end

function SN.PhaseThree()

	SN.Phase = 3
	SN.PhaseObj.Objectives:Remove()
	SN.PhaseObj.Objectives:AddPercent(SN.Sicaron.Name, 25, 50)
	SN.PhaseObj:SetPhase(SN.Phase)
	print("Phase 3 Starting, 16s purges.")

end

function SN.PhaseFour()

	SN.Phase = 4
	SN.PhaseObj.Objectives:Remove()
	SN.PhaseObj.Objectives:AddPercent(SN.Sicaron.Name, 10, 25)
	SN.PhaseObj:SetPhase(SN.Phase)
	print("Phase 4 Starting, 12s purges.")

end

function SN.PhaseFive()

	SN.Phase = 5
	SN.PhaseObj.Objectives:Remove()
	SN.PhaseObj.Objectives:AddPercent(SN.Sicaron.Name, 0, 10)
	SN.PhaseObj:SetPhase("Final")
	print("Final Phase! 8s purges.")

end

function SN:Reset()
	
	self.EncounterRunning = false
	self.Sicaron.Available = false
	self.Sicaron.UnitID = nil
	self.Sicaron.CastBar:Remove()
	self.PhaseObj:End(self.TimeElapsed)
	self.Phase = 1
	
end

function SN:Timer()
	
end

function SN:SetTimers(bool)

	if bool then
		self.Sicaron.TimersRef.Contract.Enabled = self.Settings.Timers.Contract
		self.Sicaron.TimersRef.Hex.Enabled = self.Settings.Timers.Hex
		self.Sicaron.TimersRef.Decay.Enabled = self.Settings.Timers.Decay
	else
		self.Sicaron.TimersRef.Contract.Enabled = false
		self.Sicaron.TimersRef.Hex.Enabled = false
		self.Sicaron.TimersRef.Decay.Enabled = false
	end
	
end

function SN:SetAlerts(bool)

	if bool then
		self.Sicaron.AlertsRef.Contract.Enabled = self.Settings.Alerts.Contract
		self.Sicaron.AlertsRef.ContractRed.Enabled = self.Settings.Alerts.Contract
		self.Sicaron.AlertsRef.Hex.Enabled = self.Settings.Alerts.Hex
		self.Sicaron.AlertsRef.Decay.Enabled = self.Settings.Alerts.Decay
	else
		self.Sicaron.AlertsRef.Contract.Enabled = false
		self.Sicaron.AlertsRef.ContractRed.Enabled = false
		self.Sicaron.AlertsRef.Hex.Enabled = false
		self.Sicaron.AlertsRef.Decay.Enabled = false
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
	function self:HexTimer(bool)
		SN.Settings.Timers.Hex = bool
		SN.Sicaron.TimersRef.Hex.Enabled = bool
	end
	function self:DecayTimer(bool)
		SN.Settings.Timers.Decay = bool
		SN.Sicaron.TimersRef.Decay.Enabled = bool
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
	function self:HexAlert(bool)
		SN.Settings.Alerts.Hex = bool
		SN.Sicaron.AlertsRef.Hex.Enabled = bool
	end
	function self:DecayAlert(bool)
		SN.Settings.Alerts.Decay = bool
		SN.Sicaron.AlertsRef.Decay.Enabled = bool
	end
	
	-- Menu Options.
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.Timers, SN.Settings.Timers.Enabled)
	Timers:AddCheck(SN.Lang.Debuff.Contract[KBM.Lang], self.ContractTimer, SN.Settings.Timers.Contract)
	Timers:AddCheck(SN.Lang.Ability.Hex[KBM.Lang], self.HexTimer, SN.Settings.Timers.Hex)
	Timers:AddCheck(SN.Lang.Ability.Decay[KBM.Lang], self.DecayTimer, SN.Settings.Timers.Decay)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, SN.Settings.Alerts.Enabled)
	Alerts:AddCheck(SN.Lang.Debuff.Contract[KBM.Lang], self.ContractAlert, SN.Settings.Alerts.Contract)
	Alerts:AddCheck(SN.Lang.Ability.Hex[KBM.Lang], self.HexAlert, SN.Settings.Alerts.Hex)
	Alerts:AddCheck(SN.Lang.Ability.Decay[KBM.Lang], self.DecayAlert, SN.Settings.Alerts.Decay)
	
end

function SN:Start()
	
	-- Initiate Main Menu option.
	self.Header = KBM.HeaderList[self.Instance]
	self.Sicaron.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Sicaron, true, self.Header)
	self.Sicaron.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	self.Sicaron.TimersRef.Contract = KBM.MechTimer:Add(self.Lang.Debuff.Contract[KBM.Lang], 17)
	self.Sicaron.TimersRef.Hex = KBM.MechTimer:Add(self.Lang.Ability.Hex[KBM.Lang], 26)
	self.Sicaron.TimersRef.Decay = KBM.MechTimer:Add(self.Lang.Ability.Decay[KBM.Lang], 20.5)
	self:SetTimers(self.Settings.Timers.Enabled)
	
	-- Create Alerts
	self.Sicaron.AlertsRef.Contract = KBM.Alert:Create(self.Lang.Debuff.Contract[KBM.Lang], 12, false, true, "blue")
	self.Sicaron.AlertsRef.ContractRed = KBM.Alert:Create(self.Lang.Debuff.Contract[KBM.Lang], 5, true, true, "red")
	self.Sicaron.AlertsRef.Hex = KBM.Alert:Create(self.Lang.Ability.Hex[KBM.Lang], nil, true, true, "purple")
	self.Sicaron.AlertsRef.Decay = KBM.Alert:Create(self.Lang.Ability.Decay[KBM.Lang], nil, true, true, "dark_green")
	self:SetAlerts(self.Settings.Alerts.Enabled)
	
	-- Assign Mechanics to Triggers
	self.Sicaron.Triggers.Contract = KBM.Trigger:Create(self.Lang.Notify.Contract[KBM.Lang], "notify", self.Sicaron)
	self.Sicaron.Triggers.Contract:AddTimer(self.Sicaron.TimersRef.Contract)
	self.Sicaron.Triggers.Contract:AddAlert(self.Sicaron.AlertsRef.Contract, true)
	self.Sicaron.AlertsRef.Contract:Important()
	self.Sicaron.AlertsRef.Contract:AlertEnd(self.Sicaron.AlertsRef.ContractRed)
	self.Sicaron.Triggers.Hex = KBM.Trigger:Create(self.Lang.Ability.Hex[KBM.Lang], "cast", self.Sicaron)
	self.Sicaron.Triggers.Hex:AddAlert(self.Sicaron.AlertsRef.Hex)
	self.Sicaron.Triggers.Hex:AddTimer(self.Sicaron.TimersRef.Hex)
	self.Sicaron.Triggers.Decay = KBM.Trigger:Create(self.Lang.Ability.Decay[KBM.Lang], "cast", self.Sicaron)
	self.Sicaron.Triggers.Decay:AddAlert(self.Sicaron.AlertsRef.Decay)
	self.Sicaron.Triggers.Decay:AddTimer(self.Sicaron.TimersRef.Decay)
	self.Sicaron.Triggers.PhaseTwo = KBM.Trigger:Create(80, "percent", self.Sicaron)
	self.Sicaron.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Sicaron.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Sicaron)
	self.Sicaron.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Sicaron.Triggers.PhaseFour = KBM.Trigger:Create(25, "percent", self.Sicaron)
	self.Sicaron.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Sicaron.Triggers.PhaseFive = KBM.Trigger:Create(10, "percent", self.Sicaron)
	self.Sicaron.Triggers.PhaseFive:AddPhase(self.PhaseFive)
	
	-- Assign Castbar object.
	self.Sicaron.CastBar = KBM.CastBar:Add(self, self.Sicaron, true)
	
	-- Assign Phase Monitor.
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end