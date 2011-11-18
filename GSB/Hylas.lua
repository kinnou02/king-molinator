-- Prince Hylas Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBPH_Settings = nil
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GSB = KBM.BossMod["Greenscales Blight"]

local PH = {
	ModEnabled = true,
	Hylas = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = GSB.Name,
	Type = "20man",
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	ID = "Hylas",	
}

PH.Hylas = {
	Mod = PH,
	Level = "??",
	Active = false,
	Name = "Prince Hylas",
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

KBM.RegisterMod(PH.ID, PH)

PH.Lang.Hylas = KBM.Language:Add(PH.Hylas.Name)
PH.Lang.Hylas.German = "Prinz Hylas"
-- PH.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- PH.Lang.Flames.French = "Flammes anciennes"

PH.Hylas.Name = PH.Lang.Hylas[KBM.Lang]

function PH:AddBosses(KBM_Boss)
	self.Hylas.Descript = self.Hylas.Name
	self.MenuName = self.Hylas.Descript
	self.Bosses = {
		[self.Hylas.Name] = true,
	}
	KBM_Boss[self.Hylas.Name] = self.Hylas	
end

function PH:InitVars()
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
	KBMPH_Settings = self.Settings
end

function PH:LoadVars()
	if type(KBMGSBPH_Settings) == "table" then
		for Setting, Value in pairs(KBMGSBPH_Settings) do
			if type(KBMGSBPH_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMGSBPH_Settings[Setting]) do
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

function PH:SaveVars()
	KBMGSBPH_Settings = self.Settings
end

function PH:Castbar(units)
end

function PH:RemoveUnits(UnitID)
	if self.Hylas.UnitID == UnitID then
		self.Hylas.Available = false
		return true
	end
	return false
end

function PH:Death(UnitID)
	if self.Hylas.UnitID == UnitID then
		self.Hylas.Dead = true
		return true
	end
	return false
end

function PH:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Hylas.Name then
				if not self.Hylas.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Hylas.Dead = false
					self.Hylas.Casting = false
					self.Hylas.CastBar:Create(unitID)
				end
				self.Hylas.UnitID = unitID
				self.Hylas.Available = true
				return self.Hylas
			end
		end
	end
end

function PH:Reset()
	self.EncounterRunning = false
	self.Hylas.Available = false
	self.Hylas.UnitID = nil
	self.Hylas.CastBar:Remove()
end

function PH:Timer()
	
end

function PH.Hylas:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		PH.Settings.Timers.FlamesEnabled = bool
		PH.Hylas.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, PH.Settings.Timers.Enabled)
	--Timers:AddCheck(PH.Lang.Flames[KBM.Lang], self.FlamesEnabled, PH.Settings.Timers.FlamesEnabled)	
	
end

function PH:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Hylas.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Hylas, true, self.Header)
	self.Hylas.MenuItem.Check:SetEnabled(false)
	-- self.Hylas.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Hylas.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Hylas.CastBar = KBM.CastBar:Add(self, self.Hylas, true)
end