-- Abominus Boss Mod for King Boss Mods
-- Written by Noshei
-- Copyright 2013
--
 
KBMSLRDPBAB_Settings = nil
chKBMSLRDPBAB_Settings = nil
 
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
        return
end
local PB = KBM.BossMod["RPlanebreaker_Bastion"]
 
local PBA = {
	Enabled = true,
	Directory = PB.Directory,
	File = "Abominus.lua",
	Instance = PB.Name,
	InstanceObj = PB,
	HasPhases = true,
	Lang = {},
	ID = "Abominus",
	Object = "PBA",
	TimeoutOverride = true,
	Timeout = 20,
	Enrage = 12 * 60,
}
 
KBM.RegisterMod(PBA.ID, PBA)
 
-- Main Unit Dictionary
PBA.Lang.Unit = {}
PBA.Lang.Unit.Abominus = KBM.Language:Add("Planebreaker Abominus") -- ???
PBA.Lang.Unit.Abominus:SetFrench("Planicide Abominus")
PBA.Lang.Unit.Zorzyx = KBM.Language:Add("Zor'zyx")
PBA.Lang.Unit.Zorzyx:SetFrench("Zor’zyx")
PBA.Lang.Unit.Torkrik = KBM.Language:Add("Tor'krik")
PBA.Lang.Unit.Torkrik:SetFrench("Tor’krik")
PBA.Lang.Unit.Ixior = KBM.Language:Add("Ix'ior")
PBA.Lang.Unit.Ixior:SetFrench("Ix’ior")
 
-- Ability Dictionary
PBA.Lang.Ability = {}
 
-- Description Dictionary
PBA.Lang.Main = {}
PBA.Lang.Main.Encounter = KBM.Language:Add("Abominus")
PBA.Lang.Main.Encounter:SetFrench("Abominus")
 
-- Debuff Dictionary
PBA.Lang.Debuff = {}
PBA.Lang.Debuff.Petrification = KBM.Language:Add("Petrification")
PBA.Lang.Debuff.Petrification:SetFrench("Pétrification")
PBA.Lang.Debuff.PetrificationID = "B4F2B766BAC029D3B"
PBA.Lang.Debuff.Sandstorm = KBM.Language:Add("Sandstorm Target")
PBA.Lang.Debuff.SandstormID = "B14A5C9A23557342C"
 
-- Notify Dictionary
PBA.Lang.Notify = {}
PBA.Lang.Notify.Reflect = KBM.Language:Add("Ix'ior prepares to hurl a blast of magical energy at (%a*).")
 
-- Messages Dictionary
PBA.Lang.Messages = {}
PBA.Lang.Messages.Sandstorm = KBM.Language:Add("Sandstorm on YOU!")
PBA.Lang.Messages.Reflect = KBM.Language:Add("Reflect needed on:")
 
 
PBA.Descript = PBA.Lang.Main.Encounter[KBM.Lang]
 
PBA.Abominus = {
	Mod = PBA,
	Level = "??",
	Active = false,
	Name = PBA.Lang.Unit.Abominus[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "none",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
				Enabled = false,
		},
		AlertsRef = {
				Enabled = true,
				Sandstorm = KBM.Defaults.AlertObj.Create("yellow"),
		},
		MechRef = {
				Enabled = true,
				Sandstorm = KBM.Defaults.MechObj.Create("yellow"),
				Reflect = KBM.Defaults.MechObj.Create("blue"),
		},
	}
}
 
PBA.Zorzyx = {
	Mod = PBA,
	Level = "??",
	Active = false,
	Name = PBA.Lang.Unit.Zorzyx[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U49172D1806E351F8",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	--TimersRef = {},
	--AlertsRef = {},
	--MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		--      Enabled = false,
		--},
		--AlertsRef = {
		--      Enabled = true,
		--},
		--MechRef = {
		--      Enabled = true,
		--},
	}
}
 
PBA.Torkrik = {
	Mod = PBA,
	Level = "??",
	Active = false,
	Name = PBA.Lang.Unit.Torkrik[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U6639A5224FD93943",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	--TimersRef = {},
	--AlertsRef = {},
	--MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		--      Enabled = false,
		--},
		--AlertsRef = {
		--      Enabled = true,
		--},
		--MechRef = {
		--      Enabled = true,
		--},
	}
}
 
PBA.Ixior = {
	Mod = PBA,
	Level = "??",
	Active = false,
	Name = PBA.Lang.Unit.Ixior[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U78B9A29C3FB7E378",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	--TimersRef = {},
	--AlertsRef = {},
	--MechRef = {},
	--Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		--      Enabled = false,
		--},
		--AlertsRef = {
		--      Enabled = true,
		--},
		--MechRef = {
		--      Enabled = true,
		--},
	}
}
 
function PBA:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Abominus.Name] = self.Abominus,
		[self.Zorzyx.Name] = self.Zorzyx,
		[self.Torkrik.Name] = self.Torkrik,
		[self.Ixior.Name] = self.Ixior,
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
 
function PBA:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		Abominus = {
			CastBar = self.Abominus.Settings.CastBar,
			TimersRef = self.Abominus.Settings.TimersRef,
			AlertsRef = self.Abominus.Settings.AlertsRef,
			MechRef = self.Abominus.Settings.MechRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMSLRDPBAB_Settings = self.Settings
	chKBMSLRDPBAB_Settings = self.Settings
end
 
function PBA:SwapSettings(bool)
	if bool then
		KBMSLRDPBAB_Settings = self.Settings
		self.Settings = chKBMSLRDPBAB_Settings
	else
		chKBMSLRDPBAB_Settings = self.Settings
		self.Settings = KBMSLRDPBAB_Settings
	end

end
 
function PBA:LoadVars()
	if KBM.Options.Character then
			KBM.LoadTable(chKBMSLRDPBAB_Settings, self.Settings)
	else
			KBM.LoadTable(KBMSLRDPBAB_Settings, self.Settings)
	end
   
	if KBM.Options.Character then
			chKBMSLRDPBAB_Settings = self.Settings
	else
			KBMSLRDPBAB_Settings = self.Settings
	end    
   
	self.Settings.Enabled = true
end
 
function PBA:SaveVars()
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDPBAB_Settings = self.Settings
	else
		KBMSLRDPBAB_Settings = self.Settings
	end    
end
 
function PBA:Castbar(units)
end
 
function PBA:RemoveUnits(UnitID)
	if self.Abominus.UnitID == UnitID then
		self.Abominus.Available = false
		return true
	end
	return false
end
 
function PBA.PhaseTwo()
	PBA.PhaseObj.Objectives:Remove()
	PBA.PhaseObj:SetPhase("2")
	PBA.PhaseObj.Objectives:AddPercent(PBA.Zorzyx, 0, 70)
	PBA.PhaseObj.Objectives:AddPercent(PBA.Torkrik, 0, 70)
	PBA.PhaseObj.Objectives:AddPercent(PBA.Ixior, 0, 70)
end
 
function PBA.PhaseFinal()
	PBA.PhaseObj.Objectives:Remove()
	PBA.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	PBA.PhaseObj.Objectives:AddPercent(PBA.Abominus, 0, 100)
	PBA.PhaseObj.Objectives:AddPercent(PBA.Zorzyx, 0, 100)
	PBA.PhaseObj.Objectives:AddPercent(PBA.Torkrik, 0, 100)
	PBA.PhaseObj.Objectives:AddPercent(PBA.Ixior, 0, 100)
end
 
function PBA:Death(UnitID)
	if self.Abominus.UnitID == UnitID then
		self.Abominus.Dead = true
		return true
	end
	if self.Ixior.UnitID == UnitID then
		self.PhaseFinal()
	end
	return false
end
 
function PBA:UnitHPCheck(uDetails, unitID)     
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
				self.PhaseObj.Objectives:AddPercent(self.Zorzyx, 70, 100)
				self.PhaseObj.Objectives:AddPercent(self.Torkrik, 70, 100)
				self.PhaseObj.Objectives:AddPercent(self.Ixior, 70, 100)
				KBM.TankSwap:Start(self.Lang.Debuff.PetrificationID, unitID)
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
 
function PBA:Reset()
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
 
function PBA:Timer()
       
end
 
function PBA:DefineMenu()
        self.Menu = PBA.Menu:CreateEncounter(self.Abominus, self.Enabled)
end
 
function PBA:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Abominus)

	-- Create Alerts
	self.Abominus.AlertsRef.Sandstorm = KBM.Alert:Create(self.Lang.Debuff.Sandstorm[KBM.Lang], 10, true, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Abominus)

	-- Create Mechanic Spies
	self.Abominus.MechRef.Sandstorm = KBM.MechSpy:Add(self.Lang.Debuff.Sandstorm[KBM.Lang], nil, "playerDebuff", self.Abominus)
	self.Abominus.MechRef.Reflect = KBM.MechSpy:Add(self.Lang.Messages.Reflect[KBM.Lang], 5, "mechanic", self.Abominus)
	KBM.Defaults.MechObj.Assign(self.Abominus)

	-- Assign Alerts and Timers for Triggers

	self.Abominus.Triggers.Sandstorm = KBM.Trigger:Create(self.Lang.Debuff.Sandstorm[KBM.Lang], "playerDebuff", self.Abominus)
	self.Abominus.Triggers.Sandstorm:AddSpy(self.Abominus.MechRef.Sandstorm)
	self.Abominus.Triggers.Sandstorm:AddAlert(self.Abominus.AlertsRef.Sandstorm, true)
	self.Abominus.Triggers.SandstormRem = KBM.Trigger:Create(self.Lang.Debuff.Sandstorm[KBM.Lang], "playerBuffRemove", self.Abominus)
	self.Abominus.Triggers.SandstormRem:AddStop(self.Abominus.MechRef.Sandstorm)
   
	self.Abominus.Triggers.Reflect = KBM.Trigger:Create(self.Lang.Notify.Reflect[KBM.Lang], "notify", self.Abominus)
	self.Abominus.Triggers.Reflect:AddSpy(self.Abominus.MechRef.Reflect)
   
	self.Abominus.Triggers.PhaseTwo = KBM.Trigger:Create(70, "percent", self.Ixior)
	self.Abominus.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)

	self.Abominus.CastBar = KBM.Castbar:Add(self, self.Abominus)
	self.Zorzyx.CastBar = KBM.Castbar:Add(self, self.Zorzyx)
	self.Torkrik.CastBar = KBM.Castbar:Add(self, self.Torkrik)
	self.Ixior.CastBar = KBM.Castbar:Add(self, self.Ixior)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
end
