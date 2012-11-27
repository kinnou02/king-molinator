-- Oludare the Firehoof Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFOLHOF_Settings = nil
chKBMEXFOLHOF_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Fall of Lantern Hook"]

local MOD = {
	Directory = Instance.Directory,
	File = "Oludare.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Oludare",
	Object = "MOD",
}

MOD.Oludare = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Oludare the Firehoof",
	NameShort = "Oludare",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U16A9DD714DD37727",
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

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Oludare = KBM.Language:Add(MOD.Oludare.Name)
MOD.Lang.Unit.Oludare:SetGerman("Oludare Feuerhuf")
MOD.Lang.Unit.Oludare:SetFrench("Oludare le Sabot de feu")
MOD.Lang.Unit.Oludare:SetRussian("Олюдейр Огнекопытный")
MOD.Lang.Unit.Oludare:SetKorean("화염발굽 올루데어")
MOD.Oludare.Name = MOD.Lang.Unit.Oludare[KBM.Lang]
MOD.Descript = MOD.Oludare.Name
MOD.Lang.Unit.OluShort = KBM.Language:Add("Oludare")
MOD.Lang.Unit.OluShort:SetGerman()
MOD.Lang.Unit.OluShort:SetFrench()
MOD.Lang.Unit.OluShort:SetRussian("Олюдейр")
MOD.Lang.Unit.OluShort:SetKorean("올루데어")
MOD.Oludare.NameShort = MOD.Lang.Unit.OluShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Oludare.Name] = self.Oludare,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Oludare.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Oludare.Settings.TimersRef,
		-- AlertsRef = self.Oludare.Settings.AlertsRef,
	}
	KBMEXFOLHOF_Settings = self.Settings
	chKBMEXFOLHOF_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFOLHOF_Settings = self.Settings
		self.Settings = chKBMEXFOLHOF_Settings
	else
		chKBMEXFOLHOF_Settings = self.Settings
		self.Settings = KBMEXFOLHOF_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFOLHOF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFOLHOF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFOLHOF_Settings = self.Settings
	else
		KBMEXFOLHOF_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFOLHOF_Settings = self.Settings
	else
		KBMEXFOLHOF_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Oludare.UnitID == UnitID then
		self.Oludare.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Oludare.UnitID == UnitID then
		self.Oludare.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Oludare.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Oludare.Dead = false
					self.Oludare.Casting = false
					self.Oludare.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Oludare.Name, 0, 100)
					self.Phase = 1
				end
				self.Oludare.UnitID = unitID
				self.Oludare.Available = true
				return self.Oludare
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Oludare.Available = false
	self.Oludare.UnitID = nil
	self.Oludare.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Oludare, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Oludare)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Oludare)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Oludare.CastBar = KBM.CastBar:Add(self, self.Oludare)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end