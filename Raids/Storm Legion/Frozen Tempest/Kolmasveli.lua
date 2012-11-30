-- Kolmasveli and Toinenveli Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDFTKT_Settings = nil
chKBMSLRDFTKT_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local FT = KBM.BossMod["RFrozen_Tempest"]

local KT = {
	Enabled = true,
	Directory = FT.Directory,
	File = "Kolmasveli.lua",
	Instance = FT.Name,
	InstanceObj = FT,
	HasPhases = true,
	Lang = {},
	ID = "RKolmasveli",
	Object = "KT",
}

KBM.RegisterMod(KT.ID, KT)

-- Main Unit Dictionary
KT.Lang.Unit = {}
KT.Lang.Unit.Kolmasveli = KBM.Language:Add("Kolmasveli")
KT.Lang.Unit.Kolmasveli:SetGerman()
KT.Lang.Unit.KolmasveliShort = KBM.Language:Add("Kolmasveli")
KT.Lang.Unit.KolmasveliShort:SetGerman()
KT.Lang.Unit.Toinenveli = KBM.Language:Add("Toinenveli")
KT.Lang.Unit.Toinenveli:SetGerman()
KT.Lang.Unit.ToinenveliShort = KBM.Language:Add("Toinenveli")
KT.Lang.Unit.ToinenveliShort:SetGerman()

-- Ability Dictionary
KT.Lang.Ability = {}

-- Description Dictionary
KT.Lang.Main = {}
KT.Lang.Main.Descript = KBM.Language:Add("Kolmasveli and Toinenveli")
KT.Lang.Main.Descript:SetGerman("Kolmasveli und Toinenveli")
KT.Descript = KT.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
KT.Kolmasveli = {
	Mod = KT,
	Level = "??",
	Active = false,
	Name = KT.Lang.Unit.Kolmasveli[KBM.Lang],
	NameShort = KT.Lang.Unit.KolmasveliShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "none",
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

KT.Toinenveli = {
	Mod = KT,
	Level = "??",
	Active = false,
	Name = KT.Lang.Unit.Toinenveli[KBM.Lang],
	NameShort = KT.Lang.Unit.ToinenveliShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "none",
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

function KT:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kolmasveli.Name] = self.Kolmasveli,
		[self.Toinenveli.Name] = self.Toinenveli,
	}
end

function KT:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kolmasveli.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Kolmasveli.Settings.TimersRef,
		-- AlertsRef = self.Kolmasveli.Settings.AlertsRef,
	}
	KBMSLRDFTKT_Settings = self.Settings
	chKBMSLRDFTKT_Settings = self.Settings
	
end

function KT:SwapSettings(bool)

	if bool then
		KBMSLRDFTKT_Settings = self.Settings
		self.Settings = chKBMSLRDFTKT_Settings
	else
		chKBMSLRDFTKT_Settings = self.Settings
		self.Settings = KBMSLRDFTKT_Settings
	end

end

function KT:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDFTKT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDFTKT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDFTKT_Settings = self.Settings
	else
		KBMSLRDFTKT_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function KT:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDFTKT_Settings = self.Settings
	else
		KBMSLRDFTKT_Settings = self.Settings
	end	
end

function KT:Castbar(units)
end

function KT:RemoveUnits(UnitID)
	if self.Kolmasveli.UnitID == UnitID then
		self.Kolmasveli.Available = false
		return true
	end
	return false
end

function KT:Death(UnitID)
	if self.Kolmasveli.UnitID == UnitID then
		self.Kolmasveli.Dead = true
		return true
	end
	return false
end

function KT:UnitHPCheck(uDetails, unitID)	
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
					if BossObj.Name == self.Kolmasveli.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Kolmasveli.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Kolmasveli.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Kolmasveli
			end
		end
	end
end

function KT:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Kolmasveli.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function KT:Timer()	
end

function KT:DefineMenu()
	self.Menu = FT.Menu:CreateEncounter(self.Kolmasveli, self.Enabled)
end

function KT:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Kolmasveli)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Kolmasveli)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Kolmasveli.CastBar = KBM.CastBar:Add(self, self.Kolmasveli)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end