-- KING Krilladu Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRCKRI_Settings = nil
chKBMNTRCKRI_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Rhaza'de_Canyons"]

local MOD = {
	Directory = Instance.Directory,
	File = "Krilladu.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RC_Krilladu",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Krilladu = KBM.Language:Add("King Krilladu")
MOD.Lang.Unit.Krilladu:SetFrench("Krillado royal")
MOD.Lang.Unit.Minor = KBM.Language:Add("Krilladu Minor")
MOD.Lang.Unit.Minor:SetFrench("Krillado mineur")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Call = KBM.Language:Add("Call of the Swarm")
MOD.Lang.Ability.Call:SetFrench("Appel de l'essaim")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}


MOD.Krilladu = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Krilladu[KBM.Lang],
	--NameShort = "Krilladu",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U20E31BB634DE8CF9",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Call = KBM.Defaults.AlertObj.Create("red"),
			}
	}
}

MOD.Minor = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Minor[KBM.Lang],
	--NameShort = "Krilladu",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U0ED6700063665F02",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Krilladu[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Krilladu.Name] = self.Krilladu,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Krilladu.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Krilladu.Settings.TimersRef,
		AlertsRef = self.Krilladu.Settings.AlertsRef,
	}
	KBMNTRCKRI_Settings = self.Settings
	chKBMNTRCKRI_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRCKRI_Settings = self.Settings
		self.Settings = chKBMNTRCKRI_Settings
	else
		chKBMNTRCKRI_Settings = self.Settings
		self.Settings = KBMNTRCKRI_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRCKRI_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRCKRI_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRCKRI_Settings = self.Settings
	else
		KBMNTRCKRI_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRCKRI_Settings = self.Settings
	else
		KBMNTRCKRI_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Krilladu.UnitID == UnitID then
		self.Krilladu.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Krilladu.UnitID == UnitID then
		self.Krilladu.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Krilladu.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Krilladu.Dead = false
				self.Krilladu.Casting = false
				self.Krilladu.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Krilladu.Name, 0, 100)
				self.Phase = 1
			end
			self.Krilladu.UnitID = unitID
			self.Krilladu.Available = true
			return self.Krilladu
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Krilladu.Available = false
	self.Krilladu.UnitID = nil
	self.Krilladu.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Krilladu)
	
	-- Create Alerts
	self.Krilladu.AlertsRef.Call = KBM.Alert:Create(self.Lang.Ability.Call[KBM.Lang], nil, false, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Krilladu)
	
	-- Assign Alerts and Timers to Triggers
	self.Krilladu.Triggers.Call = KBM.Trigger:Create(self.Lang.Ability.Call[KBM.Lang], "cast", self.Krilladu)
	self.Krilladu.Triggers.Call:AddAlert(self.Krilladu.AlertsRef.Call)
	
	self.Krilladu.Triggers.CallStop = KBM.Trigger:Create(self.Lang.Ability.Call[KBM.Lang], "interrupt", self.Krilladu)
	self.Krilladu.Triggers.CallStop:AddStop(self.Krilladu.AlertsRef.Call)
	
	self.Krilladu.CastBar = KBM.Castbar:Add(self, self.Krilladu)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end