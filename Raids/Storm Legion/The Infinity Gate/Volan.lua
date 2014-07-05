-- Volan Boss Mod for King Boss Mods
-- Written by Noshei
-- Copyright 2013
--

KBMSLRDIGVN_Settings = nil
chKBMSLRDIGVN_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IG = KBM.BossMod["RInfinity_Gate"]

local VOL = {
	Enabled = true,
	Directory = IG.Directory,
	File = "Volan.lua",
	Instance = IG.Name,
	InstanceObj = IG,
	HasPhases = true,
	Lang = {},
	ID = "SLIGVolan",
	Object = "VOL",
	Enrage = 11 * 60 + 30,
	FirstSpine = false,
	SpineCount = 0,
	OutbreakCount = 0,
	ExtinctionCount = 0,
	OblivionCount = 0,
}

KBM.RegisterMod(VOL.ID, VOL)

-- Main Unit Dictionary
VOL.Lang.Unit = {}
VOL.Lang.Unit.Volan = KBM.Language:Add("Volan")
VOL.Lang.Unit.Volan:SetFrench("Volan")
VOL.Lang.Unit.Volan:SetGerman("Volan")
VOL.Lang.Unit.VolanLL = KBM.Language:Add("Volan's Left Leg")
VOL.Lang.Unit.VolanLL:SetFrench("Jambe gauche de Volan")
VOL.Lang.Unit.VolanLL:SetGerman("Volans linkes Bein")
VOL.Lang.Unit.VolanRL = KBM.Language:Add("Volan's Right Leg")
VOL.Lang.Unit.VolanRL:SetFrench("Jambe droite de Volan")
VOL.Lang.Unit.VolanRL:SetGerman("Volans rechtes Bein")

-- Ability Dictionary
VOL.Lang.Ability = {}
VOL.Lang.Ability.Energy = KBM.Language:Add("Energy Beam")
VOL.Lang.Ability.Energy:SetFrench("Orbe entropique")
VOL.Lang.Ability.Energy:SetGerman("Energiestrahl")
VOL.Lang.Ability.Spine = KBM.Language:Add("Spine Shatter")
VOL.Lang.Ability.Spine:SetFrench("Destruction vertébrale")
VOL.Lang.Ability.Spine:SetGerman("Rückgratbrecher")
VOL.Lang.Ability.Outbreak = KBM.Language:Add("Outbreak")
VOL.Lang.Ability.Outbreak:SetFrench("Déclenchement")
VOL.Lang.Ability.Outbreak:SetGerman("Ausbruch")
VOL.Lang.Ability.Extinction = KBM.Language:Add("Extinction")
VOL.Lang.Ability.Extinction:SetFrench("Extinction")
VOL.Lang.Ability.Extinction:SetGerman("Untergang")
VOL.Lang.Ability.Oblivion = KBM.Language:Add("Eve of Oblivion")
VOL.Lang.Ability.Oblivion:SetGerman("Vorabend des Vergessens")--TODO
 
-- Description Dictionary
VOL.Lang.Main = {}
 
-- Debuff Dictionary
VOL.Lang.Debuff = {}
VOL.Lang.Debuff.Outbreak = KBM.Language:Add("Outbreak")
VOL.Lang.Debuff.Outbreak:SetFrench("Déclenchement")
VOL.Lang.Debuff.Outbreak:SetGerman("Ausbruch")
 
-- Notify Dictionary
VOL.Lang.Notify = {}
VOL.Lang.Notify.Crystal = KBM.Language:Add("Volan propels a burst of energy towards (%a*).")
VOL.Lang.Notify.Crystal:SetFrench("Volan expédie une explosion d'énergie vers (%a*).")
VOL.Lang.Notify.Crystal:SetGerman("Volan schleudert eine Energieexplosion in Richtung (%a*).")
VOL.Lang.Notify.Spine = KBM.Language:Add("Your cities will fall.")
VOL.Lang.Notify.Spine:SetFrench("Vos cités s'écrouleront.")
VOL.Lang.Notify.Spine:SetGerman("Eure Städte werden fallen.")
VOL.Lang.Notify.Outbreak = KBM.Language:Add("Your lands will burn.")
VOL.Lang.Notify.Outbreak:SetFrench("Vos terres brûleront.")
VOL.Lang.Notify.Outbreak:SetGerman("Eure Lande werden brennen.")
VOL.Lang.Notify.Extinction = KBM.Language:Add("Extinction awaits you.")
VOL.Lang.Notify.Extinction:SetFrench("L'extinction vous attend.")
VOL.Lang.Notify.Extinction:SetGerman("Euer Untergang naht.")
VOL.Lang.Notify.Oblivion = KBM.Language:Add("Witness true power.")
VOL.Lang.Notify.Oblivion:SetGerman("Erlebt wahre Kraft.")--TODO
VOL.Lang.Notify.Exhausted = KBM.Language:Add('Volan shouts, "Resistance only delays the inevitable."')
VOL.Lang.Notify.Exhausted:SetFrench('Volan s\'écrie: "Votre résistance ne fait que ******er l\'inévitable."')
VOL.Lang.Notify.Exhausted:SetGerman('Volan schreit, "Widerstand verzögert nur das Unvermeidliche."')--TODO
VOL.Lang.Notify.PhaseTwo = KBM.Language:Add('Volan bellows, "My soul burns with hatred. I will only be free from my torment when no life remains on this accursed world."')
VOL.Lang.Notify.PhaseTwo:SetFrench('Volan hurle: "La haine consume mon âme. Je ne serai libre de mes tourments que lorsqu\'aucune vie ne restera en ce monde maudit."')
VOL.Lang.Notify.PhaseTwo:SetGerman("")--TODO
 
-- Messages Dictionary
VOL.Lang.Messages = {}
VOL.Lang.Messages.CrystalRun = KBM.Language:Add("Run to Crystal!")
VOL.Lang.Messages.CrystalRun:SetFrench("Courez sur le Cristal!")
VOL.Lang.Messages.CrystalRun:SetGerman("Zum Kristall laufen!")
VOL.Lang.Messages.Extinction = KBM.Language:Add("Spread Out!")
VOL.Lang.Messages.Extinction:SetFrench("Dispersez vous!")
VOL.Lang.Messages.Extinction:SetGerman("Verteilen!")
VOL.Lang.Messages.OblivionDamage = KBM.Language:Add("Eve of Oblivion Hits Raid!")
VOL.Lang.Messages.OblivionDamage:SetGerman("Vorabend des Vergessens trifft den Schlachtzug!")--TODO
VOL.Lang.Messages.ExhaustedStart = KBM.Language:Add("Start DPS Burn!")
VOL.Lang.Messages.ExhaustedStart:SetFrench("Burst DPS!")
VOL.Lang.Messages.ExhaustedStart:SetGerman("Burst DPS Start!")
VOL.Lang.Messages.ExhaustedEnd = KBM.Language:Add("End of Exhausted!")
VOL.Lang.Messages.ExhaustedEnd:SetGerman("Ende der Erschöpfung!")--TODO 
VOL.Descript = VOL.Lang.Unit.Volan[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
VOL.Volan = {
	Mod = VOL,
	Level = "??",
	Active = false,
	Name = VOL.Lang.Unit.Volan[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U676084BA1D5160F3",
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
			Energy = KBM.Defaults.TimerObj.Create("blue"),
			Extinction1 = KBM.Defaults.TimerObj.Create("red"),
			Extinction2 = KBM.Defaults.TimerObj.Create("red"),
			Outbreak1 = KBM.Defaults.TimerObj.Create("dark_green"),
			Outbreak2 = KBM.Defaults.TimerObj.Create("dark_green"),
			Outbreak3 = KBM.Defaults.TimerObj.Create("dark_green"),
			Outbreak4 = KBM.Defaults.TimerObj.Create("dark_green"),
			Outbreak5 = KBM.Defaults.TimerObj.Create("dark_green"),
			Spine1 = KBM.Defaults.TimerObj.Create("yellow"),
			Spine2 = KBM.Defaults.TimerObj.Create("yellow"),
			Spine3 = KBM.Defaults.TimerObj.Create("yellow"),
			Oblivion1 = KBM.Defaults.TimerObj.Create("cyan"),
			Oblivion2 = KBM.Defaults.TimerObj.Create("cyan"),
			OblivionDamage = KBM.Defaults.TimerObj.Create("red"),
			ExhaustedStart = KBM.Defaults.TimerObj.Create("purple"),
			ExhaustedEnd = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Outbreak = KBM.Defaults.AlertObj.Create("dark_green"),
			Crystal = KBM.Defaults.AlertObj.Create("blue"),
			Extinction = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Outbreak = KBM.Defaults.MechObj.Create("dark_green"),
			Crystal = KBM.Defaults.MechObj.Create("blue"),
		},
	}
}

VOL.VolanLL = {
	Mod = VOL,
	Level = "??",
	Active = false,
	Name = VOL.Lang.Unit.VolanLL[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U47623A846423F2F7",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	-- MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		-- TimersRef = {
			-- Enabled = true,
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Disruptor = KBM.Defaults.AlertObj.Create("yellow"),
			-- Distortion = KBM.Defaults.AlertObj.Create("red"),
		-- },
		-- MechRef = {
			-- Enabled = true,
			-- Decay = KBM.Defaults.MechObj.Create("cyan"),
			-- Distortion = KBM.Defaults.MechObj.Create("red"),
		-- },
	}
}

VOL.VolanRL = {
	Mod = VOL,
	Level = "??",
	Active = false,
	Name = VOL.Lang.Unit.VolanRL[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U17B096BE7903E180",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	-- MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		-- TimersRef = {
			-- Enabled = true,
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Disruptor = KBM.Defaults.AlertObj.Create("yellow"),
			-- Distortion = KBM.Defaults.AlertObj.Create("red"),
		-- },
		-- MechRef = {
			-- Enabled = true,
			-- Decay = KBM.Defaults.MechObj.Create("cyan"),
			-- Distortion = KBM.Defaults.MechObj.Create("red"),
		-- },
	}
}

function VOL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Volan.Name] = self.Volan,
		[self.VolanLL.Name] = self.VolanLL,
		[self.VolanRL.Name] = self.VolanRL,
	}
end

function VOL:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		Volan = {
			CastBar = self.Volan.Settings.CastBar,
			AlertsRef = self.Volan.Settings.AlertsRef,
			TimersRef = self.Volan.Settings.TimersRef,
			MechRef = self.Volan.Settings.MechRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMSLRDIGVN_Settings = self.Settings
	chKBMSLRDIGVN_Settings = self.Settings
	
end

function VOL:SwapSettings(bool)

	if bool then
		KBMSLRDIGVN_Settings = self.Settings
		self.Settings = chKBMSLRDIGVN_Settings
	else
		chKBMSLRDIGVN_Settings = self.Settings
		self.Settings = KBMSLRDIGVN_Settings
	end

end

function VOL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDIGVN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDIGVN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDIGVN_Settings = self.Settings
	else
		KBMSLRDIGVN_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function VOL:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDIGVN_Settings = self.Settings
	else
		KBMSLRDIGVN_Settings = self.Settings
	end	
end

function VOL.PhaseTwo()
	if VOL.Phase == 1 then
		VOL.Phase = 2
		VOL.PhaseObj.Objectives:Remove()
		VOL.PhaseObj.Objectives:AddPercent(VOL.Volan, 0, 100)
		VOL.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		VOL.FirstSpine = false
		VOL.SpineCount = 0
		VOL.OutbreakCount = 0
		VOL.ExtinctionCount = 0
		VOL.OblivionCount = 0
	end
end

function VOL:Castbar(units)
end

function VOL:RemoveUnits(UnitID)
	if self.Volan.UnitID == UnitID then
		self.Volan.Available = false
		return true
	end
	return false
end

function VOL:Death(UnitID)
	if self.Volan.UnitID == UnitID then
		self.Volan.Dead = true
		return true
	end
	return false
end

function VOL:UnitHPCheck(uDetails, unitID)	
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
				--self.PhaseObj.Objectives:AddPercent(self.Volan, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.VolanLL, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.VolanRL, 0, 100)
				self.Phase = 1
				self.FirstSpine = false
				self.SpineCount = 0
				self.OutbreakCount = 0
				self.ExtinctionCount = 0
				self.OblivionCount = 0
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

function VOL:Reset()
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

function VOL.ExtinctionTrigger()
	if VOL.Phase == 1 then
		if VOL.OutbreakCount == 1 then
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Outbreak2)
		else
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Outbreak3)
		end
		VOL.OutbreakCount = VOL.OutbreakCount + 1
	elseif VOL.Phase == 2 then
		if VOL.OutbreakCount == 0 then
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Outbreak4)
			VOL.OutbreakCount = VOL.OutbreakCount + 1
		else
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Oblivion2)
		end
	end
end

function VOL.OutbreakTrigger()
	if VOL.Phase == 1 then
		if VOL.SpineCount == 0 then
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Spine1)
		elseif VOL.SpineCount == 1 then
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Spine2)
		else
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Spine3)
		end
		VOL.SpineCount = VOL.SpineCount + 1
	elseif VOL.Phase == 2 then
		if VOL.OblivionCount == 0 then
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Oblivion1)
			VOL.OblivionCount = VOL.OblivionCount + 1
		else
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Extinction2)
		end
	end
end

function VOL.SpineTrigger()
	if VOL.Phase == 1 then
		if VOL.FirstSpine then
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Extinction1)
		else
			KBM.MechTimer:AddStart(VOL.Volan.TimersRef.Outbreak1)
			VOL.OutbreakCount = VOL.OutbreakCount + 1
			VOL.FirstSpine = true
		end
	end
end

function VOL:Timer()	
end

function VOL:DefineMenu()
	self.Menu = IG.Menu:CreateEncounter(self.Volan, self.Enabled)
end

function VOL:Start()
	-- Create Timers
	self.Volan.TimersRef.Energy = KBM.MechTimer:Add(self.Lang.Ability.Energy[KBM.Lang], 25, false)
	self.Volan.TimersRef.Extinction1 = KBM.MechTimer:Add(self.Lang.Ability.Extinction[KBM.Lang], 28, false)
	self.Volan.TimersRef.Extinction2 = KBM.MechTimer:Add(self.Lang.Ability.Extinction[KBM.Lang], 44, false)
	self.Volan.TimersRef.Outbreak1 = KBM.MechTimer:Add(self.Lang.Ability.Outbreak[KBM.Lang], 25, false)
	self.Volan.TimersRef.Outbreak2 = KBM.MechTimer:Add(self.Lang.Ability.Outbreak[KBM.Lang], 28, false)
	self.Volan.TimersRef.Outbreak3 = KBM.MechTimer:Add(self.Lang.Ability.Outbreak[KBM.Lang], 34, false)
	self.Volan.TimersRef.Outbreak4 = KBM.MechTimer:Add(self.Lang.Ability.Outbreak[KBM.Lang], 24, false)
	self.Volan.TimersRef.Outbreak5 = KBM.MechTimer:Add(self.Lang.Ability.Outbreak[KBM.Lang], 23, false)
	self.Volan.TimersRef.Spine1 = KBM.MechTimer:Add(self.Lang.Ability.Spine[KBM.Lang], 36, false)
	self.Volan.TimersRef.Spine2 = KBM.MechTimer:Add(self.Lang.Ability.Spine[KBM.Lang], 10, false)
	self.Volan.TimersRef.Spine3 = KBM.MechTimer:Add(self.Lang.Ability.Spine[KBM.Lang], 12, false)
	self.Volan.TimersRef.Oblivion1 = KBM.MechTimer:Add(self.Lang.Ability.Oblivion[KBM.Lang], 31, false)
	self.Volan.TimersRef.Oblivion2 = KBM.MechTimer:Add(self.Lang.Ability.Oblivion[KBM.Lang], 13, false)
	self.Volan.TimersRef.OblivionDamage = KBM.MechTimer:Add(self.Lang.Messages.OblivionDamage[KBM.Lang], 14, false)
	self.Volan.TimersRef.ExhaustedStart = KBM.MechTimer:Add(self.Lang.Messages.ExhaustedStart[KBM.Lang], 19, false)
	self.Volan.TimersRef.ExhaustedEnd = KBM.MechTimer:Add(self.Lang.Messages.ExhaustedEnd[KBM.Lang], 20, false)
	KBM.Defaults.TimerObj.Assign(self.Volan)

	-- Link All Timers
	self.Volan.TimersRef.Extinction2:SetLink(self.Volan.TimersRef.Extinction1)
	self.Volan.TimersRef.Outbreak5:SetLink(self.Volan.TimersRef.Outbreak1)
	self.Volan.TimersRef.Outbreak4:SetLink(self.Volan.TimersRef.Outbreak1)
	self.Volan.TimersRef.Outbreak3:SetLink(self.Volan.TimersRef.Outbreak1)
	self.Volan.TimersRef.Outbreak2:SetLink(self.Volan.TimersRef.Outbreak1)
	self.Volan.TimersRef.Spine3:SetLink(self.Volan.TimersRef.Spine1)
	self.Volan.TimersRef.Spine2:SetLink(self.Volan.TimersRef.Spine1)
	self.Volan.TimersRef.Oblivion2:SetLink(self.Volan.TimersRef.Oblivion1)
	
	-- Create Alerts
	self.Volan.AlertsRef.Outbreak = KBM.Alert:Create(self.Lang.Debuff.Outbreak[KBM.Lang], nil, true, true, "dark_green")
	self.Volan.AlertsRef.Crystal = KBM.Alert:Create(self.Lang.Messages.CrystalRun[KBM.Lang], 6, false, true, "blue")
	self.Volan.AlertsRef.Extinction = KBM.Alert:Create(self.Lang.Messages.Extinction[KBM.Lang], 14, false, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Volan)

	-- Create Mechanic Spies
	self.Volan.MechRef.Outbreak = KBM.MechSpy:Add(self.Lang.Debuff.Outbreak[KBM.Lang], nil, "playerDebuff", self.Volan)
	self.Volan.MechRef.Crystal = KBM.MechSpy:Add(self.Lang.Messages.CrystalRun[KBM.Lang], 6, "mechanic", self.Volan)
	KBM.Defaults.MechObj.Assign(self.Volan)

	-- Assign Alerts and Timers for Triggers
	self.Volan.Triggers.Crystal = KBM.Trigger:Create(self.Lang.Notify.Crystal[KBM.Lang], "notify", self.Volan)
	self.Volan.Triggers.Crystal:AddTimer(self.Volan.TimersRef.Energy)
	self.Volan.Triggers.Crystal:AddSpy(self.Volan.MechRef.Crystal)
	self.Volan.Triggers.Crystal:AddAlert(self.Volan.AlertsRef.Crystal, true)
	
	self.Volan.Triggers.OutbreakBuff = KBM.Trigger:Create(self.Lang.Debuff.Outbreak[KBM.Lang], "playerDebuff", self.Volan)
	self.Volan.Triggers.OutbreakBuff:AddSpy(self.Volan.MechRef.Outbreak)
	self.Volan.Triggers.OutbreakRem = KBM.Trigger:Create(self.Lang.Debuff.Outbreak[KBM.Lang], "playerBuffRemove", self.Volan)
	self.Volan.Triggers.OutbreakRem:AddStop(self.Volan.MechRef.Outbreak)
	
	self.Volan.Triggers.Extinction = KBM.Trigger:Create(self.Lang.Notify.Extinction[KBM.Lang], "notify", self.Volan)
	self.Volan.Triggers.Extinction:AddAlert(self.Volan.AlertsRef.Extinction, false)
	self.Volan.Triggers.Extinction:AddPhase(self.ExtinctionTrigger)
	
	self.Volan.Triggers.Outbreak = KBM.Trigger:Create(self.Lang.Notify.Outbreak[KBM.Lang], "notify", self.Volan)
	self.Volan.Triggers.Outbreak:AddPhase(self.OutbreakTrigger)
	
	self.Volan.Triggers.Spine = KBM.Trigger:Create(self.Lang.Notify.Spine[KBM.Lang], "notify", self.Volan)
	self.Volan.Triggers.Spine:AddPhase(self.SpineTrigger)
	
	self.Volan.Triggers.Oblivion = KBM.Trigger:Create(self.Lang.Notify.Oblivion[KBM.Lang], "notify", self.Volan)
	self.Volan.Triggers.Oblivion:AddTimer(self.Volan.TimersRef.OblivionDamage)
	self.Volan.Triggers.Oblivion:AddTimer(self.Volan.TimersRef.ExhaustedStart)
	
	self.Volan.Triggers.Exhausted = KBM.Trigger:Create(self.Lang.Notify.Exhausted[KBM.Lang], "notify", self.Volan)
	self.Volan.Triggers.Exhausted:AddTimer(self.Volan.TimersRef.ExhaustedEnd)
	self.Volan.Triggers.Exhausted:AddTimer(self.Volan.TimersRef.Outbreak5)
	
	self.Volan.Triggers.PhaseTwo = KBM.Trigger:Create(self.Lang.Notify.PhaseTwo[KBM.Lang], "notify", self.Volan)
	self.Volan.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
		
	self.Volan.CastBar = KBM.Castbar:Add(self, self.Volan)
	self.VolanLL.CastBar = KBM.Castbar:Add(self, self.VolanLL)
	self.VolanRL.CastBar = KBM.Castbar:Add(self, self.VolanRL)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end