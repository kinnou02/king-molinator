-- Dread Lord Goloch Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEEDG_Settings = nil
chKBMSLRDEEDG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local EE = KBM.BossMod["REndless_Eclipse"]

local DLG = {
	Enabled = true,
	Directory = EE.Directory,
	File = "Goloch.lua",
	Instance = EE.Name,
	InstanceObj = EE,
	HasPhases = true,
	Lang = {},
	ID = "Goloch",
	Object = "DLG",
	Enrage = 6 * 60 + 15,
}

DLG.Goloch = {
	Mod = DLG,
	Level = "??",
	Active = false,
	Name = "Dread Lord Goloch",
	NameShort = "Goloch",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	UTID = "UFD8602DF11B09969",
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
			FirstGlimpse = KBM.Defaults.TimerObj.Create("yellow"),
			Glimpse = KBM.Defaults.TimerObj.Create("yellow"),
			FirstBaleful = KBM.Defaults.TimerObj.Create("red"),
			Baleful = KBM.Defaults.TimerObj.Create("red"),
			FirstDays = KBM.Defaults.TimerObj.Create("orange"),
			Days = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			Days = KBM.Defaults.AlertObj.Create("orange"),
			DaysUp = KBM.Defaults.AlertObj.Create("orange"),
		},
		MechRef = {
			Enabled = true,
			Glimpse = KBM.Defaults.MechObj.Create("yellow"),
			Curse = KBM.Defaults.MechObj.Create("red"),
			Torment = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

KBM.RegisterMod(DLG.ID, DLG)

-- Main Unit Dictionary
DLG.Lang.Unit = {}
DLG.Lang.Unit.Goloch = KBM.Language:Add("Dread Lord Goloch")
DLG.Lang.Unit.Goloch:SetGerman("Schreckensfürst Goloch")
DLG.Lang.Unit.Goloch:SetFrench("Seigneur lugubre Goloch")
DLG.Lang.Unit.GolochShort = KBM.Language:Add("Goloch")
DLG.Lang.Unit.GolochShort:SetGerman("Goloch")
DLG.Lang.Unit.GolochShort:SetFrench("Goloch")

-- Ability Dictionary
DLG.Lang.Ability = {}
DLG.Lang.Ability.Days = KBM.Language:Add("End of Days")
DLG.Lang.Ability.Days:SetFrench("La fin des temps")
DLG.Lang.Ability.Glimpse = KBM.Language:Add("Glimpse of Mortality")
DLG.Lang.Ability.Glimpse:SetFrench("Lueur de mortalité")
DLG.Lang.Ability.Baleful = KBM.Language:Add("Baleful Smash")
DLG.Lang.Ability.Baleful:SetFrench("Coup funeste")

-- Debuff Dictionary
DLG.Lang.Debuff = {}
DLG.Lang.Debuff.Dread = KBM.Language:Add("Dread Scythe")
DLG.Lang.Debuff.Dread:SetFrench("Faux d'effroi")
DLG.Lang.Debuff.Curse = KBM.Language:Add("Gatekeeper's Curse")
DLG.Lang.Debuff.Curse:SetFrench("Malédiction du gardien")
DLG.Lang.Debuff.Torment = KBM.Language:Add("Lingering Torment")
DLG.Lang.Debuff.Torment:SetFrench("Tourment persistant")
DLG.Lang.Debuff.Glimpse = KBM.Language:Add("Glimpse of Mortality")
DLG.Lang.Debuff.Glimpse:SetFrench("Lueur de mortalité")

-- Buff Dictionary
DLG.Lang.Buff = {}
DLG.Lang.Buff.Days = KBM.Language:Add("End of Days")
DLG.Lang.Buff.Days:SetFrench("La fin des temps")
DLG.Lang.Buff.Quiet = KBM.Language:Add("Quiet Fears")

-- Description Dictionary
DLG.Lang.Main = {}
DLG.Lang.Main.Descript = KBM.Language:Add("Dread Lord Goloch")
DLG.Lang.Main.Descript:SetGerman("Schreckensfürst Goloch")
DLG.Lang.Main.Descript:SetFrench("Seigneur lugubre Goloch")
DLG.Descript = DLG.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
DLG.Goloch.Name = DLG.Lang.Unit.Goloch[KBM.Lang]
DLG.Goloch.NameShort = DLG.Lang.Unit.GolochShort[KBM.Lang]

function DLG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Goloch.Name] = self.Goloch,
	}
end

function DLG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Goloch.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Goloch.Settings.TimersRef,
		AlertsRef = self.Goloch.Settings.AlertsRef,
		MechRef = self.Goloch.Settings.MechRef,
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMSLRDEEDG_Settings = self.Settings
	chKBMSLRDEEDG_Settings = self.Settings
	
end

function DLG:SwapSettings(bool)

	if bool then
		KBMSLRDEEDG_Settings = self.Settings
		self.Settings = chKBMSLRDEEDG_Settings
	else
		chKBMSLRDEEDG_Settings = self.Settings
		self.Settings = KBMSLRDEEDG_Settings
	end

end

function DLG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDEEDG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDEEDG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDEEDG_Settings = self.Settings
	else
		KBMSLRDEEDG_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function DLG:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDEEDG_Settings = self.Settings
	else
		KBMSLRDEEDG_Settings = self.Settings
	end	
end

function DLG:Castbar(units)
end

function DLG:RemoveUnits(UnitID)
	if self.Goloch.UnitID == UnitID then
		self.Goloch.Available = false
		return true
	end
	return false
end

function DLG:Death(UnitID)
	if self.Goloch.UnitID == UnitID then
		self.Goloch.Dead = true
		return true
	end
	return false
end

function DLG:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if self.Bosses[uDetails.name] then
			local BossObj = self.Bosses[uDetails.name]
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Goloch then
					BossObj.CastBar:Create(unitID)
					KBM.TankSwap:Start(self.Lang.Debuff.Dread[KBM.Lang], unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Goloch, 0, 100)
				self.Phase = 1
				KBM.MechTimer:AddStart(self.Goloch.TimersRef.FirstGlimpse)
				KBM.MechTimer:AddStart(self.Goloch.TimersRef.FirstDays)
				KBM.MechTimer:AddStart(self.Goloch.TimersRef.FirstBaleful)
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Goloch then
					BossObj.CastBar:Create(unitID)
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return self.Goloch
		end
	end
end

function DLG:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Goloch.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function DLG:Timer()	
end

function DLG:DefineMenu()
	self.Menu = EE.Menu:CreateEncounter(self.Goloch, self.Enabled)
end

function DLG:Start()
	-- Create Timers
	self.Goloch.TimersRef.FirstGlimpse = KBM.MechTimer:Add(DLG.Lang.Ability.Glimpse[KBM.Lang], 45, false)
	self.Goloch.TimersRef.Glimpse = KBM.MechTimer:Add(DLG.Lang.Ability.Glimpse[KBM.Lang], 75, false)
	self.Goloch.TimersRef.FirstDays = KBM.MechTimer:Add(DLG.Lang.Ability.Days[KBM.Lang], 30, false)
	self.Goloch.TimersRef.Days = KBM.MechTimer:Add(DLG.Lang.Ability.Days[KBM.Lang], 45, false)
	self.Goloch.TimersRef.FirstBaleful = KBM.MechTimer:Add(DLG.Lang.Ability.Baleful[KBM.Lang], 80, false)
	self.Goloch.TimersRef.Baleful = KBM.MechTimer:Add(DLG.Lang.Ability.Baleful[KBM.Lang], 100, false)
	KBM.Defaults.TimerObj.Assign(self.Goloch)

	self.Goloch.TimersRef.FirstGlimpse:SetLink(self.Goloch.TimersRef.Glimpse)
	self.Goloch.TimersRef.FirstDays:SetLink(self.Goloch.TimersRef.Days)
	self.Goloch.TimersRef.FirstBaleful:SetLink(self.Goloch.TimersRef.Baleful)

	-- Create Alerts
	self.Goloch.AlertsRef.Days = KBM.Alert:Create(self.Lang.Ability.Days[KBM.Lang], nil, false, true, "orange")
	self.Goloch.AlertsRef.DaysUp = KBM.Alert:Create(self.Lang.Ability.Days[KBM.Lang], nil, true, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Goloch)

	--self.Goloch.AlertsRef.DaysUp:SetLink(self.Goloch.AlertsRef.Days)

	-- Create Spies
	self.Goloch.MechRef.Glimpse = KBM.MechSpy:Add(self.Lang.Debuff.Glimpse[KBM.Lang], nil, "playerDebuff", self.Goloch)
	self.Goloch.MechRef.Curse = KBM.MechSpy:Add(self.Lang.Debuff.Curse[KBM.Lang], nil, "playerDebuff", self.Goloch)
	self.Goloch.MechRef.Torment = KBM.MechSpy:Add(self.Lang.Debuff.Torment[KBM.Lang], nil, "playerDebuff", self.Goloch)
	KBM.Defaults.MechObj.Assign(self.Goloch)
	
	-- Assign Alerts and Timers to Triggers
	self.Goloch.Triggers.Glimpse = KBM.Trigger:Create(self.Lang.Ability.Glimpse[KBM.Lang], "channel", self.Goloch)
	self.Goloch.Triggers.Glimpse:AddTimer(self.Goloch.TimersRef.Glimpse)
	self.Goloch.Triggers.GlimpseDebuff = KBM.Trigger:Create(self.Lang.Debuff.Glimpse[KBM.Lang], "playerDebuff", self.Goloch)
	self.Goloch.Triggers.GlimpseDebuff:AddSpy(self.Goloch.MechRef.Glimpse)

	self.Goloch.Triggers.Days = KBM.Trigger:Create(self.Lang.Ability.Days[KBM.Lang], "channel", self.Goloch)
	self.Goloch.Triggers.Days:AddTimer(self.Goloch.TimersRef.Days)
	self.Goloch.Triggers.Days:AddAlert(self.Goloch.AlertsRef.Days)

	self.Goloch.Triggers.DaysUp = KBM.Trigger:Create(self.Lang.Buff.Days[KBM.Lang], "buff", self.Goloch)
	self.Goloch.Triggers.DaysUp:AddAlert(self.Goloch.AlertsRef.DaysUp)
	self.Goloch.Triggers.DaysUpRem = KBM.Trigger:Create(self.Lang.Buff.Days[KBM.Lang], "buffRemove", self.Goloch)
	self.Goloch.Triggers.DaysUpRem:AddStop(self.Goloch.AlertsRef.DaysUp)

	self.Goloch.Triggers.Curse = KBM.Trigger:Create(self.Lang.Debuff.Curse[KBM.Lang], "playerBuff", self.Goloch)
	self.Goloch.Triggers.Curse:AddSpy(self.Goloch.MechRef.Curse)
	self.Goloch.Triggers.CurseRem = KBM.Trigger:Create(self.Lang.Debuff.Curse[KBM.Lang], "playerBuffRemove", self.Goloch)
	self.Goloch.Triggers.CurseRem:AddStop(self.Goloch.MechRef.Curse)

	self.Goloch.Triggers.Torment = KBM.Trigger:Create(self.Lang.Debuff.Torment[KBM.Lang], "playerBuff", self.Goloch)
	self.Goloch.Triggers.Torment:AddSpy(self.Goloch.MechRef.Torment)
	self.Goloch.Triggers.TormentRem = KBM.Trigger:Create(self.Lang.Debuff.Torment[KBM.Lang], "playerBuffRemove", self.Goloch)
	self.Goloch.Triggers.TormentRem:AddStop(self.Goloch.MechRef.Torment)

	self.Goloch.Triggers.Baleful = KBM.Trigger:Create(self.Lang.Ability.Baleful[KBM.Lang], "channel", self.Goloch)
	self.Goloch.Triggers.Baleful:AddTimer(self.Goloch.TimersRef.Baleful)
	
	self.Goloch.CastBar = KBM.CastBar:Add(self, self.Goloch)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end