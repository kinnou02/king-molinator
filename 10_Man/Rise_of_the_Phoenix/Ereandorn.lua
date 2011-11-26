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
	ModEnabled = true,
	Ereandorn = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = ROTP.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	ID = "Ereandorn",
	}

EN.Ereandorn = {
	Mod = EN,
	Level = "??",
	Active = false,
	Name = "Ereandorn",
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

KBM.RegisterMod(EN.ID, EN)

EN.Lang.Ereandorn = KBM.Language:Add(EN.Ereandorn.Name)

-- Notify Dictionary
EN.Lang.Notify = {}
EN.Lang.Notify.Combustion = KBM.Language:Add('Ereandorn says, "(%a*), how does it feel to burn?"')
EN.Lang.Notify.Combustion.German = 'Ereandorn sagt: "(%a*), wie fühlt es sich an, zu verbrennen?"'
EN.Lang.Notify.Growth = KBM.Language:Add("The corpse of (%a*) will fuel our conquest")
EN.Lang.Notify.Growth.German = "Der Leichnam von (%a*) wird unsere Eroberung vorantreiben!"
EN.Lang.Notify.Eruption = KBM.Language:Add("I will rebuild this world in flames!")
EN.Lang.Notify.Eruption.German = "Ich werde diese Welt in Flammen neu formen!"

-- Ability Dictionary
EN.Lang.Ability = {}
EN.Lang.Ability.Combustion = KBM.Language:Add("Excitable Combustion")
EN.Lang.Ability.Combustion.German = "Aufgeregte Verbrennung"
EN.Lang.Ability.Growth = KBM.Language:Add("Molten Growth")
EN.Lang.Ability.Growth.German = KBM.Language:Add("Geschmolzener Wuchs")
EN.Lang.Ability.Eruption = KBM.Language:Add("Volcanic Eruption")
EN.Lang.Ability.Eruption.German = "Vulkanausbruch"

EN.Ereandorn.Name = EN.Lang.Ereandorn[KBM.Lang]

function EN:AddBosses(KBM_Boss)
	self.Ereandorn.Descript = self.Ereandorn.Name
	self.MenuName = self.Ereandorn.Descript
	self.Bosses = {
		[self.Ereandorn.Name] = true,
	}
	KBM_Boss[self.Ereandorn.Name] = self.Ereandorn	
end

function EN:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
		},
		Alerts = {
			Enabled = true,
			Combustion = true,
			Growth = true,
			Eruption = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
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
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMROTPEN_Settings
	else
		TargetLoad = KBMROTPEN_Settings
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
					self.Ereandorn.Dead = false
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
end

function EN:Timer()
	
end

function EN:SetTimers(bool)
	
	if bool then
	
	else
	
	end
	
end

function EN:SetAlerts(bool)

	if bool then
		self.Ereandorn.AlertsRef.Combustion.Enabled = self.Settings.Alerts.Combustion
		self.Ereandorn.AlertsRef.Growth.Enabled = self.Settings.Alerts.Growth
		self.Ereandorn.AlertsRef.Eruption.Enabled = self.Settings.Alerts.Eruption
	else
		self.Ereandorn.AlertsRef.Combustion.Enabled = false
		self.Ereandorn.AlertsRef.Growth.Enabled = false
		self.Ereandorn.AlertsRef.Eruption.Enabled = false
	end

end

function EN.Ereandorn:Options()
	-- Timer Options
	function self:TimersEnabled(bool)
		EN.Settings.Timers.Enabled = bool
		EN:SetTimers(bool)
	end
	-- Alert Options
	function self:AlertsEnabled(bool)
		EN.Settings.Alerts.Enabled = bool
		EN:SetAlerts(bool)
	end
	function self:CombustionAlert(bool)
		EN.Settings.Alerts.Combustion = bool
		EN.Ereandorn.AlertsRef.Combustion.Enabled = bool
	end
	function self:GrowthAlert(bool)
		EN.Settings.Alerts.Growth = bool
		EN.Ereandorn.AlertsRef.Growth.Enabled = bool
	end
	function self:EruptionAlert(bool)
		EN.Settings.Alerts.Eruption = bool
		EN.Ereandorn.AlertsRef.Eruption.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	--local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, EN.Settings.Timers.Enabled)
	--Timers:AddCheck(EN.Lang.Flames[KBM.Lang], self.FlamesEnabled, EN.Settings.Timers.FlamesEnabled)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.AlertsEnabled, EN.Settings.Alerts.Enabled)
	Alerts:AddCheck(EN.Lang.Ability.Combustion[KBM.Lang]..".", self.CombustionAlert, EN.Settings.Alerts.Combustion)
	Alerts:AddCheck(EN.Lang.Ability.Growth[KBM.Lang]..".", self.GrowthAlert, EN.Settings.Alerts.Growth)
	Alerts:AddCheck(EN.Lang.Ability.Eruption[KBM.Lang]..".", self.EruptionAlert, EN.Settings.Alerts.Eruption)
	
end

function EN:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Ereandorn.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Ereandorn, true, self.Header)
	self.Ereandorn.MenuItem.Check:SetEnabled(false)
	
	-- Alerts
	self.Ereandorn.AlertsRef.Combustion = KBM.Alert:Create(self.Lang.Ability.Combustion[KBM.Lang], 5, true, false, "red")
	self.Ereandorn.AlertsRef.Growth = KBM.Alert:Create(self.Lang.Ability.Growth[KBM.Lang], 8, true, true, "orange")
	self.Ereandorn.AlertsRef.Eruption = KBM.Alert:Create(self.Lang.Ability.Eruption[KBM.Lang], 5, true, false, "orange")
	self:SetAlerts(self.Settings.Alerts.Enabled)
		
	-- Assign mechanics to Triggers
	self.Ereandorn.Triggers.Combustion = KBM.Trigger:Create(self.Lang.Notify.Combustion[KBM.Lang], "notify", self.Ereandorn)
	self.Ereandorn.Triggers.Combustion:AddAlert(self.Ereandorn.AlertsRef.Combustion, true)
	self.Ereandorn.Triggers.Growth = KBM.Trigger:Create(self.Lang.Notify.Growth[KBM.Lang], "notify", self.Ereandorn)
	self.Ereandorn.Triggers.Growth:AddAlert(self.Ereandorn.AlertsRef.Growth)
	self.Ereandorn.Triggers.Eruption = KBM.Trigger:Create(self.Lang.Notify.Eruption[KBM.Lang], "notify", self.Ereandorn)
	self.Ereandorn.Triggers.Eruption:AddAlert(self.Ereandorn.AlertsRef.Eruption)
	
	self.Ereandorn.CastBar = KBM.CastBar:Add(self, self.Ereandorn, true)
end