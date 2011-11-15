-- Uruluuk Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGPUK_Settings = nil
GP = KBMGP_Register()

local UK = {
	ModEnabled = true,
	Uruluuk = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = GP.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	ID = "Uruluuk",
	}

UK.Uruluuk = {
	Mod = UK,
	Level = "??",
	Active = false,
	Name = "Uruluuk",
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

local KBM = KBM_RegisterMod(UK.Uruluuk.ID, UK)

UK.Lang.Uruluuk = KBM.Language:Add(UK.Uruluuk.Name)
-- UK.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- UK.Lang.Flames.French = "Flammes anciennes"

UK.Uruluuk.Name = UK.Lang.Uruluuk[KBM.Lang]

function UK:AddBosses(KBM_Boss)
	self.Uruluuk.Descript = self.Uruluuk.Name
	self.MenuName = self.Uruluuk.Descript
	self.Bosses = {
		[self.Uruluuk.Name] = true,
	}
	KBM_Boss[self.Uruluuk.Name] = self.Uruluuk	
end

function UK:InitVars()
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

function UK:LoadVars()
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

function UK:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function UK:Castbar(units)
end

function UK:RemoveUnits(UnitID)
	if self.Uruluuk.UnitID == UnitID then
		self.Uruluuk.Available = false
		return true
	end
	return false
end

function UK:Death(UnitID)
	if self.Uruluuk.UnitID == UnitID then
		self.Uruluuk.Dead = true
		return true
	end
	return false
end

function UK:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Uruluuk.Name then
				if not self.Uruluuk.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Uruluuk.Dead = false
					self.Uruluuk.Casting = false
					self.Uruluuk.CastBar:Create(unitID)
				end
				self.Uruluuk.UnitID = unitID
				self.Uruluuk.Available = true
				return self.Uruluuk
			end
		end
	end
end

function UK:Reset()
	self.EncounterRunning = false
	self.Uruluuk.Available = false
	self.Uruluuk.UnitID = nil
	self.Uruluuk.CastBar:Remove()
end

function UK:Timer()
	
end

function UK.Uruluuk:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		UK.Settings.Timers.FlamesEnabled = bool
		UK.Uruluuk.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, UK.Settings.Timers.Enabled)
	--Timers:AddCheck(UK.Lang.Flames[KBM.Lang], self.FlamesEnabled, UK.Settings.Timers.FlamesEnabled)	
	
end

function UK:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Uruluuk.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Uruluuk, true, self.Header)
	self.Uruluuk.MenuItem.Check:SetEnabled(false)
	-- self.Uruluuk.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Uruluuk.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Uruluuk.CastBar = KBM.CastBar:Add(self, self.Uruluuk, true)
end