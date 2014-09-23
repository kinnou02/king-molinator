-- Toxilua Boss Mod for King Boss Mods
-- Written by Lupercal@Brisesol
-- Copyright 2011
--

KBMSLRDBGTX_Settings = nil
chKBMSLRDBGTX_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local BG = KBM.BossMod["RBinding_Greenscale"]

local TX = {
	Enabled = true,
	Directory = BG.Directory,
	File = "BToxilua.lua",
	Instance = BG.Name,
	InstanceObj = BG,
	HasPhases = false,
	Lang = {},
	Enrage = 60 * 5,	
	ID = "BToxilua",
	Object = "TX",
}

TX.Toxilua = {
	Mod = TX,
	Level = "??",
	Active = false,
	Name = "Toxilua",
	NameShort = "Toxilua",
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

KBM.RegisterMod(TX.ID, TX)

-- Main Unit Dictionary
TX.Lang.Unit = {}
TX.Lang.Unit.Toxilua = KBM.Language:Add(TX.Toxilua.Name)

TX.Lang.Unit.Toxilua:SetFrench("Toxilua")


-- Unit Dictionary
--TX.Lang.Unit.Verdant = KBM.Language:Add("Verdant Annihilator")
--TX.Lang.Unit.Verdant:SetGerman("Grüner Auslöscher")
--TX.Lang.Unit.Verdant:SetFrench("Annihilateur verdoyant")
--TX.Lang.Unit.Verdant:SetRussian("Лиственный расщепитель")

-- Ability Dictionary
--TX.Lang.Ability = {}
-- TX.Lang.Ability.Blight = KBM.Language:Add("Strangling Blight")
-- TX.Lang.Ability.Blight:SetGerman("Würgende Plage")
-- TX.Lang.Ability.Blight:SetFrench("Fléau étrangleur")
-- TX.Lang.Ability.Blight:SetRussian("Удушающая болезнь")
-- TX.Lang.Ability.Blight:SetKorean("목조르는 식물")
-- TX.Lang.Ability.Fumes = KBM.Language:Add("Noxious Fumes")
-- TX.Lang.Ability.Fumes:SetGerman("Giftige Dämpfe")
-- TX.Lang.Ability.Fumes:SetFrench("Émanations nocives")
-- TX.Lang.Ability.Fumes:SetRussian("Ядовитые пары")
-- TX.Lang.Ability.Fumes:SetKorean("유독 연기")

--Mechanic Dictionary (Verbose)
-- TX.Lang.Mechanic = {}
-- TX.Lang.Mechanic.Death = KBM.Language:Add("Protective Shield")
-- TX.Lang.Mechanic.Death:SetGerman("Schutzschild")
-- TX.Lang.Mechanic.Death:SetFrench("Bouclier protecteur")
-- TX.Lang.Mechanic.Death:SetRussian("Защитный купол")

TX.Toxilua.Name = TX.Lang.Unit.Toxilua[KBM.Lang]
TX.Descript = TX.Toxilua.Name

function TX:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Toxilua.Name] = self.Toxilua
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

function TX:InitVars()
	self.Settings = {
		Enabled = true,
		Chronicle = false,
		CastBar = self.Toxilua.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		--MechTimer = KBM.Defaults.MechTimer(),
		--PhaseMon = KBM.Defaults.PhaseMon(),
		--Alerts = KBM.Defaults.Alerts(),
		--TimersRef = self.Toxilua.Settings.TimersRef,
		--AlertsRef = self.Toxilua.Settings.AlertsRef,
	}
	KBMSLRDBGGS_Settings = self.Settings
	chKBMSLRDBGGS_Settings = self.Settings	
end

function TX:SwapSettings(bool)
	if bool then
		KBMSLRDBGGS_Settings = self.Settings
		self.Settings = chKBMSLRDBGGS_Settings
	else
		chKBMSLRDBGGS_Settings = self.Settings
		self.Settings = KBMSLRDBGGS_Settings
	end
end

function TX:LoadVars()	
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

function TX:SaveVars()	
	if KBM.Options.Character then
		chKBMSLRDBGTX_Settings = self.Settings
	else
		KBMSLRDBGTX_Settings = self.Settings
	end	
end

function TX:Castbar(units)
end

function TX:RemoveUnits(UnitID)
	if self.Toxilua.UnitID == UnitID then
		self.Toxilua.Available = false
		return true
	end
	return false
end

function TX:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		--local BossObj = self.UTID[uDetails.type]
		local BossObj = self.Bosses[uDetails.name]
		if BossObj == self.Toxilua then
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
				self.PhaseObj.Objectives:AddPercent(self.Toxilua, 75, 100)
			else
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function TX:Death(UnitID)
	if self.Toxilua.UnitID == UnitID then
		self.Toxilua.Dead = true
		return true
	end
	return false
end

function TX:Reset()
	self.EncounterRunning = false
	self.Toxilua.Available = false
	self.Toxilua.UnitID = nil
	self.Toxilua.CastBar:Remove()
	self.Toxilua.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function TX:Timer()	
end

function TX:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Toxilua, self.Enabled)
end

function TX:Start()
	-- Create Timers

	KBM.Defaults.TimerObj.Assign(self.Toxilua)

	-- Create Alerts
	
	 KBM.Defaults.AlertObj.Assign(self.Toxilua)
	
	-- Assign Timers and Alerts to Triggers
	
	self.Toxilua.CastBar = KBM.Castbar:Add(self, self.Toxilua)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end