-- General Grim Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMSQGG_Settings = nil
chKBMSLNMSQGG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Exodus of the Storm Queen"]

local MOD = {
	Directory = Instance.Directory,
	File = "Grim.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Grim",
	Object = "MOD",
}

MOD.Grim = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "General Grim",
	NameShort = "Grim",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFD5A45964C9F14C7",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Grim = KBM.Language:Add(MOD.Grim.Name)
MOD.Lang.Unit.Grim:SetFrench("Général Grim")
MOD.Lang.Unit.Grim:SetGerman("General Grim")
MOD.Lang.Unit.GrimShort = KBM.Language:Add("Grim")
MOD.Lang.Unit.GrimShort:SetFrench()
MOD.Lang.Unit.GrimShort:SetGerman("Grim")

MOD.Grim.Name = MOD.Lang.Unit.Grim[KBM.Lang]
MOD.Grim.NameShort = MOD.Lang.Unit.GrimShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

MOD.Descript = MOD.Grim.Name

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Grim.Name] = self.Grim,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Grim.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Grim.Settings.TimersRef,
		-- AlertsRef = self.Grim.Settings.AlertsRef,
	}
	KBMSLNMSQGG_Settings = self.Settings
	chKBMSLNMSQGG_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMSQGG_Settings = self.Settings
		self.Settings = chKBMSLNMSQGG_Settings
	else
		chKBMSLNMSQGG_Settings = self.Settings
		self.Settings = KBMSLNMSQGG_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMSQGG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMSQGG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMSQGG_Settings = self.Settings
	else
		KBMSLNMSQGG_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMSQGG_Settings = self.Settings
	else
		KBMSLNMSQGG_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Grim.UnitID == UnitID then
		self.Grim.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Grim.UnitID == UnitID then
		self.Grim.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Grim.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Grim.Dead = false
					self.Grim.Casting = false
					self.Grim.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Grim.Name, 0, 100)
					self.Phase = 1
				end
				self.Grim.UnitID = unitID
				self.Grim.Available = true
				return self.Grim
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Grim.Available = false
	self.Grim.UnitID = nil
	self.Grim.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Grim)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Grim)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Grim.CastBar = KBM.CastBar:Add(self, self.Grim)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end