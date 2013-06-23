-- Manslaughter Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXGFMS_Settings = nil
chKBMSLEXGFMS_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EGolem_Foundry"]

local MOD = {
	Directory = Instance.Directory,
	File = "Manslaughter.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Manslaughter",
	Object = "MOD",
}

MOD.Manslaughter = {
	Mod = MOD,
	Level = "57",
	Active = false,
	Name = "Manslaughter",
	NameShort = "Manslaughter",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFC4782BE11129B57",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Manslaughter = KBM.Language:Add(MOD.Manslaughter.Name)
MOD.Lang.Unit.Manslaughter:SetGerman("Totschlag")
MOD.Lang.Unit.Manslaughter:SetFrench("Massacre")
MOD.Manslaughter.Name = MOD.Lang.Unit.Manslaughter[KBM.Lang]
MOD.Descript = MOD.Manslaughter.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Manslaughter")
MOD.Lang.Unit.AndShort:SetGerman("Totschlag")
MOD.Lang.Unit.AndShort:SetFrench("Massacre")
MOD.Manslaughter.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Manslaughter.Name] = self.Manslaughter,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Manslaughter.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Manslaughter.Settings.TimersRef,
		-- AlertsRef = self.Manslaughter.Settings.AlertsRef,
	}
	KBMSLEXGFMS_Settings = self.Settings
	chKBMSLEXGFMS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXGFMS_Settings = self.Settings
		self.Settings = chKBMSLEXGFMS_Settings
	else
		chKBMSLEXGFMS_Settings = self.Settings
		self.Settings = KBMSLEXGFMS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXGFMS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXGFMS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXGFMS_Settings = self.Settings
	else
		KBMSLEXGFMS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXGFMS_Settings = self.Settings
	else
		KBMSLEXGFMS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Manslaughter.UnitID == UnitID then
		self.Manslaughter.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Manslaughter.UnitID == UnitID then
		self.Manslaughter.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Manslaughter.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Manslaughter.Dead = false
				self.Manslaughter.Casting = false
				self.Manslaughter.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Manslaughter.Name, 0, 100)
				self.Phase = 1
			end
			self.Manslaughter.UnitID = unitID
			self.Manslaughter.Available = true
			return self.Manslaughter
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Manslaughter.Available = false
	self.Manslaughter.UnitID = nil
	self.Manslaughter.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Manslaughter)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Manslaughter)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Manslaughter.CastBar = KBM.CastBar:Add(self, self.Manslaughter)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end