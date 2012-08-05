-- King Boss Mods Locale Manager
-- Written By Paul Snart
-- Copyright 2012
--

local AddonData = Inspect.Addon.Detail("KBMLocaleManager")
local KBMLM = AddonData.data
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
	-- Welcome Messages
	KBM.Language.Welcome = {}
	KBMLM.SetGroupObject(KBM.Language.Welcome, "GroupObject", "Welcome messages")
	KBM.Language.Welcome.Welcome = KBM.Language:Add("Welcome to King Boss Mods v")
	KBM.Language.Welcome.Welcome:SetGerman("Willkommen zu King Boss Mods v")
	KBM.Language.Welcome.Welcome:SetFrench("Bienvenu sur King Boss Mods v")
	KBM.Language.Welcome.Welcome:SetKorean("킹보스 모드 v에 오신것을 환영합니다!")
	KBM.Language.Welcome.Commands = KBM.Language:Add("/kbmhelp for a list of commands")
	KBM.Language.Welcome.Commands:SetGerman("/kbmhelp für eine Liste möglicher Befehle")
	KBM.Language.Welcome.Commands:SetFrench("/kbmhelp pour la liste des commandes")
	KBM.Language.Welcome.Commands:SetKorean("커맨드 도움말은 /kbmhelp 을 치시면 됩니다.")
	KBM.Language.Welcome.Options = KBM.Language:Add("/kbmoptions for options")
	KBM.Language.Welcome.Options:SetFrench("/kbmoptions pour la configuration")
	KBM.Language.Welcome.Options:SetGerman("/kbmoptions für die Konfiguration")
	KBM.Language.Welcome.Options:SetKorean("옵션은 /kbmoptions 을 사용하시면 됩니다.")
	
	-- Version Info
	KBM.Language.Version = {}
	KBMLM.SetGroupObject(KBM.Language.Version, "GroupObject", "Version Related Text")
	KBM.Language.Version.Title = KBM.Language:Add("You are running:")
	KBM.Language.Version.Title:SetFrench("Vous exécuter ceci:")
	KBM.Language.Version.Title:SetGerman("Du benutzt:")
	KBM.Language.Version.Title:SetKorean("현재 실행중입니다:")
	KBM.Language.Version.Old = KBM.Language:Add("There is a newer version of KBM available, please update!")
	KBM.Language.Version.Old:SetGerman("Es ist eine neuere King Boss Mods Version verfügbar, bitte updaten!")
	KBM.Language.Version.Old:SetFrench("Il existe une version plus récente de KBM disponible, svp mettre-à-jour!")
	KBM.Language.Version.Old:SetKorean("새로운 KBM버전이 나왔습니다. 업데이트 해주세요!")
	KBM.Language.Version.OldInfo = KBM.Language:Add("The most recent version seen is v")
	KBM.Language.Version.OldInfo:SetGerman("Die neueste Version ist v")
	KBM.Language.Version.OldInfo:SetFrench("La version la plus récente vue est v")
	KBM.Language.Version.OldInfo:SetKorean("현재 발견된 최신의 버전은 v")
	KBM.Language.Version.Alpha = KBM.Language:Add("There is a newer Alpha build of KBM available, please update!")
	KBM.Language.Version.Alpha:SetGerman("Es ist eine neuere Alpha Version verfügbar, bitte updaten!")
	KBM.Language.Version.Alpha:SetFrench("Il y a un nouveau build Alpha de KBM disponible, svp mettre-à-jour!")
	KBM.Language.Version.Alpha:SetKorean("KBM 새로운 알파빌드가 릴리즈 되었습니다. 업데이트 해주세요!")
	KBM.Language.Version.AlphaInfo = KBM.Language:Add("You are running r%d, there is at least build r%d in circulation.")
	KBM.Language.Version.AlphaInfo:SetGerman("Du benutzt r%d, es gibt bereits eine neue Version r%d.")
	KBM.Language.Version.AlphaInfo:SetFrench("Vous exécutez r%d, il y a le build r%d de KBM en circulation.")
	KBM.Language.Version.AlphaInfo:SetKorean("현재 버전은 r%d, 버전 r%d 에 새로운 릴리즈가 있을겁니다.")
	
	-- Rez Master Dictionary
	KBM.Language.RezMaster = {}
	KBMLM.SetGroupObject(KBM.Language.RezMaster, "GroupObject", "Rez Master dictionary")
	KBM.Language.RezMaster.Name = KBM.Language:Add("Rez Master")
	KBM.Language.RezMaster.Name:SetGerman("Rez Meister")
	KBM.Language.RezMaster.Name:SetFrench("Suivi des Rez")
	KBM.Language.RezMaster.Name:SetKorean("부활 마스터")
	KBM.Language.RezMaster.Enabled = KBM.Language:Add("Enable Rez Master")
	KBM.Language.RezMaster.Enabled:SetFrench("Activer Suivi des Rez")
	KBM.Language.RezMaster.Enabled:SetGerman("Rez Meister anzeigen")
	KBM.Language.RezMaster.Enabled:SetKorean("부활 마스터 적용")
	KBM.Language.RezMaster.Ready = KBM.Language:Add("Ready!")
	KBM.Language.RezMaster.Ready:SetFrench("Prêt!")
	KBM.Language.RezMaster.Ready:SetGerman("Bereit!")
	KBM.Language.RezMaster.Ready:SetKorean("준비!")
	KBM.Language.RezMaster.AnchorText = KBM.Language:Add("Rez Timer Anchor")
	KBM.Language.RezMaster.AnchorText:SetFrench("Ancrage Minuterie Rez")
	KBM.Language.RezMaster.AnchorText:SetGerman("Rez Meister Anker")
	KBM.Language.RezMaster.AnchorText:SetKorean("부활 시간 앵커")
	
	-- Chat Objects
	KBM.Language.Chat = {}
	KBMLM.SetGroupObject(KBM.Language.Chat, "GroupObject", "Chat based dictionary")
	KBM.Language.Chat.Enabled = KBM.Language:Add("Enable chat output")
	KBM.Language.Chat.Enabled:SetFrench("Activer redirection vers le chat")
	
	-- Command Listings
	KBM.Language.Command = {}
	KBMLM.SetGroupObject(KBM.Language.Command, "GroupObject", "Slash Command dictionary")
	KBM.Language.Command.Title = KBM.Language:Add("King Boss Mods in game slash commands")
	KBM.Language.Command.Title:SetGerman("King Boss Mods - mögliche Befehle")
	KBM.Language.Command.Title:SetFrench("King Boss Mods Commandes en jeu")
	KBM.Language.Command.Title:SetKorean("킹보스 모드 게임상 슬래쉬 커맨드 목록")
	KBM.Language.Command.On = KBM.Language:Add("/kbmon -- Turns the Addon to it's on state.")
	KBM.Language.Command.On:SetGerman("/kbmon -- Schaltet das Addon an.")
	KBM.Language.Command.On:SetFrench("/kbmon – Activer l’Addon.")
	KBM.Language.Command.On:SetKorean("/kbmon -- 애드온을 해당상태로 돌려놓음.")
	KBM.Language.Command.Off = KBM.Language:Add("/kbmoff -- Switches the Addon off.")
	KBM.Language.Command.Off:SetGerman("/kbmoff -- Schaltet das Addon aus.")
	KBM.Language.Command.Off:SetFrench("/kbmoff – Désactiver l’Addon.")
	KBM.Language.Command.Off:SetKorean("/kbmoff -- 애드온 끔.")
	KBM.Language.Command.Reset = KBM.Language:Add("/kbmreset -- Resets the current encounter.")
	KBM.Language.Command.Reset:SetGerman("/kbmreset -- Setzt den aktuellen Kampf zurück.")
	KBM.Language.Command.Reset:SetFrench("/kbmreset – Réanitialiser le combat en cours.")
	KBM.Language.Command.Reset:SetKorean("/kbmreset -- 현재 보스전 리셋.")
	KBM.Language.Command.Version = KBM.Language:Add("/kbmversion -- Displays the current version.")
	KBM.Language.Command.Version:SetFrench("/kbmversion - Afficher la version courante.")
	KBM.Language.Command.Version:SetGerman("/kbmversion - Zeigt die aktuelle Version an.")
	KBM.Language.Command.Version:SetKorean("/kbmversion -- 현재버전표시.")
	KBM.Language.Command.Options = KBM.Language:Add("/kbmoptions -- Toggles the GUI Options screen.")
	KBM.Language.Command.Options:SetGerman("/kbmoptions -- Blendet das Konfigurations-Fenster ein und aus.")
	KBM.Language.Command.Options:SetFrench("/kbmoptions – Afficher l’écran de configuration de KBM.")
	KBM.Language.Command.Options:SetKorean("/kbmoptions -- GUI 옵션화면 표시")
	KBM.Language.Command.Help = KBM.Language:Add("/kbmhelp -- Displays what you're reading now :)")
	KBM.Language.Command.Help:SetGerman("/kbmhelp -- Zeigt an, was du gerade liesst :)")
	KBM.Language.Command.Help:SetFrench("/kbmhelp – Afficher ce que vous lisez en ce moment :)")
	KBM.Language.Command.Help:SetKorean("/kbmhelp -- 플레이가 현재 읽는 도움말 표시 :)")
	
	-- Encounter Tabs
	KBM.Language.Tabs = {}
	KBMLM.SetGroupObject(KBM.Language.Tabs, "GroupObject", "Option Tabs related")
	KBM.Language.Tabs.Encounter = KBM.Language:Add("Encounter")
	KBM.Language.Tabs.Encounter:SetGerman("Gegner")
	KBM.Language.Tabs.Encounter:SetFrench("Combat")
	KBM.Language.Tabs.Encounter:SetRussian("Бой")
	KBM.Language.Tabs.Encounter:SetKorean("보스전")
	KBM.Language.Tabs.Timers = KBM.Language:Add("Timers")
	KBM.Language.Tabs.Timers:SetGerman("Timer")
	KBM.Language.Tabs.Timers:SetFrench("Minuteries")
	KBM.Language.Tabs.Timers:SetRussian("Таймеры")
	KBM.Language.Tabs.Timers:SetKorean("타이머")
	KBM.Language.Tabs.Alerts = KBM.Language:Add("Alerts")
	KBM.Language.Tabs.Alerts:SetGerman("Alarmierungen")
	KBM.Language.Tabs.Alerts:SetFrench("Alertes")
	KBM.Language.Tabs.Alerts:SetRussian("Предупреждения")
	KBM.Language.Tabs.Alerts:SetKorean("경보")
	KBM.Language.Tabs.Castbars = KBM.Language:Add("Castbars")
	KBM.Language.Tabs.Castbars:SetGerman("Zauberbalken")
	KBM.Language.Tabs.Castbars:SetFrench("Barres-cast")
	KBM.Language.Tabs.Castbars:SetRussian("Кастбары")
	KBM.Language.Tabs.Castbars:SetKorean("캐스터바")
	KBM.Language.Tabs.Records = KBM.Language:Add("Records")
	KBM.Language.Tabs.Records:SetGerman("Bestzeiten")
	KBM.Language.Tabs.Records:SetFrench("Archives")
	KBM.Language.Tabs.Records:SetRussian("Рекорды")
	KBM.Language.Tabs.Records:SetKorean("기록")
	KBM.Language.Tabs.Plugins = KBM.Language:Add("Plug-Ins")
	KBM.Language.Tabs.Plugins:SetGerman()
	KBM.Language.Tabs.Plugins:SetFrench()
	KBM.Language.Tabs.Plugins:SetKorean("플러그인")
	
	-- Encounter related messages
	KBM.Language.Encounter = {}
	KBMLM.SetGroupObject(KBM.Language.Encounter, "GroupObject", "Encounter related messages")
	KBM.Language.Encounter.Start = KBM.Language:Add("Encounter started:")
	KBM.Language.Encounter.Start:SetFrench("Combat débuté:")
	KBM.Language.Encounter.Start:SetGerman("Bosskampf gestartet:")
	KBM.Language.Encounter.Start:SetRussian("Бой начался:")
	KBM.Language.Encounter.Start:SetKorean("보스전이 시작되었습니다:")
	KBM.Language.Encounter.GLuck = KBM.Language:Add("Good luck!")
	KBM.Language.Encounter.GLuck:SetFrench("Merde à tous!")
	KBM.Language.Encounter.GLuck:SetGerman("Viel Erfolg!")
	KBM.Language.Encounter.GLuck:SetRussian("Удачи!")
	KBM.Language.Encounter.GLuck:SetKorean("행운을 빕니다!")
	KBM.Language.Encounter.Wipe = KBM.Language:Add("Encounter ended, possible wipe.")
	KBM.Language.Encounter.Wipe:SetFrench("Combat terminé, Foutu wipe encore!")
	KBM.Language.Encounter.Wipe:SetGerman("Bosskampf beendet, möglicher Wipe.")
	KBM.Language.Encounter.Wipe:SetRussian("Бой закончен, возможный вайп.")
	KBM.Language.Encounter.Wipe:SetKorean("보스전이 끝났습니다. 아마 전멸했을듯.")
	KBM.Language.Encounter.Victory = KBM.Language:Add("Encounter Victory!")
	KBM.Language.Encounter.Victory:SetFrench("Victoire, On l'a tué!")
	KBM.Language.Encounter.Victory:SetGerman("Bosskampf erfolgreich!")
	KBM.Language.Encounter.Victory:SetRussian("Победа!")
	KBM.Language.Encounter.Victory:SetKorean("보스전 승리!")
	KBM.Language.Encounter.Chronicle = KBM.Language:Add("Activate in Chronicles")
	KBM.Language.Encounter.Chronicle:SetGerman("in den Chroniken verwenden")
	KBM.Language.Encounter.Chronicle:SetFrench("Activé dans les Chroniques")
	KBM.Language.Encounter.Chronicle:SetRussian("Включить в хрониках")
	KBM.Language.Encounter.Chronicle:SetKorean("크로니클 내부 동작")

	-- Records Dictionary
	KBM.Language.Records = {}
	KBMLM.SetGroupObject(KBM.Language.Records, "GroupObject", "Records related")
	-- Records Tab
	KBM.Language.Records.Attempts = KBM.Language:Add("Attempts: ")
	KBM.Language.Records.Attempts:SetGerman("Pulls: ")
	KBM.Language.Records.Attempts:SetRussian("Пуллов: ")
	KBM.Language.Records.Attempts:SetFrench("Essais: ")
	KBM.Language.Records.Attempts:SetKorean("시도: ")
	KBM.Language.Records.Wipes = KBM.Language:Add("Wipes: ")
	KBM.Language.Records.Wipes:SetGerman("Wipes: ")
	KBM.Language.Records.Wipes:SetFrench("Wipes: ")
	KBM.Language.Records.Wipes:SetRussian("Вайпов: ")
	KBM.Language.Records.Wipes:SetKorean("전멸: ")
	KBM.Language.Records.Kills = KBM.Language:Add("Kills: ")
	KBM.Language.Records.Kills:SetGerman("Kills: ")
	KBM.Language.Records.Kills:SetFrench("Tués: ")
	KBM.Language.Records.Kills:SetRussian("Побед: ")
	KBM.Language.Records.Kills:SetKorean("킬: ")
	KBM.Language.Records.Best = KBM.Language:Add("Best Time:")
	KBM.Language.Records.Best:SetGerman("Bestzeit:")
	KBM.Language.Records.Best:SetRussian("Лучшее время:")
	KBM.Language.Records.Best:SetFrench("Meilleur Temps:")
	KBM.Language.Records.Best:SetKorean("최고 기록:")
	KBM.Language.Records.Date = KBM.Language:Add("Date set: ")
	KBM.Language.Records.Date:SetGerman("Datum: ")
	KBM.Language.Records.Date:SetFrench("Date établie: ")
	KBM.Language.Records.Date:SetRussian("Дата: ")
	KBM.Language.Records.Date:SetKorean("날짜 셋팅: ")
	KBM.Language.Records.Details = KBM.Language:Add("Details:")
	KBM.Language.Records.Details:SetGerman("Details:")
	KBM.Language.Records.Details:SetRussian("Подробности:")
	KBM.Language.Records.Details:SetFrench("Détails:")
	KBM.Language.Records.Details:SetKorean("디테일:")
	KBM.Language.Records.Rate = KBM.Language:Add("Success Rate is ")
	KBM.Language.Records.Rate:SetGerman("Erfolgsrate ist: ")
	KBM.Language.Records.Rate:SetRussian("Процент успеха: ")
	KBM.Language.Records.Rate:SetFrench("Taux Succès: ")
	KBM.Language.Records.Rate:SetKorean("보스 성공률 ")
	KBM.Language.Records.NoRecord = KBM.Language:Add("No kills have been recorded")
	KBM.Language.Records.NoRecord:SetGerman("Keine Kills wurden bisher verzeichnet")
	KBM.Language.Records.NoRecord:SetRussian("Бои с этим боссом отсутсвуют")
	KBM.Language.Records.NoRecord:SetFrench("Aucun kills a été enregistré")
	KBM.Language.Records.NoRecord:SetKorean("기록된 킬링 기록이 없습니다.")
	-- In game Messages
	KBM.Language.Records.Previous = KBM.Language:Add("Previous best: ")
	KBM.Language.Records.Previous:SetGerman("Alte Bestzeit: ")
	KBM.Language.Records.Previous:SetRussian("Предыдущий рекорд: ")
	KBM.Language.Records.Previous:SetFrench("Meilleur précédent: ")
	KBM.Language.Records.Previous:SetKorean("최근 최고기록: ")
	KBM.Language.Records.BeatRecord = KBM.Language:Add("Congratulations: New Record!")
	KBM.Language.Records.BeatRecord:SetGerman("Gratulation! Neue Bestzeit!")
	KBM.Language.Records.BeatRecord:SetRussian("Поздравляем! Вы улучшили свой рекорд!")
	KBM.Language.Records.BeatRecord:SetFrench("Félicitation: Nouveau Record!")
	KBM.Language.Records.BeatRecord:SetKorean("축하 : 새로운 기록!")
	KBM.Language.Records.BeatChrRecord = KBM.Language:Add("Congratulations: New Chronicle Record!")
	KBM.Language.Records.BeatChrRecord:SetGerman("Gratulation! Neue Chroniken Bestzeit!")
	KBM.Language.Records.BeatChrRecord:SetRussian("Поздравляем! Вы улучшили свой рекорд в хрониках!")
	KBM.Language.Records.BeatChrRecord:SetFrench("Félicitation! Nouveau Record Chronique!")
	KBM.Language.Records.BeatChrRecord:SetKorean("경축: 새로운 크로니클 기록이 갱신!")
	KBM.Language.Records.NewRecord = KBM.Language:Add("Congratulations: A new record has been set!")
	KBM.Language.Records.NewRecord:SetGerman("Gratulation! Eine neue Bestzeit wurde gesetzt!")
	KBM.Language.Records.NewRecord:SetRussian("Поздравляем! Вы установили рекорд!")
	KBM.Language.Records.NewRecord:SetFrench("Félicitation! Nouveau Record a été enregistré!")
	KBM.Language.Records.NewRecord:SetKorean("경축: 새로운 기록 갱신!")
	KBM.Language.Records.NewChrRecord = KBM.Language:Add("Congratulations: A new Chronicle record has been set!")
	KBM.Language.Records.NewChrRecord:SetGerman("Gratulation! Eine neue Chroniken Bestzeit wurde gesetzt!")
	KBM.Language.Records.NewChrRecord:SetRussian("Поздравляем! Вы установили рекорд в хрониках!")
	KBM.Language.Records.NewChrRecord:SetFrench("Félicitation! Nouveau Record Chronique a été enregistré!")
	KBM.Language.Records.NewChrRecord:SetKorean("경축 : 새로운 크로니클 기록이 갱신!")
	KBM.Language.Records.Current = KBM.Language:Add("Current Record: ")
	KBM.Language.Records.Current:SetGerman("Aktuelle Bestzeit: ")
	KBM.Language.Records.Current:SetRussian("Текущий рекорд: ")
	KBM.Language.Records.Current:SetFrench("Record Actuel: ")
	KBM.Language.Records.Current:SetKorean("현재 기록: ")
	KBM.Language.Records.Invalid = KBM.Language:Add("Time is invalid, no records can be set.")
	KBM.Language.Records.Invalid:SetGerman("Die Zeit ist ungültig, Bestzeit konnte nicht gesetzt werden.")
	KBM.Language.Records.Invalid:SetRussian("Время не удалось измерить, рекорд не засчитан.")
	KBM.Language.Records.Invalid:SetFrench("Temps est invalide, aucun record enregistrable.")
	KBM.Language.Records.Invalid:SetKorean("시간이 올바르지 않습니다, 기록이 되지 않습니다.")

	-- Colors
	KBM.Language.Color = {}
	KBMLM.SetGroupObject(KBM.Language.Color, "GroupObject", "Colors")
	KBM.Language.Color.Custom = KBM.Language:Add("Custom color")
	KBM.Language.Color.Custom:SetGerman("eigene Farbauswahl")
	KBM.Language.Color.Custom:SetRussian("Свой цвет")
	KBM.Language.Color.Custom:SetFrench("Custom couleur")
	KBM.Language.Color.Custom:SetKorean("임의색깔")
	KBM.Language.Color.Red = KBM.Language:Add("Red")
	KBM.Language.Color.Red:SetGerman("Rot")
	KBM.Language.Color.Red:SetRussian("Красный")
	KBM.Language.Color.Red:SetFrench("Rouge")
	KBM.Language.Color.Red:SetKorean("빨강")
	KBM.Language.Color.Blue = KBM.Language:Add("Blue")
	KBM.Language.Color.Blue:SetGerman("Blau")
	KBM.Language.Color.Blue:SetRussian("Голубой")
	KBM.Language.Color.Blue:SetFrench("Bleu")
	KBM.Language.Color.Blue:SetKorean("파랑")
	KBM.Language.Color.Cyan = KBM.Language:Add("Cyan")
	KBM.Language.Color.Cyan:SetGerman("Blaugrün")
	KBM.Language.Color.Cyan:SetFrench("Cyan")
	KBM.Language.Color.Cyan:SetRussian("Сине-Зеленый")
	KBM.Language.Color.Cyan:SetKorean("하늘색")
	KBM.Language.Color.Dark_Green = KBM.Language:Add("Dark Green")
	KBM.Language.Color.Dark_Green:SetGerman("Dunkelgrün")
	KBM.Language.Color.Dark_Green:SetRussian("Темнозеленый")
	KBM.Language.Color.Dark_Green:SetFrench("Vert Foncé")
	KBM.Language.Color.Dark_Green:SetKorean("어두운 녹색")
	KBM.Language.Color.Yellow = KBM.Language:Add("Yellow")
	KBM.Language.Color.Yellow:SetGerman("Gelb")
	KBM.Language.Color.Yellow:SetRussian("Желтый")
	KBM.Language.Color.Yellow:SetFrench("Jaune")
	KBM.Language.Color.Yellow:SetKorean("노랑")
	KBM.Language.Color.Orange = KBM.Language:Add("Orange")
	KBM.Language.Color.Orange:SetGerman("Orange")
	KBM.Language.Color.Orange:SetFrench("Orange")
	KBM.Language.Color.Orange:SetRussian("Оранжевый")
	KBM.Language.Color.Orange:SetKorean("오렌지")
	KBM.Language.Color.Purple = KBM.Language:Add("Purple")
	KBM.Language.Color.Purple:SetGerman("Lila")
	KBM.Language.Color.Purple:SetRussian("Фиолетовый")
	KBM.Language.Color.Purple:SetFrench("Violet")
	KBM.Language.Color.Purple:SetKorean("보라")
	KBM.Language.Color.Pink = KBM.Language:Add("Pink")
	KBM.Language.Color.Pink:SetFrench("Rose")
	KBM.Language.Color.Dark_Grey = KBM.Language:Add("Dark Grey")
	KBM.Language.Color.Dark_Grey:SetFrench("Gris Foncé")

	-- Castbar Action Dictionary
	KBM.Language.CastBar = {}
	KBMLM.SetGroupObject(KBM.Language.CastBar, "GroupObject", "Castbar Action")
	KBM.Language.CastBar.Interrupt = KBM.Language:Add("Interrupted")
	KBM.Language.CastBar.Interrupt:SetGerman("Unterbrochen")
	KBM.Language.CastBar.Interrupt:SetFrench("Interrompu")
	KBM.Language.CastBar.Interrupt:SetRussian("Прерван")
	KBM.Language.CastBar.Interrupt:SetKorean("방해받음")
	KBM.Language.CastBar.Player = KBM.Language:Add("Enable player Castbar")
	KBM.Language.CastBar.Player:SetFrench("Activer Barre-cast Joueur")
	KBM.Language.CastBar.Player:SetGerman("Aktiviere Spieler Zauberbalken")
	KBM.Language.CastBar.Player:SetKorean("플레이어 캐스터바 사용")
	KBM.Language.CastBar.Mimic = KBM.Language:Add("Mimic Rift's player castbar position")
	KBM.Language.CastBar.Mimic:SetFrench("Imiter la position Barre-cast Joueur")
	KBM.Language.CastBar.Mimic:SetGerman("Benutze Rift's Spieler Zauberbalken Position")
	KBM.Language.CastBar.Mimic:SetKorean("플레이어 캐스터바 위치에 올려놓기")

	-- Cast-bar related options
	KBM.Language.Options = {}
	KBMLM.SetGroupObject(KBM.Language.Options, "GroupObject", "General and Main options")
	KBM.Language.Options.CastbarOverride = KBM.Language:Add("Castbar: Override")
	KBM.Language.Options.CastbarOverride:SetGerman("separate Einstellungen")
	KBM.Language.Options.CastbarOverride:SetFrench("Barre-cast: Substituer")
	KBM.Language.Options.CastbarOverride:SetRussian("Кастбар: Переопределить")
	KBM.Language.Options.CastbarOverride:SetKorean("캐스트 바 : 오버라이드")
	KBM.Language.Options.Pinned = KBM.Language:Add("Pin to ")
	KBM.Language.Options.Pinned:SetGerman("Anheften an ")
	KBM.Language.Options.Pinned:SetFrench("Pin à ")
	KBM.Language.Options.Pinned:SetRussian("Привязать к ")
	KBM.Language.Options.Pinned:SetKorean("고정 위치 ")
	KBM.Language.Options.FiltersEnabled = KBM.Language:Add("Enable cast filters")
	KBM.Language.Options.FiltersEnabled:SetGerman("Aktiviere Zauber Filter")
	KBM.Language.Options.FiltersEnabled:SetFrench("Activer filtres cast")
	KBM.Language.Options.FiltersEnabled:SetRussian("Включить фильтры кастбара")
	KBM.Language.Options.FiltersEnabled:SetKorean("캐스트 필터 적용")
	KBM.Language.Options.Castbar = KBM.Language:Add("Cast-bars")
	KBM.Language.Options.Castbar:SetFrench("Barres-cast")
	KBM.Language.Options.Castbar:SetGerman("Zauberbalken")
	KBM.Language.Options.Castbar:SetRussian("Кастбары")
	KBM.Language.Options.Castbar:SetKorean("캐스터 바")
	KBM.Language.Options.CastbarEnabled = KBM.Language:Add("Cast-bars enabled")
	KBM.Language.Options.CastbarEnabled:SetFrench("Barres-cast activé")
	KBM.Language.Options.CastbarEnabled:SetGerman("Zauberbalken anzeigen")
	KBM.Language.Options.CastbarEnabled:SetRussian("Включить кастбары")
	KBM.Language.Options.CastbarEnabled:SetKorean("캐스터-바 적용")
	KBM.Language.Options.CastbarStyle = KBM.Language:Add("Use Rift style cast-bars")
	KBM.Language.Options.CastbarStyle:SetFrench("Utiliser style Barres-casts de Rift")
	KBM.Language.Options.CastbarStyle:SetGerman("Benutze Rift-Style Zauberbalken")
	KBM.Language.Options.CastbarStyle:SetKorean("리프트 스타일 캐스터바 사용")

	-- MechSpy Options
	KBM.Language.MechSpy = {}
	KBMLM.SetGroupObject(KBM.Language.MechSpy, "GroupObject", "Mechanic Spy dictionary")
	KBM.Language.MechSpy.Name = KBM.Language:Add("Mechanic Spy")
	KBM.Language.MechSpy.Name:SetGerman("Mechanik Spion")
	KBM.Language.MechSpy.Name:SetFrench("Espion de Mécanisme")
	KBM.Language.MechSpy.Name:SetRussian("Подсказки механики")
	KBM.Language.MechSpy.Name:SetKorean("메카닉 스파이")
	KBM.Language.MechSpy.Enabled = KBM.Language:Add("Mechanic Spy Enabled")
	KBM.Language.MechSpy.Enabled:SetGerman("Mechanik Spion anzeigen")
	KBM.Language.MechSpy.Enabled:SetFrench("Espion de Mécanisme Activé")
	KBM.Language.MechSpy.Enabled:SetRussian("Включить подсказки механики")
	KBM.Language.MechSpy.Enabled:SetKorean("메카닉 스파이 적용")
	KBM.Language.MechSpy.Show = KBM.Language:Add("Always show Mechanic Headers")
	KBM.Language.MechSpy.Show:SetGerman("Mechanik Spion Kopfzeilen immer zeigen")
	KBM.Language.MechSpy.Show:SetFrench("Toujours montrer En-tête Mécanisme")
	KBM.Language.MechSpy.Show:SetRussian("Всегда показывать заголовки механики")
	KBM.Language.MechSpy.Show:SetKorean("메카닉 헤더 항상키기")
	KBM.Language.MechSpy.Override = KBM.Language:Add("Mechanic Spy: Override")
	KBM.Language.MechSpy.Override:SetGerman("separate Mechanik Spion Einstellungen")
	KBM.Language.MechSpy.Override:SetFrench("Espion de Mécanisme: Substituer")
	KBM.Language.MechSpy.Override:SetRussian("Подсказки механики: Переопределить")
	KBM.Language.MechSpy.Override:SetKorean("메카닉 스파이: 오버라이드")
	
	-- Timer Options
	KBM.Language.Options.MechTimerOverride = KBM.Language:Add("Mechanic Timers: Override")
	KBM.Language.Options.MechTimerOverride:SetGerman("separate Mechanik Timer Einstellungen")
	KBM.Language.Options.MechTimerOverride:SetRussian("Таймеры механики: Переопределить")
	KBM.Language.Options.MechTimerOverride:SetFrench("Minuteries de Mécanisme: Substituer")
	KBM.Language.Options.MechTimerOverride:SetKorean("메카닉 타이머: 오버라이드")
	KBM.Language.Options.EncTimerOverride = KBM.Language:Add("Encounter Timer: Override")
	KBM.Language.Options.EncTimerOverride:SetGerman("separate Boss Timer: Einstellungen")
	KBM.Language.Options.EncTimerOverride:SetRussian("Таймер боя: Переопределить")
	KBM.Language.Options.EncTimerOverride:SetFrench("Minuteries combat: Substituer")
	KBM.Language.Options.EncTimerOverride:SetKorean("인카운트 타이머: 오버라이드")
	KBM.Language.Options.EncTimers = KBM.Language:Add("Encounter Timers enabled")
	KBM.Language.Options.EncTimers:SetGerman("Boss Timer anzeigen")
	KBM.Language.Options.EncTimers:SetRussian("Включить Таймеры боя")
	KBM.Language.Options.EncTimers:SetFrench("Timers combat activé")
	KBM.Language.Options.EncTimers:SetKorean("인카운트 타임 적용")
	KBM.Language.Options.MechanicTimers = KBM.Language:Add("Mechanic Timers enabled")
	KBM.Language.Options.MechanicTimers:SetFrench("Minuteries de Mécanisme")
	KBM.Language.Options.MechanicTimers:SetGerman("Mechanik Timer")
	KBM.Language.Options.MechanicTimers:SetRussian("Включить Таймеры механики")
	KBM.Language.Options.MechanicTimers:SetKorean("메카닉 타이머 적용")
	KBM.Language.Options.TimersEnabled = KBM.Language:Add("Timers enabled")
	KBM.Language.Options.TimersEnabled:SetFrench("Minuteries activé")
	KBM.Language.Options.TimersEnabled:SetGerman("Timer anzeigen")
	KBM.Language.Options.TimersEnabled:SetRussian("Включить Таймер")
	KBM.Language.Options.TimersEnabled:SetKorean("타이머 사용")
	KBM.Language.Options.ShowTimer = KBM.Language:Add("Show Timer (for positioning)")
	KBM.Language.Options.ShowTimer:SetFrench("Montrer Minuterie (pour positionnement)")
	KBM.Language.Options.ShowTimer:SetGerman("Zeige Timer (für Positionierung)")
	KBM.Language.Options.ShowTimer:SetRussian("Показать таймер (для позиционирования)")
	KBM.Language.Options.ShowTimer:SetKorean("타이머 보여주기 (for positioning)")
	KBM.Language.Options.LockTimer = KBM.Language:Add("Unlock Timer")
	KBM.Language.Options.LockTimer:SetFrench("D\195\169bloquer Minuterie")
	KBM.Language.Options.LockTimer:SetGerman("Timer ist verschiebbar")
	KBM.Language.Options.LockTimer:SetRussian("Разблокировать таймер")
	KBM.Language.Options.LockTimer:SetKorean("타이머 해제")
	KBM.Language.Options.Timer = KBM.Language:Add("Encounter duration Timer")
	KBM.Language.Options.Timer:SetFrench("Minuterie durée combat")
	KBM.Language.Options.Timer:SetGerman("Kampfdauer Anzeige")
	KBM.Language.Options.Timer:SetRussian("Таймер продолжительности боя")
	KBM.Language.Options.Timer:SetKorean("인카운터 지속 타이머")
	KBM.Language.Options.Enrage = KBM.Language:Add("Enrage Timer (if supported)")
	KBM.Language.Options.Enrage:SetFrench("Minuterie d'Enrage (si supporté)")
	KBM.Language.Options.Enrage:SetGerman("Enrage Anzeige (wenn unterstützt)")
	KBM.Language.Options.Enrage:SetRussian("Энрейдж Таймер (если поддерживается)")
	KBM.Language.Options.Enrage:SetKorean("격노 타임 (지원가능시)")

	-- Anchors Options
	KBM.Language.Options.ShowAnchor = KBM.Language:Add("Show anchor (for positioning)")
	KBM.Language.Options.ShowAnchor:SetFrench("Montrer ancrage (pour positionnement)")
	KBM.Language.Options.ShowAnchor:SetGerman("Zeige Anker (für Positionierung)")
	KBM.Language.Options.ShowAnchor:SetRussian("Показать якорь (для позиционирования)")
	KBM.Language.Options.ShowAnchor:SetKorean("앵커 적용 (위치조정)")
	KBM.Language.Options.LockAnchor = KBM.Language:Add("Unlock anchor")
	KBM.Language.Options.LockAnchor:SetFrench("Débloquer Ancrage")
	KBM.Language.Options.LockAnchor:SetGerman("Anker ist verschiebbar")
	KBM.Language.Options.LockAnchor:SetRussian("Разблокировать якорь")
	KBM.Language.Options.LockAnchor:SetKorean("앵커 잠금해제")
	
	-- Anchor Text
	KBM.Language.Anchors = {}
	KBMLM.SetGroupObject(KBM.Language.Anchors, "GroupObject", "All anchor text")
	KBM.Language.Anchors.MechSpy = KBM.Language:Add("Mechanic Spy Anchor")
	KBM.Language.Anchors.MechSpy:SetGerman("Mechanik Spion Anker")
	KBM.Language.Anchors.MechSpy:SetFrench("Ancrage Espion de Mécanisme")
	KBM.Language.Anchors.MechSpy:SetKorean("메카닉 추적 고정핀")
	KBM.Language.Anchors.Timers = KBM.Language:Add("Timer Anchor")
	KBM.Language.Anchors.Timers:SetGerman("Timer Anker")
	KBM.Language.Anchors.Timers:SetFrench("Ancrage Minuterie")
	KBM.Language.Anchors.Timers:SetKorean("타이머 고정핀")
	KBM.Language.Anchors.TankSwap = KBM.Language:Add("Tank-Swap Anchor")
	KBM.Language.Anchors.TankSwap:SetGerman("Tank Wechsel Anker")
	KBM.Language.Anchors.TankSwap:SetFrench("Ancrage Tank-Swap")
	KBM.Language.Anchors.TankSwap:SetKorean("탱크스왑 고정핀")
	KBM.Language.Anchors.Phases = KBM.Language:Add("Phases & Objectives")
	KBM.Language.Anchors.Phases:SetGerman("Phasen Monitor Anker")
	KBM.Language.Anchors.Phases:SetFrench("Phases & Objectifs")
	KBM.Language.Anchors.Phases:SetKorean("단계 & 사물")
	KBM.Language.Anchors.Castbars = KBM.Language:Add("Global Castbar")
	KBM.Language.Anchors.Castbars:SetGerman("Zauberbalken Anker")
	KBM.Language.Anchors.Castbars:SetFrench("Barre-cast Globale")
	KBM.Language.Anchors.Castbars:SetKorean("글로벌 캐스트바")
	KBM.Language.Anchors.AlertText = KBM.Language:Add(" Alert Anchor ")
	KBM.Language.Anchors.AlertText:SetGerman(" Alarmierungs Anker ")
	KBM.Language.Anchors.AlertText:SetFrench(" Ancrage Alerte ")
	KBM.Language.Anchors.AlertText:SetKorean(" 경고 고정핀 ")

	-- Phase Monitor
	KBM.Language.Options.PhaseMonOverride = KBM.Language:Add("Phase Monitor: Override")
	KBM.Language.Options.PhaseMonOverride:SetGerman("separate Phasen Monitor: Einstellungen")
	KBM.Language.Options.PhaseMonOverride:SetFrench("Moniteur Phase: Substituer")
	KBM.Language.Options.PhaseMonOverride:SetRussian("Монитор фаз: Переопределить")
	KBM.Language.Options.PhaseMonOverride:SetKorean("단계 모니터: 오버라이드")
	KBM.Language.Options.PhaseMonitor = KBM.Language:Add("Phase Monitor")
	KBM.Language.Options.PhaseMonitor:SetGerman("Phasen Monitor")
	KBM.Language.Options.PhaseMonitor:SetRussian("Монитор фаз")
	KBM.Language.Options.PhaseMonitor:SetFrench("Moniteur Phase")
	KBM.Language.Options.PhaseMonitor:SetKorean("단계 모니터링")
	KBM.Language.Options.PhaseEnabled = KBM.Language:Add("Enable Phase Monitor")
	KBM.Language.Options.PhaseEnabled:SetGerman("Phasen Monitor anzeigen")
	KBM.Language.Options.PhaseEnabled:SetRussian("Включить Монитор фаз")
	KBM.Language.Options.PhaseEnabled:SetFrench("Activer Moniteur Phase")
	KBM.Language.Options.PhaseEnabled:SetKorean("단계 모니터 사용")
	KBM.Language.Options.Phases = KBM.Language:Add("Display current Phase")
	KBM.Language.Options.Phases:SetGerman("Zeige aktuelle Phase an")
	KBM.Language.Options.Phases:SetRussian("Показывать текущую фазу")
	KBM.Language.Options.Phases:SetFrench("Afficher Phase courante")
	KBM.Language.Options.Phases:SetKorean("현재 단계 표시")
	KBM.Language.Options.Objectives = KBM.Language:Add("Display Phase objective tracking")
	KBM.Language.Options.Objectives:SetGerman("Zeige Phasen Aufgabe an")
	KBM.Language.Options.Objectives:SetRussian("Показывать цели фазы")
	KBM.Language.Options.Objectives:SetFrench("Afficher objectifs de Phase")
	KBM.Language.Options.Objectives:SetKorean("단계 오브젝트 추적 표시")
	KBM.Language.Options.Phase = KBM.Language:Add("Phase")
	KBM.Language.Options.Phase:SetGerman("Phase")
	KBM.Language.Options.Phase:SetFrench("Phase")
	KBM.Language.Options.Phase:SetRussian("Фаза")
	KBM.Language.Options.Phase:SetKorean("단계")
	KBM.Language.Options.Single = KBM.Language:Add("Single")
	KBM.Language.Options.Single:SetGerman("Einzel")
	KBM.Language.Options.Single:SetFrench("Simple")
	KBM.Language.Options.Single:SetRussian("Одна")
	KBM.Language.Options.Single:SetKorean("싱글")
	KBM.Language.Options.Ground = KBM.Language:Add("Ground")
	KBM.Language.Options.Ground:SetGerman("Boden")
	KBM.Language.Options.Ground:SetFrench("Sol")
	KBM.Language.Options.Ground:SetRussian("Земля")
	KBM.Language.Options.Ground:SetKorean("바닥")
	KBM.Language.Options.Air = KBM.Language:Add("Air")
	KBM.Language.Options.Air:SetGerman("Flug")
	KBM.Language.Options.Air:SetFrench("Air")
	KBM.Language.Options.Air:SetRussian("Воздух")
	KBM.Language.Options.Air:SetKorean("공중")
	KBM.Language.Options.Final = KBM.Language:Add("Final")
	KBM.Language.Options.Final:SetGerman("Letzte")
	KBM.Language.Options.Final:SetFrench("Final")
	KBM.Language.Options.Final:SetRussian("Финальная")
	KBM.Language.Options.Final:SetKorean("마지막")
	KBM.Language.Options.Dead = KBM.Language:Add("Dead")
	KBM.Language.Options.Dead:SetGerman("Tot")
	KBM.Language.Options.Dead:SetFrench("Mort")
	KBM.Language.Options.Dead:SetRussian("Мертвый")
	KBM.Language.Options.Dead:SetKorean("죽음")

	-- Button Options
	KBM.Language.Options.Button = KBM.Language:Add("Options Button Visible")
	KBM.Language.Options.Button:SetFrench("Bouton Configurations Visible")
	KBM.Language.Options.Button:SetGerman("Options-Schalter sichtbar")
	KBM.Language.Options.Button:SetRussian("Отображать кнопку настроек")
	KBM.Language.Options.Button:SetKorean("옵션 버튼 보이기")
	KBM.Language.Options.LockButton = KBM.Language:Add("Unlock Button (right-click to move)")
	KBM.Language.Options.LockButton:SetFrench("Débloquer Bouton (click-droit pour déplacer)")
	KBM.Language.Options.LockButton:SetGerman("Schalter ist verschiebbar (Rechts-Klick zum verschieben)")
	KBM.Language.Options.LockButton:SetRussian("Разблокировать кнопку (правый клик для перемещения)")
	KBM.Language.Options.LockButton:SetKorean("버튼 잠금해제 (우클릭으로 이동가능)")

	-- Tank Swap related
	KBM.Language.Options.TankSwap = KBM.Language:Add("Tank-Swaps")
	KBM.Language.Options.TankSwap:SetFrench("Tank-Swaps")
	KBM.Language.Options.TankSwap:SetGerman("Tank Wechsel")
	KBM.Language.Options.TankSwap:SetRussian("Смена Танков")
	KBM.Language.Options.TankSwap:SetKorean("탱크 스왑")
	KBM.Language.Options.Tank = KBM.Language:Add("Show Test Tanks")
	KBM.Language.Options.Tank:SetFrench("Afficher Test Tanks")
	KBM.Language.Options.Tank:SetGerman("Zeige Test-Tanks-Fenster")
	KBM.Language.Options.Tank:SetRussian("Показать тестовых танков")
	KBM.Language.Options.Tank:SetKorean("테스트 탱커들 표시")
	KBM.Language.Options.TankSwapEnabled = KBM.Language:Add("Tank-Swaps enabled")
	KBM.Language.Options.TankSwapEnabled:SetGerman("Tank Wechsel anzeigen")
	KBM.Language.Options.TankSwapEnabled:SetRussian("Включить Смену танков")
	KBM.Language.Options.TankSwapEnabled:SetFrench("Tank-Swaps activé")
	KBM.Language.Options.TankSwapEnabled:SetKorean("탱커스왑 적용")

	-- Alert related
	KBM.Language.Options.AlertsOverride = KBM.Language:Add("Alerts: Override")
	KBM.Language.Options.AlertsOverride:SetGerman("separate Einstellungen")
	KBM.Language.Options.AlertsOverride:SetFrench("Alertes: Substituer")
	KBM.Language.Options.AlertsOverride:SetRussian("Предупреждения: Переопределить")
	KBM.Language.Options.AlertsOverride:SetKorean("경고 : 오버라이드")
	KBM.Language.Options.Alert = KBM.Language:Add("Screen Alerts")
	KBM.Language.Options.Alert:SetGerman("Alarmierungen")
	KBM.Language.Options.Alert:SetFrench("Alerte à l'écran")
	KBM.Language.Options.Alert:SetRussian("Предупреждения на экране")
	KBM.Language.Options.Alert:SetKorean("화면 경고")
	KBM.Language.Options.AlertsEnabled = KBM.Language:Add("Screen Alerts enabled")
	KBM.Language.Options.AlertsEnabled:SetGerman("Alarmierungen aktiviert")
	KBM.Language.Options.AlertsEnabled:SetFrench("Alerte à l'écran activé")
	KBM.Language.Options.AlertsEnabled:SetRussian("Отображать предупреждения на экране")
	KBM.Language.Options.AlertsEnabled:SetKorean("화면 경보 적용")
	KBM.Language.Options.AlertFlash = KBM.Language:Add("Screen flash enabled")
	KBM.Language.Options.AlertFlash:SetGerman("Bildschirm-Rand Flackern aktiviert")
	KBM.Language.Options.AlertFlash:SetFrench("Flash écran activé")
	KBM.Language.Options.AlertFlash:SetRussian("Включить Мигание экрана")
	KBM.Language.Options.AlertFlash:SetKorean("화면깜박임 적용")
	KBM.Language.Options.AlertText = KBM.Language:Add("Alert warning text enabled")
	KBM.Language.Options.AlertText:SetGerman("Alarmierungs-Text aktiviert")
	KBM.Language.Options.AlertText:SetFrench("Texte Avertissement Alerte activé")
	KBM.Language.Options.AlertText:SetRussian("Включить Текст предупреждения")
	KBM.Language.Options.AlertText:SetKorean("경고 텍스트 적용")
	KBM.Language.Options.AlertVert = KBM.Language:Add("Enable vertical alert bars")
	KBM.Language.Options.AlertVert:SetGerman("Vertikale Alarmierungsbalken anzeigen")
	KBM.Language.Options.AlertVert:SetFrench("Activer barres d'alertes verticales")
	KBM.Language.Options.AlertVert:SetRussian("Включить вертикальные полосы для предупреждения")
	KBM.Language.Options.AlertVert:SetKorean("수직 경고바 적용")
	KBM.Language.Options.AlertVertShort = KBM.Language:Add("Vertical bars")
	KBM.Language.Options.AlertVertShort:SetGerman("Vertikale Balken")
	KBM.Language.Options.AlertVertShort:SetFrench("Barres Verticales")
	KBM.Language.Options.AlertVertShort:SetRussian("Вертикальные полосы")
	KBM.Language.Options.AlertVertShort:SetKorean("수직바")
	KBM.Language.Options.AlertHorz = KBM.Language:Add("Enable horizontal alert bars")
	KBM.Language.Options.AlertHorz:SetGerman("Horizontale Alarmierungsbalken anzeigen")
	KBM.Language.Options.AlertHorz:SetFrench("Activer barres d'alertes horizontales")
	KBM.Language.Options.AlertHorz:SetRussian("Включить горизонтальные полосы для предупреждения")
	KBM.Language.Options.AlertHorz:SetKorean("수직 경고바 적용")
	KBM.Language.Options.AlertHorzShort = KBM.Language:Add("Horizontal bars")
	KBM.Language.Options.AlertHorzShort:SetGerman("Horizontale Balken")
	KBM.Language.Options.AlertHorzShort:SetFrench("Barres Horizontales")
	KBM.Language.Options.AlertHorzShort:SetRussian("Горизонтальные полосы")
	KBM.Language.Options.AlertHorzShort:SetKorean("수직 바")
	KBM.Language.Options.UnlockFlash = KBM.Language:Add("Unlock alert border for scaling")
	KBM.Language.Options.UnlockFlash:SetGerman("Alarmierungs Ränder sind änderbar.")
	KBM.Language.Options.UnlockFlash:SetRussian("Разблокировать рамку предупреждения")
	KBM.Language.Options.UnlockFlash:SetFrench("Débloquer bordure alerte pour ajustement")
	KBM.Language.Options.UnlockFlash:SetKorean("크기 변경을 위해 경고 테두리 잠금해제")
	KBM.Language.Options.Border = KBM.Language:Add("Enable Border")
	KBM.Language.Options.Border:SetGerman("Ränder aktivieren")
	KBM.Language.Options.Border:SetFrench("Activer Bordure")
	KBM.Language.Options.Border:SetRussian("Показать рамку")
	KBM.Language.Options.Border:SetKorean("둘레 적용")
	KBM.Language.Options.Notify = KBM.Language:Add("Enable Text")
	KBM.Language.Options.Notify:SetGerman("Text aktivieren")
	KBM.Language.Options.Notify:SetRussian("Показать текст")
	KBM.Language.Options.Notify:SetFrench("Activer Texte")
	KBM.Language.Options.Notify:SetKorean("텍스트 사용가능")
	KBM.Language.Options.Sound = KBM.Language:Add("Play Sound")
	KBM.Language.Options.Sound:SetGerman("Sound abspielen")
	KBM.Language.Options.Sound:SetRussian("Играть звук")
	KBM.Language.Options.Sound:SetFrench("Jouer Son")
	KBM.Language.Options.Sound:SetKorean("사운드 작동")
	
	-- Size Dictionary
	KBM.Language.Options.UnlockWidth = KBM.Language:Add("Unlock width for scaling (Mouse wheel)")
	KBM.Language.Options.UnlockWidth:SetGerman("Breite ist skalierbar")
	KBM.Language.Options.UnlockWidth:SetRussian("Разблокировать ширину (колесо мыши)")
	KBM.Language.Options.UnlockWidth:SetFrench("Débloquer largeur pour ajustement (Molette souris)")
	KBM.Language.Options.UnlockWidth:SetKorean("크기 조정을 위한 넓이 조정 (마우스휠 이용)")
	KBM.Language.Options.UnlockHeight = KBM.Language:Add("Unlock height for scaling (Mouse wheel)")
	KBM.Language.Options.UnlockHeight:SetGerman("Höhe ist skalierbar")
	KBM.Language.Options.UnlockHeight:SetRussian("Разблокировать высоту (колесо мыши)")
	KBM.Language.Options.UnlockHeight:SetFrench("Débloquer hauteur pour ajustement (Molette souris)")
	KBM.Language.Options.UnlockHeight:SetKorean("높이 크기 잠금해제 (마우스 휠)")
	KBM.Language.Options.UnlockText = KBM.Language:Add("Unlock Text size (Mouse wheel)")
	KBM.Language.Options.UnlockText:SetGerman("Textgröße ist änderbar")
	KBM.Language.Options.UnlockText:SetRussian("Разблокировать размер текста (колесо мыши)")
	KBM.Language.Options.UnlockText:SetFrench("Débloquer Taille Texte (Molette Souris)")
	KBM.Language.Options.UnlockText:SetKorean("텍스트 사이즈 잠금해제 (마우스 휠로)")
	KBM.Language.Options.UnlockAlpha = KBM.Language:Add("Unlock transparency")
	KBM.Language.Options.UnlockAlpha:SetGerman("Transparenz ist änderbar")
	KBM.Language.Options.UnlockAlpha:SetRussian("Разблокировать прозрачность")
	KBM.Language.Options.UnlockAlpha:SetFrench("Débloquer transparence")
	KBM.Language.Options.UnlockAlpha:SetKorean("투명도 잠금해제")

	-- Main Options Dictionary
	KBM.Language.Menu = {}
	KBMLM.SetGroupObject(KBM.Language.Menu, "GroupObject", "Menu related dictionary")
	KBM.Language.Menu.Global = KBM.Language:Add("Global Options")
	KBM.Language.Menu.Global:SetGerman("Globale Einstellungen")
	KBM.Language.Menu.Global:SetFrench("Options Globales")
	KBM.Language.Menu.Global:SetRussian("Общие настройки")
	KBM.Language.Menu.Global:SetKorean("글로벌 옵션")
	KBM.Language.Menu.Timers = KBM.Language:Add("Timers")
	KBM.Language.Menu.Timers:SetGerman("Timer")
	KBM.Language.Menu.Timers:SetFrench("Minuteries")
	KBM.Language.Menu.Timers:SetRussian("Таймеры")
	KBM.Language.Menu.Timers:SetKorean("타이머")
	KBM.Language.Menu.Enable = KBM.Language:Add("Enable")
	KBM.Language.Menu.Enable:SetGerman("Aktiviere")
	KBM.Language.Menu.Enable:SetFrench("Activer")
	KBM.Language.Menu.Enable:SetRussian("Включить")
	KBM.Language.Menu.Enable:SetKorean("사용")
	KBM.Language.Menu.Filters = KBM.Language:Add("filters")
	KBM.Language.Menu.Filters:SetGerman("Filter")
	KBM.Language.Menu.Filters:SetFrench("Filtres")
	KBM.Language.Menu.Filters:SetRussian("фильтры")
	KBM.Language.Menu.Filters:SetKorean("필터")
	KBM.Language.Menu.Castbars = KBM.Language:Add("cast-bars")
	KBM.Language.Menu.Castbars:SetFrench("barres-cast")
	KBM.Language.Menu.Castbars:SetGerman("Zauberbalken")
	KBM.Language.Menu.Castbars:SetRussian("кастбары")
	KBM.Language.Menu.Castbars:SetKorean("캐스터바")
	
	-- Filter Options
	KBM.Language.Filters = {}
	KBMLM.SetGroupObject(KBM.Language.Filters, "GroupObject", "Filter related dictionary")
	KBM.Language.Filters.EnableBoss = KBM.Language:Add("Enable %s's filters")
	KBM.Language.Filters.EnableBoss:SetFrench("Filtres sur %s Activé")
	KBM.Language.Filters.EnableBoss:SetGerman("Aktiviere %s's Filter")
	KBM.Language.Filters.EnableBoss:SetRussian("%s: включить фильтры")
	KBM.Language.Filters.EnableBoss:SetKorean("%s'의 필터 적용")
	
	-- Misc.
	KBM.Language.Options.Title = KBM.Language:Add("King Boss Mods: Options")
	KBM.Language.Options.Title:SetGerman("King Boss Mods: Konfiguration") 
	KBM.Language.Options.Title:SetFrench("King Boss Mods: Configurations")
	KBM.Language.Options.Title:SetRussian("King Boss Mods: Настройки")
	KBM.Language.Options.Title:SetKorean("킹 보스 모드 : 옵션")
	KBM.Language.Options.Character = KBM.Language:Add("Saving settings for this character only")
	KBM.Language.Options.Character:SetGerman("Einstellungen nur für diesen Charakter speichern")
	KBM.Language.Options.Character:SetFrench("Sauvegarder paramètre pour ce personnage uniquement")
	KBM.Language.Options.Character:SetRussian("Сохранить настройки только для этого персонажа")
	KBM.Language.Options.Character:SetKorean("이 캐릭터에 한해서 설정저장")
	KBM.Language.Options.ModEnabled = KBM.Language:Add("Enable King Boss Mods v"..KBMLM.KBMAddonData.toc.Version)
	KBM.Language.Options.ModEnabled:SetGerman("Aktiviere King Boss Mods v"..KBMLM.KBMAddonData.toc.Version)
	KBM.Language.Options.ModEnabled:SetRussian("Активировать King Boss Mods v"..KBMLM.KBMAddonData.toc.Version)
	KBM.Language.Options.ModEnabled:SetFrench("Activer King Boss Mods v"..KBMLM.KBMAddonData.toc.Version)
	KBM.Language.Options.ModEnabled:SetKorean("킹보스 모드 v"..KBMLM.KBMAddonData.toc.Version.." 사용")
	KBM.Language.Options.Enabled = KBM.Language:Add("Enabled")
	KBM.Language.Options.Enabled:SetGerman("Aktiviert")
	KBM.Language.Options.Enabled:SetRussian("Активировать")
	KBM.Language.Options.Enabled:SetFrench("Activé")
	KBM.Language.Options.Enabled:SetKorean("사용가능")
	KBM.Language.Options.Settings = KBM.Language:Add("Settings")
	KBM.Language.Options.Settings:SetFrench("Configurations")
	KBM.Language.Options.Settings:SetGerman("Einstellungen")
	KBM.Language.Options.Settings:SetRussian("Настройки")
	KBM.Language.Options.Settings:SetKorean("설정")
	KBM.Language.Options.Shadow = KBM.Language:Add("Show text shadows")
	KBM.Language.Options.Shadow:SetGerman("Zeige Text Schattierung")
	KBM.Language.Options.Shadow:SetRussian("Отображать тень текста")
	KBM.Language.Options.Shadow:SetFrench("Montrer ombre texte")
	KBM.Language.Options.Shadow:SetKorean("텍스트 그림자 보여주기")
	KBM.Language.Options.Texture = KBM.Language:Add("Enable textured overlay")
	KBM.Language.Options.Texture:SetGerman("Texturierte Balken aktiviert")
	KBM.Language.Options.Texture:SetRussian("Включить функцию наложения текстур")
	KBM.Language.Options.Texture:SetFrench("Activer overlay textures")
	KBM.Language.Options.Texture:SetKorean("텍스쳐 오버레이 적용")

	-- Timer Dictionary
	KBM.Language.Timers = {}
	KBMLM.SetGroupObject(KBM.Language.Timers, "GroupObject", "Timer related")	
	KBM.Language.Timers.Time = KBM.Language:Add("Time")
	KBM.Language.Timers.Time:SetFrench("Durée")
	KBM.Language.Timers.Time:SetGerman("Zeit")
	KBM.Language.Timers.Time:SetRussian("Время")
	KBM.Language.Timers.Time:SetKorean("시간")
	KBM.Language.Timers.Enrage = KBM.Language:Add("Enrage in")
	KBM.Language.Timers.Enrage:SetGerman("Enrage in")
	KBM.Language.Timers.Enrage:SetFrench("Enrage dans")
	KBM.Language.Timers.Enrage:SetRussian("Энрейдж через")
	KBM.Language.Timers.Enrage:SetKorean("격노까지 남은시간 ")
	KBM.Language.Timers.Enraged = KBM.Language:Add("!! Enraged !!")
	KBM.Language.Timers.Enraged:SetGerman()
	KBM.Language.Timers.Enraged:SetFrench("!! Enragé !!")
	KBM.Language.Timers.Enraged:SetKorean("!! 격노 !!")

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
	KBMLM.KBMAddonData = Inspect.Addon.Detail("KingMolinator")
	KBMLM.SetMain_Lang()
	KBM.LocaleManager = KBMLM
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