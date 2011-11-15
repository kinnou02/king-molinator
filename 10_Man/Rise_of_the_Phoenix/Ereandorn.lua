-- Ereandorn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPEN_Settings = nil
ROTP = KBMROTP_Register()

local EN = {
	ModEnabled = true,
	Ereandorn = {
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
	ID = "Ereandorn",
	}

EN.Ereandorn = {
	Mod = EN,
	Level = "??",
	Active = false,
	Name = "Ereandorn",
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

local KBM = KBM_RegisterMod(EN.Ereandorn.ID, EN)

EN.Lang.Ereandorn = KBM.Language:Add(EN.Ereandorn.Name)
-- EN.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- EN.Lang.Flames.French = "Flammes anciennes"

EN.Ereandorn.Name = EN.Lang.Ereandorn[KBM.Lang]

function EN:AddBosses(KBM_Boss)
	self.Ereandorn.Descript = self.Ereandorn.Name
	self.MenuName = self.Ereandorn.Descript
	self.Bosses = {
		[self.Ereandorn.Name] = true,
	}
	KBM_Boss[self.Ereandorn.Name] = self.Ereandorn	
end

function EN:InitVars()
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
	KBMEN_Settings = self.Settings
end

function EN:LoadVars()
	if type(KBMGSBEN_Settings) == "table" then
		for Setting, Value in pairs(KBMGSBEN_Settings) do
			if type(KBMGSBEN_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMGSBEN_Settings[Setting]) do
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

function EN:SaveVars()
	KBMGSBEN_Settings = self.Settings
end

function EN:Castbar(units)
end

function EN:RemoveUnits(UnitID)
	if self.Ereandorn.UnitID == UnitID then
		self.Ereandorn.Available = false
		return true
	end
	return false
end

function EN:Death(UnitID)
	if self.Ereandorn.UnitID == UnitID then
		self.Ereandorn.Dead = true
		return true
	end
	return false
end

function EN:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Ereandorn.Name then
				if not self.Ereandorn.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ereandorn.Dead = false
					self.Ereandorn.Casting = false
					self.Ereandorn.CastBar:Create(unitID)
				end
				self.Ereandorn.UnitID = unitID
				self.Ereandorn.Available = true
				return self.Ereandorn
			end
		end
	end
end

function EN:Reset()
	self.EncounterRunning = false
	self.Ereandorn.Available = false
	self.Ereandorn.UnitID = nil
	self.Ereandorn.CastBar:Remove()
end

function EN:Timer()
	
end

function EN.Ereandorn:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		EN.Settings.Timers.FlamesEnabled = bool
		EN.Ereandorn.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, EN.Settings.Timers.Enabled)
	--Timers:AddCheck(EN.Lang.Flames[KBM.Lang], self.FlamesEnabled, EN.Settings.Timers.FlamesEnabled)	
	
end

function EN:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Ereandorn.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Ereandorn, true, self.Header)
	self.Ereandorn.MenuItem.Check:SetEnabled(false)
	-- self.Ereandorn.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Ereandorn.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Ereandorn.CastBar = KBM.CastBar:Add(self, self.Ereandorn, true)
end