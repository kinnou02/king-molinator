-- Estrode Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMES_Settings = nil
HK = KBMHK_Register()

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
	Enrage = 60 * 15,
	ID = "Estrode",
}

ES.Estrode = {
	Mod = ES,
	Level = "??",
	Active = false,
	Name = "Estrode",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
}

local KBM = KBM_RegisterMod(ES.Estrode.ID, ES)

ES.Lang.Estrode = KBM.Language:Add(ES.Estrode.Name)

-- Ability Dictionary
ES.Lang.Ability = {}
ES.Lang.Ability.Soul = KBM.Language:Add("Soul Capture")
ES.Lang.Ability.Soul.German = "Seelenfang"
ES.Lang.Ability.Mind = KBM.Language:Add("Mind Control")
ES.Lang.Ability.Mind.German = "Gedankenkontrolle"

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
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMES_Settings = self.Settings
end

function ES:LoadVars()
	if type(KBMES_Settings) == "table" then
		for Setting, Value in pairs(KBMES_Settings) do
			if type(KBMES_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMES_Settings[Setting]) do
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

function ES:SaveVars()
	KBMES_Settings = self.Settings
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

function ES.Estrode:Options()
	function self:TimersEnabled(bool)
	end
	function self:SoulEnabled(bool)
		ES.Settings.Timers.Soul = bool
		ES.Estrode.TimersRef.Soul.Enabled = bool
	end
	function self:MindEnabled(bool)
		ES.Settings.Timers.Mind = bool
		ES.Estrode.TimersRef.Mind.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, ES.Settings.Timers.Enabled)
	Timers:AddCheck(ES.Lang.Ability.Soul[KBM.Lang], self.SoulEnabled, ES.Settings.Timers.Soul)
	Timers:AddCheck(ES.Lang.Ability.Mind[KBM.Lang], self.MindEnabled, ES.Settings.Timers.Mind)
	
end

function ES:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Estrode.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Estrode, true, self.Header)
	self.Estrode.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	self.Estrode.TimersRef.Soul = KBM.MechTimer:Add(self.Lang.Ability.Soul[KBM.Lang], 40)
	self.Estrode.TimersRef.Soul.Enabled = self.Settings.Timers.Soul
	self.Estrode.TimersRef.Mind = KBM.MechTimer:Add(self.Lang.Ability.Mind[KBM.Lang], 60)
	self.Estrode.TimersRef.Mind.Enabled = self.Settings.Timers.Mind
	
	-- Assign Mechanics to Triggers
	self.Estrode.Triggers.Soul = KBM.Trigger:Create(self.Lang.Ability.Soul[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.Soul:AddTimer(self.Estrode.TimersRef.Soul)
	self.Estrode.Triggers.Mind = KBM.Trigger:Create(self.Lang.Say.Mind[KBM.Lang], "say", self.Estrode)
	self.Estrode.Triggers.Mind:AddTimer(self.Estrode.TimersRef.Mind)
	
	self.Estrode.CastBar = KBM.CastBar:Add(self, self.Estrode, true)
end