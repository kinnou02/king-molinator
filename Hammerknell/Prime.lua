-- Vladmal Prime Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMVP_Settings = nil
HK = KBMHK_Register()

local VP = {
	ModEnabled = true,
	Prime = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		ID = "Prime",
	},
	Instance = HK.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	Enrage = 60 * 11, 
}

VP.Prime = {
	Mod = VP,
	Level = "??",
	Active = false,
	Name = "Vladmal Prime",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
}

local KBM = KBM_RegisterMod(VP.Prime.ID, VP)

VP.Lang.Prime = KBM.Language:Add(VP.Prime.Name)
VP.Lang.Flames = KBM.Language:Add("Ancient Flames")
VP.Lang.Flames.French = "Flammes anciennes"

VP.Prime.Name = VP.Lang.Prime[KBM.Lang]

function VP:AddBosses(KBM_Boss)
	self.Prime.Descript = self.Prime.Name
	self.MenuName = self.Prime.Descript
	self.Bosses = {
		[self.Prime.Name] = true,
	}
	KBM_Boss[self.Prime.Name] = self.Prime	
end

function VP:InitVars()
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
	KBMVP_Settings = self.Settings
end

function VP:LoadVars()
	if type(KBMVP_Settings) == "table" then
		for Setting, Value in pairs(KBMVP_Settings) do
			if type(KBMVP_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMVP_Settings[Setting]) do
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

function VP:SaveVars()
	KBMVP_Settings = self.Settings
end

function VP:Castbar(units)
end

function VP:RemoveUnits(UnitID)
	if self.Prime.UnitID == UnitID then
		self.Prime.Available = false
		return true
	end
	return false
end

function VP:Death(UnitID)
	if self.Prime.UnitID == UnitID then
		self.Prime.Dead = true
		return true
	end
	return false
end

function VP:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Prime.Name then
				if not self.Prime.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Prime.Dead = false
					self.Prime.Casting = false
					self.Prime.CastBar:Create(unitID)
				end
				self.Prime.UnitID = unitID
				self.Prime.Available = true
				return self.Prime
			end
		end
	end
end

function VP:Reset()
	self.EncounterRunning = false
	self.Prime.Available = false
	self.Prime.UnitID = nil
	self.Prime.CastBar:Remove()
end

function VP:Timer()
	
end

function VP.Prime:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		VP.Settings.Timers.FlamesEnabled = bool
		VP.Prime.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, VP.Settings.Timers.Enabled)
	Timers:AddCheck(VP.Lang.Flames[KBM.Lang], self.FlamesEnabled, VP.Settings.Timers.FlamesEnabled)	
	
end

function VP:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Prime.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Prime, true, self.Header)
	self.Prime.MenuItem.Check:SetEnabled(false)
	self.Prime.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	self.Prime.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Prime.CastBar = KBM.CastBar:Add(self, self.Prime, true)
end