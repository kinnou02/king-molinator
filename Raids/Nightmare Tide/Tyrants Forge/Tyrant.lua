-- Tyrant Boss Mod for King Boss Mods

KBMNTRDTFMTC_Settings = nil
chKBMNTRDTFMTC_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local TF = KBM.BossMod["RTyrants_Forge"]

local MTC = {
	Directory = TF.Directory,
	File = "Tyrant.lua",
	Enabled = true,
	Instance = TF.Name,
	InstanceObj = TF,
	Lang = {},
	Enrage = 9 * 60,
	ID = "Tyrant",
	Object = "MTC",
}

KBM.RegisterMod(MTC.ID, MTC)

-- Main Unit Dictionary
MTC.Lang.Unit = {}
MTC.Lang.Unit.Tyrant = KBM.Language:Add("Tyrant")
MTC.Lang.Unit.Tyrant:SetFrench("Crucia")

-- Ability Dictionary
MTC.Lang.Ability = {}

-- Verbose Dictionary
MTC.Lang.Verbose = {}

-- Buff Dictionary
MTC.Lang.Buff = {}

-- Debuff Dictionary
MTC.Lang.Debuff = {}
MTC.Lang.Debuff.Static = KBM.Language:Add("Static Feedback")

-- Description Dictionary
MTC.Lang.Main = {}

MTC.Descript = MTC.Lang.Unit.Tyrant[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
MTC.Tyrant = {
	Mod = MTC,
	Level = "??",
	Active = false,
	Name = MTC.Lang.Unit.Tyrant[KBM.Lang],
	Dead = false,	
	Available = false,
	Menu = {},
	UTID = "U0FB9FE7860741CA0",
	UnitID = nil,
	Castbar = nil,
	--TimersRef = {},	
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		-- Enabled = false,
		--},
		AlertsRef = {
			Enabled = true,
			Static = KBM.Defaults.AlertObj.Create("purple"),	
		},
		MechRef = {
			Enabled = true,
			Static = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

function MTC:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Tyrant.Name] = self.Tyrant,
	}
end

function MTC:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Tyrant.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		TimersRef = self.Tyrant.Settings.TimersRef,
		AlertsRef = self.Tyrant.Settings.AlertsRef,
		MechRef = self.Tyrant.Settings.MechRef,
	}
	KBMNTRDTFMTC_Settings = self.Settings
	chKBMNTRDTHMTC_Settings = self.Settings

end

function MTC:SwapSettings(bool)

	if bool then
		KBMNTRDTFMTC_Settings = self.Settings
		self.Settings = chKBMNTRDTFMTC_Settings
	else
		chKBMNTRDTFMTC_Settings = self.Settings
		self.Settings = KBMNTRDTFMTC_Settings
	end

end

function MTC:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDTFMTC_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDTFMTC_Settings, self.Settings)
	end

	if KBM.Options.Character then
		chKBMNTRDTFMTC_Settings = self.Settings
	else
		KBMNTRDTFMTC_Settings = self.Settings
	end	

	self.Settings.Enabled = true
end

function MTC:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTRDTFMTC_Settings = self.Settings
	else
		KBMNTRDTFMTC_Settings = self.Settings
	end	
end

function MTC:Castbar(units)
end

function MTC:RemoveUnits(UnitID)
	if self.Tyrant.UnitID == UnitID then
		self.Tyrant.Available = false
		return true
	end
	return false
end

function MTCeath(UnitID)
	if self.Tyrant.UnitID == UnitID then
		self.Tyrant.Dead = true
		return true
	end
	return false
end

function MTC:UnitHPCheck(uDetails, unitID)	
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
				if BossObj.CastBar then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Tyrant, 0, 100)
				self.Phase = 1
			end
		else
			BossObj.Dead = false
			BossObj.Casting = false
			if BossObj.UnitID ~= unitID then
				BossObj.CastBar:Remove()
				BossObj.CastBar:Create(unitID)
			end
		end
		BossObj.UnitID = unitID
		BossObj.Available = true
		return BossObj
	end
end

function MTC:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Tyrant.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MTC:Timer()	
end

function MTCefineMenu()
	self.Menu = TF.Menu:CreateEncounter(self.Tyrant, self.Enabled)
end

function MTC:Start()

	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Tyrant)

	-- Create Alerts
	self.Tyrant.AlertsRef.Static = KBM.Alert:Create(self.Lang.Debuff.Static[KBM.Lang], nil, false, true, "purple")	
	KBM.Defaults.AlertObj.Assign(self.Tyrant)

	-- Create Spies
	self.Tyrant.MechRef.Static = KBM.MechSpy:Add(self.Lang.Debuff.Static[KBM.Lang], nil, "playerDebuff", self.Tyrant)
	KBM.Defaults.MechObj.Assign(self.Tyrant)

	-- Assign Alerts and Timers to Triggers
	self.Tyrant.Triggers.Static = KBM.Trigger:Create(self.Lang.Debuff.Static[KBM.Lang], "playerDebuff", self.Tyrant)
	self.Tyrant.Triggers.Static:AddAlert(self.Tyrant.AlertsRef.Static, true)
	self.Tyrant.Triggers.Static:AddSpy(self.Tyrant.MechRef.Static)
	self.Tyrant.Triggers.StaticRem = KBM.Trigger:Create(self.Lang.Debuff.Static[KBM.Lang], "playerBuffRemove", self.Tyrant)
	self.Tyrant.Triggers.StaticRem:AddStop(self.Tyrant.AlertsRef.Static)
	self.Tyrant.Triggers.StaticRem:AddStop(self.Tyrant.MechRef.Static)
	
	self.Tyrant.CastBar = KBM.Castbar:Add(self, self.Tyrant)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end