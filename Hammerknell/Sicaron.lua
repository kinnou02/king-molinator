-- Sicaron Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSN_Settings = nil
HK = KBMHK_Register()

local SN = {
	ModEnabled = true,
	Sicaron = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		ID = "Sicaron",
	},
	Instance = HK.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	Enrage = 60 * 12,
}

SN.Sicaron = {
	Mod = SN,
	Level = "??",
	Active = false,
	Name = "Sicaron",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
}

local KBM = KBM_RegisterMod(SN.Sicaron.ID, SN)

SN.Lang.Sicaron = KBM.Language:Add(SN.Sicaron.Name)

SN.Sicaron.Name = SN.Lang.Sicaron[KBM.Lang]

function SN:AddBosses(KBM_Boss)
	self.Sicaron.Descript = self.Sicaron.Name
	self.MenuName = self.Sicaron.Descript
	self.Bosses = {
		[self.Sicaron.Name] = true,
	}
	KBM_Boss[self.Sicaron.Name] = self.Sicaron	
end

function SN:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMSN_Settings = self.Settings
end

function SN:LoadVars()
	if type(KBMSN_Settings) == "table" then
		for Setting, Value in pairs(KBMSN_Settings) do
			if type(KBMSN_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMSN_Settings[Setting]) do
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

function SN:SaveVars()
	KBMSN_Settings = self.Settings
end

function SN:Castbar(units)
end

function SN:RemoveUnits(UnitID)
	if self.Sicaron.UnitID == UnitID then
		self.Sicaron.Available = false
		return true
	end
	return false
end

function SN:Death(UnitID)
	if self.Sicaron.UnitID == UnitID then
		self.Sicaron.Dead = true
		return true
	end
	return false
end

function SN:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Sicaron.Name then
				if not self.Sicaron.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Sicaron.Dead = false
					self.Sicaron.Casting = false
					self.Sicaron.CastBar:Create(unitID)
				end
				self.Sicaron.UnitID = unitID
				self.Sicaron.Available = true
				return self.Sicaron
			end
		end
	end
end

function SN:Reset()
	self.EncounterRunning = false
	self.Sicaron.Available = false
	self.Sicaron.UnitID = nil
	self.Sicaron.CastBar:Remove()
end

function SN:Timer()
	
end

function SN.Sicaron:Options()
	function self:TimersEnabled(bool)
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, SN.Settings.Timers.Enabled)
	--Timers:AddCheck(SN.Lang.Flames[KBM.Lang], self.FlamesEnabled, SN.Settings.Timers.FlamesEnabled)	
	
end

function SN:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Sicaron.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Sicaron, true, self.Header)
	self.Sicaron.MenuItem.Check:SetEnabled(false)
	--self.Sicaron.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	--self.Sicaron.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Sicaron.CastBar = KBM.CastBar:Add(self, self.Sicaron, true)
end