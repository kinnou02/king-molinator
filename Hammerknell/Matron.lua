-- Matron Zamira Boss Mod for King Boss Mods
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
MZ.Lang.Matron.French = "Matrone Zamira"

-- Ability Dictionary
MZ.Lang.Ability = {}
MZ.Lang.Ability.Concussion = KBM.Language:Add("Dark Concussion")
MZ.Lang.Ability.Concussion.German = "Dunkle Erschütterung"
MZ.Lang.Ability.Concussion.French = "Concussion sombre"
MZ.Lang.Ability.Blast = KBM.Language:Add("Hideous Blast")
MZ.Lang.Ability.Blast.German = "Schrecklicher Schlag"
MZ.Lang.Ability.Blast.French = "Explosion atroce"
MZ.Lang.Ability.Mark = KBM.Language:Add("Mark of Oblivion")
MZ.Lang.Ability.Mark.German = "Zeichen der Vergessenheit"
MZ.Lang.Ability.Mark.French = "Marque de l'oubli"
MZ.Lang.Ability.Shadow = KBM.Language:Add("Shadow Strike")
MZ.Lang.Ability.Shadow.German = "Schattenschlag"

-- Debuff Dictionary
MZ.Lang.Debuff = {}
MZ.Lang.Debuff.Curse = KBM.Language:Add("Matron's Curse")
MZ.Lang.Debuff.Curse.German = "Fluch der Matrone"

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
			Mark = true,
			Shadow = true,
		},
		Alerts = {
			Enabled = true,
			Concussion = true,
			Blast = true,
			Mark = true,
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
	-- Timer Options
	function self:TimersEnabled(bool)
		MZ.Settings.Timers.Enabled = bool
	end
	function self:ConcussionTimer(bool)
		MZ.Settings.Timers.Concussion = bool
		MZ.Matron.TimersRef.Concussion.Enabled = bool
	end
	function self:MarkTimer(bool)
		MZ.Settings.Timers.Mark = bool
		MZ.Matron.TimersRef.Mark.Enabled = bool
	end
	function self:ShaodwTimer(bool)
		MZ.Settings.Timers.Shadow = bool
		MZ.Matron.TimersRef.Shadow.Enabled = bool
	end
	-- Alert Options
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
	function self:MarkAlert(bool)
		MZ.Settings.Alerts.Mark = bool
		MZ.Matron.AlertsRef.MarkDamage.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, MZ.Settings.Timers.Enabled)
	Timers:AddCheck(MZ.Lang.Ability.Concussion[KBM.Lang], self.ConcussionTimer, MZ.Settings.Timers.Concussion)
	Timers:AddCheck(MZ.Lang.Ability.Mark[KBM.Lang], self.MarkTimer, MZ.Settings.Timers.Mark)
	Timers:AddCheck(MZ.Lang.Ability.Shadow[KBM.Lang], self.ShadowTimer, MZ.Settings.Timers.Shadow)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.AlertsEnabled, MZ.Settings.Alerts.Enabled)
	Alerts:AddCheck(MZ.Lang.Ability.Concussion[KBM.Lang], self.ConcussionAlert, MZ.Settings.Alerts.Concussion)
	Alerts:AddCheck(MZ.Lang.Ability.Blast[KBM.Lang], self.BlastAlert, MZ.Settings.Alerts.Blast)
	Alerts:AddCheck(MZ.Lang.Ability.Mark[KBM.Lang], self.MarkAlert, MZ.Settings.Alerts.Mark)
	
end

function MZ:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Matron.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Matron, true, self.Header)
	self.Matron.MenuItem.Check:SetEnabled(false)
		
	-- Create Timers
	self.Matron.TimersRef.Concussion = KBM.MechTimer:Add(self.Lang.Ability.Concussion[KBM.Lang], 13)
	self.Matron.TimersRef.Mark = KBM.MechTimer:Add(self.Lang.Ability.Mark[KBM.Lang], 24)
	self.Matron.TimersRef.Shadow = KBM.MechTimer:Add(self.Lang.Ability.Shadow[KBM.Lang], 11)
	
	-- Create Alerts
	self.Matron.AlertsRef.Concussion = KBM.Alert:Create(self.Lang.Ability.Concussion[KBM.Lang], 3, true, false, "red")
	self.Matron.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], 2, true, false, "yellow")
	self.Matron.AlertsRef.MarkDamage = KBM.Alert:Create(self.Lang.Ability.Mark[KBM.Lang], 6, false, true, "purple")
	
	-- Assign Mechanics to Triggers
	self.Matron.Triggers.Concussion = KBM.Trigger:Create(self.Lang.Ability.Concussion[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.Concussion:AddTimer(self.Matron.TimersRef.Concussion)
	self.Matron.Triggers.Concussion:AddAlert(self.Matron.AlertsRef.Concussion)
	self.Matron.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Blast:AddAlert(self.Matron.AlertsRef.Blast)
	self.Matron.Triggers.Mark = KBM.Trigger:Create(self.Lang.Ability.Mark[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Mark:AddTimer(self.Matron.TimersRef.Mark)
	self.Matron.Triggers.MarkDamage = KBM.Trigger:Create(self.Lang.Ability.Mark[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.MarkDamage:AddAlert(self.Matron.AlertsRef.MarkDamage, true)
	self.Matron.Triggers.Shadow = KBM.Trigger:Create(self.Lang.Ability.Shadow[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.Shadow:AddTimer(self.Matron.TimersRef.Shadow)
	
	self.Matron.CastBar = KBM.CastBar:Add(self, self.Matron, true)
end