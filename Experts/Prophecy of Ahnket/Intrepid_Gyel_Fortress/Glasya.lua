-- Lady Glasya Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMPOAIGFGLA_Settings = nil
chKBMPOAIGFGLA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Intrepid_Gyel_Fortress"]

local MOD = {
	Directory = Instance.Directory,
	File = "Glasya.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "IGF_Glasya",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Glasya = KBM.Language:Add("Lady Glasya")
MOD.Lang.Unit.Glasya:SetFrench("Dame Glasya")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Void = KBM.Language:Add("Void")
MOD.Lang.Ability.Void:SetFrench("Néant")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Notify Dictionary
MOD.Lang.Notify = {}
MOD.Lang.Notify.Victory = KBM.Language:Add("Samekh says, \"Look, how this devil child clings to our gifts.\"")
MOD.Lang.Notify.Victory:SetFrench("Samekh dit : \"Voyez, comme cette malfaisante enfant s'accroche à nos dons !\"")

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Glasya[KBM.Lang]


MOD.Glasya = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Glasya[KBM.Lang],
	NameShort = "Glasya",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U211454857684D6A4",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Void = KBM.Defaults.AlertObj.Create("blue"),
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Glasya.Name] = self.Glasya,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Glasya.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Glasya.Settings.AlertsRef,
	}
	KBMPOAIGFGLA_Settings = self.Settings
	chKBMPOAIGFGLA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMPOAIGFGLA_Settings = self.Settings
		self.Settings = chKBMPOAIGFGLA_Settings
	else
		chKBMPOAIGFGLA_Settings = self.Settings
		self.Settings = KBMPOAIGFGLA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPOAIGFGLA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPOAIGFGLA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPOAIGFGLA_Settings = self.Settings
	else
		KBMPOAIGFGLA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMPOAIGFGLA_Settings = self.Settings
	else
		KBMPOAIGFGLA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Glasya.UnitID == UnitID then
		self.Glasya.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Glasya.UnitID == UnitID then
		self.Glasya.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Glasya.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Glasya.Dead = false
				self.Glasya.Casting = false
				self.Glasya.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Glasya.Name, 0, 100)
				self.Phase = 1
			end
			self.Glasya.UnitID = unitID
			self.Glasya.Available = true
			return self.Glasya
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Glasya.Available = false
	self.Glasya.UnitID = nil
	self.Glasya.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Glasya)
	
	-- Create Alerts
	self.Glasya.AlertsRef.Void = KBM.Alert:Create(self.Lang.Ability.Void[KBM.Lang], nil, true, true, "blue")
	KBM.Defaults.AlertObj.Assign(self.Glasya)
	
	-- Assign Alerts and Timers to Triggers
	self.Glasya.Triggers.Void = KBM.Trigger:Create(self.Lang.Ability.Void[KBM.Lang], "cast", self.Glasya)
	self.Glasya.Triggers.Void:AddAlert(self.Glasya.AlertsRef.Void)
	
	--self.Glasya.Triggers.Victory = KBM.Trigger:Create(0, "percent", self.Glasya)
	self.Glasya.Triggers.Victory = KBM.Trigger:Create(self.Lang.Notify.Victory[KBM.Lang], "notify", self.Glasya)
	self.Glasya.Triggers.Victory:SetVictory()
	
	self.Glasya.CastBar = KBM.Castbar:Add(self, self.Glasya)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end