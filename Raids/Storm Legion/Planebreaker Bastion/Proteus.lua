-- Proteus Boss Mod for King Boss Mods
-- Written by Noshei
-- Copyright 2013
--

KBMSLRDPBPS_Settings = nil
chKBMSLRDPBPS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PB = KBM.BossMod["RPlanebreaker_Bastion"]

local PRT = {
	Enabled = true,
	Directory = PB.Directory,
	File = "Proteus.lua",
	Instance = PB.Name,
	InstanceObj = PB,
	HasPhases = true,
	Lang = {},
	ID = "Proteus",
	Object = "PRT",
	TimeoutOverride = true,
	Timeout = 20,
	Enrage = 9 * 60,
}

KBM.RegisterMod(PRT.ID, PRT)

-- Main Unit Dictionary
PRT.Lang.Unit = {}
PRT.Lang.Unit.Proteus = KBM.Language:Add("Proteus") -- ???
PRT.Lang.Unit.Proteus:SetFrench("Proteus")
PRT.Lang.Unit.Proteus:SetGerman("Proteus")
PRT.Lang.Unit.Construct = KBM.Language:Add("Quicksilver Construct")
PRT.Lang.Unit.Construct:SetGerman("Quecksilber-Konstrukt")
PRT.Lang.Unit.Hunter = KBM.Language:Add("Planar Hunter")
PRT.Lang.Unit.Hunter:SetGerman("Ebenenjäger")
PRT.Lang.Unit.Excreter = KBM.Language:Add("Toxin Excreter")
PRT.Lang.Unit.Excreter:SetGerman("Giftausscheider")
PRT.Lang.Unit.Stalk = KBM.Language:Add("Trasher Stalk")
PRT.Lang.Unit.Stalk:SetGerman("Zerstörerischer Pirscher")

-- Ability Dictionary
PRT.Lang.Ability = {}
PRT.Lang.Ability.Rampage = KBM.Language:Add("Unstoppable Rampage")
PRT.Lang.Ability.Rampage:SetFrench("Déchainement imparable")
PRT.Lang.Ability.Rampage:SetGerman("Unaufhaltsamer Amoklauf")

-- Debuff Dictionary
PRT.Lang.Debuff = {}
PRT.Lang.Debuff.Rampage = KBM.Language:Add("Unstoppable Rampage")
PRT.Lang.Debuff.Rampage:SetFrench("Déchainement imparable")
PRT.Lang.Debuff.Rampage:SetGerman("Unaufhaltsamer Amoklauf")
PRT.Lang.Debuff.RampageID = "B3563AA8E7A088296"
PRT.Lang.Debuff.Glacial = KBM.Language:Add("Glacial Lure")
PRT.Lang.Debuff.Glacial:SetFrench("Appât glacial")
PRT.Lang.Debuff.Glacial:SetGerman("Gletscherköder")
PRT.Lang.Debuff.GlacialID = "BFC35441E164B5B5E"

-- Buff Dictionary
PRT.Lang.Buff = {}
PRT.Lang.Buff.Chains = KBM.Language:Add("Web of Chains")  -- boss stun&dmg buff
PRT.Lang.Buff.Chains:SetGerman("Netz von Ketten")
--PRT.Lang.Buff.ChainsID = ???

-- Notify Dictionary
PRT.Lang.Notify = {}
PRT.Lang.Notify.Rampage = KBM.Language:Add("Proteus fixates on (%a*). Run!")
PRT.Lang.Notify.Rampage:SetFrench("Proteus se concentre sur (%a*). Fuyez!")
PRT.Lang.Notify.Rampage:SetGerman("Proteus fixiert sich auf (%a*). Rennt!")

-- Messages Dictionary
PRT.Lang.Messages = {}
PRT.Lang.Messages.Rampage = KBM.Language:Add("Rampage on YOU!")
PRT.Lang.Messages.Rampage:SetFrench("Déchainement sur TOI!")
PRT.Lang.Messages.Rampage:SetGerman("Amoklauf auf DIR!")
PRT.Lang.Messages.Glacial = KBM.Language:Add("Glacial Lure on YOU!")
PRT.Lang.Messages.Glacial:SetFrench("Appât Glacial sur TOI!")
PRT.Lang.Messages.Glacial:SetGerman("Gletscherköder auf DIR!")

-- Description Dictionary
PRT.Lang.Main = {}
PRT.Lang.Main.Encounter = KBM.Language:Add("Proteus")
PRT.Lang.Main.Encounter:SetFrench()
PRT.Lang.Main.Encounter:SetGerman()

PRT.Descript = PRT.Lang.Main.Encounter[KBM.Lang]

PRT.Proteus = {
	Mod = PRT,
	Level = "??",
	Active = false,
	Name = PRT.Lang.Unit.Proteus[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U0D7C7A923193D54C",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	--TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		-- TimersRef = {
			-- Enabled = false,
		-- },
		AlertsRef = {
			Enabled = true,
			Rampage = KBM.Defaults.AlertObj.Create("red"),
			Glacial = KBM.Defaults.AlertObj.Create("blue"),
		},
		MechRef = {
			Enabled = true,
			Rampage = KBM.Defaults.MechObj.Create("red"),
			Glacial = KBM.Defaults.MechObj.Create("blue"),
		},
	}
}

function PRT:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Proteus.Name] = self.Proteus,
	}

	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Override = true
				BossObj.Settings.CastBar.Multi = true
			end
		end
	end	
end

function PRT:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		Proteus = {
			CastBar = self.Proteus.Settings.CastBar,
			TimersRef = self.Proteus.Settings.TimersRef,
			AlertsRef = self.Proteus.Settings.AlertsRef,
			MechRef = self.Proteus.Settings.MechRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMSLRDPBPS_Settings = self.Settings
	chKBMSLRDPBPS_Settings = self.Settings
	
end

function PRT:SwapSettings(bool)

	if bool then
		KBMSLRDPBPS_Settings = self.Settings
		self.Settings = chKBMSLRDPBPS_Settings
	else
		chKBMSLRDPBPS_Settings = self.Settings
		self.Settings = KBMSLRDPBPS_Settings
	end

end

function PRT:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDPBPS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDPBPS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDPBPS_Settings = self.Settings
	else
		KBMSLRDPBPS_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function PRT:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDPBPS_Settings = self.Settings
	else
		KBMSLRDPBPS_Settings = self.Settings
	end	
end

function PRT:Castbar(units)
end

function PRT:RemoveUnits(UnitID)
	if self.Proteus.UnitID == UnitID then
		self.Proteus.Available = false
		return true
	end
	return false
end

function PRT:Death(UnitID)
	if self.Proteus.UnitID == UnitID then
		self.Proteus.Dead = true
		return true
	end
	return false
end

function PRT:UnitHPCheck(uDetails, unitID)	
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
				self.Phase = 1
				self.PhaseObj.Objectives:AddPercent(self.Proteus, 0, 100)
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
end

function PRT:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function PRT:Timer()	
end

function PRT:DefineMenu()
	self.Menu = PRT.Menu:CreateEncounter(self.Proteus, self.Enabled)
end

function PRT:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Proteus)

	-- Create Alerts
	self.Proteus.AlertsRef.Rampage = KBM.Alert:Create(self.Lang.Debuff.Rampage[KBM.Lang], nil, true, true, "red")
	self.Proteus.AlertsRef.Glacial = KBM.Alert:Create(self.Lang.Debuff.Glacial[KBM.Lang], 10, true, true, "blue")
	KBM.Defaults.AlertObj.Assign(self.Proteus)

	-- Create Mechanic Spies
	self.Proteus.MechRef.Rampage = KBM.MechSpy:Add(self.Lang.Debuff.Rampage[KBM.Lang], nil, "playerDebuff", self.Proteus)
	self.Proteus.MechRef.Glacial = KBM.MechSpy:Add(self.Lang.Debuff.Glacial[KBM.Lang], 10, "playerDebuff", self.Proteus)
	KBM.Defaults.MechObj.Assign(self.Proteus)

	-- Assign Alerts and Timers for Triggers

	self.Proteus.Triggers.Rampage = KBM.Trigger:Create(self.Lang.Debuff.Rampage[KBM.Lang], "playerDebuff", self.Proteus)
	self.Proteus.Triggers.Rampage:AddSpy(self.Proteus.MechRef.Rampage)
	self.Proteus.Triggers.RampageRem = KBM.Trigger:Create(self.Lang.Debuff.Rampage[KBM.Lang], "playerBuffRemove", self.Proteus)
	self.Proteus.Triggers.RampageRem:AddStop(self.Proteus.MechRef.Rampage)
	
	self.Proteus.Triggers.Glacial = KBM.Trigger:Create(self.Lang.Debuff.Glacial[KBM.Lang], "playerDebuff", self.Proteus)
	self.Proteus.Triggers.Glacial:AddSpy(self.Proteus.MechRef.Glacial)
	self.Proteus.Triggers.Glacial:AddAlert(self.Proteus.AlertsRef.Glacial, true)
	self.Proteus.Triggers.GlacialRem = KBM.Trigger:Create(self.Lang.Debuff.Glacial[KBM.Lang], "playerBuffRemove", self.Proteus)
	self.Proteus.Triggers.GlacialRem:AddStop(self.Proteus.MechRef.Glacial)
	self.Proteus.Triggers.GlacialRem:AddStop(self.Proteus.AlertsRef.Glacial)

	self.Proteus.CastBar = KBM.Castbar:Add(self, self.Proteus)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
end
