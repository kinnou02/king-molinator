-- Matron Zamira Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMZ_Settings = nil

local HK = KBMHK_Register()

local MZ = {
	ModEnabled = true,
	Matron = {
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
	ID = "Matron",
}

MZ.Matron = {
	Mod = MZ,
	Level = "??",
	Active = false,
	Name = "Matron Zamira",
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

local KBM = KBM_RegisterMod(MZ.Matron.ID, MZ)

MZ.Lang.Matron = KBM.Language:Add(MZ.Matron.Name)
MZ.Lang.Matron.German = "Matrone Zamira"

-- Ability Dictionary
MZ.Lang.Ability = {}
MZ.Lang.Ability.Concussion = KBM.Language:Add("Dark Concussion")
MZ.Lang.Ability.Concussion.German = "Dunkle Erschütterung"
MZ.Lang.Ability.Concussion.French = "Concussion sombre"
MZ.Lang.Ability.Blast = KBM.Language:Add("Hideous Blast")
MZ.Lang.Ability.Blast.German = "Schrecklicher Schlag"
MZ.Lang.Ability.Blast.French = "Explosion atroce"

-- Debuff Dictionary
MZ.Lang.Debuff = {}
MZ.Lang.Debuff.Curse = KBM.Language:Add("Matron's Curse")
MZ.Lang.Debuff.Curse.German = "Matron's Fluch"

MZ.Matron.Name = MZ.Lang.Matron[KBM.Lang]

function MZ:AddBosses(KBM_Boss)
	self.Matron.Descript = self.Matron.Name
	self.MenuName = self.Matron.Descript
	self.Bosses = {
		[self.Matron.Name] = true,
	}
	KBM_Boss[self.Matron.Name] = self.Matron	
end

function MZ:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			Concussion = true,
		},
		Alerts = {
			Enabled = true,
			Concussion = true,
			Blast = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMMZ_Settings = self.Settings
end

function MZ:LoadVars()
	if type(KBMMZ_Settings) == "table" then
		for Setting, Value in pairs(KBMMZ_Settings) do
			if type(KBMMZ_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMMZ_Settings[Setting]) do
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

function MZ:SaveVars()
	KBMMZ_Settings = self.Settings
end

function MZ:Castbar(units)
end

function MZ:RemoveUnits(UnitID)
	if self.Matron.UnitID == UnitID then
		self.Matron.Available = false
		return true
	end
	return false
end

function MZ:Death(UnitID)
	if self.Matron.UnitID == UnitID then
		self.Matron.Dead = true
		return true
	end
	return false
end

function MZ:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Matron.Name then
				if not self.Matron.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Matron.Dead = false
					self.Matron.Casting = false
					self.Matron.CastBar:Create(unitID)
					KBM.TankSwap:Start(MZ.Lang.Debuff.Curse[KBM.Lang])
				end
				self.Matron.UnitID = unitID
				self.Matron.Available = true
				return self.Matron
			end
		end
	end
end

function MZ:Reset()
	self.EncounterRunning = false
	self.Matron.Available = false
	self.Matron.UnitID = nil
	self.Matron.CastBar:Remove()
end

function MZ:Timer()
	
end

function MZ.Matron:Options()
	function self:TimersEnabled(bool)
		MZ.Settings.Timers.Enabled = bool
	end
	function self:ConcussionTimer(bool)
		MZ.Settings.Timers.Concussion = bool
		MZ.Matron.TimersRef.Concussion.Enabled = bool
	end
	function self:AlertsEnabled(bool)
		MZ.Settings.Alerts.Enabled = bool
	end
	function self:ConcussionAlert(bool)
		MZ.Settings.Alerts.Concussion = bool
		MZ.Matron.AlertsRef.Concussion.Enabled = bool
	end
	function self:BlastAlert(bool)
		MZ.Settings.Alerts.Blast = bool
		MZ.Matron.AlertsRef.Blast.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, MZ.Settings.Timers.Enabled)
	Timers:AddCheck(MZ.Lang.Ability.Concussion[KBM.Lang], self.ConcussionTimer, MZ.Settings.Timers.Concussion)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.AlertsEnabled, MZ.Settings.Alerts.Enabled)
	Alerts:AddCheck(MZ.Lang.Ability.Concussion[KBM.Lang], self.ConcussionAlert, MZ.Settings.Alerts.Concussion)
	Alerts:AddCheck(MZ.Lang.Ability.Blast[KBM.Lang], self.BlastAlert, MZ.Settings.Alerts.Blast)
	
end

function MZ:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Matron.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Matron, true, self.Header)
	self.Matron.MenuItem.Check:SetEnabled(false)
		
	-- Create Timers
	self.Matron.TimersRef.Concussion = KBM.MechTimer:Add(self.Lang.Ability.Concussion[KBM.Lang], 15)
	
	-- Create Alerts
	self.Matron.AlertsRef.Concussion = KBM.Alert:Create(self.Lang.Ability.Concussion[KBM.Lang], 3, true, nil, "red")
	self.Matron.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], 2, true, nil, "yellow")
	
	-- Assign Mechanics to Triggers
	self.Matron.Triggers.Concussion = KBM.Trigger:Create(self.Lang.Ability.Concussion[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Concussion:AddTimer(self.Matron.TimersRef.Concussion)
	self.Matron.Triggers.Concussion:AddAlert(self.Matron.AlertsRef.Concussion)
	self.Matron.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "cast", self.Matron)
	
	self.Matron.CastBar = KBM.CastBar:Add(self, self.Matron, true)
end