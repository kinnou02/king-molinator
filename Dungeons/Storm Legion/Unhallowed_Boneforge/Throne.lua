-- Necrotic Throne Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMUBFNCT_Settings = nil
chKBMSLNMUBFNCT_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Unhallowed Boneforge"]

local MOD = {
	Directory = Instance.Directory,
	File = "Throne.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Throne",
	Object = "MOD",
}

MOD.Throne = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Necrotic Throne",
	NameShort = "Throne",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "none",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Throne = KBM.Language:Add(MOD.Throne.Name)
MOD.Lang.Unit.Throne:SetGerman("Nekrotischer Thron")
MOD.Throne.Name = MOD.Lang.Unit.Throne[KBM.Lang]
MOD.Descript = MOD.Throne.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Throne")
MOD.Lang.Unit.AndShort:SetGerman("Thron")
MOD.Throne.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Throne.Name] = self.Throne,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Throne.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Throne.Settings.TimersRef,
		-- AlertsRef = self.Throne.Settings.AlertsRef,
	}
	KBMSLNMUBFNCT_Settings = self.Settings
	chKBMSLNMUBFNCT_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMUBFNCT_Settings = self.Settings
		self.Settings = chKBMSLNMUBFNCT_Settings
	else
		chKBMSLNMUBFNCT_Settings = self.Settings
		self.Settings = KBMSLNMUBFNCT_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMUBFNCT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMUBFNCT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMUBFNCT_Settings = self.Settings
	else
		KBMSLNMUBFNCT_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMUBFNCT_Settings = self.Settings
	else
		KBMSLNMUBFNCT_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Throne.UnitID == UnitID then
		self.Throne.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Throne.UnitID == UnitID then
		self.Throne.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Throne.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Throne.Dead = false
					self.Throne.Casting = false
					self.Throne.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Throne.Name, 0, 100)
					self.Phase = 1
				end
				self.Throne.UnitID = unitID
				self.Throne.Available = true
				return self.Throne
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Throne.Available = false
	self.Throne.UnitID = nil
	self.Throne.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Throne, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Throne)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Throne)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Throne.CastBar = KBM.CastBar:Add(self, self.Throne)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end