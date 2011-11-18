-- Plutonus the Immortal Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSPI_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROS = KBM.BossMod["River of Souls"]

local PI = {
	ModEnabled = true,
	Plutonus = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = ROS.Name,
	Type = "20man",
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	ID = "Plutonus",
}

PI.Plutonus = {
	Mod = PI,
	Level = "??",
	Active = false,
	Name = "Plutonus the Immortal",
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

KBM.RegisterMod(PI.ID, PI)

PI.Lang.Plutonus = KBM.Language:Add(PI.Plutonus.Name)
PI.Lang.Plutonus.German = "Plutonus der Unsterbliche"
PI.Lang.Plutonus.French = "Plutonus l'Immortel"

PI.Plutonus.Name = PI.Lang.Plutonus[KBM.Lang]

function PI:AddBosses(KBM_Boss)
	self.Plutonus.Descript = self.Plutonus.Name
	self.MenuName = self.Plutonus.Descript
	self.Bosses = {
		[self.Plutonus.Name] = true,
	}
	KBM_Boss[self.Plutonus.Name] = self.Plutonus	
end

function PI:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			FlamesEnabled = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMPI_Settings = self.Settings
end

function PI:LoadVars()
	if type(KBMROSPI_Settings) == "table" then
		for Setting, Value in pairs(KBMROSPI_Settings) do
			if type(KBMROSPI_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMROSPI_Settings[Setting]) do
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

function PI:SaveVars()
	KBMROSPI_Settings = self.Settings
end

function PI:Castbar(units)
end

function PI:RemoveUnits(UnitID)
	if self.Plutonus.UnitID == UnitID then
		self.Plutonus.Available = false
		return true
	end
	return false
end

function PI:Death(UnitID)
	if self.Plutonus.UnitID == UnitID then
		self.Plutonus.Dead = true
		return true
	end
	return false
end

function PI:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Plutonus.Name then
				if not self.Plutonus.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Plutonus.Dead = false
					self.Plutonus.Casting = false
					self.Plutonus.CastBar:Create(unitID)
				end
				self.Plutonus.UnitID = unitID
				self.Plutonus.Available = true
				return self.Plutonus
			end
		end
	end
end

function PI:Reset()
	self.EncounterRunning = false
	self.Plutonus.Available = false
	self.Plutonus.UnitID = nil
	self.Plutonus.CastBar:Remove()
end

function PI:Timer()
	
end

function PI.Plutonus:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		PI.Settings.Timers.FlamesEnabled = bool
		PI.Plutonus.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, PI.Settings.Timers.Enabled)
	--Timers:AddCheck(PI.Lang.Flames[KBM.Lang], self.FlamesEnabled, PI.Settings.Timers.FlamesEnabled)	
	
end

function PI:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Plutonus.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Plutonus, true, self.Header)
	self.Plutonus.MenuItem.Check:SetEnabled(false)
	-- self.Plutonus.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Plutonus.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Plutonus.CastBar = KBM.CastBar:Add(self, self.Plutonus, true)
end