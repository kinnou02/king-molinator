-- Bruzhail Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMUBFBRZ_Settings = nil
chKBMSLNMUBFBRZ_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Unhallowed Boneforge"]

local MOD = {
	Directory = Instance.Directory,
	File = "Bruzhail.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Bruzhail",
	Object = "MOD",
}

MOD.Bruzhail = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Bruzhail the Black Chariot",
	NameShort = "Bruzhail",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U21674AA91A8728DA",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Bruzhail = KBM.Language:Add(MOD.Bruzhail.Name)
MOD.Lang.Unit.Bruzhail:SetGerman("Bruzhail der Schwarze Streitwagen")
MOD.Bruzhail.Name = MOD.Lang.Unit.Bruzhail[KBM.Lang]
MOD.Descript = MOD.Bruzhail.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Bruzhail")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Bruzhail.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Bruzhail.Name] = self.Bruzhail,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Bruzhail.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Bruzhail.Settings.TimersRef,
		-- AlertsRef = self.Bruzhail.Settings.AlertsRef,
	}
	KBMSLNMUBFBRZ_Settings = self.Settings
	chKBMSLNMUBFBRZ_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMUBFBRZ_Settings = self.Settings
		self.Settings = chKBMSLNMUBFBRZ_Settings
	else
		chKBMSLNMUBFBRZ_Settings = self.Settings
		self.Settings = KBMSLNMUBFBRZ_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMUBFBRZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMUBFBRZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMUBFBRZ_Settings = self.Settings
	else
		KBMSLNMUBFBRZ_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMUBFBRZ_Settings = self.Settings
	else
		KBMSLNMUBFBRZ_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Bruzhail.UnitID == UnitID then
		self.Bruzhail.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Bruzhail.UnitID == UnitID then
		self.Bruzhail.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				BossObj.CastBar:Create(unitID)
				BossObj.UnitID = unitID
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Bruzhail, 0, 100)
				self.Phase = 1
			else
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Bruzhail.Available = false
	self.Bruzhail.UnitID = nil
	self.Bruzhail.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Bruzhail)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Bruzhail)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Bruzhail.CastBar = KBM.CastBar:Add(self, self.Bruzhail)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end