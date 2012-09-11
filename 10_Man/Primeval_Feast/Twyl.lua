﻿-- Lord Twyl Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMPFLT_Settings = nil
chKBMPFLT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PF = KBM.BossMod["Primeval Feast"]

local LT = {
	Directory = PF.Directory,
	File = "Twyl.lua",
	Enabled = true,
	Instance = PF.Name,
	Lang = {},
	Enrage = 8 * 60,
	ID = "PF_Twyl",
	Object = "LT",
	HasPhases = true,
}

LT.Twyl = {
	Mod = LT,
	Level = "??",
	Active = false,
	Name = "Lord Twyl",
	NameShort = "Twyl",
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Quake = KBM.Defaults.AlertObj.Create("yellow"),
			Fire = KBM.Defaults.AlertObj.Create("red"),
			Nova = KBM.Defaults.AlertObj.Create("cyan"),
		},
		TimersRef = {
			Enabled = true,
			Fire = KBM.Defaults.TimerObj.Create("red"),
			Nova = KBM.Defaults.TimerObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
			Sacrifice = KBM.Defaults.MechObj.Create("dark_green"),
			Spider = KBM.Defaults.MechObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(LT.ID, LT)

-- Main Unit Dictionary
LT.Lang.Unit = {}
LT.Lang.Unit.Twyl = KBM.Language:Add(LT.Twyl.Name)
LT.Lang.Unit.Twyl:SetGerman("Fürst Twyl")
LT.Lang.Unit.TwylShort = KBM.Language:Add("Twyl")
LT.Lang.Unit.TwylShort:SetGerman("Twyl")
LT.Lang.Unit.Wolf = KBM.Language:Add("Ravenous Wolf")
LT.Lang.Unit.WolfShort = KBM.Language:Add("Wolf")
LT.Lang.Unit.Tiger = KBM.Language:Add("Voracious Tiger")
LT.Lang.Unit.TigerShort = KBM.Language:Add("Tiger")
LT.Lang.Unit.Spider = KBM.Language:Add("Rapacious Spider")
LT.Lang.Unit.SpiderShort = KBM.Language:Add("Spider")
LT.Lang.Unit.Shaman = KBM.Language:Add("Ritual Shaman")
LT.Lang.Unit.ShamanShort = KBM.Language:Add("Shaman")
LT.Lang.Unit.Fiend = KBM.Language:Add("Wicker Fiend")
LT.Lang.Unit.FiendShort = KBM.Language:Add("Fiend")

LT.Lang.Ability = {}
LT.Lang.Ability.Fire = KBM.Language:Add("Flickering Fire")
LT.Lang.Ability.Nova = KBM.Language:Add("Frozen Nova")
LT.Lang.Ability.Blast = KBM.Language:Add("Dark Moon Blast")
LT.Lang.Ability.Pyre = KBM.Language:Add("Wicker Pyre")

LT.Lang.Debuff = {}
LT.Lang.Debuff.Quake = KBM.Language:Add("Primeval Quake")
LT.Lang.Debuff.Critter = KBM.Language:Add("Tasty Critter")
LT.Lang.Debuff.Sacrifice = KBM.Language:Add("Harvest Sacrifice")
LT.Lang.Debuff.Spider = KBM.Language:Add("Spinning Swarm")

LT.Lang.Say = {}
LT.Lang.Say.Spring = KBM.Language:Add("Such a lovely Spring day! Warm blood never tasted better, my dear.")
LT.Lang.Say.Summer = KBM.Language:Add("Summer's scorching fury answers my call. Earth and Fire bow before me!")
LT.Lang.Say.Autumn = KBM.Language:Add("Autumn's dark chill heeds my command. Death cowers to Life!")
LT.Lang.Say.Winter = KBM.Language:Add("Winter's frosty dawn obeys my will. Air and Water submit to me!")

LT.Twyl.Name = LT.Lang.Unit.Twyl[KBM.Lang]
LT.Twyl.NameShort = LT.Lang.Unit.TwylShort[KBM.Lang]
LT.Descript = LT.Twyl.Name

LT.Wolf = {
	Mod = LT,
	Level = "??",
	Active = false,
	Name = LT.Lang.Unit.Wolf[KBM.Lang],
	NameShort = LT.Lang.Unit.WolfShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Critter = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Critter = KBM.Defaults.MechObj.Create("red"),
		},
	},
}

LT.Tiger = {
	Mod = LT,
	Level = "??",
	Active = false,
	Name = LT.Lang.Unit.Tiger[KBM.Lang],
	NameShort = LT.Lang.Unit.TigerShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Critter = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Critter = KBM.Defaults.MechObj.Create("red"),
		},
	},
}

LT.Spider = {
	Mod = LT,
	Level = "??",
	Active = false,
	Name = LT.Lang.Unit.Spider[KBM.Lang],
	NameShort = LT.Lang.Unit.SpiderShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Critter = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Critter = KBM.Defaults.MechObj.Create("red"),
		},
	},
}

LT.Shaman = {
	Mod = LT,
	Level = "??",
	Name = LT.Lang.Unit.Shaman[KBM.Lang],
	UnitList = {},
	Ignore = true,
	Type = "multi",
}
	

function LT:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Twyl.Name] = self.Twyl,
		[self.Wolf.Name] = self.Wolf,
		[self.Tiger.Name] = self.Tiger,
		[self.Spider.Name] = self.Spider,
		[self.Shaman.Name] = self.Shaman,
	}
	KBM_Boss[self.Twyl.Name] = self.Twyl
	KBM.SubBoss[self.Wolf.Name] = self.Wolf
	KBM.SubBoss[self.Tiger.Name] = self.Tiger
	KBM.SubBoss[self.Spider.Name] = self.Spider
	KBM.SubBoss[self.Shaman.Name] = self.Shaman
end

function LT:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Twyl = {
			CastBar = self.Twyl.Settings.CastBar,
			AlertsRef = self.Twyl.Settings.AlertsRef,
			TimersRef = self.Twyl.Settings.TimersRef,
		},
		Wolf = {
			AlertsRef = self.Wolf.Settings.AlertsRef,
		},
		Tiger = {
			AlertsRef = self.Tiger.Settings.AlertsRef,
		},
		Spider = {
			AlertsRef = self.Spider.Settings.AlertsRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMPFLT_Settings = self.Settings
	chKBMPFLT_Settings = self.Settings
end

function LT:SwapSettings(bool)

	if bool then
		KBMPFLT_Settings = self.Settings
		self.Settings = chKBMPFLT_Settings
	else
		chKBMPFLT_Settings = self.Settings
		self.Settings = KBMPFLT_Settings
	end

end

function LT:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPFLT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPFLT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPFLT_Settings = self.Settings
	else
		KBMPFLT_Settings = self.Settings
	end	
end

function LT:SaveVars()	
	if KBM.Options.Character then
		chKBMPFLT_Settings = self.Settings
	else
		KBMPFLT_Settings = self.Settings
	end	
end

function LT:Castbar(units)
end

function LT:RemoveUnits(UnitID)
	if self.Twyl.UnitID == UnitID then
		self.Twyl.Available = false
		return true
	end
	return false
end

function LT.PhaseOne()
	if LT.Phase < 1 then
		LT.PhaseObj.Objectives:Remove()
		LT.PhaseObj:SetPhase("Spring")
		LT.PhaseObj.Objectives:AddTime(18)
		LT.PhaseObj.Objectives:AddPercent(LT.Wolf.Name, 0, 100)
		LT.PhaseObj.Objectives:AddPercent(LT.Tiger.Name, 0, 100)
		LT.PhaseObj.Objectives:AddPercent(LT.Spider.Name, 0, 100)
		LT.Phase = 1
	end
end

function LT.PhaseTwo()
	if LT.Phase < 2 then
		LT.PhaseObj.Objectives:Remove()
		LT.PhaseObj:SetPhase("Summer")
		LT.PhaseObj.Objectives:AddPercent(LT.Twyl.Name, 50, 100)
		LT.Phase = 2
	end
end

function LT.PhaseThree()
	if LT.Phase < 3 then
		LT.PhaseObj.Objectives:Remove()
		LT.PhaseObj:SetPhase("Autumn")
		LT.PhaseObj.Objectives:AddDeath(LT.Shaman.Name, 2)
		LT.Phase = 3
	end
end

function LT.PhaseFinal()
	if LT.Phase < 4 then
		LT.PhaseObj.Objectives:Remove()
		LT.PhaseObj:SetPhase("Winter")
		LT.PhaseObj.Objectives:AddPercent(LT.Twyl.Name, 0, 50)
		LT.Phase = 4
	end
end

function LT:Death(UnitID)
	if self.Twyl.UnitID == UnitID then
		self.Twyl.Dead = true
		return true
	end
	return false
end

function LT:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
				if BossObj then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						BossObj.Dead = false
						local BossPercentRaw = (uDetails.health/uDetails.healthMax)*100
						self.PhaseObj:Start(self.StartTime)
						if BossObj == self.Wolf then
							self.PhaseObj:SetPhase("Spring")
							self.PhaseObj.Objectives:AddPercent(LT.Wolf.Name, 0, BossPercentRaw)
							self.PhaseObj.Objectives:AddPercent(LT.Tiger.Name, 0, 100)
							self.PhaseObj.Objectives:AddPercent(LT.Spider.Name, 0, 100)
							self.Phase = 1
						elseif BossObj == self.Tiger then
							self.PhaseObj:SetPhase("Spring")
							self.PhaseObj.Objectives:AddPercent(LT.Wolf.Name, 0, 0)
							self.PhaseObj.Objectives:AddPercent(LT.Tiger.Name, 0, BossPercentRaw)
							self.PhaseObj.Objectives:AddPercent(LT.Spider.Name, 0, 100)
							self.Phase = 1
						elseif BossObj == self.Spider then
							self.PhaseObj:SetPhase("Spring")
							self.PhaseObj.Objectives:AddPercent(LT.Wolf.Name, 0, 0)
							self.PhaseObj.Objectives:AddPercent(LT.Tiger.Name, 0, 0)
							self.PhaseObj.Objectives:AddPercent(LT.Spider.Name, 0, BossPercentRaw)
							self.Phase = 1
						elseif BossObj == self.Twyl then
							BossObj.Casting = false
							BossObj.CastBar:Create(unitID)
							if BossPercentRaw < 50 then
								self.PhaseObj:SetPhase("Winter")
								self.PhaseObj.Objectives:AddPercent(LT.Twyl.Name, 0, BossPercentRaw) 
								self.Phase = 4
							elseif BossPercentRaw < 99 then
								self.PhaseObj:SetPhase("Summer")
								self.PhaseObj.Objectives:AddPercent(LT.Twyl.Name, 50, BossPercentRaw)
								self.Phase = 2
							else
								self.Phase = 0
								self.PhaseOne()
							end
						end
					end
					BossObj.UnitID = unitID
					BossObj.Available = true
					return BossObj
				end
			end
		end
	end
end

function LT:Reset()
	self.EncounterRunning = false
	self.PhaseObj:End(Inspect.Time.Real())

	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
		if BossObj.UnitList then
			BossObj.UnitList = {}
		end		
	end
end

function LT:Timer()
	
end

function LT:DefineMenu()
	self.Menu = PF.Menu:CreateEncounter(self.Twyl, self.Enabled)
end

function LT:Start()
	-- Create Timers
	self.Twyl.TimersRef.Fire = KBM.MechTimer:Add(self.Lang.Ability.Fire[KBM.Lang], 17, false)
	self.Twyl.TimersRef.Nova = KBM.MechTimer:Add(self.Lang.Ability.Nova[KBM.Lang], 14, false)
	KBM.Defaults.TimerObj.Assign(self.Twyl)

	-- Create Alerts
	self.Twyl.AlertsRef.Quake = KBM.Alert:Create(self.Lang.Debuff.Quake[KBM.Lang], 6, false, true, "yellow")
	self.Twyl.AlertsRef.Quake:Important()
	self.Twyl.AlertsRef.Fire = KBM.Alert:Create(self.Lang.Ability.Fire[KBM.Lang], 10, false, false, "red")
	self.Twyl.AlertsRef.Nova = KBM.Alert:Create(self.Lang.Ability.Nova[KBM.Lang], 3, false, false, "blue")
	KBM.Defaults.AlertObj.Assign(self.Twyl)

	self.Wolf.AlertsRef.Critter = KBM.Alert:Create(self.Lang.Debuff.Critter[KBM.Lang], nil, false, false, "red")
	KBM.Defaults.AlertObj.Assign(self.Wolf)

	self.Tiger.AlertsRef.Critter = KBM.Alert:Create(self.Lang.Debuff.Critter[KBM.Lang], nil, false, false, "red")
	KBM.Defaults.AlertObj.Assign(self.Tiger)

	self.Spider.AlertsRef.Critter = KBM.Alert:Create(self.Lang.Debuff.Critter[KBM.Lang], nil, false, false, "red")
	KBM.Defaults.AlertObj.Assign(self.Spider)

	self.Twyl.MechRef.Sacrifice = KBM.MechSpy:Add(self.Lang.Debuff.Sacrifice[KBM.Lang], nil, "playerDebuff", self.Twyl)
	self.Twyl.MechRef.Spider = KBM.MechSpy:Add(self.Lang.Debuff.Spider[KBM.Lang], nil, "playerDebuff", self.Twyl)
	KBM.Defaults.MechObj.Assign(self.Twyl)

	self.Wolf.MechRef.Critter = KBM.MechSpy:Add(self.Lang.Debuff.Critter[KBM.Lang], -1, "playerDebuff", self.Wolf)
	KBM.Defaults.MechObj.Assign(self.Wolf)

	self.Tiger.MechRef.Critter = KBM.MechSpy:Add(self.Lang.Debuff.Critter[KBM.Lang], -1, "playerDebuff", self.Tiger)
	KBM.Defaults.MechObj.Assign(self.Tiger)

	self.Spider.MechRef.Critter = KBM.MechSpy:Add(self.Lang.Debuff.Critter[KBM.Lang], -1, "playerDebuff", self.Spider)
	KBM.Defaults.MechObj.Assign(self.Spider)


	-- Assign Alerts and Timers to Triggers
	self.Twyl.Triggers.Quake = KBM.Trigger:Create(self.Lang.Debuff.Quake[KBM.Lang], "playerDebuff", self.Twyl)
	self.Twyl.Triggers.Quake:AddAlert(self.Twyl.AlertsRef.Quake, true)
	self.Twyl.Triggers.Sacrifice = KBM.Trigger:Create(self.Lang.Debuff.Sacrifice[KBM.Lang], "playerDebuff", self.Twyl)
	self.Twyl.Triggers.Sacrifice:AddSpy(self.Twyl.MechRef.Sacrifice)
	self.Twyl.Triggers.SacrificeEnd = KBM.Trigger:Create(self.Lang.Debuff.Sacrifice[KBM.Lang], "playerBuffRemove", self.Twyl)
	self.Twyl.Triggers.SacrificeEnd:AddStop(self.Twyl.MechRef.Sacrifice)

	self.Twyl.Triggers.Spider = KBM.Trigger:Create(self.Lang.Debuff.Spider[KBM.Lang], "playerDebuff", self.Twyl)
	self.Twyl.Triggers.Spider:AddSpy(self.Twyl.MechRef.Spider)
	self.Twyl.Triggers.SpiderEnd = KBM.Trigger:Create(self.Lang.Debuff.Spider[KBM.Lang], "playerBuffRemove", self.Twyl)
	self.Twyl.Triggers.SpiderEnd:AddStop(self.Twyl.MechRef.Spider)

	self.Twyl.Triggers.PhaseTwo = KBM.Trigger:Create(self.Lang.Say.Summer[KBM.Lang], "say", self.Twyl)
	self.Twyl.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Twyl.Triggers.PhaseThree = KBM.Trigger:Create(self.Lang.Say.Autumn[KBM.Lang], "say", self.Twyl)
	self.Twyl.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Twyl.Triggers.PhaseFinal = KBM.Trigger:Create(self.Lang.Say.Winter[KBM.Lang], "say", self.Twyl)
	self.Twyl.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)

	self.Twyl.Triggers.Fire = KBM.Trigger:Create(self.Lang.Ability.Fire[KBM.Lang], "cast", self.Twyl)
	self.Twyl.Triggers.Fire:AddAlert(self.Twyl.AlertsRef.Fire)
	self.Twyl.Triggers.Fire:AddTimer(self.Twyl.TimersRef.Fire)
	
	self.Twyl.Triggers.FireUp = KBM.Trigger:Create(self.Lang.Ability.Fire[KBM.Lang], "buff", self.Twyl)
	self.Twyl.Triggers.FireUp:AddAlert(self.Twyl.AlertsRef.Fire)
	self.Twyl.Triggers.FireOff = KBM.Trigger:Create(self.Lang.Ability.Fire[KBM.Lang], "buffRemove", self.Twyl)
	self.Twyl.Triggers.FireOff:AddStop(self.Twyl.AlertsRef.Fire)

	self.Twyl.Triggers.Nova = KBM.Trigger:Create(self.Lang.Ability.Nova[KBM.Lang], "cast", self.Twyl)
	self.Twyl.Triggers.Nova:AddAlert(self.Twyl.AlertsRef.Nova)
	self.Twyl.Triggers.Nova:AddTimer(self.Twyl.TimersRef.Nova)
	self.Twyl.Triggers.NovaInt = KBM.Trigger:Create(self.Lang.Ability.Nova[KBM.Lang], "interrupt", self.Twyl)
	self.Twyl.Triggers.NovaInt:AddStop(self.Twyl.AlertsRef.Nova)

	self.Wolf.Triggers.Critter = KBM.Trigger:Create(self.Lang.Debuff.Critter[KBM.Lang], "playerDebuff", self.Wolf)
	self.Wolf.Triggers.Critter:AddAlert(self.Wolf.AlertsRef.Critter, true)
	self.Wolf.Triggers.Critter:AddSpy(self.Wolf.MechRef.Critter)
	self.Wolf.Triggers.Critter = KBM.Trigger:Create(self.Wolf.Name, "death", self.Wolf)
	self.Wolf.Triggers.Critter:AddStop(self.Wolf.MechRef.Critter)

	self.Tiger.Triggers.Critter = KBM.Trigger:Create(self.Lang.Debuff.Critter[KBM.Lang], "playerDebuff", self.Tiger)
	self.Tiger.Triggers.Critter:AddAlert(self.Tiger.AlertsRef.Critter, true)
	self.Tiger.Triggers.Critter:AddSpy(self.Tiger.MechRef.Critter)
	self.Tiger.Triggers.Critter = KBM.Trigger:Create(self.Tiger.Name, "death", self.Tiger)
	self.Tiger.Triggers.Critter:AddStop(self.Tiger.MechRef.Critter)

	self.Spider.Triggers.Critter = KBM.Trigger:Create(self.Lang.Debuff.Critter[KBM.Lang], "playerDebuff", self.Spider)
	self.Spider.Triggers.Critter:AddAlert(self.Spider.AlertsRef.Critter, true)
	self.Spider.Triggers.Critter:AddSpy(self.Spider.MechRef.Critter)
	self.Spider.Triggers.Critter = KBM.Trigger:Create(self.Spider.Name, "death", self.Spider)
	self.Spider.Triggers.Critter:AddStop(self.Spider.MechRef.Critter)
	
	self.Twyl.CastBar = KBM.CastBar:Add(self, self.Twyl, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end