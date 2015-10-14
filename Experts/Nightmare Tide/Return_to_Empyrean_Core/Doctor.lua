-- Doctor Perfidus Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRTECDOC_Settings = nil
chKBMNTRTECDOC_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["RTEmpyrean_Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Doctor.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RTEC_Doctor",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Doctor = KBM.Language:Add("Doctor Perfidus")
MOD.Lang.Unit.Doctor:SetGerman("Doktor Perfidus")
MOD.Lang.Unit.Doctor:SetFrench("Docteur Perfidus")

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.Shield = KBM.Language:Add("Shield Down")
MOD.Lang.Verbose.Shield:SetFrench("Bouclier tombé!!!")


-- Buff Dictionary
MOD.Lang.Buff = {}
MOD.Lang.Buff.Shield = KBM.Language:Add("Impenetrable Barrier")
MOD.Lang.Buff.Shield:SetFrench("Barrière impénétrable")

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Notify Dictionary
MOD.Lang.Notify = {}
MOD.Lang.Notify.Victory = KBM.Language:Add("Who will take care of my beautiful creations?")
MOD.Lang.Notify.Victory:SetFrench("Qui prendra soin de mes fabuleuses créations ?")

MOD.Doctor = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Doctor[KBM.Lang],
	NameShort = "Doctor",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U6D36462226900797",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Shield = KBM.Defaults.AlertObj.Create("red"),
		},
	},
}


KBM.RegisterMod(MOD.ID, MOD)

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Doctor[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Doctor.Name] = self.Doctor,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Doctor.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Doctor.Settings.TimersRef,
		AlertsRef = self.Doctor.Settings.AlertsRef,
	}
	KBMNTRTECDOC_Settings = self.Settings
	chKBMNTRTECDOC_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRTECDOC_Settings = self.Settings
		self.Settings = chKBMNTRTECDOC_Settings
	else
		chKBMNTRTECDOC_Settings = self.Settings
		self.Settings = KBMNTRTECDOC_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRTECDOC_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRTECDOC_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRTECDOC_Settings = self.Settings
	else
		KBMNTRTECDOC_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRTECDOC_Settings = self.Settings
	else
		KBMNTRTECDOC_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Doctor.UnitID == UnitID then
		self.Doctor.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Doctor.UnitID == UnitID then
		self.Doctor.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Doctor.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Doctor.Dead = false
				self.Doctor.Casting = false
				self.Doctor.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Doctor, 0, 100)
				self.Phase = 1
			end
			self.Doctor.UnitID = unitID
			self.Doctor.Available = true
			return self.Doctor
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Doctor.Available = false
	self.Doctor.UnitID = nil
	self.Doctor.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Doctor)
	
	-- Create Alerts
	self.Doctor.AlertsRef.Shield = KBM.Alert:Create(self.Lang.Verbose.Shield[KBM.Lang], nil, true, false, "blue")
	KBM.Defaults.AlertObj.Assign(self.Doctor)
	
	-- Assign Alerts and Timers to Triggers
	self.Doctor.Triggers.Shield = KBM.Trigger:Create(self.Lang.Buff.Shield[KBM.Lang], "buffRemove", self.Doctor)
	self.Doctor.Triggers.Shield:AddAlert(self.Doctor.AlertsRef.Shield)
	
	self.Doctor.CastBar = KBM.Castbar:Add(self, self.Doctor)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end