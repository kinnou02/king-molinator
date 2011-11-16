-- Warmaster Galenir Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSWG_Settings = nil
ROS = KBMROS_Register()

local WG = {
	ModEnabled = true,
	Galenir = {
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
	Enrage = 60 * 5.5,
	ID = "Warmaster Galenir",	
}

WG.Galenir = {
	Mod = WG,
	Level = "??",
	Active = false,
	Name = "Warmaster Galenir",
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

local KBM = KBM_RegisterMod(WG.Galenir.ID, WG)

WG.Lang.Galenir = KBM.Language:Add(WG.Galenir.Name)
WG.Lang.Galenir.German = "Kriegsmeister Galenir"
WG.Lang.Galenir.French = "Ma\195\174tre de Guerre Galenir"

WG.Galenir.Name = WG.Lang.Galenir[KBM.Lang]

function WG:AddBosses(KBM_Boss)
	self.Galenir.Descript = self.Galenir.Name
	self.MenuName = self.Galenir.Descript
	self.Bosses = {
		[self.Galenir.Name] = true,
	}
	KBM_Boss[self.Galenir.Name] = self.Galenir	
end

function WG:InitVars()
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
	KBMWG_Settings = self.Settings
end

function WG:LoadVars()
	if type(KBMROSWG_Settings) == "table" then
		for Setting, Value in pairs(KBMROSWG_Settings) do
			if type(KBMROSWG_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMROSWG_Settings[Setting]) do
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

function WG:SaveVars()
	KBMROSWG_Settings = self.Settings
end

function WG:Castbar(units)
end

function WG:RemoveUnits(UnitID)
	if self.Galenir.UnitID == UnitID then
		self.Galenir.Available = false
		return true
	end
	return false
end

function WG:Death(UnitID)
	if self.Galenir.UnitID == UnitID then
		self.Galenir.Dead = true
		return true
	end
	return false
end

function WG:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Galenir.Name then
				if not self.Galenir.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Galenir.Dead = false
					self.Galenir.Casting = false
					self.Galenir.CastBar:Create(unitID)
					KBM.TankSwap:Start("Infecting Strike")
				end
				self.Galenir.UnitID = unitID
				self.Galenir.Available = true
				return self.Galenir
			end
		end
	end
end

function WG:Reset()
	self.EncounterRunning = false
	self.Galenir.Available = false
	self.Galenir.UnitID = nil
	self.Galenir.CastBar:Remove()
end

function WG:Timer()
	
end

function WG.Galenir:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		WG.Settings.Timers.FlamesEnabled = bool
		WG.Galenir.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, WG.Settings.Timers.Enabled)
	--Timers:AddCheck(WG.Lang.Flames[KBM.Lang], self.FlamesEnabled, WG.Settings.Timers.FlamesEnabled)	
	
end

function WG:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Galenir.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Galenir, true, self.Header)
	self.Galenir.MenuItem.Check:SetEnabled(false)
	-- self.Galenir.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Galenir.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Galenir.CastBar = KBM.CastBar:Add(self, self.Galenir, true)
end