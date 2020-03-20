-- Enclave of Ahnket Header for King Boss Mods
-- Written by Yarrellii
-- March 2019

KBMPOAEAFRZ_Settings = nil
chKBMPOAEAFRZ_Settings = nil
-- Third boss Frezhak :
-- Damage from the waters, Corrupted Waters : B764E58549960B748
-- Shield for Aquajet, Water Shields : B7C082A3A788CB971

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Enclave_Of_Ahnket"]

local MOD = {
	Directory = Instance.Directory,
	File = "Frezhak.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "EA_FRZ",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Frezhak = KBM.Language:Add("Frezhak")
MOD.Lang.Unit.Frezhak:SetGerman("Frezhak")
MOD.Lang.Unit.Frezhak:SetFrench("Frezhak")

MOD.Frezhak = {
	Mod = MOD,
	Level = "72",
	Active = false,
	Name = MOD.Lang.Unit.Frezhak[KBM.Lang],
	NameShort = "Frezhak",
	Menu = {},
	AlertsRef = {},
	MechRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U497FDCFB50B9A9D2",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Impure = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.Impure = KBM.Language:Add("Boss is immune until you take him to the spout!")
MOD.Lang.Verbose.Impure:SetGerman("Boss ist immun - Zieh ihn in die weisse Bubble")
MOD.Lang.Verbose.Impure:SetFrench("Le patron est immunisé - faites-le glisser dans la bulle blanche")

-- Buff Dictionary
MOD.Lang.Buff = {}
MOD.Lang.Buff.Impure = KBM.Language:Add("Impure protection") --Impure protection : B5CD06F854D63D83F
MOD.Lang.Buff.Impure:SetGerman("Makelhafer Schutz")
MOD.Lang.Buff.Impure:SetFrench("Protection impure")

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Notify Dictionary
MOD.Lang.Notify = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Frezhak[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Frezhak.Name] = self.Frezhak,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Frezhak.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Frezhak.Settings.AlertsRef,
		MechRef = self.Frezhak.Settings.MechRef,
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMPOAEAFRZ_Settings = self.Settings
	chKBMPOAEAFRZ_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMPOAEAFRZ_Settings = self.Settings
		self.Settings = chKBMPOAEAFRZ_Settings
	else
		chKBMPOAEAFRZ_Settings = self.Settings
		self.Settings = KBMPOAEAFRZ_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPOAEAFRZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPOAEAFRZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPOAEAFRZ_Settings = self.Settings
	else
		KBMPOAEAFRZ_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMPOAEAFRZ_Settings = self.Settings
	else
		KBMPOAEAFRZ_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Frezhak.UnitID == UnitID then
		self.Frezhak.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Frezhak.UnitID == UnitID then
		self.Frezhak.Dead = true
		return true
	end
	return false
end

function MOD.PhaseTwo()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj.Objectives:AddPercent(MOD.Frezhak.Name, 50, 75)
	MOD.PhaseObj:SetPhase(2)
	MOD.Phase = 2
end

function MOD.PhaseThree()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj.Objectives:AddPercent(MOD.Frezhak.Name, 35, 50)
	MOD.PhaseObj:SetPhase(3)
	MOD.Phase = 3
end

function MOD.PhaseFour()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj.Objectives:AddPercent(MOD.Frezhak.Name, 15, 35)
	MOD.PhaseObj:SetPhase(4)
	MOD.Phase = 4
end

function MOD.PhaseFive()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj.Objectives:AddPercent(MOD.Frezhak.Name, 0, 15)
	MOD.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	MOD.Phase = 5
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Frezhak.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Frezhak.Dead = false
				self.Frezhak.Casting = false
				self.Frezhak.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(1)
				self.PhaseObj.Objectives:AddPercent(self.Frezhak.Name, 75, 100)
				self.Phase = 1
			end
			self.Frezhak.UnitID = unitID
			self.Frezhak.Available = true
			return self.Frezhak
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Frezhak.Available = false
	self.Frezhak.UnitID = nil
	self.Frezhak.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Frezhak)
	
	--KBM.Defaults.MechObj.Assign(self.Frezhak)
	
	-- Create Alerts (Text, Duration, Flash, Countdown, Color)
	self.Frezhak.AlertsRef.Impure = KBM.Alert:Create(self.Lang.Verbose.Impure[KBM.Lang], nil, true, false, "red")
	KBM.Defaults.AlertObj.Assign(self.Frezhak)
	
	-- Assign Alerts and Timers to Triggers
	self.Frezhak.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Frezhak)
	self.Frezhak.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Frezhak.Triggers.PhaseTwo = KBM.Trigger:Create(50, "percent", self.Frezhak)
	self.Frezhak.Triggers.PhaseTwo:AddPhase(self.PhaseThree)
	self.Frezhak.Triggers.PhaseTwo = KBM.Trigger:Create(35, "percent", self.Frezhak)
	self.Frezhak.Triggers.PhaseTwo:AddPhase(self.PhaseFour)
	self.Frezhak.Triggers.PhaseTwo = KBM.Trigger:Create(15, "percent", self.Frezhak)
	self.Frezhak.Triggers.PhaseTwo:AddPhase(self.PhaseFive)	
	self.Frezhak.Triggers.Victory = KBM.Trigger:Create(0, "percent", self.Frezhak)
	self.Frezhak.Triggers.Victory:SetVictory()
		
	self.Frezhak.Triggers.Impure = KBM.Trigger:Create(self.Lang.Buff.Impure[KBM.Lang], "buff", self.Frezhak)
    self.Frezhak.Triggers.Impure:AddAlert(self.Frezhak.AlertsRef.Impure)
	
	self.Frezhak.Triggers.ImpureRemove = KBM.Trigger:Create(self.Lang.Buff.Impure[KBM.Lang], "buffRemove", self.Frezhak)
	self.Frezhak.Triggers.ImpureRemove:AddStop(self.Frezhak.AlertsRef.Impure)
		
	self.Frezhak.CastBar = KBM.Castbar:Add(self, self.Frezhak)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end