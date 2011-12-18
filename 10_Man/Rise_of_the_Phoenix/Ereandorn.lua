-- Ereandorn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPEN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROTP = KBM.BossMod["Rise of the Phoenix"]

local EN = {
	Enabled = true,
	Instance = ROTP.Name,
	HasPhases = false,
	Lang = {},
	TankSwap = false,
	ID = "Ereandorn",
	Menu = {},
}

EN.Ereandorn = {
	Mod = EN,
	Level = "52",
	Active = false,
	Name = "Ereandorn",
	Menu = {},
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = false,
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Combustion = KBM.Defaults.AlertObj.Create("red"),
			Growth = KBM.Defaults.AlertObj.Create("red"),
			Eruption = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(EN.ID, EN)

EN.Lang.Ereandorn = KBM.Language:Add(EN.Ereandorn.Name)

-- Notify Dictionary
EN.Lang.Notify = {}
EN.Lang.Notify.Combustion = KBM.Language:Add('Ereandorn says, "(%a*), how does it feel to burn?"')
EN.Lang.Notify.Combustion.German = 'Ereandorn sagt: "(%a*), wie fühlt es sich an, zu verbrennen?"'
EN.Lang.Notify.Growth = KBM.Language:Add("The corpse of (%a*) will fuel our conquest")
EN.Lang.Notify.Growth.German = "Der Leichnam von (%a*) wird unsere Eroberung vorantreiben"
EN.Lang.Notify.Eruption = KBM.Language:Add("I will rebuild this world in flames!")
EN.Lang.Notify.Eruption.German = "Ich werde diese Welt in Flammen neu formen!"

-- Ability Dictionary
EN.Lang.Ability = {}
EN.Lang.Ability.Combustion = KBM.Language:Add("Excitable Combustion")
EN.Lang.Ability.Combustion.German = "Aufgeregte Verbrennung"
EN.Lang.Ability.Growth = KBM.Language:Add("Molten Growth")
EN.Lang.Ability.Growth.German = "Geschmolzener Wuchs"
EN.Lang.Ability.Eruption = KBM.Language:Add("Volcanic Eruption")
EN.Lang.Ability.Eruption.German = "Vulkanausbruch"

EN.Ereandorn.Name = EN.Lang.Ereandorn[KBM.Lang]

function EN:AddBosses(KBM_Boss)
	self.Ereandorn.Descript = self.Ereandorn.Name
	self.MenuName = self.Ereandorn.Descript
	self.Bosses = {
		[self.Ereandorn.Name] = self.Ereandorn,
	}
	KBM_Boss[self.Ereandorn.Name] = self.Ereandorn	
end

function EN:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ereandorn.Settings.CastBar,
		AlertsRef = self.Ereandorn.Settings.AlertsRef,
		EncTimer = KBM.Defaults.EncTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMROTPEN_Settings = self.Settings
	chKBMROTPEN_Settings = self.Settings
	
end

function EN:SwapSettings(bool)
	if bool then
		KBMROTPEN_Settings = self.Settings
		self.Settings = chKBMROTPEN_Settings
	else
		chKBMROTPEN_Settings = self.Settings
		self.Settings = KBMROTPEN_Settings
	end
end

function EN:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROTPEN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROTPEN_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMROTPEN_Settings = self.Settings
	else
		KBMROTPEN_Settings = self.Settings
	end	
end

function EN:SaveVars()	
	if KBM.Options.Character then
		chKBMROTPEN_Settings = self.Settings
	else
		KBMROTPEN_Settings = self.Settings
	end	
end

function EN:Castbar(units)
end

function EN:RemoveUnits(UnitID)
	if self.Ereandorn.UnitID == UnitID then
		self.Ereandorn.Available = false
		return true
	end
	return false
end

function EN:Death(UnitID)
	if self.Ereandorn.UnitID == UnitID then
		self.Ereandorn.Dead = true
		return true
	end
	return false
end

function EN:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Ereandorn.Name then
				if not self.Ereandorn.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ereandorn.Casting = false
					self.Ereandorn.CastBar:Create(unitID)
				end
				self.Ereandorn.UnitID = unitID
				self.Ereandorn.Available = true
				return self.Ereandorn
			end
		end
	end
end

function EN:Reset()
	self.EncounterRunning = false
	self.Ereandorn.Available = false
	self.Ereandorn.UnitID = nil
	self.Ereandorn.CastBar:Remove()
	self.Ereandorn.Dead = false
end

function EN:Timer()	
end

function EN.Ereandorn:SetTimers(bool)	
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

function EN.Ereandorn:SetAlerts(bool)
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

function EN:DefineMenu()
	self.Menu = ROTP.Menu:CreateEncounter(self.Ereandorn, self.Enabled)
end

function EN:Start()
	-- Alerts
	self.Ereandorn.AlertsRef.Combustion = KBM.Alert:Create(self.Lang.Ability.Combustion[KBM.Lang], 5, true, false, "red")
	self.Ereandorn.AlertsRef.Growth = KBM.Alert:Create(self.Lang.Ability.Growth[KBM.Lang], 8, true, true, "red")
	self.Ereandorn.AlertsRef.Eruption = KBM.Alert:Create(self.Lang.Ability.Eruption[KBM.Lang], 5, true, false, "orange")
	KBM.Defaults.AlertObj.Assign(self.Ereandorn)
		
	-- Assign mechanics to Triggers
	self.Ereandorn.Triggers.Combustion = KBM.Trigger:Create(self.Lang.Notify.Combustion[KBM.Lang], "notify", self.Ereandorn)
	self.Ereandorn.Triggers.Combustion:AddAlert(self.Ereandorn.AlertsRef.Combustion, true)
	self.Ereandorn.Triggers.Growth = KBM.Trigger:Create(self.Lang.Notify.Growth[KBM.Lang], "notify", self.Ereandorn)
	self.Ereandorn.Triggers.Growth:AddAlert(self.Ereandorn.AlertsRef.Growth)
	self.Ereandorn.Triggers.Eruption = KBM.Trigger:Create(self.Lang.Notify.Eruption[KBM.Lang], "notify", self.Ereandorn)
	self.Ereandorn.Triggers.Eruption:AddAlert(self.Ereandorn.AlertsRef.Eruption)
	
	self.Ereandorn.CastBar = KBM.CastBar:Add(self, self.Ereandorn)
	self:DefineMenu()
end