-- Subversionary Liaz Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMGFSL_Settings = nil
chKBMSLNMGFSL_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Golem Foundry"]

local MOD = {
	Directory = Instance.Directory,
	File = "Liaz.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Liaz",
	Object = "MOD",
}

MOD.Liaz = {
	Mod = MOD,
	Level = "57",
	Active = false,
	Name = "Subversionary Liaz",
	NameShort = "Liaz",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFCD9484316D15BB6",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Liaz = KBM.Language:Add(MOD.Liaz.Name)
MOD.Lang.Unit.Liaz:SetGerman("Liaz der Umstürzler")
MOD.Liaz.Name = MOD.Lang.Unit.Liaz[KBM.Lang]
MOD.Descript = MOD.Liaz.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Liaz")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Liaz.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Liaz.Name] = self.Liaz,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Liaz.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Liaz.Settings.TimersRef,
		-- AlertsRef = self.Liaz.Settings.AlertsRef,
	}
	KBMSLNMGFSL_Settings = self.Settings
	chKBMSLNMGFSL_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMGFSL_Settings = self.Settings
		self.Settings = chKBMSLNMGFSL_Settings
	else
		chKBMSLNMGFSL_Settings = self.Settings
		self.Settings = KBMSLNMGFSL_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMGFSL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMGFSL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMGFSL_Settings = self.Settings
	else
		KBMSLNMGFSL_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMGFSL_Settings = self.Settings
	else
		KBMSLNMGFSL_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Liaz.UnitID == UnitID then
		self.Liaz.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Liaz.UnitID == UnitID then
		self.Liaz.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Liaz.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Liaz.Dead = false
					self.Liaz.Casting = false
					self.Liaz.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Liaz.Name, 0, 100)
					self.Phase = 1
				end
				self.Liaz.UnitID = unitID
				self.Liaz.Available = true
				return self.Liaz
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Liaz.Available = false
	self.Liaz.UnitID = nil
	self.Liaz.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Liaz, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Liaz)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Liaz)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Liaz.CastBar = KBM.CastBar:Add(self, self.Liaz)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end