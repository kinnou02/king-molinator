-- Ungolok Boss Mod for King Boss Mods
-- Written by Noshei
-- Copyright 2012
--
-- Edited by Maatang
-- July 1st, 2015

KBMNTSLROFUNG_Settings = nil
chKBMNTSLROFUNG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local ROF = KBM.BossMod["SThe_Rhen_of_Fate"]

local UNG = {
	Directory = ROF.Directory,
	File = "Ungolok.lua",
	Enabled = true,
	Instance = ROF.Name,
	InstanceObj = ROF,
	Lang = {},
	Enrage = 8 * 60,
	ID = "SUngolok",
	Object = "UNG",
}

KBM.RegisterMod(UNG.ID, UNG)

-- Main Unit Dictionary
UNG.Lang.Unit = {}
UNG.Lang.Unit.Ungolok = KBM.Language:Add("Ungolok")
UNG.Lang.Unit.Ungolok:SetFrench()

-- Ability Dictionary
UNG.Lang.Ability = {}
UNG.Lang.Ability.InkBlast = KBM.Language:Add("Ink Blast")
UNG.Lang.Ability.InkBlast:SetFrench("Explosion d’encre")
UNG.Lang.Ability.Pressure = KBM.Language:Add("Building Pressure")
UNG.Lang.Ability.Pressure:SetFrench("Montée de pression")
UNG.Lang.Ability.Current = KBM.Language:Add("Fatal Current")
UNG.Lang.Ability.Current:SetFrench("Courant fatal")


-- Verbose Dictionary
UNG.Lang.Verbose = {}
UNG.Lang.Verbose.Ink = KBM.Language:Add("Ungolok prepares an Ink Blast.")
UNG.Lang.Verbose.Ink:SetFrench("Ungolok prépare une Explosion d'encre.")

-- Buff Dictionary
UNG.Lang.Buff = {}

-- Debuff Dictionary
UNG.Lang.Debuff = {}
UNG.Lang.Debuff.Barb = KBM.Language:Add("Venomous Barb")
UNG.Lang.Debuff.Barb:SetFrench("Aiguillon venimeux")


-- Description Dictionary
UNG.Lang.Main = {}

UNG.Descript = UNG.Lang.Unit.Ungolok[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
UNG.Ungolok = {
	Mod = UNG,
	Level = "??",
	Active = false,
	Name = UNG.Lang.Unit.Ungolok[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	-- TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U298B6CC31F0BCB3C", --10 Man Raid ID
	--UTID = "U09138AE74B7CF7F4", --Chronicle ID
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
			--	Enabled = true,
		--},
		AlertsRef = {
			Enabled = true,
			InkBlast = KBM.Defaults.AlertObj.Create("orange"),
			Current = KBM.Defaults.AlertObj.Create("red"),
			Pressure = KBM.Defaults.AlertObj.Create("blue"),
		},
		MechRef = {
			Enabled = true,
			Barb = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

function UNG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ungolok.Name] = self.Ungolok,
	}
end

function UNG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ungolok.Settings.CastBar,
		--EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		--TimersRef = self.Ungolok.Settings.TimersRef,
		AlertsRef = self.Ungolok.Settings.AlertsRef,
		MechRef = self.Ungolok.Settings.MechRef,
	}
	KBMNTSLROFUNG_Settings = self.Settings
	chKBMNTSLROFUNG_Settings = self.Settings

end

function UNG:SwapSettings(bool)

	if bool then
		KBMNTSLROFUNG_Settings = self.Settings
		self.Settings = chKBMNTSLROFUNG_Settings
	else
		chKBMNTSLROFUNG_Settings = self.Settings
		self.Settings = KBMNTSLROFUNG_Settings
	end

end

function UNG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTSLROFUNG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTSLROFUNG_Settings, self.Settings)
	end

	if KBM.Options.Character then
		chKBMNTSLROFUNG_Settings = self.Settings
	else
		KBMNTSLROFUNG_Settings = self.Settings
	end	

	self.Settings.Enabled = true
end

function UNG:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTSLROFUNG_Settings = self.Settings
	else
		KBMNTSLROFUNG_Settings = self.Settings
	end	
end

function UNG:Castbar(units)
end

function UNG:RemoveUnits(UnitID)
	if self.Ungolok.UnitID == UnitID then
		self.Ungolok.Available = false
		return true
	end
	return false
end

function UNG:Death(UnitID)
	if self.Ungolok.UnitID == UnitID then
		self.Ungolok.Dead = true
		return true
	end
	return false
end

function UNG:UnitHPCheck(uDetails, unitID)	
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
			if BossObj == self.Ungolok then
				BossObj.CastBar:Create(unitID)
			end
			self.PhaseObj:Start(self.StartTime)
			self.PhaseObj:SetPhase("1")
			self.PhaseObj.Objectives:AddPercent(self.Ungolok, 0, 100)
			self.Phase = 1
			if BossObj == self.Ungolok then
				--KBM.TankSwap:Start(self.Lang.Debuff.Devil[KBM.Lang], unitID)
			end
		else
			if BossObj == self.Ungolok then
				if not KBM.TankSwap.Active then
				--KBM.TankSwap:Start(self.Lang.Debuff.Devil[KBM.Lang], unitID)
				end
			end
			BossObj.Dead = false
			BossObj.Casting = false
			if BossObj.UnitID ~= unitID then
				if BossObj == self.Ungolok then
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

function UNG:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Ungolok.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function UNG:Timer()	
end

function UNG:Start()

	-- Create Timers


	-- Create Alerts
	self.Ungolok.AlertsRef.InkBlast = KBM.Alert:Create(self.Lang.Ability.InkBlast[KBM.Lang], nil, false, true, "orange")
	self.Ungolok.AlertsRef.Current = KBM.Alert:Create(self.Lang.Ability.Current[KBM.Lang], nil, false, true, "red")
	self.Ungolok.AlertsRef.Pressure = KBM.Alert:Create(self.Lang.Ability.Pressure[KBM.Lang], nil, false, true, "blue")
	KBM.Defaults.AlertObj.Assign(self.Ungolok)

	-- Create Spies
	self.Ungolok.MechRef.Barb = KBM.MechSpy:Add(self.Lang.Debuff.Barb[KBM.Lang], nil, "playerDebuff", self.Ungolok)
	KBM.Defaults.MechObj.Assign(self.Ungolok)

	-- Assign Alerts and Timers to Triggers
	self.Ungolok.Triggers.Current = KBM.Trigger:Create(self.Lang.Ability.Current[KBM.Lang], "cast", self.Ungolok)
	self.Ungolok.Triggers.Current:AddAlert(self.Ungolok.AlertsRef.Current)

	self.Ungolok.Triggers.InkBlast = KBM.Trigger:Create(self.Lang.Verbose.Ink[KBM.Lang], "notify", self.Ungolok)
	self.Ungolok.Triggers.InkBlast:AddAlert(self.Ungolok.AlertsRef.InkBlast)

	self.Ungolok.Triggers.Pressure = KBM.Trigger:Create(self.Lang.Ability.Pressure[KBM.Lang], "cast", self.Ungolok)
	self.Ungolok.Triggers.Pressure:AddAlert(self.Ungolok.AlertsRef.Pressure)

	self.Ungolok.Triggers.Barb = KBM.Trigger:Create(UNG.Lang.Debuff.Barb[KBM.Lang], "playerBuff", self.Ungolok)
	self.Ungolok.Triggers.Barb:SetMinStack(5)
	self.Ungolok.Triggers.Barb:AddSpy(self.Ungolok.MechRef.Barb)
	self.Ungolok.Triggers.BarbRem = KBM.Trigger:Create(self.Lang.Debuff.Barb[KBM.Lang], "playerBuffRemove", self.Ungolok)
	self.Ungolok.Triggers.BarbRem:AddStop(self.Ungolok.MechRef.Barb)

	self.Ungolok.CastBar = KBM.Castbar:Add(self, self.Ungolok)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end