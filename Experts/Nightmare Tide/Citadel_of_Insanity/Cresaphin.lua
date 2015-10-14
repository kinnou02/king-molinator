-- Cresaphin Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTCOICRE_Settings = nil
chKBMNTCOICRE_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Citadel_of_Insanity"]

local MOD = {
	Directory = Instance.Directory,
	File = "Cresaphin.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "COI_Cresaphin",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Cresaphin = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Cresaphin",
	--NameShort = "Cresaphin",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U14D690B76A2A28EA",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Cresaphin = KBM.Language:Add(MOD.Cresaphin.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Encasing = KBM.Language:Add("Encasing")
MOD.Lang.Ability.Encasing:SetFrench("Fermeture du piège")
MOD.Lang.Ability.Shield = KBM.Language:Add("Chitinous Shielding")
MOD.Lang.Ability.Shield:SetFrench("Protection chitineuse")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Cresaphin[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Cresaphin.Name] = self.Cresaphin,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Cresaphin.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		-- AlertsRef = self.Baird.Settings.AlertsRef,
	}
	KBMNTCOICRE_Settings = self.Settings
	chKBMNTCOICRE_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTCOICRE_Settings = self.Settings
		self.Settings = chKBMNTCOICRE_Settings
	else
		chKBMNTCOICRE_Settings = self.Settings
		self.Settings = KBMNTCOICRE_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTCOICRE_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTCOICRE_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTCOICRE_Settings = self.Settings
	else
		KBMNTCOICRE_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTCOICRE_Settings = self.Settings
	else
		KBMNTCOICRE_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Cresaphin.UnitID == UnitID then
		self.Cresaphin.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Cresaphin.UnitID == UnitID then
		self.Cresaphin.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Cresaphin.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Cresaphin.Dead = false
				self.Cresaphin.Casting = false
				self.Cresaphin.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Cresaphin, 0, 100)
				self.Phase = 1
			end
			self.Cresaphin.UnitID = unitID
			self.Cresaphin.Available = true
			return self.Cresaphin
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Cresaphin.Available = false
	self.Cresaphin.UnitID = nil
	self.Cresaphin.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Baird)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Cresaphin.CastBar = KBM.Castbar:Add(self, self.Cresaphin)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end