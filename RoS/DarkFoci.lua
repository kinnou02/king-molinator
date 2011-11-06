-- Dark Foci Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSDF_Settings = nil
ROS = KBMROS_Register()

local DF = {
	ModEnabled = true,
	Foci = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		ID = "Dark Foci",
	},
	Instance = ROS.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
}

DF.Foci = {
	Mod = DF,
	Level = "??",
	Active = false,
	Name = "Dark Foci",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
}

local KBM = KBM_RegisterMod(DF.Foci.ID, DF)

DF.Lang.Foci = KBM.Language:Add(DF.Foci.Name)
-- DF.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- DF.Lang.Flames.French = "Flammes anciennes"

DF.Foci.Name = DF.Lang.Foci[KBM.Lang]

function DF:AddBosses(KBM_Boss)
	self.Foci.Descript = self.Foci.Name
	self.MenuName = self.Foci.Descript
	self.Bosses = {
		[self.Foci.Name] = true,
	}
	KBM_Boss[self.Foci.Name] = self.Foci	
end

function DF:InitVars()
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
	KBMDF_Settings = self.Settings
end

function DF:LoadVars()
	if type(KBMROSDF_Settings) == "table" then
		for Setting, Value in pairs(KBMROSDF_Settings) do
			if type(KBMROSDF_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMROSDF_Settings[Setting]) do
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

function DF:SaveVars()
	KBMROSDF_Settings = self.Settings
end

function DF:Castbar(units)
end

function DF:RemoveUnits(UnitID)
	if self.Foci.UnitID == UnitID then
		self.Foci.Available = false
		return true
	end
	return false
end

function DF:Death(UnitID)
	if self.Foci.UnitID == UnitID then
		self.Foci.Dead = true
		return true
	end
	return false
end

function DF:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Foci.Name then
				if not self.Foci.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Foci.Dead = false
					self.Foci.Casting = false
					self.Foci.CastBar:Create(unitID)
				end
				self.Foci.UnitID = unitID
				self.Foci.Available = true
				return self.Foci
			end
		end
	end
end

function DF:Reset()
	self.EncounterRunning = false
	self.Foci.Available = false
	self.Foci.UnitID = nil
	self.Foci.CastBar:Remove()
end

function DF:Timer()
	
end

function DF.Foci:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		DF.Settings.Timers.FlamesEnabled = bool
		DF.Foci.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, DF.Settings.Timers.Enabled)
	--Timers:AddCheck(DF.Lang.Flames[KBM.Lang], self.FlamesEnabled, DF.Settings.Timers.FlamesEnabled)	
	
end

function DF:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Foci.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Foci, true, self.Header)
	self.Foci.MenuItem.Check:SetEnabled(false)
	-- self.Foci.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Foci.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Foci.CastBar = KBM.CastBar:Add(self, self.Foci, true)
end