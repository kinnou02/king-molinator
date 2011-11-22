-- Anrak the Foul Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGPAF_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GP = KBM.BossMod["Guilded Prophecy"]

local AF = {
	ModEnabled = true,
	Anrak = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = GP.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	Enrage = 60 * 7,
	ID = "Anrak",
	}

AF.Anrak = {
	Mod = AF,
	Level = "??",
	Active = false,
	Name = "Anrak the Foul",
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

KBM.RegisterMod(AF.ID, AF)

AF.Lang.Anrak = KBM.Language:Add(AF.Anrak.Name)
AF.Lang.Anrak.German = "Anrak der Üble"
AF.Lang.Anrak.French = "Anrak l'ignoble"

AF.Anrak.Name = AF.Lang.Anrak[KBM.Lang]

function AF:AddBosses(KBM_Boss)
	self.Anrak.Descript = self.Anrak.Name
	self.MenuName = self.Anrak.Descript
	self.Bosses = {
		[self.Anrak.Name] = true,
	}
	KBM_Boss[self.Anrak.Name] = self.Anrak	
end

function AF:InitVars()
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

function AF:LoadVars()
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

function AF:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function AF:Castbar(units)
end

function AF:RemoveUnits(UnitID)
	if self.Anrak.UnitID == UnitID then
		self.Anrak.Available = false
		return true
	end
	return false
end

function AF:Death(UnitID)
	if self.Anrak.UnitID == UnitID then
		self.Anrak.Dead = true
		return true
	end
	return false
end

function AF:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Anrak.Name then
				if not self.Anrak.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Anrak.Dead = false
					self.Anrak.Casting = false
					self.Anrak.CastBar:Create(unitID)
				end
				self.Anrak.UnitID = unitID
				self.Anrak.Available = true
				return self.Anrak
			end
		end
	end
end

function AF:Reset()
	self.EncounterRunning = false
	self.Anrak.Available = false
	self.Anrak.UnitID = nil
	self.Anrak.CastBar:Remove()
end

function AF:Timer()
	
end

function AF.Anrak:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		AF.Settings.Timers.FlamesEnabled = bool
		AF.Anrak.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, AF.Settings.Timers.Enabled)
	--Timers:AddCheck(AF.Lang.Flames[KBM.Lang], self.FlamesEnabled, AF.Settings.Timers.FlamesEnabled)	
	
end

function AF:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Anrak.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Anrak, true, self.Header)
	self.Anrak.MenuItem.Check:SetEnabled(false)
	-- self.Anrak.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Anrak.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Anrak.CastBar = KBM.CastBar:Add(self, self.Anrak, true)
end