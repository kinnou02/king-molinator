-- Citybreaker Zidae Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXSBPCBZ_Settings = nil
chKBMSLEXSBPCBZ_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EStorm_Breaker_Protocol"]

local MOD = {
	Directory = Instance.Directory,
	File = "Zidae.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Zidae",
	Object = "MOD",
}

MOD.Zidae = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Citybreaker Zidae",
	NameShort = "Zidae",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFFE6ECC319528969",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Zidae = KBM.Language:Add(MOD.Zidae.Name)
MOD.Lang.Unit.Zidae:SetGerman("Stadtbrecher Zidae")
MOD.Lang.Unit.Zidae:SetFrench("Casseur Zidae")
MOD.Zidae.Name = MOD.Lang.Unit.Zidae[KBM.Lang]
MOD.Descript = MOD.Zidae.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Zidae")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Zidae.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Zidae.Name] = self.Zidae,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Zidae.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Zidae.Settings.TimersRef,
		-- AlertsRef = self.Zidae.Settings.AlertsRef,
	}
	KBMSLEXSBPCBZ_Settings = self.Settings
	chKBMSLEXSBPCBZ_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXSBPCBZ_Settings = self.Settings
		self.Settings = chKBMSLEXSBPCBZ_Settings
	else
		chKBMSLEXSBPCBZ_Settings = self.Settings
		self.Settings = KBMSLEXSBPCBZ_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXSBPCBZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXSBPCBZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXSBPCBZ_Settings = self.Settings
	else
		KBMSLEXSBPCBZ_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXSBPCBZ_Settings = self.Settings
	else
		KBMSLEXSBPCBZ_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Zidae.UnitID == UnitID then
		self.Zidae.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Zidae.UnitID == UnitID then
		self.Zidae.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.type == self.Zidae.UTID then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Zidae.Dead = false
					self.Zidae.Casting = false
					self.Zidae.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Zidae.Name, 0, 100)
					self.Phase = 1
				end
				self.Zidae.UnitID = unitID
				self.Zidae.Available = true
				return self.Zidae
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Zidae.Available = false
	self.Zidae.UnitID = nil
	self.Zidae.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Zidae)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Zidae)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Zidae.CastBar = KBM.Castbar:Add(self, self.Zidae)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end