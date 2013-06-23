-- Kyzan Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLSLGAKZ_Settings = nil
chKBMSLSLGAKZ_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local GA = KBM.BossMod["SGrim_Awakening"]

local KZ = {
	Directory = GA.Directory,
	File = "Kyzan.lua",
	Enabled = true,
	Instance = GA.Name,
	InstanceObj = GA,
	Lang = {},
	Enrage = 6 * 60,
	ID = "SKyzan",
	Object = "KZ",
}

KBM.RegisterMod(KZ.ID, KZ)

-- Main Unit Dictionary
KZ.Lang.Unit = {}
KZ.Lang.Unit.Kyzan = KBM.Language:Add("Kyzan")

-- Ability Dictionary
KZ.Lang.Ability = {}
KZ.Lang.Ability.Annihilation = KBM.Language:Add("Delayed Annihilation")

-- Verbose Dictionary
KZ.Lang.Verbose = {}

-- Buff Dictionary
KZ.Lang.Buff = {}
KZ.Lang.Buff.Growth = KBM.Language:Add("Abhorrent Growth")
KZ.Lang.Buff.GrowthID = "B71EFD1E7E16B7029"

-- Debuff Dictionary
KZ.Lang.Debuff = {}
KZ.Lang.Debuff.Rending = KBM.Language:Add("Rending Slice")
KZ.Lang.Debuff.RendingID = "B222A8C2D75DD0233"
KZ.Lang.Debuff.Leech = KBM.Language:Add("Soul Leech")
KZ.Lang.Debuff.LeechID = "BFFF2E05144BCABF1"
KZ.Lang.Debuff.Delayed = KBM.Language:Add("Delayed Annihilation")
KZ.Lang.Debuff.DelayedID = "BFFE5A18279825D02"
KZ.Lang.Debuff.Harvest = KBM.Language:Add("Bone Harvest")
KZ.Lang.Debuff.HarvestID = "B5B66DE15D863A53D"
KZ.Lang.Debuff.Phase = KBM.Language:Add("Phase Rip")
KZ.Lang.Debuff.PhaseID = "B66EB09DD08948BC5"

-- Description Dictionary
KZ.Lang.Main = {}

KZ.Descript = KZ.Lang.Unit.Kyzan[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
KZ.Kyzan = {
	Mod = KZ,
	Level = "??",
	Active = false,
	Name = KZ.Lang.Unit.Kyzan[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U33C180C326727959",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Annihilation = KBM.Defaults.TimerObj.Create("cyan"),
		--	BeaconFirst = KBM.Defaults.TimerObj.Create("red"),
		--	Beacon = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Annihilation = KBM.Defaults.AlertObj.Create("cyan"),
		--	Shatter = KBM.Defaults.AlertObj.Create("yellow"),
		},
		MechRef = {
			Enabled = true,
			Harvest = KBM.Defaults.MechObj.Create("dark_green"),
			Growth = KBM.Defaults.MechObj.Create("yellow"),
			Leech = KBM.Defaults.MechObj.Create("purple"),
			Phase = KBM.Defaults.MechObj.Create("pink"),
		},
	}
}


function KZ:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kyzan.Name] = self.Kyzan,
	}
end

function KZ:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kyzan.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		TimersRef = self.Kyzan.Settings.TimersRef,
		AlertsRef = self.Kyzan.Settings.AlertsRef,
		MechRef = self.Kyzan.Settings.MechRef,
	}
	KBMSLSLGAKZ_Settings = self.Settings
	chKBMSLSLGAKZ_Settings = self.Settings
	
end

function KZ:SwapSettings(bool)

	if bool then
		KBMSLSLGAKZ_Settings = self.Settings
		self.Settings = chKBMSLSLGAKZ_Settings
	else
		chKBMSLSLGAKZ_Settings = self.Settings
		self.Settings = KBMSLSLGAKZ_Settings
	end

end

function KZ:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLSLGAKZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLSLGAKZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLSLGAKZ_Settings = self.Settings
	else
		KBMSLSLGAKZ_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function KZ:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLSLGAKZ_Settings = self.Settings
	else
		KBMSLSLGAKZ_Settings = self.Settings
	end	
end

function KZ:Castbar(units)
end

function KZ:RemoveUnits(UnitID)
	if self.Kyzan.UnitID == UnitID then
		self.Kyzan.Available = false
		return true
	end
	return false
end

function KZ:Death(UnitID)
	if self.Kyzan.UnitID == UnitID then
		self.Kyzan.Dead = true
		return true
	end
	return false
end

function KZ:UnitHPCheck(uDetails, unitID)	
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
				if BossObj == self.Kyzan then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Kyzan, 0, 100)
				self.Phase = 1
				if BossObj == self.Kyzan then
					local DebuffTable = {
						[1] = self.Lang.Debuff.RendingID,
						[2] = self.Lang.Debuff.LeechID,
					}
					KBM.TankSwap:Start(DebuffTable, unitID, 2)
				end
			else
				if BossObj == self.Kyzan then
					if not KBM.TankSwap.Active then
						local DebuffTable = {
							[1] = self.Lang.Debuff.RendingID,
							[2] = self.Lang.Debuff.LeechID,
						}
						KBM.TankSwap:Start(DebuffTable, unitID, 2)
					end
				end
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					if BossObj == self.Kyzan then
						BossObj.CastBar:Remove()
						BossObj.CastBar:Create(unitID)
					end
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function KZ:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Kyzan.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function KZ:Timer()	
end

function KZ:DefineMenu()
	self.Menu = GA.Menu:CreateEncounter(self.Kyzan, self.Enabled)
end

function KZ:Start()

	-- Create Timers
	self.Kyzan.TimersRef.Annihilation = KBM.MechTimer:Add(self.Lang.Ability.Annihilation[KBM.Lang], 25, false)
	self.Kyzan.TimersRef.Annihilation:Wait()
	--self.Kyzan.TimersRef.Shatter = KBM.MechTimer:Add(self.Lang.Debuff.Shatter[KBM.Lang], 25)
	KBM.Defaults.TimerObj.Assign(self.Kyzan)
	
	-- Create Alerts
	self.Kyzan.AlertsRef.Annihilation = KBM.Alert:Create(self.Lang.Ability.Annihilation[KBM.Lang], nil, false, true, "cyan")
	--self.Kyzan.AlertsRef.Gaze:Important()
	--self.Kyzan.AlertsRef.Shatter = KBM.Alert:Create(self.Lang.Debuff.Shatter[KBM.Lang], nil, false, true, "yellow")
	--self.Kyzan.AlertsRef.Shatter:Important()
	KBM.Defaults.AlertObj.Assign(self.Kyzan)

	-- Create Spies
	self.Kyzan.MechRef.Harvest = KBM.MechSpy:Add(self.Lang.Debuff.Harvest[KBM.Lang], nil, "playerDebuff", self.Kyzan)
	self.Kyzan.MechRef.Leech = KBM.MechSpy:Add(self.Lang.Debuff.Leech[KBM.Lang], nil, "playerDebuff", self.Kyzan)
	self.Kyzan.MechRef.Phase = KBM.MechSpy:Add(self.Lang.Debuff.Phase[KBM.Lang], nil, "playerDebuff", self.Kyzan)
	self.Kyzan.MechRef.Growth = KBM.MechSpy:Add(self.Lang.Buff.Growth[KBM.Lang], nil, "buff", self.Kyzan)
	KBM.Defaults.MechObj.Assign(self.Kyzan)

	-- Assign Alerts and Timers to Triggers
	self.Kyzan.Triggers.Harvest = KBM.Trigger:Create(self.Lang.Debuff.HarvestID, "playerIDBuff", self.Kyzan)
	self.Kyzan.Triggers.Harvest:AddSpy(self.Kyzan.MechRef.Harvest)

	self.Kyzan.Triggers.Leech = KBM.Trigger:Create(self.Lang.Debuff.LeechID, "playerIDBuff", self.Kyzan)
	self.Kyzan.Triggers.Leech:AddSpy(self.Kyzan.MechRef.Leech)

	self.Kyzan.Triggers.Phase = KBM.Trigger:Create(self.Lang.Debuff.PhaseID, "playerIDBuff", self.Kyzan)
	self.Kyzan.Triggers.Phase:AddSpy(self.Kyzan.MechRef.Phase)

	self.Kyzan.Triggers.Growth = KBM.Trigger:Create(self.Lang.Buff.Growth[KBM.Lang], "buff", self.Kyzan)
	self.Kyzan.Triggers.Growth:AddSpy(self.Kyzan.MechRef.Growth)

	self.Kyzan.Triggers.Annihilation = KBM.Trigger:Create(self.Lang.Ability.Annihilation[KBM.Lang], "cast", self.Kyzan)
	self.Kyzan.Triggers.Annihilation:AddTimer(self.Kyzan.TimersRef.Annihilation)
	self.Kyzan.Triggers.Annihilation:AddAlert(self.Kyzan.AlertsRef.Annihilation)
	
	self.Kyzan.CastBar = KBM.CastBar:Add(self, self.Kyzan)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end