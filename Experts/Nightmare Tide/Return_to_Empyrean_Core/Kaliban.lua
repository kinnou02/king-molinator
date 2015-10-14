-- Prince Kaliban Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRTECKAL_Settings = nil
chKBMNTRTECKAL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["RTEmpyrean_Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Kaliban.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RTEC_Kaliban",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Kaliban = KBM.Language:Add("Prince Kaliban")
MOD.Lang.Unit.Kaliban:SetGerman("Prinz Kaliban")
MOD.Lang.Unit.Kaliban:SetFrench("Prince Kaliban")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Radiance = KBM.Language:Add("Princely Radiance")
MOD.Lang.Ability.Radiance:SetFrench("Rayonnement princier")

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.RadianceWarn = KBM.Language:Add("Turn Around!")
MOD.Lang.Verbose.RadianceWarn:SetFrench("Tournez vous!!!")
MOD.Lang.Verbose.TrampleWarn = KBM.Language:Add("Run to center!")
MOD.Lang.Verbose.TrampleWarn:SetFrench("Au milieu!!!")

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Notify Dictionary
MOD.Lang.Notify = {}
MOD.Lang.Notify.Trample = KBM.Language:Add("Prince Kaliban glares at (%a*).")
MOD.Lang.Notify.Trample:SetFrench("Prince Kaliban lance un regard furieux à (%a*)!")
MOD.Lang.Notify.Radiance = KBM.Language:Add("Pince Kaliban's skin begins to glow.")
MOD.Lang.Notify.Radiance:SetFrench("La peau de Prince Kaliban commence à briller.")


-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Kaliban[KBM.Lang]

MOD.Kaliban = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Kaliban[KBM.Lang],
	NameShort = "Kaliban",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U797104833FB30298",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Radiance = KBM.Defaults.AlertObj.Create("red"),
		  Trample = KBM.Defaults.AlertObj.Create("purple")
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kaliban.Name] = self.Kaliban,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kaliban.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Kaliban.Settings.TimersRef,
		AlertsRef = self.Kaliban.Settings.AlertsRef,
	}
	KBMNTRTECKAL_Settings = self.Settings
	chKBMNTRTECKAL_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRTECKAL_Settings = self.Settings
		self.Settings = chKBMNTRTECKAL_Settings
	else
		chKBMNTRTECKAL_Settings = self.Settings
		self.Settings = KBMNTRTECKAL_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRTECKAL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRTECKAL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRTECKAL_Settings = self.Settings
	else
		KBMNTRTECKAL_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRTECKAL_Settings = self.Settings
	else
		KBMNTRTECKAL_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Kaliban.UnitID == UnitID then
		self.Kaliban.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Kaliban.UnitID == UnitID then
		self.Kaliban.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Kaliban.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Kaliban.Dead = false
				self.Kaliban.Casting = false
				self.Kaliban.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Kaliban.Name, 0, 100)
				self.Phase = 1
			end
			self.Kaliban.UnitID = unitID
			self.Kaliban.Available = true
			return self.Kaliban
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Kaliban.Available = false
	self.Kaliban.UnitID = nil
	self.Kaliban.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	self.Kaliban.AlertsRef.Radiance = KBM.Alert:Create(self.Lang.Verbose.RadianceWarn[KBM.Lang], nil, true, true, "red")
	self.Kaliban.AlertsRef.Trample = KBM.Alert:Create(self.Lang.Verbose.TrampleWarn[KBM.Lang], 1, true, false, "purple")
	KBM.Defaults.AlertObj.Assign(self.Kaliban)
	
	-- Assign Alerts and Timers to Triggers
	self.Kaliban.Triggers.Radiance = KBM.Trigger:Create(self.Lang.Ability.Radiance[KBM.Lang], "cast", self.Kaliban)
  self.Kaliban.Triggers.Radiance:AddAlert(self.Kaliban.AlertsRef.Radiance)
  
  self.Kaliban.Triggers.Trample = KBM.Trigger:Create(self.Lang.Notify.Trample[KBM.Lang], "notify", self.Kaliban)
  self.Kaliban.Triggers.Trample:AddAlert(self.Kaliban.AlertsRef.Trample, true)
	
	
	self.Kaliban.CastBar = KBM.Castbar:Add(self, self.Kaliban)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end