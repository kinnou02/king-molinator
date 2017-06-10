-- Houndmaster Kytus Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMPOAIGFKYT_Settings = nil
chKBMPOAIGFKYT_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Intrepid_Gyel_Fortress"]

local MOD = {
	Directory = Instance.Directory,
	File = "Kytus.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "IGF_Kytus",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Kytus = KBM.Language:Add("Houndmaster Kytus")
MOD.Lang.Unit.Kytus:SetFrench("Maître-chien Kytus")

-- Additional Unit Dictionary
MOD.Lang.Unit.Rex = KBM.Language:Add("Infernus Rex")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Howl = KBM.Language:Add("Howl of Terror")
MOD.Lang.Ability.Howl:SetFrench("Hurlement de terreur")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Notify Dictionary
MOD.Lang.Notify = {}
MOD.Lang.Notify.Howl = KBM.Language:Add("Infernus Rex begins to howl!")
MOD.Lang.Notify.Howl:SetFrench("Infernus Rex se met à hurler!")

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Kytus[KBM.Lang]

MOD.Kytus = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Kytus[KBM.Lang],
	--NameShort = "Kytus",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U66316BC375369BE0",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

MOD.Rex = {
  Mod = MOD,
  Level = "??",
  Name = MOD.Lang.Unit.Rex[KBM.Lang],
  NameShort = "Rex",
  Castbar = nil,
  AlertsRef = {},
  UTID = "U486E2F487A729E18",
  UnitID = nil,
  Triggers = {},
  Settings = {
    CastBar = KBM.Defaults.Castbar(),
    AlertsRef = {
      Enabled = true,
      Howl = KBM.Defaults.AlertObj.Create("red"),
    },
  },
}

KBM.RegisterMod(MOD.ID, MOD)



function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kytus.Name] = self.Kytus,
		[self.Rex.Name] = self.Rex,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kytus.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Rex.Settings.AlertsRef,
	}
	KBMPOAIGFKYT_Settings = self.Settings
	chKBMPOAIGFKYT_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMPOAIGFKYT_Settings = self.Settings
		self.Settings = chKBMPOAIGFKYT_Settings
	else
		chKBMPOAIGFKYT_Settings = self.Settings
		self.Settings = KBMPOAIGFKYT_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPOAIGFKYT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPOAIGFKYT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPOAIGFKYT_Settings = self.Settings
	else
		KBMPOAIGFKYT_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMPOAIGFKYT_Settings = self.Settings
	else
		KBMPOAIGFKYT_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Kytus.UnitID == UnitID then
		self.Kytus.Available = false
		return true
	elseif self.Rex.UnitID == UnitID then
	 self.Rex.Available = false
	end
	return false
end

function MOD:Death(UnitID)
	if self.Kytus.UnitID == UnitID then
		self.Kytus.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Kytus.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Kytus.Dead = false
				self.Kytus.Casting = false
				--self.Kytus.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Kytus, 0, 100)
				self.Phase = 1
			end
			self.Kytus.UnitID = unitID
			self.Kytus.Available = true
			return self.Kytus
		end
	  elseif uDetails.type == self.Rex.UTID then
        self.Rex.Dead = false
        self.Rex.Casting = false
        self.Rex.CastBar:Create(unitID)
        self.PhaseObj.Objectives:AddPercent(self.Rex.Name, 0, 100)
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Kytus.Available = false
	self.Kytus.UnitID = nil
	self.Rex.CastBar:Remove()
	self.Rex.Available = false
	self.Rex.UnitID = nil
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	--self.Rex.AlertsRef.Howl = KBM.Alert:Create(self.Lang.Ability.Howl[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Rex)
	
	-- Assign Alerts and Timers to Triggers
	--self.Rex.Triggers.Howl = KBM.Trigger:Create(self.Lang.Ability.Howl[KBM.Lang], "cast", self.Rex)
	--self.Rex.Triggers.Howl:AddAlert(self.Rex.AlertsRef.Howl)
	
	self.Rex.CastBar = KBM.Castbar:Add(self, self.Rex)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end
