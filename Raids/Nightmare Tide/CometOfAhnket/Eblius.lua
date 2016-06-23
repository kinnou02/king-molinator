-- Duke Eblius Boss Mod for King Boss Mods
-- Written by Elinare
-- Copyright 2016
--

KBMNTEBL_Settings = nil
cCOABMNTEBL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local COA = KBM.BossMod["RCometOfAhnket"]

local EBL = {
	Directory = COA.Directory,
	File = "Eblius.lua",
	Enabled = true,
	HasPhases = true,
	Phase = 1,
	TankSwap = true,
	Instance = COA.Name,
	InstanceObj = COA,
	Lang = {},
	Enrage = 60 * 7,
	ID = "Eblius",
	Object = "EBL",
}

EBL.Ebl = {
	Mod = EBL,
	Menu = {},
	Level = "??",
	Active = false,
	Name = "Duke Eblius",
	UTID = "U159DB101516EF3F3",
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = true,
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	MechRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		Filters = {
			Enabled = true,
			Fleau = KBM.Defaults.CastFilter.Create("purle"),
			CallToArms = KBM.Defaults.CastFilter.Create("red"),
			BlazingRuin = KBM.Defaults.CastFilter.Create("yellow"),
			-- SoulSear = KBM.Defaults.CastFilter.Create("purle"),
			-- Blast = KBM.Defaults.CastFilter.Create("red"),
		},
		TimersRef = {
			Enabled = true,
			-- Crush = KBM.Defaults.TimerObj.Create("purple"),
			-- Pound = KBM.Defaults.TimerObj.Create("blue"),
			-- Demonic = KBM.Defaults.TimerObj.Create("cyan"),
		},
		AlertsRef = {
			Enabled = true,
			Fleau = KBM.Defaults.AlertObj.Create("purle"),
			CallToArms = KBM.Defaults.AlertObj.Create("red"),
			BlazingRuin = KBM.Defaults.AlertObj.Create("yellow"),
			-- SoulSear = KBM.Defaults.AlertObj.Create("purle"),
		},
		MechRef = {
			Enabled = true,
		},
	}
}

KBM.RegisterMod("Eblius", EBL)

-- Main Unit Dictionary
EBL.Lang.Unit = {}
EBL.Lang.Unit.Eblius = KBM.Language:Add(EBL.Ebl.Name)
EBL.Lang.Unit.Eblius:SetGerman("Eblius")
EBL.Lang.Unit.Eblius:SetFrench("Duc Eblius")
EBL.Lang.Unit.Eblius:SetRussian("??????????")
EBL.Lang.Unit.Eblius:SetKorean("????")
EBL.Ebl.Name = EBL.Lang.Unit.Eblius[KBM.Lang]
EBL.Descript = EBL.Lang.Unit.Eblius[KBM.Lang]

-- Ability Dictionary
EBL.Lang.Ability = {}
EBL.Lang.Ability.Fleau = KBM.Language:Add("Sulphurous Blight")
EBL.Lang.Ability.Fleau:SetFrench("Fléau sulfureux")
EBL.Lang.Ability.Fleau:SetGerman("Sulphurous Blight")
EBL.Lang.Ability.Fleau:SetRussian("????????? ????")
EBL.Lang.Ability.Fleau:SetKorean("?? ??")
EBL.Lang.Ability.CallToArms = KBM.Language:Add("Call to arms")
EBL.Lang.Ability.CallToArms:SetFrench("Appel aux armes")
EBL.Lang.Ability.CallToArms:SetGerman("Call to arms")
EBL.Lang.Ability.CallToArms:SetRussian("???????? ????")
EBL.Lang.Ability.CallToArms:SetKorean("??? ??")
EBL.Lang.Ability.BlazingRuin = KBM.Language:Add("Blazing Ruin")
EBL.Lang.Ability.BlazingRuin:SetFrench("Ruine flamboyante")
EBL.Lang.Ability.BlazingRuin:SetGerman("Blazing Ruin")
EBL.Lang.Ability.BlazingRuin:SetRussian("???????? ????")
EBL.Lang.Ability.BlazingRuin:SetKorean("??? ??")
-- EBL.Lang.Ability.SoulSear = KBM.Language:Add("Soul Sear")
-- EBL.Lang.Ability.SoulSear:SetFrench("Soul Sear")
-- EBL.Lang.Ability.SoulSear:SetGerman("Soul Sear")
-- EBL.Lang.Ability.SoulSear:SetRussian("???????? ????")
-- EBL.Lang.Ability.SoulSear:SetKorean("??? ??")

-- Debuff Dictionary
EBL.Lang.Debuff = {}
-- EBL.Lang.Debuff.Mangled = KBM.Language:Add("Mangled")
-- EBL.Lang.Debuff.Mangled:SetGerman("Üble Blessur")
-- EBL.Lang.Debuff.Mangled:SetFrench("Estropié")
-- EBL.Lang.Debuff.Mangled:SetRussian("?????????")
-- EBL.Lang.Debuff.Mangled:SetKorean("??")

function EBL:AddBosses(KBM_Boss)
	self.MenuName = self.Ebl.Name
	self.Bosses = {
		[self.Ebl.Name] = self.Ebl
	}
end

function EBL:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		CastBar = EBL.Ebl.Settings.CastBar,
		MechTimer = KBM.Defaults.MechTimer(),
		TimersRef = EBL.Ebl.Settings.TimersRef,
		AlertsRef = EBL.Ebl.Settings.AlertsRef,
		Alerts = KBM.Defaults.Alerts(),
		CastFilters = EBL.Ebl.Settings.Filters,
		MechSpy = KBM.Defaults.MechSpy(),
		MechRef = EBL.Ebl.Settings.MechRef,
	}
	KBMNTEBL_Settings = self.Settings
	cCOABMNTEBL_Settings = self.Settings	
end

function EBL:SwapSettings(bool)
	if bool then
		KBMNTRDEBL_Settings = self.Settings
		self.Settings = chKBMNTRDEBL_Settings
	else
		chKBMNTRDEBL_Settings = self.Settings
		self.Settings = KBMNTRDEBL_Settings
	end
end

function EBL:LoadVars()		
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDEBL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDEBL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRDEBL_Settings = self.Settings
	else
		KBMNTRDEBL_Settings = self.Settings
	end	
	
	self.Ebl.CastFilters[self.Lang.Ability.Fleau[KBM.Lang]] = {ID = "Fleau"}
	self.Ebl.CastFilters[self.Lang.Ability.CallToArms[KBM.Lang]] = {ID = "CallToArms"}
	self.Ebl.CastFilters[self.Lang.Ability.BlazingRuin[KBM.Lang]] = {ID = "BlazingRuin"}
	-- self.Ebl.CastFilters[self.Lang.Ability.SoulSear[KBM.Lang]] = {ID = "SoulSear"}
	KBM.Defaults.CastFilter.Assign(self.Ebl)
	
end

function EBL:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRDEBL_Settings = self.Settings
	else
		KBMNTRDEBL_Settings = self.Settings
	end	
end

function EBL:Castbar()
end

function EBL:RemoveUnits(UnitID)
	if self.Ebl.UnitID == UnitID then
		self.Ebl.Available = false
		return true
	end
	return false	
end

function EBL:Death(UnitID)
	if self.Ebl.UnitID == UnitID then
		self.Ebl.Dead = true
		return true
	end
	return false	
end

function EBL.PhaseTwo()
	EBL.PhaseObj.Objectives:Remove()
	EBL.Phase = 3
	EBL.PhaseObj:SetPhase(3)
	EBL.PhaseObj.Objectives:AddPercent(EBL.Ebl, 65, 85)
end

function EBL.PhaseThree()
	EBL.PhaseObj.Objectives:Remove()
	EBL.Phase = 3
	EBL.PhaseObj:SetPhase(3)
	EBL.PhaseObj.Objectives:AddPercent(EBL.Ebl, 30, 65)
end

function EBL.PhaseFour()
	EBL.PhaseObj.Objectives:Remove()
	EBL.Phase = 4
	EBL.PhaseObj:SetPhase(4)
	EBL.PhaseObj.Objectives:AddPercent(EBL.Ebl, 0, 30)	
end

function EBL:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Ebl.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ebl.Dead = false
					self.Ebl.Casting = false
					self.Ebl.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
					self.PhaseObj.Objectives:AddPercent(self.Ebl, 85, 100)
				end
				self.Ebl.Casting = false
				self.Ebl.UnitID = unitID
				self.Ebl.Available = true
				return self.Ebl
			end
		end
	end
end

function EBL:Reset()
	self.EncounterRunning = false
	self.Ebl.UnitID = nil
	self.Ebl.Dead = false
	self.Ebl.Available = false
	self.Ebl.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())	
end

function EBL:Timer()	
end



function EBL:Start()	
	-- Create Timers
	-- self.Ebl.TimersRef.PopAdd = KBM.MechTimer:Add(self.Lang.Ability.PopAdd[KBM.Lang], 9)
	-- self.Ebl.TimersRef.PopAdd:Wait()
	KBM.Defaults.TimerObj.Assign(self.Ebl)
	
	-- Create Alerts
	self.Ebl.AlertsRef.Fleau = KBM.Alert:Create(self.Lang.Ability.Fleau[KBM.Lang], nil, false, true, "yellow")
	self.Ebl.AlertsRef.CallToArms = KBM.Alert:Create(self.Lang.Ability.CallToArms[KBM.Lang], nil, false, true, "yellow")
	self.Ebl.AlertsRef.BlazingRuin = KBM.Alert:Create(self.Lang.Ability.BlazingRuin[KBM.Lang], nil, false, true, "yellow")
	-- self.Ebl.AlertsRef.SoulSear = KBM.Alert:Create(self.Lang.Ability.SoulSear[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Ebl)
	
	-- Create Spy
	
	KBM.Defaults.MechObj.Assign(self.Ebl)
	
	self.Ebl.Triggers.Fleau = KBM.Trigger:Create(self.Lang.Ability.Fleau[KBM.Lang], "cast", self.Ebl)
	self.Ebl.Triggers.Fleau:AddAlert(self.Ebl.AlertsRef.Fleau)
	
	self.Ebl.Triggers.CallToArms = KBM.Trigger:Create(self.Lang.Ability.CallToArms[KBM.Lang], "cast", self.Ebl)
	self.Ebl.Triggers.CallToArms:AddAlert(self.Ebl.AlertsRef.CallToArms)
	
	self.Ebl.Triggers.BlazingRuin = KBM.Trigger:Create(self.Lang.Ability.BlazingRuin[KBM.Lang], "cast", self.Ebl)
	self.Ebl.Triggers.BlazingRuin:AddAlert(self.Ebl.AlertsRef.BlazingRuin)
	
	-- self.Ebl.Triggers.SoulSear = KBM.Trigger:Create(self.Lang.Ability.SoulSear[KBM.Lang], "cast", self.Ebl)
	-- self.Ebl.Triggers.SoulSear:AddAlert(self.Ebl.AlertsRef.SoulSear)
	
	
	
	self.Ebl.Triggers.PhaseTwo = KBM.Trigger:Create(85, "percent", self.Ebl)
	self.Ebl.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Ebl.Triggers.PhaseThree = KBM.Trigger:Create(65, "percent", self.Ebl)
	self.Ebl.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Ebl.Triggers.PhaseFour = KBM.Trigger:Create(30, "percent", self.Ebl)
	self.Ebl.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	-- Assign Castbar object.
	self.Ebl.CastBar = KBM.Castbar:Add(self, self.Ebl)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end