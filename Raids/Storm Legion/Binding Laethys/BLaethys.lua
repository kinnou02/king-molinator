-- Laethys Boss Mod for King Boss Mods
-- Written by Apuch@Zaviel
-- Copyright 2014
--

KBMSLRDBALAE_Settings = nil
chKBMSLRDBALAE_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local BL = KBM.BossMod["RBinding_Laethys"]

local LAE = {
	Enabled = true,
	Directory = BL.Directory,
	File = "BLaethys.lua",
	Instance = BL.Name,
	InstanceObj = BL,
	HasPhases = true,
	Phase = 1,
	Enrage = 10 * 60,
	Lang = {},
	ID = "BLaethys",
	Object = "LAE",
}

LAE.Laethys = {
	Mod = LAE,
	Level = "??",
	Active = false,
	Name = "Laethys",
	NameShort = "Laethys",
	Dead = false,
	Available = false,
	Menu = {},
	UTID = {
		[1] = "U2FEC219438B99105",
		[2] = "U299BA3021BCD4CC5",
	},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	MechRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		 TimersRef = {
			Enabled = true,
			PhaseTwoTrans = KBM.Defaults.TimerObj.Create("dark_green"),
			FirstAuricEvocation = KBM.Defaults.TimerObj.Create("yellow"),
			AuricEvocation = KBM.Defaults.TimerObj.Create("yellow"),
			FirstMetallicOrbs = KBM.Defaults.TimerObj.Create("red"),
			MetallicOrbs = KBM.Defaults.TimerObj.Create("red"),
			FirstLaethicGold = KBM.Defaults.TimerObj.Create("orange"),
			LaethicGold = KBM.Defaults.TimerObj.Create("orange"),		
		 },
		 AlertsRef = {
			Enabled = true,
			AuricEvocation = KBM.Defaults.AlertObj.Create("yellow"),
			MetallicOrbs = KBM.Defaults.AlertObj.Create("red"),
			LaethicGold = KBM.Defaults.AlertObj.Create("orange"),
			HighReactor = KBM.Defaults.AlertObj.Create("dark_green"),
			LowReactor = KBM.Defaults.AlertObj.Create("purple"),
			GoldenSubjugation = KBM.Defaults.AlertObj.Create("blue"),
			MetallicOrb = KBM.Defaults.AlertObj.Create("red"),
		 },
		 MechRef = {
			Enabled = true,
			Reflect = KBM.Defaults.MechObj.Create("blue"),
		},
	}
}

KBM.RegisterMod(LAE.ID, LAE)

-- Main Unit Dictionary
LAE.Lang.Unit = {}
LAE.Lang.Unit.Laethys = KBM.Language:Add(LAE.Laethys.Name)
LAE.Lang.Unit.LaethysShort = KBM.Language:Add(LAE.Laethys.Name)

-- Ability Dictionary
LAE.Lang.Ability = {}
LAE.Lang.Ability.AuricEvocation = KBM.Language:Add("Auric Evocation")
LAE.Lang.Ability.MetallicOrbs = KBM.Language:Add("Metallic Orbs")
LAE.Lang.Ability.LaethicGold = KBM.Language:Add("Laethic Gold")
LAE.Lang.Ability.GoldenSubjugation = KBM.Language:Add("Golden Subjugation")
LAE.Lang.Ability.MetallicOrb = KBM.Language:Add("Metallic Orb")

-- Description Dictionary
LAE.Lang.Main = {}
LAE.Lang.Main.Descript = KBM.Language:Add("Laethys")
LAE.Descript = LAE.Lang.Main.Descript[KBM.Lang]

-- Mechanic Dictionary
LAE.Lang.Mechanic = {}

-- Debuff Dictionary
LAE.Lang.Debuff = {}
LAE.Lang.Debuff.EyeOfLaethys = KBM.Language:Add("Eye of Laethys")
LAE.Lang.Debuff.HighReactor = KBM.Language:Add("High Reactor")
LAE.Lang.Debuff.LowReactor = KBM.Language:Add("Low Reactor")
LAE.Lang.Debuff.GreedWrath = KBM.Language:Add("Greed's Wrath")
LAE.Lang.Debuff.GreedWrathID = "B4045A84A7A9D0EC4"
LAE.Lang.Debuff.EyeOfLaethysID = "BFF1913D98DE52A09"
-- Notify Dictionary
LAE.Lang.Notify = {}
LAE.Lang.Notify.Reflect = KBM.Language:Add("Laethys launches a molten flare at (%a+)%.")

-- Menu Dictionary
LAE.Lang.Menu = {}
LAE.Lang.Menu.FAuricEvocation = KBM.Language:Add("First Auric Evocation")
LAE.Lang.Menu.FMetallicOrbs = KBM.Language:Add("First Metallic Orbs")
LAE.Lang.Menu.FLaethicGold = KBM.Language:Add("First Laethic Gold")

-- Messages Dictionary
LAE.Lang.Messages = {}
LAE.Lang.Messages.Reflect = KBM.Language:Add("Reflect needed on:")

function LAE:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Laethys.Name] = self.Laethys
	}
end

function LAE:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Laethys.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		Laethys = {
			TimersRef = self.Laethys.Settings.TimersRef,
			AlertsRef = self.Laethys.Settings.AlertsRef,
		},
	}
	KBMSLRDBALAE_Settings = self.Settings
	chKBMSLRDBALAE_Settings = self.Settings
	
end

function LAE:SwapSettings(bool)

	if bool then
		KBMSLRDBALAE_Settings = self.Settings
		self.Settings = chKBMSLRDBALAE_Settings
	else
		chKBMSLRDBALAE_Settings = self.Settings
		self.Settings = KBMSLRDBALAE_Settings
	end

end

function LAE:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDBALAE_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDBALAE_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDBALAE_Settings = self.Settings
	else
		KBMSLRDBALAE_Settings = self.Settings
	end	
end

function LAE:SaveVars()	
	if KBM.Options.Character then
		chKBMSLRDBALAE_Settings = self.Settings
	else
		KBMSLRDBALAE_Settings = self.Settings
	end	
end

function LAE:Castbar(units)
end

function LAE:RemoveUnits(UnitID)
	if self.Laethys.UnitID == UnitID then
		self.Laethys.Available = false
		return true
	end
	return false
end

function LAE:Death(UnitID)
	if self.Laethys.UnitID == UnitID then
		self.Laethys.Dead = true
		return true
	end
	return false
end

function LAE:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if self.Bosses[uDetails.name] then
			local BossObj = self.Bosses[uDetails.name]
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Laethys then
					BossObj.CastBar:Create(unitID)
					KBM.TankSwap:Start(self.Lang.Debuff.EyeOfLaethysID, unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Laethys, 0, 100)
				self.Phase = 1
				KBM.MechTimer:AddStart(self.Laethys.TimersRef.FirstAuricEvocation)
				KBM.MechTimer:AddStart(self.Laethys.TimersRef.FirstMetallicOrbs)
				KBM.MechTimer:AddStart(self.Laethys.TimersRef.FirstLaethicGold)
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Laethys then
					BossObj.CastBar:Create(unitID)
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return self.Laethys
		end
	end
end

function LAE:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Laethys.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function LAE:Timer()	
end

function LAE:DefineMenu()
	self.Menu = BL.Menu:CreateEncounter(self.Laethys, self.Enabled)
end

function LAE:Start()
	self.Laethys.TimersRef.FirstAuricEvocation = KBM.MechTimer:Add(self.Lang.Ability.AuricEvocation[KBM.Lang], 10)
	self.Laethys.TimersRef.FirstAuricEvocation.MenuName = self.Lang.Menu.FAuricEvocation[KBM.Lang]
	self.Laethys.TimersRef.AuricEvocation = KBM.MechTimer:Add(self.Lang.Ability.AuricEvocation[KBM.Lang], 90)
	
	self.Laethys.TimersRef.FirstMetallicOrbs = KBM.MechTimer:Add(self.Lang.Ability.MetallicOrbs[KBM.Lang], 25)
	self.Laethys.TimersRef.FirstMetallicOrbs.MenuName = self.Lang.Menu.FMetallicOrbs[KBM.Lang]
	self.Laethys.TimersRef.MetallicOrbs = KBM.MechTimer:Add(self.Lang.Ability.MetallicOrbs[KBM.Lang], 90)
	
	self.Laethys.TimersRef.FirstLaethicGold = KBM.MechTimer:Add(self.Lang.Ability.LaethicGold[KBM.Lang], 60)
	self.Laethys.TimersRef.FirstLaethicGold.MenuName = self.Lang.Menu.FLaethicGold[KBM.Lang]
	self.Laethys.TimersRef.LaethicGold = KBM.MechTimer:Add(self.Lang.Ability.LaethicGold[KBM.Lang], 90)
	
	KBM.Defaults.TimerObj.Assign(self.Laethys)
	
	-- Create Mechanic Spies
	self.Laethys.MechRef.Reflect = KBM.MechSpy:Add(self.Lang.Messages.Reflect[KBM.Lang], 4, "mechanic", self.Laethys)
	KBM.Defaults.MechObj.Assign(self.Laethys)
	
	-- Create Alerts
	self.Laethys.AlertsRef.AuricEvocation = KBM.Alert:Create(self.Lang.Ability.AuricEvocation[KBM.Lang], nil, false, true, "yellow")
	
	self.Laethys.AlertsRef.MetallicOrbs = KBM.Alert:Create(self.Lang.Ability.MetallicOrbs[KBM.Lang], nil, false, true, "red")
	
	self.Laethys.AlertsRef.MetallicOrb = KBM.Alert:Create(self.Lang.Ability.MetallicOrb[KBM.Lang], nil, false, true, "red")
	
	self.Laethys.AlertsRef.LaethicGold = KBM.Alert:Create(self.Lang.Ability.LaethicGold[KBM.Lang], nil, true, true, "orange")
	
	self.Laethys.AlertsRef.HighReactor = KBM.Alert:Create(self.Lang.Debuff.HighReactor[KBM.Lang], nil, false, true, "dark_green")
	
	self.Laethys.AlertsRef.LowReactor = KBM.Alert:Create(self.Lang.Debuff.LowReactor[KBM.Lang], nil, false, true, "purple")
	
	self.Laethys.AlertsRef.GoldenSubjugation = KBM.Alert:Create(self.Lang.Ability.GoldenSubjugation[KBM.Lang], nil, false, true, "blue")
	
	KBM.Defaults.AlertObj.Assign(self.Laethys)

	self.Laethys.Triggers.HighReactor = KBM.Trigger:Create(self.Lang.Debuff.HighReactor[KBM.Lang], "playerBuff", self.Laethys)
	self.Laethys.Triggers.HighReactor:AddAlert(self.Laethys.AlertsRef.HighReactor, true)
	
	self.Laethys.Triggers.LowReactor = KBM.Trigger:Create(self.Lang.Debuff.LowReactor[KBM.Lang], "playerBuff", self.Laethys)
	self.Laethys.Triggers.LowReactor:AddAlert(self.Laethys.AlertsRef.LowReactor, true)
	
	self.Laethys.Triggers.AuricEvocation = KBM.Trigger:Create(self.Lang.Ability.AuricEvocation[KBM.Lang], "channel", self.Laethys)
	self.Laethys.Triggers.AuricEvocation:AddTimer(self.Laethys.TimersRef.AuricEvocation)
	self.Laethys.Triggers.AuricEvocation:AddAlert(self.Laethys.AlertsRef.AuricEvocation)

	self.Laethys.Triggers.LaethicGold = KBM.Trigger:Create(self.Lang.Ability.LaethicGold[KBM.Lang], "cast", self.Laethys)
	self.Laethys.Triggers.LaethicGold:AddAlert(self.Laethys.AlertsRef.LaethicGold)
	self.Laethys.Triggers.LaethicGold:AddTimer(self.Laethys.TimersRef.LaethicGold)
	self.Laethys.Triggers.LaethicGold1 = KBM.Trigger:Create(self.Lang.Ability.LaethicGold[KBM.Lang], "channel", self.Laethys)
	self.Laethys.Triggers.LaethicGold1:AddAlert(self.Laethys.AlertsRef.LaethicGold)
	
	self.Laethys.Triggers.MetallicOrbs = KBM.Trigger:Create(self.Lang.Ability.MetallicOrbs[KBM.Lang], "cast", self.Laethys)
	self.Laethys.Triggers.MetallicOrbs:AddAlert(self.Laethys.AlertsRef.MetallicOrbs)
	self.Laethys.Triggers.MetallicOrbs:AddTimer(self.Laethys.TimersRef.MetallicOrbs)
	
	self.Laethys.Triggers.MetallicOrb = KBM.Trigger:Create(self.Lang.Ability.MetallicOrb[KBM.Lang], "cast", self.Laethys)
	self.Laethys.Triggers.MetallicOrb:AddAlert(self.Laethys.AlertsRef.MetallicOrb)
	
	self.Laethys.Triggers.GoldenSubjugation = KBM.Trigger:Create(self.Lang.Ability.GoldenSubjugation[KBM.Lang], "channel", self.Laethys)
	self.Laethys.Triggers.GoldenSubjugation:AddAlert(self.Laethys.AlertsRef.GoldenSubjugation)
	
	self.Laethys.Triggers.Reflect = KBM.Trigger:Create(self.Lang.Notify.Reflect[KBM.Lang], "notify", self.Laethys)
	self.Laethys.Triggers.Reflect:AddSpy(self.Laethys.MechRef.Reflect)
	
	self.Laethys.CastBar = KBM.Castbar:Add(self, self.Laethys)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
end