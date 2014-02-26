-- Eggtenders Boss Mod for King Boss Mods
-- Written by Ivnedar
-- Copyright 2013
--

KBMSLRDPBET_Settings = nil
chKBMSLRDPBET_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PB = KBM.BossMod["RPlanebreaker_Bastion"]

local ETS = {
	Enabled = true,
	Directory = PB.Directory,
	File = "Eggtenders.lua",
	Instance = PB.Name,
	InstanceObj = PB,
	HasPhases = true,
	Lang = {},
	ID = "Eggtenders",
	Object = "ETS",
	TimeoutOverride = true,
	Timeout = 20,
	EggtenderUnits = {},
	Nextboss = 1,
	Enrage = 6 * 60,
}

KBM.RegisterMod(ETS.ID, ETS)

-- Main Unit Dictionary
ETS.Lang.Unit = {}
ETS.Lang.Unit.Eggtender = KBM.Language:Add("Eggtender") -- U54A900670238C4D6
ETS.Lang.Unit.Eggtender:SetFrench("Garde-œufs")
ETS.Lang.Unit.Eggtender:SetGerman("Gelegehüter")
ETS.Lang.Unit.Egg = KBM.Language:Add("Massive Architect Egg") -- U47651D39698CC267 (642.54998563789,884,97998021916,1218.159972772)
ETS.Lang.Unit.Egg:SetFrench("Œuf d'Architecte massif")
ETS.Lang.Unit.Egg:SetGerman("Massives Architekten-Ei")

-- Ability Dictionary
ETS.Lang.Ability = {}
ETS.Lang.Ability.Faucet = KBM.Language:Add("Bile Faucet")
ETS.Lang.Ability.Faucet:SetFrench("Robinet de bile")
ETS.Lang.Ability.Faucet:SetGerman("Gallenventil")
ETS.Lang.Ability.Bile = KBM.Language:Add("Frenetic Bile")
ETS.Lang.Ability.Bile:SetGerman("Frenetische Galle")
ETS.Lang.Ability.Pool = KBM.Language:Add("Pool of Bile")
ETS.Lang.Ability.Pool:SetFrench("Flaque de bile")
ETS.Lang.Ability.Pool:SetGerman("Gallenteich")
ETS.Lang.Ability.Slam = KBM.Language:Add("Slam")
ETS.Lang.Ability.Slam:SetGerman("Rempler")

-- Description Dictionary
ETS.Lang.Main = {}
ETS.Lang.Main.Encounter = KBM.Language:Add("Eggtenders")
ETS.Lang.Main.Encounter:SetFrench("Garde-œufs")
ETS.Lang.Main.Encounter:SetGerman("Eierhüter")

-- Debuff Dictionary
ETS.Lang.Debuff = {}

-- Messages Dictionary
ETS.Lang.Messages = {}

ETS.Descript = ETS.Lang.Main.Encounter[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
ETS.Eggtender1 = {
	Mod = ETS,
	Level = "??",
	Active = false,
	Name = ETS.Lang.Unit.Eggtender[KBM.Lang].." 1",
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U54A900670238C4D6", -- Shared
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
			Enabled = true,
			Faucet = KBM.Defaults.TimerObj.Create("red"),
			FirstFaucet = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Pool = KBM.Defaults.AlertObj.Create("dark_green"),
		},
		MechRef = {
			Enabled = true,
			Pool = KBM.Defaults.MechObj.Create("dark_green"),
		},
	}
}

ETS.Eggtender2 = {
	Mod = ETS,
	Level = "??",
	Active = false,
	Name = ETS.Lang.Unit.Eggtender[KBM.Lang].." 2",
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U54A900670238C4D6", -- Shared
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Faucet = KBM.Defaults.TimerObj.Create("red"),
			FirstFaucet = KBM.Defaults.TimerObj.Create("red"),
		},
	}
}

ETS.Eggtender3 = {
	Mod = ETS,
	Level = "??",
	Active = false,
	Name = ETS.Lang.Unit.Eggtender[KBM.Lang].." 3",
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U54A900670238C4D6", -- Shared
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Faucet = KBM.Defaults.TimerObj.Create("red"),
			FirstFaucet = KBM.Defaults.TimerObj.Create("red"),
		},
	}
}

ETS.Eggtender4 = {
	Mod = ETS,
	Level = "??",
	Active = false,
	Name = ETS.Lang.Unit.Eggtender[KBM.Lang].." 4",
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U54A900670238C4D6", -- Shared
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Faucet = KBM.Defaults.TimerObj.Create("red"),
			FirstFaucet = KBM.Defaults.TimerObj.Create("red"),
		},
	}
}

ETS.Eggtender5 = {
	Mod = ETS,
	Level = "??",
	Active = false,
	Name = ETS.Lang.Unit.Eggtender[KBM.Lang].." 5",
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U54A900670238C4D6", -- Shared
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Faucet = KBM.Defaults.TimerObj.Create("red"),
			FirstFaucet = KBM.Defaults.TimerObj.Create("red"),
		},
	}
}
	
function ETS:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Eggtender1.Name] = self.Eggtender1,
		[self.Eggtender2.Name] = self.Eggtender2,
		[self.Eggtender3.Name] = self.Eggtender3,
		[self.Eggtender4.Name] = self.Eggtender4,
		[self.Eggtender5.Name] = self.Eggtender5,
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

function ETS:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		Eggtender1 = {
			CastBar = self.Eggtender1.Settings.CastBar,
			TimersRef = self.Eggtender1.Settings.TimersRef,
			AlertsRef = self.Eggtender1.Settings.AlertsRef,
			MechRef = self.Eggtender1.Settings.MechRef,
		},
		Eggtender2 = {
			CastBar = self.Eggtender2.Settings.CastBar,
			TimersRef = self.Eggtender2.Settings.TimersRef,
		},
		Eggtender3 = {
			CastBar = self.Eggtender3.Settings.CastBar,
			TimersRef = self.Eggtender3.Settings.TimersRef,
		},
		Eggtender4 = {
			CastBar = self.Eggtender4.Settings.CastBar,
			TimersRef = self.Eggtender4.Settings.TimersRef,
		},
		Eggtender5 = {
			CastBar = self.Eggtender5.Settings.CastBar,
			TimersRef = self.Eggtender5.Settings.TimersRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMSLRDPBET_Settings = self.Settings
	chKBMSLRDPBET_Settings = self.Settings
	
end

function ETS:SwapSettings(bool)

	if bool then
		KBMSLRDPBET_Settings = self.Settings
		self.Settings = chKBMSLRDPBET_Settings
	else
		chKBMSLRDPBET_Settings = self.Settings
		self.Settings = KBMSLRDPBET_Settings
	end

end

function ETS:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDPBET_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDPBET_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDPBET_Settings = self.Settings
	else
		KBMSLRDPBET_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function ETS:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDPBET_Settings = self.Settings
	else
		KBMSLRDPBET_Settings = self.Settings
	end	
end

function ETS:Castbar(units)
end

function ETS:RemoveUnits(UnitID)
	local e = self.EggtenderUnits[UnitID]
	if e ~= nil then
		e.Available = false
		for n = 1,5 do
			if self["Eggtender"..n].Available == true then
				return false
			end
		end
		return true
	end
	return false
end

function ETS:Death(UnitID)
	local e = self.EggtenderUnits[UnitID]
	if e ~= nil then
		e.Dead = true
		KBM.MechTimer:AddRemove(e.TimersRef.Faucet, true)
		for n = 1,5 do
			if self["Eggtender"..n].Dead == false then
				return false
			end
		end
		return true
	end
	return false
end

function ETS:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Eggtender1.UTID then
			local BossObj = self.EggtenderUnits[unitID]
			if not BossObj then
				print("Nextboss: "..self.Nextboss)
				if self.Nextboss > 5 then
					return
				end
				BossObj = self["Eggtender"..self.Nextboss]
				self.EggtenderUnits[unitID] = BossObj
				KBM.MechTimer:AddStart(BossObj.TimersRef.FirstFaucet)
				self.Nextboss = self.Nextboss + 1
			end

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
				for n = 1,5 do
					self.PhaseObj.Objectives:AddPercent(self["Eggtender"..n], 0, 100)
				end
				self.Phase = 1
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

function ETS:Reset()
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
	self.EggtenderUnits = {}
	self.Nextboss = 1
end

function ETS:Timer()	
end

function ETS:DefineMenu()
	self.Menu = PBB.Menu:CreateEncounter(self.Eggtender1, self.Enabled)
end

function ETS:Start()

	-- Set them all up!
	e1 = self.Eggtender1
	e1.MechRef.Pool = KBM.MechSpy:Add(self.Lang.Ability.Pool[KBM.Lang], 5, "cast", e1)
	KBM.Defaults.MechObj.Assign(e1)

	e1.AlertsRef.Pool = KBM.Alert:Create(self.Lang.Ability.Pool[KBM.Lang], 2, false, true, "orange")
	KBM.Defaults.AlertObj.Assign(e1)

	for n = 1,5 do
		local e = self["Eggtender"..n]
		e.TimersRef.FirstFaucet = KBM.MechTimer:Add(e.Name.." - "..self.Lang.Ability.Faucet[KBM.Lang], 35-(n*5))
		e.TimersRef.Faucet = KBM.MechTimer:Add(e.Name.." - "..self.Lang.Ability.Faucet[KBM.Lang], 50-(n*5))
		KBM.Defaults.TimerObj.Assign(e)

		e.TimersRef.FirstFaucet:SetLink(e.TimersRef.Faucet)

		e.Triggers.Faucet = KBM.Trigger:Create(self.Lang.Ability.Faucet[KBM.Lang], "cast", e)
		e.Triggers.Faucet:AddTimer(e.TimersRef.Faucet)

		e.Triggers.Pool = KBM.Trigger:Create(self.Lang.Ability.Pool[KBM.Lang], "cast", e)
		e.Triggers.Pool:AddAlert(e1.AlertsRef.Pool)
		e.Triggers.Pool:AddSpy(e1.MechRef.Pool)

		e.CastBar = KBM.Castbar:Add(self, e)
	end

	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end