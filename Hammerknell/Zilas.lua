-- Zilas Zamira Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSZ_Settings = nil
HK = KBMHK_Register()

local SZ = {
	ModEnabled = true,
	Zilas = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		ID = "Zilas",
	},
	Instance = HK.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
}

SZ.Zilas = {
	Mod = SZ,
	Level = "??",
	Active = false,
	Name = "Soulrender Zilas",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
}

local KBM = KBM_RegisterMod(SZ.Zilas.ID, SZ)

function SZ:AddBosses(KBM_Boss)
	self.Zilas.Descript = self.Zilas.Name
	self.MenuName = self.Zilas.Descript
	self.Bosses = {
		[self.Zilas.Name] = true,
	}
	KBM_Boss[self.Zilas.Name] = self.Zilas	
end

function SZ:InitVars()
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
	KBMSZ_Settings = self.Settings
end

function SZ:LoadVars()
	if type(KBMSZ_Settings) == "table" then
		for Setting, Value in pairs(KBMSZ_Settings) do
			if type(KBMSZ_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMSZ_Settings[Setting]) do
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

function SZ:SaveVars()
	KBMSZ_Settings = self.Settings
end

function SZ:Castbar(units)
end

function SZ:RemoveUnits(UnitID)
	if self.Zilas.UnitID == UnitID then
		self.Zilas.Available = false
		return true
	end
	return false
end

function SZ:Death(UnitID)
	if self.Zilas.UnitID == UnitID then
		self.Zilas.Dead = true
		return true
	end
	return false
end

function SZ:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Zilas.Name then
				if not self.Zilas.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Zilas.Dead = false
					self.Zilas.Casting = false
					self.Zilas.CastBar:Create(unitID)
				end
				self.Zilas.UnitID = unitID
				self.Zilas.Available = true
				return self.Zilas
			end
		end
	end
end

function SZ:Reset()
	self.EncounterRunning = false
	self.Zilas.Available = false
	self.Zilas.UnitID = nil
	self.Zilas.CastBar:Remove()
end

function SZ:Timer()
	
end

function SZ.Zilas:Options()
	function self:TimersEnabled(bool)
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, SZ.Settings.Timers.Enabled)
	--Timers:AddCheck("Tidal Wave (Phase 1)", self.WaveStartEnabled, SZ.Settings.Timers.WaveStartEnabled)	
	
end

function SZ:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Zilas.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Zilas, true, self.Header)
	self.Zilas.MenuItem.Check:SetEnabled(false)
	--self.Jornaru.TimersRef.Wave = KBM.MechTimer:Add("Wave1", "repeat", 40, self, nil, "Tidal Wave")
	--self.Jornaru.TimersRef.Wave.Enable = self.Settings.Timers.WaveStartEnabled
	
	self.Zilas.CastBar = KBM.CastBar:Add(self, self.Zilas, true)
end