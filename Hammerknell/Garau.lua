-- Inquisitor Garau Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGU_Settings = nil
local HK = KBMHK_Register()

local GU = {
	ModEnabled = true,
	MenuName = "",
	Garau = {
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
	ID = "Garau",
}

GU.Garau = {
	Mod = GU,
	Level = "??",
	Active = false,
	Name = "Inquisitor Garau",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Descript = "Inquisitor Garau",
	TimeOut = 5,
	Triggers = {},
}

local KBM = KBM_RegisterMod(GU.Garau.ID, GU)

GU.Lang.Garau = KBM.Language:Add(GU.Garau.Name)
GU.Lang.Garau.French = "Inquisiteur Garau"

-- Ability Dictionary
GU.Lang.Ability = {}
GU.Lang.Ability.Arcane = KBM.Language:Add("Arcane Essence")
GU.Lang.Ability.Arcane.French = "Syphon d'essence"
GU.Lang.Ability.Arcane.German = "Essenzabsauger"
GU.Lang.Ability.Blood = KBM.Language:Add("Bloodtide")
GU.Lang.Ability.Blood.German = "Blutflut"

-- Speak Dictionary
GU.Lang.Say = {}
GU.Lang.Say.Power = KBM.Language:Add("Power my creation!")
GU.Lang.Say.Power.French = "Alimentez ma cr\195\169ation*!"
GU.Lang.Say.Power.German = "Macht meiner Schöpfung!"
GU.Lang.Say.Arcane = KBM.Language:Add("Inquisitor Garau siphons arcane essence from nearby enemies!")
GU.Lang.Say.Arcane.French = "Inquisiteur Garau siphonne l'essence occulte des ennemis \195\160 proximit\195\169 !"
GU.Lang.Say.Arcane.German = "Inquisitor Garau saugt von Feinden in der Nähe arkane Essenz ab!"
GU.Lang.Say.Bask = KBM.Language:Add("Bask in the power of Akylios!")
GU.Lang.Say.Bask.French = "Savourez le pouvoir d'Akylios !"
GU.Lang.Say.Bask.German = "Preiset die Macht des Akylios!"
GU.Lang.Say.Sacrifice = KBM.Language:Add("Sacrifice your lives for Akylios!")
GU.Lang.Say.Sacrifice.French = "Sacrifiez vos vies pour Akylios !"
GU.Lang.Say.Sacrifice.German = "Opfert Eure leben dem Akylios!"

-- Unit Dictionary
GU.Lang.Unit = {}
GU.Lang.Unit.Porter = KBM.Language:Add("Arcane Porter")
GU.Lang.Unit.Porter.German = "Arkane Torwache"
GU.Lang.Unit.Crawler = KBM.Language:Add("Infused Crawler")
GU.Lang.Unit.Crawler.German = "Durchdrungener Kriecher"

GU.Garau.Name = KBM.Language[GU.Garau.Name][KBM.Lang]

function GU:AddBosses(KBM_Boss)
	self.MenuName = self.Garau.Name
	self.Garau.Bosses = {
		[self.Garau.Name] = true,
	}
	KBM_Boss[self.Garau.Name] = self.Garau	
end

function GU:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			BloodEnabled = true,
			PorterEnabled = true,
			EssenceEnabled = true,
			CrawlerEnabled = true,
		},
		CastBar =  {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMGU_Settings = self.Settings
end

function GU:LoadVars()
	if type(KBMGU_Settings) == "table" then
		for Setting, Value in pairs(KBMGU_Settings) do
			if type(KBMGU_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMGU_Settings[Setting]) do
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

function GU:SaveVars()
	KBMGU_Settings = self.Settings
end

function GU:Castbar(units)
end

function GU:RemoveUnits(UnitID)
	if self.Garau.UnitID == UnitID then
		self.Garau.Available = false
		return true
	end
	return false
end

function GU:Death(UnitID)
	if self.Garau.UnitID == UnitID then
		self.Garau.Dead = true
		return true
	end
	return false
end

function GU:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Garau.Name then
				if not self.Garau.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Garau.Dead = false
					self.Garau.Casting = false
					self.Garau.CastBar:Create(unitID)
				end
				self.Garau.UnitID = unitID
				self.Garau.Available = true
				return self.Garau
			end
		end
	end
end

function GU:Reset()
	self.EncounterRunning = false
	self.Garau.Available = false
	self.Garau.UnitID = nil
	self.Garau.CastBar:Remove()
end

function GU:Timer()
	
end

function GU.Garau:Options()
	function self:TimersEnabled(bool)
		GU.Settings.Timers.Enabled = bool
	end
	function self:BloodEnabled(bool)
		GU.Settings.Timers.BloodEnabled = bool
		GU.Garau.TimersRef.Blood.Enabled = bool
	end
	function self:CrawlerEnabled(bool)
		GU.Settings.Timers.CrawlerEnabled = bool
		GU.Garau.TimersRef.Crawler.Enabled = bool
	end
	function self:PorterEnabled(bool)
		GU.Settings.Timers.PorterEnabled = bool
		GU.Garau.TimersRef.Porter.Enabled = bool
	end
	function self:EssenceEnabled(bool)
		GU.Settings.Timers.EssenceEnabled = bool
		GU.Garau.TimersRef.Essence.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, GU.Settings.Timers.Enabled)
	Timers:AddCheck(GU.Lang.Ability.Blood[KBM.Lang], self.BloodEnabled, GU.Settings.Timers.BloodEnabled)
	Timers:AddCheck(GU.Lang.Unit.Crawler[KBM.Lang], self.CrawlerEnabled, GU.Settings.Timers.CrawlerEnabled)
	Timers:AddCheck(GU.Lang.Unit.Porter[KBM.Lang], self.PorterEnabled, GU.Settings.Timers.PorterEnabled)
	Timers:AddCheck(GU.Lang.Ability.Arcane[KBM.Lang], self.EssenceEnabled, GU.Settings.Timers.EssenceEnabled)
	
end

function GU:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Garau.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Garau, true, self.Header)
	self.Garau.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	self.Garau.TimersRef.Blood = KBM.MechTimer:Add(GU.Lang.Ability.Blood[KBM.Lang], 18)
	self.Garau.TimersRef.Blood.Enabled = self.Settings.Timers.BloodEnabled
	self.Garau.TimersRef.Crawler = KBM.MechTimer:Add(self.Lang.Unit.Crawler[KBM.Lang], 30)
	self.Garau.TimersRef.Crawler.Enabled = self.Settings.Timers.CrawlerEnabled
	self.Garau.TimersRef.Porter = KBM.MechTimer:Add(GU.Lang.Unit.Porter[KBM.Lang], 45)
	self.Garau.TimersRef.Porter.Enabled = self.Settings.Timers.PorterEnabled
	self.Garau.TimersRef.Essence = KBM.MechTimer:Add(GU.Lang.Ability.Arcane[KBM.Lang], 20)
	self.Garau.TimersRef.Essence.Enabled = self.Settings.Timers.EssenceEnabled
	
	-- Assign Mechanics to Triggers
	self.Garau.Triggers.Blood = KBM.Trigger:Create(GU.Lang.Ability.Blood[KBM.Lang], "damage", self.Garau)
	self.Garau.Triggers.Blood:AddTimer(self.Garau.TimersRef.Blood)
	self.Garau.Triggers.CrawlerA = KBM.Trigger:Create(GU.Lang.Say.Bask[KBM.Lang], "say", self.Garau)
	self.Garau.Triggers.CrawlerA:AddTimer(self.Garau.TimersRef.Crawler)
	self.Garau.Triggers.CrawlerB = KBM.Trigger:Create(GU.Lang.Say.Sacrifice[KBM.Lang], "say", self.Garau)
	self.Garau.Triggers.CrawlerB:AddTimer(self.Garau.TimersRef.Crawler)
	self.Garau.Triggers.Porter = KBM.Trigger:Create(GU.Lang.Say.Power[KBM.Lang], "say", self.Garau)
	self.Garau.Triggers.Porter:AddTimer(self.Garau.TimersRef.Porter)
	self.Garau.Triggers.Essence = KBM.Trigger:Create(GU.Lang.Say.Arcane[KBM.Lang], "notify", self.Garau)
	self.Garau.Triggers.Essence:AddTimer(self.Garau.TimersRef.Essence)
	
	self.Garau.CastBar = KBM.CastBar:Add(self, self.Garau, true)
end