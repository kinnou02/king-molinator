-- Beruhast Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPBT_Settings = nil
ROTP = KBMROTP_Register()

local BT = {
	ModEnabled = true,
	Beruhast = {
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
	ID = "Beruhast",
	}

BT.Beruhast = {
	Mod = BT,
	Level = "??",
	Active = false,
	Name = "Beruhast",
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

local KBM = KBM_RegisterMod(BT.Beruhast.ID, BT)

BT.Lang.Beruhast = KBM.Language:Add(BT.Beruhast.Name)
-- BT.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- BT.Lang.Flames.French = "Flammes anciennes"

BT.Beruhast.Name = BT.Lang.Beruhast[KBM.Lang]

function BT:AddBosses(KBM_Boss)
	self.Beruhast.Descript = self.Beruhast.Name
	self.MenuName = self.Beruhast.Descript
	self.Bosses = {
		[self.Beruhast.Name] = true,
	}
	KBM_Boss[self.Beruhast.Name] = self.Beruhast	
end

function BT:InitVars()
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

function BT:LoadVars()
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

function BT:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function BT:Castbar(units)
end

function BT:RemoveUnits(UnitID)
	if self.Beruhast.UnitID == UnitID then
		self.Beruhast.Available = false
		return true
	end
	return false
end

function BT:Death(UnitID)
	if self.Beruhast.UnitID == UnitID then
		self.Beruhast.Dead = true
		return true
	end
	return false
end

function BT:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Beruhast.Name then
				if not self.Beruhast.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Beruhast.Dead = false
					self.Beruhast.Casting = false
					self.Beruhast.CastBar:Create(unitID)
				end
				self.Beruhast.UnitID = unitID
				self.Beruhast.Available = true
				return self.Beruhast
			end
		end
	end
end

function BT:Reset()
	self.EncounterRunning = false
	self.Beruhast.Available = false
	self.Beruhast.UnitID = nil
	self.Beruhast.CastBar:Remove()
end

function BT:Timer()
	
end

function BT.Beruhast:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		BT.Settings.Timers.FlamesEnabled = bool
		BT.Beruhast.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, BT.Settings.Timers.Enabled)
	--Timers:AddCheck(BT.Lang.Flames[KBM.Lang], self.FlamesEnabled, BT.Settings.Timers.FlamesEnabled)	
	
end

function BT:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Beruhast.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Beruhast, true, self.Header)
	self.Beruhast.MenuItem.Check:SetEnabled(false)
	-- self.Beruhast.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Beruhast.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Beruhast.CastBar = KBM.CastBar:Add(self, self.Beruhast, true)
end