-- Regulos Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEERS_Settings = nil
chKBMSLRDEERS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local EE = KBM.BossMod["REndless_Eclipse"]

local REG = {
	Enabled = true,
	Directory = EE.Directory,
	File = "Regulos.lua",
	Instance = EE.Name,
	InstanceObj = EE,
	HasPhases = true,
	Lang = {},
	ID = "Regulos",
	Object = "REG",
	Enrage = 13 * 60,
	VoidCounter = 0,
	CounterObj = nil,
}

REG.Regulos = {
	Mod = REG,
	Level = "??",
	Active = false,
	Name = "Regulos",
	NameShort = "Regulos",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	UTID = "UFF5EE9B9158B8C9E",
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
			Apotheosis = KBM.Defaults.TimerObj.Create("red"),
			FirstTentacles = KBM.Defaults.TimerObj.Create("cyan"),
			Crash = KBM.Defaults.TimerObj.Create("red"),
			Vanquish = KBM.Defaults.TimerObj.Create("red"),
			FirstVanquish = KBM.Defaults.TimerObj.Create("red"),
			FirstCrash = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Eradicate = KBM.Defaults.AlertObj.Create("purple"),
			Vanquish = KBM.Defaults.AlertObj.Create("red"),
			Tentacle = KBM.Defaults.AlertObj.Create("cyan"),
			Dominion = KBM.Defaults.AlertObj.Create("dark_grey"),
		},
		MechRef = {
			Enabled = true,
			Doom = KBM.Defaults.MechObj.Create("cyan"),
			Eradicate = KBM.Defaults.MechObj.Create("purple"),
			Glimpse = KBM.Defaults.MechObj.Create("dark_green"),
			Darkness = KBM.Defaults.MechObj.Create("orange"),
			Dominion = KBM.Defaults.MechObj.Create("dark_grey"),
		},
	}
}

KBM.RegisterMod(REG.ID, REG)

-- Main Unit Dictionary
REG.Lang.Unit = {}
REG.Lang.Unit.Regulos = KBM.Language:Add("Regulos")
REG.Lang.Unit.Regulos:SetGerman("Regulos")
REG.Lang.Unit.Regulos:SetFrench("Regulos")
REG.Lang.Unit.RegulosShort = KBM.Language:Add("Regulos")
REG.Lang.Unit.RegulosShort:SetGerman("Regulos")
REG.Lang.Unit.RegulosShort:SetFrench("Regulos")
REG.Lang.Unit.Shambler = KBM.Language:Add("Shambling Nightmare")
REG.Lang.Unit.Shambler:SetFrench("Cauchemar indolent")
REG.Lang.Unit.Shambler:SetGerman("Torkelnder Albtraum")
REG.Lang.Unit.Molinar = KBM.Language:Add("Dark Thane Molinar")
REG.Lang.Unit.Molinar:SetFrench("Baron des ténèbres Molinar")
REG.Lang.Unit.Molinar:SetGerman("Dunkler Vasall Molinar")
REG.Lang.Unit.MolinarShort = KBM.Language:Add("Molinar")
REG.Lang.Unit.MolinarShort:SetGerman("Molinar")
REG.Lang.Unit.MolinarShort:SetFrench("Molinar")
REG.Lang.Unit.Sicaron = KBM.Language:Add("Sicaron")
REG.Lang.Unit.Sicaron:SetGerman("Sicaron")
REG.Lang.Unit.Sicaron:SetFrench("Sicaron")
REG.Lang.Unit.Kosic = KBM.Language:Add("Hierarch Kosic")
REG.Lang.Unit.Kosic:SetGerman("Hierarch Kosic")
REG.Lang.Unit.Kosic:SetFrench("Hiérarque Kosic")

-- Ability Dictionary
REG.Lang.Ability = {}
REG.Lang.Ability.Tentacle = KBM.Language:Add("Tentacle Storm") -- 10s cast time
REG.Lang.Ability.Tentacle:SetFrench("Tempête tentaculaire") 
REG.Lang.Ability.Tentacle:SetGerman("Tentakelsturm")
REG.Lang.Ability.Apotheosis = KBM.Language:Add("Death's Apotheosis") -- 72.5s cast time
REG.Lang.Ability.Apotheosis:SetFrench("Apothéose de la Mort") 
REG.Lang.Ability.Apotheosis:SetGerman("Vergöttlichung des Todes")
REG.Lang.Ability.Calamity = KBM.Language:Add("Invoke Calamity") -- 3.5s cast time
REG.Lang.Ability.Calamity:SetFrench("Invocation de calamité")
REG.Lang.Ability.Calamity:SetGerman("Unheil herbeirufen")
REG.Lang.Ability.Vanquish = KBM.Language:Add("Vanquish the Weak")
REG.Lang.Ability.Vanquish:SetFrench("Victoire sur les faibles")
REG.Lang.Ability.Vanquish:SetGerman("Überwindung der Schwachen")
REG.Lang.Ability.Crash = KBM.Language:Add("Crash of Souls")
REG.Lang.Ability.Crash:SetGerman("Zusammenstoß der Seelen")
REG.Lang.Ability.Crash:SetFrench("Écrasement d'âmes")
REG.Lang.Ability.Vortex = KBM.Language:Add("Vortex of Agony")
REG.Lang.Ability.Vortex:SetGerman("Wirbel der Qual")
REG.Lang.Ability.Vortex:SetFrench("Vortex d'agonie")
REG.Lang.Ability.Void = KBM.Language:Add("Void Assault")
REG.Lang.Ability.Void:SetGerman("Leereangriff")
REG.Lang.Ability.Void:SetFrench("Assaut du Néant")
REG.Lang.Ability.Hex = KBM.Language:Add("Excruciating Hex")
REG.Lang.Ability.Hex:SetGerman("Quälende Verhexung")
REG.Lang.Ability.Hex:SetRussian("Смертоностное проклятие")
REG.Lang.Ability.Hex:SetFrench("Maléfice accablant")
REG.Lang.Ability.Hex:SetKorean("고문 마법")

-- Debuff Dictionary
REG.Lang.Debuff = {}
REG.Lang.Debuff.Mark = KBM.Language:Add("Mark of the Void") -- Tank debuff
REG.Lang.Debuff.Mark:SetFrench("Marque du Néant")
REG.Lang.Debuff.Mark:SetGerman("Zeichen der Leere")
REG.Lang.Debuff.MarkID = "BFC47C4459394DC79"
REG.Lang.Debuff.Heart = KBM.Language:Add("Heart of Death") -- Middle of boss debuff
REG.Lang.Debuff.Heart:SetFrench("Coeur de la mort")
REG.Lang.Debuff.Heart:SetGerman("Herz des Todes")
REG.Lang.Debuff.HeartID = "B61B61EC658F33554"
REG.Lang.Debuff.Darkness = KBM.Language:Add("Seething Darkness") -- 50k Heal absorb
REG.Lang.Debuff.Darkness:SetFrench("Ténèbres bouillonnantes")
REG.Lang.Debuff.Darkness:SetGerman("Brodelnde Dunkelheit")
REG.Lang.Debuff.DarknessID1 = "B102AB75ED903C096"
REG.Lang.Debuff.DarknessID = "BFA88E73C5E9309E8"
REG.Lang.Debuff.Dominion = KBM.Language:Add("Unholy Dominion") -- DoT that wipes raid if player dies.
REG.Lang.Debuff.Dominion:SetGerman("Unheilige Herrschaft")
REG.Lang.Debuff.Dominion:SetFrench("Domination impie")
REG.Lang.Debuff.DominionID = "BFBFA067BB378ECD3"
REG.Lang.Debuff.Doom = KBM.Language:Add("Impending Doom")
REG.Lang.Debuff.Doom:SetFrench("Étreinte de la mort")
REG.Lang.Debuff.Doom:SetGerman("Drohender Untergang")
REG.Lang.Debuff.DoomID = "B6D600F00E8521132"
REG.Lang.Debuff.Glimpse = KBM.Language:Add("Glimpse the Abyss")
REG.Lang.Debuff.Glimpse:SetFrench("Aperçu des abysses")
REG.Lang.Debuff.Glimpse:SetGerman("Blick in den Abgrund")
REG.Lang.Debuff.GlimpseID = "B5900DBFDE7D6B55F"
REG.Lang.Debuff.Contract = KBM.Language:Add("Unholy Contract")
REG.Lang.Debuff.Contract:SetGerman("Unheiliger Vertrag")
REG.Lang.Debuff.Contract:SetFrench("Contrat impie")

-- Messages Dictionary
REG.Lang.Messages = {}
REG.Lang.Messages.Engulf = KBM.Language:Add("(%a*) is engulfed by seething darkness.")
REG.Lang.Messages.Engulf:SetFrench("(%a*) se retrouve englouti par les Ténèbres bouillonnantes.")
REG.Lang.Messages.Engulf:SetGerman("(%a*) ist von brodelnder Dunkelheit umgeben.")
REG.Lang.Messages.Eradicate = KBM.Language:Add("Regulos prepares to eradicate (%a*).") -- 
REG.Lang.Messages.Eradicate:SetFrench("Regulos se prépare à éradiquer (%a*).") -- 
REG.Lang.Messages.Eradicate:SetGerman("Regulos bereitet sich darauf vor, (%a*) auszulöschen.")
REG.Lang.Messages.Will = KBM.Language:Add("Regulos imposes his will upon (%a*).")
REG.Lang.Messages.Will:SetFrench("Regulos impose sa volonté à (%a*).")
REG.Lang.Messages.Will:SetGerman("Regulos zwingt (%a*) seinen Willen auf.")
REG.Lang.Messages.Runic = KBM.Language:Add("Dark Thane Molinar begins to conjure a runic curse.")
REG.Lang.Messages.Runic:SetGerman("Dunkler Vasall Molinar beginnt, einen Runenfluch auszusprechen.")
REG.Lang.Messages.Runic:SetFrench("Baron des ténèbres Molinar commence à évoquer une malédiction runique.")
REG.Lang.Messages.Contract = KBM.Language:Add("Sicaron forces (%a*) into an unholy contract")
REG.Lang.Messages.Contract:SetGerman("Sicaron zwingt (%a*) in einen unheiligen Pakt")
REG.Lang.Messages.Contract:SetFrench("Sicaron force (%a*) à passer un contrat impie.")

-- Verbose Dictionary
REG.Lang.Verbose = {}
REG.Lang.Verbose.Eradicate = KBM.Language:Add("Eradicate")
REG.Lang.Verbose.Eradicate:SetFrench("Éradication")
REG.Lang.Verbose.Eradicate:SetGerman("Auslöschen")
REG.Lang.Verbose.Stack = KBM.Language:Add("Stack! Meteor time!")
REG.Lang.Verbose.Stack:SetFrench("Stack! Chûte de Météorite!")
REG.Lang.Verbose.Stack:SetGerman("Zusammenstehen! Meteor!")
REG.Lang.Verbose.LookAway = KBM.Language:Add("Look Away!")
REG.Lang.Verbose.LookAway:SetGerman("Wegschauen!")
REG.Lang.Verbose.LookAway:SetFrench("Retournez-vous!")

-- Description Dictionary
REG.Lang.Main = {}
REG.Lang.Main.Descript = KBM.Language:Add("Regulos")
REG.Lang.Main.Descript:SetGerman("Schreckensfürst Regulos")
REG.Lang.Main.Descript:SetFrench("Regulos")
REG.Descript = REG.Lang.Main.Descript[KBM.Lang]

-- MechSpy Dictionary
REG.Lang.MechSpy = {}
REG.Lang.MechSpy.Buff = KBM.Language:Add("Buffed: Unholy Contract")
REG.Lang.MechSpy.Buff:SetGerman("Buff: Unheiliger Vertrag")
REG.Lang.MechSpy.Buff:SetFrench("Buffed: Contrat impie")
REG.Lang.MechSpy.Debuff = KBM.Language:Add("Debuffed: Unholy Contract")
REG.Lang.MechSpy.Debuff:SetGerman("Debuff: Unheiliger Vertrag")
REG.Lang.MechSpy.Debuff:SetFrench("Debuffed: Contrat impie")

-- Assign Boss to Language Specific Dictionary
REG.Regulos.Name = REG.Lang.Unit.Regulos[KBM.Lang]
REG.Regulos.NameShort = REG.Lang.Unit.RegulosShort[KBM.Lang]

REG.Sicaron = {
	Mod = REG,
	Level = "??",
	Active = false,
	Name = REG.Lang.Unit.Sicaron[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFC2ABBAB6F651B44",
	UnitID = nil,
	Triggers = {},
	AlertsRef = {},
	MechRef = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Contract = KBM.Defaults.AlertObj.Create("blue"),
			ContractRed = KBM.Defaults.AlertObj.Create("red"),
			Hex = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Buff = KBM.Defaults.MechObj.Create("blue"),
			Debuff = KBM.Defaults.MechObj.Create("red"),
		},
	},
}

REG.Molinar = {
	Mod = REG,
	Level = "??",
	Active = false,
	Name = REG.Lang.Unit.Molinar[KBM.Lang],
	NameShort = REG.Lang.Unit.MolinarShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFAD3C441752F0739",
	UnitID = nil,
	Triggers = {},
	AlertsRef = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			LookAway = KBM.Defaults.AlertObj.Create("red"),
		},
	},
}

REG.Shambler = {
	Mod = REG,
	Level = "??",
	Active = false,
	Name = REG.Lang.Unit.Shambler[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFE6B1D9142DF21D4",
	UnitID = nil,
}

REG.Kosic = {
	Mod = REG,
	Level = "??",
	Active = false,
	Name = REG.Lang.Unit.Kosic[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFFEE7B8544FF500E",
	UnitID = nil,
}

function REG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Regulos.Name] = self.Regulos,
		[self.Sicaron.Name] = self.Sicaron,
		[self.Shambler.Name] = self.Shambler,
		[self.Molinar.Name] = self.Molinar,
		[self.Kosic.Name] = self.Kosic,
	}
end

function REG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		
		Regulos = {
			CastBar = self.Regulos.Settings.CastBar,
			TimersRef = self.Regulos.Settings.TimersRef,
			AlertsRef = self.Regulos.Settings.AlertsRef,
			MechRef = self.Regulos.Settings.MechRef,
		},
		Sicaron = {
			CastBar = self.Sicaron.Settings.CastBar,
			AlertsRef = self.Sicaron.Settings.AlertsRef,
			MechRef = self.Sicaron.Settings.MechRef,
		},
		Molinar = {
			AlertsRef = self.Molinar.Settings.AlertsRef,
		},
	}
	KBMSLRDEERS_Settings = self.Settings
	chKBMSLRDEERS_Settings = self.Settings
	
end

function REG:SwapSettings(bool)

	if bool then
		KBMSLRDEERS_Settings = self.Settings
		self.Settings = chKBMSLRDEERS_Settings
	else
		chKBMSLRDEERS_Settings = self.Settings
		self.Settings = KBMSLRDEERS_Settings
	end

end

function REG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDEERS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDEERS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDEERS_Settings = self.Settings
	else
		KBMSLRDEERS_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function REG:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDEERS_Settings = self.Settings
	else
		KBMSLRDEERS_Settings = self.Settings
	end	
end

function REG:Castbar(units)
end

function REG:RemoveUnits(UnitID)
	if self.Regulos.UnitID == UnitID then
		self.Regulos.Available = false
		return true
	end
	return false
end

function REG:Death(UnitID)
	if self.Regulos.UnitID == UnitID then
		self.Regulos.Dead = true
		return true
	elseif self.Sicaron.UnitID == UnitID then
		self.Sicaron.Dead = true
	elseif self.Shambler.UnitID == UnitID then
		self.Shambler.Dead = true
	elseif self.Molinar.UnitID == UnitID then
		self.Molinar.Dead = true
	elseif self.Kosic.UnitID == UnitID then
		self.Kosic.Dead = true
	end

	if self.Sicaron.Dead and self.Shambler.Dead and self.Molinar.Dead and self.Kosic.Dead then
		if self.Phase == 2 then
			self.PhaseObj.Objectives:Remove()
			self.PhaseObj:SetPhase("3")
			self.PhaseObj.Objectives:AddPercent(self.Regulos, 25, 70)
			self.Phase = 3
		elseif self.Phase == 4 then
			self.PhaseObj.Objectives:Remove()
			self.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
			self.PhaseObj.Objectives:AddPercent(self.Regulos, 0, 25)
			self.Phase = 5
		end
	end
	return false
end

function REG.PhaseVoid()
	if REG.Phase == 2 then
		REG.PhaseObj.Objectives:Remove()
		REG.PhaseObj:SetPhase("3")
		REG.PhaseObj.Objectives:AddPercent(REG.Regulos, 25, 70)
		REG.Phase = 3
	elseif REG.Phase == 4 then
		REG.PhaseObj.Objectives:Remove()
		REG.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		REG.PhaseObj.Objectives:AddPercent(REG.Regulos, 0, 25)
		REG.Phase = 5
	end

	if REG.CounterObj == nil then
		REG.CounterObj = REG.PhaseObj.Objectives:AddMeta(REG.Lang.Ability.Void[KBM.Lang], 999, 0)
	end
	REG.VoidCounter = REG.VoidCounter + 1
	REG.CounterObj:Update(REG.VoidCounter)
end

function REG.PhaseVoidReset()
end

function REG.PhaseGateOne()

end

function REG.PhaseGateTwo()

end

function REG.PhaseTwo()
	KBM.MechTimer:AddRemove(REG.Regulos.TimersRef.Vanquish)
	KBM.MechTimer:AddRemove(REG.Regulos.TimersRef.Crash)
	if REG.Phase < 2 then
		REG.PhaseObj.Objectives:Remove()
		REG.PhaseObj:SetPhase("2")
		REG.PhaseObj.Objectives:AddPercent(REG.Regulos, 0, 75)
		REG.PhaseObj.Objectives:AddPercent(REG.Sicaron, 0, 100)
		REG.PhaseObj.Objectives:AddPercent(REG.Shambler, 0, 100)
		REG.PhaseObj.Objectives:AddPercent(REG.Molinar, 0, 100)
		REG.PhaseObj.Objectives:AddPercent(REG.Kosic, 0, 100)
		REG.Phase = 2
		REG.VoidCounter = 0
	end
end

function REG.PhaseThree()
	if REG.Phase == 2 then
		REG.PhaseObj.Objectives:Remove()
		REG.PhaseObj:SetPhase("3")
		REG.PhaseObj.Objectives:AddPercent(REG.Regulos, 25, 70)
		REG.Phase = 3
	end
end

function REG.PhaseFour()
	KBM.MechTimer:AddRemove(REG.Regulos.TimersRef.Vanquish)
	KBM.MechTimer:AddRemove(REG.Regulos.TimersRef.Crash)
	if REG.Phase < 4 then
		REG.PhaseObj.Objectives:Remove()
		REG.PhaseObj:SetPhase("4")
		REG.Sicaron.Dead = false
		REG.Sicaron.UnitID = nil
		REG.Shambler.Dead = false
		REG.Shambler.UnitID = nil
		REG.Molinar.Dead = false
		REG.Molinar.UnitID = nil
		REG.Kosic.Dead = false
		REG.Kosic.UnitID = nil
		REG.PhaseObj.Objectives:AddPercent(REG.Regulos, 0, 25)
		REG.PhaseObj.Objectives:AddPercent(REG.Sicaron, 0, 100)
		REG.PhaseObj.Objectives:AddPercent(REG.Shambler, 0, 100)
		REG.PhaseObj.Objectives:AddPercent(REG.Molinar, 0, 100)
		REG.PhaseObj.Objectives:AddPercent(REG.Kosic, 0, 100)
		REG.Phase = 4
		REG.VoidCounter = 0
	end
end

function REG.PhaseFinal()
	if REG.Phase == 4 then
		REG.PhaseObj.Objectives:Remove()
		REG.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		REG.PhaseObj.Objectives:AddPercent(REG.Regulos, 0, 25)
		REG.Phase = 5
	end
end

function REG:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
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
				self.PhaseObj.Objectives:AddPercent(self.Regulos, 0, 100)
				self.Phase = 1
				local DebuffTable = {
					[1] = self.Lang.Debuff.MarkID,
					[2] = self.Lang.Debuff.DarknessID,
				}
				KBM.TankSwap:Start(DebuffTable, unitID, 2)
				KBM.MechTimer:AddStart(self.Regulos.TimersRef.FirstVanquish)
				KBM.MechTimer:AddStart(self.Regulos.TimersRef.FirstCrash)
				KBM.MechTimer:AddStart(self.Regulos.TimersRef.FirstTentacles)
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.CastBar then
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

function REG:Reset()
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
	self.VoidCounter = 0
	self.CounterObj = nil
end

function REG:Timer()	
end

function REG:DefineMenu()
	self.Menu = EE.Menu:CreateEncounter(self.Regulos, self.Enabled)
end

function REG:Start()
	-- Create Timers
	self.Regulos.TimersRef.Apotheosis = KBM.MechTimer:Add(self.Lang.Ability.Apotheosis[KBM.Lang], 72, false)
	self.Regulos.TimersRef.FirstTentacles = KBM.MechTimer:Add(self.Lang.Ability.Tentacle[KBM.Lang], 47, false)
	self.Regulos.TimersRef.Crash = KBM.MechTimer:Add(self.Lang.Ability.Crash[KBM.Lang], 30, false)
	self.Regulos.TimersRef.Crash:Wait()
	self.Regulos.TimersRef.FirstCrash = KBM.MechTimer:Add(self.Lang.Ability.Crash[KBM.Lang], 26, false)
	self.Regulos.TimersRef.Vanquish = KBM.MechTimer:Add(self.Lang.Ability.Vanquish[KBM.Lang], 30, false)
	self.Regulos.TimersRef.Vanquish:Wait()
	self.Regulos.TimersRef.FirstVanquish = KBM.MechTimer:Add(self.Lang.Ability.Vanquish[KBM.Lang], 11, false)
	KBM.Defaults.TimerObj.Assign(self.Regulos)

	self.Regulos.TimersRef.Vanquish:SetLink(self.Regulos.TimersRef.FirstVanquish)
	self.Regulos.TimersRef.Crash:SetLink(self.Regulos.TimersRef.FirstCrash)
	
	-- Create Alerts
	self.Regulos.AlertsRef.Eradicate = KBM.Alert:Create(self.Lang.Verbose.Stack[KBM.Lang], 8, true, true, "purple")
	self.Regulos.AlertsRef.Vanquish = KBM.Alert:Create(self.Lang.Ability.Vanquish[KBM.Lang], nil, true, true, "red")
	self.Regulos.AlertsRef.Tentacle = KBM.Alert:Create(self.Lang.Ability.Tentacle[KBM.Lang], nil, false, true, "cyan")
	self.Regulos.AlertsRef.Dominion = KBM.Alert:Create(self.Lang.Debuff.Dominion[KBM.Lang], nil, true, true, "dark_grey")
	KBM.Defaults.AlertObj.Assign(self.Regulos)

	self.Sicaron.AlertsRef.Contract = KBM.Alert:Create(self.Lang.Debuff.Contract[KBM.Lang], 12, false, true, "blue")
	self.Sicaron.AlertsRef.Contract:Important()
	self.Sicaron.AlertsRef.ContractRed = KBM.Alert:Create(self.Lang.Debuff.Contract[KBM.Lang], 5, true, true, "red")
	self.Sicaron.AlertsRef.ContractRed:NoMenu()
	self.Sicaron.AlertsRef.ContractRed:Important()
	self.Sicaron.AlertsRef.Contract:AlertEnd(self.Sicaron.AlertsRef.ContractRed)
	self.Sicaron.AlertsRef.Hex = KBM.Alert:Create(self.Lang.Ability.Hex[KBM.Lang], nil, false, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Sicaron)

	self.Molinar.AlertsRef.LookAway = KBM.Alert:Create(self.Lang.Verbose.LookAway[KBM.Lang], 4, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Molinar)

	-- Create Mechanic Spies
	self.Regulos.MechRef.Doom = KBM.MechSpy:Add(self.Lang.Debuff.Doom[KBM.Lang], nil, "playerIDDebuff", self.Regulos)
	self.Regulos.MechRef.Eradicate = KBM.MechSpy:Add(self.Lang.Verbose.Eradicate[KBM.Lang], 8, "notify", self.Regulos)
	self.Regulos.MechRef.Glimpse = KBM.MechSpy:Add(self.Lang.Debuff.Glimpse[KBM.Lang], nil, "playerIDDebuff", self.Regulos)
	self.Regulos.MechRef.Darkness = KBM.MechSpy:Add(self.Lang.Debuff.Darkness[KBM.Lang], 60, "playerIDDebuff", self.Regulos)
	self.Regulos.MechRef.Dominion = KBM.MechSpy:Add(self.Lang.Debuff.Dominion[KBM.Lang], nil, "playerIDDebuff", self.Regulos)
	KBM.Defaults.MechObj.Assign(self.Regulos)

	self.Sicaron.MechRef.Buff = KBM.MechSpy:Add(self.Lang.MechSpy.Buff[KBM.Lang], 12, "mechanic", self.Sicaron)
	self.Sicaron.MechRef.Debuff = KBM.MechSpy:Add(self.Lang.MechSpy.Debuff[KBM.Lang], 5, "mechanic", self.Sicaron)
	self.Sicaron.MechRef.Debuff:NoMenu()
	self.Sicaron.MechRef.Buff:SpyAfter(self.Sicaron.MechRef.Debuff)
	KBM.Defaults.MechObj.Assign(self.Sicaron)
	
	-- Assign Alerts and Timers to Triggers
	self.Regulos.Triggers.Eradicate = KBM.Trigger:Create(self.Lang.Messages.Eradicate[KBM.Lang], "notify", self.Regulos)
	self.Regulos.Triggers.Eradicate:AddAlert(self.Regulos.AlertsRef.Eradicate, true)
	self.Regulos.Triggers.Eradicate:AddSpy(self.Regulos.MechRef.Eradicate)
	
	self.Sicaron.Triggers.Hex = KBM.Trigger:Create(self.Lang.Ability.Hex[KBM.Lang], "cast", self.Sicaron)
	self.Sicaron.Triggers.Hex:AddAlert(self.Sicaron.AlertsRef.Hex)

	self.Regulos.Triggers.Doom = KBM.Trigger:Create(self.Lang.Debuff.Doom[KBM.Lang], "playerBuff", self.Regulos)
	self.Regulos.Triggers.Doom:AddSpy(self.Regulos.MechRef.Doom)
	self.Regulos.Triggers.DoomRem = KBM.Trigger:Create(self.Lang.Debuff.Doom[KBM.Lang], "playerBuffRemove", self.Regulos)
	self.Regulos.Triggers.DoomRem:AddStop(self.Regulos.MechRef.Doom)

	self.Regulos.Triggers.Glimpse = KBM.Trigger:Create(self.Lang.Debuff.Glimpse[KBM.Lang], "playerBuff", self.Regulos)
	self.Regulos.Triggers.Glimpse:AddSpy(self.Regulos.MechRef.Glimpse)
	self.Regulos.Triggers.GlimpseRem = KBM.Trigger:Create(self.Lang.Debuff.Glimpse[KBM.Lang], "playerBuffRemove", self.Regulos)
	self.Regulos.Triggers.GlimpseRem:AddStop(self.Regulos.MechRef.Glimpse)

	self.Regulos.Triggers.Darkness = KBM.Trigger:Create(self.Lang.Debuff.Darkness[KBM.Lang], "playerBuff", self.Regulos)
	self.Regulos.Triggers.Darkness:AddSpy(self.Regulos.MechRef.Darkness)
	self.Regulos.Triggers.DarknessRem = KBM.Trigger:Create(self.Lang.Debuff.Darkness[KBM.Lang], "playerBuffRemove", self.Regulos)
	self.Regulos.Triggers.DarknessRem:AddStop(self.Regulos.MechRef.Darkness)

	self.Regulos.Triggers.Dominion = KBM.Trigger:Create(self.Lang.Debuff.Dominion[KBM.Lang], "playerBuff", self.Regulos)
	self.Regulos.Triggers.Dominion:AddSpy(self.Regulos.MechRef.Dominion)
	self.Regulos.Triggers.Dominion:AddAlert(self.Regulos.AlertsRef.Dominion)
	self.Regulos.Triggers.DominionRem = KBM.Trigger:Create(self.Lang.Debuff.Dominion[KBM.Lang], "playerBuffRemove", self.Regulos)
	self.Regulos.Triggers.DominionRem:AddStop(self.Regulos.MechRef.Dominion)
	self.Regulos.Triggers.DominionRem:AddStop(self.Regulos.AlertsRef.Dominion)

	self.Regulos.Triggers.Apotheosis = KBM.Trigger:Create(self.Lang.Ability.Apotheosis[KBM.Lang], "channel", self.Regulos)
	self.Regulos.Triggers.Apotheosis:AddTimer(self.Regulos.TimersRef.Apotheosis)
	self.Regulos.Triggers.Apotheosis:AddPhase(self.PhaseVoidReset)

	self.Regulos.Triggers.Vanquish = KBM.Trigger:Create(self.Lang.Ability.Vanquish[KBM.Lang], "channel", self.Regulos)
	self.Regulos.Triggers.Vanquish:AddAlert(self.Regulos.AlertsRef.Vanquish)
	self.Regulos.Triggers.Vanquish:AddTimer(self.Regulos.TimersRef.Vanquish)

	self.Regulos.Triggers.Tentacle = KBM.Trigger:Create(self.Lang.Ability.Tentacle[KBM.Lang], "channel", self.Regulos)
	self.Regulos.Triggers.Tentacle:AddAlert(self.Regulos.AlertsRef.Tentacle)

	self.Regulos.Triggers.Crash = KBM.Trigger:Create(self.Lang.Ability.Crash[KBM.Lang], "channel", self.Regulos)
	self.Regulos.Triggers.Crash:AddTimer(self.Regulos.TimersRef.Crash)

	self.Regulos.Triggers.Void = KBM.Trigger:Create(self.Lang.Ability.Void[KBM.Lang], "channel", self.Regulos)
	self.Regulos.Triggers.Void:AddPhase(self.PhaseVoid)

	self.Regulos.Triggers.GateOne = KBM.Trigger:Create(94, "percent", self.Regulos)
	self.Regulos.Triggers.GateOne:AddPhase(self.PhaseGateOne)

	self.Regulos.Triggers.GateTwo = KBM.Trigger:Create(86, "percent", self.Regulos)
	self.Regulos.Triggers.GateTwo:AddPhase(self.PhaseGateTwo)

	self.Regulos.Triggers.PhaseTwo = KBM.Trigger:Create(70, "percent", self.Regulos)
	self.Regulos.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)

	self.Regulos.Triggers.PhaseFour = KBM.Trigger:Create(25, "percent", self.Regulos)
	self.Regulos.Triggers.PhaseFour:AddPhase(self.PhaseFour)

	self.Sicaron.Triggers.Contract = KBM.Trigger:Create(self.Lang.Messages.Contract[KBM.Lang], "notify", self.Sicaron)
	self.Sicaron.Triggers.Contract:AddAlert(self.Sicaron.AlertsRef.Contract, true)
	self.Sicaron.Triggers.Contract:AddSpy(self.Sicaron.MechRef.Buff)

	self.Molinar.Triggers.Runic = KBM.Trigger:Create(self.Lang.Messages.Runic[KBM.Lang], "notify", self.Molinar)
	self.Molinar.Triggers.Runic:AddAlert(self.Molinar.AlertsRef.LookAway)
	
	self.Regulos.CastBar = KBM.Castbar:Add(self, self.Regulos)
	self.Sicaron.CastBar = KBM.Castbar:Add(self, self.Sicaron)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end