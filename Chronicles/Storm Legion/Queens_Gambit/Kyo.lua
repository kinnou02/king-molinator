-- Abido Kyo Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMCRONSLQGAK_Settings = nil
chKBMCRONSLQGAK_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local QG = KBM.BossMod["CRONQueens_Gambit"]

local AK = {
	Enabled = true,
	Directory = QG.Directory,
	File = "Kyo.lua",
	Instance = QG.Name,
	InstanceObj = QG,
	HasPhases = true,
	Lang = {},
	ID = "CRONQGAbido_Kyo",
	Object = "AK",
	Enrage = nil,
}

KBM.RegisterMod(AK.ID, AK)

-- Main Unit Dictionary
AK.Lang.Unit = {}
AK.Lang.Unit.Kyo = KBM.Language:Add("Abido Kyo")

-- Ability Dictionary
AK.Lang.Ability = {}
AK.Lang.Ability.Whirl = KBM.Language:Add("Steel Whirl")
AK.Lang.Ability.Blast = KBM.Language:Add("Shock Blast")

-- Debuff Dictionary
AK.Lang.Debuff = {}

-- Verbose Dictionary
AK.Lang.Verbose = {}

-- Description Dictionary
AK.Lang.Main = {}
AK.Lang.Main.Descript = KBM.Language:Add("Abido Kyo")
AK.Descript = AK.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
AK.Kyo = {
	Mod = AK,
	Level = "??",
	Active = false,
	Name = AK.Lang.Unit.Kyo[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U1212ABA54090C109",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	--MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Whirl = KBM.Defaults.AlertObj.Create("red"),
			Blast = KBM.Defaults.AlertObj.Create("blue"),
		},
		TimersRef = {
			Enabled = true,
			Whirl = KBM.Defaults.TimerObj.Create("red"),
		},
	}
}

function AK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kyo.Name] = self.Kyo,
	}
end

function AK:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kyo.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		--MechSpy = KBM.Defaults.MechSpy(),
		MechTimer = KBM.Defaults.MechTimer(),
		AlertsRef = self.Kyo.Settings.AlertsRef,
		TimersRef = self.Kyo.Settings.TimersRef,
	}
	KBMCRONSLQGAK_Settings = self.Settings
	chKBMCRONSLQGAK_Settings = self.Settings	
end

function AK:SwapSettings(bool)
	if bool then
		KBMCRONSLQGAK_Settings = self.Settings
		self.Settings = chKBMCRONSLQGAK_Settings
	else
		chKBMCRONSLQGAK_Settings = self.Settings
		self.Settings = KBMCRONSLQGAK_Settings
	end
end

function AK:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMCRONSLQGAK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMCRONSLQGAK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMCRONSLQGAK_Settings = self.Settings
	else
		KBMCRONSLQGAK_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function AK:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMCRONSLQGAK_Settings = self.Settings
	else
		KBMCRONSLQGAK_Settings = self.Settings
	end	
end

function AK:Castbar(units)
end

function AK:RemoveUnits(UnitID)
	if self.Kyo.UnitID == UnitID then
		self.Kyo.Available = false
		return true
	end
	return false
end

function AK:Death(UnitID)
	if self.Kyo.UnitID == UnitID then
		self.Kyo.Dead = true
		if self.Krok.Dead then
			return true
		end
	elseif self.Krok.UnitID == UnitID then
		self.Krok.Dead = true
		if self.Kyo.Dead then
			return true
		end
	end
	return false
end

function AK:UnitHPCheck(uDetails, unitID)	
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
					self.PhaseObj.Objectives:AddPercent(self.Kyo, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.CastBar then
						if BossObj.UnitID ~= unitID then
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
end

function AK:Reset()
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

function AK:Timer()	
end

function AK:Start()
	-- Create Timers
	self.Kyo.TimersRef.Whirl = KBM.MechTimer:Add(self.Lang.Ability.Whirl[KBM.Lang], 15)
	KBM.Defaults.TimerObj.Assign(self.Kyo)
	
	-- Create Alerts
	self.Kyo.AlertsRef.Whirl = KBM.Alert:Create(self.Lang.Ability.Whirl[KBM.Lang], nil, false, true, "red")
	self.Kyo.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], nil, false, true, "blue")
	KBM.Defaults.AlertObj.Assign(self.Kyo)
	
	-- Create Spies
	
	-- Assign Alerts and Timers to Triggers
	self.Kyo.Triggers.Whirl = KBM.Trigger:Create(self.Lang.Ability.Whirl[KBM.Lang], "channel", self.Kyo)
	self.Kyo.Triggers.Whirl:AddAlert(self.Kyo.AlertsRef.Whirl)
	self.Kyo.Triggers.Blast_Warn = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "cast", self.Kyo)
	self.Kyo.Triggers.Blast_Warn:AddAlert(self.Kyo.AlertsRef.Blast)
	self.Kyo.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "channel", self.Kyo)
	self.Kyo.Triggers.Blast:AddAlert(self.Kyo.AlertsRef.Blast)
	
	self.Kyo.CastBar = KBM.CastBar:Add(self, self.Kyo)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end