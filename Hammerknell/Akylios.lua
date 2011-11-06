-- Akylios Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMAK_Settings = nil
HK = KBMHK_Register()

local AK = {
	ModEnabled = true,
	Akylios = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		ID = "Akylios",
	},
	Instance = HK.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
}

AK.Jornaru = {
	Mod = AK,
	Level = "??",
	Active = false,
	Name = "Jornaru",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
}

AK.Akylios = {
	Mod = AK,
	Level = "??",
	Active = false,
	Name = "Akylios",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
}

local KBM = KBM_RegisterMod(AK.Akylios.ID, AK)

AK.Lang.Akylios = KBM.Language:Add(AK.Akylios.Name)
AK.Lang.Jornaru = KBM.Language:Add(AK.Jornaru.Name)

function AK:AddBosses(KBM_Boss)
	self.Jornaru.Descript = "Akylios & Jornaru"
	self.Akylios.Descript = self.Jornaru.Descript
	self.MenuName = self.Akylios.Descript
	self.Bosses = {
		[self.Jornaru.Name] = true,
		[self.Akylios.Name] = true,
	}
	KBM_Boss[self.Jornaru.Name] = self.Jornaru
	KBM_Boss[self.Akylios.Name] = self.Akylios	
end

function AK:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
			WaveStartEnabled = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMAK_Settings = self.Settings
end

function AK:LoadVars()
	if type(KBMAK_Settings) == "table" then
		for Setting, Value in pairs(KBMAK_Settings) do
			if type(KBMAK_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMAK_Settings[Setting]) do
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

function AK:SaveVars()
	KBMAK_Settings = self.Settings
end

function AK:Castbar(units)
end

function AK:RemoveUnits(UnitID)
	if self.Jornaru.UnitID == UnitID then
		self.Jornaru.Available = false
		return true
	end
	return false
end

function AK:Death(UnitID)
	if self.Jornaru.UnitID == UnitID then
		self.Jornaru.Dead = true
		return true
	end
	return false
end

function AK:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Jornaru.Name then
				if not self.Jornaru.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Jornaru.Dead = false
					self.Jornaru.Casting = false
					self.TimersRef.Wave:Start(Inspect.Time.Real())
				end
				self.Jornaru.UnitID = unitID
				self.Jornaru.Available = true
				return self.Jornaru
			end
		end
	end
end

function AK:Reset()
	self.EncounterRunning = false
	self.Jornaru.UnitID = nil
end

function AK:Timer()
	
end

function AK.Akylios:Options()
	function self:TimersEnabled(bool)
	end
	function self:WaveStartEnabled(bool)
		AK.Settings.Timers.WaveStartEnabled = bool
		AK.Jornaru.TimersRef.Wave.Enable = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, AK.Settings.Timers.Enabled)
	Timers:AddCheck("Tidal Wave (Phase 1)", self.WaveStartEnabled, AK.Settings.Timers.WaveStartEnabled)	
	
end

function AK:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Akylios.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Akylios, true, self.Header)
	self.Akylios.MenuItem.Check:SetEnabled(false)
	self.Jornaru.TimersRef.Wave = KBM.MechTimer:Add("Wave1", "repeat", 40, self, nil, "Tidal Wave")
	self.Jornaru.TimersRef.Wave.Enable = self.Settings.Timers.WaveStartEnabled
end