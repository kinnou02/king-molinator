-- Atrophinius Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMPFAN_Settings = nil
chKBMPFAN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PF = KBM.BossMod["Primeval Feast"]

local AN = {
	Directory = PF.Directory,
	File = "Atrophinius.lua",
	Enabled = true,
	Instance = PF.Name,
	Lang = {},
	Enrage = 6 * 60,
	ID = "PF_Atrophinius",
	Object = "AN",
}

AN.Atrophinius = {
	Mod = AN,
	Level = "??",
	Active = false,
	Name = "Grandmaster Atrophinius",
	NameShort = "Atrophinius",
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
			Rampage = KBM.Defaults.AlertObj.Create("red"),
			Anguish = KBM.Defaults.AlertObj.Create("purple"),
		},
		TimersRef = {
			Enabled = true,
			Rampage = KBM.Defaults.TimerObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Anguish = KBM.Defaults.MechObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(AN.ID, AN)

-- Main Unit Dictionary
AN.Lang.Unit = {}
AN.Lang.Unit.Atrophinius = KBM.Language:Add(AN.Atrophinius.Name)
AN.Lang.Unit.Atrophinius:SetGerman("Großmeister Atrophinius")
AN.Lang.Unit.Atrophinius:SetFrench("Grand maître Atrophinius")
AN.Lang.Unit.AtrophiniusShort = KBM.Language:Add("Atrophinius")
AN.Lang.Unit.AtrophiniusShort:SetGerman("Atrophinius")
AN.Lang.Unit.AtrophiniusShort:SetFrench("Atrophinius")
AN.Lang.Unit.Cask = KBM.Language:Add("Green Label Cask")
AN.Lang.Unit.Cask:SetFrench("Tonneau de Label Vert")
AN.Lang.Unit.Cask:SetGerman("Fass mit Grünem Siegel")

-- Buff Dictionary
AN.Lang.Buff = {}
AN.Lang.Buff.Rampage = KBM.Language:Add("Rampage")
AN.Lang.Buff.Rampage:SetFrench("Déchaînement")
AN.Lang.Buff.Rampage:SetGerman("Amoklauf")

-- Ability Dictionary
AN.Lang.Ability = {}
AN.Lang.Ability.Anguish = KBM.Language:Add("Song of Anguish")
AN.Lang.Ability.Anguish:SetGerman("Lied der Seelenqual")

AN.Atrophinius.Name = AN.Lang.Unit.Atrophinius[KBM.Lang]
AN.Atrophinius.NameShort = AN.Lang.Unit.AtrophiniusShort[KBM.Lang]
AN.Descript = AN.Atrophinius.Name

AN.Cask = {
	Mod = AN,
	Level = "??",
	Active = false,
	Name = AN.Lang.Unit.Cask[KBM.Lang],
	Dead = false, 
	Available = false,
	Ignore = true,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

function AN:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Atrophinius.Name] = self.Atrophinius,
	}
	KBM_Boss[self.Atrophinius.Name] = self.Atrophinius	
end

function AN:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Atrophinius.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		AlertsRef = self.Atrophinius.Settings.AlertsRef,
		TimersRef = self.Atrophinius.Settings.TimersRef,
		MechRef = self.Atrophinius.Settings.MechRef,
	}
	KBMPFAN_Settings = self.Settings
	chKBMPFAN_Settings = self.Settings
end

function AN:SwapSettings(bool)

	if bool then
		KBMPFAN_Settings = self.Settings
		self.Settings = chKBMPFAN_Settings
	else
		chKBMPFAN_Settings = self.Settings
		self.Settings = KBMPFAN_Settings
	end

end

function AN:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPFAN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPFAN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPFAN_Settings = self.Settings
	else
		KBMPFAN_Settings = self.Settings
	end	
end

function AN:SaveVars()	
	if KBM.Options.Character then
		chKBMPFAN_Settings = self.Settings
	else
		KBMPFAN_Settings = self.Settings
	end	
end

function AN:Castbar(units)
end

function AN:RemoveUnits(UnitID)
	if self.Atrophinius.UnitID == UnitID then
		self.Atrophinius.Available = false
		return true
	end
	return false
end

function AN:Death(UnitID)
	if self.Atrophinius.UnitID == UnitID then
		self.Atrophinius.Dead = true
		return true
	end
	return false
end

function AN.PhaseTwo()
	AN.PhaseObj.Objectives:Remove()
	AN.PhaseObj.Objectives:AddPercent(AN.Atrophinius.Name, 0, 75)
	AN.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	AN.Phase = 2
end

function AN:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Atrophinius.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Atrophinius.Dead = false
					self.Atrophinius.Casting = false
					self.Atrophinius.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Atrophinius.Name, 75, 100)
					self.PhaseObj.Objectives:AddDeath(self.Cask.Name, 3)
					self.Phase = 1
				end
				self.Atrophinius.UnitID = unitID
				self.Atrophinius.Available = true
				return self.Atrophinius
			else
				if not self.Bosses[uDetails.name].UnitList[unitID] then
					SubBossObj = {
						Mod = AN,
						Level = "??",
						Name = uDetails.name,
						Dead = false,
						Casting = false,
						UnitID = unitID,
						Available = true,
					}
					self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
				else
					self.Bosses[uDetails.name].UnitList[unitID].Available = true
					self.Bosses[uDetails.name].UnitList[unitID].UnitID = unitID
				end
				return self.Bosses[uDetails.name].UnitList[unitID]							
			end
		end
	end
end

function AN:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Type == "multi" then
			BossObj.UnitList = {}
		else
			BossObj.Available = false
			BossObj.UnitID = nil
			BossObj.Dead = false
			if BossObj.CastBar then
				if BossObj.CastBar.Active then
					BossObj.CastBar:Remove()
				end
			end
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())	
end

function AN:Timer()
	
end

function AN.Atrophinius:SetTimers(bool)	
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

function AN.Atrophinius:SetAlerts(bool)
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

function AN:DefineMenu()
	self.Menu = PF.Menu:CreateEncounter(self.Atrophinius, self.Enabled)
end

function AN:Start()
	-- Create Timers
	self.Atrophinius.TimersRef.Rampage = KBM.MechTimer:Add(self.Lang.Buff.Rampage[KBM.Lang], 46)
	KBM.Defaults.TimerObj.Assign(self.Atrophinius)

	-- Create Alerts
	self.Atrophinius.AlertsRef.Rampage = KBM.Alert:Create(self.Lang.Buff.Rampage[KBM.Lang], nil, false, true, "red")
	self.Atrophinius.AlertsRef.Anguish = KBM.Alert:Create(self.Lang.Ability.Anguish[KBM.Lang], nil, true, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Atrophinius)
	
	-- Create Spies
	self.Atrophinius.MechRef.Anguish = KBM.MechSpy:Add(self.Lang.Ability.Anguish[KBM.Lang], nil, "playerDebuff", self.Atrophinius)
	KBM.Defaults.MechObj.Assign(self.Atrophinius)
	
	-- Assign Alerts and Timers to Triggers
	self.Atrophinius.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Atrophinius)
	self.Atrophinius.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Atrophinius.Triggers.Rampage = KBM.Trigger:Create(self.Lang.Buff.Rampage[KBM.Lang], "buff", self.Atrophinius)
	self.Atrophinius.Triggers.Rampage:AddAlert(self.Atrophinius.AlertsRef.Rampage)
	self.Atrophinius.Triggers.Rampage:AddTimer(self.Atrophinius.TimersRef.Rampage)
	self.Atrophinius.Triggers.AnguishWarn = KBM.Trigger:Create(self.Lang.Ability.Anguish[KBM.Lang], "cast", self.Atrophinius)
	self.Atrophinius.Triggers.AnguishWarn:AddAlert(self.Atrophinius.AlertsRef.Anguish)
	self.Atrophinius.Triggers.Anguish = KBM.Trigger:Create(self.Lang.Ability.Anguish[KBM.Lang], "playerBuff", self.Atrophinius)
	self.Atrophinius.Triggers.Anguish:AddSpy(self.Atrophinius.MechRef.Anguish)
	
	self.Atrophinius.CastBar = KBM.CastBar:Add(self, self.Atrophinius, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end