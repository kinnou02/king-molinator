-- Finric Boss Mod for King Boss Mods
-- Template by Noshei
-- Written by Kapnia
--

KBMNTSLROFFIN_Settings = nil
chKBMNTSLROFFIN_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local ROF = KBM.BossMod["SThe_Rhen_of_Fate"]

local FIN = {
	Directory = ROF.Directory,
	File = "Finric.lua",
	Enabled = true,
	Instance = ROF.Name,
	InstanceObj = ROF,
	Lang = {},
	Enrage = 8 * 60,
	ID = "SFinric",
	Object = "FIN",
}

KBM.RegisterMod(FIN.ID, FIN)

-- Main Unit Dictionary
FIN.Lang.Unit = {}
FIN.Lang.Unit.Finric = KBM.Language:Add("Finric")

-- Ability Dictionary
FIN.Lang.Ability = {}
FIN.Lang.Ability.BrutalSwell = KBM.Language:Add("Brutal Swell")
FIN.Lang.Ability.BrutalSwell:SetFrench("Houle brutale")
FIN.Lang.Ability.RoS = KBM.Language:Add("Rage of Storms")
FIN.Lang.Ability.RoS:SetFrench("Rage des Tempêtes")

-- Verbose Dictionary
FIN.Lang.Verbose = {}

-- Buff Dictionary
FIN.Lang.Buff = {}

-- Debuff Dictionary
FIN.Lang.Debuff = {}
FIN.Lang.Debuff.Waterlogged = KBM.Language:Add("Waterlogged")
FIN.Lang.Debuff.Waterlogged:SetFrench("Détrempé")
FIN.Lang.Debuff.WaterloggedID = "BFA19EC4C71EAC966"
FIN.Lang.Debuff.Toxin = KBM.Language:Add("Toxin")
FIN.Lang.Debuff.Toxin:SetFrench("Toxine")
FIN.Lang.Debuff.ToxinID = "B52BE0CACC92241F4"
FIN.Lang.Debuff.Contagion = KBM.Language:Add("Contagion")
FIN.Lang.Debuff.Contagion:SetFrench("Contagion")
FIN.Lang.Debuff.ContagionID = "B546F0E37E28BDE95"

-- Description Dictionary
FIN.Lang.Main = {}

FIN.Descript = FIN.Lang.Unit.Finric[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
FIN.Finric = {
	Mod = FIN,
	Level = "??",
	Active = false,
	Name = FIN.Lang.Unit.Finric[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U5E16C7A90C01DE2D",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Contagion = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			BrutalSwell = KBM.Defaults.AlertObj.Create("blue"),
			RoS = KBM.Defaults.AlertObj.Create("cyan"),
			Toxin = KBM.Defaults.AlertObj.Create("dark_green"),
			Contagion = KBM.Defaults.AlertObj.Create("red")
		},
		MechRef = {
			Enabled = true,
			Contagion = KBM.Defaults.MechObj.Create("red"),
		},
	}
}

function FIN:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Finric.Name] = self.Finric,
	}
end

function FIN:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Finric.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		TimersRef = self.Finric.Settings.TimersRef,
		AlertsRef = self.Finric.Settings.AlertsRef,
		MechRef = self.Finric.Settings.MechRef,
	}
	KBMNTSLROFFIN_Settings = self.Settings
	chKBMNTSLROFFIN_Settings = self.Settings
	
end

function FIN:SwapSettings(bool)

	if bool then
		KBMNTSLROFFIN_Settings = self.Settings
		self.Settings = chKBMNTSLROFFIN_Settings
	else
		chKBMNTSLROFFIN_Settings = self.Settings
		self.Settings = KBMNTSLROFFIN_Settings
	end

end

function FIN:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTSLROFFIN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTSLROFFIN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTSLROFFIN_Settings = self.Settings
	else
		KBMNTSLROFFIN_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function FIN:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTSLROFFIN_Settings = self.Settings
	else
		KBMNTSLROFFIN_Settings = self.Settings
	end	
end

function FIN:Castbar(units)
end

function FIN:RemoveUnits(UnitID)
	if self.Finric.UnitID == UnitID then
		self.Finric.Available = false
		return true
	end
	return false
end

function FIN:Death(UnitID)
	if self.Finric.UnitID == UnitID then
		self.Finric.Dead = true
		return true
	end
	return false
end

function FIN:UnitHPCheck(uDetails, unitID)	
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
				if BossObj == self.Finric then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Finric, 0, 100)
				self.Phase = 1
				if BossObj == self.Finric then
					KBM.TankSwap:Start(self.Lang.Debuff.WaterloggedID, unitID)
				end
			else
				if BossObj == self.Finric then
					if not KBM.TankSwap.Active then
						KBM.TankSwap:Start(self.Lang.Debuff.WaterloggedID, unitID)
					end
				end
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					if BossObj == self.Finric then
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

function FIN:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Finric.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function FIN:Timer()	
end

function FIN:Start()

	-- Create Timers
	
	
	-- Create Alerts
	self.Finric.AlertsRef.BrutalSwell = KBM.Alert:Create(self.Lang.Ability.BrutalSwell[KBM.Lang], nil, false, true, "blue")
	self.Finric.AlertsRef.RoS = KBM.Alert:Create(self.Lang.Ability.RoS[KBM.Lang], nil, false, true, "cyan")
	self.Finric.AlertsRef.Toxin = KBM.Alert:Create(self.Lang.Debuff.Toxin[KBM.Lang], nil, true, true, "dark_green")
	self.Finric.AlertsRef.Contagion = KBM.Alert:Create(self.Lang.Debuff.Contagion[KBM.Lang], nil, false, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Finric)

	-- Create Spies
	
	self.Finric.MechRef.Contagion = KBM.MechSpy:Add(self.Lang.Debuff.Contagion[KBM.Lang], nil, "playerDebuff", self.Finric)
	KBM.Defaults.MechObj.Assign(self.Finric)
	
	-- Assign Alerts and Timers to Triggers
	self.Finric.Triggers.BrutalSwell = KBM.Trigger:Create(self.Lang.Ability.BrutalSwell[KBM.Lang], "cast", self.Finric)
	self.Finric.Triggers.BrutalSwell:AddAlert(self.Finric.AlertsRef.BrutalSwell)
	
	self.Finric.Triggers.RoS = KBM.Trigger:Create(self.Lang.Ability.RoS[KBM.Lang], "channel", self.Finric)
	self.Finric.Triggers.RoS:AddAlert(self.Finric.AlertsRef.RoS)
	
	self.Finric.Triggers.Toxin = KBM.Trigger:Create(self.Lang.Debuff.Toxin[KBM.Lang], "playerDebuff", self.Finric)
	self.Finric.Triggers.Toxin:AddAlert(self.Finric.AlertsRef.Toxin, true)
	self.Finric.Triggers.ToxinRem = KBM.Trigger:Create(self.Lang.Debuff.Toxin[KBM.Lang], "playerBuffRemove", self.Finric)
	self.Finric.Triggers.ToxinRem:AddStop(self.Finric.AlertsRef.Toxin)
	
	self.Finric.Triggers.Contagion = KBM.Trigger:Create(self.Lang.Debuff.ContagionID, "playerDebuff", self.Finric)
	self.Finric.Triggers.Contagion:AddAlert(self.Finric.AlertsRef.Contagion,true)
	--self.Finric.Triggers.Contagion:AddTimer(self.Finric.TimersRef.Contagion)
	self.Finric.Triggers.Contagion:AddSpy(self.Finric.MechRef.Contagion)
	self.Finric.Triggers.ContagionRem = KBM.Trigger:Create(self.Lang.Debuff.ContagionID, "playerBuffRemove", self.Finric)
	self.Finric.Triggers.ContagionRem:AddStop(self.Finric.AlertsRef.Contagion)
	self.Finric.Triggers.ContagionRem:AddStop(self.Finric.MechRef.Contagion)
	
	self.Finric.CastBar = KBM.Castbar:Add(self, self.Finric)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end