-- Beruhast Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPBT_Settings = nil
chKBMROTPBT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROTP = KBM.BossMod["Rise of the Phoenix"]

local BT = {
	ModEnabled = true,
	Beruhast = {
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
	ID = "Beruhast",
	}

BT.Beruhast = {
	Mod = BT,
	Level = "??",
	Active = false,
	Name = "Beruhast",
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

KBM.RegisterMod(BT.ID, BT)

BT.Lang.Beruhast = KBM.Language:Add(BT.Beruhast.Name)

-- Ability Dictionary
BT.Lang.Ability = {}
BT.Lang.Ability.Inferno = KBM.Language:Add("Inferno Lash")
BT.Lang.Ability.Inferno.French = "Fouet des limbes"
BT.Lang.Ability.Inferno.German = "Infernopeitsche"
BT.Lang.Ability.Flame = KBM.Language:Add("Leaping Flame")
BT.Lang.Ability.Flame.French = "Flamme bondissante"
BT.Lang.Ability.Flame.German = "Springende Flamme"
BT.Lang.Ability.Vortex = KBM.Language:Add("Flaming Vortex")
BT.Lang.Ability.Vortex.French = "Embrasement"
BT.Lang.Ability.Vortex.German = "Flammenwirbel"

-- Unit Dictionary
BT.Lang.Unit = {}
BT.Lang.Unit.Summon = KBM.Language:Add("Summoned Flame")
BT.Lang.Unit.Summon.German = "Beschworene Flamme"

-- Notify Dictionary
BT.Lang.Notify = {}
BT.Lang.Notify.Summon = KBM.Language:Add('Beruhast says, "A pet from Maelforge should keep you warm."')
BT.Lang.Notify.Summon.German = 'Beruhast sagt: "Ein Begleiter von Flammenmaul sollte Euch warmhalten."'

BT.Beruhast.Name = BT.Lang.Beruhast[KBM.Lang]

function BT:AddBosses(KBM_Boss)
	self.Beruhast.Descript = self.Beruhast.Name
	self.MenuName = self.Beruhast.Descript
	self.Bosses = {
		[self.Beruhast.Name] = true,
	}
	KBM_Boss[self.Beruhast.Name] = self.Beruhast	
end

function BT:InitVars()

	self.Settings = {
		Timers = {
			Enabled = true,
			Flame = true,
			Summon = true,
		},
		Alerts = {
			Enabled = true,
			Inferno = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMROTPBT_Settings = self.Settings
	chKBMROTPBT_Settings = self.Settings
	
end

function BT:SwapSettings(bool)

	if bool then
		KBMROTPBT_Settings = self.Settings
		self.Settings = chKBMROTPBT_Settings
	else
		chKBMROTPBT_Settings = self.Settings
		self.Settings = KBMROTPBT_Settings
	end

end

function BT:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMROTPBT_Settings
	else
		TargetLoad = KBMROTPBT_Settings
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
		chKBMROTPBT_Settings = self.Settings
	else
		KBMROTPBT_Settings = self.Settings
	end
	
end

function BT:SaveVars()
	
	if KBM.Options.Character then
		chKBMROTPBT_Settings = self.Settings
	else
		KBMROTPBT_Settings = self.Settings
	end
	
end

function BT:Castbar(units)
end

function BT:RemoveUnits(UnitID)
	if self.Beruhast.UnitID == UnitID then
		self.Beruhast.Available = false
		return true
	end
	return false
end

function BT:Death(UnitID)
	if self.Beruhast.UnitID == UnitID then
		self.Beruhast.Dead = true
		return true
	end
	return false
end

function BT:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Beruhast.Name then
				if not self.Beruhast.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Beruhast.Dead = false
					self.Beruhast.Casting = false
					self.Beruhast.CastBar:Create(unitID)
					self.Beruhast.TimersRef.FlameStart:Start(Inspect.Time.Real())
				end
				self.Beruhast.UnitID = unitID
				self.Beruhast.Available = true
				return self.Beruhast
			end
		end
	end
end

function BT:Reset()
	self.EncounterRunning = false
	self.Beruhast.Available = false
	self.Beruhast.UnitID = nil
	self.Beruhast.CastBar:Remove()
end

function BT:Timer()
	
end

function BT:SetTimers(bool)

	if bool then
		self.Beruhast.TimersRef.Flame.Enabled = self.Settings.Timers.Flame
		self.Beruhast.TimersRef.FlameStart.Enabled = self.Settings.Timers.Flame
		self.Beruhast.TimersRef.Summon.Enabled = self.Settings.Timers.Summon
	else
		self.Beruhast.TimersRef.Flame.Enabled = false
		self.Beruhast.TimersRef.FlameStart.Enabled = false
		self.Beruhast.TimersRef.Summon.Enabled = false
	end

end

function BT:SetAlerts(bool)

	if bool then
		self.Beruhast.AlertsRef.Inferno.Enabled = self.Settings.Alerts.Inferno	
	else
		self.Beruhast.AlertsRef.Inferno.Enabled = false	
	end

end

function BT.Beruhast:Options()

	-- Timer Settings
	function self:Timers(bool)
		BT.Settings.Timers.Enabled = bool
		BT:SetTimers(bool)
	end
	function self:FlameTimer(bool)
		BT.Settings.Timers.Flame = bool
		BT.Beruhast.TimersRef.Flame.Enabled = bool
		BT.Beruhast.TimersRef.FlameStart.Enabled = bool
	end
	function self:SummonTimer(bool)
		BT.Settings.Timers.Summon = bool
		BT.Beruhast.TimersRef.Summon.Enabled = bool
	end
	
	-- Alert Settings
	function self:Alerts(bool)
		BT.Settings.Alerts.Enabled = bool
		BT:SetAlerts(bool)
	end
	function self:InfernoAlert(bool)
		BT.Settings.Alerts.Inferno = bool
		BT.Beruhast.AlertsRef.Inferno.Enabled = bool
	end
	
	-- Menu options.
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.Timers, BT.Settings.Timers.Enabled)
	Timers:AddCheck(BT.Lang.Ability.Flame[KBM.Lang], self.FlameTimer, BT.Settings.Timers.Flame)
	Timers:AddCheck(BT.Lang.Unit.Summon[KBM.Lang], self.SummonTimer, BT.Settings.Timers.Summon)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, BT.Settings.Alerts.Enabled)
	Alerts:AddCheck(BT.Lang.Ability.Inferno[KBM.Lang], self.InfernoAlert, BT.Settings.Alerts.Inferno)
	
end

function BT:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Beruhast.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Beruhast, true, self.Header)
	self.Beruhast.MenuItem.Check:SetEnabled(false)
	
	-- Alerts
	self.Beruhast.AlertsRef.Inferno = KBM.Alert:Create(self.Lang.Ability.Inferno[KBM.Lang], 2, true, true, "yellow")
	self:SetAlerts(self.Settings.Alerts.Enabled)
	
	-- Timers
	self.Beruhast.TimersRef.Flame = KBM.MechTimer:Add(self.Lang.Ability.Flame[KBM.Lang], 70)
	self.Beruhast.TimersRef.FlameStart = KBM.MechTimer:Add(self.Lang.Ability.Flame[KBM.Lang], 30)
	self.Beruhast.TimersRef.Summon = KBM.MechTimer:Add(self.Lang.Unit.Summon[KBM.Lang], 70)
	self:SetTimers(self.Settings.Timers.Enabled)
	
	-- Assign Mechanics to Triggers
	self.Beruhast.Triggers.Inferno = KBM.Trigger:Create(self.Lang.Ability.Inferno[KBM.Lang], "cast", self.Beruhast)
	self.Beruhast.Triggers.Inferno:AddAlert(self.Beruhast.AlertsRef.Inferno)
	self.Beruhast.Triggers.Flame = KBM.Trigger:Create(self.Lang.Ability.Flame[KBM.Lang], "cast", self.Beruhast)
	self.Beruhast.Triggers.Flame:AddTimer(self.Beruhast.TimersRef.Flame)
	self.Beruhast.Triggers.Summon = KBM.Trigger:Create(self.Lang.Notify.Summon[KBM.Lang], "notify", self.Beruhast)
	self.Beruhast.Triggers.Summon:AddTimer(self.Beruhast.TimersRef.Summon)
	
	self.Beruhast.CastBar = KBM.CastBar:Add(self, self.Beruhast, true)
end