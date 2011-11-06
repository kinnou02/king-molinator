-- Lord Greenscale Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBLG_Settings = nil
GSB = KBMGSB_Register()

local LG = {
	ModEnabled = true,
	Greenscale = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		ID = "Greenscale",
	},
	Instance = GSB.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	Enrage = 60 * 11, 
}

LG.Greenscale = {
	Mod = LG,
	Level = "??",
	Active = false,
	Name = "Lord Greenscale",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
}

local KBM = KBM_RegisterMod(LG.Greenscale.ID, LG)

LG.Lang.Greenscale = KBM.Language:Add(LG.Greenscale.Name)
-- LG.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- LG.Lang.Flames.French = "Flammes anciennes"

LG.Greenscale.Name = LG.Lang.Greenscale[KBM.Lang]

function LG:AddBosses(KBM_Boss)
	self.Greenscale.Descript = self.Greenscale.Name
	self.MenuName = self.Greenscale.Descript
	self.Bosses = {
		[self.Greenscale.Name] = true,
	}
	KBM_Boss[self.Greenscale.Name] = self.Greenscale	
end

function LG:InitVars()
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
	KBMLG_Settings = self.Settings
end

function LG:LoadVars()
	if type(KBMGSBLG_Settings) == "table" then
		for Setting, Value in pairs(KBMGSBLG_Settings) do
			if type(KBMGSBLG_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMGSBLG_Settings[Setting]) do
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

function LG:SaveVars()
	KBMGSBLG_Settings = self.Settings
end

function LG:Castbar(units)
end

function LG:RemoveUnits(UnitID)
	if self.Greenscale.UnitID == UnitID then
		self.Greenscale.Available = false
		return true
	end
	return false
end

function LG:Death(UnitID)
	if self.Greenscale.UnitID == UnitID then
		self.Greenscale.Dead = true
		return true
	end
	return false
end

function LG:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Greenscale.Name then
				if not self.Greenscale.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Greenscale.Dead = false
					self.Greenscale.Casting = false
					self.Greenscale.CastBar:Create(unitID)
				end
				self.Greenscale.UnitID = unitID
				self.Greenscale.Available = true
				return self.Greenscale
			end
		end
	end
end

function LG:Reset()
	self.EncounterRunning = false
	self.Greenscale.Available = false
	self.Greenscale.UnitID = nil
	self.Greenscale.CastBar:Remove()
end

function LG:Timer()
	
end

function LG.Greenscale:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		LG.Settings.Timers.FlamesEnabled = bool
		LG.Greenscale.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, LG.Settings.Timers.Enabled)
	--Timers:AddCheck(LG.Lang.Flames[KBM.Lang], self.FlamesEnabled, LG.Settings.Timers.FlamesEnabled)	
	
end

function LG:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Greenscale.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Greenscale, true, self.Header)
	self.Greenscale.MenuItem.Check:SetEnabled(false)
	-- self.Greenscale.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Greenscale.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Greenscale.CastBar = KBM.CastBar:Add(self, self.Greenscale, true)
end