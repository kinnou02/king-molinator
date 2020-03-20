-- Enclave of Ahnket Header for King Boss Mods
-- Written by Yarrellii
-- March 2019

KBMPOAEASAL_Settings = nil
chKBMPOAEASAL_Settings = nil
-- First boss Salasohcarv : 

-- "Tomb of Rock and Sand" U1D7FEBF95ABFA006  healthMax = 10701679
-- "Dust Wisp" U056E9FD9112DDCED healthMax = 25000311

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Enclave_Of_Ahnket"]

local MOD = {
	Directory = Instance.Directory,
	File = "Salasohcarv.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "EA_SAL",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Salasohcarv = KBM.Language:Add("Salasohcarv")
MOD.Lang.Unit.Salasohcarv:SetGerman("Salasohcarv")
MOD.Lang.Unit.Salasohcarv:SetFrench("Salasohcarv")

MOD.Salasohcarv = {
	Mod = MOD,
	Level = "72",
	Active = false,
	Name = MOD.Lang.Unit.Salasohcarv[KBM.Lang],
	NameShort = "Salasohcarv",
	Menu = {},
	AlertsRef = {},
	MechRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U327C700F17E3BD31",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Tomb = KBM.Defaults.AlertObj.Create("orange"),
		  KillWisp = KBM.Defaults.AlertObj.Create("blue"),
		  KillBoss = KBM.Defaults.AlertObj.Create("blue"),
		},
		MechRef = {
		  Enabled = true,
		  Tomb = KBM.Defaults.MechObj.Create("red"),
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.Tomb = KBM.Language:Add("Kill the Tomb before it explodes!")
MOD.Lang.Verbose.Tomb:SetGerman("Befreit den Spieler aus dem Grab!")
MOD.Lang.Verbose.Tomb:SetFrench("Tuez la tombe avant qu'elle n'explose!")
MOD.Lang.Verbose.KillWisp = KBM.Language:Add("Boss is immune, Explode a wisp on the boss")
MOD.Lang.Verbose.KillWisp:SetGerman("Boss ist immun - Lasst ein Irrlicht beim Boss bei <20% explodieren")
MOD.Lang.Verbose.KillWisp:SetFrench("Le boss est immunisé - Laissez la volonté exploser chez le patron à <20%")
MOD.Lang.Verbose.KillBoss = KBM.Language:Add("Boss is no longer immune")
MOD.Lang.Verbose.KillBoss:SetGerman("Boss ist nich mehr immun")
MOD.Lang.Verbose.KillBoss:SetFrench("Boss n'est plus immunisé")

-- Buff Dictionary
MOD.Lang.Buff = {}
MOD.Lang.Buff.Barrier = KBM.Language:Add("Barrier of Earth") -- Barrier of Earth : B6C17DC1590FC185D
MOD.Lang.Buff.Barrier:SetGerman("Erdbarriere")
MOD.Lang.Buff.Barrier:SetFrench("Barrière de Terre")

-- Debuff Dictionary
MOD.Lang.Debuff = {}
MOD.Lang.Debuff.Tomb = KBM.Language:Add("Tomb of Rock and Sand") --Tomb of Rock and Sand : B3AD7B534E111A613
MOD.Lang.Debuff.Tomb:SetGerman("Grab aus Stein und Sand")
MOD.Lang.Debuff.Tomb:SetFrench("Vous êtes emprisonné dans une tombe de pierre et de sable")

-- Notify Dictionary
MOD.Lang.Notify = {}
MOD.Lang.Notify.Tomb = KBM.Language:Add("(%a*) will be imprisoned in the rock and sand!")
MOD.Lang.Notify.Tomb:SetGerman("(%a*) wird bald in Stein und Sand gefangen!")
MOD.Lang.Notify.Tomb:SetFrench("(%a*) sera emprisonné dans la pierre et le sable !")

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Salasohcarv[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Salasohcarv.Name] = self.Salasohcarv,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Salasohcarv.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Salasohcarv.Settings.AlertsRef,
		MechRef = self.Salasohcarv.Settings.MechRef,
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMPOAEASAL_Settings = self.Settings
	chKBMPOAEASAL_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMPOAEASAL_Settings = self.Settings
		self.Settings = chKBMPOAEASAL_Settings
	else
		chKBMPOAEASAL_Settings = self.Settings
		self.Settings = KBMPOAEASAL_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPOAEASAL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPOAEASAL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPOAEASAL_Settings = self.Settings
	else
		KBMPOAEASAL_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMPOAEASAL_Settings = self.Settings
	else
		KBMPOAEASAL_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Salasohcarv.UnitID == UnitID then
		self.Salasohcarv.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Salasohcarv.UnitID == UnitID then
		self.Salasohcarv.Dead = true
		return true
	end
	return false
end

function MOD.WispPhase()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj:SetPhase("Kill Wisp")
	MOD.Phase = 2
end

function MOD.BurnPhase()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj:SetPhase("Kill Boss")
	MOD.Phase = 1
end

function MOD.FinalPhase()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj.Objectives:AddPercent(MOD.Salasohcarv.Name, 0, 20)
	MOD.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	MOD.Phase = 3
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Salasohcarv.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Salasohcarv.Dead = false
				self.Salasohcarv.Casting = false
				self.Salasohcarv.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("Burn Phase")
				self.Phase = 1
			end
			self.Salasohcarv.UnitID = unitID
			self.Salasohcarv.Available = true
			return self.Salasohcarv
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Salasohcarv.Available = false
	self.Salasohcarv.UnitID = nil
	self.Salasohcarv.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Salasohcarv)
	
	self.Salasohcarv.MechRef.Tomb = KBM.MechSpy:Add(self.Lang.Debuff.Tomb[KBM.Lang], nil, "playerBuff", self.Salasohcarv)
	KBM.Defaults.MechObj.Assign(self.Salasohcarv)
	
	-- Create Alerts (Text, Duration, Flash, Countdown, Color)
	self.Salasohcarv.AlertsRef.Tomb = KBM.Alert:Create(self.Lang.Verbose.Tomb[KBM.Lang], nil, true, true, "red")
	self.Salasohcarv.AlertsRef.KillWisp = KBM.Alert:Create(self.Lang.Verbose.KillWisp[KBM.Lang], nil, true, false, "blue")
	self.Salasohcarv.AlertsRef.KillBoss = KBM.Alert:Create(self.Lang.Verbose.KillBoss[KBM.Lang], nil, true, false, "blue")
	KBM.Defaults.AlertObj.Assign(self.Salasohcarv)
	
	-- Assign Alerts and Timers to Triggers
	self.Salasohcarv.Triggers.BurnPhase = KBM.Trigger:Create(self.Lang.Buff.Barrier[KBM.Lang], "buffRemove", self.Salasohcarv)
	self.Salasohcarv.Triggers.BurnPhase:AddPhase(self.BurnPhase)
	self.Salasohcarv.Triggers.BurnPhase:AddAlert(self.Salasohcarv.AlertsRef.KillBoss)
	self.Salasohcarv.Triggers.BurnPhase:AddStop(self.Salasohcarv.AlertsRef.KillWisp)
	
	self.Salasohcarv.Triggers.WispPhase = KBM.Trigger:Create(self.Lang.Buff.Barrier[KBM.Lang], "buff", self.Salasohcarv)
	self.Salasohcarv.Triggers.WispPhase:AddPhase(self.WispPhase)
	self.Salasohcarv.Triggers.WispPhase:AddAlert(self.Salasohcarv.AlertsRef.KillWisp)
	self.Salasohcarv.Triggers.WispPhase:AddStop(self.Salasohcarv.AlertsRef.KillBoss)
	
	self.Salasohcarv.Triggers.PhaseTwo = KBM.Trigger:Create(20, "percent", self.Salasohcarv)
	self.Salasohcarv.Triggers.PhaseTwo:AddPhase(self.FinalPhase)	
	
	self.Salasohcarv.Triggers.Victory = KBM.Trigger:Create(0, "percent", self.Salasohcarv)
	self.Salasohcarv.Triggers.Victory:SetVictory()

	self.Salasohcarv.Triggers.Tomb = KBM.Trigger:Create(self.Lang.Debuff.Tomb[KBM.Lang], "playerBuff", self.Salasohcarv)
    self.Salasohcarv.Triggers.Tomb:AddAlert(self.Salasohcarv.AlertsRef.Tomb)
    self.Salasohcarv.Triggers.Tomb:AddSpy(self.Salasohcarv.MechRef.Tomb)
	
	self.Salasohcarv.Triggers.TombRemove = KBM.Trigger:Create(self.Lang.Debuff.Tomb[KBM.Lang], "playerBuffRemove", self.Salasohcarv)
	self.Salasohcarv.Triggers.TombRemove:AddStop(self.Salasohcarv.AlertsRef.Tomb)
	self.Salasohcarv.Triggers.TombRemove:AddStop(self.Salasohcarv.MechRef.Tomb)
		
	self.Salasohcarv.CastBar = KBM.Castbar:Add(self, self.Salasohcarv)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end