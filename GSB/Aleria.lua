-- Oracle Aleria Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBOA_Settings = nil
chKBMGSBOA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GSB = KBM.BossMod["Greenscales Blight"]

local OA = {
	Enabled = true,
	Instance = GSB.Name,
	HasPhases = true,
	Lang = {},
	ID = "Aleria",
}

OA.Aleria = {
	Mod = OA,
	Level = "52",
	Active = false,
	Name = "Oracle Aleria",
	Menu = {},
	AlertsRef = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Necrotic = KBM.Defaults.AlertObj.Create("purple"),
		},
		TimersRef = {
			Enabled = true,
			Necrotic = KBM.Defaults.TimerObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(OA.ID, OA)

OA.Lang.Aleria = KBM.Language:Add(OA.Aleria.Name)
OA.Lang.Aleria.German = "Orakel Aleria"

-- Unit Dictionary
OA.Lang.Unit = {}
OA.Lang.Unit.Primal = KBM.Language:Add("Primal Werewolf")
OA.Lang.Unit.Primal.German = "Ur-Werwolf"
OA.Lang.Unit.Necrotic = KBM.Language:Add("Necrotic Werewolf")
OA.Lang.Unit.Necrotic.German = "Nekrotischer Werwolf"

-- Debuff Dictionary
OA.Lang.Debuff = {}
OA.Lang.Debuff.Necrotic = KBM.Language:Add("Necrotic Eruption")
OA.Lang.Debuff.Necrotic.German = "Nekrotischer Ausbruch" 

OA.Primal = {
	Mod = OA,
	Level = "52",
	Active = false,
	Name = OA.Lang.Unit.Primal[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
}

OA.Necrotic = {
	Mod = OA,
	Level = "52",
	Active = false,
	Name = OA.Lang.Unit.Necrotic[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
}

OA.Aleria.Name = OA.Lang.Aleria[KBM.Lang]

function OA:AddBosses(KBM_Boss)
	self.Aleria.Descript = self.Aleria.Name
	self.Primal.Descript = self.Aleria.Descript
	self.Necrotic.Descript = self.Aleria.Descript
	self.MenuName = self.Aleria.Descript
	self.Bosses = {
		[self.Aleria.Name] = self.Aleria,
		[self.Primal.Name] = self.Primal,
		[self.Necrotic.Name] = self.Necrotic,
	}
	KBM_Boss[self.Aleria.Name] = self.Aleria
	KBM.SubBoss[self.Primal.Name] = self.Primal
	KBM.SubBoss[self.Necrotic.Name] = self.Necrotic
end

function OA:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
	}
	KBMGSBOA_Settings = self.Settings
	chKBMGSBOA_Settings = self.Settings
end

function OA:SwapSettings(bool)
	if bool then
		KBMGSBOA_Settings = self.Settings
		self.Settings = chKBMGSBOA_Settings
	else
		chKBMGSBOA_Settings = self.Settings
		self.Settings = KBMGSBOA_Settings
	end
end

function OA:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGSBOA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGSBOA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGSBOA_Settings = self.Settings
	else
		KBMGSBOA_Settings = self.Settings
	end
end

function OA:SaveVars()	
	if KBM.Options.Character then
		chKBMGSBOA_Settings = self.Settings
	else
		KBMGSBOA_Settings = self.Settings
	end	
end

function OA:Castbar(units)
end

function OA:RemoveUnits(UnitID)
	if self.Aleria.UnitID == UnitID then
		self.Aleria.Available = false
		return true
	end
	return false
end

function OA.PhaseTwo()
	OA.PhaseObj.Objectives:Remove()
	OA.Phase = 2
	OA.PhaseObj:SetPhase("Final")
	OA.PhaseObj.Objectives:AddPercent(OA.Aleria.Name, 0, 100)
end

function OA:Death(UnitID)
	if self.Aleria.UnitID == UnitID then
		self.Aleria.Dead = true
		return true
	else
		if self.Primal.UnitID == UnitID then
			self.Primal.Dead = true
		elseif self.Necrotic.UnitID == UnitID then
			self.Necrotic.Dead = true
		end
		if self.Primal.Dead and self.Necrotic.Dead then
			self.PhaseTwo()
		end
	end
	return false
end

function OA:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
					self.PhaseObj.Objectives:AddPercent(self.Primal.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Necrotic.Name, 0, 100)
				end
				if not self.Bosses[uDetails.name].UnitID then
					self.Bosses[uDetails.name].Dead = false
				end
				self.Bosses[uDetails.name].UnitID = unitID
				self.Bosses[uDetails.name].Available = true
				return self.Bosses[uDetails.name]
			end
		end
	end
end

function OA:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.Dead = false
		BossObj.UnitID = nil
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function OA:Timer()	
end

function OA.Aleria:SetTimers(bool)	
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

function OA.Aleria:SetAlerts(bool)
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

function OA:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Aleria, self.Enabled)
end

function OA:Start()
	-- Create Alert
	self.Aleria.AlertsRef.Necrotic = KBM.Alert:Create(self.Lang.Debuff.Necrotic[KBM.Lang], nil, false, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Aleria)
	
	-- Create Timer
	self.Aleria.TimersRef.Necrotic = KBM.MechTimer:Add(self.Lang.Debuff.Necrotic[KBM.Lang], 22, "purple")
	KBM.Defaults.TimerObj.Assign(self.Aleria)

	-- Assign Alert to Trigger
	self.Aleria.Triggers.Necrotic = KBM.Trigger:Create(self.Lang.Debuff.Necrotic[KBM.Lang], "buff", self.Aleria)
	self.Aleria.Triggers.Necrotic:AddAlert(self.Aleria.AlertsRef.Necrotic, true)
	self.Aleria.Triggers.Necrotic:AddTimer(self.Aleria.TimersRef.Necrotic)
	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end