-- Guurloth Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGPGH_Settings = nil
GP = KBMGP_Register()

local GH = {
	ModEnabled = true,
	Guurloth = {
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
	ID = "Guurloth",
	}

GH.Guurloth = {
	Mod = GH,
	Level = "??",
	Active = false,
	Name = "Guurloth",
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

local KBM = KBM_RegisterMod(GH.Guurloth.ID, GH)

GH.Lang.Guurloth = KBM.Language:Add(GH.Guurloth.Name)
-- GH.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- GH.Lang.Flames.French = "Flammes anciennes"

GH.Guurloth.Name = GH.Lang.Guurloth[KBM.Lang]

function GH:AddBosses(KBM_Boss)
	self.Guurloth.Descript = self.Guurloth.Name
	self.MenuName = self.Guurloth.Descript
	self.Bosses = {
		[self.Guurloth.Name] = true,
	}
	KBM_Boss[self.Guurloth.Name] = self.Guurloth	
end

function GH:InitVars()
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

function GH:LoadVars()
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

function GH:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function GH:Castbar(units)
end

function GH:RemoveUnits(UnitID)
	if self.Guurloth.UnitID == UnitID then
		self.Guurloth.Available = false
		return true
	end
	return false
end

function GH:Death(UnitID)
	if self.Guurloth.UnitID == UnitID then
		self.Guurloth.Dead = true
		return true
	end
	return false
end

function GH:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Guurloth.Name then
				if not self.Guurloth.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Guurloth.Dead = false
					self.Guurloth.Casting = false
					self.Guurloth.CastBar:Create(unitID)
				end
				self.Guurloth.UnitID = unitID
				self.Guurloth.Available = true
				return self.Guurloth
			end
		end
	end
end

function GH:Reset()
	self.EncounterRunning = false
	self.Guurloth.Available = false
	self.Guurloth.UnitID = nil
	self.Guurloth.CastBar:Remove()
end

function GH:Timer()
	
end

function GH.Guurloth:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		GH.Settings.Timers.FlamesEnabled = bool
		GH.Guurloth.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, GH.Settings.Timers.Enabled)
	--Timers:AddCheck(GH.Lang.Flames[KBM.Lang], self.FlamesEnabled, GH.Settings.Timers.FlamesEnabled)	
	
end

function GH:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Guurloth.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Guurloth, true, self.Header)
	self.Guurloth.MenuItem.Check:SetEnabled(false)
	-- self.Guurloth.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Guurloth.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Guurloth.CastBar = KBM.CastBar:Add(self, self.Guurloth, true)
end