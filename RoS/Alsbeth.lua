-- Alsbeth the Discordant Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSAD_Settings = nil
ROS = KBMROS_Register()

local AD = {
	ModEnabled = true,
	Alsbeth = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = ROS.Name,
	Type = "20man",
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	Enrage = 60 * 19,
	ID = "Alsbeth",
}

AD.Alsbeth = {
	Mod = AD,
	Level = "??",
	Active = false,
	Name = "Alsbeth the Discordant",
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

local KBM = KBM_RegisterMod(AD.Alsbeth.ID, AD)

AD.Lang.Alsbeth = KBM.Language:Add(AD.Alsbeth.Name)
AD.Lang.Alsbeth.German = "Alsbeth die Streitsuchende"
AD.Lang.Alsbeth.French = "Alsbeth la Discordante"

AD.Alsbeth.Name = AD.Lang.Alsbeth[KBM.Lang]

function AD:AddBosses(KBM_Boss)
	self.Alsbeth.Descript = self.Alsbeth.Name
	self.MenuName = self.Alsbeth.Descript
	self.Bosses = {
		[self.Alsbeth.Name] = true,
	}
	KBM_Boss[self.Alsbeth.Name] = self.Alsbeth	
end

function AD:InitVars()
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
	KBMAD_Settings = self.Settings
end

function AD:LoadVars()
	if type(KBMROSAD_Settings) == "table" then
		for Setting, Value in pairs(KBMROSAD_Settings) do
			if type(KBMROSAD_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMROSAD_Settings[Setting]) do
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

function AD:SaveVars()
	KBMROSAD_Settings = self.Settings
end

function AD:Castbar(units)
end

function AD:RemoveUnits(UnitID)
	if self.Alsbeth.UnitID == UnitID then
		self.Alsbeth.Available = false
		return true
	end
	return false
end

function AD:Death(UnitID)
	if self.Alsbeth.UnitID == UnitID then
		self.Alsbeth.Dead = true
		return true
	end
	return false
end

function AD:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Alsbeth.Name then
				if not self.Alsbeth.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Alsbeth.Dead = false
					self.Alsbeth.Casting = false
					self.Alsbeth.CastBar:Create(unitID)
				end
				self.Alsbeth.UnitID = unitID
				self.Alsbeth.Available = true
				return self.Alsbeth
			end
		end
	end
end

function AD:Reset()
	self.EncounterRunning = false
	self.Alsbeth.Available = false
	self.Alsbeth.UnitID = nil
	self.Alsbeth.CastBar:Remove()
end

function AD:Timer()
	
end

function AD.Alsbeth:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		AD.Settings.Timers.FlamesEnabled = bool
		AD.Alsbeth.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, AD.Settings.Timers.Enabled)
	--Timers:AddCheck(AD.Lang.Flames[KBM.Lang], self.FlamesEnabled, AD.Settings.Timers.FlamesEnabled)	
	
end

function AD:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Alsbeth.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Alsbeth, true, self.Header)
	self.Alsbeth.MenuItem.Check:SetEnabled(false)
	-- self.Alsbeth.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Alsbeth.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Alsbeth.CastBar = KBM.CastBar:Add(self, self.Alsbeth, true)
end