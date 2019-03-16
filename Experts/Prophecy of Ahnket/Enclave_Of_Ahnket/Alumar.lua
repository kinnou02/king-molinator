-- Enclave of Ahnket Header for King Boss Mods
-- Written by Yarrellii
-- March 20191222	2

KBMPOAEAALU_Settings = nil
chKBMPOAEAALU_Settings = nil
--{availability = "full", combat = true, coordX = 4387.9296875, coordY = 794.77996826172, coordZ = 5084.2998046875, health = 25000072, healthMax = 25000073, id = "u8000000033004FCE", level = 70, name = "Tower Portal: Marksmen", nameSecondary = "Tenebrean Simulacrum", radius = 0, relation = "hostile", tag = "planar", tagName = "Planar", tier = "raid", type = "U36333A6F3D370A3D"}
-- {availability = "full", coordX = 4397.4697265625, coordY = 794.77996826172, coordZ = 5077.2397460938, health = 25000072, healthMax = 25000073, id = "u8000000033004FD1", level = 70, name = "Tower Portal: Dominator", nameSecondary = "Tenebrean Simulacrum", radius = 0, relation = "hostile", tag = "planar", tagName = "Planar", tier = "raid", type = "U76BE2809396F7048"}
-- {availability = "full", coordX = 4386.6000976563, coordY = 794.77996826172, coordZ = 5105.08984375, health = 25000072, healthMax = 25000073, id = "u8000000033004FCD", level = 70, name = "Tower Portal: Warlord", nameSecondary = "Tenebrean Simulacrum", radius = 0.5, relation = "hostile", tag = "planar", tagName = "Planar", tier = "raid", type = "U034652041FDB2F4D"}
-- {availability = "full", coordX = 4394.1899414063, coordY = 794.77996826172, coordZ = 5111.7197265625, health = 25000072, healthMax = 25000073, id = "u8000000033004FCF", level = 70, name = "Tower Portal: Warden", nameSecondary = "Tenebrean Simulacrum", radius = 0, relation = "hostile", tag = "planar", tagName = "Planar", tier = "raid", type = "U603CBDDF5D10A2D3"}

-- Fourth boss Alu'Mar :
-- CHANNEL Tower Rend (inny outty)
-- CAST Disruption blast - blue bubbles spawns on boss - Watery Morass then lasts 20s and prevents spawning of adds
-- BUFF incorrect name, Increases the bosses outgoing damage Ahnket's Aid : B3557A70266F2DAFA
-- PERCENT 50% portals

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Enclave_Of_Ahnket"]

local MOD = {
	Directory = Instance.Directory,
	File = "Alumar.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "EA_ALU",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Alumar = KBM.Language:Add("Alu'Mar")

MOD.Alumar = {
	Mod = MOD,
	Level = "72",
	Active = false,
	Name = MOD.Lang.Unit.Alumar[KBM.Lang],
	NameShort = "Alumar",
	Menu = {},
	AlertsRef = {},
	MechRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U7BD64228313E2F73",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Aid = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.Aid = KBM.Language:Add("Boss immune until the portals are dead!") 

-- Buff Dictionary
MOD.Lang.Buff = {}
MOD.Lang.Buff.Aid = KBM.Language:Add("Ahnket's Aid") --Ahnket's Aid : B0A1AAAB1CB1F7161

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Notify Dictionary
MOD.Lang.Notify = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Alumar[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Alumar.Name] = self.Alumar,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Alumar.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Alumar.Settings.AlertsRef,
		MechRef = self.Alumar.Settings.MechRef,
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMPOAEAALU_Settings = self.Settings
	chKBMPOAEAALU_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMPOAEAALU_Settings = self.Settings
		self.Settings = chKBMPOAEAALU_Settings
	else
		chKBMPOAEAALU_Settings = self.Settings
		self.Settings = KBMPOAEAALU_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPOAEAALU_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPOAEAALU_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPOAEAALU_Settings = self.Settings
	else
		KBMPOAEAALU_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMPOAEAALU_Settings = self.Settings
	else
		KBMPOAEAALU_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Alumar.UnitID == UnitID then
		self.Alumar.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Alumar.UnitID == UnitID then
		self.Alumar.Dead = true
		return true
	end
	return false
end

function MOD.PhaseTwo()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj.Objectives:AddPercent(MOD.Alumar.Name, 50, 50)
	MOD.PhaseObj:SetPhase(2)
	MOD.Phase = 2
end

function MOD.PhaseThree()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj.Objectives:AddPercent(MOD.Alumar.Name, 0, 50)
	MOD.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	MOD.Phase = 3
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Alumar.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Alumar.Dead = false
				self.Alumar.Casting = false
				self.Alumar.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(1)
				self.PhaseObj.Objectives:AddPercent(self.Alumar.Name, 50, 100)
				self.Phase = 1
			end
			self.Alumar.UnitID = unitID
			self.Alumar.Available = true
			return self.Alumar
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Alumar.Available = false
	self.Alumar.UnitID = nil
	self.Alumar.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Alumar)
	--KBM.Defaults.MechObj.Assign(self.Alumar)
	
	-- Create Alerts
	self.Alumar.AlertsRef.Aid = KBM.Alert:Create(self.Lang.Verbose.Aid[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Alumar)

	
	-- Assign Alerts and Timers to Triggers
	self.Alumar.Triggers.Victory = KBM.Trigger:Create(0, "percent", self.Alumar)
	self.Alumar.Triggers.Victory:SetVictory()
		
	self.Alumar.Triggers.Aid = KBM.Trigger:Create(self.Lang.Buff.Aid[KBM.Lang], "buff", self.Alumar)
    self.Alumar.Triggers.Aid:AddAlert(self.Alumar.AlertsRef.Aid, true)
		
	self.Alumar.CastBar = KBM.Castbar:Add(self, self.Alumar)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end