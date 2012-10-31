-- Maelforge Final Encounter Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDMFF_Settings = nil
chKBMINDMFF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local MF = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Maelforge_Final.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Enrage = 15 * 60,
	Lang = {},
	ID = "Maelforge_Final",
	Object = "MF",
	CannonCount = 0,
}

MF.Maelforge = {
	Mod = MF,
	Level = "??",
	Active = false,
	Name = "Maelforge",
	NameShort = "Maelforge",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	RaidID = "U22D6DD797E7A5F87",
	RaidID_P2 = "U35BDBE1D14577953",
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Hell = KBM.Defaults.TimerObj.Create("purple"),
			Hell_P3First = KBM.Defaults.TimerObj.Create("purple"),
			Fissure = KBM.Defaults.TimerObj.Create("orange"),
		},
		MechRef = {
			Enabled = true,
			Hell_Yellow = KBM.Defaults.MechObj.Create("yellow"),
			Hell_Green = KBM.Defaults.MechObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Hell_Yellow = KBM.Defaults.AlertObj.Create("yellow"),
			Hell_Green = KBM.Defaults.AlertObj.Create("dark_green"),
			Fiery = KBM.Defaults.AlertObj.Create("red"),
			Earthen = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

KBM.RegisterMod(MF.ID, MF)

-- Main Unit Dictionary
MF.Lang.Unit = {}
MF.Lang.Unit.Maelforge = KBM.Language:Add(MF.Maelforge.Name)
MF.Lang.Unit.Maelforge:SetGerman("Flammenmaul")
MF.Lang.Unit.Maelforge:SetFrench()
MF.Lang.Unit.Maelforge:SetRussian("Маэлфорж")
MF.Lang.Unit.Maelforge:SetKorean("마엘포지")
MF.Lang.Unit.Cannon = KBM.Language:Add("Magma Cannon")
MF.Lang.Unit.Cannon:SetGerman("Magmakanone")
MF.Lang.Unit.Cannon:SetFrench("Canon à magma")
MF.Lang.Unit.CanShort = KBM.Language:Add("Cannon")
MF.Lang.Unit.CanShort:SetGerman("Kanone")
MF.Lang.Unit.CanShort:SetFrench("Canon")

-- Location Dictionary
MF.Lang.Location = {}
MF.Lang.Location.Spires = KBM.Language:Add("Spires of Sacrifice")
MF.Lang.Location.Spires:SetGerman("Spitze der Opfergabe")
MF.Lang.Location.Spires:SetFrench("Aiguilles de Sacrifice")

-- Ability Dictionary
MF.Lang.Ability = {}
MF.Lang.Ability.Blast = KBM.Language:Add("Molten Blast")
MF.Lang.Ability.Blast:SetGerman("Geschmolzene Explosion")

-- Debuff Dictionary
MF.Lang.Debuff = {}
MF.Lang.Debuff.Hell = KBM.Language:Add("Hellfire")
MF.Lang.Debuff.Hell:SetGerman("Höllenfeuer")
MF.Lang.Debuff.Hell:SetFrench("Hellfire")
MF.Lang.Debuff.Earthen = KBM.Language:Add("Earthen Fissure")
MF.Lang.Debuff.Earthen:SetGerman("Erdspalte")
MF.Lang.Debuff.Earthen:SetFrench("Fissure terrestre")
MF.Lang.Debuff.Fiery = KBM.Language:Add("Fiery Fissure")
MF.Lang.Debuff.Fiery:SetGerman("Feuriger Spalt")
MF.Lang.Debuff.Fiery:SetFrench("Fissure flamboyante")
MF.Lang.Debuff.Melt = KBM.Language:Add("Melt Armor")

-- Notify Dictionary
MF.Lang.Notify = {}
MF.Lang.Notify.Fissure = KBM.Language:Add("Hellfire feeds on your agony!")
MF.Lang.Notify.Fissure:SetGerman("Eure Angst nährt das Flammeninferno!")
MF.Lang.Notify.Fissure:SetFrench("Les feux de l'enfer se nourrissent de votre agonie !")

-- Mechanic Dictionary
MF.Lang.Mechanic = {}
MF.Lang.Mechanic.Fissure = KBM.Language:Add("Fissures")
MF.Lang.Mechanic.Fissure:SetGerman("Spalten")
MF.Lang.Mechanic.Fissure:SetFrench("Fissures")

-- Menu Dictionary
MF.Lang.Menu = {}
MF.Lang.Menu.Hell_Green = KBM.Language:Add("Hellfire (Green)")
MF.Lang.Menu.Hell_Green:SetGerman("Höllenfeuer (Grün)")
MF.Lang.Menu.Hell_Green:SetFrench("Hellfire (Foncé)")
MF.Lang.Menu.Hell_Yellow = KBM.Language:Add("Hellfire (Yellow)")
MF.Lang.Menu.Hell_Yellow:SetGerman("Höllenfeuer (Gelb)")
MF.Lang.Menu.Hell_Yellow:SetFrench("Hellfire (Jaune)")
MF.Lang.Menu.Hell_P3First = KBM.Language:Add("First Hellfire (Final Phase)")
MF.Lang.Menu.Hell_P3First:SetGerman("Erste Höllenfeuer (Letzte Phase)") 

-- Description
MF.Lang.Descript = {}
MF.Lang.Descript.Main = KBM.Language:Add("Maelforge - Final")
MF.Lang.Descript.Main:SetGerman("Flammenmaul - Finale")
MF.Lang.Descript.Main:SetFrench("Maelforge - Final")

MF.Maelforge.Name = MF.Lang.Unit.Maelforge[KBM.Lang]
MF.Maelforge.NameShort = MF.Lang.Unit.Maelforge[KBM.Lang]
MF.Maelforge.LocationReq = MF.Lang.Location.Spires[KBM.Lang]
MF.Descript = MF.Lang.Descript.Main[KBM.Lang]

MF.Cannon = {
	Mod = MF,
	Level = "??",
	Name = MF.Lang.Unit.Cannon[KBM.Lang],
	NameShort = MF.Lang.Unit.CanShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	Type = "multi",
	AlertsRef = {},
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Blast = KBM.Defaults.AlertObj.Create("yellow"),
		},
	},	
}

function MF:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maelforge.Name] = self.Maelforge,
		[self.Cannon.Name] = self.Cannon,
	}
	KBM.Boss.Raid[self.Maelforge.RaidID] = self.Maelforge
	KBM.Boss.Raid[self.Maelforge.RaidID_P2] = self.Maelforge
	KBM.SubBoss[self.Cannon.Name] = self.Cannon

end

function MF:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maelforge.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		Maelforge = {
			TimersRef = self.Maelforge.Settings.TimersRef,
			MechRef = self.Maelforge.Settings.MechRef,
			AlertsRef = self.Maelforge.Settings.AlertsRef,
		},
		Cannon = {
			AlertsRef = self.Cannon.Settings.AlertsRef,
		},
	}
	KBMINDMFF_Settings = self.Settings
	chKBMINDMFF_Settings = self.Settings
	
end

function MF:SwapSettings(bool)

	if bool then
		KBMINDMFF_Settings = self.Settings
		self.Settings = chKBMINDMFF_Settings
	else
		chKBMINDMFF_Settings = self.Settings
		self.Settings = KBMINDMFF_Settings
	end

end

function MF:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDMFF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDMFF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDMFF_Settings = self.Settings
	else
		KBMINDMFF_Settings = self.Settings
	end	
end

function MF:SaveVars()	
	if KBM.Options.Character then
		chKBMINDMFF_Settings = self.Settings
	else
		KBMINDMFF_Settings = self.Settings
	end	
end

function MF:Castbar(units)
end

function MF:RemoveUnits(UnitID)
	if self.Maelforge.UnitID == UnitID then
		self.Maelforge.Available = false
		return true
	end
	return false
end

function MF.PhaseTwo()
	if MF.Phase == 1 then
		MF.PhaseObj.Objectives:Remove()
		MF.PhaseObj.Objectives:AddPercent(MF.Maelforge.Name, 30, 65)
		MF.PhaseObj:SetPhase(2)
		MF.Phase = 2
	end
end

function MF.PhaseCannons()
	MF.PhaseObj.Objectives:Remove()
	MF.PhaseObj.Objectives:AddPercent(MF.Maelforge.Name, 0, 30)
	MF.PhaseObj.Objectives:AddDeath(MF.Cannon.Name, 4)
	MF.PhaseObj:SetPhase("3")
	MF.Phase = 3
	MF.CannonCount = 0	
end

function MF.PhaseFinal()
	MF.PhaseObj.Objectives:Remove()
	MF.PhaseObj.Objectives:AddPercent(MF.Maelforge.Name, 0, 30)
	MF.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	MF.Phase = 4
	KBM.MechTimer:AddRemove(MF.Maelforge.TimersRef.Hell)
	KBM.MechTimer:AddStart(MF.Maelforge.TimersRef.Hell_P3First)
end

function MF:Death(UnitID)
	if self.Maelforge.UnitID == UnitID then
		self.Maelforge.Dead = true
		return true
	elseif self.Cannon.UnitList[UnitID] then
		if not self.Cannon.UnitList[UnitID].Dead then
			self.Cannon.UnitList[UnitID].Dead = true
			self.Cannon.UnitList[UnitID].CastBar:Remove()
			self.Cannon.UnitList[UnitID].CastBar = nil
			self.CannonCount = self.CannonCount + 1
			if self.CannonCount == 4 then
				MF.PhaseFinal()
			end
		end
	end
	return false
end

function MF:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			local BossObj = self.Bosses[uDetails.name]
			if BossObj == self.Maelforge then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Maelforge.Dead = false
					self.Maelforge.Casting = false
					self.Maelforge.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					if uDetails.type == self.Maelforge.RaidID_P2 then
						self.PhaseTwo()
					else
						self.PhaseObj:SetPhase(1)
						self.PhaseObj.Objectives:AddPercent(self.Maelforge.Name, 65, 100)
						KBM.TankSwap:Start(self.Lang.Debuff.Melt[KBM.Lang], unitID)
						KBM.MechTimer:AddStart(self.Maelforge.TimersRef.Fissure)
						self.Phase = 1
					end
				end
				if uDetails.type == self.Maelforge.RaidID_P2 then
					if self.Maelforge.UnitID ~= unitID then
						if KBM.TankSwap.Active then
							KBM.TankSwap:Remove()
							KBM.TankSwap:Start(self.Lang.Debuff.Melt[KBM.Lang], unitID)
						end
					end
				end
				self.Maelforge.UnitID = unitID
				self.Maelforge.Available = true
				return self.Maelforge
			elseif BossObj.UnitList then
				if not BossObj.UnitList[unitID] then
					SubBossObj = {
						Mod = MF,
						Level = "??",
						Name = uDetails.name,
						Dead = false,
						Casting = false,
						UnitID = unitID,
						Available = true,
					}
					BossObj.UnitList[unitID] = SubBossObj
					if BossObj == self.Cannon then
						SubBossObj.CastBar = KBM.CastBar:Add(self, self.Cannon, false, true)
						SubBossObj.CastBar:Create(unitID)
					end
				else
					BossObj.UnitList[unitID].Available = true
					BossObj.UnitList[unitID].UnitID = unitID
				end
				return BossObj.UnitList[unitID]
			end
		end
	end
end

function MF:Reset()
	self.EncounterRunning = false
	self.Maelforge.Available = false
	self.Maelforge.UnitID = nil
	self.Maelforge.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
	self.CannonCount = 0
	for UnitID, BossObj in pairs(self.Cannon.UnitList) do
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
			BossObj.CastBar = nil
		end
	end
	self.Cannon.UnitList = {}
	self.Cannon.Available = false
	self.Cannon.Dead = false
end

function MF:Timer()	
end

function MF:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Maelforge, self.Enabled)
end

function MF:Start()
	-- Create Timers
	self.Maelforge.TimersRef.Hell = KBM.MechTimer:Add(self.Lang.Debuff.Hell[KBM.Lang], 50)
	self.Maelforge.TimersRef.Hell_P3First = KBM.MechTimer:Add(self.Lang.Debuff.Hell[KBM.Lang], 44)
	self.Maelforge.TimersRef.Hell_P3First.MenuName = self.Lang.Menu.Hell_P3First[KBM.Lang]
	self.Maelforge.TimersRef.Fissure = KBM.MechTimer:Add(self.Lang.Mechanic.Fissure[KBM.Lang], 60)
	KBM.Defaults.TimerObj.Assign(self.Maelforge)
	
	-- Create Spies
	self.Maelforge.MechRef.Hell_Yellow = KBM.MechSpy:Add(self.Lang.Debuff.Hell[KBM.Lang], nil, "playerDebuff", self.Maelforge)
	self.Maelforge.MechRef.Hell_Yellow.MenuName = self.Lang.Menu.Hell_Yellow[KBM.Lang]
	self.Maelforge.MechRef.Hell_Green = KBM.MechSpy:Add(self.Lang.Debuff.Hell[KBM.Lang], nil, "playerDebuff", self.Maelforge)
	self.Maelforge.MechRef.Hell_Green.MenuName = self.Lang.Menu.Hell_Green[KBM.Lang]
	KBM.Defaults.MechObj.Assign(self.Maelforge)
	
	-- Create Alerts (Maelforge)
	self.Maelforge.AlertsRef.Hell_Yellow = KBM.Alert:Create(self.Lang.Menu.Hell_Yellow[KBM.Lang], nil, false, true, "yellow")
	self.Maelforge.AlertsRef.Hell_Green = KBM.Alert:Create(self.Lang.Menu.Hell_Green[KBM.Lang], nil, false, true, "dark_green")
	self.Maelforge.AlertsRef.Fiery = KBM.Alert:Create(self.Lang.Debuff.Fiery[KBM.Lang], nil, false, true, "red")
	self.Maelforge.AlertsRef.Earthen = KBM.Alert:Create(self.Lang.Debuff.Earthen[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Maelforge)

	-- Create Alerts (Cannons)
	self.Cannon.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Cannon)
	
	-- Assign Alerts and Timers to Triggers
	self.Maelforge.Triggers.Hell_Yellow = KBM.Trigger:Create("B58F6969FA32C3353", "playerIDBuff", self.Maelforge)
	self.Maelforge.Triggers.Hell_Yellow:AddAlert(self.Maelforge.AlertsRef.Hell_Yellow, true)
	self.Maelforge.Triggers.Hell_Yellow:AddTimer(self.Maelforge.TimersRef.Hell)
	self.Maelforge.Triggers.Hell_Yellow:AddSpy(self.Maelforge.MechRef.Hell_Yellow)
	self.Maelforge.Triggers.Hell_Green = KBM.Trigger:Create("B0E7E2D5A0A251BA2", "playerIDBuff", self.Maelforge)
	self.Maelforge.Triggers.Hell_Green:AddAlert(self.Maelforge.AlertsRef.Hell_Green, true)
	self.Maelforge.Triggers.Hell_Green:AddSpy(self.Maelforge.MechRef.Hell_Green)
	self.Maelforge.Triggers.Fissure = KBM.Trigger:Create(self.Lang.Notify.Fissure[KBM.Lang], "notify", self.Maelforge)
	self.Maelforge.Triggers.Fissure:AddTimer(self.Maelforge.TimersRef.Fissure)
	self.Maelforge.Triggers.Fiery = KBM.Trigger:Create(self.Lang.Debuff.Fiery[KBM.Lang], "playerBuff", self.Maelforge)
	self.Maelforge.Triggers.Fiery:AddAlert(self.Maelforge.AlertsRef.Fiery, true)
	self.Maelforge.Triggers.Earthen = KBM.Trigger:Create(self.Lang.Debuff.Earthen[KBM.Lang], "playerBuff", self.Maelforge)
	self.Maelforge.Triggers.Earthen:AddAlert(self.Maelforge.AlertsRef.Earthen, true)
	self.Maelforge.Triggers.PhaseTwo = KBM.Trigger:Create(65, "percent", self.Maelforge)
	self.Maelforge.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Maelforge.Triggers.PhaseFinal = KBM.Trigger:Create(30, "percent", self.Maelforge)
	self.Maelforge.Triggers.PhaseFinal:AddPhase(self.PhaseCannons)
	
	-- Assign Alerts to Cannon Triggers
	self.Cannon.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "personalCast", self.Cannon)
	self.Cannon.Triggers.Blast:AddAlert(self.Cannon.AlertsRef.Blast)
	self.Cannon.Triggers.BlastInt = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "personalInterrupt", self.Cannon)
	self.Cannon.Triggers.BlastInt:AddStop(self.Cannon.AlertsRef.Blast)
		
	self.Maelforge.CastBar = KBM.CastBar:Add(self, self.Maelforge)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end