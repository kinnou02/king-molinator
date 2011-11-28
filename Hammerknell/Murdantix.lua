-- Murdantix Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMX_Settings = nil
chKBMMX_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local MX = {
	ModEnabled = true,
	Murdantix = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		Name = "Murdantix",
	},
	Instance = HK.Name,
	HasPhases = true,
	Phase = 1,
	Timers = {},
	Lang = {},
	TankSwap = true,
	Enrage = 60 * 10,
	ID = "Murdantix",
}

MX.Murd = {
	Mod = MX,
	Level = "??",
	Active = false,
	Name = "Murdantix",
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = false,
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Descript = "Murdantix",
	TimeOut = 5,
}

KBM.RegisterMod("Murdantix", MX)

MX.Lang.Murdantix = KBM.Language:Add(MX.Murd.Name)

-- Ability Dictionary
MX.Lang.Mangling = KBM.Language:Add("Mangling Crush")
MX.Lang.Mangling.French = "Essorage"
MX.Lang.Mangling.German = "Erdrückender Stoss"
MX.Lang.Pound = KBM.Language:Add("Ferocious Pound")
MX.Lang.Pound.French = "Attaque f\195\169roce"
MX.Lang.Pound.German = "Wildes Zuschlagen"
MX.Lang.Blast = KBM.Language:Add("Demonic Blast")
MX.Lang.Blast.French = "Explosion d\195\169moniaque"
MX.Lang.Blast.German = "Dämonische Explosion"
MX.Lang.Trauma = KBM.Language:Add("Soul Trauma")
MX.Lang.Trauma.French = "Traumatisme d'\195\162me"
MX.Lang.Trauma.German = "Seelentrauma"

-- Debuff Dictionary
MX.Lang.Debuff = {}
MX.Lang.Debuff.Mangled = KBM.Language:Add("Mangled")
MX.Lang.Debuff.Mangled.German = "Üble Blessur"

function MX:AddBosses(KBM_Boss)
	self.MenuName = self.Murd.Name
	KBM_Boss[self.Murd.Name] = self.Murd
end

function MX:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			Mangle = true,
			Pound = true,
			Blast = true,
			Trauma = true,
		},
		Alerts = {
			Enabled = true,
			Trauma = true,
		},
		CastBar = {
			Enabled = true,
			x = false,
			y = false,
		},
	}
	KBMMX_Settings = self.Settings
	chKBMMX_Settings = self.Settings
	
end

function MX:SwapSettings(bool)

	if bool then
		KBMMX_Settings = self.Settings
		self.Settings = chKBMMX_Settings
	else
		chKBMMX_Settings = self.Settings
		self.Settings = KBMMX_Settings
	end

end

function MX:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMMX_Settings
	else
		TargetLoad = KBMMX_Settings
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
		chKBMMX_Settings = self.Settings
	else
		KBMMX_Settings = self.Settings
	end
	
end

function MX:SaveVars()
	
	if KBM.Options.Character then
		chKBMMX_Settings = self.Settings
	else
		KBMMX_Settings = self.Settings
	end
	
end

function MX:Castbar()
end

function MX:RemoveUnits(UnitID)
	if self.Murd.UnitID == UnitID then
		self.Murd.Available = false
		return true
	end
	return false
end

function MX:Death(UnitID)
	if self.Murd.UnitID == UnitID then
		self.Murd.Dead = true
		return true
	end
	return false
end

function MX.PhaseTwo()
	MX.PhaseObj.Objectives:Remove()
	MX.Phase = 2
	MX.PhaseObj:SetPhase(2)
	MX.PhaseObj.Objectives:AddPercent(self.Murd.Name, 50, 75)
end

function MX.PhaseThree()
	MX.PhaseObj.Objectives:Remove()
	MX.Phase = 3
	MX.PhaseObj:SetPhase(3)
	MX.PhaseObj.Objectives:AddPercent(self.Murd.Name, 25, 50)
end

function MX.PhaseFour()
	MX.Phase.Objectives:Remove()
	MX.Phase = 4
	MX.PhaseObj:SetPhase(4)
	MX.PhaseObj.Objectives:AddPercent(self.Murd.Name, 0, 25)
end

function MX:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Murd.Name then
				if not self.Murd.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Murd.Dead = false
					self.Murd.Casting = false
					self.Phase = 1
					self.Murd.CastBar:Create(unitID)
					KBM.TankSwap:Start(self.Lang.Debuff.Mangled[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Murd.Name, 75, 100)
					self.PhaseObj:Start(self.StartTime)
				end
				self.Murd.UnitID = unitID
				self.Murd.Available = true
				return self.Murd
			end
		end
	end
end

function MX:Reset()
	self.EncounterRunning = false
	self.Murd.UnitID = nil
	self.Murd.CastBar:Remove()
	self.Phase = 1
	self.PhaseObj:End(Inspect.Time.Real())
end

function MX:Timer()
	
end

function MX:SetTimers(bool)

	if bool then
		self.Murd.TimersRef.Mangling.Enabled = MX.Settings.Timers.Mangle
		self.Murd.TimersRef.Pound.Enabled = MX.Settings.Timers.Pound
		self.Murd.TimersRef.Blast.Enabled = MX.Settings.Timers.Blast
		self.Murd.TimersRef.Trauma.Enabled = MX.Settings.Timers.Trauma
	else
		self.Murd.TimersRef.Mangling.Enabled = false
		self.Murd.TimersRef.Pound.Enabled = false
		self.Murd.TimersRef.Blast.Enabled = false
		self.Murd.TimersRef.Trauma.Enabled = false
	end

end

function MX:SetAlerts(bool)

	if bool then
		self.Murd.AlertsRef.Trauma.Enabled = self.Settings.Alerts.Trauma
	else
		self.Murd.AlertsRef.Trauma.Enabled = false
	end
	
end

function MX.Murdantix:Options()

	-- Timer Options
	function self:Timers(bool)
		MX.Settings.Timers.Enabled = bool
		MX:SetTimers(bool)
	end
	function self:MangleTimer(bool)
		MX.Settings.Timers.Mangle = bool
		MX.Murd.TimersRef.Mangling.Enabled = bool
	end
	function self:PoundTimer(bool)
		MX.Settings.Timers.Pound = bool
		MX.Murd.TimersRef.Pound.Enabled = bool
	end
	function self:BlastTimer(bool)
		MX.Settings.Timers.Blast = bool
		MX.Murd.TimersRef.Blast.Enabled = bool
	end
	function self:TraumaTimer(bool)
		MX.Settings.Timers.Trauma = bool
		MX.Murd.TimersRef.Trauma.Enabled = bool
	end
	
	-- Alert Options
	function self:Alerts(bool)
		MX.Settings.Alerts.Enabled = bool
		MX:SetAlerts(bool)
	end
	function self:TraumaAlert(bool)
		MX.Settings.Alerts.Trauma = bool
		MX.Murd.AlertsRef.Trauma.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	
	-- Timers Menu
	local Header = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.Timers, MX.Settings.Timers.Enabled)
	Header:AddCheck(MX.Lang.Mangling[KBM.Lang], self.MangleTimer, MX.Settings.Timers.Mangle)
	Header:AddCheck(MX.Lang.Pound[KBM.Lang], self.PoundTimer, MX.Settings.Timers.Pound)
	Header:AddCheck(MX.Lang.Blast[KBM.Lang], self.BlastTimer, MX.Settings.Timers.Blast)
	Header:AddCheck(MX.Lang.Trauma[KBM.Lang], self.TraumaTimer, MX.Settings.Timers.Trauma)
	-- Alerts Menu
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, MX.Settings.Alerts.Enabled)
	Alerts:AddCheck(MX.Lang.Trauma[KBM.Lang], self.TraumaAlert, MX.Settings.Alerts.Trauma)
	
end

function MX:Start()

	-- Intitiate Main Menu option.
	self.Header = KBM.HeaderList[self.Instance]
	self.Murdantix.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Murdantix, true, self.Header)
	self.Murdantix.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	self.Murd.TimersRef.Mangling = KBM.MechTimer:Add(self.Lang.Mangling[KBM.Lang], 12)
	self.Murd.TimersRef.Pound = KBM.MechTimer:Add(self.Lang.Pound[KBM.Lang], 35)
	self.Murd.TimersRef.Blast = KBM.MechTimer:Add(self.Lang.Blast[KBM.Lang], 16)
	self.Murd.TimersRef.Trauma = KBM.MechTimer:Add(self.Lang.Trauma[KBM.Lang], 9)
	self:SetTimers(self.Settings.Timers.Enabled)
	
	-- Create Alerts
	self.Murd.AlertsRef.Trauma = KBM.Alert:Create(self.Lang.Trauma[KBM.Lang], 2, true, nil, "yellow")
	self:SetAlerts(self.Settings.Alerts.Enabled)
	
	-- Assign Mechanics to Triggers
	self.Murd.Triggers.Mangling = KBM.Trigger:Create(self.Lang.Mangling[KBM.Lang], "damage", self.Murd)
	self.Murd.Triggers.Mangling:AddTimer(self.Murd.TimersRef.Mangling)
	self.Murd.Triggers.Pound = KBM.Trigger:Create(self.Lang.Pound[KBM.Lang], "damage", self.Murd)
	self.Murd.Triggers.Pound:AddTimer(self.Murd.TimersRef.Pound)
	self.Murd.Triggers.Blast = KBM.Trigger:Create(self.Lang.Blast[KBM.Lang], "cast", self.Murd)
	self.Murd.Triggers.Blast:AddTimer(self.Murd.TimersRef.Blast)
	self.Murd.Triggers.Trauma = KBM.Trigger:Create(self.Lang.Trauma[KBM.Lang], "cast", self.Murd)
	self.Murd.Triggers.Trauma:AddTimer(self.Murd.TimersRef.Trauma)
	self.Murd.Triggers.Trauma:AddAlert(self.Murd.AlertsRef.Trauma)
	self.Murd.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Murd)
	self.Murd.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Murd.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Murd)
	self.Murd.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Murd.Triggers.PhaseFour = KBM.Trigger:Create(25, "percent", self.Murd)
	self.Murd.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	-- Assign Castbar object.
	self.Murd.CastBar = KBM.CastBar:Add(self, self.Murd, true)
	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end