-- Murdantix Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMX_Settings = nil

local MX = {
	ModEnabled = true,
	Bosses = {
		["Murdantix"] = true,
	},
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
	PhaseList = {},
	Timers = {},
	Lang = {},
}

MX.Murd = {
	Mod = MX,
	Level = "??",
	Active = false,
	Name = "Murdantix",
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = false,
	Timers = {},
	TimersRef = {},
	Triggers = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Descript = "Murdantix",
}

local KBM = KBM_RegisterMod("Murdantix", MX)

KBM.Language:Add(MX.Murd.Name)

-- Ability Dictionary
MX.Lang.Mangling = KBM.Language:Add("Mangling Crush")
MX.Lang.Mangling.French = "Traumatisme d'\195\162me"
MX.Lang.Pound = KBM.Language:Add("Ferocious Pound")
MX.Lang.Pound.French = "Attaque f\195\169roce"

function MX:AddBosses(KBM_Boss)
	self.MenuName = self.Murd.Name
	KBM_Boss[self.Murd.Name] = self.Murd
end

function MX:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			MangleEnabled = true,
			PoundEnabled = true,
		},
		CastBar = {
			Enabled = true,
			x = false,
			y = false,
		},
	}
	KBMMX_Settings = self.Settings
end

function MX:LoadVars()
	if type(KBMMX_Settings) == "table" then
		for Setting, Value in pairs(KBMMX_Settings) do
			if type(KBMMX_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMMX_Settings[Setting]) do
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

function MX:SaveVars()
	KBMMX_Settings = self.Settings
end

function MX:Castbar()
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
				if not self.Murd.UnitID then
					self.Murd.UnitID = unitID
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Murd.Dead = false
					self.Murd.Casting = false
					self.Murd.CastBar:Create(unitID)
				end
				self.Murd.Available = true
				return self.Murd
			end
		end
	end
end

function MX:Reset()
	self.EncounterRunning = false
	self.Murd.UnitID = nil
	self.Murd.CastBar:Remove()
end

function MX:Timer()
	
end

function MX.Murdantix:Options()
	function self:TimersEnabled(bool)
		MX.Settings.Timers.Enabled = bool
	end
	function self:MangleEnabled(bool)
		MX.Settings.Timers.MangleEnabled = bool
		MX.Murd.TimersRef.Mangling.Enabled = bool
	end
	function self:PoundEnabled(bool)
		MX.Settings.Timers.PoundEnabled = bool
		MX.Murd.TimersRef.Pound.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, MX.Settings.Timers.Enabled)
	Timers:AddCheck(MX.Lang.Mangling[KBM.Lang], self.MangleEnabled, MX.Settings.Timers.MangleEnabled)
	Timers:AddCheck(MX.Lang.Pound[KBM.Lang], self.PoundEnabled, MX.Settings.Timers.PoundEnabled)
end

function MX:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Murdantix.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Murdantix, true, self.Header)
	self.Murdantix.MenuItem.Check:SetEnabled(false)
	self.Murd.TimersRef.Mangling = KBM.MechTimer:Add(self.Lang.Mangling[KBM.Lang], "damage", 12, self.Murd)
	self.Murd.TimersRef.Mangling.Enabled = MX.Settings.Timers.MangleEnabled
	self.Murd.TimersRef.Pound = KBM.MechTimer:Add(self.Lang.Pound[KBM.Lang], "damage", 35, self.Murd)
	self.Murd.TimersRef.Pound.Enabled = MX.Settings.Timers.PoundEnabled
	
	self.Murd.CastBar = KBM.CastBar:Add(self, self.Murd, true)
end