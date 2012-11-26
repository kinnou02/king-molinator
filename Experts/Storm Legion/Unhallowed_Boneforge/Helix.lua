-- Forgelord Helix Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXUBFFLH_Settings = nil
chKBMSLEXUBFFLH_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EUnhallowed_Boneforge"]

local MOD = {
	Directory = Instance.Directory,
	File = "Helix.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Helix",
	Object = "MOD",
}

MOD.Helix = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Forgelord Helix",
	NameShort = "Helix",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U5605DC34626585B9",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Helix = KBM.Language:Add(MOD.Helix.Name)
MOD.Lang.Unit.Helix:SetGerman("Schmiedefürst Helix")
MOD.Helix.Name = MOD.Lang.Unit.Helix[KBM.Lang]
MOD.Descript = MOD.Helix.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Helix")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Helix.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Helix.Name] = self.Helix,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Helix.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Helix.Settings.TimersRef,
		-- AlertsRef = self.Helix.Settings.AlertsRef,
	}
	KBMSLEXUBFFLH_Settings = self.Settings
	chKBMSLEXUBFFLH_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXUBFFLH_Settings = self.Settings
		self.Settings = chKBMSLEXUBFFLH_Settings
	else
		chKBMSLEXUBFFLH_Settings = self.Settings
		self.Settings = KBMSLEXUBFFLH_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXUBFFLH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXUBFFLH_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXUBFFLH_Settings = self.Settings
	else
		KBMSLEXUBFFLH_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXUBFFLH_Settings = self.Settings
	else
		KBMSLEXUBFFLH_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Helix.UnitID == UnitID then
		self.Helix.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Helix.UnitID == UnitID then
		self.Helix.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Helix.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Helix.Dead = false
				self.Helix.Casting = false
				self.Helix.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Helix.Name, 0, 100)
				self.Phase = 1
			end
			self.Helix.UnitID = unitID
			self.Helix.Available = true
			return self.Helix
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Helix.Available = false
	self.Helix.UnitID = nil
	self.Helix.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Helix, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Helix)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Helix)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Helix.CastBar = KBM.CastBar:Add(self, self.Helix)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end