-- Sparkwing Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFCSG_Settings = nil
chKBMEXFCSG_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Foul Cascade"]

local MOD = {
	Directory = Instance.Directory,
	File = "Sparkwing.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Sparkwing",
	Object = "MOD",
}

MOD.Sparkwing = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Sparkwing",
	NameShort = "Sparkwing",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U00CDD198543C9E9E",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Sparkwing = KBM.Language:Add(MOD.Sparkwing.Name)
MOD.Lang.Unit.Sparkwing:SetGerman("Funkenschwinge")
MOD.Lang.Unit.Sparkwing:SetFrench("Étinssaile")
MOD.Lang.Unit.Sparkwing:SetRussian("Искрокрыл")
MOD.Lang.Unit.Sparkwing:SetKorean("불똥 튀는 날개")
MOD.Sparkwing.Name = MOD.Lang.Unit.Sparkwing[KBM.Lang]
MOD.Descript = MOD.Sparkwing.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Sparkwing.Name] = self.Sparkwing,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Sparkwing.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Sparkwing.Settings.TimersRef,
		-- AlertsRef = self.Sparkwing.Settings.AlertsRef,
	}
	KBMEXFCSG_Settings = self.Settings
	chKBMEXFCSG_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFCSG_Settings = self.Settings
		self.Settings = chKBMEXFCSG_Settings
	else
		chKBMEXFCSG_Settings = self.Settings
		self.Settings = KBMEXFCSG_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFCSG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFCSG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFCSG_Settings = self.Settings
	else
		KBMEXFCSG_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFCSG_Settings = self.Settings
	else
		KBMEXFCSG_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Sparkwing.UnitID == UnitID then
		self.Sparkwing.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Sparkwing.UnitID == UnitID then
		self.Sparkwing.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Sparkwing.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Sparkwing.Dead = false
					self.Sparkwing.Casting = false
					self.Sparkwing.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Sparkwing.Name, 0, 100)
					self.Phase = 1
				end
				self.Sparkwing.UnitID = unitID
				self.Sparkwing.Available = true
				return self.Sparkwing
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Sparkwing.Available = false
	self.Sparkwing.UnitID = nil
	self.Sparkwing.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Sparkwing)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Sparkwing)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Sparkwing.CastBar = KBM.CastBar:Add(self, self.Sparkwing)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end