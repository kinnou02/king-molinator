-- Assualt Commander Jorb Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHAJ_Settings = nil
DH = KBMDH_Register()

local AJ = {
	ModEnabled = true,
	Jorb = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = DH.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	ID = "Jorb",
	}

AJ.Jorb = {
	Mod = AJ,
	Level = "??",
	Active = false,
	Name = "Assault Commander Jorb",
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

local KBM = KBM_RegisterMod(AJ.Jorb.ID, AJ)

AJ.Lang.Jorb = KBM.Language:Add(AJ.Jorb.Name)
AJ.Lang.Jorb.German = "Überfallkommandant Jorb"
AJ.Lang.Jorb.French = "Commandant d'assaut Jorb"

AJ.Jorb.Name = AJ.Lang.Jorb[KBM.Lang]

function AJ:AddBosses(KBM_Boss)
	self.Jorb.Descript = self.Jorb.Name
	self.MenuName = self.Jorb.Descript
	self.Bosses = {
		[self.Jorb.Name] = true,
	}
	KBM_Boss[self.Jorb.Name] = self.Jorb	
end

function AJ:InitVars()
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

function AJ:LoadVars()
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

function AJ:SaveVars()
	KBMGSBGS_Settings = self.Settings
end

function AJ:Castbar(units)
end

function AJ:RemoveUnits(UnitID)
	if self.Jorb.UnitID == UnitID then
		self.Jorb.Available = false
		return true
	end
	return false
end

function AJ:Death(UnitID)
	if self.Jorb.UnitID == UnitID then
		self.Jorb.Dead = true
		return true
	end
	return false
end

function AJ:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Jorb.Name then
				if not self.Jorb.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Jorb.Dead = false
					self.Jorb.Casting = false
					self.Jorb.CastBar:Create(unitID)
				end
				self.Jorb.UnitID = unitID
				self.Jorb.Available = true
				return self.Jorb
			end
		end
	end
end

function AJ:Reset()
	self.EncounterRunning = false
	self.Jorb.Available = false
	self.Jorb.UnitID = nil
	self.Jorb.CastBar:Remove()
end

function AJ:Timer()
	
end

function AJ.Jorb:Options()
	function self:TimersEnabled(bool)
	end
	function self:FlamesEnabled(bool)
		AJ.Settings.Timers.FlamesEnabled = bool
		AJ.Jorb.TimersRef.Flames.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, AJ.Settings.Timers.Enabled)
	--Timers:AddCheck(AJ.Lang.Flames[KBM.Lang], self.FlamesEnabled, AJ.Settings.Timers.FlamesEnabled)	
	
end

function AJ:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Jorb.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Jorb, true, self.Header)
	self.Jorb.MenuItem.Check:SetEnabled(false)
	-- self.Jorb.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	-- self.Jorb.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Jorb.CastBar = KBM.CastBar:Add(self, self.Jorb, true)
end