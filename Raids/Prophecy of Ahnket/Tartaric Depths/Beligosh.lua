-- Beligosh Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOATDBEL_Settings = nil
chKBMPOATDBEL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Tartaric_Depths"]

local MOD = {
	Directory = Instance.Directory,
	File = "Beligosh.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "beligosh",
	Object = "MOD",
}

MOD.Beligosh = {
	Mod = MOD,
	Level = "72",
	Active = false,
	Name = "Beligosh",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U660817DD7F651CD6",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Beligosh = KBM.Language:Add(MOD.Beligosh.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Beligosh[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Beligosh.Name] = self.Beligosh,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Beligosh.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Beligosh.Settings.AlertsRef,
	}
	KBMPOATDBEL_Settings = self.Settings
	chKBMPOATDBEL_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMPOATDBEL_Settings = self.Settings
		self.Settings = chKBMPOATDBEL_Settings
	else
		chKBMPOATDBEL_Settings = self.Settings
		self.Settings = KBMPOATDBEL_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPOATDBEL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPOATDBEL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPOATDBEL_Settings = self.Settings
	else
		KBMPOATDBEL_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMPOATDBEL_Settings = self.Settings
	else
		KBMPOATDBEL_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Beligosh.UnitID == UnitID then
		self.Beligosh.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Beligosh.UnitID == UnitID then
		self.Beligosh.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)
	if uDetails and unitID then
		if uDetails.type == self.Beligosh.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Beligosh.Dead = false
				self.Beligosh.Casting = false
				self.Beligosh.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Beligosh, 0, 100)
				self.Phase = 1
			end
			self.Beligosh.UnitID = unitID
			self.Beligosh.Available = true
			return self.Beligosh
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Beligosh.Available = false
	self.Beligosh.UnitID = nil
	self.Beligosh.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	
	-- Create Alerts
	
	-- Assign Alerts and Timers to Triggers
	self.Beligosh.CastBar = KBM.Castbar:Add(self, self.Beligosh)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end
