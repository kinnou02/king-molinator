-- The Ember.Szath Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDEC_Settings = nil
chKBMINDEC_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local EC = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Conclave.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "The Ember Conclave",
	Object = "EC",
}

EC.Szath = {
	Mod = EC,
	Level = "??",
	Active = false,
	Name = "Witchlord Szath",
	NameShort = "Szath",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

KBM.RegisterMod(EC.ID, EC)

-- Main Unit Dictionary
EC.Lang.Unit = {}
EC.Lang.Unit.Szath = KBM.Language:Add(EC.Szath.Name)
EC.Lang.Unit.Szath:SetFrench("Seigneur-sorcier Szath")
EC.Lang.Unit.Szath:SetGerman("Hexenmeister Szath")
EC.Lang.Unit.SzShort = KBM.Language:Add(EC.Szath.NameShort)
EC.Lang.Unit.SzShort:SetFrench()
EC.Lang.Unit.SzShort:SetGerman()
EC.Lang.Unit.Nahoth = KBM.Language:Add("Packmaster Nahoth")
EC.Lang.Unit.Nahoth:SetFrench("Maître-fourrier Nahoth")
EC.Lang.Unit.Nahoth:SetGerman("Rudelmeister Nahoth")
EC.Lang.Unit.NahShort = KBM.Language:Add("Nahoth")
EC.Lang.Unit.NahShort:SetFrench()
EC.Lang.Unit.NahShort:SetGerman()
EC.Lang.Unit.Ereetu = KBM.Language:Add("Emberlord Ereetu")
EC.Lang.Unit.Ereetu:SetFrench("Seigneur de Braise Ereetu")
EC.Lang.Unit.Ereetu:SetGerman("Glutfürst Ereetu")
EC.Lang.Unit.EreShort = KBM.Language:Add("Ereetu")
EC.Lang.Unit.EreShort:SetFrench()
EC.Lang.Unit.EreShort:SetGerman()

EC.Nahoth = {
	Mod = EC,
	Level = "??",
	Active = false,
	Name = EC.Lang.Unit.Nahoth[KBM.Lang],
	NameShort = EC.Lang.Unit.NahShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

EC.Ereetu = {
	Mod = EC,
	Level = "??",
	Active = false,
	Name = EC.Lang.Unit.Ereetu[KBM.Lang],
	NameShort = EC.Lang.Unit.EreShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

-- Ability Dictionary
EC.Lang.Ability = {}

-- Description Dictionary
EC.Lang.Main = {}
EC.Lang.Main.Descript = KBM.Language:Add("The Ember Conclave")
EC.Lang.Main.Descript:SetFrench("Conclave de braise")
EC.Lang.Main.Descript:SetGerman("Die Glutkonklave")
EC.Lang.Main.Descript:SetRussian("Раскаленный Конклав")

EC.Szath.Name = EC.Lang.Unit.Szath[KBM.Lang]
EC.Szath.NameShort = EC.Lang.Unit.SzShort[KBM.Lang]
EC.Descript = EC.Lang.Main.Descript[KBM.Lang]

function EC:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Szath.Name] = self.Szath,
		[self.Nahoth.Name] = self.Nahoth,
		[self.Ereetu.Name] = self.Ereetu,
	}
	KBM_Boss[self.Szath.Name] = self.Szath
	KBM_Boss[self.Nahoth.Name] = self.Nahoth
	KBM_Boss[self.Ereetu.Name] = self.Ereetu
	
	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Override = true
				BossObj.Settings.CastBar.Multi = true
			end
		end
	end	
end

function EC:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Szath.Settings.TimersRef,
		-- AlertsRef = self.Szath.Settings.AlertsRef,
		Szath = {
			CastBar = self.Szath.Settings.CastBar,
		},
		Nahoth = {
			CastBar = self.Nahoth.Settings.CastBar,
		},
		Ereetu = {
			CastBar = self.Ereetu.Settings.CastBar,
		},
	}
	KBMINDEC_Settings = self.Settings
	chKBMINDEC_Settings = self.Settings
	
end

function EC:SwapSettings(bool)

	if bool then
		KBMINDEC_Settings = self.Settings
		self.Settings = chKBMINDEC_Settings
	else
		chKBMINDEC_Settings = self.Settings
		self.Settings = KBMINDEC_Settings
	end

end

function EC:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDEC_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDEC_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDEC_Settings = self.Settings
	else
		KBMINDEC_Settings = self.Settings
	end	
end

function EC:SaveVars()	
	if KBM.Options.Character then
		chKBMINDEC_Settings = self.Settings
	else
		KBMINDEC_Settings = self.Settings
	end	
end

function EC:Castbar(units)
end

function EC:RemoveUnits(UnitID)
	if self.Szath.UnitID == UnitID then
		self.Szath.Available = false
		return true
	end
	return false
end

function EC:Death(UnitID)
	if self.Szath.UnitID == UnitID then
		self.Szath.Dead = true
	elseif self.Nahoth.UnitID == UnitID then
		self.Nahoth.Dead = true
	elseif self.Ereetu.UnitID == UnitID then
		self.Ereetu.Dead = true
	end
	if self.Szath.Dead == true then
		if self.Nahoth.Dead == true then
			if self.Ereetu.Dead == true then
				return true
			end
		end
	end
	return false
end

function EC:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if self.Bosses[unitDetails.name] then
				local BossObj = self.Bosses[unitDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					BossObj.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Szath.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Nahoth.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Ereetu.Name, 0, 100)
					self.Phase = 1
				else
					if not BossObj.CastBar then
						BossObj.CastBar:Create(unitID)
					end
					BossObj.Dead = false
					BossObj.Casting = false
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return BossObj
			end
		end
	end
end

function EC:Reset()
	self.EncounterRunning = false
	for Name, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function EC:Timer()	
end

function EC:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Szath, self.Enabled)
end

function EC:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Szath)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Szath)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Szath.CastBar = KBM.CastBar:Add(self, self.Szath)
	self.Nahoth.CastBar = KBM.CastBar:Add(self, self.Nahoth)
	self.Ereetu.CastBar = KBM.CastBar:Add(self, self.Ereetu)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end