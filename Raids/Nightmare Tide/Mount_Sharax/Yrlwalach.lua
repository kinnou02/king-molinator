-- Yrlwalach Boss Mod for King Boss Mods
-- Written by Kapnia
--

KBMNTRDMSYRL_Settings = nil
chKBMNTRDMSYRL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local MS = KBM.BossMod["RMount_Sharax"]

local YRL = {
	Directory = MS.Directory,
	File = "Yrlwalach.lua",
	Enabled = true,
	Instance = MS.Name,
	InstanceObj = MS,
	Lang = {},
	Enrage = 7 * 60,
	ID = "Yrlwalach",
	Object = "YRL",
}

KBM.RegisterMod(YRL.ID, YRL)

-- Main Unit Dictionary
YRL.Lang.Unit = {}
YRL.Lang.Unit.Yrlwalach = KBM.Language:Add("Yrlwalach")

-- Ability Dictionary
YRL.Lang.Ability = {}

-- Verbose Dictionary
YRL.Lang.Verbose = {}

-- Buff Dictionary
YRL.Lang.Buff = {}

-- Debuff Dictionary
YRL.Lang.Debuff = {}
YRL.Lang.Debuff.ContainedDepths = KBM.Language:Add("The Contained Depths") --Zone ablegen
YRL.Lang.Debuff.ContainedDepthsID = "B0796521D436835BB"
YRL.Lang.Debuff.CommunalSuffering = KBM.Language:Add("Communal Suffering") --Dispell
YRL.Lang.Debuff.CommunalSufferingID = "B18991A7DEFCD3CCD "
YRL.Lang.Debuff.WISB = KBM.Language:Add("When Infinity Stares Back") --Stacks
YRL.Lang.Debuff.WISBID = "B5183088E34D0A16E "

-- Description Dictionary
YRL.Lang.Main = {}

YRL.Descript = YRL.Lang.Unit.Yrlwalach[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
YRL.Yrlwalach = {
	Mod = YRL,
	Level = "??",
	Active = false,
	Name = YRL.Lang.Unit.Yrlwalach[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	--TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U51C2A7E834AE8121",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		--	Enabled = true,
		--},
		AlertsRef = {
			Enabled = true,
			ContainedDepths = KBM.Defaults.AlertObj.Create("yellow"),
			WISB = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			ContainedDepths = KBM.Defaults.MechObj.Create("yellow"),
			CommunalSuffering = KBM.Defaults.MechObj.Create("red"),
			WISB = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

function YRL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Yrlwalach.Name] = self.Yrlwalach,
	}
end

function YRL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Yrlwalach.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		--MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		--TimersRef = self.Yrlwalach.Settings.TimersRef,
		AlertsRef = self.Yrlwalach.Settings.AlertsRef,
		MechRef = self.Yrlwalach.Settings.MechRef,
	}
	KBMNTRDMSYRL_Settings = self.Settings
	chKBMNTRDMSYRL_Settings = self.Settings
	
end

function YRL:SwapSettings(bool)

	if bool then
		KBMNTRDMSYRL_Settings = self.Settings
		self.Settings = chKBMNTRDMSYRL_Settings
	else
		chKBMNTRDMSYRL_Settings = self.Settings
		self.Settings = KBMNTRDMSYRL_Settings
	end

end

function YRL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDMSYRL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDMSYRL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRDMSYRL_Settings = self.Settings
	else
		KBMNTRDMSYRL_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function YRL:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTRDMSYRL_Settings = self.Settings
	else
		KBMNTRDMSYRL_Settings = self.Settings
	end	
end

function YRL:Castbar(units)
end

function YRL:RemoveUnits(UnitID)
	if self.Yrlwalach.UnitID == UnitID then
		self.Yrlwalach.Available = false
		return true
	end
	return false
end

function YRL:Death(UnitID)
	if self.Yrlwalach.UnitID == UnitID then
		self.Yrlwalach.Dead = true
		return true
	end
	return false
end

function YRL:UnitHPCheck(uDetails, unitID)	
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
				if BossObj == self.Yrlwalach then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Yrlwalach, 0, 100)
				self.Phase = 1
				if BossObj == self.Yrlwalach then
					
				end
			else
				if BossObj == self.Yrlwalach then
					if not KBM.TankSwap.Active then
						
					end
				end
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					if BossObj == self.Yrlwalach then
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

function YRL:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Yrlwalach.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function YRL:Timer()	
end

function YRL:Start()

	-- Create Timers
	
	
	-- Create Alerts
	self.Yrlwalach.AlertsRef.ContainedDepths = KBM.Alert:Create(self.Lang.Debuff.ContainedDepths[KBM.Lang], nil, true, true, "yellow")
	self.Yrlwalach.AlertsRef.WISB = KBM.Alert:Create(self.Lang.Debuff.WISB[KBM.Lang], nil, true, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Yrlwalach)

	-- Create Spies
	self.Yrlwalach.MechRef.ContainedDepths = KBM.MechSpy:Add(self.Lang.Debuff.ContainedDepths[KBM.Lang], nil, "playerDebuff", self.Yrlwalach)
	self.Yrlwalach.MechRef.CommunalSuffering = KBM.MechSpy:Add(self.Lang.Debuff.CommunalSuffering[KBM.Lang], nil, "playerDebuff", self.Yrlwalach)
	self.Yrlwalach.MechRef.WISB = KBM.MechSpy:Add(self.Lang.Debuff.WISB[KBM.Lang], nil, "playerDebuff", self.Yrlwalach)
	KBM.Defaults.MechObj.Assign(self.Yrlwalach)

	-- Assign Alerts and Timers to Triggers
	self.Yrlwalach.Triggers.ContainedDepths = KBM.Trigger:Create(self.Lang.Debuff.ContainedDepths[KBM.Lang], "playerDebuff", self.Yrlwalach)
	self.Yrlwalach.Triggers.ContainedDepths:AddAlert(self.Yrlwalach.AlertsRef.ContainedDepths, true)
	self.Yrlwalach.Triggers.ContainedDepths:AddSpy(self.Yrlwalach.MechRef.ContainedDepths)
	
	self.Yrlwalach.Triggers.WISB = KBM.Trigger:Create(self.Lang.Debuff.WISB[KBM.Lang], "playerDebuff", self.Yrlwalach)
	self.Yrlwalach.Triggers.WISB:SetMinStack(8)
	self.Yrlwalach.Triggers.WISB:AddAlert(self.Yrlwalach.AlertsRef.WISB, true)
	self.Yrlwalach.Triggers.WISB:AddSpy(self.Yrlwalach.MechRef.WISB)
	
	self.Yrlwalach.Triggers.CommunalSuffering = KBM.Trigger:Create(self.Lang.Debuff.CommunalSuffering[KBM.Lang], "playerDebuff", self.Yrlwalach)
	self.Yrlwalach.Triggers.CommunalSuffering:AddSpy(self.Yrlwalach.MechRef.CommunalSuffering)
	
	--self.Yrlwalach.Triggers.ContainedDepthsBuff = KBM.Trigger:Create(self.Lang.Debuff.ContainedDepths[KBM.Lang], "playerDebuff", self.Yrlwalach)
	--self.Yrlwalach.Triggers.ContainedDepthsBuff:AddSpy(self.Yrlwalach.MechRef.ContainedDepths)
	
	--self.Yrlwalach.Triggers.CommunalSufferingBuff = KBM.Trigger:Create(self.Lang.Debuff.CommunalSuffering[KBM.Lang], "playerDebuff", self.Yrlwalach)
	--self.Yrlwalach.Triggers.CommunalSufferingBuff:AddSpy(self.Yrlwalach.MechRef.CommunalSuffering)
	
	self.Yrlwalach.CastBar = KBM.Castbar:Add(self, self.Yrlwalach)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end