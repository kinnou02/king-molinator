-- Seathe Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTGFSEA_Settings = nil
chKBMNTGFSEA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Gyel_Fortress"]

local MOD = {
	Directory = Instance.Directory,
	File = "Seathe.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "GF_Seathe",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Seathe = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Seathe",
	--NameShort = "Seathe",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U4E6AA198560A6EF7",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Fervor = KBM.Defaults.AlertObj.Create("red"),
		  Triferno = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Seathe = KBM.Language:Add(MOD.Seathe.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Fervor = KBM.Language:Add("Fervor of the Branded")
MOD.Lang.Ability.Fervor:SetFrench("Ferveur des Marqués")
MOD.Lang.Ability.Triferno = KBM.Language:Add("Triferno")
MOD.Lang.Ability.Triferno:SetFrench("Trienfer")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Seathe[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Seathe.Name] = self.Seathe,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Seathe.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Seathe.Settings.AlertsRef,
	}
	KBMNTGFSEA_Settings = self.Settings
	chKBMNTGFSEA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTGFSEA_Settings = self.Settings
		self.Settings = chKBMNTGFSEA_Settings
	else
		chKBMNTGFSEA_Settings = self.Settings
		self.Settings = KBMNTGFSEA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTGFSEA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTGFSEA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTGFSEA_Settings = self.Settings
	else
		KBMNTGFSEA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTGFSEA_Settings = self.Settings
	else
		KBMNTGFSEA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Seathe.UnitID == UnitID then
		self.Seathe.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Seathe.UnitID == UnitID then
		self.Seathe.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Seathe.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Seathe.Dead = false
				self.Seathe.Casting = false
				self.Seathe.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Seathe, 0, 100)
				self.Phase = 1
			end
			self.Seathe.UnitID = unitID
			self.Seathe.Available = true
			return self.Seathe
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Seathe.Available = false
	self.Seathe.UnitID = nil
	self.Seathe.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	--self.Seathe.AlertsRef.Fervor = KBM.Alert:Create(self.Lang.Ability.Fervor[KBM.Lang], nil, true, true, "red")
	self.Seathe.AlertsRef.Triferno = KBM.Alert:Create(self.Lang.Ability.Triferno[KBM.Lang], nil, true, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Seathe)
	
	-- Assign Alerts and Timers to Triggers
	--self.Seathe.Triggers.Fervor = KBM.Trigger:Create(self.Lang.Ability.Fervor[KBM.Lang], "cast", self.Seathe)
	--self.Seathe.Triggers.Fervor:AddAlert(self.Seathe.AlertsRef.Fervor)
  
	self.Seathe.Triggers.Triferno = KBM.Trigger:Create(self.Lang.Ability.Triferno[KBM.Lang], "channel", self.Seathe)
	self.Seathe.Triggers.Triferno:AddAlert(self.Seathe.AlertsRef.Triferno)
	
	self.Seathe.CastBar = KBM.Castbar:Add(self, self.Seathe)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end