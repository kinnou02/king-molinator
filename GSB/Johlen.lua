-- Infiltrator Johlen Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBIJ_Settings = nil
GSB = KBMGSB_Register()

local IJ = {
	ModEnabled = true,
	Johlen = {
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
	ID = "Johlen",	
}

IJ.Johlen = {
	Mod = IJ,
	Level = "??",
	Active = false,
	Name = "Infiltrator Johlen",
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

local KBM = KBM_RegisterMod(IJ.Johlen.ID, IJ)

IJ.Lang.Johlen = KBM.Language:Add(IJ.Johlen.Name)
-- IJ.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- IJ.Lang.Flames.French = "Flammes anciennes"

IJ.Johlen.Name = IJ.Lang.Johlen[KBM.Lang]

function IJ:AddBosses(KBM_Boss)
	self.Johlen.Descript = self.Johlen.Name
	self.MenuName = self.Johlen.Descript
	self.Bosses = {
		[self.Johlen.Name] = true,
	}
	KBM_Boss[self.Johlen.Name] = self.Johlen	
end

function IJ:InitVars()
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
	KBMIJ_Settings = self.Settings
end

function IJ:LoadVars()
	if type(KBMGSBIJ_Settings) == "table" then
		for Setting, Value in pairs(KBMGSBIJ_Settings) do
			if type(KBMGSBIJ_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMGSBIJ_Settings[Setting]) do
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

function IJ:SaveVars()
	KBMGSBIJ_Settings = self.Settings
end

function IJ:Castbar(units)
end

function IJ:RemoveUnits(UnitID)
	if self.Johlen.UnitID == UnitID then
		self.Johlen.Available = false
		return true
	end
	return false
end

function IJ:Death(UnitID)
	if self.Johlen.UnitID == UnitID then
		self.Johlen.Dead = true
		return true
	end
	return false
end

function IJ:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Johlen.Name then
				if not self.Johlen.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Johlen.Dead = false
					self.Johlen.Casting = false
					self.Johlen.CastBar:Create(unitID)
				end
				self.Johlen.UnitID = unitID
				self.Johlen.Available = true
				return self.Johlen
			end
		end
	end
end

function IJ:Reset()
	self.EncounterRunning = false
	self.Johlen.Available = false
	self.Johlen.UnitID = nil
	self.Johlen.CastBar:Remove()
end

function IJ:Timer()
	
end

function IJ.Johlen:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		IJ.Settings.Timers.FlamesEnabled = bool
		IJ.Johlen.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, IJ.Settings.Timers.Enabled)
	--Timers:AddCheck(IJ.Lang.Flames[KBM.Lang], self.FlamesEnabled, IJ.Settings.Timers.FlamesEnabled)	
	
end

function IJ:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Johlen.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Johlen, true, self.Header)
	self.Johlen.MenuItem.Check:SetEnabled(false)
	-- self.Johlen.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Johlen.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Johlen.CastBar = KBM.CastBar:Add(self, self.Johlen, true)
end