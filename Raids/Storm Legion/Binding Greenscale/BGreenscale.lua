-- Lord Greenscale Boss Mod for King Boss Mods
-- Written by Lupercal@Brisesol
-- Copyright 2011
--

KBMSLRDBGGS_Settings = nil
chKBMSLRDBGGS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local BG = KBM.BossMod["RBinding_Greenscale"]

local LG = {
	Enabled = true,
	Directory = BG.Directory,
	File = "BGreenscale.lua",
	Instance = BG.Name,
	InstanceObj = BG,
	HasPhases = false,
	Lang = {},
	Enrage = 60 * 14.5,	
	ID = "BGreenscale",
	Object = "LG",
}

LG.Greenscale = {
	Mod = LG,
	Level = "??",
	Active = false,
	Name = "Lord Greenscale",
	NameShort = "Greenscale",
	Menu = {},
	Castbar = nil,
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UTID = "U2647724A2459175C",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			--Blight = KBM.Defaults.TimerObj.Create("red"),
			Fumes = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			--Blight = KBM.Defaults.AlertObj.Create("red"),
			FumesWarn = KBM.Defaults.AlertObj.Create("purple"),
			Fumes = KBM.Defaults.AlertObj.Create("purple"),
			--Death = KBM.Defaults.AlertObj.Create("dark_green"),
		},
	}
}

KBM.RegisterMod(LG.ID, LG)

-- Main Unit Dictionary
LG.Lang.Unit = {}
LG.Lang.Unit.Greenscale = KBM.Language:Add(LG.Greenscale.Name)
LG.Lang.Unit.Greenscale:SetGerman("Fürst Grünschuppe")
LG.Lang.Unit.Greenscale:SetFrench("Seigneur Vert\195\169caille")

-- Unit Dictionary
-- LG.Lang.Unit.Verdant = KBM.Language:Add("Verdant Annihilator")
-- LG.Lang.Unit.Verdant:SetGerman("Grüner Auslöscher")
-- LG.Lang.Unit.Verdant:SetFrench("Annihilateur verdoyant")


-- Debuff Dictionary
LG.Lang.Debuff = {}
LG.Lang.Debuff.Blossom = KBM.Language:Add("Fungal Blossom")
LG.Lang.Debuff.Blossom:SetFrench("Floraison fongique")

-- Ability Dictionary
LG.Lang.Ability = {}
-- LG.Lang.Ability.Blight = KBM.Language:Add("Strangling Blight")
-- LG.Lang.Ability.Blight:SetGerman("Würgende Plage")
-- LG.Lang.Ability.Blight:SetFrench("Fléau étrangleur")
-- LG.Lang.Ability.Blight:SetRussian("Удушающая болезнь")
-- LG.Lang.Ability.Blight:SetKorean("목조르는 식물")
LG.Lang.Ability.Fumes = KBM.Language:Add("Noxious Fumes")
LG.Lang.Ability.Fumes:SetGerman("Giftige Dämpfe")
LG.Lang.Ability.Fumes:SetFrench("Émanations nocives")
LG.Lang.Ability.Venom = KBM.Language:Add("Venom Cloud")
--LG.Lang.Ability.Venom:SetGerman("Giftige Dämpfe")
LG.Lang.Ability.Venom:SetFrench("Nuage de venin")
LG.Lang.Ability.Bulwark = KBM.Language:Add("Bulwark")

--Mechanic Dictionary (Verbose)
-- LG.Lang.Mechanic = {}
-- LG.Lang.Mechanic.Death = KBM.Language:Add("Protective Shield")
-- LG.Lang.Mechanic.Death:SetGerman("Schutzschild")
-- LG.Lang.Mechanic.Death:SetFrench("Bouclier protecteur")
-- LG.Lang.Mechanic.Death:SetRussian("Защитный купол")

LG.Greenscale.Name = LG.Lang.Unit.Greenscale[KBM.Lang]
LG.Descript = LG.Greenscale.Name

function LG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Greenscale.Name] = self.Greenscale
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

function LG:InitVars()
	self.Settings = {
		Enabled = true,
		Chronicle = false,
		CastBar = self.Greenscale.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Greenscale.Settings.TimersRef,
		AlertsRef = self.Greenscale.Settings.AlertsRef,
	}
	KBMSLRDBGGS_Settings = self.Settings
	chKBMSLRDBGGS_Settings = self.Settings	
end

function LG:SwapSettings(bool)
	if bool then
		KBMSLRDBGGS_Settings = self.Settings
		self.Settings = chKBMSLRDBGGS_Settings
	else
		chKBMSLRDBGGS_Settings = self.Settings
		self.Settings = KBMSLRDBGGS_Settings
	end
end

function LG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDBGGS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDBGGS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDBGGS_Settings = self.Settings
	else
		KBMSLRDBGGS_Settings = self.Settings
	end	
end

function LG:SaveVars()	
	if KBM.Options.Character then
		chKBMSLRDBGGS_Settings = self.Settings
	else
		KBMSLRDBGGS_Settings = self.Settings
	end	
end

function LG:Castbar(units)
end

function LG:RemoveUnits(UnitID)
	if self.Greenscale.UnitID == UnitID then
		self.Greenscale.Available = false
		return true
	end
	return false
end

function LG:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		--local BossObj = self.Bosses[uDetails.name]
		if BossObj == self.Greenscale then
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
				--self.PhaseObj.Objectives:AddPercent(self.Greenscale, 70, 100)
			else
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function LG:Death(UnitID)
	if self.Greenscale.UnitID == UnitID then
		self.Greenscale.Dead = true
		return true
	end
	return false
end

function LG:Reset()
	self.EncounterRunning = false
	self.Greenscale.Available = false
	self.Greenscale.UnitID = nil
	self.Greenscale.CastBar:Remove()
	self.Greenscale.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function LG:Timer()	
end

function LG:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Greenscale, self.Enabled)
end

function LG:Start()
	-- Create Timers
	self.Greenscale.TimersRef.Fumes = KBM.MechTimer:Add(self.Lang.Ability.Fumes[KBM.Lang], 26)
	KBM.Defaults.TimerObj.Assign(self.Greenscale)

	-- Create Alerts
	
	self.Greenscale.AlertsRef.FumesWarn = KBM.Alert:Create(self.Lang.Ability.Fumes[KBM.Lang], nil, true, true, "purple")
	self.Greenscale.AlertsRef.Fumes = KBM.Alert:Create(self.Lang.Ability.Fumes[KBM.Lang], 3, false, true, "purple")
	self.Greenscale.AlertsRef.Fumes:NoMenu()
	self.Greenscale.AlertsRef.FumesWarn:AlertEnd(self.Greenscale.AlertsRef.Fumes)
	KBM.Defaults.AlertObj.Assign(self.Greenscale)
	
	-- Assign Timers and Alerts to Triggers
	self.Greenscale.Triggers.Fumes = KBM.Trigger:Create(self.Lang.Ability.Fumes[KBM.Lang], "cast", self.Greenscale)
	self.Greenscale.Triggers.Fumes:AddTimer(self.Greenscale.TimersRef.Fumes)
	self.Greenscale.Triggers.Fumes:AddAlert(self.Greenscale.AlertsRef.FumesWarn)
	self.Greenscale.CastBar = KBM.Castbar:Add(self, self.Greenscale)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end