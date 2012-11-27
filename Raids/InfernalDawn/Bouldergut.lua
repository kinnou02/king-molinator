-- Bouldergut Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDBG_Settings = nil
chKBMINDBG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local BG = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Bouldergut.lua",
	Instance = IND.Name,
	InstanceObj = IND,
	HasPhases = true,
	Lang = {},
	ID = "Bouldergut",
	Object = "BG",
}

BG.Bouldergut = {
	Mod = BG,
	Level = "??",
	Active = false,
	Name = "Bouldergut",
	NameShort = "Bouldergut",
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U2D9D1FA518516BA1",
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

KBM.RegisterMod(BG.ID, BG)

-- Main Unit Dictionary
BG.Lang.Unit = {}
BG.Lang.Unit.Bouldergut = KBM.Language:Add("Bouldergut")
BG.Lang.Unit.Bouldergut:SetFrench("Rochentraille")
BG.Lang.Unit.Bouldergut:SetGerman("Felsbauch")
BG.Lang.Unit.Bouldergut:SetRussian("Камнежор")
BG.Lang.Unit.Bouldergut:SetKorean("보울더굿")
BG.Lang.Unit.BouldergutShort = KBM.Language:Add("Bouldergut")
BG.Lang.Unit.BouldergutShort:SetFrench("Rochentraille")
BG.Lang.Unit.BouldergutShort:SetGerman("Felsbauch")
BG.Lang.Unit.BouldergutShort:SetRussian("Камнежор")
BG.Lang.Unit.BouldergutShort:SetKorean("보울더굿")

-- Ability Dictionary
BG.Lang.Ability = {}

-- Description Dictionary
BG.Lang.Main = {}
BG.Lang.Main.Descript = KBM.Language:Add("Bouldergut")
BG.Lang.Main.Descript:SetFrench("Rochentraille")
BG.Lang.Main.Descript:SetGerman("Felsbauch")
BG.Lang.Main.Descript:SetRussian("Камнежор")
BG.Lang.Main.Descript:SetKorean("보울더굿")
BG.Descript = BG.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
BG.Bouldergut.Name = BG.Lang.Unit.Bouldergut[KBM.Lang]
BG.Bouldergut.NameShort = BG.Lang.Unit.BouldergutShort[KBM.Lang]

function BG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Bouldergut.Name] = self.Bouldergut,
	}
end

function BG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Bouldergut.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Bouldergut.Settings.TimersRef,
		-- AlertsRef = self.Bouldergut.Settings.AlertsRef,
	}
	KBMINDBG_Settings = self.Settings
	chKBMINDBG_Settings = self.Settings
	
end

function BG:SwapSettings(bool)

	if bool then
		KBMINDBG_Settings = self.Settings
		self.Settings = chKBMINDBG_Settings
	else
		chKBMINDBG_Settings = self.Settings
		self.Settings = KBMINDBG_Settings
	end

end

function BG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDBG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDBG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDBG_Settings = self.Settings
	else
		KBMINDBG_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function BG:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMINDBG_Settings = self.Settings
	else
		KBMINDBG_Settings = self.Settings
	end	
end

function BG:Castbar(units)
end

function BG:RemoveUnits(UnitID)
	if self.Bouldergut.UnitID == UnitID then
		self.Bouldergut.Available = false
		return true
	end
	return false
end

function BG:Death(UnitID)
	if self.Bouldergut.UnitID == UnitID then
		self.Bouldergut.Dead = true
		return true
	end
	return false
end

function BG:UnitHPCheck(uDetails, unitID)	
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
					if BossObj.Name == self.Bouldergut.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Bouldergut.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Bouldergut.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Bouldergut
			end
		end
	end
end

function BG:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Bouldergut.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function BG:Timer()	
end

function BG:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Bouldergut, self.Enabled)
end

function BG:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Bouldergut)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Bouldergut)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Bouldergut.CastBar = KBM.CastBar:Add(self, self.Bouldergut)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end