-- Totek the Ancient Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRTITTA_Settings = nil
chKBMNTRTITTA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["RTIron_Tomb"]

local MOD = {
	Directory = Instance.Directory,
	File = "Totek.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "NT_Totek",
	Object = "MOD",
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Totek = KBM.Language:Add("Nightmare Totek")
MOD.Lang.Unit.Totek:SetFrench("Totek caudemardesque")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Roar = KBM.Language:Add("Shattering Roar")
MOD.Lang.Ability.Roar:SetFrench("Rugissement destructeur")
MOD.Lang.Ability.Fury = KBM.Language:Add("Ancient Fury")
MOD.Lang.Ability.Fury:SetFrench("Fureur ancienne")

MOD.Descript = MOD.Lang.Unit.Totek[KBM.Lang]

MOD.Totek = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = MOD.Lang.Unit.Totek[KBM.Lang],
	NameShort = "Totek",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U054B9FC642CFDA64",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Roar = KBM.Defaults.AlertObj.Create("purple"),
		  Fury = KBM.Defaults.AlertObj.Create("orange"),
		},		
	},
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Totek.Name] = self.Totek,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Totek.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Totek.Settings.TimersRef,
		AlertsRef = self.Totek.Settings.AlertsRef,
	}
	KBMNTRTITTA_Settings = self.Settings
	chKBMNTRTITTA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRTITTA_Settings = self.Settings
		self.Settings = chKBMNTRTITTA_Settings
	else
		chKBMNTRTITTA_Settings = self.Settings
		self.Settings = KBMNTRTITTA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRTITTA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRTITTA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRTITTA_Settings = self.Settings
	else
		KBMNTRTITTA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRTITTA_Settings = self.Settings
	else
		KBMNTRTITTA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Totek.UnitID == UnitID then
		self.Totek.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Totek.UnitID == UnitID then
		self.Totek.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Totek.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Totek.Dead = false
					self.Totek.Casting = false
					self.Totek.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Totek.Name, 0, 100)
					self.Phase = 1
				end
				self.Totek.UnitID = unitID
				self.Totek.Available = true
				return self.Totek
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Totek.Available = false
	self.Totek.UnitID = nil
	self.Totek.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Totek)
	
	-- Create Alerts
	--self.Totek.AlertsRef.Fury = KBM.Alert:Create(self.Lang.Ability.Fury[KBM.Lang], nil, true, true, "orange")
	self.Totek.AlertsRef.Roar = KBM.Alert:Create(self.Lang.Ability.Roar[KBM.Lang], nil, true, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Totek)
	
	-- Assign Alerts and Timers to Triggers
	--self.Totek.Triggers.Fury = KBM.Trigger:Create(self.Lang.Ability.Fury[KBM.Lang], "channel", self.Totek)
	--self.Totek.Triggers.Fury:AddAlert(self.Totek.AlertsRef.Fury)
	
	self.Totek.Triggers.Roar = KBM.Trigger:Create(self.Lang.Ability.Roar[KBM.Lang], "cast", self.Totek)
	self.Totek.Triggers.Roar:AddAlert(self.Totek.AlertsRef.Roar)
	
	self.Totek.CastBar = KBM.Castbar:Add(self, self.Totek)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end