-- Isskal Ragetide Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHIL_Settings = nil
DH = KBMDH_Register()

local IL = {
	ModEnabled = true,
	Isskal = {
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
	ID = "Isskal",
	}

IL.Isskal = {
	Mod = IL,
	Level = "??",
	Active = false,
	Name = "Isskal",
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

local KBM = KBM_RegisterMod(IL.Isskal.ID, IL)

IL.Lang.Isskal = KBM.Language:Add(IL.Isskal.Name)
-- IL.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- IL.Lang.Flames.French = "Flammes anciennes"

IL.Isskal.Name = IL.Lang.Isskal[KBM.Lang]

function IL:AddBosses(KBM_Boss)
	self.Isskal.Descript = self.Isskal.Name
	self.MenuName = self.Isskal.Descript
	self.Bosses = {
		[self.Isskal.Name] = true,
	}
	KBM_Boss[self.Isskal.Name] = self.Isskal	
end

function IL:InitVars()
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

function IL:LoadVars()
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

function IL:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function IL:Castbar(units)
end

function IL:RemoveUnits(UnitID)
	if self.Isskal.UnitID == UnitID then
		self.Isskal.Available = false
		return true
	end
	return false
end

function IL:Death(UnitID)
	if self.Isskal.UnitID == UnitID then
		self.Isskal.Dead = true
		return true
	end
	return false
end

function IL:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Isskal.Name then
				if not self.Isskal.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Isskal.Dead = false
					self.Isskal.Casting = false
					self.Isskal.CastBar:Create(unitID)
				end
				self.Isskal.UnitID = unitID
				self.Isskal.Available = true
				return self.Isskal
			end
		end
	end
end

function IL:Reset()
	self.EncounterRunning = false
	self.Isskal.Available = false
	self.Isskal.UnitID = nil
	self.Isskal.CastBar:Remove()
end

function IL:Timer()
	
end

function IL.Isskal:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		IL.Settings.Timers.FlamesEnabled = bool
		IL.Isskal.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, IL.Settings.Timers.Enabled)
	--Timers:AddCheck(IL.Lang.Flames[KBM.Lang], self.FlamesEnabled, IL.Settings.Timers.FlamesEnabled)	
	
end

function IL:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Isskal.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Isskal, true, self.Header)
	self.Isskal.MenuItem.Check:SetEnabled(false)
	-- self.Isskal.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Isskal.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Isskal.CastBar = KBM.CastBar:Add(self, self.Isskal, true)
end