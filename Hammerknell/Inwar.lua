-- Inwar Darktide Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMID_Settings = nil
HK = KBMHK_Register()

local ID = {
	ModEnabled = true,
	Inwar = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		ID = "Inwar",
	},
	Instance = HK.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
}

ID.Inwar = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Inwar Darktide",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
}

local KBM = KBM_RegisterMod(ID.Inwar.ID, ID)

ID.Lang.Inwar = KBM.Language:Add(ID.Inwar.Name)
ID.Lang.Inwar.German = "Inwar Dunkelflut"

ID.Inwar.Name = ID.Lang.Inwar[KBM.Lang]

function ID:AddBosses(KBM_Boss)
	self.Inwar.Descript = self.Inwar.Name
	self.MenuName = self.Inwar.Descript
	self.Bosses = {
		[self.Inwar.Name] = true,
	}
	KBM_Boss[self.Inwar.Name] = self.Inwar	
end

function ID:InitVars()
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
	KBMID_Settings = self.Settings
end

function ID:LoadVars()
	if type(KBMID_Settings) == "table" then
		for Setting, Value in pairs(KBMID_Settings) do
			if type(KBMID_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMID_Settings[Setting]) do
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

function ID:SaveVars()
	KBMID_Settings = self.Settings
end

function ID:Castbar(units)
end

function ID:RemoveUnits(UnitID)
	if self.Inwar.UnitID == UnitID then
		self.Inwar.Available = false
		return true
	end
	return false
end

function ID:Death(UnitID)
	if self.Inwar.UnitID == UnitID then
		self.Inwar.Dead = true
		return true
	end
	return false
end

function ID:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Inwar.Name then
				if not self.Inwar.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Inwar.Dead = false
					self.Inwar.Casting = false
					self.Inwar.CastBar:Create(unitID)
				end
				self.Inwar.UnitID = unitID
				self.Inwar.Available = true
				return self.Inwar
			end
		end
	end
end

function ID:Reset()
	self.EncounterRunning = false
	self.Inwar.Available = false
	self.Inwar.UnitID = nil
	self.Inwar.CastBar:Remove()
end

function ID:Timer()
	
end

function ID.Inwar:Options()
	function self:TimersEnabled(bool)
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, ID.Settings.Timers.Enabled)
	--Timers:AddCheck(ID.Lang.Flames[KBM.Lang], self.FlamesEnabled, ID.Settings.Timers.FlamesEnabled)	
	
end

function ID:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Inwar.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Inwar, true, self.Header)
	self.Inwar.MenuItem.Check:SetEnabled(false)
	--self.Inwar.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	--self.Inwar.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Inwar.CastBar = KBM.CastBar:Add(self, self.Inwar, true)
end