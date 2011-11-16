-- Ereandorn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPEN_Settings = nil
ROTP = KBMROTP_Register()

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

local KBM = KBM_RegisterMod(EN.Ereandorn.ID, EN)

EN.Lang.Ereandorn = KBM.Language:Add(EN.Ereandorn.Name)

-- Notify Dictionary
EN.Lang.Ereandorn.Notify = {}
EN.Lang.Ereandorn.Notify.Burn = KBM.Language:Add("Ereandorn says, (%a*), how does it feel to burn")
EN.Lang.Ereandorn.Notify.Fuel = KBM.Language:Add("The corpse of (%a*) will fuel our conquest")
EN.Lang.Ereandorn.Notify.Bomb = KBM.Language:Add("I will rebuild this world in flames!")

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
			Burn = true,
			Fuel = true,
			Bomb = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMEN_Settings = self.Settings
end

function EN:LoadVars()
	if type(KBMGSBEN_Settings) == "table" then
		for Setting, Value in pairs(KBMGSBEN_Settings) do
			if type(KBMGSBEN_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMGSBEN_Settings[Setting]) do
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

function EN:SaveVars()
	KBMGSBEN_Settings = self.Settings
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

function EN.Ereandorn:Options()
	-- Timer Options
	function self:TimersEnabled(bool)
		EN.Settings.Timers.Enabled = bool
	end
	-- Alert Options
	function self:AlertsEnabled(bool)
		EN.Settings.Alerts.Enabled = bool
	end
	function self:BurnAlert(bool)
		EN.Settings.Alerts.Burn = bool
		EN.Ereandorn.AlertsRef.Burn.Enabled = bool
	end
	function self:FuelAlert(bool)
		EN.Settings.Alerts.Fuel = bool
		EN.Ereandorn.AlertsRef.Fuel.Enabled = bool
	end
	function self:BombAlert(bool)
		EN.Settings.Alerts.Bomb = bool
		EN.Ereandorn.AlertsRef.Bomb.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	--local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, EN.Settings.Timers.Enabled)
	--Timers:AddCheck(EN.Lang.Flames[KBM.Lang], self.FlamesEnabled, EN.Settings.Timers.FlamesEnabled)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.AlertsEnabled, EN.Settings.Alerts.Enabled)
	-- Alerts:AddCheck("Burn move out alert (temporary name).", self.BurnAlert, EN.Settings.Alerts.Burn)
	-- Alerts:AddCheck("Target Pillar alert (temporary name).", self.FuelAlert, EN.Settings.Alerts.Fuel)
	-- Alerts:AddCheck("Bomb alert (temporary name).", self.BombAlert, EN.Settings.Alerts.Bomb)
	
end

function EN:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Ereandorn.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Ereandorn, true, self.Header)
	self.Ereandorn.MenuItem.Check:SetEnabled(false)
	
	-- Alerts
	-- self.Ereandorn.AlertsRef.Burn = KBM.Alert:Create("Run away!", 5, true, false, "red")
	-- self.Ereandorn.AlertsRef.Fuel = KBM.Alert:Create("Pillar", 5, true, false, "orange")
	-- self.Ereandorn.AlertsRef.Bomb = KBM.Alert:Create("Bomb!", 5, true, false, "orange")
		
	-- Assign mechanics to Triggers
	-- self.Ereandorn.Triggers.Burn = KBM.Trigger:Create(self.Lang.Ereandorn.Notify.Burn[KBM.Lang], "notify", self.Ereandorn)
	-- self.Ereandorn.Triggers.Burn:AddAlert(self.Ereandorn.AlertsRef.Burn, true)
	-- self.Ereandorn.Triggers.Fuel = KBM.Trigger:Create(self.Lang.Ereandorn.Notify.Fuel[KBM.Lang], "notify", self.Ereandorn)
	-- self.Ereandorn.Triggers.Fuel:AddAlert(self.Ereandorn.AlertsRef.Fuel)
	-- self.Ereandorn.Triggers.Bomb = KBM.Trigger:Create(self.Lang.Ereandorn.Notify.Bomb[KBM.Lang], "notify", self.Ereandorn)
	-- self.Ereandorn.Triggers.Bomb:AddAlert(self.Ereandorn.AlertsRef.Bomb)
	
	self.Ereandorn.CastBar = KBM.CastBar:Add(self, self.Ereandorn, true)
end