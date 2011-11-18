-- General Silgen Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPGS_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROTP = KBM.BossMod["Rise of the Phoenix"]

local GS = {
	ModEnabled = true,
	Silgen = {
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
	ID = "Silgen",
	}

GS.Silgen = {
	Mod = GS,
	Level = "??",
	Active = false,
	Name = "General Silgen",
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

KBM.RegisterMod(GS.ID, GS)

GS.Lang.Silgen = KBM.Language:Add(GS.Silgen.Name)
GS.Lang.Silgen.French = "G\195\169n\195\169ral Silgen"

GS.Silgen.Name = GS.Lang.Silgen[KBM.Lang]

function GS:AddBosses(KBM_Boss)
	self.Silgen.Descript = self.Silgen.Name
	self.MenuName = self.Silgen.Descript
	self.Bosses = {
		[self.Silgen.Name] = true,
	}
	KBM_Boss[self.Silgen.Name] = self.Silgen	
end

function GS:InitVars()
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
	KBMGS_Settings = self.Settings
end

function GS:LoadVars()
	if type(KBMGSBGS_Settings) == "table" then
		for Setting, Value in pairs(KBMGSBGS_Settings) do
			if type(KBMGSBGS_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMGSBGS_Settings[Setting]) do
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

function GS:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function GS:Castbar(units)
end

function GS:RemoveUnits(UnitID)
	if self.Silgen.UnitID == UnitID then
		self.Silgen.Available = false
		return true
	end
	return false
end

function GS:Death(UnitID)
	if self.Silgen.UnitID == UnitID then
		self.Silgen.Dead = true
		return true
	end
	return false
end

function GS:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Silgen.Name then
				if not self.Silgen.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Silgen.Dead = false
					self.Silgen.Casting = false
					self.Silgen.CastBar:Create(unitID)
				end
				self.Silgen.UnitID = unitID
				self.Silgen.Available = true
				return self.Silgen
			end
		end
	end
end

function GS:Reset()
	self.EncounterRunning = false
	self.Silgen.Available = false
	self.Silgen.UnitID = nil
	self.Silgen.CastBar:Remove()
end

function GS:Timer()
	
end

function GS.Silgen:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		GS.Settings.Timers.FlamesEnabled = bool
		GS.Silgen.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, GS.Settings.Timers.Enabled)
	--Timers:AddCheck(GS.Lang.Flames[KBM.Lang], self.FlamesEnabled, GS.Settings.Timers.FlamesEnabled)	
	
end

function GS:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Silgen.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Silgen, true, self.Header)
	self.Silgen.MenuItem.Check:SetEnabled(false)
	-- self.Silgen.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Silgen.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Silgen.CastBar = KBM.CastBar:Add(self, self.Silgen, true)
end