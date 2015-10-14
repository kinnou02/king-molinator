-- Cor Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRTECCOR_Settings = nil
chKBMNTRTECCOR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["RTEmpyrean_Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Cor.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RTEC_Cor",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Cor = KBM.Language:Add("Cor")
MOD.Lang.Unit.Cor:SetFrench("Cor")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Radiation = KBM.Language:Add("Radiation")
MOD.Lang.Ability.Radiation:SetFrench("Radiation")
MOD.Lang.Ability.Frenzy = KBM.Language:Add("Frenzy")
MOD.Lang.Ability.Frenzy:SetFrench("Frénésie")

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.RadiationWarn = KBM.Language:Add("Spread!")
MOD.Lang.Verbose.RadiationWarn:SetFrench("Dispersion!!!")
MOD.Lang.Verbose.FrenzyWarn = KBM.Language:Add("Stack Together!")
MOD.Lang.Verbose.FrenzyWarn:SetFrench("Packez vous!!!")

-- Buff Dictionary
MOD.Lang.Buff = {}
MOD.Lang.Buff.Frenzy = KBM.Language:Add("Frenzy")
MOD.Lang.Buff.Frenzy:SetFrench("Frénésie")
MOD.Lang.Buff.Radiation = KBM.Language:Add("Radiation")
MOD.Lang.Buff.Radiation:SetFrench("Radiation")

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Cor[KBM.Lang]

MOD.Cor = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Cor[KBM.Lang],
	--NameShort = "",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFC6AC0880D0024B6",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Frenzy = KBM.Defaults.AlertObj.Create("red"),
			Radiation = KBM.Defaults.AlertObj.Create("purple"),
			},
		},
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Cor.Name] = self.Cor,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Cor.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Cor.Settings.TimersRef,
		AlertsRef = self.Cor.Settings.AlertsRef,
	}
	KBMNTRTECCOR_Settings = self.Settings
	chKBMNTRTECCOR_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRTECCOR_Settings = self.Settings
		self.Settings = chKBMNTRTECCOR_Settings
	else
		chKBMNTRTECCOR_Settings = self.Settings
		self.Settings = KBMNTRTECCOR_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRTECCOR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRTECCOR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRTECCOR_Settings = self.Settings
	else
		KBMNTRTECCOR_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRTECCOR_Settings = self.Settings
	else
		KBMNTRTECCOR_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Cor.UnitID == UnitID then
		self.Cor.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Cor.UnitID == UnitID then
		self.Cor.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Cor.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Cor.Dead = false
				self.Cor.Casting = false
				self.Cor.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Cor.Name, 0, 100)
				self.Phase = 1
			end
			self.Cor.UnitID = unitID
			self.Cor.Available = true
			return self.Cor
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Cor.Available = false
	self.Cor.UnitID = nil
	self.Cor.CastBar:Remove()
	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Cor)
	
	-- Create Alerts
	self.Cor.AlertsRef.Frenzy = KBM.Alert:Create(self.Lang.Verbose.FrenzyWarn[KBM.Lang], nil, false, false, "red")
	self.Cor.AlertsRef.Radiation = KBM.Alert:Create(self.Lang.Verbose.RadiationWarn[KBM.Lang], nil, false, false, "purple") 
	KBM.Defaults.AlertObj.Assign(self.Cor)
	
	-- Assign Alerts and Timers to Triggers
	self.Cor.Triggers.Frenzy = KBM.Trigger:Create(self.Lang.Ability.Frenzy[KBM.Lang], "cast", self.Cor)
	self.Cor.Triggers.Radiation = KBM.Trigger:Create(self.Lang.Ability.Radiation[KBM.Lang], "cast", self.Cor)
	self.Cor.Triggers.Frenzy:AddAlert(self.Cor.AlertsRef.Frenzy)
	self.Cor.Triggers.Radiation:AddAlert(self.Cor.AlertsRef.Radiation)
	
	
	self.Cor.CastBar = KBM.Castbar:Add(self, self.Cor)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end