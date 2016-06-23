-- Teth Mornta Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRCPLA_Settings = nil
chKBMNTRCPLA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Rhaza'de_Canyons"]

local MOD = {
	Directory = Instance.Directory,
	File = "Teth.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RC_Teth",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Teth = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Teth Mornta",
	--NameShort = "Teth",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U0792F9C65622478F",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Rip = KBM.Defaults.AlertObj.Create("red"),
			Singularity = KBM.Defaults.AlertObj.Create("red"),
			Abyss = KBM.Defaults.AlertObj.Create("purple"), 
			Shatter = KBM.Defaults.AlertObj.Create("orange"), 
			}
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Teth = KBM.Language:Add(MOD.Teth.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Rip = KBM.Language:Add("Soul Rip")
MOD.Lang.Ability.Singularity = KBM.Language:Add("Spiritual Singularity")

MOD.Lang.Ability.Abyss = KBM.Language:Add("Spiritual Abyss")

MOD.Lang.Ability.Shatter = KBM.Language:Add("Shatter Reality")

MOD.Lang.Ability.Chains = KBM.Language:Add("Chains of Teth")
MOD.Lang.Ability.Sentence = KBM.Language:Add("Death Sentence")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}
MOD.Lang.Debuff.Chains = KBM.Language:Add("Chains of Teth")
MOD.Lang.Debuff.ChainsID = "B275ABD0693BA8F38"
MOD.Lang.Debuff.Sentence = KBM.Language:Add("Death Sentence")
MOD.Lang.Debuff.SentenceID = ""

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Teth[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Teth.Name] = self.Teth,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Teth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Teth.Settings.TimersRef,
		AlertsRef = self.Teth.Settings.AlertsRef,
	}
	KBMNTRCPLA_Settings = self.Settings
	chKBMNTRCPLA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRCPLA_Settings = self.Settings
		self.Settings = chKBMNTRCPLA_Settings
	else
		chKBMNTRCPLA_Settings = self.Settings
		self.Settings = KBMNTRCPLA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRCPLA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRCPLA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRCPLA_Settings = self.Settings
	else
		KBMNTRCPLA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRCPLA_Settings = self.Settings
	else
		KBMNTRCPLA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Teth.UnitID == UnitID then
		self.Teth.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Teth.UnitID == UnitID then
		self.Teth.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Teth.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Teth.Dead = false
				self.Teth.Casting = false
				self.Teth.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Teth.Name, 80, 100)
				self.Phase = 1
			end
			self.Teth.UnitID = unitID
			self.Teth.Available = true
			return self.Teth
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Teth.Available = false
	self.Teth.UnitID = nil
	self.Teth.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.PhaseTwo()
	MOD.PhaseObj.Objectives:Remove()
	MOD.Phase = 2
	MOD.PhaseObj:SetPhase("2")
	MOD.PhaseObj.Objectives:AddPercent(MOD.Teth.Name, 60, 80)
end

function MOD.PhaseThree()
	MOD.PhaseObj.Objectives:Remove()
	MOD.Phase = 3
	MOD.PhaseObj:SetPhase("3")
	MOD.PhaseObj.Objectives:AddPercent(MOD.Teth.Name, 40, 60)
end

function MOD.PhaseFinal()
	MOD.PhaseObj.Objectives:Remove()
	MOD.Phase = 4
	MOD.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	MOD.PhaseObj.Objectives:AddPercent(MOD.Teth.Name, 0, 40)
end



function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Teth)
	
	-- Create Alerts
	self.Teth.AlertsRef.Rip = KBM.Alert:Create("Get in!", nil, false, true, "red")
	self.Teth.AlertsRef.Singularity = KBM.Alert:Create("Get in!", nil, false, true, "red")
	
	self.Teth.AlertsRef.Abyss = KBM.Alert:Create(self.Lang.Ability.Abyss[KBM.Lang], nil, false, true, "purple")
		
	self.Teth.AlertsRef.Shatter = KBM.Alert:Create(self.Lang.Ability.Shatter[KBM.Lang], nil, false, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Teth)
	
	-- Assign Alerts and Timers to Triggers
	self.Teth.Triggers.Rip = KBM.Trigger:Create(self.Lang.Ability.Rip[KBM.Lang], "channel", self.Teth)
	self.Teth.Triggers.Rip:AddAlert(self.Teth.AlertsRef.Rip)
	
	self.Teth.Triggers.Singularity = KBM.Trigger:Create(self.Lang.Ability.Singularity[KBM.Lang], "channel", self.Teth)
	self.Teth.Triggers.Singularity:AddAlert(self.Teth.AlertsRef.Singularity)
	
	self.Teth.Triggers.Abyss = KBM.Trigger:Create(self.Lang.Ability.Abyss[KBM.Lang], "cast", self.Teth)
	self.Teth.Triggers.Abyss:AddAlert(self.Teth.AlertsRef.Abyss)
	
	self.Teth.Triggers.Shatter = KBM.Trigger:Create(self.Lang.Ability.Shatter[KBM.Lang], "cast", self.Teth)
	self.Teth.Triggers.Shatter:AddAlert(self.Teth.AlertsRef.Shatter)
	
	
	
	self.Teth.Triggers.PhaseTwo = KBM.Trigger:Create(80, "percent", self.Teth)
	self.Teth.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	
	self.Teth.Triggers.PhaseThree = KBM.Trigger:Create(60, "percent", self.Teth)
	self.Teth.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	
	self.Teth.Triggers.PhaseFinal = KBM.Trigger:Create(40, "percent", self.Teth)
	self.Teth.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	
	
	
	self.Teth.CastBar = KBM.Castbar:Add(self, self.Teth)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end