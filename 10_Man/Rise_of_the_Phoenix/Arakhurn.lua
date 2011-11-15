-- High Priest Arakhurn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPHA_Settings = nil
ROTP = KBMROTP_Register()

local HA = {
	ModEnabled = true,
	Arakhurn = {
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
	ID = "Arakhurn",
	}

HA.Arakhurn = {
	Mod = HA,
	Level = "??",
	Active = false,
	Name = "High Priest Arakhurn",
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

local KBM = KBM_RegisterMod(HA.Arakhurn.ID, HA)

HA.Lang.Arakhurn = KBM.Language:Add(HA.Arakhurn.Name)
HA.Lang.Arakhurn.German = "Hohepriester Arakhurn"
-- HA.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- HA.Lang.Flames.French = "Flammes anciennes"

HA.Arakhurn.Name = HA.Lang.Arakhurn[KBM.Lang]

function HA:AddBosses(KBM_Boss)
	self.Arakhurn.Descript = self.Arakhurn.Name
	self.MenuName = self.Arakhurn.Descript
	self.Bosses = {
		[self.Arakhurn.Name] = true,
	}
	KBM_Boss[self.Arakhurn.Name] = self.Arakhurn	
end

function HA:InitVars()
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

function HA:LoadVars()
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

function HA:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function HA:Castbar(units)
end

function HA:RemoveUnits(UnitID)
	if self.Arakhurn.UnitID == UnitID then
		self.Arakhurn.Available = false
		return true
	end
	return false
end

function HA:Death(UnitID)
	if self.Arakhurn.UnitID == UnitID then
		self.Arakhurn.Dead = true
		return true
	end
	return false
end

function HA:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Arakhurn.Name then
				if not self.Arakhurn.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Arakhurn.Dead = false
					self.Arakhurn.Casting = false
					self.Arakhurn.CastBar:Create(unitID)
				end
				self.Arakhurn.UnitID = unitID
				self.Arakhurn.Available = true
				return self.Arakhurn
			end
		end
	end
end

function HA:Reset()
	self.EncounterRunning = false
	self.Arakhurn.Available = false
	self.Arakhurn.UnitID = nil
	self.Arakhurn.CastBar:Remove()
end

function HA:Timer()
	
end

function HA.Arakhurn:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		HA.Settings.Timers.FlamesEnabled = bool
		HA.Arakhurn.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, HA.Settings.Timers.Enabled)
	--Timers:AddCheck(HA.Lang.Flames[KBM.Lang], self.FlamesEnabled, HA.Settings.Timers.FlamesEnabled)	
	
end

function HA:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Arakhurn.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Arakhurn, true, self.Header)
	self.Arakhurn.MenuItem.Check:SetEnabled(false)
	-- self.Arakhurn.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Arakhurn.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Arakhurn.CastBar = KBM.CastBar:Add(self, self.Arakhurn, true)
end