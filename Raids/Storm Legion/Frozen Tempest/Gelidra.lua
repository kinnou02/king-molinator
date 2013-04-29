-- Gelidra Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDFTGA_Settings = nil
chKBMSLRDFTGA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local FT = KBM.BossMod["RFrozen_Tempest"]

-- tank debuff "Deathly Chill" or "Deathly Hallows"

local GLD = {
	Enabled = true,
	Directory = FT.Directory,
	File = "Gelidra.lua",
	Instance = FT.Name,
	InstanceObj = FT,
	HasPhases = true,
	Lang = {},
	ID = "Gelidra",
	Enrage = (6 * 60) + 20,
	Object = "GLD",
	HardMode = false,
}

KBM.RegisterMod(GLD.ID, GLD)

-- Main Unit Dictionary
GLD.Lang.Unit = {}
GLD.Lang.Unit.Gelidra = KBM.Language:Add("Gelidra")
GLD.Lang.Unit.Gelidra:SetGerman("Gelidra")
GLD.Lang.Unit.Gelidra:SetFrench("Gelidra")
GLD.Lang.Unit.GelidraShort = KBM.Language:Add("Gelidra")
GLD.Lang.Unit.GelidraShort:SetGerman("Gelidra")
GLD.Lang.Unit.GelidraShort:SetFrench("Gelidra")
GLD.Lang.Unit.Vortex = KBM.Language:Add("Shrouding Vortex")
GLD.Lang.Unit.Vortex:SetGerman("Verhüllender Wirbel")
GLD.Lang.Unit.Vortex:SetFrench("Vortex enveloppant")
GLD.Lang.Unit.VortexShort = KBM.Language:Add("Vortex")
GLD.Lang.Unit.VortexShort:SetGerman("Wirbel")
GLD.Lang.Unit.VortexShort:SetFrench("Vortex")
GLD.Lang.Unit.Amrian = KBM.Language:Add("Amrian")

-- Ability Dictionary
GLD.Lang.Ability = {}
GLD.Lang.Ability.Cyclonic = KBM.Language:Add("Cyclonic Destruction")
GLD.Lang.Ability.Cyclonic:SetGerman("Zyklonische Zerstörung")
GLD.Lang.Ability.Cyclonic:SetFrench("Destruction cyclonique")
GLD.Lang.Ability.Cascade = KBM.Language:Add("Lacerating Cascade")
GLD.Lang.Ability.Cascade:SetGerman("Reißende Kaskade")
GLD.Lang.Ability.Cascade:SetFrench("Cascade lacérante")
GLD.Lang.Ability.Blizzard = KBM.Language:Add("Razorwind Blizzard")

-- Description Dictionary
GLD.Lang.Main = {}

-- Debuff Dictionary
GLD.Lang.Debuff = {}
GLD.Lang.Debuff.Hoar = KBM.Language:Add("Hoarfrost")
GLD.Lang.Debuff.Hoar:SetGerman("Raureif")
GLD.Lang.Debuff.Hoar:SetFrench("Givre")
GLD.Lang.Debuff.Rime = KBM.Language:Add("Glacial Rime")
GLD.Lang.Debuff.Rime:SetGerman("Gletscherreif")
GLD.Lang.Debuff.Rime:SetFrench("Éclats de sang gelé")
GLD.Lang.Debuff.Spasm = KBM.Language:Add("Voltaic Spasms")
GLD.Lang.Debuff.Spasm:SetGerman("Voltaische Krämpfe")
GLD.Lang.Debuff.Spasm:SetFrench("Spasmes voltaïques")
GLD.Lang.Debuff.Induction = KBM.Language:Add("Hypothermic Induction")

GLD.Lang.Messages = {}
GLD.Lang.Messages.Phase2 = KBM.Language:Add("Phase 2 starts")
GLD.Lang.Messages.Phase2:SetGerman("Phase 2 beginnt")
GLD.Lang.Messages.Phase2:SetFrench("Début Phase 2")
GLD.Lang.Messages.FirstP2 = KBM.Language:Add("First Phase 2")
GLD.Lang.Messages.FirstP2:SetGerman("Erste Phase 2")
GLD.Lang.Messages.FirstP2:SetFrench("Première Phase 2")

GLD.Descript = GLD.Lang.Unit.Gelidra[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
GLD.Gelidra = {
	Mod = GLD,
	Level = "??",
	Active = false,
	Name = GLD.Lang.Unit.Gelidra[KBM.Lang],
	NameShort = GLD.Lang.Unit.GelidraShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFA195D8347994DEE",
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
			FirstP2 = KBM.Defaults.TimerObj.Create("dark_green"),
			Phase2 = KBM.Defaults.TimerObj.Create("dark_green"),
			Cascade = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Cascade = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Rime = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

GLD.Amrian = {
	Mod = GLD,
	Level = "??",
	Active = false,
	Name = GLD.Lang.Unit.Amrian[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	-- TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "none",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		AlertsRef = {
			Enabled = true,
			Induction = KBM.Defaults.AlertObj.Create("cyan"),
			Blizzard = KBM.Defaults.AlertObj.Create("blue"),
		},
		MechRef = {
			Enabled = true,
			Induction = KBM.Defaults.MechObj.Create("cyan"),
			Blizzard = KBM.Defaults.MechObj.Create("blue"),
		},		
	}
}


GLD.Vortex = {
	Mod = GLD,
	Level = "??",
	Active = false,
	Name = GLD.Lang.Unit.Vortex[KBM.Lang],
	NameShort = GLD.Lang.Unit.VortexShort[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	-- TimersRef = {},
	Available = false,
	UTID = "UFB17379E4CB69B1A",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		AlertsRef = {
			Enabled = true,
			Cyclonic = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

function GLD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Gelidra.Name] = self.Gelidra,
		[self.Vortex.Name] = self.Vortex,
		[self.Amrian.Name] = self.Amrian,
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

function GLD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		Gelidra = {
			CastBar = self.Gelidra.Settings.CastBar,
			AlertsRef = self.Gelidra.Settings.AlertsRef,
			TimersRef = self.Gelidra.Settings.TimersRef,
			MechRef = self.Gelidra.Settings.MechRef,
		},
		Vortex = {
			CastBar = self.Vortex.Settings.CastBar,
			AlertsRef = self.Vortex.Settings.AlertsRef,
		},
		Amrian = {
			CastBar = self.Amrian.Settings.CastBar,
			AlertsRef = self.Amrian.Settings.AlertsRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMSLRDFTGA_Settings = self.Settings
	chKBMSLRDFTGA_Settings = self.Settings
	
end

function GLD:SwapSettings(bool)

	if bool then
		KBMSLRDFTGA_Settings = self.Settings
		self.Settings = chKBMSLRDFTGA_Settings
	else
		chKBMSLRDFTGA_Settings = self.Settings
		self.Settings = KBMSLRDFTGA_Settings
	end

end

function GLD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDFTGA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDFTGA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDFTGA_Settings = self.Settings
	else
		KBMSLRDFTGA_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function GLD:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDFTGA_Settings = self.Settings
	else
		KBMSLRDFTGA_Settings = self.Settings
	end	
end

function GLD:Castbar(units)
end

function GLD:RemoveUnits(UnitID)
	if self.Gelidra.UnitID == UnitID then
		self.Gelidra.Available = false
		return true
	end
	return false
end

function GLD:Death(UnitID)
	if self.Gelidra.UnitID == UnitID then
		self.Gelidra.Dead = true
		return true
	end
	if self.Vortex.UnitID == UnitID then
		self.PhaseObj.Objectives:Remove()
		self.Vortex.UnitID = nil
		self.PhaseObj:SetPhase("1")
		self.PhaseObj.Objectives:AddPercent(self.Gelidra, 0, 100)
		if self.Amrian.UnitID then
			self.PhaseObj.Objectives:AddPercent(self.Amrian, 0, 100)
		end
		KBM.MechTimer:AddStart(self.Gelidra.TimersRef.Phase2)
	end
	return false
end

function GLD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if not BossObj then
			BossObj = self.Bosses[uDetails.name]
		end
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
				self.PhaseObj.Objectives:AddPercent(self.Gelidra, 0, 100)
				self.Phase = 1
				local DebuffTable = {
						[1] = self.Lang.Debuff.Hoar[KBM.Lang],
						[2] = self.Lang.Debuff.Spasm[KBM.Lang],
				}
				KBM.TankSwap:Start(DebuffTable, unitID, 2)
				KBM.MechTimer:AddStart(self.Gelidra.TimersRef.FirstP2)
				if BossObj == self.Amrian then
					if not self.HardMode then
						KBM.PercentageMon:Start(self.ID, true)
						self.HardMode = true
					end
				end
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					BossObj.CastBar:Remove()
					BossObj.CastBar:Create(unitID)
					if BossObj == self.Vortex then
						self.PhaseObj:SetPhase("2")
						self.PhaseObj.Objectives:AddPercent(self.Vortex, 0, 100)
					elseif BossObj == self.Amrian then
						self.PhaseObj.Objectives:AddPercent(self.Amrian, 0, 100)
						if not self.HardMode then
							KBM.PercentageMon:Start(self.ID, true)
							self.HardMode = true
						end
					end
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function GLD:Reset()
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
	self.HardMode = false
end

function GLD:Timer()	
end

function GLD:DefineMenu()
	self.Menu = FT.Menu:CreateEncounter(self.Gelidra, self.Enabled)
end

function GLD:Start()
	-- Create Timers
	self.Gelidra.TimersRef.Cascade = KBM.MechTimer:Add(self.Lang.Ability.Cascade[KBM.Lang], 11, false)
	self.Gelidra.TimersRef.FirstP2 = KBM.MechTimer:Add(self.Lang.Messages.Phase2[KBM.Lang], 40, false)
	self.Gelidra.TimersRef.FirstP2.MenuName = self.Lang.Messages.FirstP2[KBM.Lang]
	self.Gelidra.TimersRef.Phase2 = KBM.MechTimer:Add(self.Lang.Messages.Phase2[KBM.Lang], 75, false)
	KBM.Defaults.TimerObj.Assign(self.Gelidra)
	
	-- Create Alerts
	self.Gelidra.AlertsRef.Cascade = KBM.Alert:Create(self.Lang.Ability.Cascade[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Gelidra)

	self.Vortex.AlertsRef.Cyclonic = KBM.Alert:Create(self.Lang.Ability.Cyclonic[KBM.Lang], nil, true, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Vortex)
	
	self.Amrian.AlertsRef.Induction = KBM.Alert:Create(self.Lang.Debuff.Induction[KBM.Lang], nil, false, true, "cyan")
	self.Amrian.AlertsRef.Induction.MenuName = self.Lang.Debuff.Induction[KBM.Lang].." (HM)"
	self.Amrian.AlertsRef.Blizzard = KBM.Alert:Create(self.Lang.Ability.Blizzard[KBM.Lang], nil, false, true, "blue")
	self.Amrian.AlertsRef.Blizzard.MenuName = self.Lang.Ability.Blizzard[KBM.Lang].." (HM)"
	KBM.Defaults.AlertObj.Assign(self.Amrian)

	-- Create Mechanic Spies (Gelidra)
	self.Gelidra.MechRef.Rime = KBM.MechSpy:Add(self.Lang.Debuff.Rime[KBM.Lang], nil, "playerDebuff", self.Gelidra)
	KBM.Defaults.MechObj.Assign(self.Gelidra)
	
	self.Amrian.MechRef.Induction = KBM.MechSpy:Add(self.Lang.Debuff.Induction[KBM.Lang], nil, "playerDebuff", self.Amrian)
	self.Amrian.MechRef.Induction.MenuName = self.Lang.Debuff.Induction[KBM.Lang].." (HM)"
	self.Amrian.MechRef.Blizzard = KBM.MechSpy:Add(self.Lang.Ability.Blizzard[KBM.Lang], 4, "cast", self.Amrian)
	self.Amrian.MechRef.Blizzard.MenuName = self.Lang.Ability.Blizzard[KBM.Lang].." (HM)"
	KBM.Defaults.MechObj.Assign(self.Amrian)
	
	-- Assign Alerts and Timers to Triggers
	self.Gelidra.Triggers.Cascade = KBM.Trigger:Create(self.Lang.Ability.Cascade[KBM.Lang], "cast", self.Gelidra)
	self.Gelidra.Triggers.Cascade:AddAlert(self.Gelidra.AlertsRef.Cascade)
	self.Gelidra.Triggers.Cascade:AddTimer(self.Gelidra.TimersRef.Cascade)
	self.Gelidra.Triggers.Rime = KBM.Trigger:Create(self.Lang.Debuff.Rime[KBM.Lang], "playerBuff", self.Gelidra)
	self.Gelidra.Triggers.Rime:AddSpy(self.Gelidra.MechRef.Rime)
	self.Gelidra.Triggers.RimeRem = KBM.Trigger:Create(self.Lang.Debuff.Rime[KBM.Lang], "playerBuffRemove", self.Gelidra)
	self.Gelidra.Triggers.RimeRem:AddStop(self.Gelidra.MechRef.Rime)

	self.Vortex.Triggers.Cyclonic = KBM.Trigger:Create(self.Lang.Ability.Cyclonic[KBM.Lang], "cast", self.Vortex)
	self.Vortex.Triggers.Cyclonic:AddAlert(self.Vortex.AlertsRef.Cyclonic)
	self.Vortex.Triggers.CyclonicInt = KBM.Trigger:Create(self.Lang.Ability.Cyclonic[KBM.Lang], "interrupt", self.Vortex)
	self.Vortex.Triggers.CyclonicInt:AddStop(self.Vortex.AlertsRef.Cyclonic)
	
	self.Amrian.Triggers.Blizzard = KBM.Trigger:Create(self.Lang.Ability.Blizzard[KBM.Lang], "cast", self.Amrian)
	self.Amrian.Triggers.Blizzard:AddAlert(self.Amrian.AlertsRef.Blizzard)
	self.Amrian.Triggers.Blizzard:AddSpy(self.Amrian.MechRef.Blizzard)
	self.Amrian.Triggers.Induction = KBM.Trigger:Create(self.Lang.Debuff.Induction[KBM.Lang], "playerDebuff", self.Amrian)
	self.Amrian.Triggers.Induction:AddAlert(self.Amrian.AlertsRef.Induction, true)
	self.Amrian.Triggers.Induction:AddSpy(self.Amrian.MechRef.Induction)
	
	self.PercentageMon = KBM.PercentageMon:Create(self.Gelidra, self.Amrian, 10, true)
	self.Gelidra.CastBar = KBM.CastBar:Add(self, self.Gelidra)
	self.Vortex.CastBar = KBM.CastBar:Add(self, self.Vortex)
	self.Amrian.CastBar = KBM.CastBar:Add(self, self.Amrian)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end