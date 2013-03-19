-- Regulos Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEERS_Settings = nil
chKBMSLRDEERS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local EE = KBM.BossMod["REndless_Eclipse"]

local REG = {
	Enabled = true,
	Directory = EE.Directory,
	File = "Regulos.lua",
	Instance = EE.Name,
	InstanceObj = EE,
	HasPhases = true,
	Lang = {},
	ID = "Regulos",
	Object = "REG",
	Enrage = 11 * 60,
}

REG.Regulos = {
	Mod = REG,
	Level = "??",
	Active = false,
	Name = "Regulos",
	NameShort = "Regulos",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	UTID = "UFF5EE9B9158B8C9E",
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Apotheosis = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Eradicate = KBM.Defaults.AlertObj.Create("purple"),
			Vanquish = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Doom = KBM.Defaults.MechObj.Create("cyan"),
			Eradicate = KBM.Defaults.MechObj.Create("purple"),
			Glimpse = KBM.Defaults.MechObj.Create("dark_green"),
		},
	}
}

KBM.RegisterMod(REG.ID, REG)

-- Main Unit Dictionary
REG.Lang.Unit = {}
REG.Lang.Unit.Regulos = KBM.Language:Add("Regulos")
REG.Lang.Unit.Regulos:SetGerman("Regulos")
REG.Lang.Unit.Regulos:SetFrench("Regulos")
REG.Lang.Unit.RegulosShort = KBM.Language:Add("Regulos")
REG.Lang.Unit.RegulosShort:SetGerman("Regulos")
REG.Lang.Unit.RegulosShort:SetFrench("Regulos")
REG.Lang.Unit.Shambler = KBM.Language:Add("Shambling Nightmare")
REG.Lang.Unit.Shambler:SetFrench("Cauchemar indolent")
REG.Lang.Unit.Molinar = KBM.Language:Add("Dark Thane Molinar")
REG.Lang.Unit.Molinar:SetFrench("Baron des ténèbres Molinar")

-- Ability Dictionary
REG.Lang.Ability = {}
REG.Lang.Ability.Tentacle = KBM.Language:Add("Tentacle Storm") -- 10s cast time
REG.Lang.Ability.Tentacle:SetFrench("Tempête tentaculaire") -- 10s cast time
REG.Lang.Ability.Apotheosis = KBM.Language:Add("Death's Apotheosis") -- 72.5s cast time
REG.Lang.Ability.Apotheosis:SetFrench("Apothéose de la Mort") -- 72.5s cast time
REG.Lang.Ability.Calamity = KBM.Language:Add("Invoke Calamity") -- 3.5s cast time
REG.Lang.Ability.Calamity:SetFrench("Invocation de calamité") -- 3.5s cast time
REG.Lang.Ability.Vanquish = KBM.Language:Add("Vanquish the Weak")
REG.Lang.Ability.Vanquish:SetFrench("Victoire sur les faibles")

-- Debuff Dictionary
REG.Lang.Debuff = {}
REG.Lang.Debuff.Mark = KBM.Language:Add("Mark of the Void") -- Tank debuff?
REG.Lang.Debuff.Mark:SetFrench("Marque du Néant") -- Tank debuff?
REG.Lang.Debuff.Heart = KBM.Language:Add("Heart of Death") -- Tank debuff?
REG.Lang.Debuff.Heart:SetFrench("Coeur de la mort") -- Tank debuff? Cœur
REG.Lang.Debuff.Darkness = KBM.Language:Add("Seething Darkness") -- 50k Heal absorb
REG.Lang.Debuff.Darkness:SetFrench("Ténèbres bouillonnantes") -- 50k Heal absorb
REG.Lang.Debuff.Doom = KBM.Language:Add("Impending Doom")
REG.Lang.Debuff.Doom:SetFrench("Étreinte de la mort")
REG.Lang.Debuff.Glimpse = KBM.Language:Add("Glimpse the Abyss")
REG.Lang.Debuff.Glimpse:SetFrench("Aperçu des abysses")

-- Messages Dictionary
REG.Lang.Messages = {}
REG.Lang.Messages.Engulf = KBM.Language:Add("(%a*) is engulfed by seething darkness.")
REG.Lang.Messages.Engulf:SetFrench("(%a*) se retrouve englouti par les Ténèbres bouillonnantes.")
REG.Lang.Messages.Eradicate = KBM.Language:Add("Regulos prepares to eradicate (%a*).") -- 
REG.Lang.Messages.Eradicate:SetFrench("Regulos se prépare à éradiquer (%a*).") -- 
REG.Lang.Messages.Will = KBM.Language:Add("Regulos imposes his will upon (%a*).")
REG.Lang.Messages.Will:SetFrench("Regulos impose sa volonté à (%a*).")

-- Verbose Dictionary
REG.Lang.Verbose = {}
REG.Lang.Verbose.Eradicate = KBM.Language:Add("Eradicate")
REG.Lang.Verbose.Eradicate:SetFrench("Éradication")
REG.Lang.Verbose.Stack = KBM.Language:Add("Stack! Meteor time!")
REG.Lang.Verbose.Stack:SetFrench("Stack! Chûte de Météorite!")

-- Description Dictionary
REG.Lang.Main = {}
REG.Lang.Main.Descript = KBM.Language:Add("Regulos")
REG.Lang.Main.Descript:SetGerman("Schreckensfürst Regulos")
REG.Lang.Main.Descript:SetFrench("Regulos")
REG.Descript = REG.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
REG.Regulos.Name = REG.Lang.Unit.Regulos[KBM.Lang]
REG.Regulos.NameShort = REG.Lang.Unit.RegulosShort[KBM.Lang]

function REG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Regulos.Name] = self.Regulos,
	}
end

function REG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Regulos.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Regulos.Settings.TimersRef,
		AlertsRef = self.Regulos.Settings.AlertsRef,
		MechSpy = KBM.Defaults.MechSpy(),
		MechRef = self.Regulos.Settings.MechRef,
	}
	KBMSLRDEERS_Settings = self.Settings
	chKBMSLRDEERS_Settings = self.Settings
	
end

function REG:SwapSettings(bool)

	if bool then
		KBMSLRDEERS_Settings = self.Settings
		self.Settings = chKBMSLRDEERS_Settings
	else
		chKBMSLRDEERS_Settings = self.Settings
		self.Settings = KBMSLRDEERS_Settings
	end

end

function REG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDEERS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDEERS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDEERS_Settings = self.Settings
	else
		KBMSLRDEERS_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function REG:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDEERS_Settings = self.Settings
	else
		KBMSLRDEERS_Settings = self.Settings
	end	
end

function REG:Castbar(units)
end

function REG:RemoveUnits(UnitID)
	if self.Regulos.UnitID == UnitID then
		self.Regulos.Available = false
		return true
	end
	return false
end

function REG:Death(UnitID)
	if self.Regulos.UnitID == UnitID then
		self.Regulos.Dead = true
		return true
	end
	return false
end

function REG:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Regulos.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Regulos, 0, 100)
					self.Phase = 1
					KBM.TankSwap:Start(self.Lang.Debuff.Mark[KBM.Lang], unitID)
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Regulos.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return BossObj
			end
		end
	end
end

function REG:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Regulos.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function REG:Timer()	
end

function REG:DefineMenu()
	self.Menu = EE.Menu:CreateEncounter(self.Regulos, self.Enabled)
end

function REG:Start()
	-- Create Timers
	self.Regulos.TimersRef.Apotheosis = KBM.MechTimer:Add(self.Lang.Ability.Apotheosis[KBM.Lang], 72, false)
	KBM.Defaults.TimerObj.Assign(self.Regulos)
	
	-- Create Alerts
	self.Regulos.AlertsRef.Eradicate = KBM.Alert:Create(self.Lang.Verbose.Stack[KBM.Lang], 8, true, true, "purple")
	self.Regulos.AlertsRef.Vanquish = KBM.Alert:Create(self.Lang.Ability.Vanquish[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Regulos)

	-- Create Mechanic Spies
	self.Regulos.MechRef.Doom = KBM.MechSpy:Add(self.Lang.Debuff.Doom[KBM.Lang], nil, "playerDebuff", self.Regulos)
	self.Regulos.MechRef.Eradicate = KBM.MechSpy:Add(self.Lang.Verbose.Eradicate[KBM.Lang], 8, "notify", self.Regulos)
	self.Regulos.MechRef.Glimpse = KBM.MechSpy:Add(self.Lang.Debuff.Glimpse[KBM.Lang], nil, "playerDebuff", self.Regulos)
	KBM.Defaults.MechObj.Assign(self.Regulos)
	
	-- Assign Alerts and Timers to Triggers
	self.Regulos.Triggers.Eradicate = KBM.Trigger:Create(self.Lang.Messages.Eradicate[KBM.Lang], "notify", self.Regulos)
	self.Regulos.Triggers.Eradicate:AddAlert(self.Regulos.AlertsRef.Eradicate, true)
	self.Regulos.Triggers.Eradicate:AddSpy(self.Regulos.MechRef.Eradicate)

	self.Regulos.Triggers.Doom = KBM.Trigger:Create(self.Lang.Debuff.Doom[KBM.Lang], "playerBuff", self.Regulos)
	self.Regulos.Triggers.Doom:AddSpy(self.Regulos.MechRef.Doom)
	self.Regulos.Triggers.DoomRem = KBM.Trigger:Create(self.Lang.Debuff.Doom[KBM.Lang], "playerBuffRemove", self.Regulos)
	self.Regulos.Triggers.DoomRem:AddStop(self.Regulos.MechRef.Doom)

	self.Regulos.Triggers.Glimpse = KBM.Trigger:Create(self.Lang.Debuff.Glimpse[KBM.Lang], "playerBuff", self.Regulos)
	self.Regulos.Triggers.Glimpse:AddSpy(self.Regulos.MechRef.Glimpse)
	self.Regulos.Triggers.GlimpseRem = KBM.Trigger:Create(self.Lang.Debuff.Glimpse[KBM.Lang], "playerBuffRemove", self.Regulos)
	self.Regulos.Triggers.GlimpseRem:AddStop(self.Regulos.MechRef.Glimpse)

	self.Regulos.Triggers.Apotheosis = KBM.Trigger:Create(self.Lang.Ability.Apotheosis[KBM.Lang], "channel", self.Regulos)
	self.Regulos.Triggers.Apotheosis:AddTimer(self.Regulos.TimersRef.Apotheosis)

	self.Regulos.Triggers.Vanquish = KBM.Trigger:Create(self.Lang.Ability.Vanquish[KBM.Lang], "channel", self.Regulos)
	self.Regulos.Triggers.Vanquish:AddAlert(self.Regulos.AlertsRef.Vanquish)
	
	self.Regulos.CastBar = KBM.CastBar:Add(self, self.Regulos)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end