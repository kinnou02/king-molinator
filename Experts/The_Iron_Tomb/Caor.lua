-- Caor Ashstone Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXTITCA_Settings = nil
chKBMEXTITCA_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["The Iron Tomb"]

local MOD = {
	Directory = Instance.Directory,
	File = "Caor.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Caor",
	Object = "MOD",
}

MOD.Caor = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Caor Ashstone",
	NameShort = "Caor",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U7ECF03C84DCEB01A",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Caor = KBM.Language:Add(MOD.Caor.Name)
MOD.Lang.Unit.Caor:SetGerman("Caor Aschstein")
MOD.Lang.Unit.Caor:SetFrench()
MOD.Lang.Unit.Caor:SetRussian("Кер Пепельник")
MOD.Lang.Unit.Caor:SetKorean("카오르 애시스톤")
MOD.Caor.Name = MOD.Lang.Unit.Caor[KBM.Lang]
MOD.Descript = MOD.Caor.Name
MOD.Lang.Unit.CaorShort = KBM.Language:Add(MOD.Caor.NameShort)
MOD.Lang.Unit.CaorShort:SetGerman("Caor")
MOD.Lang.Unit.CaorShort:SetFrench("Caor")
MOD.Lang.Unit.CaorShort:SetRussian("Кер")
MOD.Lang.Unit.CaorShort:SetKorean("카오르")
MOD.Caor.NameShort = MOD.Lang.Unit.CaorShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Caor.Name] = self.Caor,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Caor.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Caor.Settings.TimersRef,
		-- AlertsRef = self.Caor.Settings.AlertsRef,
	}
	KBMEXTITCA_Settings = self.Settings
	chKBMEXTITCA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXTITCA_Settings = self.Settings
		self.Settings = chKBMEXTITCA_Settings
	else
		chKBMEXTITCA_Settings = self.Settings
		self.Settings = KBMEXTITCA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXTITCA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXTITCA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXTITCA_Settings = self.Settings
	else
		KBMEXTITCA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXTITCA_Settings = self.Settings
	else
		KBMEXTITCA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Caor.UnitID == UnitID then
		self.Caor.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Caor.UnitID == UnitID then
		self.Caor.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Caor.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Caor.Dead = false
					self.Caor.Casting = false
					self.Caor.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Caor.Name, 0, 100)
					self.Phase = 1
				end
				self.Caor.UnitID = unitID
				self.Caor.Available = true
				return self.Caor
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Caor.Available = false
	self.Caor.UnitID = nil
	self.Caor.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Caor, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Caor)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Caor)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Caor.CastBar = KBM.CastBar:Add(self, self.Caor)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end