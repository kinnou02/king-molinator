-- King Boss Mods Locale Manager
-- Written By Paul Snart
-- Copyright 2012
--

local AddonData = Inspect.Addon.Detail("KBMLocaleManager")
KBMLM = AddonData.data
KBMLM.Language = {
	Phrases = {},
}
KBMLM.TotalPhrases = 0

function KBMLM.InitStore()
	local Store = {
		German = {
			Total = 0,
			List = {},
		},
		French = {
			Total = 0,
			List = {},
		},
		Russian = {
			Total = 0,
			List = {},
		},
		Korean = {
			Total = 0,
			List = {},
		},
	}
	return Store
end

function KBMLM.Language:Add(Phrase)
	-- Main Dictionary Handler
	-- All Languages are filled with English versions, until updated.
	local SetPhrase = {}
	SetPhrase.English = Phrase
	SetPhrase.French = Phrase
	SetPhrase.German = Phrase
	SetPhrase.Russian = Phrase
	SetPhrase.Korean = Phrase
	SetPhrase.Type = "Phrase"
	SetPhrase.Translated = {English = true}
	function SetPhrase:SetFrench(frPhrase)
		if frPhrase then
			self.French = frPhrase
		end
		self.Translated.French = true
	end
	function SetPhrase:SetGerman(gePhrase)
		if gePhrase then
			self.German = gePhrase
		end
		self.Translated.German = true
	end
	function SetPhrase:SetRussian(ruPhrase)
		if ruPhrase then
			self.Russian = ruPhrase
		end
		self.Translated.Russian = true
	end
	function SetPhrase:SetKorean(koPhrase)
		if koPhrase then
			self.Korean = koPhrase
		end
		self.Translated.Korean = true
	end
	KBMLM.TotalPhrases = KBMLM.TotalPhrases + 1
	return SetPhrase
end

function KBMLM.SetGroupObject(LangGroup, Type, Info)
	LangGroup.Type = Type
	LangGroup.Info = Info
end

-- Set Main Options Page Translations and In-Game messages/UI Headings
function KBMLM.SetMain_Lang()

	KBM = KBMLM.KBM
	-- Main Addon Dictionary
	-- Encounter related messages
	KBM.Language.Encounter = {}
	KBMLM.SetGroupObject(KBM.Language.Encounter, "GroupObject", "Encounter related messages")
	KBM.Language.Encounter.Start = KBM.Language:Add("Encounter started:")
	KBM.Language.Encounter.Start:SetFrench("Combat d\195\169but\195\169:")
	KBM.Language.Encounter.Start:SetGerman("Bosskampf gestartet:")
	KBM.Language.Encounter.Start:SetRussian("Бой начался:")
	KBM.Language.Encounter.GLuck = KBM.Language:Add("Good luck!")
	KBM.Language.Encounter.GLuck:SetFrench("Bonne chance!")
	KBM.Language.Encounter.GLuck:SetGerman("Viel Erfolg!")
	KBM.Language.Encounter.GLuck:SetRussian("Удачи!")
	KBM.Language.Encounter.Wipe = KBM.Language:Add("Encounter ended, possible wipe.")
	KBM.Language.Encounter.Wipe:SetFrench("Combat termin\195\169, wipe possible.")
	KBM.Language.Encounter.Wipe:SetGerman("Bosskampf beendet, möglicher Wipe.")
	KBM.Language.Encounter.Wipe.Russian  = "Бой закончен, возможный вайп."
	KBM.Language.Encounter.Victory = KBM.Language:Add("Encounter Victory!")
	KBM.Language.Encounter.Victory:SetFrench("Victoire, On l'a tué!")
	KBM.Language.Encounter.Victory:SetGerman("Bosskampf erfolgreich!")
	KBM.Language.Encounter.Victory:SetRussian("Победа!")
	KBM.Language.Encounter.Chronicle = KBM.Language:Add("Activate in Chronicles")
	KBM.Language.Encounter.Chronicle:SetGerman("in den Chroniken verwenden")
	KBM.Language.Encounter.Chronicle:SetRussian("Активировать в хрониках")
	KBM.Language.Encounter.Chronicle:SetFrench("Activé dans les Chroniques")

	-- Records Dictionary
	KBM.Language.Records = {}
	KBMLM.SetGroupObject(KBM.Language.Records, "GroupObject", "Records related")
	-- Records Tab
	KBM.Language.Records.Attempts = KBM.Language:Add("Attempts: ")
	KBM.Language.Records.Attempts:SetGerman("Pulls: ")
	KBM.Language.Records.Attempts:SetRussian("Пулы: ")
	KBM.Language.Records.Attempts:SetFrench("Essais: ")
	KBM.Language.Records.Wipes = KBM.Language:Add("Wipes: ")
	KBM.Language.Records.Wipes:SetGerman("Wipes: ")
	KBM.Language.Records.Wipes:SetFrench("Wipes: ")
	KBM.Language.Records.Wipes:SetRussian("Вайпы: ")
	KBM.Language.Records.Kills = KBM.Language:Add("Kills: ")
	KBM.Language.Records.Kills:SetGerman("Kills: ")
	KBM.Language.Records.Kills:SetFrench("Tués: ")
	KBM.Language.Records.Kills:SetRussian("Победы: ")
	KBM.Language.Records.Best = KBM.Language:Add("Best Time:")
	KBM.Language.Records.Best:SetGerman("Bestzeit:")
	KBM.Language.Records.Best:SetRussian("Лучшее время:")
	KBM.Language.Records.Best:SetFrench("Meilleur Temps:")
	KBM.Language.Records.Date = KBM.Language:Add("Date set: ")
	KBM.Language.Records.Date:SetGerman("Datum: ")
	KBM.Language.Records.Date:SetFrench("Date set: ")
	KBM.Language.Records.Date:SetRussian("Дата: ")
	KBM.Language.Records.Details = KBM.Language:Add("Details:")
	KBM.Language.Records.Details:SetGerman("Details:")
	KBM.Language.Records.Details:SetRussian("Подробности:")
	KBM.Language.Records.Details:SetFrench("Détails:")
	KBM.Language.Records.Rate = KBM.Language:Add("Success Rate is ")
	KBM.Language.Records.Rate:SetGerman("Erfolgsrate ist: ")
	KBM.Language.Records.Rate:SetRussian("Процент успеха: ")
	KBM.Language.Records.Rate:SetFrench("Taux Succès: ")
	KBM.Language.Records.NoRecord = KBM.Language:Add("No kills have been recorded")
	KBM.Language.Records.NoRecord:SetGerman("Keine Kills wurden bisher verzeichnet")
	KBM.Language.Records.NoRecord:SetRussian("Бои с этим боссом отсутсвуют")
	KBM.Language.Records.NoRecord:SetFrench("Aucun kills a été enregistré")
	-- In game Messages
	KBM.Language.Records.Previous = KBM.Language:Add("Previous best: ")
	KBM.Language.Records.Previous:SetGerman("Alte Bestzeit: ")
	KBM.Language.Records.Previous:SetRussian("Предыдущий рекорд: ")
	KBM.Language.Records.Previous:SetFrench("Meilleur précédent: ")
	KBM.Language.Records.BeatRecord = KBM.Language:Add("Congratulations: New Record!")
	KBM.Language.Records.BeatRecord:SetGerman("Gratulation! Neue Bestzeit!")
	KBM.Language.Records.BeatRecord:SetRussian("Поздравляем! Вы улучшили свой рекорд!")
	KBM.Language.Records.BeatRecord:SetFrench("Félicitation: Nouveau Record!")
	KBM.Language.Records.BeatChrRecord = KBM.Language:Add("Congratulations: New Chronicle Record!")
	KBM.Language.Records.BeatChrRecord:SetGerman("Gratulation! Neue Chroniken Bestzeit!")
	KBM.Language.Records.BeatChrRecord:SetRussian("Поздравляем! Вы улучшили свой рекорд в хрониках!")
	KBM.Language.Records.BeatChrRecord:SetFrench("Félicitation! Nouveau Record Chronique!")
	KBM.Language.Records.NewRecord = KBM.Language:Add("Congratulations: A new record has been set!")
	KBM.Language.Records.NewRecord:SetGerman("Gratulation! Eine neue Bestzeit wurde gesetzt!")
	KBM.Language.Records.NewRecord:SetRussian("Поздравляем! Вы установили рекорд!")
	KBM.Language.Records.NewRecord:SetFrench("Félicitation! Nouveau Record a été enregistré!")
	KBM.Language.Records.NewChrRecord = KBM.Language:Add("Congratulations: A new Chronicle record has been set!")
	KBM.Language.Records.NewChrRecord:SetGerman("Gratulation! Eine neue Chroniken Bestzeit wurde gesetzt!")
	KBM.Language.Records.NewChrRecord:SetRussian("Поздравляем! Вы установили рекорд в хрониках!")
	KBM.Language.Records.NewChrRecord:SetFrench("Félicitation! Nouveau Record Chronique a été enregistré!")
	KBM.Language.Records.Current = KBM.Language:Add("Current Record: ")
	KBM.Language.Records.Current:SetGerman("Aktuelle Bestzeit: ")
	KBM.Language.Records.Current:SetRussian("Текущий рекорд: ")
	KBM.Language.Records.Current:SetFrench("Record Actuel: ")
	KBM.Language.Records.Invalid = KBM.Language:Add("Time is invalid, no records can be set.")
	KBM.Language.Records.Invalid:SetGerman("Die Zeit ist ungültig, Bestzeit konnte nicht gesetzt werden.")
	KBM.Language.Records.Invalid:SetRussian("Время не удалось измерить, рекорд не засчитан.")
	KBM.Language.Records.Invalid:SetFrench("Temps est invalide, aucun record enregistrable.")

	-- Colors
	KBM.Language.Color = {}
	KBMLM.SetGroupObject(KBM.Language.Color, "GroupObject", "Colors")
	KBM.Language.Color.Custom = KBM.Language:Add("Custom color")
	KBM.Language.Color.Custom:SetGerman("eigene Farbauswahl")
	KBM.Language.Color.Custom:SetRussian("Свой цвет")
	KBM.Language.Color.Custom:SetFrench("Custom couleur")
	KBM.Language.Color.Red = KBM.Language:Add("Red")
	KBM.Language.Color.Red:SetGerman("Rot")
	KBM.Language.Color.Red:SetRussian("Красный")
	KBM.Language.Color.Red:SetFrench("Rouge")
	KBM.Language.Color.Blue = KBM.Language:Add("Blue")
	KBM.Language.Color.Blue:SetGerman("Blau")
	KBM.Language.Color.Blue:SetRussian("Голубой")
	KBM.Language.Color.Blue:SetFrench("Bleu")
	KBM.Language.Color.Cyan = KBM.Language:Add("Cyan")
	KBM.Language.Color.Cyan:SetGerman("Blaugrün")
	KBM.Language.Color.Cyan:SetFrench("Cyan")
	KBM.Language.Color.Dark_Green = KBM.Language:Add("Dark Green")
	KBM.Language.Color.Dark_Green:SetGerman("Dunkelgrün")
	KBM.Language.Color.Dark_Green:SetRussian("Темнозеленый")
	KBM.Language.Color.Dark_Green:SetFrench("Vert Foncé")
	KBM.Language.Color.Yellow = KBM.Language:Add("Yellow")
	KBM.Language.Color.Yellow:SetGerman("Gelb")
	KBM.Language.Color.Yellow:SetRussian("Желтый")
	KBM.Language.Color.Yellow:SetFrench("Jaune")
	KBM.Language.Color.Orange = KBM.Language:Add("Orange")
	KBM.Language.Color.Orange:SetGerman("Orange")
	KBM.Language.Color.Orange:SetFrench("Orange")
	KBM.Language.Color.Orange:SetRussian("Оранжевый")
	KBM.Language.Color.Purple = KBM.Language:Add("Purple")
	KBM.Language.Color.Purple:SetGerman("Lila")
	KBM.Language.Color.Purple:SetRussian("Фиолетовый")
	KBM.Language.Color.Purple:SetFrench("Violet")

	-- Castbar Action Dictionary
	KBM.Language.CastBar = {}
	KBMLM.SetGroupObject(KBM.Language.CastBar, "GroupObject", "Castbar Action")
	KBM.Language.CastBar.Interrupt = KBM.Language:Add("Interrupted")
	KBM.Language.CastBar.Interrupt:SetGerman("Unterbrochen")
	KBM.Language.CastBar.Interrupt:SetFrench("Interrupted")
	KBM.Language.CastBar.Interrupt:SetRussian("Прерван")

	-- Cast-bar related options
	KBM.Language.Options = {}
	KBMLM.SetGroupObject(KBM.Language.Options, "GroupObject", "General and Main options")
	KBM.Language.Options.CastbarOverride = KBM.Language:Add("Castbar: Override")
	KBM.Language.Options.CastbarOverride:SetGerman("separate Einstellungen")
	KBM.Language.Options.CastbarOverride:SetFrench("Barre-cast: Substituer")
	KBM.Language.Options.CastbarOverride:SetRussian("Кастбар: Переопределить")
	KBM.Language.Options.Pinned = KBM.Language:Add("Pin to ")
	KBM.Language.Options.Pinned:SetGerman("Anheften an ")
	KBM.Language.Options.Pinned:SetFrench("Pin à ")
	KBM.Language.Options.Pinned:SetRussian("Привязать к ")
	KBM.Language.Options.FiltersEnabled = KBM.Language:Add("Enable cast filters")
	KBM.Language.Options.FiltersEnabled:SetGerman("Aktiviere Zauber Filter")
	KBM.Language.Options.FiltersEnabled:SetFrench("Activer filtres cast")
	KBM.Language.Options.FiltersEnabled:SetRussian("Разрешить фильтры кастбара")
	KBM.Language.Options.Castbar = KBM.Language:Add("Cast-bars")
	KBM.Language.Options.Castbar:SetFrench("Barres-cast")
	KBM.Language.Options.Castbar:SetGerman("Zauberbalken")
	KBM.Language.Options.Castbar:SetRussian("Кастбары")
	KBM.Language.Options.CastbarEnabled = KBM.Language:Add("Cast-bars enabled")
	KBM.Language.Options.CastbarEnabled:SetFrench("Barres-cast activ\195\169")
	KBM.Language.Options.CastbarEnabled:SetGerman("Zauberbalken anzeigen")
	KBM.Language.Options.CastbarEnabled:SetRussian("Кастбары разрешены")

	-- Timer Options
	KBM.Language.Options.MechTimerOverride = KBM.Language:Add("Mechanic Timers: Override")
	KBM.Language.Options.MechTimerOverride:SetGerman("separate Einstellungen")
	KBM.Language.Options.MechTimerOverride:SetRussian("Таймеры механики: Переопределить")
	KBM.Language.Options.MechTimerOverride:SetFrench("Timers de Mécanisme: Override")
	KBM.Language.Options.EncTimerOverride = KBM.Language:Add("Encounter Timer: Override")
	KBM.Language.Options.EncTimerOverride:SetGerman("separate Boss Timer: Einstellungen")
	KBM.Language.Options.EncTimerOverride:SetRussian("Таймер боя: Переопределить")
	KBM.Language.Options.EncTimerOverride:SetFrench("Timers combat: Substituer")
	KBM.Language.Options.EncTimers = KBM.Language:Add("Encounter Timers enabled")
	KBM.Language.Options.EncTimers:SetGerman("Boss Timer anzeigen")
	KBM.Language.Options.EncTimers:SetRussian("Таймеры боя разрешены")
	KBM.Language.Options.EncTimers:SetFrench("Timers combat activé")
	KBM.Language.Options.MechanicTimers = KBM.Language:Add("Mechanic Timers enabled")
	KBM.Language.Options.MechanicTimers:SetFrench("Timers de M\195\169canisme")
	KBM.Language.Options.MechanicTimers:SetGerman("Mechanik Timer")
	KBM.Language.Options.MechanicTimers:SetRussian("Таймеры механики разрешены")
	KBM.Language.Options.TimersEnabled = KBM.Language:Add("Timers enabled")
	KBM.Language.Options.TimersEnabled:SetFrench("Timers activ\195\169")
	KBM.Language.Options.TimersEnabled:SetGerman("Timer anzeigen")
	KBM.Language.Options.TimersEnabled:SetRussian("Таймер разрешен")
	KBM.Language.Options.ShowTimer = KBM.Language:Add("Show Timer (for positioning)")
	KBM.Language.Options.ShowTimer:SetFrench("Montrer Timer (pour positionnement)")
	KBM.Language.Options.ShowTimer:SetGerman("Zeige Timer (für Positionierung)")
	KBM.Language.Options.ShowTimer:SetRussian("Показать таймер (для позиционирования)")
	KBM.Language.Options.LockTimer = KBM.Language:Add("Unlock Timer")
	KBM.Language.Options.LockTimer:SetFrench("D\195\169bloquer Timer")
	KBM.Language.Options.LockTimer:SetGerman("Timer ist verschiebbar")
	KBM.Language.Options.LockTimer:SetRussian("Разблокировать таймер")
	KBM.Language.Options.Timer = KBM.Language:Add("Encounter duration Timer")
	KBM.Language.Options.Timer:SetFrench("Timer duration combat")
	KBM.Language.Options.Timer:SetGerman("Kampfdauer Anzeige")
	KBM.Language.Options.Timer:SetRussian("Таймер продолжительности энкаунтера")
	KBM.Language.Options.Enrage = KBM.Language:Add("Enrage Timer (if supported)")
	KBM.Language.Options.Enrage:SetFrench("Timer d'Enrage (si support\195\169)")
	KBM.Language.Options.Enrage:SetGerman("Enrage Anzeige (wenn unterstützt)")
	KBM.Language.Options.Enrage:SetRussian("Энрейдж Таймер (если поддерживается)")

	-- Anchors Options
	KBM.Language.Options.ShowAnchor = KBM.Language:Add("Show anchor (for positioning)")
	KBM.Language.Options.ShowAnchor:SetFrench("Montrer ancrage (pour positionnement)")
	KBM.Language.Options.ShowAnchor:SetGerman("Zeige Anker (für Positionierung)")
	KBM.Language.Options.ShowAnchor:SetRussian("Показать якорь (для позиционирования)")
	KBM.Language.Options.LockAnchor = KBM.Language:Add("Unlock anchor")
	KBM.Language.Options.LockAnchor:SetFrench("D\195\169bloquer Ancrage")
	KBM.Language.Options.LockAnchor:SetGerman("Anker ist verschiebbar")
	KBM.Language.Options.LockAnchor:SetRussian("Разблокировать якорь")

	-- Phase Monitor
	KBM.Language.Options.PhaseMonOverride = KBM.Language:Add("Phase Monitor: Override")
	KBM.Language.Options.PhaseMonOverride:SetGerman("separate Phasen Monitor: Einstellungen")
	KBM.Language.Options.PhaseMonOverride:SetFrench("Moniteur Phase: Substituer")
	KBM.Language.Options.PhaseMonOverride:SetRussian("Монитор фаз: Переопределить")
	KBM.Language.Options.PhaseMonitor = KBM.Language:Add("Phase Monitor")
	KBM.Language.Options.PhaseMonitor:SetGerman("Phasen Monitor")
	KBM.Language.Options.PhaseMonitor:SetRussian("Монитор фаз")
	KBM.Language.Options.PhaseMonitor:SetFrench("Moniteur Phase")
	KBM.Language.Options.PhaseEnabled = KBM.Language:Add("Enable Phase Monitor")
	KBM.Language.Options.PhaseEnabled:SetGerman("Phasen Monitor anzeigen")
	KBM.Language.Options.PhaseEnabled:SetRussian("Монитор фаз: активирован")
	KBM.Language.Options.PhaseEnabled:SetFrench("Activer Moniteur Phase")	
	KBM.Language.Options.Phases = KBM.Language:Add("Display current Phase")
	KBM.Language.Options.Phases:SetGerman("Zeige aktuelle Phase an")
	KBM.Language.Options.Phases:SetRussian("Показывать текущую фазу")
	KBM.Language.Options.Phases:SetFrench("Afficher Phase courante")
	KBM.Language.Options.Objectives = KBM.Language:Add("Display Phase objective tracking")
	KBM.Language.Options.Objectives:SetGerman("Zeige Phasen Aufgabe an")
	KBM.Language.Options.Objectives:SetRussian("Показывать цели фазы")
	KBM.Language.Options.Objectives:SetFrench("Afficher objectifs de Phase")
	KBM.Language.Options.Phase = KBM.Language:Add("Phase")
	KBM.Language.Options.Phase:SetGerman("Phase")
	KBM.Language.Options.Phase:SetFrench("Phase")
	KBM.Language.Options.Phase:SetRussian("Фаза")
	KBM.Language.Options.Single = KBM.Language:Add("Single")
	KBM.Language.Options.Single:SetGerman("Einzel")
	KBM.Language.Options.Single:SetFrench("Simple")
	KBM.Language.Options.Ground = KBM.Language:Add("Ground")
	KBM.Language.Options.Ground:SetGerman("Boden")
	KBM.Language.Options.Ground:SetFrench("Sol")
	KBM.Language.Options.Air = KBM.Language:Add("Air")
	KBM.Language.Options.Air:SetGerman("Flug")
	KBM.Language.Options.Air:SetFrench("Air")
	KBM.Language.Options.Final = KBM.Language:Add("Final")
	KBM.Language.Options.Final:SetGerman("Letzte")
	KBM.Language.Options.Final:SetFrench("Final")
	KBM.Language.Options.Dead = KBM.Language:Add("Dead")
	KBM.Language.Options.Dead:SetGerman("Tot")
	KBM.Language.Options.Dead:SetFrench("Mort")

	-- Button Options
	KBM.Language.Options.Button = KBM.Language:Add("Options Button Visible")
	KBM.Language.Options.Button:SetFrench("Bouton Configurations Visible")
	KBM.Language.Options.Button:SetGerman("Options-Schalter sichtbar")
	KBM.Language.Options.Button:SetRussian("Отображать кнопку настроек")
	KBM.Language.Options.LockButton = KBM.Language:Add("Unlock Button (right-click to move)")
	KBM.Language.Options.LockButton:SetFrench("D\195\169bloquer Bouton (click-droit pour d\195\169placer)")
	KBM.Language.Options.LockButton:SetGerman("Schalter ist verschiebbar (Rechts-Klick zum verschieben)")
	KBM.Language.Options.LockButton:SetRussian("Разблокировать кнопку (правый клик для перемещения)")

	-- Tank Swap related
	KBM.Language.Options.TankSwap = KBM.Language:Add("Tank-Swaps")
	KBM.Language.Options.TankSwap:SetFrench("Tank-Swaps")
	KBM.Language.Options.TankSwap:SetGerman("Tank Wechsel")
	KBM.Language.Options.TankSwap:SetRussian("Танк-свап")
	KBM.Language.Options.Tank = KBM.Language:Add("Show Test Tanks")
	KBM.Language.Options.Tank:SetFrench("Afficher Test Tanks")
	KBM.Language.Options.Tank:SetGerman("Zeige Test-Tanks-Fenster")
	KBM.Language.Options.Tank:SetRussian("Показать тестовых танков")
	KBM.Language.Options.TankSwapEnabled = KBM.Language:Add("Tank-Swaps enabled")
	KBM.Language.Options.TankSwapEnabled:SetGerman("Tank Wechsel anzeigen")
	KBM.Language.Options.TankSwapEnabled:SetRussian("Включить танк-свап")
	KBM.Language.Options.TankSwapEnabled:SetFrench("Tank-Swaps activé")

	-- Alert related
	KBM.Language.Options.AlertsOverride = KBM.Language:Add("Alerts: Override")
	KBM.Language.Options.AlertsOverride:SetGerman("separate Einstellungen")
	KBM.Language.Options.AlertsOverride:SetFrench("Alertes: Substituer")
	KBM.Language.Options.AlertsOverride:SetRussian("Предупреждения: Переопределить")
	KBM.Language.Options.Alert = KBM.Language:Add("Screen Alerts")
	KBM.Language.Options.Alert:SetGerman("Alarmierungen")
	KBM.Language.Options.Alert:SetFrench("Alerte \195\160 l'\195\169cran")
	KBM.Language.Options.Alert:SetRussian("Предупреждения на экране")
	KBM.Language.Options.AlertsEnabled = KBM.Language:Add("Screen Alerts enabled")
	KBM.Language.Options.AlertsEnabled:SetGerman("Alarmierungen aktiviert")
	KBM.Language.Options.AlertsEnabled:SetFrench("Alerte \195\160 l'\195\169cran activ\195\169")
	KBM.Language.Options.AlertsEnabled:SetRussian("Отображать предупреждения на экране")
	KBM.Language.Options.AlertFlash = KBM.Language:Add("Screen flash enabled")
	KBM.Language.Options.AlertFlash:SetGerman("Bildschirm-Rand Flackern aktiviert")
	KBM.Language.Options.AlertFlash:SetFrench("Flash \195\169cran activ\195\169")
	KBM.Language.Options.AlertFlash:SetRussian("Мигание экрана разрешено")
	KBM.Language.Options.AlertText = KBM.Language:Add("Alert warning text enabled")
	KBM.Language.Options.AlertText:SetGerman("Alarmierungs-Text aktiviert")
	KBM.Language.Options.AlertText:SetFrench("Texte Avertissement Alerte activ\195\169")
	KBM.Language.Options.AlertText:SetRussian("Текст предупреждения разрешен")
	KBM.Language.Options.UnlockFlash = KBM.Language:Add("Unlock alert border for scaling")
	KBM.Language.Options.UnlockFlash:SetGerman("Alarmierungs Ränder sind änderbar.")
	KBM.Language.Options.UnlockFlash:SetRussian("Разблокировать рамку предупреждения")
	KBM.Language.Options.UnlockFlash:SetFrench("Débloquer bordure alerte pour ajustement")
	KBM.Language.Options.Border = KBM.Language:Add("Enable Border")
	KBM.Language.Options.Border:SetGerman("Ränder aktivieren")
	KBM.Language.Options.Border:SetFrench("Activer Bordure")
	KBM.Language.Options.Border:SetRussian("Показать рамку")
	KBM.Language.Options.Notify = KBM.Language:Add("Enable Text")
	KBM.Language.Options.Notify:SetGerman("Text aktivieren")
	KBM.Language.Options.Notify:SetRussian("Показать текст")
	KBM.Language.Options.Notify:SetFrench("Activer Texte")
	KBM.Language.Options.Sound = KBM.Language:Add("Play Sound")
	KBM.Language.Options.Sound:SetGerman("Sound abspielen")
	KBM.Language.Options.Sound:SetRussian("Играть звук")
	KBM.Language.Options.Sound:SetFrench("Jouer Son")
	
	-- Size Dictionary
	KBM.Language.Options.UnlockWidth = KBM.Language:Add("Unlock width for scaling (Mouse wheel)")
	KBM.Language.Options.UnlockWidth:SetGerman("Breite ist skalierbar")
	KBM.Language.Options.UnlockWidth:SetRussian("Разблокировать ширину (колесо мыши)")
	KBM.Language.Options.UnlockWidth:SetFrench("Débloquer largeur pour ajustement (Molette souris)")
	KBM.Language.Options.UnlockHeight = KBM.Language:Add("Unlock height for scaling (Mouse wheel)")
	KBM.Language.Options.UnlockHeight:SetGerman("Höhe ist skalierbar")
	KBM.Language.Options.UnlockHeight:SetRussian("Разблокировать высоту (колесо мыши)")
	KBM.Language.Options.UnlockHeight:SetFrench("Débloquer hauteur pour ajustement (Molette souris)")
	KBM.Language.Options.UnlockText = KBM.Language:Add("Unlock Text size (Mouse wheel)")
	KBM.Language.Options.UnlockText:SetGerman("Textgröße ist änderbar")
	KBM.Language.Options.UnlockText:SetRussian("Разблокировать размер текста (колесо мыши)")
	KBM.Language.Options.UnlockText:SetFrench("Débloquer Taille Texte (Molette Souris)")
	KBM.Language.Options.UnlockAlpha = KBM.Language:Add("Unlock transparency")
	KBM.Language.Options.UnlockAlpha:SetGerman("Transparenz ist änderbar")
	KBM.Language.Options.UnlockAlpha:SetRussian("Разблокировать прозрачность")
	KBM.Language.Options.UnlockAlpha:SetFrench("Débloquer transparence")

	-- Main Options Dictionary
	KBM.Language.Menu = {}
	KBM.Language.Menu.Global = KBM.Language:Add("Global Options")
	KBM.Language.Menu.Global:SetGerman("Globale Einstellungen")
	KBM.Language.Menu.Timers = KBM.Language:Add("Timers")
	KBM.Language.Menu.Timers:SetGerman("Timer")
	KBM.Language.Menu.Enable = KBM.Language:Add("Enable")
	KBM.Language.Menu.Enable:SetGerman("Aktiviere")
	KBM.Language.Menu.Filters = KBM.Language:Add("filters")
	KBM.Language.Menu.Filters:SetGerman("Filter")
	KBM.Language.Menu.Castbars = KBM.Language:Add("cast-bars")
	KBM.Language.Menu.Castbars:SetFrench("barres-cast")
	KBM.Language.Menu.Castbars:SetGerman("Zauberbalken")
	KBM.Language.Menu.Castbars:SetRussian("Кастбары")
	
	-- Misc.
	KBM.Language.Options.Character = KBM.Language:Add("Saving settings for this character only")
	KBM.Language.Options.Character:SetGerman("Einstellungen nur für diesen Charakter speichern")
	KBM.Language.Options.Character:SetFrench("Sauvegarder paramètre pour ce personnage uniquement")
	KBM.Language.Options.Character:SetRussian("Сохранить настройки только для этого персонажа")
	KBM.Language.Options.Character.French = "Sauvegarder configuration pour ce personnage uniquement"
	KBM.Language.Options.ModEnabled = KBM.Language:Add("Enable King Boss Mods v"..AddonData.toc.Version)
	KBM.Language.Options.ModEnabled:SetGerman("Aktiviere King Boss Mods v"..AddonData.toc.Version)
	KBM.Language.Options.ModEnabled:SetRussian("Активировать King Boss Mods v"..AddonData.toc.Version)
	KBM.Language.Options.ModEnabled:SetFrench("Activer King Boss Mods v"..AddonData.toc.Version)
	KBM.Language.Options.Enabled = KBM.Language:Add("Enabled")
	KBM.Language.Options.Enabled:SetGerman("Aktiviert")
	KBM.Language.Options.Enabled:SetRussian("Активировать")
	KBM.Language.Options.Enabled:SetFrench("Activé")
	KBM.Language.Options.Settings = KBM.Language:Add("Settings")
	KBM.Language.Options.Settings:SetFrench("Configurations")
	KBM.Language.Options.Settings:SetGerman("Einstellungen")
	KBM.Language.Options.Settings:SetRussian("Настройки")
	KBM.Language.Options.Shadow = KBM.Language:Add("Show text shadows")
	KBM.Language.Options.Shadow:SetGerman("Zeige Text Schattierung")
	KBM.Language.Options.Shadow:SetRussian("Отображать тень текста")
	KBM.Language.Options.Shadow:SetFrench("Montrer ombre texte")
	KBM.Language.Options.Texture = KBM.Language:Add("Enable textured overlay")
	KBM.Language.Options.Texture:SetGerman("Texturierte Balken aktiviert")
	KBM.Language.Options.Texture:SetRussian("Включить функцию наложения текстур")
	KBM.Language.Options.Texture:SetFrench("Activer overlay textures")

	-- Timer Dictionary
	KBM.Language.Timers = {}
	KBMLM.SetGroupObject(KBM.Language.Timers, "GroupObject", "Timer related")	
	KBM.Language.Timers.Time = KBM.Language:Add("Time")
	KBM.Language.Timers.Time:SetFrench("Durée")
	KBM.Language.Timers.Time:SetGerman("Zeit")
	KBM.Language.Timers.Time:SetRussian("Время")
	KBM.Language.Timers.Enrage = KBM.Language:Add("Enrage in")
	KBM.Language.Timers.Enrage:SetGerman("Enrage in")
	KBM.Language.Timers.Enrage:SetFrench("Enrage dans")
	KBM.Language.Timers.Enrage:SetRussian("Энрейдж через")

	KBM.Numbers = {}
	KBM.Numbers.Place = {}
	KBM.Numbers.Place[0] = "th"
	KBM.Numbers.Place[1] = "st"
	KBM.Numbers.Place[2] = "nd"
	KBM.Numbers.Place[3] = "rd"
end

function KBMLM.Start(KBM)
	KBMLM.KBM = KBM
	KBM.Language = KBMLM.Language
	KBMLM.SetMain_Lang()
	print("Locale Manager Sync")
end

function KBMLM.CheckLangList(LangTable, Counter)
end

function KBMLM.CheckLangTable(LangTable, Counter)
end

function KBMLM.FindMissing(TempLang)

	KBMLM.Store = KBMLM.InitStore()
	-- First check Main Translations KBM.Language.*.{LangObj}
	local MSID = "Main Dictionary"
	local FileID = "Locale.lua"
	for ID, LangObj in pairs(KBMLM.Language) do
		if type(LangObj) == "table" then
			if LangObj.Type == "GroupObject" then
				for phraseID, Phrase in pairs(LangObj) do
					if type(Phrase) == "table" then
						if Phrase.Type == "Phrase" then
							for LangID, CountObj in pairs(KBMLM.Store) do
								if not Phrase.Translated[LangID] then
									CountObj.Total = CountObj.Total + 1
									if not CountObj.List[MSID] then
										CountObj.List[MSID] = {}
										CountObj.List[MSID].Directory = "KBMLocaleManager/"
										CountObj.List[MSID].File = {}
									end
									if not CountObj.List[MSID].File[FileID] then
										CountObj.List[MSID].File[FileID] = {}
										CountObj.List[MSID].File[FileID].Group = {}
									end
									if not KBMLM.Store[LangID].List[MSID].File[FileID].Group[ID] then
										CountObj.List[MSID].File[FileID].Group[ID] = {}
										CountObj.List[MSID].File[FileID].Group[ID].Phrases = {}
										CountObj.List[MSID].File[FileID].Group[ID].Title = ID
									end
									local PhraseObj = "KBM.Language."..ID.."."..phraseID..":Set"..LangID..'("'..Phrase.English..'")'
									table.insert(CountObj.List[MSID].File[FileID].Group[ID].Phrases, PhraseObj)
								end
							end
						end
					end
				end
			end
		end
	end
	-- Now check each Boss Mod for missing translations. ({mod}.Lang.*.{LangObj})
	for ModID, ModObj in pairs(KBM.BossMod) do
		-- Check if the Mod has a language table
		if ModObj.Lang then
			-- Now itterate through the language table
			for ID, LangObj in pairs(ModObj.Lang) do
				-- Itterate through each phrase for this group.
				for PhraseID, Phrase in pairs(LangObj) do
					if type(Phrase) == "table" then
						if Phrase.Type == "Phrase" then
							-- Check Each language (this will soon defualt to current client language)
							for LangID, CountObj in pairs(KBMLM.Store) do
								if not Phrase.Translated[LangID] then
									if ModObj.Directory then
										CountObj.Total = CountObj.Total + 1
										if not CountObj.List[ModObj.Directory] then
											CountObj.List[ModObj.Directory] = {}
											CountObj.List[ModObj.Directory].Directory = ModObj.Directory
											CountObj.List[ModObj.Directory].File = {}
										end
										if not CountObj.List[ModObj.Directory].File[ModObj.File] then
											CountObj.List[ModObj.Directory].File[ModObj.File] = {}
											CountObj.List[ModObj.Directory].File[ModObj.File].Group = {}
										end
										if not CountObj.List[ModObj.Directory].File[ModObj.File].Group[ID] then
											CountObj.List[ModObj.Directory].File[ModObj.File].Group[ID] = {}
											CountObj.List[ModObj.Directory].File[ModObj.File].Group[ID].Phrases = {}
											CountObj.List[ModObj.Directory].File[ModObj.File].Group[ID].Title = ID
										end
										local PhraseObj = tostring(ModObj.Object)..".Lang."..ID.."."..PhraseID..":Set"..LangID..'("'..Phrase.English..'")'
										table.insert(CountObj.List[ModObj.Directory].File[ModObj.File].Group[ID].Phrases, PhraseObj)
									else
										print("Mod layout error for: "..ModObj.ID)
										print("Mod ID: "..ModID)
										print("Instance: "..tostring(ModObj.Instance.Name))
									end
								end
							end
						end
					end
				end
			end
		else
			print("Mod: "..ModID.." does not have a translation table.")
		end
	end
	-- Now check for Plug-In Translations
	-- Tba
	if TempLang == "" then
		TempLang = KBM.Lang
	end
	print("Total Dictionary Entries: "..KBMLM.TotalPhrases.." (Includes non-tracked Plug-In Translations)")
	for LangID, Object in pairs(KBMLM.Store) do
		print(LangID..": "..Object.Total)
	end
	if KBMLM.Store[TempLang] then
		print_raw("-- KBM Automated Translation output")
		print_raw("-- Language: "..TempLang)
		for ID, Object in pairs(KBMLM.Store[TempLang].List) do
			print_raw("--")
			print_raw("-- Group ID: "..tostring(ID))
			print_raw("-- Directory: "..Object.Directory)
			for FileID, FileObj in pairs(Object.File) do
				print_raw("-- File: "..FileID)
				for GroupID, GroupObj in pairs(FileObj.Group) do
					print_raw("-- Sub Type: "..GroupObj.Title)
					for i, Phrase in ipairs(GroupObj.Phrases) do
						print_raw(Phrase)
					end
				end
				print_raw("-- Group list End ****")
				print_raw("--")
			end
			print_raw("-- File List End ******")
			print_raw("--")
		end
		print_raw("--")
		print_raw("-- Report complete.")
	else
		print("Attempt to produce report for: "..tostring(TempLang))
		if TempLang == "English" then
			print("Please use /kbmlocale [language] to report on a non-English language")
		else
			print("Unsupported Language: No report can be generated")
		end
		local TempStr = "Supported translations are: "
		for LangID, Object in pairs(KBMLM.Store) do
			TempStr = TempStr..LangID..", "
		end
		print(TempStr)
	end
end