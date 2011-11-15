-- Thalquur Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGPTR_Settings = nil
GP = KBMGP_Register()

local TR = {
	ModEnabled = true,
	Thalquur = {
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
	ID = "Thalquur",
	}

TR.Thalquur = {
	Mod = TR,
	Level = "??",
	Active = false,
	Name = "Thalquur",
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

local KBM = KBM_RegisterMod(TR.Thalquur.ID, TR)

TR.Lang.Thalquur = KBM.Language:Add(TR.Thalquur.Name)
-- TR.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- TR.Lang.Flames.French = "Flammes anciennes"

TR.Thalquur.Name = TR.Lang.Thalquur[KBM.Lang]

function TR:AddBosses(KBM_Boss)
	self.Thalquur.Descript = self.Thalquur.Name
	self.MenuName = self.Thalquur.Descript
	self.Bosses = {
		[self.Thalquur.Name] = true,
	}
	KBM_Boss[self.Thalquur.Name] = self.Thalquur	
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
	if self.Thalquur.UnitID == UnitID then
		self.Thalquur.Available = false
		return true
	end
	return false
end

function TR:Death(UnitID)
	if self.Thalquur.UnitID == UnitID then
		self.Thalquur.Dead = true
		return true
	end
	return false
end

function TR:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Thalquur.Name then
				if not self.Thalquur.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Thalquur.Dead = false
					self.Thalquur.Casting = false
					self.Thalquur.CastBar:Create(unitID)
				end
				self.Thalquur.UnitID = unitID
				self.Thalquur.Available = true
				return self.Thalquur
			end
		end
	end
end

function TR:Reset()
	self.EncounterRunning = false
	self.Thalquur.Available = false
	self.Thalquur.UnitID = nil
	self.Thalquur.CastBar:Remove()
end

function TR:Timer()
	
end

function TR.Thalquur:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		TR.Settings.Timers.FlamesEnabled = bool
		TR.Thalquur.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, TR.Settings.Timers.Enabled)
	--Timers:AddCheck(TR.Lang.Flames[KBM.Lang], self.FlamesEnabled, TR.Settings.Timers.FlamesEnabled)	
	
end

function TR:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Thalquur.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Thalquur, true, self.Header)
	self.Thalquur.MenuItem.Check:SetEnabled(false)
	-- self.Thalquur.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Thalquur.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Thalquur.CastBar = KBM.CastBar:Add(self, self.Thalquur, true)
end