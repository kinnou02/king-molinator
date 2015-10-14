-- Johan Boss Mod for King Boss Mods

KBMNTRDTFJOH_Settings = nil
chKBMNTRDTFJOH_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
return
end
local TF = KBM.BossMod["RTyrants_Forge"]

local JOH = {
	Directory = TF.Directory,
	File = "Johan.lua",
	Enabled = true,
	Instance = TF.Name,
	InstanceObj = TF,
	Lang = {},
	Enrage = 5 * 60 + 50,
	ID = "Johan",
	Object = "JOH",
}

KBM.RegisterMod(JOH.ID, JOH)

-- Main Unit Dictionary
JOH.Lang.Unit = {}
JOH.Lang.Unit.Johan = KBM.Language:Add("Johan")

-- Ability Dictionary
JOH.Lang.Ability = {}
JOH.Lang.Ability.Overload = KBM.Language:Add("Overload")
JOH.Lang.Ability.Overload:SetFrench("Surcharge")
JOH.Lang.Ability.Anchor = KBM.Language:Add("Drop Anchor")
JOH.Lang.Ability.Anchor:SetFrench("Ancrage")
JOH.Lang.Ability.Hammer = KBM.Language:Add("Johammer")
JOH.Lang.Ability.Hammer:SetFrench("Marteau de Johan")

-- Verbose Dictionary
JOH.Lang.Verbose = {}

-- Buff Dictionary
JOH.Lang.Buff = {}

-- Debuff Dictionary
JOH.Lang.Debuff = {}
JOH.Lang.Debuff.Parasite = KBM.Language:Add("Akvan Parasite")
JOH.Lang.Debuff.Parasite:SetFrench("Parasite akvan")
JOH.Lang.Debuff.Barrage = KBM.Language:Add("Cerebral Barrage")
JOH.Lang.Debuff.Barrage:SetFrench("Barrage cérébral")
JOH.Lang.Debuff.Sting = KBM.Language:Add("Firefin Sting")
JOH.Lang.Debuff.Shocking = KBM.Language:Add("Shocking Results")
JOH.Lang.Debuff.Shocking:SetFrench("Résultats choquants")

-- Description Dictionary
JOH.Lang.Main = {}

JOH.Descript = JOH.Lang.Unit.Johan[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
JOH.Johan = {
	Mod = JOH,
	Level = "??",
	Active = false,
	Name = JOH.Lang.Unit.Johan[KBM.Lang],
	Dead = false,	
	Available = false,
	Menu = {},
	UTID = "U548810C2597B7B79",
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
			Parasite = KBM.Defaults.AlertObj.Create("dark_green"),	
			Barrage = KBM.Defaults.AlertObj.Create("purple"),
			Sting = KBM.Defaults.AlertObj.Create("red"),	
			Overload = KBM.Defaults.AlertObj.Create("orange"),
			Anchor = KBM.Defaults.AlertObj.Create("cyan"),
			Hammer = KBM.Defaults.AlertObj.Create("yellow"),
			Shocking = KBM.Defaults.AlertObj.Create("blue"),
		},
		MechRef = {
			Enabled = true,
			Parasite = KBM.Defaults.MechObj.Create("dark_green"),
			Barrage = KBM.Defaults.MechObj.Create("purple"),
			Sting = KBM.Defaults.MechObj.Create("red"),
		},
	}
}

function JOH:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Johan.Name] = self.Johan,
	}
end

function JOH:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Johan.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		TimersRef = self.Johan.Settings.TimersRef,
		AlertsRef = self.Johan.Settings.AlertsRef,
		MechRef = self.Johan.Settings.MechRef,
	}
	KBMNTRDTFJOH_Settings = self.Settings
	chKBMNTRDTHJOH_Settings = self.Settings

end

function JOH:SwapSettings(bool)

	if bool then
		KBMNTRDTFJOH_Settings = self.Settings
		self.Settings = chKBMNTRDTFJOH_Settings
	else
		chKBMNTRDTFJOH_Settings = self.Settings
		self.Settings = KBMNTRDTFJOH_Settings
	end

end

function JOH:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDTFJOH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDTFJOH_Settings, self.Settings)
	end

	if KBM.Options.Character then
		chKBMNTRDTFJOH_Settings = self.Settings
	else
		KBMNTRDTFJOH_Settings = self.Settings
	end	

	self.Settings.Enabled = true
end

function JOH:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTRDTFJOH_Settings = self.Settings
	else
		KBMNTRDTFJOH_Settings = self.Settings
	end	
end

function JOH:Castbar(units)
end

function JOH:RemoveUnits(UnitID)
	if self.Johan.UnitID == UnitID then
		self.Johan.Available = false
		return true
	end
	return false
end

function JOH:Death(UnitID)
	if self.Johan.UnitID == UnitID then
		self.Johan.Dead = true
		return true
	end
	return false
end

function JOH:UnitHPCheck(uDetails, unitID)	
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
				self.PhaseObj.Objectives:AddPercent(self.Johan, 0, 100)
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

function JOH:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Johan.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function JOH:Timer()	
end

function JOHefineMenu()
	self.Menu = TF.Menu:CreateEncounter(self.Johan, self.Enabled)
end

function JOH:Start()

	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Johan)

	-- Create Alerts
	self.Johan.AlertsRef.Parasite = KBM.Alert:Create(self.Lang.Debuff.Parasite[KBM.Lang], nil, false, true, "dark_green")	
	self.Johan.AlertsRef.Barrage = KBM.Alert:Create(self.Lang.Debuff.Barrage[KBM.Lang], nil, false, true, "purple")	
	self.Johan.AlertsRef.Sting = KBM.Alert:Create(self.Lang.Debuff.Sting[KBM.Lang], nil, false, true, "red")
	self.Johan.AlertsRef.Overload = KBM.Alert:Create(self.Lang.Ability.Overload[KBM.Lang], nil, false, true, "orange")
	self.Johan.AlertsRef.Anchor = KBM.Alert:Create(self.Lang.Ability.Anchor[KBM.Lang], nil, false, true, "cyan")
	self.Johan.AlertsRef.Hammer = KBM.Alert:Create(self.Lang.Ability.Hammer[KBM.Lang], nil, false, true, "yellow")
	self.Johan.AlertsRef.Shocking = KBM.Alert:Create(self.Lang.Debuff.Shocking[KBM.Lang], nil, false, true, "blue")	
	KBM.Defaults.AlertObj.Assign(self.Johan)

	-- Create Spies
	self.Johan.MechRef.Parasite = KBM.MechSpy:Add(self.Lang.Debuff.Parasite[KBM.Lang], nil, "playerDebuff", self.Johan)
	self.Johan.MechRef.Barrage = KBM.MechSpy:Add(self.Lang.Debuff.Barrage[KBM.Lang], nil, "playerDebuff", self.Johan)
	self.Johan.MechRef.Sting = KBM.MechSpy:Add(self.Lang.Debuff.Sting[KBM.Lang], nil, "playerDebuff", self.Johan)	
	KBM.Defaults.MechObj.Assign(self.Johan)

	-- Assign Alerts and Timers to Triggers
	self.Johan.Triggers.Parasite = KBM.Trigger:Create(self.Lang.Debuff.Parasite[KBM.Lang], "playerDebuff", self.Johan)
	self.Johan.Triggers.Parasite:AddAlert(self.Johan.AlertsRef.Parasite, true)
	self.Johan.Triggers.Parasite:AddSpy(self.Johan.MechRef.Parasite)
	self.Johan.Triggers.Barrage = KBM.Trigger:Create(self.Lang.Debuff.Barrage[KBM.Lang], "playerDebuff", self.Johan)
	self.Johan.Triggers.Barrage:AddAlert(self.Johan.AlertsRef.Barrage, true)
	self.Johan.Triggers.Barrage:AddSpy(self.Johan.MechRef.Barrage)
	self.Johan.Triggers.Sting = KBM.Trigger:Create(self.Lang.Debuff.Sting[KBM.Lang], "playerDebuff", self.Johan)
	self.Johan.Triggers.Sting:AddAlert(self.Johan.AlertsRef.Sting, true)
	self.Johan.Triggers.Sting:AddSpy(self.Johan.MechRef.Sting)
	self.Johan.Triggers.ParasiteRem = KBM.Trigger:Create(self.Lang.Debuff.Parasite[KBM.Lang], "playerBuffRemove", self.Johan)
	self.Johan.Triggers.ParasiteRem:AddStop(self.Johan.AlertsRef.Parasite)
	self.Johan.Triggers.ParasiteRem:AddStop(self.Johan.MechRef.Parasite)
	self.Johan.Triggers.BarrageRem = KBM.Trigger:Create(self.Lang.Debuff.Barrage[KBM.Lang], "playerBuffRemove", self.Johan)
	self.Johan.Triggers.BarrageRem:AddStop(self.Johan.AlertsRef.Barrage)
	self.Johan.Triggers.BarrageRem:AddStop(self.Johan.MechRef.Barrage)
	self.Johan.Triggers.Overload = KBM.Trigger:Create(self.Lang.Ability.Overload[KBM.Lang], "channel", self.Johan)
	self.Johan.Triggers.Overload:AddAlert(self.Johan.AlertsRef.Overload)
	self.Johan.Triggers.Anchor = KBM.Trigger:Create(self.Lang.Ability.Anchor[KBM.Lang], "cast", self.Johan)
	self.Johan.Triggers.Anchor:AddAlert(self.Johan.AlertsRef.Anchor)
	self.Johan.Triggers.Hammer = KBM.Trigger:Create(self.Lang.Ability.Hammer[KBM.Lang], "cast", self.Johan)
	self.Johan.Triggers.Hammer:AddAlert(self.Johan.AlertsRef.Hammer)
	self.Johan.Triggers.HammerInt = KBM.Trigger:Create(self.Lang.Ability.Hammer[KBM.Lang], "interrupt", self.Johan)
	self.Johan.Triggers.HammerInt:AddStop(self.Johan.AlertsRef.Hammer)
	self.Johan.Triggers.Shocking = KBM.Trigger:Create(self.Lang.Debuff.Shocking[KBM.Lang], "buff", self.Johan)
	self.Johan.Triggers.Shocking:AddAlert(self.Johan.AlertsRef.Shocking)

	self.Johan.CastBar = KBM.Castbar:Add(self, self.Johan)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end