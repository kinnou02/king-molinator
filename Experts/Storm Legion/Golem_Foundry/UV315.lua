-- UV-315 Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXGFUV_Settings = nil
chKBMSLEXGFUV_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EGolem_Foundry"]

local MOD = {
	Directory = Instance.Directory,
	File = "UV315.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_UV315",
	Object = "MOD",
}

MOD.UV315 = {
	Mod = MOD,
	Level = "57",
	Active = false,
	Name = "UV-315",
	NameShort = "UV-315",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFDC174785FD30DB7",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.UV315 = KBM.Language:Add(MOD.UV315.Name)
MOD.Lang.Unit.UV315:SetGerman()
MOD.Lang.Unit.UV315:SetFrench()
MOD.UV315.Name = MOD.Lang.Unit.UV315[KBM.Lang]
MOD.Descript = MOD.UV315.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("UV-315")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.UV315.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.UV315.Name] = self.UV315,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.UV315.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.UV315.Settings.TimersRef,
		-- AlertsRef = self.UV315.Settings.AlertsRef,
	}
	KBMSLEXGFUV_Settings = self.Settings
	chKBMSLEXGFUV_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXGFUV_Settings = self.Settings
		self.Settings = chKBMSLEXGFUV_Settings
	else
		chKBMSLEXGFUV_Settings = self.Settings
		self.Settings = KBMSLEXGFUV_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXGFUV_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXGFUV_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXGFUV_Settings = self.Settings
	else
		KBMSLEXGFUV_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXGFUV_Settings = self.Settings
	else
		KBMSLEXGFUV_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.UV315.UnitID == UnitID then
		self.UV315.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.UV315.UnitID == UnitID then
		self.UV315.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.UV315.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.UV315.Dead = false
				self.UV315.Casting = false
				self.UV315.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.UV315.Name, 0, 100)
				self.Phase = 1
			end
			self.UV315.UnitID = unitID
			self.UV315.Available = true
			return self.UV315
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.UV315.Available = false
	self.UV315.UnitID = nil
	self.UV315.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.UV315)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.UV315)
	
	-- Assign Alerts and Timers to Triggers
	
	self.UV315.CastBar = KBM.Castbar:Add(self, self.UV315)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end