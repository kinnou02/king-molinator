-- Duke Letareus Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBDL_Settings = nil
GSB = KBMGSB_Register()

local DL = {
	ModEnabled = true,
	Letareus = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		ID = "Letareus",
	},
	Instance = GSB.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	Enrage = 60 * 11, 
}

DL.Letareus = {
	Mod = DL,
	Level = "??",
	Active = false,
	Name = "Duke Letareus",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
}

local KBM = KBM_RegisterMod(DL.Letareus.ID, DL)

DL.Lang.Letareus = KBM.Language:Add(DL.Letareus.Name)
-- DL.Lang.Flames = KBM.Language:Add("Ancient Flames")
-- DL.Lang.Flames.French = "Flammes anciennes"

DL.Letareus.Name = DL.Lang.Letareus[KBM.Lang]

function DL:AddBosses(KBM_Boss)
	self.Letareus.Descript = self.Letareus.Name
	self.MenuName = self.Letareus.Descript
	self.Bosses = {
		[self.Letareus.Name] = true,
	}
	KBM_Boss[self.Letareus.Name] = self.Letareus	
end

function DL:InitVars()
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
	KBMDL_Settings = self.Settings
end

function DL:LoadVars()
	if type(KBMGSBDL_Settings) == "table" then
		for Setting, Value in pairs(KBMGSBDL_Settings) do
			if type(KBMGSBDL_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMGSBDL_Settings[Setting]) do
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

function DL:SaveVars()
	KBMGSBDL_Settings = self.Settings
end

function DL:Castbar(units)
end

function DL:RemoveUnits(UnitID)
	if self.Letareus.UnitID == UnitID then
		self.Letareus.Available = false
		return true
	end
	return false
end

function DL:Death(UnitID)
	if self.Letareus.UnitID == UnitID then
		self.Letareus.Dead = true
		return true
	end
	return false
end

function DL:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Letareus.Name then
				if not self.Letareus.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Letareus.Dead = false
					self.Letareus.Casting = false
					self.Letareus.CastBar:Create(unitID)
				end
				self.Letareus.UnitID = unitID
				self.Letareus.Available = true
				return self.Letareus
			end
		end
	end
end

function DL:Reset()
	self.EncounterRunning = false
	self.Letareus.Available = false
	self.Letareus.UnitID = nil
	self.Letareus.CastBar:Remove()
end

function DL:Timer()
	
end

function DL.Letareus:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		DL.Settings.Timers.FlamesEnabled = bool
		DL.Letareus.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, DL.Settings.Timers.Enabled)
	--Timers:AddCheck(DL.Lang.Flames[KBM.Lang], self.FlamesEnabled, DL.Settings.Timers.FlamesEnabled)	
	
end

function DL:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Letareus.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Letareus, true, self.Header)
	self.Letareus.MenuItem.Check:SetEnabled(false)
	-- self.Letareus.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Letareus.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Letareus.CastBar = KBM.CastBar:Add(self, self.Letareus, true)
end