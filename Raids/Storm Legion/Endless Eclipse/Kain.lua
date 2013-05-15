-- Kain the Reaper Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEEKR_Settings = nil
chKBMSLRDEEKR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local EE = KBM.BossMod["REndless_Eclipse"]

local KR = {
	Enabled = true,
	Directory = EE.Directory,
	File = "Kain.lua",
	Instance = EE.Name,
	InstanceObj = EE,
	HasPhases = true,
	Lang = {},
	ID = "RKain_the_Reaper",
	Object = "KR",
}

KBM.RegisterMod(KR.ID, KR)

-- Main Unit Dictionary
KR.Lang.Unit = {}
KR.Lang.Unit.Kain = KBM.Language:Add("Kain the Reaper")
KR.Lang.Unit.Kain:SetGerman("Kain der Schnitter")
KR.Lang.Unit.Kain:SetFrench("Kain le Faucheur")
KR.Lang.Unit.KainShort = KBM.Language:Add("Kain")
KR.Lang.Unit.KainShort:SetGerman("Kain")
KR.Lang.Unit.KainShort:SetFrench("Kain")
KR.Lang.Unit.Zathral = KBM.Language:Add("Zathral Ashtongue")
KR.Lang.Unit.Zathral:SetFrench("Zathral Langue-cendrée")
KR.Lang.Unit.Zathral:SetGerman("Zathral Aschzunge")
KR.Lang.Unit.ZathralShort = KBM.Language:Add("Zathral")
KR.Lang.Unit.ZathralShort:SetFrench("Zathral")
KR.Lang.Unit.ZathralShort:SetGerman("Zathral")
KR.Lang.Unit.Baziel = KBM.Language:Add("Baziel Rotflesh")
KR.Lang.Unit.Baziel:SetFrench("Baziel Chairpourrie")
KR.Lang.Unit.Baziel:SetGerman("Baziel Faulfleisch")
KR.Lang.Unit.BazielShort = KBM.Language:Add("Baziel")
KR.Lang.Unit.BazielShort:SetFrench("Baziel")
KR.Lang.Unit.BazielShort:SetGerman("Baziel")
KR.Lang.Unit.Thief = KBM.Language:Add("Deathbound Bloodthief")
KR.Lang.Unit.Thief:SetFrench("Voleur de sang maudit")
KR.Lang.Unit.Thief:SetGerman("Todesgebundener Blutdieb")

-- Ability Dictionary
KR.Lang.Ability = {}
KR.Lang.Ability.Vile = KBM.Language:Add("Vile Blood")
KR.Lang.Ability.Vile:SetFrench("Sang infâme")
KR.Lang.Ability.Vile:SetGerman("Übles Blut")
KR.Lang.Ability.Foul = KBM.Language:Add("Foul Blood")
KR.Lang.Ability.Foul:SetFrench("Sang infect")
KR.Lang.Ability.Foul:SetGerman("Fauliges Blut")

-- Debuff Dictionary
KR.Lang.Debuff = {}
KR.Lang.Debuff.Ravenous = KBM.Language:Add("Ravenous Hunger")
KR.Lang.Debuff.Ravenous:SetGerman("Unbändiger Hunger")
KR.Lang.Debuff.Ravenous:SetFrench("Fringale vorace")
KR.Lang.Debuff.RavenousID = "BFF195769E88347C3"
KR.Lang.Debuff.Voracious = KBM.Language:Add("Voracious Hunger")
KR.Lang.Debuff.Voracious:SetFrench("Appétit vorace")
KR.Lang.Debuff.Voracious:SetGerman("Unstillbarer Hunger")
KR.Lang.Debuff.VoraciousID = "BFEB697D0228F51D9"

-- Description Dictionary
KR.Lang.Main = {}

KR.Descript = KR.Lang.Unit.Kain[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
KR.Kain = {
	Mod = KR,
	Level = "??",
	Active = false,
	Name = KR.Lang.Unit.Kain[KBM.Lang],
	NameShort = KR.Lang.Unit.KainShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFED5D20F2D11A108",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	--TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		--TimersRef = {
		--	Enabled = true,
		--	AddsSpawn = KBM.Defaults.TimerObj.Create("cyan"),
		--},
		AlertsRef = {
			Enabled = true,
			Foul = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Voracious = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

-- Add Unit Creation
KR.Zathral = {
	Mod = KR,
	Level = "??",
	Active = false,
	Name = KR.Lang.Unit.Zathral[KBM.Lang],
	NameShort = KR.Lang.Unit.ZathralShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFD0D0C831F686B02",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	--TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		--TimersRef = {
		--	Enabled = true,
		--	AddsSpawn = KBM.Defaults.TimerObj.Create("cyan")
		--},
		AlertsRef = {
			Enabled = true,
			Vile = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

KR.Baziel = {
	Mod = KR,
	Level = "??",
	Active = false,
	Name = KR.Lang.Unit.Baziel[KBM.Lang],
	NameShort = KR.Lang.Unit.BazielShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFDF01DAF799F6BA9",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	--TimersRef = {},
	--AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		--TimersRef = {
		--	Enabled = true,
		--	AddsSpawn = KBM.Defaults.TimerObj.Create("cyan")
		--},
		--AlertsRef = {
		--	Enabled = true,
		--	Vile = KBM.Defaults.AlertObj.Create("red"),
		--},
		MechRef = {
			Enabled = true,
			Ravenous = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

KR.Thief = {
	Mod = KR,
	Level = "??",
	Name = "Deathbound Bloodthief",
	UnitList = {},
	Ignore = true,
	Type = "multi",
	UTID = "UFCC83EB55DCCE3D3",
}

function KR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kain.Name] = self.Kain,
		[self.Zathral.Name] = self.Zathral,
		[self.Baziel.Name] = self.Baziel,
		[self.Thief.Name] = self.Thief,
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

function KR:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		--MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Kain = {
			CastBar = self.Kain.Settings.CastBar,
			AlertsRef = self.Kain.Settings.AlertsRef,
			MechRef = self.Kain.Settings.MechRef,
		},
		Zathral = {
			CastBar = self.Zathral.Settings.CastBar,
			AlertsRef = self.Zathral.Settings.AlertsRef,
		},
		Baziel = {
			CastBar = self.Baziel.Settings.CastBar,
			MechRef = self.Baziel.Settings.MechRef,
		},
	}
	KBMSLRDEEKR_Settings = self.Settings
	chKBMSLRDEEKR_Settings = self.Settings
	
end

function KR:SwapSettings(bool)

	if bool then
		KBMSLRDEEKR_Settings = self.Settings
		self.Settings = chKBMSLRDEEKR_Settings
	else
		chKBMSLRDEEKR_Settings = self.Settings
		self.Settings = KBMSLRDEEKR_Settings
	end

end

function KR:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDEEKR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDEEKR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDEEKR_Settings = self.Settings
	else
		KBMSLRDEEKR_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function KR:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDEEKR_Settings = self.Settings
	else
		KBMSLRDEEKR_Settings = self.Settings
	end	
end

function KR:Castbar(units)
end

function KR:RemoveUnits(UnitID)
	if self.Kain.UnitID == UnitID then
		self.Kain.Available = false
		return true
	end
	return false
end

function KR:Death(UnitID)
	if self.Kain.UnitID == UnitID then
		self.Kain.Dead = true
		return true
	elseif self.Zathral.UnitID == UnitID then
		self.Zathral.Dead = true
		self.PhaseObj.Objectives:Remove()
		self.PhaseObj.Objectives:AddPercent(self.Baziel, 0, 100)
		self.PhaseObj:SetPhase("2")
		self.Phase = 2
	elseif self.Baziel.UnitID == UnitID then
		self.Baziel.Dead = true
		self.PhaseObj.Objectives:Remove()
		self.PhaseObj.Objectives:AddPercent(self.Kain, 0, 100)
		self.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		self.Phase = 3
	elseif self.Thief.UnitList[UnitID] then
		self.Thief.UnitList[UnitID].Dead = true
	end
	return false
end

function KR:UnitHPCheck(uDetails, unitID)	
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
					BossObj.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					if BossObj.Name == self.Zathral.Name then
						self.PhaseObj:SetPhase("1")
						self.PhaseObj.Objectives:AddPercent(self.Zathral, 0, 100)
						self.Phase = 1
					elseif BossObj.Name == self.Baziel.Name then
						self.PhaseObj:SetPhase("2")
						self.PhaseObj.Objectives:AddPercent(self.Baziel, 0, 100)
						self.Phase = 2
					elseif BossObj.Name == self.Kain.Name then
						self.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
						self.PhaseObj.Objectives:AddPercent(self.Kain, 0, 100)
						self.Phase = 3
					end
				elseif BossObj == self.Thief then
					if not self.Thief.UnitList[unitID] then
						local SubBossObj = {
							Mod = KR,
							Level = "??",
							Name = uDetails.name,
							Dead = false,
							Casting = false,
							UnitID = unitID,
							Available = true,
						}
						self.Thief.UnitList[unitID] = SubBossObj
						return SubBossObj
					end
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.UnitID ~= unitID then
						BossObj.CastBar:Remove()
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return BossObj
			end
		end
	end
end

function KR:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
		if BossObj.CastBar and BossObj.CastBar.Active then
			BossObj.CastBar:Remove()
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function KR:Timer()	
end

function KR:DefineMenu()
	self.Menu = EE.Menu:CreateEncounter(self.Kain, self.Enabled)
end

function KR:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Kain)
	
	-- Create Alerts
	self.Zathral.AlertsRef.Vile = KBM.Alert:Create(KR.Lang.Ability.Vile[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Zathral)

	self.Kain.AlertsRef.Foul = KBM.Alert:Create(KR.Lang.Ability.Foul[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Kain)

	-- Create Mechanic Spies
	self.Baziel.MechRef.Ravenous = KBM.MechSpy:Add(self.Lang.Debuff.Ravenous[KBM.Lang], nil, "playerIDBuff", self.Baziel)
	KBM.Defaults.MechObj.Assign(self.Baziel)

	self.Kain.MechRef.Voracious = KBM.MechSpy:Add(self.Lang.Debuff.Voracious[KBM.Lang], nil, "playerIDBuff", self.Kain)
	KBM.Defaults.MechObj.Assign(self.Kain)
	
	-- Assign Alerts and Timers to Triggers
	self.Zathral.Triggers.Vile = KBM.Trigger:Create(self.Lang.Ability.Vile[KBM.Lang], "cast", self.Zathral)
	self.Zathral.Triggers.Vile:AddAlert(self.Zathral.AlertsRef.Vile)

	self.Baziel.Triggers.Ravenous = KBM.Trigger:Create(self.Lang.Debuff.RavenousID, "playerIDBuff", self.Baziel)
	self.Baziel.Triggers.Ravenous:AddSpy(self.Baziel.MechRef.Ravenous)
	self.Baziel.Triggers.RavenousRem = KBM.Trigger:Create(self.Lang.Debuff.RavenousID, "playerIDBuffRemove", self.Baziel)
	self.Baziel.Triggers.RavenousRem:AddStop(self.Baziel.MechRef.Ravenous)

	self.Kain.Triggers.Foul = KBM.Trigger:Create(self.Lang.Ability.Foul[KBM.Lang], "cast", self.Kain)
	self.Kain.Triggers.Foul:AddAlert(self.Kain.AlertsRef.Foul)
	self.Kain.Triggers.Voracious = KBM.Trigger:Create(self.Lang.Debuff.VoraciousID, "playerIDBuff", self.Kain)
	self.Kain.Triggers.Voracious:AddSpy(self.Kain.MechRef.Voracious)
	self.Kain.Triggers.VoraciousRem = KBM.Trigger:Create(self.Lang.Debuff.VoraciousID, "playerIDBuffRemove", self.Kain)
	self.Kain.Triggers.VoraciousRem:AddStop(self.Kain.MechRef.Voracious)
	
	self.Zathral.CastBar = KBM.CastBar:Add(self, self.Zathral)
	self.Baziel.CastBar = KBM.CastBar:Add(self, self.Baziel)
	self.Kain.CastBar = KBM.CastBar:Add(self, self.Kain)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end