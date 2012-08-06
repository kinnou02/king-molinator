-- Maelforge Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDMF_Settings = nil
chKBMINDMF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local MF = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Maelforge.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Maelforge",
	Object = "MF",
}

MF.Maelforge = {
	Mod = MF,
	Level = "??",
	Active = false,
	Name = "Maelforge",
	NameShort = "Maelforge",
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

KBM.RegisterMod(MF.ID, MF)

-- Main Unit Dictionary
MF.Lang.Unit = {}
MF.Lang.Unit.Maelforge = KBM.Language:Add(MF.Maelforge.Name)
MF.Lang.Unit.Maelforge:SetGerman("Flammenmaul")
MF.Lang.Unit.Maelforge:SetFrench()
MF.Lang.Unit.Maelforge:SetRussian("Маэлфорж")
MF.Lang.Unit.Maelforge:SetKorean("마엘포지")
MF.Lang.Unit.Cannon = KBM.Language:Add("Magma Cannon")
MF.Lang.Unit.Cannon:SetGerman("Magmakanone")
MF.Lang.Unit.CanShort = KBM.Language:Add("Cannon")
MF.Lang.Unit.CanShort:SetGerman("Kanone")
MF.Lang.Unit.Egg = KBM.Language:Add("Ember Egg")
MF.Lang.Unit.Egg:SetGerman("Glutei")
MF.Lang.Unit.EggShort = KBM.Language:Add("Egg")
MF.Lang.Unit.EggShort:SetGerman("Ei")

-- Ability Dictionary
MF.Lang.Ability = {}

-- Notify Dictionary
MF.Lang.Notify = {}
MF.Lang.Notify.PhaseTwo = KBM.Language:Add("Maelforge: Carcera, I will break you and spill your doom across this world. These weaklings shall be the first to die.")
MF.Lang.Notify.PhaseFinal = KBM.Language:Add("Maelforge: My children will taste your flesh. You whet the appetite of apocalypse.")
MF.Lang.Notify.Victory = KBM.Language:Add("Carcera: This world is saved from abomination, but its doom rises on ashen wings.")

-- Description Dictionary
MF.Lang.Descript = {}
MF.Lang.Descript.Main = KBM.Language:Add("Maelforge - Ember Eggs")
MF.Lang.Descript.Main:SetGerman("Flammenmaul - Gluteier")

MF.Maelforge.Name = MF.Lang.Unit.Maelforge[KBM.Lang]
MF.Maelforge.NameShort = MF.Lang.Unit.Maelforge[KBM.Lang]
MF.Descript = MF.Lang.Descript.Main[KBM.Lang]

MF.Cannon = {
	Mod = MF,
	Level = "??",
	Name = MF.Lang.Unit.Cannon[KBM.Lang],
	NameShort = MF.Lang.Unit.CanShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	Type = "multi",
}

MF.Egg = {
	Mod = MF,
	Level = "??",
	Name = MF.Lang.Unit.Egg[KBM.Lang],
	NameShort = MF.Lang.Unit.EggShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	Type = "multi",
}

function MF:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maelforge.Name] = self.Maelforge,
		[self.Cannon.Name] = self.Cannon,
		[self.Egg.Name] = self.Egg,
	}
	KBM_Boss[self.Maelforge.Name] = self.Maelforge
	KBM.SubBoss[self.Cannon.Name] = self.Cannon
	KBM.SubBoss[self.Egg.Name] = self.Egg
end

function MF:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maelforge.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Maelforge.Settings.TimersRef,
		-- AlertsRef = self.Maelforge.Settings.AlertsRef,
	}
	KBMINDMF_Settings = self.Settings
	chKBMINDMF_Settings = self.Settings
	
end

function MF:SwapSettings(bool)

	if bool then
		KBMINDMF_Settings = self.Settings
		self.Settings = chKBMINDMF_Settings
	else
		chKBMINDMF_Settings = self.Settings
		self.Settings = KBMINDMF_Settings
	end

end

function MF:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDMF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDMF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDMF_Settings = self.Settings
	else
		KBMINDMF_Settings = self.Settings
	end	
end

function MF:SaveVars()	
	if KBM.Options.Character then
		chKBMINDMF_Settings = self.Settings
	else
		KBMINDMF_Settings = self.Settings
	end	
end

function MF:Castbar(units)
end

function MF:RemoveUnits(UnitID)
	if self.Maelforge.UnitID == UnitID then
		self.Maelforge.Available = false
		return true
	end
	return false
end

function MF.PhaseTwo()
	if MF.Phase == 1 then
		MF.PhaseObj.Objectives:Remove()
		MF.PhaseObj:SetPhase("2")
		MF.PhaseObj.Objectives:AddDeath(MF.Cannon.Name, 6)
		MF.Phase = 2
	end
end

function MF.PhaseFinal()
	if MF.Phase < 3 then
		MF.PhaseObj.Objectives:Remove()
		MF.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		MF.PhaseObj.Objectives:AddDeath(MF.Egg.Name, 3)
		MF.Phase = 3
	end
end

function MF:Death(UnitID)
	if self.Cannon.UnitList[UnitID] then
		if self.Cannon.UnitList[UnitID].Dead == false then
			self.CannonCount = self.CannonCount + 1
			self.Cannon.UnitList[UnitID].Dead = true
			if self.CannonCount == 6 then
				self.PhaseFinal()
			end
		end
	end
	return false
end

function MF:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			local BossObj = self.Bosses[uDetails.name]
			if BossObj then
				if self.BossObj == self.Maelforge then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						self.Maelforge.Dead = false
						self.Maelforge.Casting = false
						self.Maelforge.CastBar:Create(unitID)
						self.PhaseObj:Start(self.StartTime)
						self.PhaseObj:SetPhase("1")
						self.PhaseObj.Objectives:AddPercent(self.Maelforge.Name, 50, 100)
						self.Phase = 1
					end
					self.Maelforge.UnitID = unitID
					self.Maelforge.Available = true
					return self.Maelforge
				elseif BossObj.UnitList then
					if not BossObj.UnitList[unitID] then
						SubBossObj = {
							Mod = MF,
							Level = "??",
							Name = uDetails.name,
							Dead = false,
							Casting = false,
							UnitID = unitID,
							Available = true,
						}
						BossObj.UnitList[unitID] = SubBossObj
						if BossObj == self.Cannon then
							if self.Phase == 1 then
								self.PhaseTwo()
								SubBossObj.CastBar = KBM.CastBar:Add(self, self.Cannon, false, true)
								SubBossObj.CastBar:Create(unitID)
							end
						elseif BossObj == self.Egg then
							if self.Phase < 3 then
								self.PhaseFinal()
							end
						end
					else
						BossObj.UnitList[unitID].Available = true
						BossObj.UnitList[unitID].UnitID = unitID
					end
					return BossObj.UnitList[unitID]
				end
			end
		end
	end
end

function MF:Reset()
	self.EncounterRunning = false
	self.PhaseObj:End(Inspect.Time.Real())
	self.Phase = 1
	self.CannonCount = 0
	for UnitID, BossObj in pairs(self.Cannon.UnitList) do
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
			BossObj.CastBar = nil
		end
	end
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

function MF:Timer()	
end

function MF.Maelforge:SetTimers(bool)	
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

function MF.Maelforge:SetAlerts(bool)
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

function MF:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Maelforge, self.Enabled)
end

function MF:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Maelforge)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Maelforge)
	
	-- Assign Alerts and Timers to Triggers
	self.Maelforge.Triggers.PhaseTwo = KBM.Trigger:Create(50, "percent", self.Maelforge)
	self.Maelforge.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Maelforge.Triggers.PhaseTwoN = KBM.Trigger:Create(self.Lang.Notify.PhaseTwo[KBM.Lang], "notify", self.Maelforge)
	self.Maelforge.Triggers.PhaseTwoN:AddPhase(self.PhaseTwo)
	self.Maelforge.Triggers.PhaseFinal = KBM.Trigger:Create(self.Lang.Notify.PhaseFinal[KBM.Lang], "notify", self.Maelforge)
	self.Maelforge.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	self.Maelforge.Triggers.Victory = KBM.Trigger:Create(self.Lang.Notify.Victory[KBM.Lang], "notify", self.Maelforge)
	self.Maelforge.Triggers.Victory:SetVictory()
	
	self.Maelforge.CastBar = KBM.CastBar:Add(self, self.Maelforge)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end