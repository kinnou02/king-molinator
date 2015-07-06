-- Jinoscoth Boss Mod for King Boss Mods
-- Written by Kapnia
--

KBMNTRDMSJIN_Settings = nil
chKBMNTRDMSJIN_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local MS = KBM.BossMod["RMount_Sharax"]

local JIN = {
	Directory = MS.Directory,
	File = "Jinoscoth.lua",
	Enabled = true,
	Instance = MS.Name,
	InstanceObj = MS,
	Lang = {},
	Enrage = 5 * 60,
	ID = "Jinoscoth",
	Object = "JIN",
}

KBM.RegisterMod(JIN.ID, JIN)

-- Main Unit Dictionary
JIN.Lang.Unit = {}
JIN.Lang.Unit.Jinoscoth = KBM.Language:Add("Jinoscoth")
JIN.Lang.Unit.Jinoscoth:SetFrench("Jinoscoth")

-- Ability Dictionary
JIN.Lang.Ability = {}
JIN.Lang.Ability.Iced = KBM.Language:Add("Iced")
JIN.Lang.Ability.Iced:SetFrench("Glacé")
JIN.Lang.Ability.Bulwark = KBM.Language:Add("Frost Bulwark")
JIN.Lang.Ability.Bulwark:SetFrench("Rempart de givre")

-- Verbose Dictionary
JIN.Lang.Verbose = {}

-- Buff Dictionary
JIN.Lang.Buff = {}

-- Debuff Dictionary
JIN.Lang.Debuff = {}
JIN.Lang.Debuff.SappingCold = KBM.Language:Add("Sapping Cold")
JIN.Lang.Debuff.SappingCold:SetFrench("Froid affaiblissant")
JIN.Lang.Debuff.SappingColdID = "B41589C3B824AAA3D"
JIN.Lang.Debuff.LivingIce = KBM.Language:Add("Living Ice")
JIN.Lang.Debuff.LivingIce:SetFrench("Glace vivante")
JIN.Lang.Debuff.LivingIceID = "B7EEC49241458804E"

-- Description Dictionary
JIN.Lang.Main = {}

JIN.Descript = JIN.Lang.Unit.Jinoscoth[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
JIN.Jinoscoth = {
	Mod = JIN,
	Level = "??",
	Active = false,
	Name = JIN.Lang.Unit.Jinoscoth[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	--TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U3785225977845C60",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		--	Enabled = true,
		--},
		AlertsRef = {
			Enabled = true,
			LivingIce = KBM.Defaults.AlertObj.Create("blue"),
			Iced = KBM.Defaults.AlertObj.Create("red"),
			Bulwark = KBM.Defaults.AlertObj.Create("orange"),
		},
		MechRef = {
			Enabled = true,
			LivingIce = KBM.Defaults.MechObj.Create("blue"),
		},
	}
}

function JIN:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Jinoscoth.Name] = self.Jinoscoth,
	}
end

function JIN:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Jinoscoth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		--MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		--TimersRef = self.Jinoscoth.Settings.TimersRef,
		AlertsRef = self.Jinoscoth.Settings.AlertsRef,
		MechRef = self.Jinoscoth.Settings.MechRef,
	}
	KBMNTRDMSJIN_Settings = self.Settings
	chKBMNTRDMSJIN_Settings = self.Settings
	
end

function JIN:SwapSettings(bool)

	if bool then
		KBMNTRDMSJIN_Settings = self.Settings
		self.Settings = chKBMNTRDMSJIN_Settings
	else
		chKBMNTRDMSJIN_Settings = self.Settings
		self.Settings = KBMNTRDMSJIN_Settings
	end

end

function JIN:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDMSJIN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDMSJIN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRDMSJIN_Settings = self.Settings
	else
		KBMNTRDMSJIN_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function JIN:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTRDMSJIN_Settings = self.Settings
	else
		KBMNTRDMSJIN_Settings = self.Settings
	end	
end

function JIN:Castbar(units)
end

function JIN:RemoveUnits(UnitID)
	if self.Jinoscoth.UnitID == UnitID then
		self.Jinoscoth.Available = false
		return true
	end
	return false
end

function JIN:Death(UnitID)
	if self.Jinoscoth.UnitID == UnitID then
		self.Jinoscoth.Dead = true
		return true
	end
	return false
end

function JIN:UnitHPCheck(uDetails, unitID)	
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
				if BossObj == self.Jinoscoth then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Jinoscoth, 0, 100)
				self.Phase = 1
				if BossObj == self.Jinoscoth then
					KBM.TankSwap:Start(self.Lang.Debuff.SappingColdID, unitID)
				end
			else
				if BossObj == self.Jinoscoth then
					if not KBM.TankSwap.Active then
						KBM.TankSwap:Start(self.Lang.Debuff.SappingColdID, unitID)
					end
				end
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					if BossObj == self.Jinoscoth then
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

function JIN:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Jinoscoth.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function JIN:Timer()	
end

function JIN:Start()

	-- Create Timers
	
	
	-- Create Alerts
	self.Jinoscoth.AlertsRef.LivingIce = KBM.Alert:Create(self.Lang.Debuff.LivingIce[KBM.Lang], nil, true, true, "blue")
	self.Jinoscoth.AlertsRef.Iced = KBM.Alert:Create(self.Lang.Ability.Iced[KBM.Lang], nil, true, true, "red")	
	self.Jinoscoth.AlertsRef.Bulwark = KBM.Alert:Create(self.Lang.Ability.Bulwark[KBM.Lang], nil, true, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Jinoscoth)
	
	-- Create Spies
	self.Jinoscoth.MechRef.LivingIce = KBM.MechSpy:Add(self.Lang.Debuff.LivingIce[KBM.Lang], nil, "playerDebuff", self.Jinoscoth)
	KBM.Defaults.MechObj.Assign(self.Jinoscoth)

	-- Assign Alerts and Timers to Triggers
	self.Jinoscoth.Triggers.LivingIce = KBM.Trigger:Create(self.Lang.Debuff.LivingIce[KBM.Lang], "playerDebuff", self.Jinoscoth)
	self.Jinoscoth.Triggers.LivingIce:AddAlert(self.Jinoscoth.AlertsRef.LivingIce, true)
	self.Jinoscoth.Triggers.LivingIce:AddSpy(self.Jinoscoth.MechRef.LivingIce)
	self.Jinoscoth.Triggers.Iced = KBM.Trigger:Create(self.Lang.Ability.Iced[KBM.Lang], "cast", self.Jinoscoth)
	self.Jinoscoth.Triggers.Iced:AddAlert(self.Jinoscoth.AlertsRef.Iced, true)
	self.Jinoscoth.Triggers.Bulwark = KBM.Trigger:Create(self.Lang.Ability.Bulwark[KBM.Lang], "cast", self.Jinoscoth)
	self.Jinoscoth.Triggers.Bulwark:AddAlert(self.Jinoscoth.AlertsRef.Bulwark, true)	
	
	self.Jinoscoth.CastBar = KBM.Castbar:Add(self, self.Jinoscoth)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end