-- Irauga Boss Mod for King Boss Mods
-- Written by Lupercal@brisesol
-- Copyright 2011
--

KBMSLRDBAIR_Settings = nil
chKBMSLRDBAIR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local BA = KBM.BossMod["RBinding_Akylios"]

local IR = {
	Enabled = true,
	Directory = BA.Directory,
	File = "BIrauga.lua",
	Instance = BA.Name,
	InstanceObj = BA,
	HasPhases = false,
	Lang = {},
	Enrage = 60 * 5,	
	ID = "BIrauga",
	Object = "IR",
}

IR.Irauga = {
	Mod = IR,
	Level = "??",
	Active = false,
	Name = "Irauga",
	NameShort = "Irauga",
	Menu = {},
	Castbar = nil,
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UTID = "none",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			--Enabled = true,
			--Blight = KBM.Defaults.TimerObj.Create("red"),
			--Fumes = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			--Enabled = true,
			--Blight = KBM.Defaults.AlertObj.Create("red"),
			--FumesWarn = KBM.Defaults.AlertObj.Create("purple"),
			--Fumes = KBM.Defaults.AlertObj.Create("purple"),
			--Death = KBM.Defaults.AlertObj.Create("dark_green"),
		},
	}
}

KBM.RegisterMod(IR.ID, IR)

-- Main Unit Dictionary
IR.Lang.Unit = {}
IR.Lang.Unit.Irauga = KBM.Language:Add(IR.Irauga.Name)

IR.Lang.Unit.Irauga:SetFrench("Irauga")


-- Unit Dictionary
--IR.Lang.Unit.Verdant = KBM.Language:Add("Verdant Annihilator")
--IR.Lang.Unit.Verdant:SetGerman("Grüner Auslöscher")
--IR.Lang.Unit.Verdant:SetFrench("Annihilateur verdoyant")
--IR.Lang.Unit.Verdant:SetRussian("Лиственный расщепитель")

-- Ability Dictionary
--IR.Lang.Ability = {}
-- IR.Lang.Ability.Blight = KBM.Language:Add("Strangling Blight")
-- IR.Lang.Ability.Blight:SetGerman("Würgende Plage")
-- IR.Lang.Ability.Blight:SetFrench("Fléau étrangleur")
-- IR.Lang.Ability.Blight:SetRussian("Удушающая болезнь")
-- IR.Lang.Ability.Blight:SetKorean("목조르는 식물")
-- IR.Lang.Ability.Fumes = KBM.Language:Add("Noxious Fumes")
-- IR.Lang.Ability.Fumes:SetGerman("Giftige Dämpfe")
-- IR.Lang.Ability.Fumes:SetFrench("Émanations nocives")
-- IR.Lang.Ability.Fumes:SetRussian("Ядовитые пары")
-- IR.Lang.Ability.Fumes:SetKorean("유독 연기")

--Mechanic Dictionary (Verbose)
-- IR.Lang.Mechanic = {}
-- IR.Lang.Mechanic.Death = KBM.Language:Add("Protective Shield")
-- IR.Lang.Mechanic.Death:SetGerman("Schutzschild")
-- IR.Lang.Mechanic.Death:SetFrench("Bouclier protecteur")
-- IR.Lang.Mechanic.Death:SetRussian("Защитный купол")

IR.Irauga.Name = IR.Lang.Unit.Irauga[KBM.Lang]
IR.Descript = IR.Irauga.Name

function IR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Irauga.Name] = self.Irauga
	}
	for BossName, BossObj in pairs(self.Bosses) do
			if BossObj.Settings then
					if BossObj.Settings.CastBar then
							BossObj.Settings.CastBar.Override = true
							BossObj.Settings.CastBar.Multi = true
					end
			end
	end    
end

function IR:InitVars()
	self.Settings = {
		Enabled = true,
		Chronicle = false,
		CastBar = self.Irauga.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		--MechTimer = KBM.Defaults.MechTimer(),
		--PhaseMon = KBM.Defaults.PhaseMon(),
		--Alerts = KBM.Defaults.Alerts(),
		--TimersRef = self.Irauga.Settings.TimersRef,
		--AlertsRef = self.Irauga.Settings.AlertsRef,
	}
	KBMSLRDBAIR_Settings = self.Settings
	chKBMSLRDBAIR_Settings = self.Settings	
end

function IR:SwapSettings(bool)
	if bool then
		KBMSLRDBAIR_Settings = self.Settings
		self.Settings = chKBMSLRDBAIR_Settings
	else
		chKBMSLRDBAIR_Settings = self.Settings
		self.Settings = KBMSLRDBAIR_Settings
	end
end

function IR:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDBAIR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDBAIR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDBAIR_Settings = self.Settings
	else
		KBMSLRDBAIR_Settings = self.Settings
	end	
end

function IR:SaveVars()	
	if KBM.Options.Character then
		chKBMSLRDBAIR_Settings = self.Settings
	else
		KBMSLRDBAIR_Settings = self.Settings
	end	
end

function IR:Castbar(units)
end

function IR:RemoveUnits(UnitID)
	if self.Irauga.UnitID == UnitID then
		self.Irauga.Available = false
		return true
	end
	return false
end

function IR:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		--local BossObj = self.UTID[uDetails.type]
		local BossObj = self.Bosses[uDetails.name]
		if BossObj == self.Irauga then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.UnitID = unitID
				BossObj.Dead = false
				BossObj.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.Phase = 1
				self.LastPhase = 1
				self.PhaseObj:SetPhase(1)
				--self.PhaseObj.Objectives:AddPercent(self.Irauga, 75, 100)
			else
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function IR:Death(UnitID)
	if self.Irauga.UnitID == UnitID then
		self.Irauga.Dead = true
		return true
	end
	return false
end

function IR:Reset()
	self.EncounterRunning = false
	self.Irauga.Available = false
	self.Irauga.UnitID = nil
	self.Irauga.CastBar:Remove()
	self.Irauga.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function IR:Timer()	
end

function IR:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Irauga, self.Enabled)
end

function IR:Start()
	-- Create Timers

	KBM.Defaults.TimerObj.Assign(self.Irauga)

	-- Create Alerts
	
	 KBM.Defaults.AlertObj.Assign(self.Irauga)
	
	-- Assign Timers and Alerts to Triggers
	
	self.Irauga.CastBar = KBM.Castbar:Add(self, self.Irauga)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end