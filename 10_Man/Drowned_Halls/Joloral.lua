-- Joloral Ragetide Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHJR_Settings = nil
DH = KBMDH_Register()

local JR = {
	ModEnabled = true,
	Joloral = {
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
	ID = "Joloral",
	}

JR.Joloral = {
	Mod = JR,
	Level = "??",
	Active = false,
	Name = "Joloral Ragetide",
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

local KBM = KBM_RegisterMod(JR.Joloral.ID, JR)

JR.Lang.Joloral = KBM.Language:Add(JR.Joloral.Name)
JR.Lang.Joloral.German = "Joloral Wutflut"
-- JR.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- JR.Lang.Flames.French = "Flammes anciennes"

JR.Joloral.Name = JR.Lang.Joloral[KBM.Lang]

function JR:AddBosses(KBM_Boss)
	self.Joloral.Descript = self.Joloral.Name
	self.MenuName = self.Joloral.Descript
	self.Bosses = {
		[self.Joloral.Name] = true,
	}
	KBM_Boss[self.Joloral.Name] = self.Joloral	
end

function JR:InitVars()
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

function JR:LoadVars()
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

function JR:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function JR:Castbar(units)
end

function JR:RemoveUnits(UnitID)
	if self.Joloral.UnitID == UnitID then
		self.Joloral.Available = false
		return true
	end
	return false
end

function JR:Death(UnitID)
	if self.Joloral.UnitID == UnitID then
		self.Joloral.Dead = true
		return true
	end
	return false
end

function JR:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Joloral.Name then
				if not self.Joloral.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Joloral.Dead = false
					self.Joloral.Casting = false
					self.Joloral.CastBar:Create(unitID)
				end
				self.Joloral.UnitID = unitID
				self.Joloral.Available = true
				return self.Joloral
			end
		end
	end
end

function JR:Reset()
	self.EncounterRunning = false
	self.Joloral.Available = false
	self.Joloral.UnitID = nil
	self.Joloral.CastBar:Remove()
end

function JR:Timer()
	
end

function JR.Joloral:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		JR.Settings.Timers.FlamesEnabled = bool
		JR.Joloral.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, JR.Settings.Timers.Enabled)
	--Timers:AddCheck(JR.Lang.Flames[KBM.Lang], self.FlamesEnabled, JR.Settings.Timers.FlamesEnabled)	
	
end

function JR:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Joloral.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Joloral, true, self.Header)
	self.Joloral.MenuItem.Check:SetEnabled(false)
	-- self.Joloral.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Joloral.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Joloral.CastBar = KBM.CastBar:Add(self, self.Joloral, true)
end