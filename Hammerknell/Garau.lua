-- Inquisitor Garau Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGU_Settings = nil
chKBMGU_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local GU = {
	Enabled = true,
	Instance = HK.Name,
	Lang = {},
	Enrage = 60 * 12,
	ID = "Garau",
}

GU.Garau = {
	Mod = GU,
	Level = "??",
	Active = false,
	Name = "Inquisitor Garau",
	NameShort = "Garau",
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Descript = "Inquisitor Garau",
	TimeOut = 3,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Blood = KBM.Defaults.TimerObj.Create("red"),
			Porter = KBM.Defaults.TimerObj.Create("purple"),
			Essence = KBM.Defaults.TimerObj.Create("orange"),
			Crawler = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = false,
		},
	},
}

KBM.RegisterMod(GU.ID, GU)

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
	self.Garau.Descript = self.Garau.Name
	self.MenuName = self.Garau.Name
	self.Bosses = {
		[self.Garau.Name] = self.Garau,
	}
	KBM_Boss[self.Garau.Name] = self.Garau	
end

function GU:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),		
		CastBar = self.Garau.Settings.CastBar,
		TimersRef = self.Garau.Settings.TimersRef,
		AlertsRef = self.Garau.Settings.AlertsRef,
	}
	KBMGU_Settings = self.Settings
	chKBMGU_Settings = self.Settings
	
end

function GU:SwapSettings(bool)
	if bool then
		KBMGU_Settings = self.Settings
		self.Settings = chKBMGU_Settings
	else
		chKBMGU_Settings = self.Settings
		self.Settings = KBMGU_Settings
	end
end

function GU:LoadVars()
	local TargetLoad = nil	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGU_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGU_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMGU_Settings = self.Settings
	else
		KBMGU_Settings = self.Settings
	end	
end

function GU:SaveVars()
	if KBM.Options.Character then
		chKBMGU_Settings = self.Settings
	else
		KBMGU_Settings = self.Settings
	end	
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

function GU:UnitHPCheck(uDetails, unitID)
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Garau.Name then
				if not self.Garau.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Garau.CastBar:Create(unitID)
				end
				self.Garau.Dead = false
				self.Garau.Casting = false
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

function GU.Garau:SetTimers(bool)	
	if bool then
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function GU.Garau:SetAlerts(bool)
	if bool then
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end

function GU:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Garau, self.Enabled)
end

function GU:Start()
	-- Create Timers
	self.Garau.TimersRef.Blood = KBM.MechTimer:Add(GU.Lang.Ability.Blood[KBM.Lang], 18)
	self.Garau.TimersRef.Crawler = KBM.MechTimer:Add(self.Lang.Unit.Crawler[KBM.Lang], 30)
	self.Garau.TimersRef.Porter = KBM.MechTimer:Add(GU.Lang.Unit.Porter[KBM.Lang], 45)
	self.Garau.TimersRef.Essence = KBM.MechTimer:Add(GU.Lang.Ability.Arcane[KBM.Lang], 20)

	KBM.Defaults.TimerObj.Assign(self.Garau)
	
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
	self:DefineMenu()
end