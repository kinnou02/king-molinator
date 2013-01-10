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
KR.Lang.Unit.KainShort = KBM.Language:Add("Kain")
KR.Lang.Unit.KainShort:SetGerman("Kain")

-- Ability Dictionary
KR.Lang.Ability = {}

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
	UTID = "none",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

function KR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kain.Name] = self.Kain,
	}
end

function KR:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kain.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Kain.Settings.TimersRef,
		-- AlertsRef = self.Kain.Settings.AlertsRef,
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
					if BossObj.Name == self.Kain.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Kain, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Kain.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Kain
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
	end
	self.Kain.CastBar:Remove()	
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
	-- KBM.Defaults.AlertObj.Assign(self.Kain)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Kain.CastBar = KBM.CastBar:Add(self, self.Kain)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end