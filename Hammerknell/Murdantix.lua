-- Murdantix Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMX_Settings = nil

local HK = KBMHK_Register()

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
	PhaseType = "percentage",
	PhaseList = {},
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

local KBM = KBM_RegisterMod("Murdantix", MX)

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
			MangleEnabled = true,
			PoundEnabled = true,
			BlastEnabled = true,
			TraumaEnabled = true,
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
end

function MX:LoadVars()
	if type(KBMMX_Settings) == "table" then
		for Setting, Value in pairs(KBMMX_Settings) do
			if type(KBMMX_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMMX_Settings[Setting]) do
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

function MX:SaveVars()
	KBMMX_Settings = self.Settings
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
					self.Murd.CastBar:Create(unitID)
					KBM.TankSwap:Start(self.Lang.Debuff.Mangled[KBM.Lang])
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
end

function MX:Timer()
	
end

function MX.Murdantix:Options()
	function self:TimersEnabled(bool)
		MX.Settings.Timers.Enabled = bool
		MX.Murd.TimersRef.Enabled = bool
		if bool then
			MX.Murdantix.Menu.Header:EnableChildren()
		else
			MX.Murdantix.Menu.Header:DisableChildren()
		end
	end
	function self:MangleEnabled(bool)
		MX.Settings.Timers.MangleEnabled = bool
		MX.Murd.TimersRef.Mangling.Enabled = bool
	end
	function self:PoundEnabled(bool)
		MX.Settings.Timers.PoundEnabled = bool
		MX.Murd.TimersRef.Pound.Enabled = bool
	end
	function self:BlastEnabled(bool)
		MX.Settings.Timers.BlastEnabled = bool
		MX.Murd.TimersRef.Blast.Enabled = bool
	end
	function self:TraumaEnabled(bool)
		MX.Settings.Timers.TraumaEnabled = bool
		MX.Murd.TimersRef.Trauma.Enabled = bool
	end
	function self:AlertEnabled(bool)
		MX.Settings.Alerts.Enabled = bool
	end
	function self:TraumaAlert(bool)
		MX.Settings.Alerts.Trauma = bool
		MX.Murd.AlertsRef.Trauma.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	
	-- Timers Menu
	self.Menu = {}
	self.Menu.Header = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, MX.Settings.Timers.Enabled)
	self.Menu.Mangling = self.Menu.Header:AddCheck(MX.Lang.Mangling[KBM.Lang], self.MangleEnabled, MX.Settings.Timers.MangleEnabled)
	self.Menu.Header:AddCheck(MX.Lang.Pound[KBM.Lang], self.PoundEnabled, MX.Settings.Timers.PoundEnabled)
	self.Menu.Header:AddCheck(MX.Lang.Blast[KBM.Lang], self.BlastEnabled, MX.Settings.Timers.BlastEnabled)
	self.Menu.Header:AddCheck(MX.Lang.Trauma[KBM.Lang], self.TraumaEnabled, MX.Settings.Timers.TraumaEnabled)
	-- Alerts Menu
	self.Menu.Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.AlertEnabled, MX.Settings.Alerts.Enabled)
	self.Menu.Alerts:AddCheck(MX.Lang.Trauma[KBM.Lang], self.TraumaAlert, MX.Settings.Alerts.Trauma)
end

function MX:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Murdantix.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Murdantix, true, self.Header)
	self.Murdantix.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	self.Murd.TimersRef.Mangling = KBM.MechTimer:Add(self.Lang.Mangling[KBM.Lang], 12)
	self.Murd.TimersRef.Mangling.Enabled = MX.Settings.Timers.MangleEnabled
	self.Murd.TimersRef.Pound = KBM.MechTimer:Add(self.Lang.Pound[KBM.Lang], 35)
	self.Murd.TimersRef.Pound.Enabled = MX.Settings.Timers.PoundEnabled
	self.Murd.TimersRef.Blast = KBM.MechTimer:Add(self.Lang.Blast[KBM.Lang], 16)
	self.Murd.TimersRef.Blast.Enabled = MX.Settings.Timers.BlastEnabled
	self.Murd.TimersRef.Trauma = KBM.MechTimer:Add(self.Lang.Trauma[KBM.Lang], 9)
	self.Murd.TimersRef.Trauma.Enabled = MX.Settings.Timers.TraumaEnabled
	
	-- Create Alerts
	self.Murd.AlertsRef.Trauma = KBM.Alert:Create(self.Lang.Trauma[KBM.Lang], 2, true, nil, "yellow")
	
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
	
	self.Murd.CastBar = KBM.CastBar:Add(self, self.Murd, true)
end