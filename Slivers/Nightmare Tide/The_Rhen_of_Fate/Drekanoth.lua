-- Drekanoth Boss Mod for King Boss Mods
-- Written by Noshei
-- Copyright 2012
--

KBMNTSLROFDRE_Settings = nil
chKBMNTSLROFDRE_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local ROF = KBM.BossMod["SThe_Rhen_of_Fate"]

local DRE = {
	Directory = ROF.Directory,
	File = "Drekanoth.lua",
	Enabled = true,
	Instance = ROF.Name,
	InstanceObj = ROF,
	Lang = {},
	Enrage = 8 * 60,
	ID = "SDrekanoth",
	Object = "DRE",
}

KBM.RegisterMod(DRE.ID, DRE)

-- Main Unit Dictionary
DRE.Lang.Unit = {}
DRE.Lang.Unit.Drekanoth = KBM.Language:Add("Drekanoth of Fate")
DRE.Lang.Unit.Drekanoth:SetFrench("Drekanoth du destin")

-- Ability Dictionary
DRE.Lang.Ability = {}

-- Verbose Dictionary
DRE.Lang.Verbose = {}

-- Buff Dictionary
DRE.Lang.Buff = {}
DRE.Lang.Buff.Power = KBM.Language:Add("Arcane Power")
DRE.Lang.Buff.Power:SetFrench("Énergie arcanique")
DRE.Lang.Buff.PowerID = "B24F5B8D42568AB56"

-- Debuff Dictionary
DRE.Lang.Debuff = {}
DRE.Lang.Debuff.Vulnerability = KBM.Language:Add("Arcane Vulnerability")
DRE.Lang.Debuff.Vulnerability:SetFrench("Vulnérabilité d'arcane")
DRE.Lang.Debuff.VulnerabilityID = "B7610E896163D0166"

-- Description Dictionary
DRE.Lang.Main = {}

DRE.Descript = DRE.Lang.Unit.Drekanoth[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
DRE.Drekanoth = {
	Mod = DRE,
	Level = "??",
	Active = false,
	Name = DRE.Lang.Unit.Drekanoth[KBM.Lang],
	Menu = {},
	Dead = false,
	--AlertsRef = {},
	--TimersRef = {},
	--MechRef = {},
	Available = false,
	UTID = "UFF30772C5A1997A3",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		--	Enabled = true,
		--},
		-- AlertsRef = {
			-- Enabled = true,
			
		-- },
		-- MechRef = {
			-- Enabled = true,
			
		-- },
	}
}

function DRE:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Drekanoth.Name] = self.Drekanoth,
	}
end

function DRE:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Drekanoth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		--MechTimer = KBM.Defaults.MechTimer(),
		--Alerts = KBM.Defaults.Alerts(),
		--MechSpy = KBM.Defaults.MechSpy(),
		--TimersRef = self.Drekanoth.Settings.TimersRef,
		AlertsRef = self.Drekanoth.Settings.AlertsRef,
		MechRef = self.Drekanoth.Settings.MechRef,
	}
	KBMNTSLROFDRE_Settings = self.Settings
	chKBMNTSLROFDRE_Settings = self.Settings
	
end

function DRE:SwapSettings(bool)

	if bool then
		KBMNTSLROFDRE_Settings = self.Settings
		self.Settings = chKBMNTSLROFDRE_Settings
	else
		chKBMNTSLROFDRE_Settings = self.Settings
		self.Settings = KBMNTSLROFDRE_Settings
	end

end

function DRE:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTSLROFDRE_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTSLROFDRE_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTSLROFDRE_Settings = self.Settings
	else
		KBMNTSLROFDRE_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function DRE:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTSLROFDRE_Settings = self.Settings
	else
		KBMNTSLROFDRE_Settings = self.Settings
	end	
end

function DRE:Castbar(units)
end

function DRE:RemoveUnits(UnitID)
	if self.Drekanoth.UnitID == UnitID then
		self.Drekanoth.Available = false
		return true
	end
	return false
end

function DRE:Death(UnitID)
	if self.Drekanoth.UnitID == UnitID then
		self.Drekanoth.Dead = true
		return true
	end
	return false
end

function DRE:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if not BossObj then
			BossObj = self.Bosses[uDetails.name]
		end
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Drekanoth then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Drekanoth, 0, 100)
				self.Phase = 1
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					if BossObj == self.Drekanoth then
						BossObj.CastBar:Remove()
						BossObj.CastBar:Create(unitID)
					end
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function DRE:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Drekanoth.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function DRE:Timer()	
end

function DRE:Start()

	-- Create Timers
	
	
	-- Create Alerts
	

	-- Create Spies
	

	-- Assign Alerts and Timers to Triggers
	
	
	self.Drekanoth.CastBar = KBM.Castbar:Add(self, self.Drekanoth)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end