-- Threngar Boss Mod for King Boss Mods

KBMNTRDMSTGR_Settings = nil
chKBMNTRDMSTGR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
return
end
local MS = KBM.BossMod["RMount_Sharax"]

local TGR = {
	Directory = MS.Directory,
	File = "Threngar.lua",
	Enabled = true,
	Instance = MS.Name,
	InstanceObj = MS,
	Lang = {},
	Enrage = 12 * 60,
	ID = "Threngar",
	Object = "TGR",
}

KBM.RegisterMod(TGR.ID, TGR)

-- Main Unit Dictionary
TGR.Lang.Unit = {}
TGR.Lang.Unit.Threngar = KBM.Language:Add("Threngar")

-- Ability Dictionary
TGR.Lang.Ability = {}

-- Verbose Dictionary
TGR.Lang.Verbose = {}

-- Buff Dictionary
TGR.Lang.Buff = {}

-- Debuff Dictionary
TGR.Lang.Debuff = {}
TGR.Lang.Debuff.Conduit = KBM.Language:Add("Conduit of Martrodraum")

-- Description Dictionary
TGR.Lang.Main = {}

TGR.Descript = TGR.Lang.Unit.Threngar[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
TGR.Threngar = {
	Mod = TGR,
	Level = "??",
	Active = false,
	Name = TGR.Lang.Unit.Threngar[KBM.Lang],
	Dead = false,	
	Available = false,
	Menu = {},
	UTID = "U41F3C58835CFD3FF",
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
		Conduit = KBM.Defaults.AlertObj.Create("dark_green"),	
		},
		MechRef = {
		Enabled = true,
		Conduit = KBM.Defaults.MechObj.Create("dark_green"),
		},
	}
}

function TGR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Threngar.Name] = self.Threngar,
	}
end

function TGR:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Threngar.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		TimersRef = self.Threngar.Settings.TimersRef,
		AlertsRef = self.Threngar.Settings.AlertsRef,
		MechRef = self.Threngar.Settings.MechRef,
		}
	KBMNTRDMSTGR_Settings = self.Settings
	chKBMNTRDMSTGR_Settings = self.Settings

end

function TGR:SwapSettings(bool)

	if bool then
		KBMNTRDMSTGR_Settings = self.Settings
		self.Settings = chKBMNTRDMSTGR_Settings
	else
		chKBMNTRDMSTGR_Settings = self.Settings
		self.Settings = KBMNTRDMSTGR_Settings
	end

end

function TGR:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDMSTGR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDMSTGR_Settings, self.Settings)
	end

	if KBM.Options.Character then
		chKBMNTRDMSTGR_Settings = self.Settings
	else
		KBMNTRDMSTGR_Settings = self.Settings
	end	

	self.Settings.Enabled = true
end

function TGR:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTRDMSTGR_Settings = self.Settings
	else
		KBMNTRDMSTGR_Settings = self.Settings
	end	
end

function TGR:Castbar(units)
end

function TGR:RemoveUnits(UnitID)
	if self.Threngar.UnitID == UnitID then
		self.Threngar.Available = false
		return true
	end
	return false
end

function TGReath(UnitID)
	if self.Threngar.UnitID == UnitID then
		self.Threngar.Dead = true
		return true
	end
	return false
end

function TGR:UnitHPCheck(uDetails, unitID)	
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
				self.PhaseObj.Objectives:AddPercent(self.Threngar, 0, 100)
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

function TGR:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Threngar.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function TGR:Timer()	
end

function TGRefineMenu()
	self.Menu = MS.Menu:CreateEncounter(self.Threngar, self.Enabled)
end

function TGR:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Threngar)

	-- Create Alerts
	self.Threngar.AlertsRef.Conduit = KBM.Alert:Create(self.Lang.Debuff.Conduit[KBM.Lang], nil, false, true, "cyan")	
	KBM.Defaults.AlertObj.Assign(self.Threngar)

	-- Create Spies
	self.Threngar.MechRef.Conduit = KBM.MechSpy:Add(self.Lang.Debuff.Conduit[KBM.Lang], nil, "playerDebuff", self.Threngar)	
	KBM.Defaults.MechObj.Assign(self.Threngar)

	-- Assign Alerts and Timers to Triggers
	self.Threngar.Triggers.Conduit = KBM.Trigger:Create(self.Lang.Debuff.Conduit[KBM.Lang], "playerDebuff", self.Threngar)
	self.Threngar.Triggers.Conduit:AddAlert(self.Threngar.AlertsRef.Conduit, true)
	self.Threngar.Triggers.Conduit:AddSpy(self.Threngar.MechRef.Conduit)
	self.Threngar.Triggers.ConduitRem = KBM.Trigger:Create(self.Lang.Debuff.Conduit[KBM.Lang], "playerBuffRemove", self.Threngar)
	self.Threngar.Triggers.ConduitRem:AddStop(self.Threngar.AlertsRef.Conduit)
	self.Threngar.Triggers.ConduitRem:AddStop(self.Threngar.MechRef.Conduit)

	self.Threngar.CastBar = KBM.Castbar:Add(self, self.Threngar)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end