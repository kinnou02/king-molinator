-- Och and Krok Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMCRONSLQGOK_Settings = nil
chKBMCRONSLQGOK_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local QG = KBM.BossMod["CRONQueens_Gambit"]

local OK = {
	Enabled = true,
	Directory = QG.Directory,
	File = "Och_and_Krok.lua",
	Instance = QG.Name,
	InstanceObj = QG,
	HasPhases = true,
	Lang = {},
	ID = "CRONOch_Krok",
	Object = "OK",
	--Enrage = 7 * 60,
}

KBM.RegisterMod(OK.ID, OK)

-- Main Unit Dictionary
OK.Lang.Unit = {}
OK.Lang.Unit.Och = KBM.Language:Add("Och")
OK.Lang.Unit.Krok = KBM.Language:Add("Krok")

-- Ability Dictionary
OK.Lang.Ability = {}

-- Debuff Dictionary
OK.Lang.Debuff = {}

-- Verbose Dictionary
OK.Lang.Verbose = {}

-- Description Dictionary
OK.Lang.Main = {}
OK.Lang.Main.Descript = KBM.Language:Add("Och and Krok")
OK.Descript = OK.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
OK.Och = {
	Mod = OK,
	Level = "??",
	Active = false,
	Name = OK.Lang.Unit.Och[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U69BCE23255919589",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	--TimersRef = {},
	--AlertsRef = {},
	--MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

OK.Krok = {
	Mod = OK,
	Level = "??",
	Active = false,
	Name = OK.Lang.Unit.Krok[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U2984058303D59680",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	--TimersRef = {},
	--AlertsRef = {},
	--MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

function OK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Och.Name] = self.Och,
		[self.Krok.Name] = self.Krok,
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

function OK:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Multi = true,
			Override = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		--Alerts = KBM.Defaults.Alerts(),
		--MechSpy = KBM.Defaults.MechSpy(),
		--MechTimer = KBM.Defaults.MechTimer(),
		Och = {
			CastBar = self.Och.Settings.CastBar,
		},
		Krok = {
			CastBar = self.Krok.Settings.CastBar,
		},
	}
	KBMCRONSLQGOK_Settings = self.Settings
	chKBMCRONSLQGOK_Settings = self.Settings	
end

function OK:SwapSettings(bool)
	if bool then
		KBMCRONSLQGOK_Settings = self.Settings
		self.Settings = chKBMCRONSLQGOK_Settings
	else
		chKBMCRONSLQGOK_Settings = self.Settings
		self.Settings = KBMCRONSLQGOK_Settings
	end
end

function OK:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMCRONSLQGOK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMCRONSLQGOK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMCRONSLQGOK_Settings = self.Settings
	else
		KBMCRONSLQGOK_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function OK:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMCRONSLQGOK_Settings = self.Settings
	else
		KBMCRONSLQGOK_Settings = self.Settings
	end	
end

function OK:Castbar(units)
end

function OK:RemoveUnits(UnitID)
	if self.Och.UnitID == UnitID then
		self.Och.Available = false
		return true
	end
	return false
end

function OK:Death(UnitID)
	if self.Och.UnitID == UnitID then
		self.Och.Dead = true
		if self.Krok.Dead then
			return true
		end
	elseif self.Krok.UnitID == UnitID then
		self.Krok.Dead = true
		if self.Och.Dead then
			return true
		end
	end
	return false
end

function OK:UnitHPCheck(uDetails, unitID)	
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
					self.PhaseObj.Objectives:AddPercent(self.Och, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Krok, 0, 100)
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

function OK:Reset()
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

function OK:Timer()	
end

function OK:Start()
	-- Create Timers
	
	-- Create Alerts
	
	-- Create Spies
	
	-- Assign Alerts and Timers to Triggers
	
	self.PercentageMon = KBM.PercentageMon:Create(self.Och, self.Krok, 7)
	self.Och.CastBar = KBM.Castbar:Add(self, self.Och)
	self.Krok.CastBar = KBM.Castbar:Add(self, self.Krok)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end