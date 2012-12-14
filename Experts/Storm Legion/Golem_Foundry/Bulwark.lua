-- Locomotive Bulwark Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXGFLBW_Settings = nil
chKBMSLEXGFLBW_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EGolem_Foundry"]

local MOD = {
	Directory = Instance.Directory,
	File = "Bulwark.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Bulwark",
	Object = "MOD",
}

MOD.Bulwark = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Locomotive Bulwark",
	NameShort = "Bulwark",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFCC32C972DF166D0",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Bulwark = KBM.Language:Add(MOD.Bulwark.Name)
MOD.Lang.Unit.Bulwark:SetGerman("Mobiles Bollwerk")
MOD.Lang.Unit.Bulwark:SetFrench("Rempart locomoteur")
MOD.Bulwark.Name = MOD.Lang.Unit.Bulwark[KBM.Lang]
MOD.Descript = MOD.Bulwark.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Bulwark")
MOD.Lang.Unit.AndShort:SetGerman("Bollwerk")
MOD.Lang.Unit.AndShort:SetFrench("Rempart")
MOD.Bulwark.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Bulwark.Name] = self.Bulwark,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Bulwark.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Bulwark.Settings.TimersRef,
		-- AlertsRef = self.Bulwark.Settings.AlertsRef,
	}
	KBMSLEXGFLBW_Settings = self.Settings
	chKBMSLEXGFLBW_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXGFLBW_Settings = self.Settings
		self.Settings = chKBMSLEXGFLBW_Settings
	else
		chKBMSLEXGFLBW_Settings = self.Settings
		self.Settings = KBMSLEXGFLBW_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXGFLBW_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXGFLBW_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXGFLBW_Settings = self.Settings
	else
		KBMSLEXGFLBW_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXGFLBW_Settings = self.Settings
	else
		KBMSLEXGFLBW_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Bulwark.UnitID == UnitID then
		self.Bulwark.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Bulwark.UnitID == UnitID then
		self.Bulwark.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Bulwark.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Bulwark.Dead = false
				self.Bulwark.Casting = false
				self.Bulwark.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Bulwark.Name, 0, 100)
				self.Phase = 1
			end
			self.Bulwark.UnitID = unitID
			self.Bulwark.Available = true
			return self.Bulwark
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Bulwark.Available = false
	self.Bulwark.UnitID = nil
	self.Bulwark.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Bulwark, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Bulwark)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Bulwark)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Bulwark.CastBar = KBM.CastBar:Add(self, self.Bulwark)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end