-- Bonelord Fetlorn Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRTITBF_Settings = nil
chKBMNTRTITBF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["RTIron_Tomb"]

local MOD = {
	Directory = Instance.Directory,
	File = "Fetlorn.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "NT_Fetlorn",
	Object = "MOD",
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Fetlorn = KBM.Language:Add("Nightmare Fetlorn")
MOD.Lang.Unit.Fetlorn:SetFrench("Fetlorn cauchemardesque")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Theft = KBM.Language:Add("Bone Theft")
MOD.Lang.Ability.Theft:SetFrench("Désossage")
MOD.Lang.Ability.Marrow = KBM.Language:Add("Boiling Marrow")
MOD.Lang.Ability.Marrow:SetFrench("Moelle embrasée")

-- Buff Dictionary
MOD.Lang.Buff = {}
MOD.Lang.Buff.Shield = KBM.Language:Add("Bone Shield")
MOD.Lang.Buff.Shield:SetFrench("Bouclier osseux")

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.TheftWarn = KBM.Language:Add("Hide!")
MOD.Lang.Verbose.TheftWarn:SetFrench("Cachez vous!!!")
MOD.Lang.Verbose.ShieldWarn = KBM.Language:Add("Purge!")
MOD.Lang.Verbose.ShieldWarn:SetFrench("Purge!!!")

MOD.Descript = MOD.Lang.Unit.Fetlorn[KBM.Lang]

MOD.Fetlorn = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = MOD.Lang.Unit.Fetlorn[KBM.Lang],
	NameShort = "Fetlorn",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U1A7CA8C559942170",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Theft = KBM.Defaults.AlertObj.Create("purple"),
		  Marrow = KBM.Defaults.AlertObj.Create("red"),
		  Shield = KBM.Defaults.AlertObj.Create("blue"),
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Fetlorn.Name] = self.Fetlorn,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Fetlorn.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Fetlorn.Settings.TimersRef,
		AlertsRef = self.Fetlorn.Settings.AlertsRef,
	}
	KBMNTRTITBF_Settings = self.Settings
	chKBMNTRTITBF_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRTITBF_Settings = self.Settings
		self.Settings = chKBMNTRTITBF_Settings
	else
		chKBMNTRTITBF_Settings = self.Settings
		self.Settings = KBMNTRTITBF_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRTITBF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRTITBF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRTITBF_Settings = self.Settings
	else
		KBMNTRTITBF_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRTITBF_Settings = self.Settings
	else
		KBMNTRTITBF_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Fetlorn.UnitID == UnitID then
		self.Fetlorn.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Fetlorn.UnitID == UnitID then
		self.Fetlorn.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Fetlorn.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Fetlorn.Dead = false
					self.Fetlorn.Casting = false
					self.Fetlorn.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Fetlorn.Name, 0, 100)
					self.Phase = 1
				end
				self.Fetlorn.UnitID = unitID
				self.Fetlorn.Available = true
				return self.Fetlorn
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Fetlorn.Available = false
	self.Fetlorn.UnitID = nil
	self.Fetlorn.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Fetlorn:SetTimers(bool)	
	if bool then
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function MOD.Fetlorn:SetAlerts(bool)
	if bool then
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Fetlorn)
	
	-- Create Alerts
	self.Fetlorn.AlertsRef.Theft = KBM.Alert:Create(self.Lang.Verbose.TheftWarn[KBM.Lang], nil, true, true, "purple")
  --self.Fetlorn.AlertsRef.Marrow = KBM.Alert:Create(self.Lang.Ability.Marrow[KBM.Lang], nil, true, true, "red")
  self.Fetlorn.AlertsRef.Shield = KBM.Alert:Create(self.Lang.Verbose.ShieldWarn[KBM.Lang], 1, true, false, "blue")
	
	KBM.Defaults.AlertObj.Assign(self.Fetlorn)
	
	-- Assign Alerts and Timers to Triggers
	self.Fetlorn.Triggers.Theft = KBM.Trigger:Create(self.Lang.Ability.Theft[KBM.Lang], "cast", self.Fetlorn)
  self.Fetlorn.Triggers.Theft:AddAlert(self.Fetlorn.AlertsRef.Theft)
  
  --self.Fetlorn.Triggers.Marrow = KBM.Trigger:Create(self.Lang.Ability.Marrow[KBM.Lang], "cast", self.Fetlorn)
  --self.Fetlorn.Triggers.Marrow:AddAlert(self.Fetlorn.AlertsRef.Marrow)
  
  self.Fetlorn.Triggers.Shield = KBM.Trigger:Create(self.Lang.Buff.Shield[KBM.Lang], "buff", self.Fetlorn)
	self.Fetlorn.Triggers.Shield:AddAlert(self.Fetlorn.AlertsRef.Shield)
	
	self.Fetlorn.CastBar = KBM.Castbar:Add(self, self.Fetlorn)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end