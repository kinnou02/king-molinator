-- TarJulia Boss Mod for King Boss Mods
-- Written by Wicendawen

KBMPOATDTAR_Settings = nil
chKBMPOATDTAR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Tartaric_Depths"]

local MOD = {
	Directory = Instance.Directory,
	File = "TarJulia.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "TarJulia",
	Object = "MOD",
}

MOD.TarJulia = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "TarJulia",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U1218D6C904266DB4",
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
MOD.Lang.Unit.TarJulia = KBM.Language:Add(MOD.TarJulia.Name)

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
MOD.Descript = MOD.Lang.Unit.TarJulia[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.TarJulia.Name] = self.TarJulia,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.TarJulia.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.TarJulia.Settings.AlertsRef,
	}
	KBMPOATDTAR_Settings = self.Settings
	chKBMPOATDTAR_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMPOATDTAR_Settings = self.Settings
		self.Settings = chKBMPOATDTAR_Settings
	else
		chKBMPOATDTAR_Settings = self.Settings
		self.Settings = KBMPOATDTAR_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPOATDTAR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPOATDTAR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPOATDTAR_Settings = self.Settings
	else
		KBMPOATDTAR_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMPOATDTAR_Settings = self.Settings
	else
		KBMPOATDTAR_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.TarJulia.UnitID == UnitID then
		self.TarJulia.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.TarJulia.UnitID == UnitID then
		self.TarJulia.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)
	if uDetails and unitID then
		if uDetails.type == self.TarJulia.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.TarJulia.Dead = false
				self.TarJulia.Casting = false
				self.TarJulia.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.TarJulia, 0, 100)
				self.Phase = 1
			end
			self.TarJulia.UnitID = unitID
			self.TarJulia.Available = true
			return self.TarJulia
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.TarJulia.Available = false
	self.TarJulia.UnitID = nil
	self.TarJulia.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	
	-- Create Alerts
	
	-- Assign Alerts and Timers to Triggers
	self.TarJulia.CastBar = KBM.Castbar:Add(self, self.TarJulia)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end
