-- Kaler Andrenos Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXAPKA_Settings = nil
chKBMEXAPKA_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Abyssal Precipice"]

local MOD = {
	Directory = Instance.Directory,
	File = "Andrenos.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Andrenos",
	Object = "MOD",
}

MOD.Andrenos = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Kaler Andrenos",
	NameShort = "Andrenos",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	UTID = "U590A07AD12D7FECD",
	TimeOut = 5,
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
MOD.Lang.Unit.Andrenos = KBM.Language:Add(MOD.Andrenos.Name)
MOD.Lang.Unit.Andrenos:SetGerman()
MOD.Lang.Unit.Andrenos:SetFrench()
MOD.Lang.Unit.Andrenos:SetRussian("Калер Андренос")
MOD.Lang.Unit.Andrenos:SetKorean("케일러 안드레노스")
MOD.Andrenos.Name = MOD.Lang.Unit.Andrenos[KBM.Lang]
MOD.Descript = MOD.Andrenos.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Andrenos")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Lang.Unit.AndShort:SetRussian("Андренос")
MOD.Lang.Unit.AndShort:SetKorean("안드레노스")
MOD.Andrenos.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Andrenos.Name] = self.Andrenos,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Andrenos.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Andrenos.Settings.TimersRef,
		-- AlertsRef = self.Andrenos.Settings.AlertsRef,
	}
	KBMEXAPKA_Settings = self.Settings
	chKBMEXAPKA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXAPKA_Settings = self.Settings
		self.Settings = chKBMEXAPKA_Settings
	else
		chKBMEXAPKA_Settings = self.Settings
		self.Settings = KBMEXAPKA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXAPKA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXAPKA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXAPKA_Settings = self.Settings
	else
		KBMEXAPKA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXAPKA_Settings = self.Settings
	else
		KBMEXAPKA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Andrenos.UnitID == UnitID then
		self.Andrenos.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Andrenos.UnitID == UnitID then
		self.Andrenos.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Andrenos.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Andrenos.Dead = false
					self.Andrenos.Casting = false
					self.Andrenos.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Andrenos.Name, 0, 100)
					self.Phase = 1
				end
				self.Andrenos.UnitID = unitID
				self.Andrenos.Available = true
				return self.Andrenos
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Andrenos.Available = false
	self.Andrenos.UnitID = nil
	self.Andrenos.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Andrenos)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Andrenos)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Andrenos.CastBar = KBM.CastBar:Add(self, self.Andrenos)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end