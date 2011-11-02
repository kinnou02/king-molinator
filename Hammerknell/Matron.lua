-- Matron Zamira Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMZ_Settings = nil
HK = KBMHK_Register()

local MZ = {
	ModEnabled = true,
	Matron = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		ID = "Matron",
	},
	Instance = HK.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
}

MZ.Matron = {
	Mod = MZ,
	Level = "??",
	Active = false,
	Name = "Matron Zamira",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
}

local KBM = KBM_RegisterMod(MZ.Matron.ID, MZ)

MZ.Lang.Matron = KBM.Language:Add(MZ.Matron.Name)

function MZ:AddBosses(KBM_Boss)
	self.Matron.Descript = self.Matron.Name
	self.MenuName = self.Matron.Descript
	self.Bosses = {
		[self.Matron.Name] = true,
	}
	KBM_Boss[self.Matron.Name] = self.Matron	
end

function MZ:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMMZ_Settings = self.Settings
end

function MZ:LoadVars()
	if type(KBMMZ_Settings) == "table" then
		for Setting, Value in pairs(KBMMZ_Settings) do
			if type(KBMMZ_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMMZ_Settings[Setting]) do
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

function MZ:SaveVars()
	KBMMZ_Settings = self.Settings
end

function MZ:Castbar(units)
end

function MZ:RemoveUnits(UnitID)
	if self.Matron.UnitID == UnitID then
		self.Matron.Available = false
		return true
	end
	return false
end

function MZ:Death(UnitID)
	if self.Matron.UnitID == UnitID then
		self.Matron.Dead = true
		return true
	end
	return false
end

function MZ:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Matron.Name then
				if not self.Matron.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Matron.Dead = false
					self.Matron.Casting = false
					self.Matron.CastBar:Create(unitID)
				end
				self.Matron.UnitID = unitID
				self.Matron.Available = true
				return self.Matron
			end
		end
	end
end

function MZ:Reset()
	self.EncounterRunning = false
	self.Matron.Available = false
	self.Matron.UnitID = nil
	self.Matron.CastBar:Remove()
end

function MZ:Timer()
	
end

function MZ.Matron:Options()
	function self:TimersEnabled(bool)
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, MZ.Settings.Timers.Enabled)
	--Timers:AddCheck("Tidal Wave (Phase 1)", self.WaveStartEnabled, MZ.Settings.Timers.WaveStartEnabled)	
	
end

function MZ:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Matron.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Matron, true, self.Header)
	self.Matron.MenuItem.Check:SetEnabled(false)
	--self.Jornaru.TimersRef.Wave = KBM.MechTimer:Add("Wave1", "repeat", 40, self, nil, "Tidal Wave")
	--self.Jornaru.TimersRef.Wave.Enable = self.Settings.Timers.WaveStartEnabled
	
	self.Matron.CastBar = KBM.CastBar:Add(self, self.Matron, true)
end