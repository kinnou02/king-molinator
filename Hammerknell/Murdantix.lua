-- Murdantix Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMX_Settings = nil

local MX = {
	ModEnabled = true,
	MenuName = "Murdantix",
	Bosses = {
		["Murdantix"] = true,
	},
	ID = nil,
	Murdantix = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		Name = "Murdantix",
		ID = "Murdantix",
	},
	Instance = "Hammerknell",
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {}
}

local KBM = KBM_RegisterMod("Murdantix", MX)

MX.MurdName = "Murdantix"

MX.Murd = {
	Mod = MX,
	Level = "??",
	Active = false,
	Name = "Murdantix",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Descript = "Murdantix",
}

function MX:AddBosses(KBM_Boss)
	if KBM.Lang == "German" then
	elseif KBM.Lang == "French" then
	end
	KBM_Boss[self.Murd.Name] = self.Murd
end

function MX:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			MangleEnabled = true,
			PoundEnabled = true,
		},
	}
	KBMMX_Settings = self.Settings
end

function MX:LoadVars()
	if type(KBMMX_Settings) == "table" then
		for Setting, Value in pairs(KBMMX_Settings) do
			if type(KBMMX_Settings[Setting]) == "table" then
				if #KBMMX_Settings[Setting] then
					for tSetting, tValue in pairs(KBMMX_Settings[Setting]) do
						self.Settings[Setting][tSetting] = tValue
					end
				end
			else
				self.Settings[Setting] = Value
			end
		end
	end
end

function MX:SaveVars()
	KBMMX_Settings = self.Settings
end

function MX:Castbar(units)
end

function MX:RemoveUnits(UnitID)
	if self.Murd.UnitID == UnitID then
		self.Murd.Available = false
		return true
	end
	return false
end

function MX:Death(UnitID)
	if self.Murd.UnitID == UnitID then
		self.Murd.Dead = true
		return true
	end
	return false
end

function MX:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Murd.Name then
				if not self.MurdID then
					self.Murd.UnitID = unitID
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Murd.Dead = false
					self.Murd.Available = true
					self.Murd.Casting = false
				end
			end
		end
	end
end

function MX:Reset()
	self.EncounterRunning = false
	if self.MurdID then
		KBM.BossID[self.MurdID] = nil
	end
	self.MurdID = nil
end

function MX:Timer()
	
end

function MX.Murdantix:Options()
	function self:TimersEnabled(bool)
		MX.Settings.Timers.Enabled = bool
	end
	function self:MangleEnabled(bool)
		MX.Settings.Timers.MangleEnabled = bool
	end
	function self:PoundEnabled(bool)
		MX.Settings.Timers.PoundEnabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, MX.Settings.Timers.Enabled)
	Timers:AddCheck("Mangling Crush", self.MangleEnabled, MX.Settings.Timers.MangleEnabled)
	Timers:AddCheck("Ferocious Pound", self.PoundEnabled, MX.Settings.Timers.PoundEnabled)
end

function MX:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Murdantix.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.Murdantix.Name, self.Murdantix, true, self.Header)
	self.Murdantix.MenuItem.Check:SetEnabled(false)
	KBM.MechTimer:Add("Mangling Crush", "damage", 12, self.Murd, false)
	KBM.MechTimer:Add("Ferocious Pound", "damage", 35, self.Murd, false)
end