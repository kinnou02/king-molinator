-- Maelforge Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDMF_Settings = nil
chKBMINDMF_Settings = nil

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
	File = "Maelforge.lua",
	Instance = IND.Name,
	InstanceObj = IND,
	HasPhases = true,
	Lang = {},
	ID = "Maelforge",
	Object = "MF",
	CannonCount = 0,
	EggCount = 0,
	TimeOut = 20,
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
	RaidID = "U35BDBE1C0B7EB642",
	UnitID = nil,
	Castbar = nil,
	MechRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Hellfire = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Hellfire = KBM.Defaults.MechObj.Create("purple"),
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
MF.Lang.Unit.Egg = KBM.Language:Add("Ember Egg")
MF.Lang.Unit.Egg:SetGerman("Glutei")
MF.Lang.Unit.Egg:SetFrench("Œuf de braise")
MF.Lang.Unit.EggShort = KBM.Language:Add("Egg")
MF.Lang.Unit.EggShort:SetGerman("Ei")
MF.Lang.Unit.EggShort:SetFrench("Œuf")

-- Ability Dictionary
MF.Lang.Ability = {}
MF.Lang.Ability.Blast = KBM.Language:Add("Molten Blast")
MF.Lang.Ability.Blast:SetGerman("Geschmolzene Explosion")

-- Notify Dictionary
MF.Lang.Notify = {}
MF.Lang.Notify.PhaseTwo = KBM.Language:Add("Maelforge: Carcera, I will break you and spill your doom across this world. These weaklings shall be the first to die.")
MF.Lang.Notify.PhaseTwo:SetFrench("Maelforge : Carcera, je vous anéantirai et répandrai vos restes sur ce monde. Ces misérables seront les premiers à périr.")
MF.Lang.Notify.PhaseTwo:SetGerman("Flammenmaul: Carcera, ich werde Euch zerbrechen und Unheil über diese Welt bringen. Diese Schwächlinge werden als Erste sterben.")
MF.Lang.Notify.PhaseFinal = KBM.Language:Add("Maelforge: My children will taste your flesh. You whet the appetite of apocalypse.")
MF.Lang.Notify.PhaseFinal:SetFrench("Maelforge : Ma descendance se repaîtra de votre chair. Vous aiguiserez la voracité de l'apocalypse.")
MF.Lang.Notify.PhaseFinal:SetGerman("Flammenmaul: Meine Brut wird Euer Fleisch kosten. Ihr nährt das Verlangen der Apokalypse.")
MF.Lang.Notify.Victory = KBM.Language:Add("Carcera: This world is saved from abomination, but its doom rises on ashen wings.")
MF.Lang.Notify.Victory:SetFrench("Carcera : Le monde est sauvé de ces abominations, mais son destin se construit sur une terre en cendres. Ce lieu était autrefois le foyer sacré de mes adorateurs qui, avant que je ne tombe dans l'oubli, exécutaient des sacrifices en mon honneur. Ces roches réveillent en moi le souvenir de l'odeur du sang et de la chair calcinée.")
MF.Lang.Notify.Victory:SetGerman("Carcera: Diese Welt wurde vor Schrecken bewahrt, aber das Unheil erhebt sich auf äschernen Schwingen. Diese Kammer war einst eine heilige Stätte, wo ich angebetet wurde. Sie brachten mir zu Ehren Opfer dar, bevor ich in Vergessenheit geriet. Diese Felsen erinnern den Geruch von kochendem Blut und brennendem Fleisch.") 

-- Debuff Dictionary
MF.Lang.Debuff = {}
MF.Lang.Debuff.Hell = KBM.Language:Add("Hellfire")
MF.Lang.Debuff.Hell:SetGerman("Höllenfeuer")
MF.Lang.Debuff.Hell:SetFrench("Hellfire")
MF.Lang.Debuff.Melt = KBM.Language:Add("Melt Armor")

-- Description Dictionary
MF.Lang.Descript = {}
MF.Lang.Descript.Main = KBM.Language:Add("Maelforge - Ember Eggs")
MF.Lang.Descript.Main:SetGerman("Flammenmaul - Gluteier")
MF.Lang.Descript.Main:SetFrench("Maelforge - Œufs de braise")

MF.Maelforge.Name = MF.Lang.Unit.Maelforge[KBM.Lang]
MF.Maelforge.NameShort = MF.Lang.Unit.Maelforge[KBM.Lang]
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
	RaidID = "U3C2D87970BEC0FB4",
	AlertsRef = {},
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Blast = KBM.Defaults.AlertObj.Create("yellow"),
		},
	},	
}

MF.Egg = {
	Mod = MF,
	Level = "??",
	Name = MF.Lang.Unit.Egg[KBM.Lang],
	NameShort = MF.Lang.Unit.EggShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	RaidID = "U4DF4DB2D235CD05C",
	Ignore = true,
	Type = "multi",
}

function MF:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maelforge.Name] = self.Maelforge,
		[self.Cannon.Name] = self.Cannon,
		[self.Egg.Name] = self.Egg,
	}
end

function MF:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maelforge.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		-- TimersRef = self.Maelforge.Settings.TimersRef,
		Maelforge = {
			AlertsRef = self.Maelforge.Settings.AlertsRef,
			MechRef = self.Maelforge.Settings.MechRef,
		},
		Cannon = {
			AlertsRef = self.Cannon.Settings.AlertsRef,
		},
	}
	KBMINDMF_Settings = self.Settings
	chKBMINDMF_Settings = self.Settings
	
end

function MF:SwapSettings(bool)

	if bool then
		KBMINDMF_Settings = self.Settings
		self.Settings = chKBMINDMF_Settings
	else
		chKBMINDMF_Settings = self.Settings
		self.Settings = KBMINDMF_Settings
	end

end

function MF:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDMF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDMF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDMF_Settings = self.Settings
	else
		KBMINDMF_Settings = self.Settings
	end	
end

function MF:SaveVars()	
	if KBM.Options.Character then
		chKBMINDMF_Settings = self.Settings
	else
		KBMINDMF_Settings = self.Settings
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
		MF.PhaseObj:SetPhase("2")
		MF.PhaseObj.Objectives:AddDeath(MF.Cannon.Name, 6)
		MF.Phase = 2
	end
end

function MF.PhaseFinal()
	if MF.Phase < 3 then
		MF.PhaseObj.Objectives:Remove()
		MF.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		MF.PhaseObj.Objectives:AddDeath(MF.Egg.Name, 3)
		MF.Phase = 3
	end
end

function MF:Death(UnitID)
	if self.Cannon.UnitList[UnitID] then
		if self.Cannon.UnitList[UnitID].Dead == false then
			self.CannonCount = self.CannonCount + 1
			self.Cannon.UnitList[UnitID].CastBar:Remove()
			self.Cannon.UnitList[UnitID].CastBar = nil
			self.Cannon.UnitList[UnitID].Dead = true
			if self.CannonCount == 6 then
				self.PhaseFinal()
			end
		end
	elseif self.Egg.UnitList[UnitID] then
		if self.Egg.UnitList[UnitID].Dead == false then
			self.EggCount = self.EggCount + 1
			self.Egg.UnitList[UnitID].Dead = true
			if self.EggCount == 3 then
				return true
			end
		end
	end
	return false
end

function MF:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			local BossObj = self.Bosses[uDetails.name]
			if BossObj then
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
						self.PhaseObj:SetPhase("1")
						self.PhaseObj.Objectives:AddPercent(self.Maelforge.Name, 50, 100)
						self.Phase = 1
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
							if self.Phase == 1 then
								self.PhaseTwo()
							end
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
end

function MF:Reset()
	self.EncounterRunning = false
	self.PhaseObj:End(Inspect.Time.Real())
	self.Phase = 1
	self.CannonCount = 0
	self.EggCount = 0
	for UnitID, BossObj in pairs(self.Cannon.UnitList) do
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
			BossObj.CastBar = nil
		end
	end
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
		if BossObj.UnitList then
			BossObj.UnitList = {}
		end		
	end
end

function MF:Timer()	
end

function MF:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Maelforge, self.Enabled)
end

function MF:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Maelforge)
	
	-- Create Alerts (Maelforge)
	self.Maelforge.AlertsRef.Hellfire = KBM.Alert:Create(self.Lang.Debuff.Hell[KBM.Lang], nil, false, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Maelforge)
	
	-- Create Alerts (Cannons)
	self.Cannon.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Cannon)
	
	-- Create Spies
	self.Maelforge.MechRef.Hellfire = KBM.MechSpy:Add(self.Lang.Debuff.Hell[KBM.Lang], nil, "playerDebuff", self.Maelforge)
	KBM.Defaults.MechObj.Assign(self.Maelforge)
	
	-- Assign Alerts and Timers to Triggers
	self.Maelforge.Triggers.Hellfire = KBM.Trigger:Create(self.Lang.Debuff.Hell[KBM.Lang], "playerDebuff", self.Maelforge)
	self.Maelforge.Triggers.Hellfire:AddAlert(self.Maelforge.AlertsRef.Hellfire, true)
	self.Maelforge.Triggers.Hellfire:AddSpy(self.Maelforge.MechRef.Hellfire)
	self.Maelforge.Triggers.PhaseTwo = KBM.Trigger:Create(50, "percent", self.Maelforge)
	self.Maelforge.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Maelforge.Triggers.PhaseTwoN = KBM.Trigger:Create(self.Lang.Notify.PhaseTwo[KBM.Lang], "notify", self.Maelforge)
	self.Maelforge.Triggers.PhaseTwoN:AddPhase(self.PhaseTwo)
	self.Maelforge.Triggers.PhaseFinal = KBM.Trigger:Create(self.Lang.Notify.PhaseFinal[KBM.Lang], "notify", self.Maelforge)
	self.Maelforge.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	-- self.Maelforge.Triggers.Victory = KBM.Trigger:Create(self.Lang.Notify.Victory[KBM.Lang], "notify", self.Maelforge)
	-- self.Maelforge.Triggers.Victory:SetVictory()
	-- self.Maelforge.Triggers.Victory = KBM.Trigger:Create(self.Lang.Notify.Victory[KBM.Lang], "say", self.Maelforge)
	-- self.Maelforge.Triggers.Victory:SetVictory()
	
	-- Assign Alerts to Cannon Triggers
	self.Cannon.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "personalCast", self.Cannon)
	self.Cannon.Triggers.Blast:AddAlert(self.Cannon.AlertsRef.Blast)
	self.Cannon.Triggers.BlastInt = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "personalInterrupt", self.Cannon)
	self.Cannon.Triggers.BlastInt:AddStop(self.Cannon.AlertsRef.Blast)
	
	self.Maelforge.CastBar = KBM.CastBar:Add(self, self.Maelforge)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end