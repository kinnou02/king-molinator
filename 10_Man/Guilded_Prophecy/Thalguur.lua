-- Thalguur Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGPTR_Settings = nil
GP = KBMGP_Register()

local TR = {
	ModEnabled = true,
	Thalguur = {
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
	ID = "Thalguur",
	}

TR.Thalguur = {
	Mod = TR,
	Level = "??",
	Active = false,
	Name = "Thalguur",
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

local KBM = KBM_RegisterMod(TR.Thalguur.ID, TR)

TR.Lang.Thalguur = KBM.Language:Add(TR.Thalguur.Name)
-- TR.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- TR.Lang.Flames.French = "Flammes anciennes"

TR.Thalguur.Name = TR.Lang.Thalguur[KBM.Lang]

function TR:AddBosses(KBM_Boss)
	self.Thalguur.Descript = self.Thalguur.Name
	self.MenuName = self.Thalguur.Descript
	self.Bosses = {
		[self.Thalguur.Name] = true,
	}
	KBM_Boss[self.Thalguur.Name] = self.Thalguur	
end

function TR:InitVars()
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

function TR:LoadVars()
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

function TR:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function TR:Castbar(units)
end

function TR:RemoveUnits(UnitID)
	if self.Thalguur.UnitID == UnitID then
		self.Thalguur.Available = false
		return true
	end
	return false
end

function TR:Death(UnitID)
	if self.Thalguur.UnitID == UnitID then
		self.Thalguur.Dead = true
		return true
	end
	return false
end

function TR:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Thalguur.Name then
				if not self.Thalguur.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Thalguur.Dead = false
					self.Thalguur.Casting = false
					self.Thalguur.CastBar:Create(unitID)
				end
				self.Thalguur.UnitID = unitID
				self.Thalguur.Available = true
				return self.Thalguur
			end
		end
	end
end

function TR:Reset()
	self.EncounterRunning = false
	self.Thalguur.Available = false
	self.Thalguur.UnitID = nil
	self.Thalguur.CastBar:Remove()
end

function TR:Timer()
	
end

function TR.Thalguur:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		TR.Settings.Timers.FlamesEnabled = bool
		TR.Thalguur.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, TR.Settings.Timers.Enabled)
	--Timers:AddCheck(TR.Lang.Flames[KBM.Lang], self.FlamesEnabled, TR.Settings.Timers.FlamesEnabled)	
	
end

function TR:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Thalguur.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Thalguur, true, self.Header)
	self.Thalguur.MenuItem.Check:SetEnabled(false)
	-- self.Thalguur.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Thalguur.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Thalguur.CastBar = KBM.CastBar:Add(self, self.Thalguur, true)
end