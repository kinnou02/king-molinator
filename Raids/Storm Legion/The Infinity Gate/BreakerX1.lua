-- Breaker X-1 "Onyx" Boss Mod for King Boss Mods
-- Written by Ivnedar
-- Copyright 2013
--

KBMSLRDIGBX_Settings = nil
chKBMSLRDIGBX_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IG = KBM.BossMod["RInfinity_Gate"]

local BXO = {
	Enabled = true,
	Directory = IG.Directory,
	File = "BreakerX1.lua",
	Instance = IG.Name,
	InstanceObj = IG,
	HasPhases = true,
	Lang = {},
	ID = "BreakerX1",
	Object = "BXO",
	Enrage = 9 * 60,
}

KBM.RegisterMod(BXO.ID, BXO)

-- Main Unit Dictionary
BXO.Lang.Unit = {}
BXO.Lang.Unit.BreakerX1 = KBM.Language:Add("Breaker X-1 \"Onyx\"") -- U4EA7C88766C1B6B9
BXO.Lang.Unit.CoreAlpha = KBM.Language:Add("Core Systems Routine Alpha") -- U01D9CC8C1FF2D603
BXO.Lang.Unit.Colossus = KBM.Language:Add("Irradiated Colossus") -- U44B144E14DCEBE34


-- Ability Dictionary
BXO.Lang.Ability = {}

-- Description Dictionary
BXO.Lang.Main = {}

-- Debuff Dictionary
BXO.Lang.Debuff = {}

-- Messages Dictionary
BXO.Lang.Messages = {}

BXO.Descript = BXO.Lang.Unit.BreakerX1[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
BXO.BreakerX1 = {
	Mod = BXO,
	Level = "??",
	Active = false,
	Name = BXO.Lang.Unit.BreakerX1[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U4EA7C88766C1B6B9",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

function BXO:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.BreakerX1.Name] = self.BreakerX1,
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

function BXO:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		BreakerX1 = {
			CastBar = self.BreakerX1.Settings.CastBar,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMSLRDIGBX_Settings = self.Settings
	chKBMSLRDIGBX_Settings = self.Settings
	
end

function BXO:SwapSettings(bool)

	if bool then
		KBMSLRDIGBX_Settings = self.Settings
		self.Settings = chKBMSLRDIGBX_Settings
	else
		chKBMSLRDIGBX_Settings = self.Settings
		self.Settings = KBMSLRDIGBX_Settings
	end

end

function BXO:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDIGBX_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDIGBX_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDIGBX_Settings = self.Settings
	else
		KBMSLRDIGBX_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function BXO:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDIGBX_Settings = self.Settings
	else
		KBMSLRDIGBX_Settings = self.Settings
	end	
end

function BXO:Castbar(units)
end

function BXO:RemoveUnits(UnitID)
	if self.BreakerX1.UnitID == UnitID then
		self.BreakerX1.Available = false
		return true
	end
	return false
end

function BXO:Death(UnitID)
	if self.BreakerX1.UnitID == UnitID then
		self.BreakerX1.Dead = true
		return true
	end
	return false
end

function BXO:UnitHPCheck(uDetails, unitID)	
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
				self.PhaseObj.Objectives:AddPercent(self.BreakerX1, 0, 100)
				self.Phase = 1
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

function BXO:Reset()
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

function BXO:Timer()	
end

function BXO:DefineMenu()
	self.Menu = IG.Menu:CreateEncounter(self.BreakerX1, self.Enabled)
end

function BXO:Start()
	-- Create Timers
	
	-- Create Alerts

	-- Create Mechanic Spies (BreakerX1)

	-- Assign Alerts and Timers to Triggers
	
	self.BreakerX1.CastBar = KBM.Castbar:Add(self, self.BreakerX1)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end