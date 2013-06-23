-- Crucia Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDFTCR_Settings = nil
chKBMSLRDFTCR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local FT = KBM.BossMod["RFrozen_Tempest"]

local CRC = {
	Enabled = true,
	Directory = FT.Directory,
	File = "Crucia.lua",
	Instance = FT.Name,
	InstanceObj = FT,
	HasPhases = true,
	Lang = {},
	Enrage = 12 * 60,
	ID = "Crucia",
	Object = "CRC",
}

KBM.RegisterMod(CRC.ID, CRC)

-- Main Unit Dictionary
CRC.Lang.Unit = {}
CRC.Lang.Unit.Crucia = KBM.Language:Add("Crucia")
CRC.Lang.Unit.Crucia:SetGerman("Crucia")
CRC.Lang.Unit.Crucia:SetFrench("Crucia")
CRC.Lang.Unit.CruciaShort = KBM.Language:Add("Crucia")
CRC.Lang.Unit.CruciaShort:SetGerman("Crucia")
CRC.Lang.Unit.CruciaShort:SetFrench("Crucia")
CRC.Lang.Unit.Tempest = KBM.Language:Add("Tempest Assault Frame")
CRC.Lang.Unit.Tempest:SetGerman("Sturmherr-Sturmrüstung")
CRC.Lang.Unit.Tempest:SetFrench("Structure d'assaut tempétueuse")
CRC.Lang.Unit.TempestShort = KBM.Language:Add("Tempest")
CRC.Lang.Unit.TempestShort:SetGerman("Sturmherr")
CRC.Lang.Unit.TempestShort:SetFrench("Structure")
CRC.Lang.Unit.LTempest = KBM.Language:Add("Left Tempest Assault Frame")
CRC.Lang.Unit.LTempest:SetGerman("Links Sturmherr-Sturmrüstung")
CRC.Lang.Unit.LTempest:SetFrench("Structure d'assaut tempétueuse Gauche")
CRC.Lang.Unit.LTempestShort = KBM.Language:Add("Left Tempest")
CRC.Lang.Unit.LTempestShort:SetGerman("Links Sturmherr")
CRC.Lang.Unit.LTempestShort:SetFrench("Structure Gauche")
CRC.Lang.Unit.RTempest = KBM.Language:Add("Right Tempest Assault Frame")
CRC.Lang.Unit.RTempest:SetGerman("Rechts Sturmherr-Sturmrüstung")
CRC.Lang.Unit.RTempest:SetFrench("Structure d'assaut tempétueuse Droite")
CRC.Lang.Unit.RTempestShort = KBM.Language:Add("Right Tempest")
CRC.Lang.Unit.RTempestShort:SetGerman("Rechts Sturmherr")
CRC.Lang.Unit.RTempestShort:SetFrench("Structure Droite")
CRC.Lang.Unit.Storm = KBM.Language:Add("Stormcore Annihilator")
CRC.Lang.Unit.Storm:SetGerman("Sturmkern-Auslöscher")
CRC.Lang.Unit.Storm:SetFrench("Annihilateur du Cœur de la Tempête")
CRC.Lang.Unit.StormShort = KBM.Language:Add("Stormcore")
CRC.Lang.Unit.StormShort:SetGerman("Sturmkern")
CRC.Lang.Unit.StormShort:SetFrench("Annihilateur")
CRC.Lang.Unit.Construct = KBM.Language:Add("Refactored Construct")
CRC.Lang.Unit.Construct:SetGerman("Überarbeitetes Konstrukt")
CRC.Lang.Unit.Construct:SetFrench("Technogolem reconstruit")
CRC.Lang.Unit.ConstructShort = KBM.Language:Add("Construct")
CRC.Lang.Unit.ConstructShort:SetGerman("Konstrukt")
CRC.Lang.Unit.ConstructShort:SetFrench("Technogolem")
CRC.Lang.Unit.Elemental = KBM.Language:Add("Tempest Elemental")
CRC.Lang.Unit.Elemental:SetFrench("Élémentaire tempétueux")
CRC.Lang.Unit.Elemental:SetGerman("Sturmwindelementar")
CRC.Lang.Unit.ElementalShort = KBM.Language:Add("Elemental")
CRC.Lang.Unit.ElementalShort:SetFrench("Élémentaire")
CRC.Lang.Unit.ElementalShort:SetGerman("Elementar")

-- Ability Dictionary
CRC.Lang.Ability = {}
CRC.Lang.Ability.LBreath = KBM.Language:Add("Lightning Breath")
CRC.Lang.Ability.LBreath:SetGerman("Blitzatem")
CRC.Lang.Ability.LBreath:SetFrench("Souffle foudroyant")
CRC.Lang.Ability.OStrike = KBM.Language:Add("Orbital Strike")
CRC.Lang.Ability.OStrike:SetGerman("Orbitalangriff")
CRC.Lang.Ability.OStrike:SetFrench("Frappe orbitale")
CRC.Lang.Ability.Pulse = KBM.Language:Add("Shocking Pulse")
CRC.Lang.Ability.Pulse:SetGerman("Schockierender Impuls")
CRC.Lang.Ability.Pulse:SetFrench("Impulsion choquante")
CRC.Lang.Ability.Fury = KBM.Language:Add("Tempest Fury")
CRC.Lang.Ability.Fury:SetGerman("Raserei des Sturmherren")
CRC.Lang.Ability.Fury:SetFrench("Fureur tempétueuse")
CRC.Lang.Ability.Wrath = KBM.Language:Add("Tempest Wrath")
CRC.Lang.Ability.Wrath:SetFrench("Courroux tempétueux")
CRC.Lang.Ability.Wrath:SetGerman("Sturmherr-Zorn")
CRC.Lang.Ability.Blessing = KBM.Language:Add("Blessing of the Storm Queen")
CRC.Lang.Ability.Blessing:SetFrench("Bénédiction de la Reine des Tempêtes")
CRC.Lang.Ability.Blessing:SetGerman("Segen der Sturmkönigin")
CRC.Lang.Ability.Armor = KBM.Language:Add("Conductive Armor")
CRC.Lang.Ability.Armor:SetFrench("Armure conductrice")
CRC.Lang.Ability.Armor:SetGerman("Leitende Rüstung")
CRC.Lang.Ability.Spark = KBM.Language:Add("Shatter Spark")

-- Debuff Dictionary
CRC.Lang.Debuff = {}
CRC.Lang.Debuff.Rod = KBM.Language:Add("Lightning Rod")
CRC.Lang.Debuff.Rod:SetGerman("Blitzrute")
CRC.Lang.Debuff.Rod:SetFrench("Paratonnerre")
CRC.Lang.Debuff.Armor = KBM.Language:Add("Conductive Armor")
CRC.Lang.Debuff.Armor:SetGerman("Leitende Rüstung")
CRC.Lang.Debuff.Armor:SetFrench("Armure conductrice")
CRC.Lang.Debuff.ArmorIDConstruct1 = "BFC27D28E7076DEBA"
CRC.Lang.Debuff.ArmorIDConstruct2 = "BFC27D28F689C8068"
CRC.Lang.Debuff.ArmorIDCrucia1 = "BFE59811C6CBE34C4"
CRC.Lang.Debuff.ArmorIDCrucia2 = "BFCCCBAD1C6C69635"
CRC.Lang.Debuff.Blessing = KBM.Language:Add("Blessing of the Storm Queen")
CRC.Lang.Debuff.Blessing:SetFrench("Bénédiction de la Reine des Tempêtes")
CRC.Lang.Debuff.Blessing:SetGerman("Segen der Sturmkönigin")
CRC.Lang.Debuff.BlessingID1 = "BFD3474BD0B3B85A0"
CRC.Lang.Debuff.BlessingID2 = "BFD3474BE4FFA4FC0"
CRC.Lang.Debuff.Unstable = KBM.Language:Add("Unstable Coolant")
CRC.Lang.Debuff.Unstable:SetFrench("Refroidissement instable")
CRC.Lang.Debuff.Unstable:SetGerman("Instabiles Kühlmittel")
CRC.Lang.Debuff.UnstableID = "BFBB93FBD79C85DEF"
CRC.Lang.Debuff.Stablized = KBM.Language:Add("Stablized Coolant")
CRC.Lang.Debuff.Stablized:SetFrench("Refroidissement stabilisé")
CRC.Lang.Debuff.Stablized:SetGerman("Stabilisiertes Kühlmittel")
CRC.Lang.Debuff.StablizedID = "BFF82C871C5EDAD5D"
CRC.Lang.Debuff.Wrath = KBM.Language:Add("Tempest Wrath")
CRC.Lang.Debuff.Wrath:SetFrench("Courroux tempétueux")
CRC.Lang.Debuff.Wrath:SetGerman("Sturmherr-Zorn")

-- Buff Dictionary
CRC.Lang.Buff = {}
CRC.Lang.Buff.Ion = KBM.Language:Add("Ion Shield")
CRC.Lang.Buff.Ion:SetFrench("Ion Shield")
CRC.Lang.Buff.Short = KBM.Language:Add("Short Circuit")
CRC.Lang.Buff.Short:SetFrench("Court-circuit")
CRC.Lang.Buff.Short:SetGerman("Kurzschluss")

-- Verbose Dictionary
CRC.Lang.Verbose = {}
CRC.Lang.Verbose.Fury = KBM.Language:Add("Look away!")
CRC.Lang.Verbose.Fury:SetGerman("WEGSCHAUEN!")
CRC.Lang.Verbose.Fury:SetFrench("Regarder Ailleurs!")
CRC.Lang.Verbose.TankSwap = KBM.Language:Add("Tank Swap")
CRC.Lang.Verbose.TankSwap:SetFrench("Changement Tank")
CRC.Lang.Verbose.TankSwap:SetGerman("Tank-Wechsel")

-- Description Dictionary
CRC.Lang.Main = {}

CRC.Descript = CRC.Lang.Unit.Crucia[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
CRC.Crucia = {
	Mod = CRC,
	Level = "??",
	Active = false,
	Name = CRC.Lang.Unit.Crucia[KBM.Lang],
	NameShort = CRC.Lang.Unit.CruciaShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFFC483AC53C05588",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			LBreath = KBM.Defaults.TimerObj.Create("red"),
			OStrike = KBM.Defaults.TimerObj.Create("blue"),
			TankSwap = KBM.Defaults.TimerObj.Create("cyan"),
		},
		AlertsRef = {
			Enabled = true,
			Fury = KBM.Defaults.AlertObj.Create("orange"),
			Rod = KBM.Defaults.AlertObj.Create("purple"),
			TankSwap = KBM.Defaults.AlertObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
			Wrath = KBM.Defaults.MechObj.Create("dark_green"),
			Unstable = KBM.Defaults.MechObj.Create("red"),
			Stablized = KBM.Defaults.MechObj.Create("blue"),
			Blessing = KBM.Defaults.MechObj.Create("cyan"),
		},
	}
}

CRC.LTempest = {
	Mod = CRC,
	Level = "??",
	Active = false,
	Name = CRC.Lang.Unit.LTempest[KBM.Lang],
	NameShort = CRC.Lang.Unit.LTempestShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFD07694121918804",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		-- TimersRef = {
			-- Enabled = true,
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

CRC.RTempest = {
	Mod = CRC,
	Level = "??",
	Active = false,
	Name = CRC.Lang.Unit.RTempest[KBM.Lang],
	NameShort = CRC.Lang.Unit.RTempestShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U0D630A3B05F784CB",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		-- TimersRef = {
			-- Enabled = true,
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

CRC.Storm = {
	Mod = CRC,
	Level = "??",
	Active = false,
	Name = CRC.Lang.Unit.Storm[KBM.Lang],
	NameShort = CRC.Lang.Unit.StormShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFD07694010BBC537",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
		-- },
		AlertsRef = {
			Enabled = true,
			Pulse = KBM.Defaults.AlertObj.Create("yellow"),
			Spark = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

CRC.Elemental = {
	Mod = CRC,
	Level = "??",
	Active = false,
	Name = CRC.Lang.Unit.Elemental[KBM.Lang],
	NameShort = CRC.Lang.Unit.ElementalShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFD0769434324761B",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
		-- },
		-- AlertsRef = {
			-- Enabled = true,
		-- },
	}
}

CRC.Construct = {
	Mod = CRC,
	Level = "??",
	Active = false,
	Name = CRC.Lang.Unit.Construct[KBM.Lang],
	NameShort = CRC.Lang.Unit.ConstructShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFD07694232CFB315",
	TimeOut = 5,
	Castbar = nil,
	Multi = true,
	UnitList = {},
	Ignore = true,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		-- CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
		-- },
		-- AlertsRef = {
			-- Enabled = true,
		-- },
	}
}

function CRC:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Crucia.Name] = self.Crucia,
		[self.LTempest.Name] = self.LTempest,
		[self.RTempest.Name] = self.RTempest,
		[self.Storm.Name] = self.Storm,
		[self.Elemental.Name] = self.Elemental,
		[self.Construct.Name] = self.Construct,
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

function CRC:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Multi = true,
			Override = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Crucia = {
			CastBar = self.Crucia.Settings.CastBar,
			-- Alerts = KBM.Defaults.Alerts(),
			TimersRef = self.Crucia.Settings.TimersRef,
			-- AlertsRef = self.Crucia.Settings.AlertsRef,
			MechRef = self.Crucia.Settings.MechRef,
		},
		Storm = {
			CastBar = self.Storm.Settings.CastBar,
			AlertsRef = self.Storm.Settings.AlertsRef,
		},
		Elemental = {
			CastBar = self.Elemental.Settings.CastBar,
		},
	}
	KBMSLRDFTCR_Settings = self.Settings
	chKBMSLRDFTCR_Settings = self.Settings
	
end

function CRC:SwapSettings(bool)

	if bool then
		KBMSLRDFTCR_Settings = self.Settings
		self.Settings = chKBMSLRDFTCR_Settings
	else
		chKBMSLRDFTCR_Settings = self.Settings
		self.Settings = KBMSLRDFTCR_Settings
	end

end

function CRC:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDFTCR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDFTCR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDFTCR_Settings = self.Settings
	else
		KBMSLRDFTCR_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function CRC:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDFTCR_Settings = self.Settings
	else
		KBMSLRDFTCR_Settings = self.Settings
	end	
end

function CRC.PhaseTwo()
	if CRC.Phase < 2 then
		CRC.PhaseObj.Objectives:Remove()
		CRC.PhaseObj:SetPhase("2")
		CRC.PhaseObj.Objectives:AddPercent(CRC.Storm, 0, 100)
		CRC.Phase = 2
		if KBM.TankSwap.Active then
			KBM.TankSwap:Remove()
		end
		if CRC.Storm.UnitID then
			local DebuffTable = {
				[1] = CRC.Lang.Debuff.ArmorIDConstruct1,
				[2] = CRC.Lang.Debuff.ArmorIDConstruct2,
			}
			KBM.TankSwap:Start(DebuffTable, CRC.Storm.UnitID, 2)
		end
	end
end

function CRC.PhaseThree()
	if CRC.Phase < 3 then
		CRC.PhaseObj.Objectives:Remove()
		CRC.PhaseObj:SetPhase("3")
		CRC.PhaseObj.Objectives:AddPercent(CRC.Crucia, 60, 100)
		CRC.Phase = 3
		if KBM.TankSwap.Active then
			KBM.TankSwap:Remove()
		end
		if CRC.Crucia.UnitID then
			local DebuffTable = {
				[1] = CRC.Lang.Debuff.ArmorIDCrucia1,
				[2] = CRC.Lang.Debuff.ArmorIDCrucia2,
			}
			KBM.TankSwap:Start(DebuffTable, CRC.Crucia.UnitID, 2)
		end
	end
end

function CRC.PhaseFour()
	if CRC.Phase < 4 then
		CRC.PhaseObj.Objectives:Remove()
		CRC.PhaseObj:SetPhase("4")
		CRC.PhaseObj.Objectives:AddPercent(CRC.Elemental, 0, 100)
		CRC.Phase = 4
	end
end

function CRC.PhaseFinal()
	if CRC.Phase < 5 then
		CRC.PhaseObj.Objectives:Remove()
		CRC.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		CRC.PhaseObj.Objectives:AddPercent(CRC.Crucia, 0, 60)
		CRC.Phase = 5
		if KBM.TankSwap.Active then
			KBM.TankSwap:Remove()
		end
		if CRC.Crucia.UnitID then
			local DebuffTable = {
				[1] = CRC.Lang.Debuff.ArmorIDCrucia1,
				[2] = CRC.Lang.Debuff.ArmorIDCrucia2,
			}
			KBM.TankSwap:Start(DebuffTable, CRC.Crucia.UnitID, 2)
		end
	end
end

function CRC:Castbar(units)
end

function CRC:Death(UnitID)
	if self.Crucia.UnitID == UnitID then
		self.Crucia.Dead = true
		return true
	elseif self.Storm.UnitID == UnitID then
		self.Storm.Dead = true
		self.PhaseThree()
	elseif self.Elemental.UnitID == UnitID then
		self.Elemental.Dead = true
		self.PhaseFinal()
	elseif self.Construct.UnitList[UnitID] then
		self.Construct.UnitList[UnitID].Dead = true
	end
	return false
end

function CRC:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type then
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
					self.Phase = 1
					BossObj.UnitID = unitID
					if BossObj == self.Storm then
						self.PhaseTwo()
					elseif BossObj == self.Elemental then
						self.PhaseFour()
					elseif BossObj == self.Crucia then
						local BossPercentRaw = (uDetails.health/uDetails.healthMax)*100
						if BossPercentRaw > 60 then
							self.PhaseThree()
						else
							self.PhaseFinal()
						end	
					else
						self.PhaseObj:Start(self.StartTime)
						self.PhaseObj:SetPhase("1")
						self.PhaseObj.Objectives:AddPercent(self.LTempest, 0, 100)
						self.PhaseObj.Objectives:AddPercent(self.RTempest, 0, 100)
					end
				else
					if BossObj.Multi then
						if not BossObj.UnitList[unitID] then
							local SubBossObj = {
								Mod = self,
								Level = "??",
								Active = true,
								Name = BossObj.Name,
								NameShort = BossObj.NameShort,
								Dead = false,
								Available = true,
								UnitID = unitID,
							}
							BossObj.UnitList[unitID] = SubBossObj
							return SubBossObj
						end
					else
						BossObj.Dead = false
						BossObj.Casting = false
						if BossObj.UnitID ~= unitID then
							if BossObj.CastBar then						
								BossObj.CastBar:Remove()
								BossObj.CastBar:Create(unitID)
							end
							if BossObj == self.Crucia then
								if self.Phase == 3 then
									if KBM.TankSwap.Active then
										KBM.TankSwap:Remove()
									end
									local DebuffTable = {
										[1] = self.Lang.Debuff.ArmorIDCrucia1,
										[2] = self.Lang.Debuff.ArmorIDCrucia2,
									}
									KBM.TankSwap:Start(DebuffTable, unitID, 2)
								end
							elseif BossObj == self.Storm then
								BossObj.UnitID = unitID
								self.PhaseTwo()
							end
						end
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return BossObj
			end
		end
	end
end

function CRC:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
		if BossObj.Multi then
			BossObj.UnitList = {}
		end
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end	
	self.PhaseObj:End(Inspect.Time.Real())
end

function CRC:Timer()	
end

function CRC:DefineMenu()
	self.Menu = FT.Menu:CreateEncounter(self.Crucia, self.Enabled)
end

function CRC:Start()
	-- Create Timers
	self.Crucia.TimersRef.LBreath = KBM.MechTimer:Add(self.Lang.Ability.LBreath[KBM.Lang], 15)
	self.Crucia.TimersRef.OStrike = KBM.MechTimer:Add(self.Lang.Ability.OStrike[KBM.Lang], 45)
	self.Crucia.TimersRef.TankSwap = KBM.MechTimer:Add(self.Lang.Verbose.TankSwap[KBM.Lang], 30)
	KBM.Defaults.TimerObj.Assign(self.Crucia)
	
	-- Create Alerts
	self.Crucia.AlertsRef.Fury = KBM.Alert:Create(self.Lang.Verbose.Fury[KBM.Lang], nil, false, true, "orange")
	self.Crucia.AlertsRef.Rod = KBM.Alert:Create(self.Lang.Debuff.Rod[KBM.Lang], nil, false, true, "purple")
	self.Crucia.AlertsRef.TankSwap = KBM.Alert:Create(self.Lang.Verbose.TankSwap[KBM.Lang], 4, false, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Crucia)
	
	self.Storm.AlertsRef.Pulse = KBM.Alert:Create(self.Lang.Ability.Pulse[KBM.Lang], nil, false, true, "yellow")
	self.Storm.AlertsRef.Spark = KBM.Alert:Create(self.Lang.Ability.Spark[KBM.Lang], nil, true, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Storm)

	-- Create Spies
	self.Crucia.MechRef.Wrath = KBM.MechSpy:Add(self.Lang.Debuff.Wrath[KBM.Lang], nil, "playerDebuff", self.Crucia)
	self.Crucia.MechRef.Unstable = KBM.MechSpy:Add(self.Lang.Debuff.Unstable[KBM.Lang], nil, "playerDebuff", self.Crucia)
	self.Crucia.MechRef.Stablized = KBM.MechSpy:Add(self.Lang.Debuff.Stablized[KBM.Lang], nil, "playerDebuff", self.Crucia)
	self.Crucia.MechRef.Blessing = KBM.MechSpy:Add(self.Lang.Debuff.Blessing[KBM.Lang], -1, "playerDebuff", self.Crucia)
	KBM.Defaults.MechObj.Assign(self.Crucia)
	
	-- Assign Alerts and Timers to Triggers
	-- Crucia Triggers
	self.Crucia.Triggers.OStrike = KBM.Trigger:Create(self.Lang.Ability.OStrike[KBM.Lang], "channel", self.Crucia)
	self.Crucia.Triggers.OStrike:AddTimer(self.Crucia.TimersRef.OStrike)
	self.Crucia.Triggers.LBreath = KBM.Trigger:Create(self.Lang.Ability.LBreath[KBM.Lang], "channel", self.Crucia)
	self.Crucia.Triggers.LBreath:AddTimer(self.Crucia.TimersRef.LBreath)
	self.Crucia.Triggers.Fury = KBM.Trigger:Create(self.Lang.Ability.Fury[KBM.Lang], "channel", self.Crucia)
	self.Crucia.Triggers.Fury:AddAlert(self.Crucia.AlertsRef.Fury)
	self.Crucia.Triggers.Rod = KBM.Trigger:Create(self.Lang.Debuff.Rod[KBM.Lang], "playerBuff", self.Crucia)
	self.Crucia.Triggers.Rod:AddAlert(self.Crucia.AlertsRef.Rod, true)
	-- Stormcore Triggers
	self.Storm.Triggers.Pulse = KBM.Trigger:Create(self.Lang.Ability.Pulse[KBM.Lang], "cast", self.Storm)
	self.Storm.Triggers.Pulse:AddAlert(self.Storm.AlertsRef.Pulse)
	self.Storm.Triggers.PulseInt = KBM.Trigger:Create(self.Lang.Ability.Pulse[KBM.Lang], "interrupt", self.Storm)
	self.Storm.Triggers.PulseInt:AddStop(self.Storm.AlertsRef.Pulse)
	self.Storm.Triggers.Spark = KBM.Trigger:Create(self.Lang.Ability.Spark[KBM.Lang], "cast", self.Storm)
	self.Storm.Triggers.Spark:AddAlert(self.Storm.AlertsRef.Spark, true)

	self.Crucia.Triggers.Wrath = KBM.Trigger:Create(self.Lang.Debuff.Wrath[KBM.Lang], "playerBuff", self.Crucia)
	self.Crucia.Triggers.Wrath:AddSpy(self.Crucia.MechRef.Wrath)
	self.Crucia.Triggers.Unstable = KBM.Trigger:Create(self.Lang.Debuff.Unstable[KBM.Lang], "playerBuff", self.Crucia)
	self.Crucia.Triggers.Unstable:AddSpy(self.Crucia.MechRef.Unstable)
	self.Crucia.Triggers.UnstableRem = KBM.Trigger:Create(self.Lang.Debuff.Unstable[KBM.Lang], "playerBuffRemove", self.Crucia)
	self.Crucia.Triggers.UnstableRem:AddStop(self.Crucia.MechRef.Unstable)
	self.Crucia.Triggers.Stablized = KBM.Trigger:Create(self.Lang.Debuff.Stablized[KBM.Lang], "playerBuff", self.Crucia)
	self.Crucia.Triggers.Stablized:AddSpy(self.Crucia.MechRef.Stablized)
	self.Crucia.Triggers.StablizedRem = KBM.Trigger:Create(self.Lang.Debuff.Stablized[KBM.Lang], "playerBuffRemove", self.Crucia)
	self.Crucia.Triggers.StablizedRem:AddStop(self.Crucia.MechRef.Stablized)

	self.Crucia.Triggers.Blessing = KBM.Trigger:Create(self.Lang.Ability.Blessing[KBM.Lang], "cast", self.Crucia)
	self.Crucia.Triggers.Blessing:AddTimer(self.Crucia.TimersRef.TankSwap)
	self.Crucia.Triggers.BlessingWarn = KBM.Trigger:Create(self.Lang.Debuff.BlessingID1, "playerIDBuff", self.Crucia)
	self.Crucia.Triggers.BlessingWarn:AddAlert(self.Crucia.AlertsRef.TankSwap)
	self.Crucia.Triggers.BlessingMC = KBM.Trigger:Create(self.Lang.Debuff.BlessingID2, "playerIDBuff", self.Crucia)
	self.Crucia.Triggers.BlessingMC:AddSpy(self.Crucia.MechRef.Blessing)
	self.Crucia.Triggers.BlessingMCRem = KBM.Trigger:Create(self.Lang.Debuff.BlessingID2, "playerIDBuffRemove", self.Crucia)
	self.Crucia.Triggers.BlessingMCRem:AddStop(self.Crucia.MechRef.Blessing)

	self.Crucia.Triggers.Armor = KBM.Trigger:Create(self.Lang.Ability.Armor[KBM.Lang], "cast", self.Crucia)
	self.Crucia.Triggers.Armor:AddTimer(self.Crucia.TimersRef.TankSwap)
	self.Crucia.Triggers.ArmorWarn = KBM.Trigger:Create(self.Lang.Debuff.ArmorIDCrucia1, "playerIDBuff", self.Crucia)
	self.Crucia.Triggers.ArmorWarn:AddAlert(self.Crucia.AlertsRef.TankSwap)

	self.Crucia.Triggers.PhaseFour = KBM.Trigger:Create(60, "percent", self.Crucia)
	self.Crucia.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	self.Crucia.CastBar = KBM.CastBar:Add(self, self.Crucia)
	self.Storm.CastBar = KBM.CastBar:Add(self, self.Storm)
	self.Elemental.CastBar = KBM.CastBar:Add(self, self.Elemental)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end