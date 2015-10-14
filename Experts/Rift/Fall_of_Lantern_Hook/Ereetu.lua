-- Emberlord Ereetu Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFOLHEE_Settings = nil
chKBMEXFOLHEE_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Fall of Lantern Hook"]

local MOD = {
	Directory = Instance.Directory,
	File = "Ereetu.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ereetu",
	Object = "MOD",
}

MOD.Ereetu = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Emberlord Ereetu",
	NameShort = "Ereetu",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U7B2D24F06CE4BE9A",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
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

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Ereetu = KBM.Language:Add(MOD.Ereetu.Name)
MOD.Lang.Unit.Ereetu:SetGerman("Glutfürst Ereetu") 
MOD.Lang.Unit.Ereetu:SetFrench("Seigneur de Braise Ereetu")
MOD.Lang.Unit.Ereetu:SetRussian("Владыка огня Эриту")
MOD.Lang.Unit.Ereetu:SetKorean("불시군주 에리두")
MOD.Ereetu.Name = MOD.Lang.Unit.Ereetu[KBM.Lang]
MOD.Descript = MOD.Ereetu.Name
MOD.Lang.Unit.EreShort = KBM.Language:Add("Ereetu")
MOD.Lang.Unit.EreShort:SetGerman()
MOD.Lang.Unit.EreShort:SetFrench()
MOD.Lang.Unit.EreShort:SetRussian("Эриту")
MOD.Lang.Unit.EreShort:SetKorean("에리두")
MOD.Ereetu.NameShort = MOD.Lang.Unit.EreShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ereetu.Name] = self.Ereetu,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ereetu.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Ereetu.Settings.TimersRef,
		-- AlertsRef = self.Ereetu.Settings.AlertsRef,
	}
	KBMEXFOLHEE_Settings = self.Settings
	chKBMEXFOLHEE_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFOLHEE_Settings = self.Settings
		self.Settings = chKBMEXFOLHEE_Settings
	else
		chKBMEXFOLHEE_Settings = self.Settings
		self.Settings = KBMEXFOLHEE_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFOLHEE_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFOLHEE_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFOLHEE_Settings = self.Settings
	else
		KBMEXFOLHEE_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFOLHEE_Settings = self.Settings
	else
		KBMEXFOLHEE_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Ereetu.UnitID == UnitID then
		self.Ereetu.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Ereetu.UnitID == UnitID then
		self.Ereetu.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Ereetu.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ereetu.Dead = false
					self.Ereetu.Casting = false
					self.Ereetu.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Ereetu.Name, 0, 100)
					self.Phase = 1
				end
				self.Ereetu.UnitID = unitID
				self.Ereetu.Available = true
				return self.Ereetu
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Ereetu.Available = false
	self.Ereetu.UnitID = nil
	self.Ereetu.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Ereetu)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Ereetu)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Ereetu.CastBar = KBM.Castbar:Add(self, self.Ereetu)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end