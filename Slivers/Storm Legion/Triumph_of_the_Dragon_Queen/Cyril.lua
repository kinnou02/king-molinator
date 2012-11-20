-- Cyril Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSLSLTQCL_Settings = nil
chKBMSLSLTQCL_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local TDQ = KBM.BossMod["STriumph_of_the_Dragon_Queen"]

local CRL = {
	Directory = TDQ.Directory,
	File = "Cyril.lua",
	Enabled = true,
	Instance = TDQ.Name,
	InstanceObj = TDQ,
	Lang = {},
	--Enrage = 5 * 60,
	ID = "Cyril",
	Object = "CRL",
}

KBM.RegisterMod(CRL.ID, CRL)

-- Main Unit Dictionary
CRL.Lang.Unit = {}
CRL.Lang.Unit.Cyril = KBM.Language:Add("Cyril")
CRL.Lang.Unit.Cyril:SetGerman("Cyril")
CRL.Lang.Unit.CyrilShort = KBM.Language:Add("Cyril")
CRL.Lang.Unit.CyrilShort:SetGerman("Cyril")

-- Ability Dictionary
CRL.Lang.Ability = {}

-- Description Dictionary
CRL.Lang.Main = {}

CRL.Descript = CRL.Lang.Unit.Cyril[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
CRL.Cyril = {
	Mod = CRL,
	Level = "??",
	Active = false,
	Name = CRL.Lang.Unit.Cyril[KBM.Lang],
	NameShort = CRL.Lang.Unit.CyrilShort[KBM.Lang],
	Menu = {},
	Dead = false,
	-- AlertsRef = {},
	-- TimersRef = {},
	Available = false,
	UTID = "none",
	UnitID = nil,
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

function CRL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Cyril.Name] = self.Cyril,
	}
end

function CRL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Cyril.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Cyril.Settings.TimersRef,
		-- AlertsRef = self.Cyril.Settings.AlertsRef,
	}
	KBMSLSLTQCL_Settings = self.Settings
	chKBMSLSLTQCL_Settings = self.Settings
	
end

function CRL:SwapSettings(bool)

	if bool then
		KBMSLSLTQCL_Settings = self.Settings
		self.Settings = chKBMSLSLTQCL_Settings
	else
		chKBMSLSLTQCL_Settings = self.Settings
		self.Settings = KBMSLSLTQCL_Settings
	end

end

function CRL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLSLTQCL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLSLTQCL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLSLTQCL_Settings = self.Settings
	else
		KBMSLSLTQCL_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function CRL:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLSLTQCL_Settings = self.Settings
	else
		KBMSLSLTQCL_Settings = self.Settings
	end	
end

function CRL:Castbar(units)
end

function CRL:RemoveUnits(UnitID)
	if self.Cyril.UnitID == UnitID then
		self.Cyril.Available = false
		return true
	end
	return false
end

function CRL:Death(UnitID)
	if self.Cyril.UnitID == UnitID then
		self.Cyril.Dead = true
		return true
	end
	return false
end

function CRL:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if self.Bosses[unitDetails.name] then
				local BossObj = self.Bosses[unitDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Cyril.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SeCRLase("1")
					self.PhaseObj.Objectives:AddPercent(self.Cyril.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Cyril.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Cyril
			end
		end
	end
end

function CRL:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Cyril.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function CRL:Timer()	
end

function CRL:DefineMenu()
	self.Menu = TDQ.Menu:CreateEncounter(self.Cyril, self.Enabled)
end

function CRL:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Cyril)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Cyril)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Cyril.CastBar = KBM.CastBar:Add(self, self.Cyril)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end