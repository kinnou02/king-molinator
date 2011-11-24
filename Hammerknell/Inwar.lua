-- Inwar Darktide Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMID_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local ID = {
	ModEnabled = true,
	Inwar = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = HK.Name,
	HasPhases = true,
	Phase = 1,
	Timers = {},
	Lang = {},
	ID = "Inwar",
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
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Primary = true,
	Required = 1,
	Triggers = {},
}

ID.Denizar = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Denizar",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false, 
	Available = false,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},
}

ID.Aqualix = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Denizar",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false, 
	Available = false,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},	
}

KBM.RegisterMod(ID.ID, ID)

ID.Lang.Inwar = KBM.Language:Add(ID.Inwar.Name)
ID.Lang.Inwar.German = "Inwar Dunkelflut"
ID.Lang.Inwar.French = "Inwar Noirflux"
ID.Lang.Denizar = KBM.Language:Add(ID.Denizar.Name)
ID.Lang.Aqualix = KBM.Language:Add(ID.Aqualix.Name)

ID.Inwar.Name = ID.Lang.Inwar[KBM.Lang]
ID.Denizar.Name = ID.Lang.Denizar[KBM.Lang]
ID.Aqualix.Name = ID.Lang.Aqualix[KBM.Lang]

function ID:AddBosses(KBM_Boss)
	self.Inwar.Descript = self.Inwar.Name
	self.Denizar.Descript = self.Inwar.Name
	self.Aqualix.Descript = self.Inwar.Name
	self.MenuName = self.Inwar.Descript
	self.Bosses = {
		[self.Inwar.Name] = self.Inwar,
		[self.Denizar.Name] = self.Denizar,
		[self.Aqualix.Name] = self.Aqualix,
	}
	KBM_Boss[self.Inwar.Name] = self.Inwar
	KBM.SubBoss[self.Denizar.Name] = self.Denizar
	KBM.SubBoss[self.Aqualix.Name] = self.Aqualix
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
	else
		if self.Phase == 1 then
			-- First Pair
			if self.Aqualix.UnitID == UnitID then
				self.Aqualix.Dead = true
				self.Aqualix.CastBar:Remove()
			elseif self.Denizar.UnitID == UnitID then
				self.Denizar.Dead = true
				self.Denizar.CastBar:Remove()
			end
			if self.Aqualix.Dead and self.Denizar.Dead then
				self.Phase = self.Phase + 1
				print("Phase 2!")
			end
		elseif self.Phase == 2 then
			-- Towers and Adds
			
		elseif self.Phase == 3 then
		
		end
	end
	return false
end

function ID:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				if not self.Bosses[uDetails.name].UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Phase = 1
				end
				if not self.Bosses[uDetails.name].CastBar.Active then
					self.Bosses[uDetails.name].CastBar:Create(unitID)			
				end
				self.Bosses[uDetails.name].Dead = false
				self.Bosses[uDetails.name].Casting = false
				self.Bosses[uDetails.name].UnitID = unitID
				self.Bosses[uDetails.name].Available = true
				return self.Bosses[uDetails.name]
			end
		end
	end
end

function ID:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		if BossObj.CastBar.Active then
			BossObj.CastBar:Remove()
		end
	end
	self.Phase = 1
end

function ID:Timer()
	
end

function ID.Inwar:Options()
	function self:TimersEnabled(bool)
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.TimersEnabled, ID.Settings.Timers.Enabled)
	
end

function ID:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Inwar.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Inwar, true, self.Header)
	self.Inwar.MenuItem.Check:SetEnabled(false)
	
	self.Inwar.CastBar = KBM.CastBar:Add(self, self.Inwar, true)
	self.Aqualix.CastBar = KBM.CastBar:Add(self, self.Aqualix, false)
	self.Denizar.CastBar = KBM.CastBar:Add(self, self.Denizar, false)
end