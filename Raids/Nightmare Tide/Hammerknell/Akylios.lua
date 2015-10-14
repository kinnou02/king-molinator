-- Akylios Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMNTAK_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local HK = KBM.BossMod["Hammerknell"]

local AK = {
	Enabled = true,
	Directory = HK.Directory,
	File = "Akylios.lua",
	Instance = HK.Name,
	InstanceObj = HK,
	HasPhases = true,
	Phase = 1,
	Counts = {
		Stingers = 0,
		Lashers = 0,
	},
	Timers = {},
	Lang = {},
	ID = "Akylios",
	Enrage = 60 * 20,
	Object = "AK",
}

AK.Jornaru = {
	Mod = AK,
	Level = "??",
	Active = false,
	Name = "Jornaru",
	CastBar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Dead = false,
	Available = false,
	UTID = "U030F252702F89F4C",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			WaveOne = KBM.Defaults.TimerObj.Create("blue"),
			WaveFour = KBM.Defaults.TimerObj.Create("blue"),
			WaveFourFirst = KBM.Defaults.TimerObj.Create("blue"),
			Orb = KBM.Defaults.TimerObj.Create("orange"),
			OrbFirst = KBM.Defaults.TimerObj.Create("orange"),
			OrbFirstSay = KBM.Defaults.TimerObj.Create("orange"),
			Summon = KBM.Defaults.TimerObj.Create("dark_green"),
			SummonTwo = KBM.Defaults.TimerObj.Create("dark_green"),
			SummonTwoFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			SummonTwoFirstSay = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			WaveWarn = KBM.Defaults.AlertObj.Create("blue"),
			WaveWarnLong = KBM.Defaults.AlertObj.Create("cyan"),
			Orb = KBM.Defaults.AlertObj.Create("orange"),
		},
		MechRef = {
			Enabled = true,
			Orb = KBM.Defaults.MechObj.Create("orange"),
		},
	},
}

AK.Akylios = {
	Mod = AK,
	Level = "??",
	Active = false,
	Name = "Akylios",
	CastBar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Dead = false,
	Available = false,
	PhaseObj = nil,
	UTID = "U123C414D761DB493",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Breath = KBM.Defaults.TimerObj.Create("red"),
			EmergeFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			BreathFirst = KBM.Defaults.TimerObj.Create("red"),
			Emerge = KBM.Defaults.TimerObj.Create("dark_green"),
			Submerge = KBM.Defaults.TimerObj.Create("dark_green"),
			Lasher = KBM.Defaults.TimerObj.Create("cyan")
		},
		AlertsRef = {
			Enabled = true,
			Breath = KBM.Defaults.AlertObj.Create("red"),
			BreathWarn = KBM.Defaults.AlertObj.Create("red"),
			Decay = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Decay = KBM.Defaults.MechObj.Create("purple"),
		},
	},
}

AK.Stinger = {
	Mod = AK,
	Level = "??",
	Name = "Stinger of Akylios",
	UnitList = {},
	Ignore = true,
	Type = "multi",
	UTID = "U3C90F47E69737F30",
}

AK.Lasher = {
	Mod = AK,
	Level = "??",
	Name = "Lasher of Akylios",
	UnitList = {},
	Ignore = true,
	Type = "multi",
	UTID = "U185ED5BF42C66F17",
}

AK.Apostle = {
	Mod = AK,
	Level = "??",
	Name = "Apostle of Jornaru",
	UnitList = {},
	Menu = {},
	UTID = "U4C42FB2022EEE7C7",
	AlertsRef = {},
	Ignore = true,
	Type = "multi",
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Storm = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

KBM.RegisterMod(AK.ID, AK)

-- Main Unit Dictionary
AK.Lang.Unit = {}
AK.Lang.Unit.Akylios = KBM.Language:Add(AK.Akylios.Name)
AK.Lang.Unit.Akylios:SetGerman(AK.Akylios.Name)
AK.Lang.Unit.Akylios:SetFrench(AK.Akylios.Name)
AK.Lang.Unit.Akylios:SetRussian("Акилиос")
AK.Akylios.Name = AK.Lang.Unit.Akylios[KBM.Lang]
AK.Lang.Unit.Jornaru = KBM.Language:Add(AK.Jornaru.Name)
AK.Lang.Unit.Jornaru:SetGerman(AK.Jornaru.Name)
AK.Lang.Unit.Jornaru:SetFrench(AK.Jornaru.Name)
AK.Lang.Unit.Jornaru:SetRussian("Йорнару")
AK.Jornaru.Name = AK.Lang.Unit.Jornaru[KBM.Lang]
-- Additional Unit List
AK.Lang.Unit.Stinger = KBM.Language:Add(AK.Stinger.Name)
AK.Lang.Unit.Stinger:SetGerman("Stachel des Akylios")
AK.Lang.Unit.Stinger:SetRussian("Жало Акилиоса")
AK.Lang.Unit.Stinger:SetFrench("Piqueur d'Akylios")
AK.Stinger.Name = AK.Lang.Unit.Stinger[KBM.Lang]
AK.Lang.Unit.Lasher = KBM.Language:Add(AK.Lasher.Name)
AK.Lang.Unit.Lasher:SetGerman("Peitscher des Akylios")
AK.Lang.Unit.Lasher:SetRussian("Бичеватель Акилиоса")
AK.Lang.Unit.Lasher:SetFrench("Fouetteur d'Akylios")
AK.Lasher.Name = AK.Lang.Unit.Lasher[KBM.Lang]
AK.Lang.Unit.Apostle = KBM.Language:Add(AK.Apostle.Name)
AK.Apostle.Name = AK.Lang.Unit.Apostle[KBM.Lang]
AK.Lang.Unit.Apostle:SetGerman("Apostel von Jornaru")
AK.Lang.Unit.Apostle:SetRussian("Апостол Йорнару")
AK.Lang.Unit.Apostle:SetFrench("Apôtre de Jornaru")
AK.Lang.Unit.ApostleShort = KBM.Language:Add("Apostle")
AK.Lang.Unit.ApostleShort:SetGerman("Apostel")
AK.Lang.Unit.ApostleShort:SetRussian("Апостол")
AK.Lang.Unit.ApostleShort:SetFrench("Apôtre")
AK.Apostle.NameShort = AK.Lang.Unit.ApostleShort[KBM.Lang]

-- Ability Dictionary.
AK.Lang.Ability = {}
AK.Lang.Ability.Decay = KBM.Language:Add("Mind Decay")
AK.Lang.Ability.Decay:SetGerman("Geistiger Verfall")
AK.Lang.Ability.Decay:SetRussian("Деградация сознания")
AK.Lang.Ability.Decay:SetFrench("Dépérissement spirituel")
AK.Lang.Ability.Breath = KBM.Language:Add("Breath of Madness")
AK.Lang.Ability.Breath:SetGerman("Hauch des Wahnsinns")
AK.Lang.Ability.Breath:SetRussian("Дыхание безумия")
AK.Lang.Ability.Breath:SetFrench("Souffle de folie")
AK.Lang.Ability.Grave = KBM.Language:Add("Watery Grave")
AK.Lang.Ability.Grave:SetGerman("Wassergrab")
AK.Lang.Ability.Grave:SetFrench("Tombe aquatique")
AK.Lang.Ability.Grave:SetRussian("Водная Могила")
AK.Lang.Ability.Storm = KBM.Language:Add("Tidal Storm")
AK.Lang.Ability.Storm:SetGerman("Flutsturm")
AK.Lang.Ability.Storm:SetRussian("Приливная буря")
AK.Lang.Ability.Storm:SetFrench("Tempête de la marée")

-- Debuff Dictionary.
AK.Lang.Debuff = {}

-- Mechanic Dictionary.
AK.Lang.Mechanic = {}
AK.Lang.Mechanic.Wave = KBM.Language:Add("Tidal Wave")
AK.Lang.Mechanic.Wave:SetGerman("Flutwelle")
AK.Lang.Mechanic.Wave:SetRussian("Приливная волна")
AK.Lang.Mechanic.Wave:SetFrench("Raz de marée")
AK.Lang.Mechanic.Orb = KBM.Language:Add("Suffocating Orb")
AK.Lang.Mechanic.Orb:SetGerman("Erstickungskugel")
AK.Lang.Mechanic.Orb:SetRussian("Сфера удушья")
AK.Lang.Mechanic.Orb:SetFrench("Orbe de suffocation")
AK.Lang.Mechanic.Summon = KBM.Language:Add("Summon the Abyss")
AK.Lang.Mechanic.Summon:SetGerman("Beschwört den Abgrund!")
AK.Lang.Mechanic.Summon:SetRussian("Воззвание к глубинам")
AK.Lang.Mechanic.Summon:SetFrench("Invoque les Abysses")
AK.Lang.Mechanic.Emerge = KBM.Language:Add("Akylios emerges")
AK.Lang.Mechanic.Emerge:SetGerman("Akylios taucht auf")
AK.Lang.Mechanic.Emerge:SetRussian("Акилиос всплывает")
AK.Lang.Mechanic.Emerge:SetFrench("Akylios émerge")
AK.Lang.Mechanic.Submerge = KBM.Language:Add("Akylios submerges")
AK.Lang.Mechanic.Submerge:SetGerman("Akylios taucht unter")
AK.Lang.Mechanic.Submerge:SetRussian("Акилиос погружается")
AK.Lang.Mechanic.Submerge:SetFrench("Akylios immerge")
AK.Lang.Mechanic.Left = KBM.Language:Add("Akylios rears to the left!")
AK.Lang.Mechanic.Left:SetGerman("Akylios bäumt sich zu Eurer Linken auf!")
AK.Lang.Mechanic.Left:SetFrench("Akylios se penche vers la gauche !")
AK.Lang.Mechanic.Left:SetRussian("Акилиос отклоняется влево!")
AK.Lang.Mechanic.Center = KBM.Language:Add("Akylios rears backwards!")
AK.Lang.Mechanic.Center:SetGerman("Akylios bäumt sich hinter Euch auf!")
AK.Lang.Mechanic.Center:SetFrench("Akylios se cabre !")
AK.Lang.Mechanic.Center:SetRussian("Акилиос отклоняется назад!")
AK.Lang.Mechanic.Right = KBM.Language:Add("Akylios rears to the right!")
AK.Lang.Mechanic.Right:SetGerman("Akylios bäumt sich zu Eurer Rechten auf!")
AK.Lang.Mechanic.Right:SetFrench("Akylios se penche vers la droite !")
AK.Lang.Mechanic.Right:SetRussian("Акилиос отклоняется вправо!")
-- Notify Dictionary
AK.Lang.Notify = {}
AK.Lang.Notify.Orb = KBM.Language:Add("Jornaru launches a suffocating orb at (%a*)")
AK.Lang.Notify.Orb:SetGerman("Jornaru wirft eine Erstickungskugel auf (%a*)")
AK.Lang.Notify.Orb:SetRussian("Йорнару запускает удушающую сферу, его цель %- (%a*).")
AK.Lang.Notify.Orb:SetFrench("Jornaru lance un orbe de suffocation à (%a*).")

-- Say Dictionary
AK.Lang.Say = {}
AK.Lang.Say.PhaseTwo = KBM.Language:Add("Master, your plan is fulfilled. After a millennia of manipulation, the wards of Hammerknell are shattered. I release you, Akylios! Come forth and claim this world.")
AK.Lang.Say.PhaseTwo:SetGerman("Meister, Euer Plan ist vollendet. Nach Millennium der Manipulation fallen die Schutzzauber Hammerhalls. Ich befreie Euch, Akylios! Kommt, nehmt Euch diese Welt.")
AK.Lang.Say.PhaseTwo:SetRussian("Господин, ваш замысел исполнен. После тысячилетий труда защита Молотозвона пала. Я, Акилиос, освобождаю вас! Явитесь и захватите этот мир.")
AK.Lang.Say.PhaseTwo:SetFrench("Le plan a porté ses fruits, maître. Après un millénaire de manipulations, les protections de Glasmarteau sont enfin brisées. Je vous libère, Akylios ! Venez conquérir ce monde !")

-- Phase Message Dictionary
AK.Lang.Phase = {}
AK.Lang.Phase.Two = KBM.Language:Add("Phase 2 starting!")
AK.Lang.Phase.Two:SetGerman("Phase 2 beginnt!")
AK.Lang.Phase.Two:SetRussian("Началась вторая фаза!")
AK.Lang.Phase.Two:SetFrench("Phase 2 débutée")
AK.Lang.Phase.Three = KBM.Language:Add("Phase 3 starting!")
AK.Lang.Phase.Three:SetGerman("Phase 3 beginnt!")
AK.Lang.Phase.Three:SetRussian("Началась третья фаза!")
AK.Lang.Phase.Three:SetFrench("Phase 3 débutée")
AK.Lang.Phase.Four = KBM.Language:Add("Phase 4 starting!")
AK.Lang.Phase.Four:SetGerman("Phase 4 beginnt!")
AK.Lang.Phase.Four:SetRussian("Началась четвертая фаза!")
AK.Lang.Phase.Four:SetFrench("Phase 4 débutée")
AK.Lang.Phase.Final = KBM.Language:Add("Final phase starting, good luck!")
AK.Lang.Phase.Final:SetGerman("Letzte Phase beginnt, viel Erfolg!")
AK.Lang.Phase.Final:SetRussian("Последняя фаза, удачи!")
AK.Lang.Phase.Final:SetFrench("Phase finale débutée, bonne chance!")

-- Options Dictionary.
AK.Lang.Options = {}
AK.Lang.Options.WaveOne = KBM.Language:Add(AK.Lang.Mechanic.Wave[KBM.Lang].." (Phase 1)")
AK.Lang.Options.WaveOne:SetGerman("Flutwelle (Phase 1)")
AK.Lang.Options.WaveOne:SetFrench("Raz de marée (Phase 1)")
AK.Lang.Options.WaveOne:SetRussian("Приливная волна (фаза 1)")
AK.Lang.Options.WaveFour = KBM.Language:Add(AK.Lang.Mechanic.Wave[KBM.Lang].." (Phase 4)")
AK.Lang.Options.WaveFour:SetGerman("Flutwelle (Phase 4)")
AK.Lang.Options.WaveFour:SetFrench("Raz de marée (Phase 4)")
AK.Lang.Options.WaveFour:SetRussian("Приливная волна (фаза 4)")
AK.Lang.Options.WaveWarn = KBM.Language:Add("Warning for Waves at 5 seconds.")
AK.Lang.Options.WaveWarn:SetGerman("Warnung für Flutwellen 5 Sekunden vorher.")
AK.Lang.Options.WaveWarn:SetRussian("Предупреждение о волнах за 5 секунд.")
AK.Lang.Options.WaveWarn:SetFrench("Attention vague dans 5 secondes")
AK.Lang.Options.WaveWarnLong = KBM.Language:Add("Warning for Waves at 10 seconds.")
AK.Lang.Options.WaveWarnLong:SetGerman("Warnung für Flutwellen 10 Sekunden vorher.")
AK.Lang.Options.WaveWarnLong:SetRussian("Предупреждение о волнах за 10 секунд.")
AK.Lang.Options.WaveWarnLong:SetFrench("Attention vague dans 10 secondes.")
AK.Lang.Options.Summon = KBM.Language:Add(AK.Lang.Mechanic.Summon[KBM.Lang].." (Phase 1)")
AK.Lang.Options.Summon:SetGerman("Beschwört den Abgrund! (Phase 1)")
AK.Lang.Options.Summon:SetFrench("Invoque les Abysses (Phase 1)")
AK.Lang.Options.Summon:SetRussian("Призыв аддов (фаза 1)")
AK.Lang.Options.SummonTwo = KBM.Language:Add(AK.Lang.Mechanic.Summon[KBM.Lang].." (Phase 2)")
AK.Lang.Options.SummonTwo:SetGerman("Beschwört den Abgrund! (Phase 2)")
AK.Lang.Options.SummonTwo:SetFrench("Invoque les Abysses (Phase 2)")
AK.Lang.Options.SummonTwo:SetRussian("Призыв аддов (фаза 2)")
AK.Lang.Options.Orb = KBM.Language:Add(AK.Lang.Mechanic.Orb[KBM.Lang].." (P2 First)")
AK.Lang.Options.Orb:SetGerman(AK.Lang.Mechanic.Orb[KBM.Lang].." (Erste in P2)")
AK.Lang.Options.Orb:SetRussian(AK.Lang.Mechanic.Orb[KBM.Lang].." (первая на 2ой фазе)")
AK.Lang.Options.Orb:SetFrench(AK.Lang.Mechanic.Orb[KBM.Lang].." (P2 Premier)")
AK.Lang.Options.Breath = KBM.Language:Add(AK.Lang.Ability.Breath[KBM.Lang].." duration.")
AK.Lang.Options.Breath:SetGerman(AK.Lang.Ability.Breath[KBM.Lang].." Dauer.")
AK.Lang.Options.Breath:SetRussian(AK.Lang.Ability.Breath[KBM.Lang].." (продолжит.)")
AK.Lang.Options.Breath:SetFrench(AK.Lang.Ability.Breath[KBM.Lang].." durée.")
AK.Lang.Options.Emerge = KBM.Language:Add("Emerge/Submerge Timers")
AK.Lang.Options.Emerge:SetGerman("Auftauchen/Untertauchen Timer")
AK.Lang.Options.Emerge:SetFrench("Timers Émerge/Immerge")
AK.Lang.Options.Emerge:SetRussian("Таймеры всплытия/погружения")
AK.Lang.Options.BreathFirst = KBM.Language:Add("First Breath in Phase 3")
AK.Lang.Options.BreathFirst:SetGerman("Erster Hauch in Phase 3")
AK.Lang.Options.BreathFirst:SetFrench("Premier souffle de la Phase 3")
AK.Lang.Options.BreathFirst:SetRussian("Первое дыхание на фазе 3")
AK.Lang.Options.Lasher = KBM.Language:Add("Second Lasher rises")
AK.Lang.Options.Lasher:SetGerman("Zweiter Peitscher erscheint")
AK.Lang.Options.Lasher:SetFrench("Second Fouetteur apparaît")
AK.Lang.Options.Lasher:SetRussian("Появление второго Бичевателя")
AK.Lang.Options.Percent = KBM.Language:Add("Use percentage based trigger for Phase 2")
AK.Lang.Options.Percent:SetGerman("Prozent basierte Trigger in Phase 2 verwenden")
AK.Lang.Options.Percent:SetFrench("Utilisez déclenchement basée sur les % pour la Phase 2")
AK.Lang.Options.Percent:SetRussian("Использовать триггер по процентам для фазы 2")
AK.Descript = AK.Akylios.Name.." & "..AK.Jornaru.Name

function AK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Jornaru.Name] = self.Jornaru,
		[self.Akylios.Name] = self.Akylios,
		[self.Stinger.Name] = self.Stinger,
		[self.Lasher.Name] = self.Lasher,
		[self.Apostle.Name] = self.Apostle,
	}
end

function AK:InitVars()
	self.Settings = {
		Enabled = true,
		--PhaseAlt = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		CastBar = {
			Override = true,
			Multi = true,
		},
		Akylios = {
			CastBar = AK.Akylios.Settings.CastBar,
			TimersRef = AK.Akylios.Settings.TimersRef,
			AlertsRef = AK.Akylios.Settings.AlertsRef,
			MechRef = AK.Akylios.Settings.MechRef,
		},
		Jornaru = {
			CastBar = AK.Jornaru.Settings.CastBar,
			TimersRef = AK.Jornaru.Settings.TimersRef,
			AlertsRef = AK.Jornaru.Settings.AlertsRef,
			MechRef = AK.Jornaru.Settings.MechRef,
		},
		Apostle = {
			AlertsRef = AK.Apostle.Settings.AlertsRef,
		},
	}
	KBMNTAK_Settings = self.Settings
	chKBMNTAK_Settings = self.Settings	
end

function AK:SwapSettings(bool)
	if bool then
		KBMNTAK_Settings = self.Settings
		self.Settings = chKBMNTAK_Settings
	else
		chKBMNTAK_Settings = self.Settings
		self.Settings = KBMNTAK_Settings
	end
end

function AK:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTAK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTAK_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMNTAK_Settings = self.Settings
	else
		KBMNTAK_Settings = self.Settings
	end

	self.Akylios.Settings.CastBar.Override = true
	self.Jornaru.Settings.CastBar.Override = true
	self.Akylios.Settings.CastBar.Multi = true
	self.Jornaru.Settings.CastBar.Multi = true
end

function AK:SaveVars()	
	if KBM.Options.Character then
		chKBMNTAK_Settings = self.Settings
	else
		KBMNTAK_Settings = self.Settings
	end	
end

function AK:Castbar(units)
end

function AK.PhaseTwo(Type)
	if KBM.Debug then
		print("Phase Two trigger Type: "..tostring(Type))
		print("Phase current set as: "..tostring(AK.Phase))
	end
	if AK.Phase == 1 then
		AK.PhaseObj.Objectives:Remove()
		AK.Phase = 2
		AK.PhaseObj:SetPhase(2)
		AK.PhaseObj.Objectives:AddDeath(AK.Stinger.Name, 8)
		AK.PhaseObj.Objectives:AddDeath(AK.Lasher.Name, 4)
		KBM.MechTimer:AddRemove(AK.Jornaru.TimersRef.WaveOne, true)
		KBM.MechTimer:AddRemove(AK.Jornaru.TimersRef.Summon, true)
		KBM.MechTimer:AddStart(AK.Jornaru.TimersRef.SummonTwoFirst)
		KBM.MechTimer:AddStart(AK.Jornaru.TimersRef.OrbFirst)
		AK.Jornaru.CastBar:Remove()
		print(AK.Lang.Phase.Two[KBM.Lang])
	end
end

function AK.PhaseTwoSay()
	if AK.Phase == 1 then
		AK.PhaseObj.Objectives:Remove()
		AK.Phase = 2
		AK.PhaseObj:SetPhase(2)
		AK.PhaseObj.Objectives:AddDeath(AK.Stinger.Name, 8)
		AK.PhaseObj.Objectives:AddDeath(AK.Lasher.Name, 4)
		KBM.MechTimer:AddRemove(AK.Jornaru.TimersRef.WaveOne, true)
		KBM.MechTimer:AddRemove(AK.Jornaru.TimersRef.Summon, true)
		KBM.MechTimer:AddStart(AK.Jornaru.TimersRef.SummonTwoFirstSay)
		KBM.MechTimer:AddStart(AK.Jornaru.TimersRef.OrbFirstSay)
		AK.Jornaru.CastBar:Remove()
		print(AK.Lang.Phase.Two[KBM.Lang])
	end
end

function AK.PhaseThree()
	AK.PhaseObj.Objectives:Remove()
	AK.Phase = 3
	AK.PhaseObj:SetPhase(3)
	AK.Lasher.UnitList = {}
	AK.Stinger.UnitList = {}
	AK.Counts.Stingers = 0
	AK.Counts.Lashers = 0
	KBM.MechTimer:AddRemove(AK.Jornaru.TimersRef.SummonTwo, true)
	KBM.MechTimer:AddStart(AK.Akylios.TimersRef.EmergeFirst)
	KBM.MechTimer:AddStart(AK.Akylios.TimersRef.BreathFirst)
	AK.PhaseObj.Objectives:AddPercent(AK.Akylios, 55, 100)
	AK.PhaseObj.Objectives:AddPercent(AK.Jornaru, 0, 50)
	AK.Jornaru.Triggers.AltPhaseFour.Enabled = true
	print(AK.Lang.Phase.Three[KBM.Lang])
end

function AK.PhaseFour()
	if AK.Phase < 4 then
		AK.Jornaru.Triggers.AltPhaseFour.Enabled = false
		AK.PhaseObj.Objectives:Remove()
		AK.Phase = 4
		AK.PhaseObj:SetPhase(4)
		KBM.MechTimer:AddStart(AK.Jornaru.TimersRef.WaveFourFirst)
		if AK.Jornaru.UnitID then
			AK.Jornaru.CastBar:Create(AK.Jornaru.UnitID)
		end
		AK.PhaseObj.Objectives:AddPercent(AK.Akylios, 15, 55)
		AK.PhaseObj.Objectives:AddPercent(AK.Jornaru, 0, 50)
		print(AK.Lang.Phase.Four[KBM.Lang])
	end
end

function AK.PhaseFinal()
	if AK.Phase < 5 then
		AK.PhaseObj.Objectives:Remove()
		AK.Phase = 5
		AK.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		KBM.MechTimer:AddRemove(AK.Akylios.TimersRef.Emerge, true)
		KBM.MechTimer:AddRemove(AK.Akylios.TimersRef.Submerge, true)
		AK.PhaseObj.Objectives:AddPercent(AK.Akylios, 0, 15)
		AK.PhaseObj.Objectives:AddPercent(AK.Jornaru, 0, 15)
		print(AK.Lang.Phase.Final[KBM.Lang])
	end
end

function AK:RemoveUnits(UnitID)
	if self.Jornaru.UnitID == UnitID then
		self.Jornaru.Available = false
		return true
	end
	return false
end

function AK:Death(UnitID)
	if self.Jornaru.UnitID == UnitID then
		self.Jornaru.Dead = true
		if self.Akylios.Dead then
			return true
		end
	elseif self.Akylios.UnitID == UnitID then
		self.Akylios.Dead = true
		if self.Jornaru.Dead then
			return true
		end
	elseif self.Apostle.UnitList[UnitID] then
		if self.Apostle.UnitList[UnitID].CastBar then
			self.Apostle.UnitList[UnitID].CastBar:Remove()
		end
		self.Apostle.UnitList[UnitID].Dead = true
		self.Apostle.UnitList[UnitID].CastBar = nil
	else
		if self.Phase < 3 then
			if self.Stinger.UnitList[UnitID] then
				self.Counts.Stingers = self.Counts.Stingers + 1
				self.Stinger.UnitList[UnitID].Dead = true
			elseif self.Lasher.UnitList[UnitID] then
				self.Counts.Lashers = self.Counts.Lashers + 1
				self.Lasher.UnitList[UnitID].Dead = true
			end
			if self.Counts.Stingers == 8 and self.Counts.Lashers == 4 then
				AK.PhaseThree()
			end
		end
	end
	return false	
end

function AK:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				if uDetails.name == self.Jornaru.Name then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						self.Phase = 1
						self.Jornaru.CastBar:Create(unitID)
						KBM.MechTimer:AddStart(self.Jornaru.TimersRef.WaveOne)
						self.PhaseObj.Objectives:AddPercent(self.Jornaru, 50, 100)
						self.PhaseObj:SetPhase(1)
						self.PhaseObj:Start(self.StartTime)
					end
					self.Jornaru.Casting = false
					self.Jornaru.UnitID = unitID
					self.Jornaru.Available = true
					return self.Jornaru
				elseif uDetails.name == self.Akylios.Name then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						self.Phase = 3
						self.Akylios.CastBar:Create(unitID)
						self.PhaseObj.Objectives:AddPercent(self.Jornaru, 0, 50)
						self.PhaseObj:SetPhase(3)
						self.PhaseObj:Start(self.StartTime)
					end
					if not self.Akylios.UnitID then
						self.Akylios.CastBar:Create(unitID)
					end
					self.Akylios.Casting = false
					self.Akylios.UnitID = unitID
					self.Akylios.Available = true
					return self.Akylios
				elseif self.EncounterRunning then
					if not self.Bosses[uDetails.name].UnitList[unitID] then
						local SubBossObj = {
							Mod = AK,
							Level = "??",
							Name = uDetails.name,
							Dead = false,
							Casting = false,
							UnitID = unitID,
							Available = true,
						}
						self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
						if uDetails.name == self.Apostle.Name then
							SubBossObj.CastBar = KBM.Castbar:Add(self, self.Apostle, false, true)
							SubBossObj.CastBar:Create(unitID)
						end
					else
						self.Bosses[uDetails.name].UnitList[unitID].Available = true
						self.Bosses[uDetails.name].UnitList[unitID].UnitID = unitID
					end
					return self.Bosses[uDetails.name].UnitList[unitID]
				end
			end
		end
	end	
end

function AK:Reset()
	self.EncounterRunning = false
	self.Jornaru.UnitID = nil
	self.Akylios.UnitID = nil
	self.Jornaru.Dead = false
	self.Jornaru.CastBar:Remove()
	self.Akylios.Dead = false
	self.Akylios.CastBar:Remove()
	self.Counts.Lashers = 0
	self.Counts.Stingers = 0
	self.Phase = 1
	self.Stinger.UnitList = {}
	self.Lasher.UnitList = {}
	self.Jornaru.Triggers.AltPhaseFour.Enabled = false
	for UnitID, BossObj in pairs(self.Apostle.UnitList) do
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
			BossObj.CastBar = nil
		end
	end
	self.Apostle.UnitList = {}
	self.PhaseObj:End(Inspect.Time.Real())	
end

function AK:Timer()
end

function AK:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Akylios, self.Enabled)
	self.Jornaru.Menu.Timers.SummonTwoFirst.Child:SetHookEx(self.SummonTwoLink)
end

function AK:Start()	
	-- Create Timers
	-- Jornaru
	self.Jornaru.TimersRef.WaveOne = KBM.MechTimer:Add(AK.Lang.Mechanic.Wave[KBM.Lang], 40, true)
	self.Jornaru.TimersRef.WaveOne.MenuName = AK.Lang.Options.WaveOne[KBM.Lang]
	self.Jornaru.TimersRef.WaveFour = KBM.MechTimer:Add(AK.Lang.Mechanic.Wave[KBM.Lang], 50, true)
	self.Jornaru.TimersRef.WaveFour:NoMenu()
	self.Jornaru.TimersRef.WaveFourFirst = KBM.MechTimer:Add(AK.Lang.Mechanic.Wave[KBM.Lang], 54)
	self.Jornaru.TimersRef.WaveFourFirst.MenuName = AK.Lang.Options.WaveFour[KBM.Lang]
	self.Jornaru.TimersRef.WaveFourFirst:AddTimer(self.Jornaru.TimersRef.WaveFour, 0)
	self.Jornaru.TimersRef.OrbFirstSay = KBM.MechTimer:Add(AK.Lang.Mechanic.Orb[KBM.Lang], 50)
	self.Jornaru.TimersRef.OrbFirst = KBM.MechTimer:Add(AK.Lang.Mechanic.Orb[KBM.Lang], 65)
	self.Jornaru.TimersRef.OrbFirst.MenuName = self.Lang.Options.Orb[KBM.Lang]
	self.Jornaru.TimersRef.Orb = KBM.MechTimer:Add(AK.Lang.Mechanic.Orb[KBM.Lang], 30)
	self.Jornaru.TimersRef.Summon = KBM.MechTimer:Add(AK.Lang.Mechanic.Summon[KBM.Lang], 70)
	self.Jornaru.TimersRef.Summon.MenuName = AK.Lang.Options.Summon[KBM.Lang]
	self.Jornaru.TimersRef.SummonTwo = KBM.MechTimer:Add(AK.Lang.Mechanic.Summon[KBM.Lang], 80, true)
	self.Jornaru.TimersRef.SummonTwo:NoMenu()
	self.Jornaru.TimersRef.SummonTwoFirstSay = KBM.MechTimer:Add(AK.Lang.Mechanic.Summon[KBM.Lang], 45)
	self.Jornaru.TimersRef.SummonTwoFirstSay:AddTimer(self.Jornaru.TimersRef.SummonTwo, 0)
	self.Jornaru.TimersRef.SummonTwoFirst = KBM.MechTimer:Add(AK.Lang.Mechanic.Summon[KBM.Lang], 58)
	self.Jornaru.TimersRef.SummonTwoFirst:AddTimer(self.Jornaru.TimersRef.SummonTwo, 0)
	self.Jornaru.TimersRef.SummonTwoFirst.MenuName = AK.Lang.Options.SummonTwo[KBM.Lang]
	-- Akylios
	self.Akylios.TimersRef.Breath = KBM.MechTimer:Add(AK.Lang.Ability.Breath[KBM.Lang], 25)
	self.Akylios.TimersRef.Emerge = KBM.MechTimer:Add(AK.Lang.Mechanic.Emerge[KBM.Lang], 75)
	self.Akylios.TimersRef.Emerge:NoMenu()
	self.Akylios.TimersRef.Submerge = KBM.MechTimer:Add(AK.Lang.Mechanic.Submerge[KBM.Lang], 80)
	self.Akylios.TimersRef.Submerge:NoMenu()
	self.Akylios.TimersRef.Submerge:AddTimer(self.Akylios.TimersRef.Emerge, 0)
	self.Akylios.TimersRef.Emerge:AddTimer(self.Akylios.TimersRef.Submerge, 0)
	self.Akylios.TimersRef.EmergeFirst = KBM.MechTimer:Add(AK.Lang.Mechanic.Emerge[KBM.Lang], 80)
	self.Akylios.TimersRef.EmergeFirst.MenuName = self.Lang.Options.Emerge[KBM.Lang]
	self.Akylios.TimersRef.EmergeFirst:AddTimer(self.Akylios.TimersRef.Submerge, 0)
	self.Akylios.TimersRef.BreathFirst = KBM.MechTimer:Add(AK.Lang.Ability.Breath[KBM.Lang], 87)
	self.Akylios.TimersRef.BreathFirst.MenuName = self.Lang.Options.BreathFirst[KBM.Lang]
	self.Akylios.TimersRef.Lasher = KBM.MechTimer:Add(AK.Lang.Options.Lasher[KBM.Lang], 45)
	self.Akylios.TimersRef.Submerge:AddTimer(self.Akylios.TimersRef.Lasher, 0)
	
	-- Create Alerts
	-- Jornaru
	self.Jornaru.AlertsRef.WaveWarn = KBM.Alert:Create(AK.Lang.Mechanic.Wave[KBM.Lang], 5, true, true, "blue")
	self.Jornaru.AlertsRef.WaveWarn.MenuName = AK.Lang.Options.WaveWarn[KBM.Lang]
	self.Jornaru.AlertsRef.WaveWarnLong = KBM.Alert:Create(AK.Lang.Mechanic.Wave[KBM.Lang], 10, true, true, "cyan")
	self.Jornaru.AlertsRef.WaveWarnLong.MenuName = AK.Lang.Options.WaveWarnLong[KBM.Lang]
	self.Jornaru.TimersRef.WaveOne:AddAlert(self.Jornaru.AlertsRef.WaveWarnLong, 10)
	self.Jornaru.TimersRef.WaveOne:AddAlert(self.Jornaru.AlertsRef.WaveWarn, 5)
	self.Jornaru.TimersRef.WaveFour:AddAlert(self.Jornaru.AlertsRef.WaveWarnLong, 10)
	self.Jornaru.TimersRef.WaveFour:AddAlert(self.Jornaru.AlertsRef.WaveWarn, 5)
	self.Jornaru.TimersRef.WaveFourFirst:AddAlert(self.Jornaru.AlertsRef.WaveWarnLong, 10)
	self.Jornaru.TimersRef.WaveFourFirst:AddAlert(self.Jornaru.AlertsRef.WaveWarn, 5)
	self.Jornaru.AlertsRef.Orb = KBM.Alert:Create(AK.Lang.Mechanic.Orb[KBM.Lang], 8, false, true, "orange")
	self.Jornaru.AlertsRef.Orb:Important()
	-- Akylios
	self.Akylios.AlertsRef.Decay = KBM.Alert:Create(AK.Lang.Ability.Decay[KBM.Lang], nil, false, true, "purple")
	self.Akylios.AlertsRef.Decay:Important()
	self.Akylios.AlertsRef.Breath = KBM.Alert:Create(AK.Lang.Ability.Breath[KBM.Lang], nil, false, true, "red")
	self.Akylios.AlertsRef.Breath.MenuName = self.Lang.Options.Breath[KBM.Lang]
	self.Akylios.AlertsRef.BreathWarn = KBM.Alert:Create(AK.Lang.Ability.Breath[KBM.Lang], nil, true, true, "red")
	-- Apostle of Jornaru
	self.Apostle.AlertsRef.Storm = KBM.Alert:Create(AK.Lang.Ability.Storm[KBM.Lang], nil, false, true, "yellow")
	self.Apostle.AlertsRef.Storm:Important()
	
	-- Create Mechanic Spies
	self.Jornaru.MechRef.Orb = KBM.MechSpy:Add(AK.Lang.Mechanic.Orb[KBM.Lang], 8, "playerBuff", self.Jornaru)
	self.Akylios.MechRef.Decay = KBM.MechSpy:Add(AK.Lang.Ability.Decay[KBM.Lang], nil, "playerBuff", self.Akylios)
	
	KBM.Defaults.AlertObj.Assign(self.Jornaru)
	KBM.Defaults.AlertObj.Assign(self.Akylios)
	KBM.Defaults.AlertObj.Assign(self.Apostle)
	
	KBM.Defaults.MechObj.Assign(self.Jornaru)
	KBM.Defaults.MechObj.Assign(self.Akylios)
	
	KBM.Defaults.TimerObj.Assign(self.Jornaru)
	KBM.Defaults.TimerObj.Assign(self.Akylios)
	
	-- Timer Linking MUST appear after settings have been initialized.
	self.Jornaru.TimersRef.SummonTwoFirst:SetLink(self.Jornaru.TimersRef.SummonTwoFirstSay)
	self.Jornaru.TimersRef.OrbFirst:SetLink(self.Jornaru.TimersRef.OrbFirstSay)
	
	-- Assign Mechanics to Triggers
	-- Jornaru
	self.Jornaru.Triggers.Orb = KBM.Trigger:Create(AK.Lang.Notify.Orb[KBM.Lang], "notify", self.Jornaru)
	self.Jornaru.Triggers.Orb:AddAlert(self.Jornaru.AlertsRef.Orb, true)
	self.Jornaru.Triggers.Orb:AddTimer(self.Jornaru.TimersRef.Orb)
	self.Jornaru.Triggers.Orb:AddSpy(self.Jornaru.MechRef.Orb)
	self.Jornaru.Triggers.PhaseTwoSay = KBM.Trigger:Create(AK.Lang.Say.PhaseTwo[KBM.Lang], "say", self.Jornaru)
	self.Jornaru.Triggers.PhaseTwoSay:AddPhase(self.PhaseTwoSay)
	self.Jornaru.Triggers.PhaseTwo = KBM.Trigger:Create(50, "percent", self.Jornaru)
	self.Jornaru.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Jornaru.Triggers.Summon = KBM.Trigger:Create(self.Lang.Mechanic.Summon[KBM.Lang], "cast", self.Jornaru)
	self.Jornaru.Triggers.Summon:AddTimer(self.Jornaru.TimersRef.Summon)
	self.Jornaru.Triggers.AltPhaseFour = KBM.Trigger:Create("", "npcDamage", self.Jornaru)
	self.Jornaru.Triggers.AltPhaseFour:AddPhase(self.PhaseFour)
	self.Jornaru.Triggers.AltPhaseFour.Enabled = false
	-- Akylios
	self.Akylios.Triggers.PhaseFour = KBM.Trigger:Create(55, "percent", self.Akylios)
	self.Akylios.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Akylios.Triggers.PhaseFinal = KBM.Trigger:Create(15, "percent", self.Akylios)
	self.Akylios.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	self.Akylios.Triggers.Decay = KBM.Trigger:Create(self.Lang.Ability.Decay[KBM.Lang], "playerBuff", self.Akylios)
	self.Akylios.Triggers.Decay:AddAlert(self.Akylios.AlertsRef.Decay, true)
	self.Akylios.Triggers.Decay:AddSpy(self.Akylios.MechRef.Decay)
	self.Akylios.Triggers.DecayRemove = KBM.Trigger:Create(self.Lang.Ability.Decay[KBM.Lang], "playerBuffRemove", self.Akylios)
	self.Akylios.Triggers.DecayRemove:AddStop(self.Akylios.AlertsRef.Decay, true)
	self.Akylios.Triggers.DecayRemove:AddStop(self.Akylios.MechRef.Decay)
	self.Akylios.Triggers.BreathWarn = KBM.Trigger:Create(AK.Lang.Ability.Breath[KBM.Lang], "cast", self.Akylios)
	self.Akylios.Triggers.BreathWarn:AddTimer(AK.Akylios.TimersRef.Breath)
	self.Akylios.Triggers.BreathWarn:AddAlert(AK.Akylios.AlertsRef.BreathWarn)
	self.Akylios.Triggers.Breath = KBM.Trigger:Create(self.Lang.Ability.Breath[KBM.Lang], "channel", self.Akylios)
	self.Akylios.Triggers.Breath:AddAlert(self.Akylios.AlertsRef.Breath)
	-- Apostle of Jornaru
	self.Apostle.Triggers.Storm = KBM.Trigger:Create(self.Lang.Ability.Storm[KBM.Lang], "personalCast", self.Apostle)
	self.Apostle.Triggers.Storm:AddAlert(self.Apostle.AlertsRef.Storm)
	self.Apostle.Triggers.StormInt = KBM.Trigger:Create(self.Lang.Ability.Storm[KBM.Lang], "personalInterrupt", self.Apostle)
	self.Apostle.Triggers.StormInt:AddStop(self.Apostle.AlertsRef.Storm)
	
	self.Jornaru.CastBar = KBM.Castbar:Add(self, self.Jornaru)
	self.Akylios.CastBar = KBM.Castbar:Add(self, self.Akylios)

	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
		
end