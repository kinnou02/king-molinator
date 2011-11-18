-- Oracle Aleria Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBOA_Settings = nil
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GSB = KBM.BossMod["Greenscales Blight"]

local OA = {
	ModEnabled = true,
	Aleria = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = GSB.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	ID = "Aleria",
	}

OA.Aleria = {
	Mod = OA,
	Level = "??",
	Active = false,
	Name = "Oracle Aleria",
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

KBM.RegisterMod(OA.ID, OA)

OA.Lang.Aleria = KBM.Language:Add(OA.Aleria.Name)
OA.Lang.Aleria.German = "Orakel Aleria"
-- OA.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- OA.Lang.Flames.French = "Flammes anciennes"

OA.Aleria.Name = OA.Lang.Aleria[KBM.Lang]

function OA:AddBosses(KBM_Boss)
	self.Aleria.Descript = self.Aleria.Name
	self.MenuName = self.Aleria.Descript
	self.Bosses = {
		[self.Aleria.Name] = true,
	}
	KBM_Boss[self.Aleria.Name] = self.Aleria	
end

function OA:InitVars()
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
	KBMOA_Settings = self.Settings
end

function OA:LoadVars()
	if type(KBMGSBOA_Settings) == "table" then
		for Setting, Value in pairs(KBMGSBOA_Settings) do
			if type(KBMGSBOA_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMGSBOA_Settings[Setting]) do
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

function OA:SaveVars()
	KBMGSBOA_Settings = self.Settings
end

function OA:Castbar(units)
end

function OA:RemoveUnits(UnitID)
	if self.Aleria.UnitID == UnitID then
		self.Aleria.Available = false
		return true
	end
	return false
end

function OA:Death(UnitID)
	if self.Aleria.UnitID == UnitID then
		self.Aleria.Dead = true
		return true
	end
	return false
end

function OA:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Aleria.Name then
				if not self.Aleria.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Aleria.Dead = false
					self.Aleria.Casting = false
					self.Aleria.CastBar:Create(unitID)
				end
				self.Aleria.UnitID = unitID
				self.Aleria.Available = true
				return self.Aleria
			end
		end
	end
end

function OA:Reset()
	self.EncounterRunning = false
	self.Aleria.Available = false
	self.Aleria.UnitID = nil
	self.Aleria.CastBar:Remove()
end

function OA:Timer()
	
end

function OA.Aleria:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		OA.Settings.Timers.FlamesEnabled = bool
		OA.Aleria.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, OA.Settings.Timers.Enabled)
	--Timers:AddCheck(OA.Lang.Flames[KBM.Lang], self.FlamesEnabled, OA.Settings.Timers.FlamesEnabled)	
	
end

function OA:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Aleria.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Aleria, true, self.Header)
	self.Aleria.MenuItem.Check:SetEnabled(false)
	-- self.Aleria.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Aleria.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Aleria.CastBar = KBM.CastBar:Add(self, self.Aleria, true)
end