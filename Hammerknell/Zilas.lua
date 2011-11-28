-- Soulrender Zilas Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSZ_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local SZ = {
	ModEnabled = true,
	Zilas = {
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
	ID = "Zilas",
}

SZ.Zilas = {
	Mod = SZ,
	Level = "??",
	Active = false,
	Name = "Soulrender Zilas",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
}

KBM.RegisterMod(SZ.ID, SZ)

SZ.Lang.Zilas = KBM.Language:Add(SZ.Zilas.Name)
SZ.Lang.Zilas.German = "Seelenreißer Zilas"
SZ.Lang.Zilas.French = "\195\137tripeur d'\195\162mes Zilas"
SZ.Zilas.Name = SZ.Lang.Zilas[KBM.Lang]

-- Ability Dictionary
SZ.Lang.Ability = {}
SZ.Lang.Ability.Grasp = KBM.Language:Add("Soulrender's Grasp")
SZ.Lang.Ability.Grasp.German = "Seelenreißer Griff"

function SZ:AddBosses(KBM_Boss)
	self.Zilas.Descript = self.Zilas.Name
	self.MenuName = self.Zilas.Descript
	self.Bosses = {
		[self.Zilas.Name] = true,
	}
	KBM_Boss[self.Zilas.Name] = self.Zilas	
end

function SZ:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			Grasp = true,
		},
		Alerts = {
			Enabled = true,
			Grasp = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMSZ_Settings = self.Settings
	chKBMSZ_Settings = self.Settings
	
end

function SZ:SwapSettings(bool)

	if bool then
		KBMSZ_Settings = self.Settings
		self.Settings = chKBMSZ_Settings
	else
		chKBMSZ_Settings = self.Settings
		self.Settings = KBMSZ_Settings
	end

end

function SZ:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMSZ_Settings
	else
		TargetLoad = KBMSZ_Settings
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
		chKBMSZ_Settings = self.Settings
	else
		KBMSZ_Settings = self.Settings
	end
	
end

function SZ:SaveVars()
	
	if KBM.Options.Settings then
		chKBMSZ_Settings = self.Settings
	else
		KBMSZ_Settings = self.Settings
	end
	
end

function SZ:Castbar(units)
end

function SZ:RemoveUnits(UnitID)
	if self.Zilas.UnitID == UnitID then
		self.Zilas.Available = false
		return true
	end
	return false
end

function SZ:Death(UnitID)
	if self.Zilas.UnitID == UnitID then
		self.Zilas.Dead = true
		return true
	end
	return false
end

function SZ:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Zilas.Name then
				if not self.Zilas.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Zilas.Dead = false
					self.Zilas.Casting = false
					self.Zilas.CastBar:Create(unitID)
				end
				self.Zilas.UnitID = unitID
				self.Zilas.Available = true
				return self.Zilas
			end
		end
	end
end

function SZ:Reset()
	self.EncounterRunning = false
	self.Zilas.Available = false
	self.Zilas.UnitID = nil
	self.Zilas.CastBar:Remove()
end

function SZ:Timer()
	
end

function SZ:SetTimers(bool)

	if bool then
		self.Zilas.TimersRef.Grasp.Enabled = self.Settings.Timers.Grasp		
	else
		self.Zilas.TimersRef.Grasp.Enabled = false
	end

end

function SZ:SetAlerts(bool)

	if bool then
		self.Zilas.AlertsRef.GraspWarn.Enabled = self.Settings.Alerts.Grasp
		self.Zilas.AlertsRef.Grasp.Enabled = self.Settings.Alerts.Grasp
	else
		self.Zilas.AlertsRef.GraspWarn.Enabled = false
		self.Zilas.AlertsRef.Grasp.Enabled = false
	end

end

function SZ.Zilas:Options()

	-- Timer Options.
	function self:Timers(bool)
		SZ.Settings.Timers.Enabled = bool
		SZ:SetTimers(bool)
	end
	function self:GraspTimer(bool)
		SZ.Settings.Timers.Grasp = bool
		SZ.Zilas.TimersRef.Grasp.Enabled = bool
	end
	-- Alert Options.
	function self:Alerts(bool)
		SZ.Settings.Alerts.Enabled = bool
		SZ:SetAlerts(bool)
	end
	function self:GraspAlert(bool)
		SZ.Settings.Alerts.Grasp = bool
		SZ.Zilas.AlertsRef.Grasp.Enabled = bool
	end
	
	-- Menu Options.
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.Timers, SZ.Settings.Timers.Enabled)
	Timers:AddCheck(SZ.Lang.Ability.Grasp[KBM.Lang], self.GraspTimer, SZ.Settings.Timers.Grasp)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, SZ.Settings.Alerts.Enabled)
	Alerts:AddCheck(SZ.Lang.Ability.Grasp[KBM.Lang], self.GraspAlert, SZ.Settings.Alerts.Grasp)
	
end

function SZ:Start()

	-- Initiate Main Menu option.
	self.Header = KBM.HeaderList[self.Instance]
	self.Zilas.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Zilas, true, self.Header)
	self.Zilas.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	self.Zilas.TimersRef.Grasp = KBM.MechTimer:Add(self.Lang.Ability.Grasp[KBM.Lang], 60)
	self:SetTimers(bool)
	
	-- Create Alerts
	self.Zilas.AlertsRef.GraspWarn = KBM.Alert:Create(self.Lang.Ability.Grasp[KBM.Lang], 5, true, true, "orange")
	self.Zilas.AlertsRef.Grasp = KBM.Alert:Create(self.Lang.Ability.Grasp[KBM.Lang], 9, false, true, "red")
	
	-- Assign Mechanics to Triggers.
	self.Zilas.Triggers.Grasp = KBM.Trigger:Create(self.Lang.Ability.Grasp[KBM.Lang], "cast", self.Zilas)
	self.Zilas.Triggers.Grasp:AddTimer(self.Zilas.TimersRef.Grasp)
	self.Zilas.Triggers.Grasp:AddAlert(self.Zilas.AlertsRef.GraspWarn)
	self.Zilas.AlertsRef.GraspWarn:AlertEnd(self.Zilas.AlertsRef.Grasp)
	
	-- Assign Castbar object.
	self.Zilas.CastBar = KBM.CastBar:Add(self, self.Zilas, true)
	
end