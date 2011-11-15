-- High Priestess Hydriss Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHHH_Settings = nil
DH = KBMDH_Register()

local HH = {
	ModEnabled = true,
	Hydriss = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = DH.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	ID = "High Priestess Hydriss",
	}

HH.Hydriss = {
	Mod = HH,
	Level = "??",
	Active = false,
	Name = "Hydriss",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 3,
	Triggers = {},
}

local KBM = KBM_RegisterMod(HH.Hydriss.ID, HH)

HH.Lang.Hydriss = KBM.Language:Add(HH.Hydriss.Name)
-- HH.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- HH.Lang.Flames.French = "Flammes anciennes"

HH.Hydriss.Name = HH.Lang.Hydriss[KBM.Lang]

function HH:AddBosses(KBM_Boss)
	self.Hydriss.Descript = self.Hydriss.Name
	self.MenuName = self.Hydriss.Descript
	self.Bosses = {
		[self.Hydriss.Name] = true,
	}
	KBM_Boss[self.Hydriss.Name] = self.Hydriss	
end

function HH:InitVars()
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

function HH:LoadVars()
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

function HH:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function HH:Castbar(units)
end

function HH:RemoveUnits(UnitID)
	if self.Hydriss.UnitID == UnitID then
		self.Hydriss.Available = false
		return true
	end
	return false
end

function HH:Death(UnitID)
	if self.Hydriss.UnitID == UnitID then
		self.Hydriss.Dead = true
		return true
	end
	return false
end

function HH:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Hydriss.Name then
				if not self.Hydriss.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Hydriss.Dead = false
					self.Hydriss.Casting = false
					self.Hydriss.CastBar:Create(unitID)
				end
				self.Hydriss.UnitID = unitID
				self.Hydriss.Available = true
				return self.Hydriss
			end
		end
	end
end

function HH:Reset()
	self.EncounterRunning = false
	self.Hydriss.Available = false
	self.Hydriss.UnitID = nil
	self.Hydriss.CastBar:Remove()
end

function HH:Timer()
	
end

function HH.Hydriss:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		HH.Settings.Timers.FlamesEnabled = bool
		HH.Hydriss.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, HH.Settings.Timers.Enabled)
	--Timers:AddCheck(HH.Lang.Flames[KBM.Lang], self.FlamesEnabled, HH.Settings.Timers.FlamesEnabled)	
	
end

function HH:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Hydriss.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Hydriss, true, self.Header)
	self.Hydriss.MenuItem.Check:SetEnabled(false)
	-- self.Hydriss.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Hydriss.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Hydriss.CastBar = KBM.CastBar:Add(self, self.Hydriss, true)
end