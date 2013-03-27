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
KT.Lang.Unit.Kolmasveli:SetFrench("Kolmasveli") 
KT.Lang.Unit.KolmasveliShort = KBM.Language:Add("Kolmasveli")
KT.Lang.Unit.KolmasveliShort:SetGerman()
KT.Lang.Unit.KolmasveliShort:SetFrench("Kolmasveli") 
KT.Lang.Unit.Toinenveli = KBM.Language:Add("Toinenveli")
KT.Lang.Unit.Toinenveli:SetGerman()
KT.Lang.Unit.Toinenveli:SetFrench("Toinenveli") 
KT.Lang.Unit.ToinenveliShort = KBM.Language:Add("Toinenveli")
KT.Lang.Unit.ToinenveliShort:SetGerman()
KT.Lang.Unit.ToinenveliShort:SetFrench("Toinenveli") 
KT.Lang.Unit.Vortex = KBM.Language:Add("Energy Vortex")
KT.Lang.Unit.Vortex:SetGerman("Energiewirbel")
KT.Lang.Unit.Vortex:SetFrench("Vortex d'énergie")
KT.Lang.Unit.VortexShort = KBM.Language:Add("Vortex")
KT.Lang.Unit.VortexShort:SetGerman("Wirbel")
KT.Lang.Unit.VortexShort:SetFrench("Vortex")  

-- Ability Dictionary
KT.Lang.Ability = {}
KT.Lang.Ability.Glimpse = KBM.Language:Add("Glimpse of Infinity")
KT.Lang.Ability.Glimpse:SetGerman("Blick in die Ewigkeit")
KT.Lang.Ability.Glimpse:SetFrench("Lueur de l'Infini")
KT.Lang.Ability.Flare = KBM.Language:Add("Tempest Flare")
KT.Lang.Ability.Flare:SetGerman("Sturmherr-Fackel")
KT.Lang.Ability.Flare:SetFrench("Flamboiement tempêtueux")

-- Debuff Dictionary
KT.Lang.Debuff = {}
KT.Lang.Debuff.KolIre = KBM.Language:Add("Kolmasveli's Ire")
KT.Lang.Debuff.KolIre:SetGerman("Kolmasvelis Grimm")
KT.Lang.Debuff.KolIre:SetFrench("Courroux de Kolmasveli")
KT.Lang.Debuff.KolIreID = "B2251D45CEBC75B22"
KT.Lang.Debuff.KolIreID2 = "BFF1D1165EAA5E3F3"
KT.Lang.Debuff.ToiIre = KBM.Language:Add("Toinenveli's Ire")
KT.Lang.Debuff.ToiIre:SetGerman("Toinenvelis Grimm")
KT.Lang.Debuff.ToiIre:SetFrench("Courroux de Toinenveli")
KT.Lang.Debuff.ToiIreID = "B01CBADD02857982F"
KT.Lang.Debuff.ToiIreID2 = "BFE566AB12246C0CB"
KT.Lang.Debuff.Eruption = KBM.Language:Add("Sparking Eruption")
KT.Lang.Debuff.Eruption:SetGerman("Zündender Ausbruch")
KT.Lang.Debuff.Eruption:SetFrench("Éruption d'étincelles")
KT.Lang.Debuff.Shock = KBM.Language:Add("Devastating Shock")
KT.Lang.Debuff.Shock:SetFrench("Choc dévastateur")

-- Verbose Dictionary
KT.Lang.Verbose = {}
KT.Lang.Verbose.GlimpseKol = KBM.Language:Add("Hide from Kolmasveli!")
KT.Lang.Verbose.GlimpseKol:SetGerman("Verstecken vor Kolmasveli!")
KT.Lang.Verbose.GlimpseKol:SetFrench("Se cacher de Kolmasveli!")
KT.Lang.Verbose.GlimpseToi = KBM.Language:Add("Hide from Toinenveli!")
KT.Lang.Verbose.GlimpseToi:SetGerman("Verstecken vor Toinenveli!")
KT.Lang.Verbose.GlimpseToi:SetFrench("Se cacher de Toinenveli!")
KT.Lang.Verbose.RunAway = KBM.Language:Add("Run away from raid!")
KT.Lang.Verbose.RunAway:SetFrench("S'éloigner du raid!")

-- Description Dictionary
KT.Lang.Main = {}
KT.Lang.Main.Descript = KBM.Language:Add("Kolmasveli and Toinenveli")
KT.Lang.Main.Descript:SetGerman("Kolmasveli und Toinenveli")
KT.Lang.Main.Descript:SetFrench("Kolmasveli et Toinenveli")
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
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Glimpse = KBM.Defaults.TimerObj.Create("red"),
			GlimpseFirst = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Ire = KBM.Defaults.AlertObj.Create("blue"),
			Eruption = KBM.Defaults.AlertObj.Create("dark_green"),
			Glimpse = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Eruption = KBM.Defaults.MechObj.Create("dark_green"),
			IreVuln = KBM.Defaults.MechObj.Create("red"),
			Shock = KBM.Defaults.MechObj.Create("purple")
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
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Glimpse = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			Ire = KBM.Defaults.AlertObj.Create("red"),
			Glimpse = KBM.Defaults.AlertObj.Create("orange"),
		},
		MechRef = {
			Enabled = true,
			IreVuln = KBM.Defaults.MechObj.Create("red"),
			Shock = KBM.Defaults.MechObj.Create("purple")
		},
	}
}

KT.Vortex = {
	Mod = KT,
	Level = "??",
	Active = false,
	Name = KT.Lang.Unit.Vortex[KBM.Lang],
	NameShort = KT.Lang.Unit.VortexShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFF0BC16350D617CC",
	UnitID = nil,
	Castbar = nil,
	AlertsRef = {},
	Triggers = {},
	Ignore = true,
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Flare = KBM.Defaults.AlertObj.Create("cyan"),
		},
	},
}

function KT:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kolmasveli.Name] = self.Kolmasveli,
		[self.Toinenveli.Name] = self.Toinenveli,
		[self.Vortex.Name] = self.Vortex,
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
		MechSpy = KBM.Defaults.MechSpy(),
		MechTimer = KBM.Defaults.MechTimer(),
		Kolmasveli = {
			CastBar = self.Kolmasveli.Settings.CastBar,
			AlertsRef = self.Kolmasveli.Settings.AlertsRef,
			TimersRef = self.Kolmasveli.Settings.TimersRef,
			MechRef = self.Kolmasveli.Settings.MechRef,
		},
		Toinenveli = {
			CastBar = self.Toinenveli.Settings.CastBar,
			AlertsRef = self.Toinenveli.Settings.AlertsRef,
			TimersRef = self.Toinenveli.Settings.TImersRef,
			MechRef = self.Toinenveli.Settings.MechRef,
		},
		Vortex = {
			CastBar = self.Vortex.Settings.CastBar,
			AlertsRef = self.Vortex.Settings.AlertsRef,
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
		if self.Toinenveli.Dead then
			return true
		end
	elseif self.Toinenveli.UnitID == UnitID then
		self.Toinenveli.Dead = true
		if self.Kolmasveli.Dead then
			return true
		end
	end
	return false
end

function KT.PhaseTwo()
	if KT.Phase < 2 then
		KT.PhaseObj.Objectives:Remove()
		KT.PhaseObj:SetPhase("2")
		KT.PhaseObj.Objectives:AddPercent(KT.Kolmasveli, 10, 40)
		KT.PhaseObj.Objectives:AddPercent(KT.Toinenveli, 10, 40)
		KT.Phase = 2
	end
end

function KT.PhaseFinal()
	if KT.Phase < 3 then
		KT.PhaseObj.Objectives:Remove()
		KT.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		KT.PhaseObj.Objectives:AddPercent(KT.Kolmasveli, 0, 10)
		KT.PhaseObj.Objectives:AddPercent(KT.Toinenveli, 0, 10)
		KT.Phase = 3
	end
end

function KT:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type then
			local BossObj = self.UTID[uDetails.type]
			if BossObj then
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
					self.PhaseObj.Objectives:AddPercent(self.Kolmasveli, 40, 100)
					self.PhaseObj.Objectives:AddPercent(self.Toinenveli, 40, 100)
					self.Phase = 1
					local DebuffTable = {
							[1] = self.Lang.Debuff.KolIre[KBM.Lang],
							[2] = self.Lang.Debuff.ToiIre[KBM.Lang],
					}
					KBM.TankSwap:Start(DebuffTable, unitID, 2)
					KBM.MechTimer:AddStart(self.Kolmasveli.TimersRef.GlimpseFirst)
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.CastBar then
						if BossObj.UnitID ~= unitID then
							BossObj.CastBar:Remove()
							BossObj.CastBar:Create(unitID)
						end
					end
					if BossObj == self.Kolmasveli or BossObj == self.Toinenveli then
						KBM.TankSwap:AddBoss(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return BossObj
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
	self.Kolmasveli.TimersRef.Glimpse = KBM.MechTimer:Add(self.Lang.Verbose.GlimpseKol[KBM.Lang], 140)
	self.Kolmasveli.TimersRef.GlimpseFirst = KBM.MechTimer:Add(self.Lang.Verbose.GlimpseKol[KBM.Lang], 170)
	self.Kolmasveli.TimersRef.GlimpseFirst:NoMenu()
	KBM.Defaults.TimerObj.Assign(self.Kolmasveli)
	
	self.Kolmasveli.TimersRef.Glimpse:SetLink(self.Kolmasveli.TimersRef.GlimpseFirst)
	
	self.Toinenveli.TimersRef.Glimpse = KBM.MechTimer:Add(self.Lang.Verbose.GlimpseToi[KBM.Lang], 60)	
	KBM.Defaults.TimerObj.Assign(self.Toinenveli)
	
	-- Create Alerts
	self.Kolmasveli.AlertsRef.Ire = KBM.Alert:Create(self.Lang.Debuff.KolIre[KBM.Lang], 5, true, true, "blue")
	self.Kolmasveli.AlertsRef.Glimpse = KBM.Alert:Create(self.Lang.Verbose.GlimpseKol[KBM.Lang], nil, true, true, "red")
	self.Kolmasveli.AlertsRef.Eruption = KBM.Alert:Create(self.Lang.Debuff.Eruption[KBM.Lang], nil, true, true, "dark_green")
	self.Kolmasveli.AlertsRef.Eruption:Important()
	KBM.Defaults.AlertObj.Assign(self.Kolmasveli)
	
	self.Toinenveli.AlertsRef.Ire = KBM.Alert:Create(self.Lang.Debuff.ToiIre[KBM.Lang], 5, true, true, "red")	
	self.Toinenveli.AlertsRef.Glimpse = KBM.Alert:Create(self.Lang.Verbose.GlimpseToi[KBM.Lang], nil, true, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Toinenveli)

	self.Vortex.AlertsRef.Flare = KBM.Alert:Create(self.Lang.Ability.Flare[KBM.Lang], nil, true, true, "cyan")
	self.Vortex.AlertsRef.Flare:Important()
	KBM.Defaults.AlertObj.Assign(self.Vortex)

	-- Create Spies
	self.Kolmasveli.MechRef.IreVuln = KBM.MechSpy:Add(self.Lang.Debuff.KolIre[KBM.Lang], nil, "playerDebuff", self.Kolmasveli)
	self.Kolmasveli.MechRef.Eruption = KBM.MechSpy:Add(self.Lang.Debuff.Eruption[KBM.Lang], nil, "playerDebuff", self.Kolmasveli)
	self.Kolmasveli.MechRef.Shock = KBM.MechSpy:Add(self.Lang.Debuff.Shock[KBM.Lang], nil, "playerDebuff", self.Kolmasveli)
	KBM.Defaults.MechObj.Assign(self.Kolmasveli)

	self.Toinenveli.MechRef.IreVuln = KBM.MechSpy:Add(self.Lang.Debuff.ToiIre[KBM.Lang], nil, "playerDebuff", self.Toinenveli)
	KBM.Defaults.MechObj.Assign(self.Toinenveli)
	
	-- Assign Alerts and Timers to Triggers
	self.Kolmasveli.Triggers.Ire = KBM.Trigger:Create(KT.Lang.Debuff.KolIreID, "playerIDBuff", self.Kolmasveli)
	self.Kolmasveli.Triggers.Ire:AddAlert(self.Kolmasveli.AlertsRef.Ire)
	self.Kolmasveli.Triggers.IreVuln = KBM.Trigger:Create(KT.Lang.Debuff.KolIreID2, "playerIDBuff", self.Kolmasveli)
	self.Kolmasveli.Triggers.IreVuln:AddSpy(self.Kolmasveli.MechRef.IreVuln)
	self.Kolmasveli.Triggers.Glimpse = KBM.Trigger:Create(self.Lang.Ability.Glimpse[KBM.Lang], "channel", self.Kolmasveli)
	self.Kolmasveli.Triggers.Glimpse:AddAlert(self.Kolmasveli.AlertsRef.Glimpse)
	self.Kolmasveli.Triggers.Glimpse:AddTimer(self.Toinenveli.TimersRef.Glimpse)
	self.Kolmasveli.Triggers.Eruption = KBM.Trigger:Create(KT.Lang.Debuff.Eruption[KBM.Lang], "playerBuff", self.Kolmasveli)
	self.Kolmasveli.Triggers.Eruption:AddSpy(self.Kolmasveli.MechRef.Eruption)
	self.Kolmasveli.Triggers.Eruption:AddAlert(self.Kolmasveli.AlertsRef.Eruption, true)
	self.Kolmasveli.Triggers.PhaseTwo = KBM.Trigger:Create(40, "percent", self.Kolmasveli)
	self.Kolmasveli.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Kolmasveli.Triggers.PhaseFinal = KBM.Trigger:Create(10, "percent", self.Kolmasveli)
	self.Kolmasveli.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	self.Kolmasveli.Triggers.Shock = KBM.Trigger:Create(KT.Lang.Debuff.Shock[KBM.Lang], "playerBuff", self.Kolmasveli)
	self.Kolmasveli.Triggers.Shock:AddSpy(self.Kolmasveli.MechRef.Shock)
	self.Kolmasveli.Triggers.ShockRem = KBM.Trigger:Create(KT.Lang.Debuff.Shock[KBM.Lang], "playerBuffRemove", self.Kolmasveli)
	self.Kolmasveli.Triggers.ShockRem:AddStop(self.Kolmasveli.MechRef.Shock)
	
	self.Toinenveli.Triggers.Ire = KBM.Trigger:Create(KT.Lang.Debuff.ToiIreID, "playerIDBuff", self.Toinenveli)
	self.Toinenveli.Triggers.Ire:AddAlert(self.Toinenveli.AlertsRef.Ire)
	self.Toinenveli.Triggers.IreVuln = KBM.Trigger:Create(KT.Lang.Debuff.ToiIreID2, "playerIDBuff", self.Toinenveli)
	self.Toinenveli.Triggers.IreVuln:AddSpy(self.Toinenveli.MechRef.IreVuln)	
	self.Toinenveli.Triggers.Glimpse = KBM.Trigger:Create(self.Lang.Ability.Glimpse[KBM.Lang], "channel", self.Toinenveli)
	self.Toinenveli.Triggers.Glimpse:AddAlert(self.Toinenveli.AlertsRef.Glimpse)
	self.Toinenveli.Triggers.Glimpse:AddTimer(self.Kolmasveli.TimersRef.Glimpse)
	self.Toinenveli.Triggers.PhaseTwo = KBM.Trigger:Create(40, "percent", self.Toinenveli)
	self.Toinenveli.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Toinenveli.Triggers.PhaseFinal = KBM.Trigger:Create(10, "percent", self.Toinenveli)
	self.Toinenveli.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)

	self.Vortex.Triggers.Flare = KBM.Trigger:Create(self.Lang.Ability.Flare[KBM.Lang], "cast", self.Vortex)
	self.Vortex.Triggers.Flare:AddAlert(self.Vortex.AlertsRef.Flare)
	self.Vortex.Triggers.FlareInt = KBM.Trigger:Create(self.Lang.Ability.Flare[KBM.Lang], "interrupt", self.Vortex)
	self.Vortex.Triggers.FlareInt:AddStop(self.Vortex.AlertsRef.Flare)
	
	self.PercentageMon = KBM.PercentageMon:Create(self.Kolmasveli, self.Toinenveli, 5)
	self.Kolmasveli.CastBar = KBM.CastBar:Add(self, self.Kolmasveli)
	self.Toinenveli.CastBar = KBM.CastBar:Add(self, self.Toinenveli)
	self.Vortex.CastBar = KBM.CastBar:Add(self, self.Vortex)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end