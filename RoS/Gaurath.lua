-- Herald Gaurath Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSHG_Settings = nil
ROS = KBMROS_Register()

local HG = {
	ModEnabled = true,
	Gaurath = {
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
	Enrage = 60 * 9.5,
	ID = "Herald Gaurath",
}

HG.Gaurath = {
	Mod = HG,
	Level = "??",
	Active = false,
	Name = "Herald Gaurath",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
}

local KBM = KBM_RegisterMod(HG.Gaurath.ID, HG)

HG.Lang.Gaurath = KBM.Language:Add(HG.Gaurath.Name)
HG.Lang.Gaurath.German = "Herold Gaurath"
-- HG.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- HG.Lang.Flames.French = "Flammes anciennes"

HG.Gaurath.Name = HG.Lang.Gaurath[KBM.Lang]

function HG:AddBosses(KBM_Boss)
	self.Gaurath.Descript = self.Gaurath.Name
	self.MenuName = self.Gaurath.Descript
	self.Bosses = {
		[self.Gaurath.Name] = true,
	}
	KBM_Boss[self.Gaurath.Name] = self.Gaurath	
end

function HG:InitVars()
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
	KBMHG_Settings = self.Settings
end

function HG:LoadVars()
	if type(KBMROSHG_Settings) == "table" then
		for Setting, Value in pairs(KBMROSHG_Settings) do
			if type(KBMROSHG_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMROSHG_Settings[Setting]) do
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

function HG:SaveVars()
	KBMROSHG_Settings = self.Settings
end

function HG:Castbar(units)
end

function HG:RemoveUnits(UnitID)
	if self.Gaurath.UnitID == UnitID then
		self.Gaurath.Available = false
		return true
	end
	return false
end

function HG:Death(UnitID)
	if self.Gaurath.UnitID == UnitID then
		self.Gaurath.Dead = true
		return true
	end
	return false
end

function HG:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Gaurath.Name then
				if not self.Gaurath.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Gaurath.Dead = false
					self.Gaurath.Casting = false
					self.Gaurath.CastBar:Create(unitID)
				end
				self.Gaurath.UnitID = unitID
				self.Gaurath.Available = true
				return self.Gaurath
			end
		end
	end
end

function HG:Reset()
	self.EncounterRunning = false
	self.Gaurath.Available = false
	self.Gaurath.UnitID = nil
	self.Gaurath.CastBar:Remove()
end

function HG:Timer()
	
end

function HG.Gaurath:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		HG.Settings.Timers.FlamesEnabled = bool
		HG.Gaurath.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, HG.Settings.Timers.Enabled)
	--Timers:AddCheck(HG.Lang.Flames[KBM.Lang], self.FlamesEnabled, HG.Settings.Timers.FlamesEnabled)	
	
end

function HG:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Gaurath.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Gaurath, true, self.Header)
	self.Gaurath.MenuItem.Check:SetEnabled(false)
	-- self.Gaurath.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Gaurath.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Gaurath.CastBar = KBM.CastBar:Add(self, self.Gaurath, true)
end