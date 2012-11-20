-- Vladmal Prime Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMVP_Settings = nil
chKBMVP_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local HK = KBM.BossMod["Hammerknell"]

local VP = {
	Enabled = true,
	Directory = HK.Directory,
	File = "Prime.lua",
	Instance = HK.Name,
	InstanceObj = HK,
	Lang = {},
	Enrage = 60 * 11,
	Phase = 1,
	ID = "Prime",
	Object = "VP",
}

VP.Prime = {
	Mod = VP,
	Level = "??",
	Active = false,
	Name = "Vladmal Prime",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Alerts =  {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UTID = "U49DE7E732CA1C64A",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Flames = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			Flames = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(VP.ID, VP)

-- Main Unit Dictionary
VP.Lang.Unit = {}
VP.Lang.Unit.Prime = KBM.Language:Add(VP.Prime.Name)
VP.Lang.Unit.Prime:SetGerman()
VP.Lang.Unit.Prime:SetFrench()
VP.Lang.Unit.Prime:SetRussian("Владмал Прайм")
VP.Lang.Unit.Prime:SetKorean("블라드말 프라임")
VP.Prime.Name = VP.Lang.Unit.Prime[KBM.Lang]
VP.Descript = VP.Prime.Name
VP.Lang.Unit.PrimeShort = KBM.Language:Add("Vladmal")
VP.Lang.Unit.PrimeShort:SetGerman()
VP.Lang.Unit.PrimeShort:SetFrench()
VP.Lang.Unit.PrimeShort:SetRussian("Владмал")
VP.Lang.Unit.PrimeShort:SetKorean("블라드말")
VP.Prime.NameShort = VP.Lang.Unit.PrimeShort[KBM.Lang]

-- Ability Dictionary
VP.Lang.Ability = {}
VP.Lang.Ability.Flames = KBM.Language:Add("Ancient Flames")
VP.Lang.Ability.Flames:SetFrench("Flammes anciennes")
VP.Lang.Ability.Flames:SetGerman("Uralte Flammen")
VP.Lang.Ability.Flames:SetRussian("Древние огни")
VP.Lang.Ability.Flames:SetKorean("고대 불꽃")

function VP:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Prime.Name] = self.Prime,
	}
end

function VP:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),		
		Alerts = KBM.Defaults.Alerts(),
		CastBar = self.Prime.Settings.CastBar,
		TimersRef = self.Prime.Settings.TimersRef,
		AlertsRef = self.Prime.Settings.AlertsRef,
		PhaseMon = KBM.Defaults.PhaseMon(),
	}
	KBMVP_Settings = self.Settings
	chKBMVP_Settings = self.Settings
	
end

function VP:SwapSettings(bool)

	if bool then
		KBMVP_Settings = self.Settings
		self.Settings = chKBMVP_Settings
	else
		chKBMVP_Settings = self.Settings
		self.Settings = KBMVP_Settings
	end

end

function VP:LoadVars()
	local TargetLoad = nil
	if KBM.Options.Character then
		KBM.LoadTable(chKBMVP_Settings, self.Settings)
	else
		KBM.LoadTable(KBMVP_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMVP_Settings = self.Settings
	else
		KBMVP_Settings = self.Settings
	end
end

function VP:SaveVars()
	if KBM.Options.Character then
		chKBMVP_Settings = self.Settings
	else
		KBMVP_Settings = self.Settings
	end	
end

function VP:Castbar(units)
end

function VP:RemoveUnits(UnitID)
	if self.Prime.UnitID == UnitID then
		self.Prime.Available = false
		return true
	end
	return false
end

function VP:Death(UnitID)
	if self.Prime.UnitID == UnitID then
		self.Prime.Dead = true
		return true
	end
	return false
end

function VP:UnitHPCheck(uDetails, unitID)
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Prime.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Prime.CastBar:Create(unitID)
					self.Prime.Dead = false
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Prime.Name, 0, 100)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				end
				self.Prime.Casting = false
				self.Prime.UnitID = unitID
				self.Prime.Available = true
				return self.Prime
			end
		end
	end
end

function VP:Reset()
	self.EncounterRunning = false
	self.Prime.Available = false
	self.Prime.UnitID = nil
	self.Prime.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function VP:Timer()	
end

function VP:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Prime, self.Enabled)
end

function VP:Start()
	-- Timers
	self.Prime.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Ability.Flames[KBM.Lang], 31)
	
	-- Alerts
	self.Prime.AlertsRef.Flames = KBM.Alert:Create(self.Lang.Ability.Flames[KBM.Lang], 13, false, true, "orange")

	KBM.Defaults.TimerObj.Assign(self.Prime)
	KBM.Defaults.AlertObj.Assign(self.Prime)
	
	-- Add Mechanics to Triggers
	self.Prime.Triggers.Flames = KBM.Trigger:Create(self.Lang.Ability.Flames[KBM.Lang], "cast", self.Prime)
	self.Prime.Triggers.Flames:AddTimer(self.Prime.TimersRef.Flames)
	self.Prime.Triggers.FlamesDebuff = KBM.Trigger:Create(self.Lang.Ability.Flames[KBM.Lang], "playerBuff", self.Prime)
	self.Prime.Triggers.FlamesDebuff:AddAlert(self.Prime.AlertsRef.Flames, true)
	
	self.Prime.CastBar = KBM.CastBar:Add(self, self.Prime, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end