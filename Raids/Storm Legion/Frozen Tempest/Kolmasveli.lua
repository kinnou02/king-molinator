-- Kolmasveli and Toinenveli Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDFTKT_Settings = nil
chKBMSLRDFTKT_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local FT = KBM.BossMod["RFrozen_Tempest"]

local KT = {
	Enabled = true,
	Directory = FT.Directory,
	File = "Kolmasveli.lua",
	Instance = FT.Name,
	InstanceObj = FT,
	HasPhases = true,
	Lang = {},
	ID = "RKolmasveli",
	Object = "KT",
	Enrage = 7 * 60,
}

KBM.RegisterMod(KT.ID, KT)

-- Main Unit Dictionary
KT.Lang.Unit = {}
KT.Lang.Unit.Kolmasveli = KBM.Language:Add("Kolmasveli")
KT.Lang.Unit.Kolmasveli:SetGerman()
KT.Lang.Unit.KolmasveliShort = KBM.Language:Add("Kolmasveli")
KT.Lang.Unit.KolmasveliShort:SetGerman()
KT.Lang.Unit.Toinenveli = KBM.Language:Add("Toinenveli")
KT.Lang.Unit.Toinenveli:SetGerman()
KT.Lang.Unit.ToinenveliShort = KBM.Language:Add("Toinenveli")
KT.Lang.Unit.ToinenveliShort:SetGerman()

-- Ability Dictionary
KT.Lang.Ability = {}
KT.Lang.Ability.Glimpse = KBM.Language:Add("Glimpse of Infinity")

-- Debuff Dictionary
KT.Lang.Debuff = {}
KT.Lang.Debuff.KolIre = KBM.Language:Add("Kolmasveli's Ire")
KT.Lang.Debuff.KolIre:SetGerman("Kolmasvelis Grimm")
KT.Lang.Debuff.ToiIre = KBM.Language:Add("Toinenveli's Ire")
KT.Lang.Debuff.ToiIre:SetGerman("Toinenvelis Grimm")

-- Verbose Dictionary
KT.Lang.Verbose = {}
KT.Lang.Verbose.GlimpseKol = KBM.Language:Add("Hide from Kolmasveli!")
KT.Lang.Verbose.GlimpseToi = KBM.Language:Add("Hide from Toinenveli!")

-- Description Dictionary
KT.Lang.Main = {}
KT.Lang.Main.Descript = KBM.Language:Add("Kolmasveli and Toinenveli")
KT.Lang.Main.Descript:SetGerman("Kolmasveli und Toinenveli")
KT.Descript = KT.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
KT.Kolmasveli = {
	Mod = KT,
	Level = "??",
	Active = false,
	Name = KT.Lang.Unit.Kolmasveli[KBM.Lang],
	NameShort = KT.Lang.Unit.KolmasveliShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFC6878694CBB7CB2",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		AlertsRef = {
			Enabled = true,
			Glimpse = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

KT.Toinenveli = {
	Mod = KT,
	Level = "??",
	Active = false,
	Name = KT.Lang.Unit.Toinenveli[KBM.Lang],
	NameShort = KT.Lang.Unit.ToinenveliShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFC6878683C42B9AC",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		AlertsRef = {
			Enabled = true,
			Glimpse = KBM.Defaults.AlertObj.Create("orange"),
		},
	}
}

function KT:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kolmasveli.Name] = self.Kolmasveli,
		[self.Toinenveli.Name] = self.Toinenveli,
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

function KT:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Multi = true,
			Override = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Toinenveli = {
			CastBar = self.Toinenveli.Settings.CastBar,
			AlertsRef = self.Toinenveli.Settings.AlertsRef,
		},
		Kolmasveli = {
			CastBar = self.Kolmasveli.Settings.CastBar,
			AlertsRef = self.Kolmasveli.Settings.AlertsRef,
		},
	}
	KBMSLRDFTKT_Settings = self.Settings
	chKBMSLRDFTKT_Settings = self.Settings	
end

function KT:SwapSettings(bool)
	if bool then
		KBMSLRDFTKT_Settings = self.Settings
		self.Settings = chKBMSLRDFTKT_Settings
	else
		chKBMSLRDFTKT_Settings = self.Settings
		self.Settings = KBMSLRDFTKT_Settings
	end
end

function KT:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDFTKT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDFTKT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDFTKT_Settings = self.Settings
	else
		KBMSLRDFTKT_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function KT:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDFTKT_Settings = self.Settings
	else
		KBMSLRDFTKT_Settings = self.Settings
	end	
end

function KT:Castbar(units)
end

function KT:RemoveUnits(UnitID)
	if self.Kolmasveli.UnitID == UnitID then
		self.Kolmasveli.Available = false
		return true
	end
	return false
end

function KT:Death(UnitID)
	if self.Kolmasveli.UnitID == UnitID then
		self.Kolmasveli.Dead = true
	elseif self.Toinenveli.UnitID == UnitID then
		self.Toinenveli.Dead = true
	end
	if self.Kolmasveli.Dead and self.Toinenveli.Dead then
		return true
	end
	return false
end

function KT.PhaseTwo()
	if KT.Phase < 2 then
		KT.PhaseObj.Objectives:Remove()
		KT.PhaseObj:SetPhase("2")
		KT.PhaseObj.Objectives:AddPercent(KT.Kolmasveli, 30, 50)
		KT.PhaseObj.Objectives:AddPercent(KT.Toinenveli, 30, 50)
		KT.Phase = 2
	end
end

function KT.PhaseThree()
	if KT.Phase < 3 then
		KT.PhaseObj.Objectives:Remove()
		KT.PhaseObj:SetPhase("3")
		KT.PhaseObj.Objectives:AddPercent(KT.Kolmasveli, 10, 30)
		KT.PhaseObj.Objectives:AddPercent(KT.Toinenveli, 10, 30)
		KT.Phase = 3
	end
end

function KT.PhaseFinal()
	if KT.Phase < 4 then
		KT.PhaseObj.Objectives:Remove()
		KT.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		KT.PhaseObj.Objectives:AddPercent(KT.Kolmasveli, 0, 10)
		KT.PhaseObj.Objectives:AddPercent(KT.Toinenveli, 0, 10)
		KT.Phase = 4
	end
end

function KT:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.CastBar then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Kolmasveli, 50, 100)
					self.PhaseObj.Objectives:AddPercent(self.Toinenveli, 50, 100)
					self.Phase = 1
					local DebuffTable = {
							[1] = self.Lang.Debuff.KolIre[KBM.Lang],
							[2] = self.Lang.Debuff.ToiIre[KBM.Lang],
					}
					KBM.TankSwap:Start(DebuffTable, unitID, 2)
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.CastBar then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Kolmasveli
			end
		end
	end
end

function KT:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function KT:Timer()	
end

function KT:DefineMenu()
	self.Menu = FT.Menu:CreateEncounter(self.Kolmasveli, self.Enabled)
end

function KT:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Kolmasveli)
	
	-- Create Alerts
	self.Kolmasveli.AlertsRef.Glimpse = KBM.Alert:Create(self.Lang.Verbose.GlimpseKol[KBM.Lang], nil, true, true, "red")
	self.Toinenveli.AlertsRef.Glimpse = KBM.Alert:Create(self.Lang.Verbose.GlimpseToi[KBM.Lang], nil, true, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Kolmasveli)
	KBM.Defaults.AlertObj.Assign(self.Toinenveli)
	
	-- Assign Alerts and Timers to Triggers
	self.Kolmasveli.Triggers.Glimpse = KBM.Trigger:Create(self.Lang.Ability.Glimpse[KBM.Lang], "channel", self.Kolmasveli)
	self.Kolmasveli.Triggers.Glimpse:AddAlert(self.Kolmasveli.AlertsRef.Glimpse)
	self.Toinenveli.Triggers.Glimpse = KBM.Trigger:Create(self.Lang.Ability.Glimpse[KBM.Lang], "channel", self.Toinenveli)
	self.Toinenveli.Triggers.Glimpse:AddAlert(self.Toinenveli.AlertsRef.Glimpse)
	self.Kolmasveli.Triggers.PhaseTwo = KBM.Trigger:Create(50, "percent", self.Kolmasveli)
	self.Kolmasveli.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Kolmasveli.Triggers.PhaseThree = KBM.Trigger:Create(30, "percent", self.Kolmasveli)
	self.Kolmasveli.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Kolmasveli.Triggers.PhaseFinal = KBM.Trigger:Create(10, "percent", self.Kolmasveli)
	self.Kolmasveli.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	self.Toinenveli.Triggers.PhaseTwo = KBM.Trigger:Create(50, "percent", self.Toinenveli)
	self.Toinenveli.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Toinenveli.Triggers.PhaseThree = KBM.Trigger:Create(30, "percent", self.Toinenveli)
	self.Toinenveli.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Toinenveli.Triggers.PhaseFinal = KBM.Trigger:Create(10, "percent", self.Toinenveli)
	self.Toinenveli.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	
	self.Kolmasveli.CastBar = KBM.CastBar:Add(self, self.Kolmasveli)
	self.Toinenveli.CastBar = KBM.CastBar:Add(self, self.Toinenveli)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end