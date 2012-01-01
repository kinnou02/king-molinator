-- King Boss Mods
-- Written By Paul Snart
-- Copyright 2011

KBM_GlobalOptions = nil
chKBM_GlobalOptions = nil

local KingMol_Main = {}
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.BossMod = {}
KBM.Lang = Inspect.System.Language()
KBM.Player = {}
KBM.Language = {}
KBM.ID = "KingMolinator"
KBM.ModList = {}
KBM.Testing = false
KBM.Debug = false
KBM.TestFilters = {}
KBM.Idle = {
	Until = 0,
	Duration = 5,
	Wait = false,
	Combat = {
		Until = 0,
		Duration = 3,
		Wait = false,
		StoreTime = 0,
	},
	Trigger = {
		Duration = 2, 
	}
}
KBM.MenuOptions = {
	Timers = {},
	CastBars = {},
	TankSwap = {},
	Alerts = {},
	Phases = {},
	Main = {},
	Enabled = true,
	Handler = nil,
	Options = nil,
	Name = "Options",
	ID = "Options",
}

KBM.Defaults = {}

function KBM.Defaults.EncTimer()
	local EncTimer = {
		Type = "EncTimer",
		Override = false,
		x = false,
		y = false,
		w = 150,
		h = 25,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Enabled = true,
		Unlocked = true,
		Visible = true,
		ScaleWidth = false,
		ScaleHeight = false,
		TextSize = 15,
		TextScale = false,
		Enrage = true,
		Duration = true,
	}
	return EncTimer
end

KBM.Defaults.CastFilter = {}
function KBM.Defaults.CastFilter.Create(Color)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		print("Warning: Color error for CastFilter.Create ("..Color..")")
		print("Color does not exist.")
	end
	local FilterObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Custom = false,
	}
	return FilterObj
end
function KBM.Defaults.CastFilter.Assign(BossObj)
	if BossObj.HasCastFilters then
		for ID, Data in pairs(BossObj.Settings.Filters) do
			if type(Data) == "table" then
				Data.ID = ID
			end
		end
		for Name, Data in pairs(BossObj.CastFilters) do
			if type(Data) == "table" then
				Data.Prefix = ""
			end
		end
	end
end

KBM.Defaults.TimerObj = {}
function KBM.Defaults.TimerObj.Create(Color)
	if not Color then
		Color = "blue"
	end
	if not KBM.Colors.List[Color] then
		error("Color error for TimerObj.Create ("..tostring(Color)..")\nColor Index does not exist.")
	end
	local TimerObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Custom = false,
	}
	return TimerObj
end
function KBM.Defaults.TimerObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.TimersRef) do
		if BossObj.Settings.TimersRef[ID] then
			Data.ID = ID
			Data.Enabled = BossObj.Settings.TimersRef[ID].Enabled
			Data.Settings = BossObj.Settings.TimersRef[ID]
			BossObj.Settings.TimersRef[ID].ID = ID
			if KBM.Colors.List[Data.Settings.Color] then
				if Data.Color.Custom then
					Data.Color = Data.Settings.Color
				end
			else
				print("TimerObj Assign Error: "..Data.ID)
				print("Color Index ("..Data.Settings.Color..") does not exist, ignoring settings.")
				print("For: "..BossObj.Name)
				Data.Settings.Color = Data.Color
			end
		else
			print("Warning: "..ID.." is undefined in TimersRef")
			print("for boss: "..BossObj.Name)
			print("---------------")
		end
	end
end	

KBM.Defaults.AlertObj = {}
function KBM.Defaults.AlertObj.Create(Color, OldData)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		print("Warning: Color error for AlertObj.Create ("..Color..")")
		print("Color Index does not exist, setting to Red")
		Color = "red"
	end
	if OldData ~= nil then
		error("Incorrect Format: AlertObj.Create.HasMenu no longer a setting")
	end
	local AlertObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Custom = false,
	}
	return AlertObj
end

function KBM.Defaults.AlertObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.AlertsRef) do
		if BossObj.Settings.AlertsRef[ID] then
			Data.ID = ID
			Data.Enabled = BossObj.Settings.AlertsRef[ID].Enabled
			Data.Settings = BossObj.Settings.AlertsRef[ID]
			if KBM.Colors.List[Data.Settings.Color] then
				if Data.Settings.Custom then
					Data.Color = Data.Settings.Color
				end
			else
				error(	"AlertObj Assign Error: "..Data.ID..
						"/nColor Index ("..Data.Settings.Color..") does not exist, ignoring settings."..
						"/nFor: "..BossObj.Name)
				Data.Settings.Color = Data.Color
			end
			BossObj.Settings.AlertsRef[ID].ID = ID
		else
			error(	"Warning: "..ID.." is undefined in AlertsRef"..
					"\nfor boss: "..BossObj.Name)
		end
	end
end


function KBM.Defaults.CastBar()
	local CastBar = {
		Override = false,
		x = false,
		y = false,
		w = 350,
		h = 32,
		Enabled = true,
		Shadow = true,
		Unlocked = true,
		Visible = true,
		ScaleWidth = false,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Shadow = true,
		Texture = true,
		TextureAlpha = 0.75,
		ScaleHeight = false,
		TextScale = false,
		TextSize = 18,
		Pinned = false,
		Color = "red",
		Custom = false,
		Type = "CastBar",
	}
	return CastBar
end

function KBM.Defaults.PhaseMon()
	local PhaseMon = {
		Override = false,
		x = false,
		y = false,
		w = 225,
		h = 50,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Enabled = true,
		Unlocked = true,
		Visible = true,
		ScaleWidth = false,
		ScaleHeight = false,
		TextSize = 14,
		TextScale = false,
		Objectives = true,
		PhaseDisplay = true,
		Type = "PhaseMon",
	}
	return PhaseMon
end

function KBM.Defaults.MechTimer()
	local MechTimer = {
		Override = false,
		x = false,
		y = false,
		w = 350,
		h = 32,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Enabled = true,
		Unlocked = true,
		Shadow = true,
		Texture = true,
		TextureAlpha = 0.75,
		Visible = true,
		ScaleWidth = false,
		ScaleHeight = false,
		TextSize = 16,
		TextScale = false,
		Custom = false,
		Color = "blue",
		Type = "MechTimer",
	}
	return MechTimer
end

function KBM.Defaults.Alerts()
	local Alerts = {
		Override = false,
		Enabled = true,
		Flash = true,
		Notify = true,
		Visible = false,
		Unlocked = false,
		FlashUnlocked = false,
		fScale = 1,
		x = false,
		y = false,
		Type = "Alerts",
	}
	return Alerts
end

local function KBM_DefineVars(AddonID)
	if AddonID == "KingMolinator" then
		KBM.Options = {
			Character = false,
			Enabled = true,
			Debug = false,
			Frame = {
				x = false,
				y = false,
			},
			Button = {
				x = false,
				y = false,
				Unlocked = true,
				Visible = true,
			},
			Alerts = KBM.Defaults.Alerts(),
			EncTimer = KBM.Defaults.EncTimer(),
			PhaseMon = KBM.Defaults.PhaseMon(),
			CastBar = KBM.Defaults.CastBar(),
			MechTimer = KBM.Defaults.MechTimer(),
			TankSwap = {
				x = false,
				y = false,
				w = 150,
				h = 40,
				wScale = 1,
				hScale = 1,
				ScaleWidth = false,
				ScaleHeight = false,
				TextScale = false,
				TextSize = 14,
				Enabled = true,
				Visible = true,
				Unlocked = true,
			},
			BestTimes = {
			},
		}
		KBM_GlobalOptions = KBM.Options
		chKBM_GlobalOptions = KBM.Options
		for _, Mod in ipairs(KBM.ModList) do
			Mod:InitVars()
		end
	end
end

function KBM.LoadTable(Source, Target)
	if type(Source) == "table" then
		for Setting, Value in pairs(Source) do
			if type(Value) == "table" then
				if Target[Setting] ~= nil then
					if type(Target[Setting]) == "table" then
						KBM.LoadTable(Value, Target[Setting])
					end
				end
			else
				if(Target[Setting]) ~= nil then
					if type(Target[Settings]) ~= "table" then
						Target[Setting] = Value
					end
				end
			end
		end
	end
end

local function KBM_LoadVars(AddonID)
	local TargetLoad = nil
	if AddonID == "KingMolinator" then
		if chKBM_GlobalOptions.Character then
			KBM.LoadTable(chKBM_GlobalOptions, KBM.Options)
		else
			KBM.LoadTable(KBM_GlobalOptions, KBM.Options)
		end		
				
		if KBM.Options.Character then
			chKBM_GlobalOptions = KBM.Options			
		else
			KBM_GlobalOptions = KBM.Options		
		end
		
		for _, Mod in ipairs(KBM.ModList) do
			Mod:LoadVars()
		end
		
		KBM.Debug = KBM.Options.Debug		
	end
end

local function KBM_SaveVars(AddonID)
	if AddonID == "KingMolinator" then
		if not KBM.Options.Character then
			KBM_GlobalOptions = KBM.Options
		else
			chKBM_GlobalOptions = KBM.Options
		end
		for _, Mod in ipairs(KBM.ModList) do
			Mod:SaveVars()
		end
	end
end

function KBM.ToAbilityID(num)
	return string.format("a%016X", num)
end

KBM.MenuGroup = {}
local KBM_Boss = {}
KBM.SubBoss = {}
KBM.BossID = {}
KBM.Encounter = false
KBM.HeaderList = {}
KBM.CurrentBoss = ""
KBM.CurrentMod = nil
local KBM_TestIsCasting = false
local KBM_TestAbility = nil

KBM.HeldTime = Inspect.Time.Real()
KBM.StartTime = 0
KBM.EnrageTime = 0
KBM.EnrageTimer = 0
KBM.TimeElapsed = 0
KBM.UpdateTime = 0
KBM.LastAction = 0
KBM.CastBar = {}
KBM.CastBar.List = {}

-- Addon Primary Context
KBM.Context = UI.CreateContext("KBM_Context")
local KM_Name = "King Boss Mods"

-- Addon KBM Primary Frames
KBM.MainWin = {
	Handle = {},
	Border = {},
	Content = {},
}

KBM.TimeVisual = {}
KBM.TimeVisual.String = "00"
KBM.TimeVisual.Seconds = 0
KBM.TimeVisual.Minutes = 0
KBM.TimeVisual.Hours = 0

KBM.FrameStore = {}
KBM.FrameQueue = {}
KBM.CheckStore = {}
KBM.CheckQueue = {}
KBM.SlideStore = {}
KBM.SlideQueue = {}
KBM.TextfStore = {}
KBM.TextfQueue = {}
KBM.TotalTexts = 0
KBM.TotalChecks = 0
KBM.TotalFrames = 0
KBM.TotalSliders = 0

KBM.MechTimer = {}
KBM.MechTimer.testTimerList = {}

KBM.TankSwap = {}
KBM.TankSwap.Triggers = {}

KBM.EncTimer = {}
KBM.Button = {}
KBM.PhaseMonitor = {}
KBM.Trigger = {}
KBM.Alert = {}

function KBM.Language:Add(Phrase)
	-- Main Dictionary Handler
	-- All Languages are filled with English versions, until updated.
	local SetPhrase = {}
	SetPhrase.English = Phrase
	SetPhrase.French = Phrase
	SetPhrase.German = Phrase
	SetPhrase.Russian = Phrase
	SetPhrase.Korean = Phrase
	SetPhrase.Translated = {}
	function SetPhrase:SetFrench(frPhrase)
		self.French = frPhrase
		self.Translated.French = true
	end
	function SetPhrase:SetGerman(gePhrase)
		self.German = gePhrase
		self.Translated.German = true
	end
	function SetPhrase:SetRussion(ruPhrase)
		self.Russian = ruPhrase
		self.Translated.Russian = true
	end
	KBM.Language[Phrase] = SetPhrase
	return KBM.Language[Phrase]
end

-- Main Addon Dictionary
-- Encounter related messages
KBM.Language.Encounter = {}
KBM.Language.Encounter.Start = KBM.Language:Add("Encounter started:")
KBM.Language.Encounter.Start.French = "Combat d\195\169but\195\169:"
KBM.Language.Encounter.Start.German = "Bosskampf gestartet:"
KBM.Language.Encounter.GLuck = KBM.Language:Add("Good luck!")
KBM.Language.Encounter.GLuck.French = "Bonne chance!"
KBM.Language.Encounter.GLuck.German = "Viel Erfolg!"
KBM.Language.Encounter.Wipe = KBM.Language:Add("Encounter ended, possible wipe.")
KBM.Language.Encounter.Wipe.French = "Combat termin\195\169, wipe possible."
KBM.Language.Encounter.Wipe.German = "Bosskampf beendet, möglicher Wipe."
KBM.Language.Encounter.Victory = KBM.Language:Add("Encounter Victory!")
KBM.Language.Encounter.Victory.French = "Victoire, On l'a tué!"
KBM.Language.Encounter.Victory.German = "Bosskampf erfolgreich!"
-- Colors
KBM.Language.Color = {}
KBM.Language.Color.Custom = KBM.Language:Add("Custom color.")
KBM.Language.Color.Custom.German = "eigene Farbauswahl."
KBM.Language.Color.Red = KBM.Language:Add("Red")
KBM.Language.Color.Red.German = "Rot"
KBM.Language.Color.Blue = KBM.Language:Add("Blue")
KBM.Language.Color.Dark_Green = KBM.Language:Add("Dark Green")
KBM.Language.Color.Dark_Green.German = "Dunkelgrün"
KBM.Language.Color.Yellow = KBM.Language:Add("Yellow")
KBM.Language.Color.Yellow.German = "Gelb"
KBM.Language.Color.Orange = KBM.Language:Add("Orange")
KBM.Language.Color.Orange.German = "Orange"
KBM.Language.Color.Purple = KBM.Language:Add("Purple")
KBM.Language.Color.Purple.German = "Lila"
-- Cast-bar related
KBM.Language.Options = {}
KBM.Language.Options.CastbarOverride = KBM.Language:Add("Castbar: Override")
KBM.Language.Options.CastbarOverride.German = "Zauberbalken: Einstellungen."
KBM.Language.Options.Pinned = KBM.Language:Add("Pin to ")
KBM.Language.Options.Pinned.German = "Anheften an "
KBM.Language.Options.FiltersEnabled = KBM.Language:Add("Enable cast filters")
KBM.Language.Options.FiltersEnabled.German = "Aktiviere Zauber Filter"
KBM.Language.Options.Castbar = KBM.Language:Add("Cast-bars")
KBM.Language.Options.Castbar.French = "Barres-cast"
KBM.Language.Options.Castbar.German = "Zauberbalken"
KBM.Language.Options.CastbarEnabled = KBM.Language:Add("Cast-bars enabled.")
KBM.Language.Options.CastbarEnabled.French = "Barres-cast activ\195\169."
KBM.Language.Options.CastbarEnabled.German = "Zauberbalken anzeigen."
-- Timer Options
KBM.Language.Options.MechTimerOverride = KBM.Language:Add("Mechanic Timers: Override.")
KBM.Language.Options.MechTimerOverride.German = "Mechanik Timer: Einstellungen."
KBM.Language.Options.EncTimerOverride = KBM.Language:Add("Encounter Timer: Override.")
KBM.Language.Options.EncTimerOverride.German = "Boss Timer: Einstellungen."
KBM.Language.Options.EncTimers = KBM.Language:Add("Encounter Timers enabled.")
KBM.Language.Options.EncTimers.German = "Boss Timer anzeigen."
KBM.Language.Options.MechanicTimers = KBM.Language:Add("Mechanic Timers enabled.")
KBM.Language.Options.MechanicTimers.French = "Timers de M\195\169canisme."
KBM.Language.Options.MechanicTimers.German = "Mechanik Timer."
KBM.Language.Options.TimersEnabled = KBM.Language:Add("Timers enabled.")
KBM.Language.Options.TimersEnabled.French = "Timers activ\195\169."
KBM.Language.Options.TimersEnabled.German = "Timer anzeigen."
KBM.Language.Options.ShowTimer = KBM.Language:Add("Show Timer (for positioning).")
KBM.Language.Options.ShowTimer.French = "Montrer Timer (pour positionnement)."
KBM.Language.Options.ShowTimer.German = "Zeige Timer (für Positionierung)."
KBM.Language.Options.LockTimer = KBM.Language:Add("Unlock Timer.")
KBM.Language.Options.LockTimer.French = "D\195\169bloquer Timer."
KBM.Language.Options.LockTimer.German = "Timer ist verschiebbar."
KBM.Language.Options.Timer = KBM.Language:Add("Encounter duration Timer.")
KBM.Language.Options.Timer.French = "Timer duration combat."
KBM.Language.Options.Timer.German = "Kampfdauer Anzeige."
KBM.Language.Options.Enrage = KBM.Language:Add("Enrage Timer (if supported).")
KBM.Language.Options.Enrage.French = "Timer d'Enrage (si support\195\169)."
KBM.Language.Options.Enrage.German = "Enrage Anzeige (wenn unterstützt)."
-- Anchors Options
KBM.Language.Options.ShowAnchor = KBM.Language:Add("Show anchor (for positioning).")
KBM.Language.Options.ShowAnchor.French = "Montrer ancrage (pour positionnement)."
KBM.Language.Options.ShowAnchor.German = "Zeige Anker (für Positionierung)."
KBM.Language.Options.LockAnchor = KBM.Language:Add("Unlock anchor.")
KBM.Language.Options.LockAnchor.French = "D\195\169bloquer Ancrage."
KBM.Language.Options.LockAnchor.German = "Anker ist verschiebbar."
-- Phase Monitor
KBM.Language.Options.PhaseMonOverride = KBM.Language:Add("Phase Monitor: Override.")
KBM.Language.Options.PhaseMonOverride.German = "Phasen Monitor: Einstellungen."
KBM.Language.Options.PhaseMonitor = KBM.Language:Add("Phase Monitor")
KBM.Language.Options.PhaseMonitor.German = "Phasen Monitor"
KBM.Language.Options.PhaseEnabled = KBM.Language:Add("Enable Phase Monitor.")
KBM.Language.Options.PhaseEnabled.German = "Phasen Monitor aktiviert."
KBM.Language.Options.Phases = KBM.Language:Add("Display current Phase.")
KBM.Language.Options.Phases.German = "Zeige aktuelle Phase an."
KBM.Language.Options.Objectives = KBM.Language:Add("Display Phase objective tracking.")
KBM.Language.Options.Objectives.German = "Zeige Phasen Aufgabe an."
KBM.Language.Options.Phase = KBM.Language:Add("Phase")
-- Button Options
KBM.Language.Options.Button = KBM.Language:Add("Options Button Visible.")
KBM.Language.Options.Button.French = "Bouton Configurations Visible."
KBM.Language.Options.Button.German = "Options-Schalter sichtbar."
KBM.Language.Options.LockButton = KBM.Language:Add("Unlock Button (right-click to move).")
KBM.Language.Options.LockButton.French = "D\195\169bloquer Bouton (click-droit pour d\195\169placer)."
KBM.Language.Options.LockButton.German = "Schalter ist verschiebbar (Rechts-Klick zum verschieben)."
-- Tank Swap related
KBM.Language.Options.TankSwap = KBM.Language:Add("Tank-Swaps")
KBM.Language.Options.TankSwap.German = "Tank Wechsel"
KBM.Language.Options.Tank = KBM.Language:Add("Show Test Tanks.")
KBM.Language.Options.Tank.French = "Afficher Test Tanks."
KBM.Language.Options.Tank.German = "Zeige Test-Tanks-Fenster."
KBM.Language.Options.TankSwapEnabled = KBM.Language:Add("Tank-Swaps enabled.")
KBM.Language.Options.TankSwapEnabled.German = "Tank Wechsel anzeigen."
-- Alert related
KBM.Language.Options.AlertsOverride = KBM.Language:Add("Alerts: Override")
KBM.Language.Options.AlertsOverride.German = "Alarmierungs: Einstellungen."
KBM.Language.Options.Alert = KBM.Language:Add("Screen Alerts")
KBM.Language.Options.Alert.German = "Alarmierungen"
KBM.Language.Options.Alert.French = "Alerte \195\160 l'\195\169cran"
KBM.Language.Options.AlertsEnabled = KBM.Language:Add("Screen Alerts enabled.")
KBM.Language.Options.AlertsEnabled.German = "Bildschirm Alarmierungen aktiviert."
KBM.Language.Options.AlertsEnabled.French = "Alerte \195\160 l'\195\169cran activ\195\169."
KBM.Language.Options.AlertFlash = KBM.Language:Add("Screen flash enabled.")
KBM.Language.Options.AlertFlash.German = "Bildschirm-Rand Flackern aktiviert."
KBM.Language.Options.AlertFlash.French = "Flash \195\169cran activ\195\169."
KBM.Language.Options.AlertText = KBM.Language:Add("Alert warning text enabled.")
KBM.Language.Options.AlertText.German = "Alarmierungs-Text aktiviert."
KBM.Language.Options.AlertText.French = "Texte Avertissement Alerte activ\195\169 ."
KBM.Language.Options.UnlockFlash = KBM.Language:Add("Unlock alert border")
KBM.Language.Options.UnlockFlash.German = "Alarmierungs Ränder sind änderbar."
-- Size Dictionary
KBM.Language.Options.UnlockWidth = KBM.Language:Add("Unlock width for scaling. (Mouse wheel)")
KBM.Language.Options.UnlockWidth.German = "Breite ist skalierbar."
KBM.Language.Options.UnlockHeight = KBM.Language:Add("Unlock height for scaling. (Mouse wheel)")
KBM.Language.Options.UnlockHeight.German = "Höhe ist skalierbar."
KBM.Language.Options.UnlockText = KBM.Language:Add("Unlock Text size. (Mouse wheel)")
KBM.Language.Options.UnlockText.German = "Textgröße ist änderbar."
KBM.Language.Options.UnlockAlpha = KBM.Language:Add("Unlock transparency.")
KBM.Language.Options.UnlockAlpha.German = "Transparenz ist änderbar."
-- Misc.
KBM.Language.Options.Character = KBM.Language:Add("Saving settings for this character only.")
KBM.Language.Options.Character.German = "Einstellungen nur für diesen Charakter speichern."
KBM.Language.Options.ModEnabled = KBM.Language:Add("Enable King Boss Mods v"..AddonData.toc.Version)
KBM.Language.Options.ModEnabled.German = "Aktiviere King Boss Mods v"..AddonData.toc.Version
KBM.Language.Options.Enabled = KBM.Language:Add("Enabled.")
KBM.Language.Options.Enabled.German = "Aktiviert."
KBM.Language.Options.Settings = KBM.Language:Add("Settings")
KBM.Language.Options.Settings.French = "Configurations"
KBM.Language.Options.Settings.German = "Einstellungen"
KBM.Language.Options.Shadow = KBM.Language:Add("Show text shadows.")
KBM.Language.Options.Shadow.German = "Zeige Text Schattierung."
KBM.Language.Options.Texture = KBM.Language:Add("Enable textured overlay.")
KBM.Language.Options.Texture.German = "Texturierte Balken aktiviert." 
-- Timer Dictionary
KBM.Language.Timers = {}
KBM.Language.Timers.Time = KBM.Language:Add("Time:")
KBM.Language.Timers.Time.French = "Dur\195\169e:"
KBM.Language.Timers.Time.German = "Zeit:"
KBM.Language.Timers.Enrage = KBM.Language:Add("Enrage in:")
KBM.Language.Timers.Enrage.French = "Enrage dans:"

KBM.Numbers = {}
KBM.Numbers.Place = {}
KBM.Numbers.Place[0] = "th"
KBM.Numbers.Place[1] = "st"
KBM.Numbers.Place[2] = "nd"
KBM.Numbers.Place[3] = "rd"

function KBM.Numbers.GetPlace(Number)
	local Check = 0
	local Last = 0
	if Number < 4 or Number > 20 then
		Last = tonumber(string.sub(tostring(Number), -1))
		if Last > 0 and Last < 4 then
			Check = Last
		end
	end
	return Number..KBM.Numbers.Place[Check]
end

-- Main Color Library.
-- Colors will remain preset based to avoid ugly videos :)
KBM.Colors = {
	Count = 6,
	List = {
		red = {
			Name = KBM.Language.Color.Red[KBM.Lang],
			Red = 1,
			Green = 0,
			Blue = 0,
		},
		dark_green = {
			Name = KBM.Language.Color.Dark_Green[KBM.Lang],
			Red = 0,
			Green = 0.6,
			Blue = 0,
		},
		orange = {
			Name = KBM.Language.Color.Orange[KBM.Lang],
			Red = 1,
			Green = 0.5,
			Blue = 0,
		},
		blue = {
			Name = KBM.Language.Color.Blue[KBM.Lang],
			Red = 0,
			Green = 0,
			Blue = 1,
		},
		yellow = {
			Name = KBM.Language.Color.Yellow[KBM.Lang],
			Red = 1,
			Green = 1,
			Blue = 0,
		},
		purple = {
			Name = KBM.Language.Color.Purple[KBM.Lang],
			Red = 0.85,
			Green = 0,
			Blue = 0.65,
		},
	}
}
function KBM.MechTimer:ApplySettings()

	self.Anchor:ClearAll()
	if self.Settings.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
	else
		self.Anchor:SetPoint("BOTTOMRIGHT", UIParent, 0.9, 0.5)
	end
	self.Anchor:SetWidth(self.Settings.w * self.Settings.wScale)
	self.Anchor:SetHeight(self.Settings.h * self.Settings.hScale)
	self.Anchor.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
	if KBM.MainWin:GetVisible() then
		self.Anchor:SetVisible(self.Settings.Visible)
		self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end
	
end

function KBM.MechTimer:Init()
	self.TimerList = {}
	self.ActiveTimers = {}
	self.RemoveTimers = {}
	self.RemoveCount = 0
	self.StartTimers = {}
	self.StartCount = 0
	self.LastTimer = nil
	self.Store = {}
	self.Settings = KBM.Options.MechTimer
	self.Anchor = UI.CreateFrame("Frame", "Timer Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
		
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.MechTimer.Settings.x = self:GetLeft()
			KBM.MechTimer.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Text = UI.CreateFrame("Text", "Timer Info", self.Anchor)
	self.Anchor.Text:SetText(" 00.0 Timer Anchor")
	self.Anchor.Text:SetPoint("CENTERLEFT", self.Anchor, "CENTERLEFT")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor_Drag", 5)
	
	function self.Anchor.Drag.Event:WheelForward()
		if KBM.MechTimer.Settings.ScaleWidth then
			if KBM.MechTimer.Settings.wScale < 1.5 then
				KBM.MechTimer.Settings.wScale = KBM.MechTimer.Settings.wScale + 0.025
				if KBM.MechTimer.Settings.wScale > 1.5 then
					KBM.MechTimer.Settings.wScale = 1.5
				end
				KBM.MechTimer.Anchor:SetWidth(KBM.MechTimer.Settings.wScale * KBM.MechTimer.Settings.w)
			end
		end
		
		if KBM.MechTimer.Settings.ScaleHeight then
			if KBM.MechTimer.Settings.hScale < 1.5 then
				KBM.MechTimer.Settings.hScale = KBM.MechTimer.Settings.hScale + 0.025
				if KBM.MechTimer.Settings.hScale > 1.5 then
					KBM.MechTimer.Settings.hScale = 1.5
				end
				KBM.MechTimer.Anchor:SetHeight(KBM.MechTimer.Settings.hScale * KBM.MechTimer.Settings.h)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
					end
				end
			end
		end
		
		if KBM.MechTimer.Settings.TextScale then
			if KBM.MechTimer.Settings.tScale < 1.5 then
				KBM.MechTimer.Settings.tScale = KBM.MechTimer.Settings.tScale + 0.025
				if KBM.MechTimer.Settings.tScale > 1.5 then
					KBM.MechTimer.Settings.tScale = 1.5
				end
				KBM.MechTimer.Anchor.Text:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
						Timer.GUI.Shadow:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
					end
				end
			end
		end
	end
	
	function self.Anchor.Drag.Event:WheelBack()		
		if KBM.MechTimer.Settings.ScaleWidth then
			if KBM.MechTimer.Settings.wScale > 0.5 then
				KBM.MechTimer.Settings.wScale = KBM.MechTimer.Settings.wScale - 0.025
				if KBM.MechTimer.Settings.wScale < 0.5 then
					KBM.MechTimer.Settings.wScale = 0.5
				end
				KBM.MechTimer.Anchor:SetWidth(KBM.MechTimer.Settings.wScale * KBM.MechTimer.Settings.w)
			end
		end
		
		if KBM.MechTimer.Settings.ScaleHeight then
			if KBM.MechTimer.Settings.hScale > 0.5 then
				KBM.MechTimer.Settings.hScale = KBM.MechTimer.Settings.hScale - 0.025
				if KBM.MechTimer.Settings.hScale < 0.5 then
					KBM.MechTimer.Settings.hScale = 0.5
				end
				KBM.MechTimer.Anchor:SetHeight(KBM.MechTimer.Settings.hScale * KBM.MechTimer.Settings.h)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
					end
				end
			end
		end
		
		if KBM.MechTimer.Settings.TextScale then
			if KBM.MechTimer.Settings.tScale > 0.5 then
				KBM.MechTimer.Settings.tScale = KBM.MechTimer.Settings.tScale - 0.025
				if KBM.MechTimer.Settings.tScale < 0.5 then
					KBM.MechTimer.Settings.tScale = 0.5
				end
				KBM.MechTimer.Anchor.Text:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
						Timer.GUI.Shadow:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
					end
				end				
			end
		end
	end
	self:ApplySettings()
	
end

function KBM.MechTimer:Pull()
	local GUI = {}
	if #self.Store > 0 then
		GUI = table.remove(self.Store)
	else
		GUI.Background = UI.CreateFrame("Frame", "Timer_Frame", KBM.Context)
		GUI.Background:SetPoint("LEFT", KBM.MechTimer.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", KBM.MechTimer.Anchor, "RIGHT")
		GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.TimeBar = UI.CreateFrame("Frame", "Timer_Progress_Frame", GUI.Background)
		--GUI.TimeBar:SetTexture("KingMolinator", "Media/BarTexture2.png")
		GUI.TimeBar:SetWidth(KBM.MechTimer.Anchor:GetWidth())
		GUI.TimeBar:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.TimeBar:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.TimeBar:SetLayer(1)
		GUI.TimeBar:SetBackgroundColor(0,0,1,0.33)
		GUI.TimeBar:SetMouseMasking("limited")
		GUI.CastInfo = UI.CreateFrame("Text", "Timer_Text_Frame", GUI.Background)
		GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
		GUI.CastInfo:SetPoint("CENTERLEFT", GUI.Background, "CENTERLEFT")
		GUI.CastInfo:SetLayer(3)
		GUI.CastInfo:SetFontColor(1,1,1)
		GUI.CastInfo:SetMouseMasking("limited")
		GUI.Shadow = UI.CreateFrame("Text", "Timer_Text_Shadow", GUI.Background)
		GUI.Shadow:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
		GUI.Shadow:SetPoint("CENTER", GUI.CastInfo, "CENTER", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetMouseMasking("limited")
		GUI.Texture = UI.CreateFrame("Texture", "Timer_Skin", GUI.Background)
		GUI.Texture:SetTexture("KingMolinator", "Media/BarSkin.png")
		GUI.Texture:SetAlpha(KBM.MechTimer.Settings.TextureAlpha)
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(4)
		GUI.Texture:SetMouseMasking("limited")
	end
	return GUI
end

function KBM.MechTimer:Add(Name, Duration, Repeat)
	local Timer = {}
	Timer.Active = false
	Timer.Alerts = {}
	Timer.Timers = {}
	Timer.Triggers = {}
	Timer.TimeStart = nil
	Timer.Removing = false
	Timer.Starting = false
	Timer.Time = Duration
	Timer.Delay = iStart
	Timer.Enabled = true
	Timer.Repeat = Repeat
	Timer.Name = Name
	Timer.Phase = 0
	Timer.Type = "timer"
	Timer.Custom = false
	Timer.Color = KBM.MechTimer.Settings.Color
	Timer.HasMenu = true
	if type(Duration) ~= "number" then
		error("Expecting Number, got "..type(Duration).." for Duration")
	end
	if type(Name) ~= "string" then
		error("Expecting String for Name, got "..type(Name))
	end
	
	function self:AddRemove(Object)
		if not Object.Removing then
			if Object.Enabled and Object.Active then
				Object.Removing = true
				table.insert(self.RemoveTimers, Object)
				self.RemoveCount = self.RemoveCount + 1
			end
		end
	end
	
	function self:AddStart(Object)
		if not Object.Starting then
			if Object.Enabled then
				self.Queued = false
				Object.Starting = true
				self.StartCount = self.StartCount + 1
				table.insert(self.StartTimers, Object)
				self:AddRemove(Object)
			end
		end
	end
	
	function Timer:Start(CurrentTime, DebugInfo)	
		if self.Enabled then
			if self.Phase > 0 then
				if KBM.CurrentMod then
					if self.Phase < KBM.CurrentMod.Phase then
						return
					end
				end
			end
			if self.Active then
				KBM.MechTimer:AddStart(self)
				return
			end
			local Anchor = KBM.MechTimer.Anchor
			self.GUI = KBM.MechTimer:Pull()
			self.GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
			self.GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
			self.GUI.Shadow:SetFontSize(self.GUI.CastInfo:GetFontSize())
			self.TimeStart = CurrentTime
			self.Remaining = self.Time
			self.GUI.CastInfo:SetText(string.format(" %0.01f : ", self.Remaining)..self.Name)
			
			if KBM.MechTimer.Settings.Shadow then
				self.GUI.Shadow:SetText(self.GUI.CastInfo:GetText())
				self.GUI.Shadow:SetVisible(true)
			else
				self.GUI.Shadow:SetVisible(false)
			end
			
			if KBM.MechTimer.Settings.Texture then
				self.GUI.Texture:SetVisible(true)
			else
				self.GUI.Texture:SetVisible(false)
			end
			
			if self.Delay then
				self.Time = Delay
			end
			
			if self.Settings then
				self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
			else
				self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[KBM.MechTimer.Settings.Color].Red, KBM.Colors.List[KBM.MechTimer.Settings.Color].Green, KBM.Colors.List[KBM.MechTimer.Settings.Color].Blue, 0.33)
			end
			
			if #KBM.MechTimer.ActiveTimers > 0 then
				for i, cTimer in ipairs(KBM.MechTimer.ActiveTimers) do
					if self.Remaining < cTimer.Remaining then
						self.Active = true
						if i == 1 then
							self.GUI.Background:SetPoint("TOPLEFT", Anchor, "TOPLEFT")
							cTimer.GUI.Background:SetPoint("TOPLEFT", self.GUI.Background, "BOTTOMLEFT", 0, 1)
						else
							self.GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.ActiveTimers[i-1].GUI.Background, "BOTTOMLEFT", 0, 1)
							cTimer.GUI.Background:SetPoint("TOPLEFT", self.GUI.Background, "BOTTOMLEFT", 0, 1)
						end
						table.insert(KBM.MechTimer.ActiveTimers, i, self)
						break
					end
				end
				if not self.Active then
					self.GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.LastTimer.GUI.Background, "BOTTOMLEFT", 0, 1)
					table.insert(KBM.MechTimer.ActiveTimers, self)
					KBM.MechTimer.LastTimer = self
					self.Active = true
				end
			else
				self.GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.Anchor, "TOPLEFT")
				table.insert(KBM.MechTimer.ActiveTimers, self)
				self.Active = true
				KBM.MechTimer.LastTimer = self
				if KBM.MechTimer.Settings.Visible then
					KBM.MechTimer.Anchor.Text:SetVisible(false)
				end
			end
			self.GUI.Background:SetVisible(true)
			self.Starting = false
		end		
	end
	
	function Timer:Queue()
		if self.Enabled then
			KBM.MechTimer:AddStart(self)
		end
	end
	
	function Timer:Stop()
		if not self.Deleting then
			self.Deleting = true
			for i, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
				if Timer == self then
					if #KBM.MechTimer.ActiveTimers == 1 then
						KBM.MechTimer.LastTimer = nil
						if KBM.MechTimer.Settings.Visible then
							KBM.MechTimer.Anchor.Text:SetVisible(true)
						end
					elseif i == 1 then
						KBM.MechTimer.ActiveTimers[i+1].GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.Anchor, "TOPLEFT")
					elseif i == #KBM.MechTimer.ActiveTimers then
						KBM.MechTimer.LastTimer = KBM.MechTimer.ActiveTimers[i-1]
					else
						KBM.MechTimer.ActiveTimers[i+1].GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.ActiveTimers[i-1].GUI.Background, "BOTTOMLEFT", 0, 1)
					end
					table.remove(KBM.MechTimer.ActiveTimers, i)
					break
				end
			end
			self.GUI.Background:SetVisible(false)
			self.GUI.Shadow:SetText("")
			table.insert(KBM.MechTimer.Store, self.GUI)
			self.Active = false
			self.Remaining = 0
			self.TimeStart = 0
			for i, AlertObj in pairs(self.Alerts) do
				self.Alerts[i].Triggered = false
			end
			self.GUI = nil
			self.Removing = false
			self.Deleting = false
			if self.Repeat then
				if KBM.Encounter then
					if self.Phase == KBM.CurrentMod.Phase or self.Phase == 0 then
						KBM.MechTimer:AddStart(self)
					end
				end
			end
			if self.TimerAfter then
				if KBM.Encounter then
					if self.TimerAfter.Phase == KBM.CurrentMod.Phase or self.TimerAfter.Phase == 0 then
						KBM.MechTimer:AddStart(self.TimerAfter)
					end
				end
			end
			if self.AlertAfter then
				if KBM.Encounter then
					KBM.Alert:Start(self.AlertAfter, Inspect.Timer.Real())
				end
			end
		end
	end
	
	function Timer:AddAlert(AlertObj, Time)
		if type(AlertObj) == "table" then
			if AlertObj.Type ~= "alert" then
				error("Expecting AlertObj got "..tostring(AlertObj.Type))
			else
				if Time == 0 then
					self.AlertAfter = AlertObj
				else
					self.Alerts[Time] = {}
					self.Alerts[Time].Triggered = false
					self.Alerts[Time].AlertObj = AlertObj
				end
			end
		else
			error("Expecting AlertObj got "..type(AlertObj))
		end
	end
	
	function Timer:AddTimer(TimerObj, Time)
		if type(TimerObj) == "table" then
			if TimerObj.Type ~= "timer" then
				error("Expecting TimerObj got "..tostring(TimerObj.Type))
			else
				if Time == 0 then
					self.TimerAfter = TimerObj
				else
					self.Timers[Time] = {}
					self.Timers[Time].Triggered = false
					self.Timers[Time].TimerObj = TimerObj
				end
			end
		else
			error("Expecting TimerObj got "..type(TimerObj))
		end
	end
	
	function Timer:AddTrigger(TriggerObj, Time)
		self.Triggers[Time] = {}
		self.Triggers[Time].Triggered = false
		self.Triggers[Time].TriggerObj = TriggerObj
	end
	
	function Timer:SetPhase(Phase)
		self.Phase = Phase
	end
	
	function Timer:Update(CurrentTime)
		local text = ""
		if self.Active then
			if self.Waiting then
			
			else
				self.Remaining = self.Time - (CurrentTime - self.TimeStart)
				if self.Remaining < 10 then
					text = string.format(" %0.01f : ", math.floor(self.Remaining))..self.Name
				elseif self.Remaining >= 60 then
					text = " "..KBM.ConvertTime(self.Remaining).." : "..self.Name
				else
					text = " "..math.floor(self.Remaining).." : "..self.Name
				end
				self.GUI.CastInfo:SetText(text)
				self.GUI.Shadow:SetText(text)
				self.GUI.TimeBar:SetWidth(self.GUI.Background:GetWidth() * (self.Remaining/self.Time))
				if self.Remaining <= 0 then
					self.Remaining = 0
					KBM.MechTimer:AddRemove(self)
				end
				TriggerTime = math.ceil(self.Remaining)
				if self.Alerts[TriggerTime] then
					if not self.Alerts[TriggerTime].Triggered then
						KBM.Alert:Start(self.Alerts[TriggerTime].AlertObj, CurrentTime)
						self.Alerts[TriggerTime].Triggered = true
					end
				end
			end
		end
	end
	
	function Timer:NoMenu()
		self.HasMenu = false
		self.Enabled = true
	end
	
	return Timer
	
end

function KBM.Trigger:Init()
	self.Queue = {}
	self.Queue.Locked = false
	self.Queue.Removing = false
	self.Queue.List = {}
	self.List = {}
	self.Notify = {}
	self.Say = {}
	self.Damage = {}
	self.Cast = {}
	self.Percent = {}
	self.Combat = {}
	self.Start = {}
	self.Death = {}
	self.Buff = {}
	self.PlayerBuff = {}
	self.BuffRemove = {}
	self.PlayerBuffRemove = {}
	self.Time = {}

	function self.Queue:Add(TriggerObj, Caster, Target, Duration)	
		if KBM.Encounter or KBM.Testing then
			if TriggerObj.Queued or self.Removing then
				return
			else
				TriggerObj.Queued = true
			end
			table.insert(self.List, TriggerObj)
			TriggerObj.Caster = Caster
			TriggerObj.Target = Target
			TriggerObj.Duration = Duration
			self.Queued = true
		end		
	end
	
	function self.Queue:Activate()	
		if self.Queued then
			if KBM.Encounter or KBM.Testing then
				if self.Removing then
					return
				end
				for i, TriggerObj in ipairs(self.List) do
					TriggerObj:Activate(TriggerObj.Caster, TriggerObj.Target, TriggerObj.Duration)
					TriggerObj.Queued = false
				end
				self.List = {}
				self.Queued = false
			end
		end		
	end
	
	function self.Queue:Remove()		
		self.Removing = true
		self.List = {}
		self.Removing = false
		self.Queued = false		
	end
	
	function self:Create(Trigger, Type, Unit, Hook)	
		TriggerObj = {}
		TriggerObj.Timers = {}
		TriggerObj.Alerts = {}
		TriggerObj.Stop = {}
		TriggerObj.Hook = Hook
		TriggerObj.Unit = Unit
		TriggerObj.Type = Type
		TriggerObj.Caster = nil
		TriggerObj.Target = nil
		TriggerObj.Queued = false
		TriggerObj.Phase = nil
		TriggerObj.Trigger = Trigger
		TriggerObj.LastTrigger = 0
		
		function TriggerObj:AddTimer(TimerObj)
			if not TimerObj then
				error("Timer object does not exist!")
			end
			if type(TimerObj) ~= "table" then
				error("TimerObj: Expecting Table, got "..tostring(type(TimerObj)))
			elseif TimerObj.Type ~= "timer" then
				error("TimerObj: Expecting timer, got "..tostring(TimerObj.Type))
			end
			table.insert(self.Timers, TimerObj)
		end
		
		function TriggerObj:AddAlert(AlertObj, Player)
			if not AlertObj then
				error("Alert Object does not exist!")
			end
			if type(AlertObj) ~= "table" then
				error("AlertObj: Expecting Table, got "..tostring(type(AlertObj)))
			elseif AlertObj.Type ~= "alert" then
				error("AlertObj: Expecting alert, got "..tostring(AlertObj.Type))
			end
			AlertObj.Player = Player
			table.insert(self.Alerts, AlertObj)
		end
		
		function TriggerObj:AddPhase(PhaseObj)
			if not PhaseObj then
				error("Phase Object does not exist!")
			end
			self.Phase = PhaseObj 
		end
		
		function TriggerObj:AddStop(Object)
			if type(Object) ~= "table" then
				error("Expecting at least table: Got "..tostring(type(Object)))
			elseif Object.Type ~= "timer" and Object.Type ~= "alert" then
				error("Expecting at least Timer or Alert: Got "..tostring(Object.Type))
			end
			table.insert(self.Stop, Object)
		end
		
		function TriggerObj:Activate(Caster, Target, Data)
			local Triggered = false
			local current = Inspect.Time.Real()
			if self.Type == "damage" then
				for i, Timer in ipairs(self.Timers) do
					if Timer.Active then
						if current - self.LastTrigger > KBM.Idle.Trigger.Duration then
							Timer:Queue()
							Triggered = true
						end
					else
						Timer:Queue()
						Triggered = true
					end
				end
			else
				for i, Timer in ipairs(self.Timers) do
					Timer:Queue()
					Triggered = true
				end
			end
			for i, AlertObj in ipairs(self.Alerts) do
				if AlertObj.Player then
					if KBM.Player.UnitID == Target then
						KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
						Triggered = true
					end
				else
					KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
					Triggered = true
				end
			end
			for i, Obj in ipairs(self.Stop) do
				if Obj.Type == "timer" then
					KBM.MechTimer:AddRemove(Obj)
					Triggered = true
				elseif Obj.Type == "alert" then
					KBM.Alert:Stop(Obj)
					Triggered = true
				end
			end
			if KBM.Encounter then
				if self.Phase then
					self.Phase(self.Type)
					Triggered = true
				end
			end
			if Triggered then
				self.LastTrigger = current
			end
		end
		
		if Type == "notify" then
			TriggerObj.Phrase = Trigger
			if not self.Notify[Unit.Mod.ID] then
				self.Notify[Unit.Mod.ID] = {}
			end
			table.insert(self.Notify[Unit.Mod.ID], TriggerObj)
		elseif Type == "say" then
			TriggerObj.Phrase = Trigger
			if not self.Say[Unit.Mod.ID] then
				self.Say[Unit.Mod.ID] = {}
			end
			table.insert(self.Say[Unit.Mod.ID], TriggerObj)
		elseif Type == "damage" then
			self.Damage[Trigger] = TriggerObj
		elseif Type == "cast" then
			if not self.Cast[Trigger] then
				self.Cast[Trigger] = {}
			end
			self.Cast[Trigger][Unit.Name] = TriggerObj
		elseif Type == "percent" then
			if not self.Percent[Unit.Mod.ID] then
				self.Percent[Unit.Mod.ID] = {}
			end
			if not self.Percent[Unit.Mod.ID][Unit.Name] then
				self.Percent[Unit.Mod.ID][Unit.Name] = {}
			end
			self.Percent[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
		elseif Type == "combat" then
			self.Combat[Trigger] = TriggerObj
		elseif Type == "start" then
			if not self.Start[Unit.Mod.ID] then
				self.Start[Unit.Mod.ID] = {}
			end
			table.insert(self.Start[Unit.Mod.ID], TriggerObj)
		elseif Type == "death" then
			self.Death[Trigger] = TriggerObj
		elseif Type == "buff" then
			if not self.Buff[Unit.Mod.ID] then
				self.Buff[Unit.Mod.ID] = {}
			end
			self.Buff[Unit.Mod.ID][Trigger] = TriggerObj
		elseif Type == "buffRemove" then
			if not self.BuffRemove[Unit.Mod.ID] then
				self.BuffRemove[Unit.Mod.ID] = {}
			end
			self.BuffRemove[Unit.Mod.ID][Trigger] = TriggerObj
		elseif Type == "playerBuff" then
			if not self.PlayerBuff[Unit.Mod.ID] then
				self.PlayerBuff[Unit.Mod.ID] = {}
			end
			self.PlayerBuff[Unit.Mod.ID][Trigger] = TriggerObj
		elseif Type == "playerBuffRemove" then
			if not self.PlayerBuffRemove[Unit.Mod.ID] then
				self.PlayerBuffRemove[Unit.Mod.ID] = {}
			end
			self.PlayerBuffRemove[Unit.Mod.ID][Trigger] = TriggerObj
		elseif Type == "time" then
			if not self.Time[Unit.Mod.ID] then
				self.Time[Unit.Mod.ID] = {}
			end
			self.Time[Unit.Mod.ID][Trigger] = TriggerObj
		else
			error("Unknown trigger type: "..tostring(Type))
		end
		
		table.insert(self.List, TriggerObj)
		return TriggerObj		
	end
	
	function self:Unload()
		self.Notify = {}
		self.Say = {}
		self.Damage = {}
		self.Cast = {}
		self.Percent = {}
		self.Combat = {}
		self.Start = {}
		self.Death = {}
		self.Buff = {}		
	end
end

local function KBM_Options()
	if KBM.MainWin:GetVisible() then
		KBM.MainWin.Options:Close()
	else
		KBM.MainWin.Options:Open()
	end	
end

function KBM.Button:Init()
	KBM.Button.Texture = UI.CreateFrame("Texture", "Button Texture", KBM.Context)
	KBM.Button.Texture:SetTexture("KingMolinator", "Media/Options_Button.png")
	if not KBM.Options.Button.x then
		KBM.Button.Texture:SetPoint("CENTER", UIParent, "CENTER")
	else
		KBM.Button.Texture:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.Button.x, KBM.Options.Button.y)
	end
	KBM.Button.Texture:SetLayer(5)
	
	function KBM.Button:UpdateMove(uType)
		if uType == "end" then
			KBM.Options.Button.x = self.Texture:GetLeft()
			KBM.Options.Button.y = self.Texture:GetTop()
		end	
	end
	
	function KBM.Button.Texture.Event.LeftClick()
		KBM_Options()
	end
	
	KBM.Button.Drag = KBM.AttachDragFrame(KBM.Button.Texture, function (uType) self:UpdateMove(uType) end, "Button Drag", 6)
	KBM.Button.Drag.Event.RightDown = KBM.Button.Drag.Event.LeftDown
	KBM.Button.Drag.Event.RightUp = KBM.Button.Drag.Event.LeftUp
	KBM.Button.Drag.Event.LeftDown = nil
	KBM.Button.Drag.Event.LeftUp = nil
	KBM.Button.Drag:SetMouseMasking("limited")
	if not KBM.Options.Button.Unlocked then
		KBM.Button.Drag:SetVisible(false)
	end
	if not KBM.Options.Button.Visible then
		KBM.Button.Texture:SetVisible(false)
	end	
end

function KBM.PhaseMonitor:PullObjective()
	local GUI  = {}
	if #self.ObjectiveStore > 0 then
		GUI = table.remove(self.ObjectiveStore)
	else
		GUI.Frame = UI.CreateFrame("Frame", "Objective_Base", KBM.Context)
		GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
		GUI.Frame:SetPoint("LEFT", self.Anchor, "LEFT")
		GUI.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
		GUI.Text = UI.CreateFrame("Text", "Objective_Text", GUI.Frame)
		GUI.Text:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT")
		GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Objective = UI.CreateFrame("Text", "Objective_Tracker", GUI.Frame)
		GUI.Objective:SetPoint("CENTERRIGHT", GUI.Frame, "CENTERRIGHT")
		GUI.Objective:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Frame:SetVisible(self.Settings.Enabled)
	end
	return GUI
end

function KBM.PhaseMonitor:Init()

	self.Settings = KBM.Options.PhaseMon
	if self.Settings.Type ~= "PhaseMon" then
		print("Error: Incorrect Settings for Phase Monintor")
	end
	self.Anchor = UI.CreateFrame("Frame", "Phase Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Anchor.Text = UI.CreateFrame("Text", "Phase Anchor Text", self.Anchor)
	self.Anchor.Text:SetText("Phases and Objectives")
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")

	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.PhaseMonitor.Settings.x = self:GetLeft()
			KBM.PhaseMonitor.Settings.y = self:GetTop()
		end
	end
		
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Phase Anchor Drag", 2)

	self.Frame = UI.CreateFrame("Frame", "Phase Monitor", KBM.Context)
	self.Frame:SetLayer(5)
	self.Frame:SetBackgroundColor(0,0,0.9,0.33)
	self.Frame:SetPoint("LEFT", self.Anchor, "LEFT")
	self.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
	self.Frame:SetPoint("TOP", self.Anchor, "TOP")
	self.Frame:SetPoint("BOTTOM", self.Anchor, "CENTERY")
	self.Frame.Text = UI.CreateFrame("Text", "Phase_Monitor_Text", self.Frame)
	self.Frame.Text:SetText("Phase: 1")
	self.Frame.Text:SetPoint("CENTER", self.Frame, "CENTER")
	
	self.Frame:SetVisible(false)
	
	self.Objectives = {}
	self.ObjectiveStore = {}
	self.Phase = {}
	self.Phase.Object = nil
	self.Active = false
	
	self.Objectives.Lists = {}
	self.Objectives.Lists.Meta = {}
	self.Objectives.Lists.Death = {}
	self.Objectives.Lists.Percent = {}
	self.Objectives.Lists.Time = {}
	self.Objectives.Lists.All = {}
	self.Objectives.Lists.LastObjective = nil
	self.Objectives.Lists.Count = 0
	
	function self:ApplySettings()
	
		if self.Settings.Type ~= "PhaseMon" then
			error("Error (Apply Settings): Incorrect Settings for Phase Monitor")
		end
	
		self.Anchor:ClearAll()
		if not self.Settings.x then
			self.Anchor:SetPoint("CENTERTOP", UIParent, 0.65, 0)
		else
			self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		end
		self.Anchor:SetWidth(self.Settings.w * self.Settings.wScale)
		self.Anchor:SetHeight(self.Settings.h * self.Settings.hScale)
		self.Anchor.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Frame.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		if self.Settings.Enabled and KBM.MainWin:GetVisible() then
			self.Anchor:SetVisible(self.Settings.Visible)
			self.Anchor:SetBackgroundColor(0,0,0,0.33)
			self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
		else
			self.Anchor:SetVisible(false)
		end
		if #self.ObjectiveStore > 0 then
			for _, GUI in ipairs(self.ObjectiveStore) do
				GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
			end
		end
		if self.Objectives.Lists.Count > 0 then
			for _, Object in ipairs(self.Objectives.Lists.All) do
				Object.GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
			end
		end	
	end
	
	function self.Objectives.Lists:Add(Object)	
		if self.Count > 0 then
			Object.Previous = self.LastObjective
		end
		self.Count = self.Count + 1
		self.LastObjective = Object
		self.All[self.Count] = Object
		if Object.Previous then
			-- Appended to current List
			Object.GUI.Frame:SetPoint("TOP", Object.Previous.GUI.Frame, "BOTTOM")
			Object.Previous.Next = Object
			Object.Next = nil
		else
			-- First in the list
			Object.GUI.Frame:SetPoint("TOP", KBM.PhaseMonitor.Frame, "BOTTOM")
			Object.Previous = nil
			Object.Next = nil
		end
		Object.Index = self.Count		
	end
	
	function self.Objectives.Lists:Remove(Object)	
		if self.Count == 1 then
			Object.GUI.Frame:SetVisible(false)
			table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
			self[Object.Type][Object.Name] = nil
			self[Object.Type] = {}
			self.All = {}
			Object = nil
			self.Count = 0
		else
			Object.GUI.Frame:SetVisible(false)
			table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
			if Object.Next then
				if Object.Previous then
					-- Next Object is now after this objects previous in the list.
					Object.Previous.Next = Object.Next
					Object.Next.GUI.Frame:SetPoint("TOP", Object.Previous.GUI.Frame, "BOTTOM")
				else
					-- Next Object is now First in the list
					Object.Next.Previous = nil
					Object.Next.GUI.Frame:SetPoint("TOP", KBM.PhaseMonitor.Frame, "BOTTOM")
				end
				Object.Next.Index = Object.Next.Index - 1
			else
				-- This object was the last object in the list, and now the previous object is.
				Object.Previous.Next = nil
				self.LastObjective = Object.Previous
			end
			self[Object.Type][Object.Name] = nil
			self.All[Object.Index] = nil
			Object = nil
			self.Count = self.Count - 1
		end		
	end
	
	function self:SetPhase(Phase)
		self.Phase = Phase
		self.Frame.Text:SetText("Phase: "..Phase)
	end
	
	function self.Phase:Create(Phase)
		local PhaseObj = {}
		PhaseObj.StartTime = 0
		PhaseObj.Phase = Phase
		PhaseObj.DefaultPhase = Phase
		PhaseObj.Objectives = {}
		PhaseObj.LastObjective = KBM.PhaseMonitor.Frame
		PhaseObj.Type = "PhaseMon"
		
		function PhaseObj:Update(Time)
			Time = math.floor(Time)
		end
		
		function PhaseObj:SetPhase(Phase)
			self.Phase = Phase
			KBM.PhaseMonitor:SetPhase(Phase)
		end
		
		function PhaseObj.Objectives:AddMeta(Name, Target, Total)		
			local MetaObj = {}
			MetaObj.Count = Total
			MetaObj.Target = Target
			MetaObj.Name = Name
			MetaObj.GUI = KBM.PhaseMonitor:PullObjective()
			MetaObj.GUI.Text:SetText(Name)
			MetaObj.GUI.Objective:SetText(MetaObj.Count.."/"..MetaObj.Target)
			MetaObj.Type = "Meta"
			
			function MetaObj:Update(Total)
				if self.Target >= Total then
					self.Count = Total
					self.GUI.Objective:SetText(self.Count.."/"..self.Target)
				end
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Meta[Name] = MetaObj
			KBM.PhaseMonitor.Objectives.Lists:Add(MetaObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				MetaObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				MetaObj.GUI.Frame:SetVisible(false)
			end
			return MetaObj
		end
		
		function PhaseObj.Objectives:AddDeath(Name, Total)		
			local DeathObj = {}
			DeathObj.Count = 0
			DeathObj.Total = Total
			DeathObj.Name = Name
			DeathObj.GUI = KBM.PhaseMonitor:PullObjective()
			DeathObj.GUI.Text:SetText(Name)
			DeathObj.GUI.Objective:SetText(DeathObj.Count.."/"..DeathObj.Total)
			DeathObj.Type = "Death"
			
			function DeathObj:Kill()
				if self.Count < Total then
					self.Count = self.Count + 1
					self.GUI.Objective:SetText(self.Count.."/"..self.Total)
				end
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Death[Name] = DeathObj
			KBM.PhaseMonitor.Objectives.Lists:Add(DeathObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				DeathObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				DeathObj.GUI.Frame:SetVisible(false)
			end			
		end
		
		function PhaseObj.Objectives:AddPercent(Name, Target, Current)		
			local PercentObj = {}
			PercentObj.Name = Name
			PercentObj.Target = Target
			PercentObj.PercentRaw = Current
			PercentObj.Percent = math.ceil(Current)
			PercentObj.GUI = KBM.PhaseMonitor:PullObjective()
			PercentObj.GUI.Text:SetText(Name)
			if Target == 0 then
				PercentObj.GUI.Objective:SetText(Current.."%")
			else
				PercentObj.GUI.Objective:SetText(Current.."%/"..Target.."%")
			end	
			PercentObj.Type = "Percent"
			
			function PercentObj:Update(PercentRaw)
				self.PercentRaw = PercentRaw
				self.Percent = math.ceil(PercentRaw)
				if self.Percent >= self.Target then
					if self.Target == 0 then
						self.GUI.Objective:SetText(self.Percent.."%")
					else
						self.GUI.Objective:SetText(self.Percent.."%/"..self.Target.."%")
					end	
				end
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Percent[Name] = PercentObj
			KBM.PhaseMonitor.Objectives.Lists:Add(PercentObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				PercentObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				PercentObj.GUI.Frame:SetVisible(false)
			end						
		end
		
		function PhaseObj.Objectives:AddTime(Time)
		end
		
		function PhaseObj.Objectives:Remove(Name)		
			if Name then
				KBM.PhaseMonitor.Objectives.Lists:Remove(KBM.PhaseMonitor.Lists.All[Name])
			else
				for _, Object in ipairs(KBM.PhaseMonitor.Objectives.Lists.All) do
					Object.GUI.Frame:SetVisible(false)
					table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
				end
				for ListName, List in pairs(KBM.PhaseMonitor.Objectives.Lists) do
					if type(List) == "table" then
						KBM.PhaseMonitor.Objectives.Lists[ListName] = {}
					end
				end
				KBM.PhaseMonitor.Objectives.Lists.Count = 0
			end			
		end
		
		function PhaseObj:Start(Time)
			self.StartTime = math.floor(Time)
			self.Phase = self.DefaultPhase
			if KBM.PhaseMonitor.Settings.Enabled then
				if KBM.PhaseMonitor.Settings.PhaseDisplay then
					KBM.PhaseMonitor.Frame:SetVisible(true)
				end
			end
			KBM.PhaseMonitor.Active = true
			self:SetPhase(self.Phase)
			if KBM.PhaseMonitor.Anchor:GetVisible() then
				if KBM.PhaseMonitor.Settings.Enabled then
					KBM.PhaseMonitor.Anchor:SetVisible(false)
				else
					KBM.PhaseMonitor.Anchor.Text:SetVisible(false)
					KBM.PhaseMonitor.Anchor:SetBackgroundColor(0,0,0,0)
				end
			end
		end
		
		function PhaseObj:End(Time)
			self.Objectives:Remove()
			KBM.PhaseMonitor.Frame:SetVisible(false)
			KBM.PhaseMonitor.Active = false
			if KBM.PhaseMonitor.Anchor:GetVisible() then
				KBM.PhaseMonitor.Anchor.Text:SetVisible(true)
				KBM.PhaseMonitor.Anchor:SetBackgroundColor(0,0,0,0.33)
			else
				if KBM.PhaseMonitor.Settings.Visible then
					KBM.PhaseMonitor.Anchor:SetVisible(true)
				end
			end
		end
	
		self.Object = PhaseObj
		return PhaseObj
	end
	
	function self.Phase:Remove()	
	end
	
	function self.Anchor.Drag.Event:WheelForward()	
		local Change = false
		if KBM.PhaseMonitor.Settings.ScaleWidth then
			if KBM.PhaseMonitor.Settings.wScale < 1.6 then
				KBM.PhaseMonitor.Settings.wScale = KBM.PhaseMonitor.Settings.wScale + 0.02
				if KBM.PhaseMonitor.Settings.wScale > 1.6 then
					KBM.PhaseMonitor.Settings.wScale = 1.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.ScaleHeight then
			if KBM.PhaseMonitor.Settings.hScale < 1.6 then
				KBM.PhaseMonitor.Settings.hScale = KBM.PhaseMonitor.Settings.hScale + 0.02
				if KBM.PhaseMonitor.Settings.hScale > 1.6 then
					KBM.PhaseMonitor.Settings.hScale = 1.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.TextScale then
			if KBM.PhaseMonitor.Settings.tScale < 1.6 then
				KBM.PhaseMonitor.Settings.tScale = KBM.PhaseMonitor.Settings.tScale + 0.02
				if KBM.PhaseMonitor.Settings.tScale > 1.6 then
					KBM.PhaseMonitor.Settings.tScale = 1.6
				end
				Change = true
			end
		end
		
		if Change then
			KBM.PhaseMonitor:ApplySettings()
		end		
	end
	
	function self.Anchor.Drag.Event:WheelBack()	
		local Change = false
		if KBM.PhaseMonitor.Settings.ScaleWidth then
			if KBM.PhaseMonitor.Settings.wScale > 0.6 then
				KBM.PhaseMonitor.Settings.wScale = KBM.PhaseMonitor.Settings.wScale - 0.02
				if KBM.PhaseMonitor.Settings.wScale < 0.6 then
					KBM.PhaseMonitor.Settings.wScale = 0.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.ScaleHeight then
			if KBM.PhaseMonitor.Settings.hScale > 0.6 then
				KBM.PhaseMonitor.Settings.hScale = KBM.PhaseMonitor.Settings.hScale - 0.02
				if KBM.PhaseMonitor.Settings.hScale < 0.6 then
					KBM.PhaseMonitor.Settings.hScale = 0.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.TextScale then
			if KBM.PhaseMonitor.Settings.tScale > 0.6 then
				KBM.PhaseMonitor.Settings.tScale = KBM.PhaseMonitor.Settings.tScale - 0.02
				if KBM.PhaseMonitor.Settings.tScale < 0.6 then
					KBM.PhaseMonitor.Settings.tScale = 0.6
				end
				Change = true
			end
		end
		
		if Change then 
			KBM.PhaseMonitor:ApplySettings()
		end
	end
	self:ApplySettings()	
end

function KBM.EncTimer:Init()	
	self.TestMode = false
	self.Settings = KBM.Options.EncTimer
	self.Frame = UI.CreateFrame("Frame", "Encounter Timer", KBM.Context)
	self.Frame:SetLayer(5)
	self.Frame:SetBackgroundColor(0,0,0,0.33)
	self.Frame.Text = UI.CreateFrame("Text", "Encounter Text", self.Frame)
	self.Frame.Text:SetText("Time: 00m:00s")
	self.Frame.Text:SetPoint("CENTER", self.Frame, "CENTER")
	self.Enrage = {}
	self.Enrage.Frame = UI.CreateFrame("Frame", "Enrage Timer", KBM.Context)
	self.Enrage.Frame:SetPoint("TOPLEFT", self.Frame, "BOTTOMLEFT")
	self.Enrage.Frame:SetPoint("RIGHT", self.Frame, "RIGHT")
	self.Enrage.Frame:SetBackgroundColor(0,0,0,0.33)
	self.Enrage.Frame:SetLayer(5)
	self.Enrage.Text = UI.CreateFrame("Text", "Enrage Text", self.Enrage.Frame)
	self.Enrage.Text:SetText("Enrage in: 00m:00s")
	self.Enrage.Text:SetPoint("CENTER", self.Enrage.Frame, "CENTER")
	self.Enrage.Progress = UI.CreateFrame("Frame", "Enrage Progress", self.Enrage.Frame)
	self.Enrage.Progress:SetPoint("TOPLEFT", self.Enrage.Frame, "TOPLEFT")
	self.Enrage.Progress:SetPoint("BOTTOM", self.Enrage.Frame, "BOTTOM")
	self.Enrage.Progress:SetPoint("RIGHT", self.Enrage.Frame, 0, nil)
	self.Enrage.Progress:SetBackgroundColor(0.9,0,0,0.33)
	
	function self:ApplySettings()
		self.Frame:ClearAll()
		if not self.Settings.x then
			self.Frame:SetPoint("CENTERTOP", UIParent, "CENTERTOP")
		else
			self.Frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		end
		self.Frame:SetWidth(self.Settings.w * self.Settings.wScale)
		self.Frame:SetHeight(self.Settings.h * self.Settings.hScale)
		self.Enrage.Frame:SetHeight(self.Frame:GetHeight())
		self.Frame.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Enrage.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		if KBM.MainWin:GetVisible() then
			self.Frame:SetVisible(self.Settings.Visible)
			self.Enrage.Frame:SetVisible(self.Settings.Visible)
			self.Frame.Drag:SetVisible(self.Settings.Unlocked)
		else
			if self.Active then
				self.Frame:SetVisible(self.Settings.Enabled)
				if KBM.CurrentMod.Enrage then
					self.Enrage.Frame:SetVisible(self.Settings.Enrage)
				else
					self.Enrage.Frame:SetVisible(false)
				end
				self.Frame.Drag:SetVisible(false)
			else
				self.Frame:SetVisible(false)
				self.Enrage.Frame:SetVisible(false)
				self.Frame.Drag:SetVisible(false)
			end
		end
	end
	
	function self:UpdateMove(uType)	
		if uType == "end" then
			self.Settings.x = self.Frame:GetLeft()
			self.Settings.y = self.Frame:GetTop()
		end		
	end
	
	function self:Update(current)	
		local EnrageString = ""
		if self.Settings.Duration then
			self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
		end
		
		if self.Settings.Enrage then
			if KBM.CurrentMod.Enrage then
				if current < KBM.EnrageTime then
					EnrageString = KBM.ConvertTime(KBM.EnrageTime - current + 1)
					self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." "..EnrageString)
					self.Enrage.Progress:SetPoint("RIGHT", self.Enrage.Frame, KBM.TimeElapsed/KBM.CurrentMod.Enrage, nil)
				else
					self.Enrage.Text:SetText("!! Enraged !!")
					self.Enrage.Progress:SetPoint("RIGHT", self.Enrage.Frame, "RIGHT")
				end
			end
		end		
	end
	
	function self:Start(Time)	
		if self.Settings.Enabled then
			if self.Settings.Duration then
				self.Frame:SetVisible(true)
				self.Active = true
			end
			if self.Settings.Enrage then
				if KBM.CurrentMod.Enrage then
					self.Enrage.Frame:SetVisible(true)
					self.Enrage.Progress:SetPoint("RIGHT", self.Enrage.Frame, "LEFT")
					self.Active = true
				end
			end
			if self.Active then
				self:Update(Time)
			end
		end		
	end
	
	function self:TestUpdate()	
	end
	
	function self:End()	
		self.Active = false		
		self.Frame.Text:SetText("Time: 00m:00s")
		self.Enrage.Text:SetText("Enrage in: 00m:00s")
		self.Enrage.Progress:SetVisible(false)
	end
	
	function self:SetTest(bool)	
		if bool then
			self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00m:00s")
			self.Frame.Text:SetText(KBM.Language.Timers.Timer[KBM.Lang].." 00m:00s")
		end
		self.Frame:SetVisible(bool)
		self.Enrange:SetVisible(bool)		
	end
	
	self.Frame.Drag = KBM.AttachDragFrame(self.Frame, function (uType) self:UpdateMove(uType) end, "Enc Timer Drag", 2)
	function self.Frame.Drag.Event:WheelForward()	
		if KBM.EncTimer.Settings.ScaleWidth then
			if KBM.EncTimer.Settings.wScale < 1.6 then
				KBM.EncTimer.Settings.wScale = KBM.EncTimer.Settings.wScale + 0.02
				if KBM.EncTimer.Settings.wScale > 1.6 then
					KBM.EncTimer.Settings.wScale = 1.6
				end
				KBM.EncTimer.Frame:SetWidth(KBM.EncTimer.Settings.wScale * KBM.EncTimer.Settings.w)
			end
		end
		
		if KBM.EncTimer.Settings.ScaleHeight then
			if KBM.EncTimer.Settings.hScale < 1.6 then
				KBM.EncTimer.Settings.hScale = KBM.EncTimer.Settings.hScale + 0.02
				if KBM.EncTimer.Settings.hScale > 1.6 then
					KBM.EncTimer.Settings.hScale = 1.6
				end
				KBM.EncTimer.Frame:SetHeight(KBM.EncTimer.Settings.hScale * KBM.EncTimer.Settings.h)
				KBM.EncTimer.Enrage.Frame:SetHeight(KBM.EncTimer.Frame:GetHeight())
			end
		end
		
		if KBM.EncTimer.Settings.TextScale then
			if KBM.EncTimer.Settings.tScale < 1.6 then
				KBM.EncTimer.Settings.tScale = KBM.EncTimer.Settings.tScale + 0.02
				if KBM.EncTimer.Settings.tScale > 1.6 then
					KBM.EncTimer.Settings.tScale = 1.6
				end
				KBM.EncTimer.Frame.Text:SetFontSize(KBM.EncTimer.Settings.TextSize * KBM.EncTimer.Settings.tScale)
				KBM.EncTimer.Enrage.Text:SetFontSize(KBM.EncTimer.Settings.TextSize * KBM.EncTimer.Settings.tScale)
			end
		end		
	end
	
	function self.Frame.Drag.Event:WheelBack()	
		if KBM.EncTimer.Settings.ScaleWidth then
			if KBM.EncTimer.Settings.wScale > 0.6 then
				KBM.EncTimer.Settings.wScale = KBM.EncTimer.Settings.wScale - 0.02
				if KBM.EncTimer.Settings.wScale < 0.6 then
					KBM.EncTimer.Settings.wScale = 0.6
				end
				KBM.EncTimer.Frame:SetWidth(KBM.EncTimer.Settings.wScale * KBM.EncTimer.Settings.w)
			end
		end
		
		if KBM.EncTimer.Settings.ScaleHeight then
			if KBM.EncTimer.Settings.hScale > 0.6 then
				KBM.EncTimer.Settings.hScale = KBM.EncTimer.Settings.hScale - 0.02
				if KBM.EncTimer.Settings.hScale < 0.6 then
					KBM.EncTimer.Settings.hScale = 0.6
				end
				KBM.EncTimer.Frame:SetHeight(KBM.EncTimer.Settings.hScale * KBM.EncTimer.Settings.h)
				KBM.EncTimer.Enrage.Frame:SetHeight(KBM.EncTimer.Frame:GetHeight())
			end
		end
		
		if KBM.EncTimer.Settings.TextScale then
			if KBM.EncTimer.Settings.tScale > 0.6 then
				KBM.EncTimer.Settings.tScale = KBM.EncTimer.Settings.tScale - 0.02
				if KBM.EncTimer.Settings.tScale < 0.6 then
					KBM.EncTimer.Settings.tScale = 0.6
				end
				KBM.EncTimer.Frame.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Enrage.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
			end
		end
	end
	self:ApplySettings()	
end

function KBM.CheckActiveBoss(uDetails, UnitID)
	current = Inspect.Time.Real()
	if KBM.Options.Enabled then
		if (not KBM.Idle.Wait or (KBM.Idle.Wait == true and KBM.Idle.Until < current)) or KBM.Encounter then
			local BossObj = nil
			KBM.Idle.Wait = false
			if not KBM.BossID[UnitID] then
				if uDetails then
					if KBM_Boss[uDetails.name] then
						BossObj = KBM_Boss[uDetails.name]
					elseif KBM.SubBoss[uDetails.name] then
						BossObj = KBM.SubBoss[uDetails.name]
					end
					if BossObj then
						if KBM.Debug then
							print("Boss found Checking")
						end
						if uDetails.combat then
							if KBM.Debug then
								print("Boss matched checking encounter start")
							end
							--if uDetails.level == BossObj.Level then
								KBM.BossID[UnitID] = {}
								KBM.BossID[UnitID].name = uDetails.name
								KBM.BossID[UnitID].monitor = true
								KBM.BossID[UnitID].Mod = BossObj.Mod
								KBM.BossID[UnitID].IdleSince = false
								if uDetails.health > 0 then
									if KBM.Debug then
										print("Boss is alive and in combat, activating.")
									end
									KBM.BossID[UnitID].Combat = true
									KBM.BossID[UnitID].dead = false
									KBM.BossID[UnitID].available = true
									KBM.BossID[UnitID].PercentRaw = (uDetails.health/uDetails.healthMax)*100
									KBM.BossID[UnitID].Percent = math.ceil(KBM.BossID[UnitID].PercentRaw)
									KBM.BossID[UnitID].PercentLast = KBM.BossID[UnitID].Percent
									if not KBM.Encounter and not BossObj.Ignore then
										if KBM.Debug then
											print("New encounter, starting")
										end
										KBM.Encounter = true
										KBM.CurrentBoss = UnitID
										KBM_CurrentBossName = uDetails.name
										KBM.CurrentMod = KBM.BossID[UnitID].Mod
										if not KBM.CurrentMod.EncounterRunning then
											print(KBM.Language.Encounter.Start[KBM.Lang].." "..BossObj.Descript)
											print(KBM.Language.Encounter.GLuck[KBM.Lang])
											KBM.TimeElapsed = 0
											KBM.StartTime = math.floor(current)
											KBM.CurrentMod.Phase = 1
											KBM.Phase = 1
											if KBM.CurrentMod.Settings.EncTimer then
												if KBM.CurrentMod.Settings.EncTimer.Override then
													KBM.EncTimer.Settings = KBM.CurrentMod.Settings.EncTimer
												else
													KBM.EncTimer.Settings = KBM.Options.EncTimer
												end
											else
												KBM.EncTimer.Settings = KBM.Options.EncTimer
											end
											if KBM.CurrentMod.Settings.PhaseMon then
												if KBM.CurrentMod.Settings.PhaseMon.Override then
													KBM.PhaseMonitor.Settings = KBM.CurrentMod.Settings.PhaseMon
												else
													KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
												end
											else
												KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
											end
											if KBM.CurrentMod.Settings.MechTimer then
												if KBM.CurrentMod.Settings.MechTimer.Override then
													KBM.MechTimer.Settings = KBM.CurrentMod.Settings.MechTimer
												else
													KBM.MechTimer.Settings = KBM.Options.MechTimer
												end
											else
												KBM.MechTimer.Setting = KBM.Options.MechTimer
											end
											if KBM.CurrentMod.Settings.Alerts then
												if KBM.CurrentMod.Settings.Alerts.Override then
													KBM.Alert.Settings = KBM.CurrentMod.Settings.Alerts
												else
													KBM.Alert.Settings = KBM.Options.Alerts
												end
											else
												KBM.Alert.Settings = KBM.Options.Alerts
											end
											KBM.EncTimer:ApplySettings()
											KBM.PhaseMonitor:ApplySettings()
											KBM.MechTimer:ApplySettings()
											KBM.Alert:ApplySettings()
											if KBM.CurrentMod.Enrage then
												KBM.EnrageTime = KBM.StartTime + KBM.CurrentMod.Enrage
											end
											KBM.EncTimer:Start(KBM.StartTime)
										end
									end
									if BossObj.Mod.ID == KBM.CurrentMod.ID then
										KBM.BossID[UnitID].Boss = KBM.CurrentMod:UnitHPCheck(uDetails, UnitID)
									end
								else
									KBM.BossID[UnitID].Combat = false
									KBM.BossID[UnitID].dead = true
									KBM.BossID[UnitID].available = true
								end					
							--end
						end
					end
				end
			else
				if uDetails then
					if uDetails.health == 0 then
						KBM.BossID[UnitID].Combat = false
						KBM.BossID[UnitID].available = true
						if not KBM.BossID[UnitID].dead then
							KBM.BossID[UnitID].dead = true
						end
					end
				end
			end
		else
			if KBM.Debug then
				print("Encounter idle wait, skipping start.")
			end
			if KBM.Idle.Until < current then
				KBM.Idle.Wait = false
			end
		end
	end	
end

function KBM.CombatEnter(UnitID)
	if KBM.Options.Enabled then
		uDetails = Inspect.Unit.Detail(UnitID)
		if uDetails then
			if not uDetails.player then
				KBM.CheckActiveBoss(uDetails, UnitID)
			end
		end
	end	
end

function KBM.CombatLeave(UnitID)	
end

function KBM.MobDamage(info)
	if KBM.Options.Enabled then
		local tUnitID = info.target
		local tDetails = Inspect.Unit.Detail(tUnitID)
		local cUnitID = info.caster
		local cDetails = nil
		if cUnitID then
			cDetails = Inspect.Unit.Detail(cUnitID)
		end
		if KBM.Encounter then
			-- Check for damage done to the raid by Bosses
			if tUnitID then
				if tDetails then
					if KBM.CurrentMod then
						if info.abilityName then
							if KBM.Trigger.Damage[info.abilityName] then
								TriggerObj = KBM.Trigger.Damage[info.abilityName]
								KBM.Trigger.Queue:Add(TriggerObj, cUnitID, tUnitID)
							end
						end
					end	
				end
			end			
		else
			-- Encounter state is idle, check triggering methods.
			-- This is a fail-safe, and not usually used for Encounter starts.
			if cDetails then
				if not cDetails.player then
					if cDetails.combat then
						if cDetails.health > 0 then
							KBM.CheckActiveBoss(cDetails, cUnitID)
						end
					end
				end
			end		
		end
	end
end

function KBM.RaidDamage(info)
	-- Will be used for DPS Monitoring
	if KBM.Options.Enabled then
		local tUnitID = info.target
		local tDetails = Inspect.Unit.Detail(tUnitID)
		local cUnitID = info.caster
		local cDetails = nil
		if cUnitID then
			cDetails = Inspect.Unit.Detail(cUnitID)
		end
		if KBM.BossID[tUnitID] then
			-- Damage inflicted to a Boss Unit by the Raid.
			-- Update Health etc, checks done to bypass Unit.Health requiring available state.
			if tDetails then
				KBM.BossID[tUnitID].Health = tDetails.health
				KBM.BossID[tUnitID].PercentRaw = (tDetails.health/tDetails.healthMax)*100
				KBM.BossID[tUnitID].Percent = math.ceil(KBM.BossID[tUnitID].PercentRaw)
				if KBM.BossID[tUnitID].Percent ~= KBM.BossID[tUnitID].PercentLast then
					if KBM.Trigger.Percent[KBM.CurrentMod.ID] then
						if KBM.Trigger.Percent[KBM.CurrentMod.ID][tDetails.name] then
							if KBM.BossID[tUnitID].PercentLast - KBM.BossID[tUnitID].Percent > 1 then
								for PCycle = KBM.BossID[tUnitID].PercentLast, KBM.BossID[tUnitID].Percent, -1 do
									if KBM.Trigger.Percent[KBM.CurrentMod.ID][tDetails.name][PCycle] then
										TriggerObj = KBM.Trigger.Percent[KBM.CurrentMod.ID][tDetails.name][PCycle]
										KBM.Trigger.Queue:Add(TriggerObj, nil, tUnitID)
									end
								end
							else
								if KBM.Trigger.Percent[KBM.CurrentMod.ID][tDetails.name][KBM.BossID[tUnitID].Percent] then
									TriggerObj = KBM.Trigger.Percent[KBM.CurrentMod.ID][tDetails.name][KBM.BossID[tUnitID].Percent]
									KBM.Trigger.Queue:Add(TriggerObj, nil, tUnitID)
								end
							end
						end
					end
					KBM.BossID[tUnitID].PercentLast = KBM.BossID[tUnitID].Percent
				end
				-- Update Phase Monitor accordingly.
				if KBM.PhaseMonitor.Active then
					if KBM.PhaseMonitor.Objectives.Lists.Percent[tDetails.name] then
						KBM.PhaseMonitor.Objectives.Lists.Percent[tDetails.name]:Update(KBM.BossID[tUnitID].PercentRaw)
					end
				end
			end
		else
			if tDetails then
				if not tDetails.player then
					if tDetails.combat then
						if tDetails.health > 0 then
							KBM.CheckActiveBoss(tDetails, tUnitID)
						end
					end
				end
			end
		end
	end	
end

local function KBM_UnitAvailable(units)
	if KBM.Encounter then
		for UnitID, Specifier in pairs(units) do
			uDetails = Inspect.Unit.Detail(UnitID)
			if uDetails then
				if not uDetails.player then
					KBM.CheckActiveBoss(uDetails, UnitID)
				end
			end
		end
	end	
end

function KBM.AttachDragFrame(parent, hook, name, layer)
	if not name then name = "" end
	if not layer then layer = 0 end
	
	local Drag = {}
	Drag.Frame = UI.CreateFrame("Frame", "Drag Frame", parent)
	Drag.Frame:SetPoint("TOPLEFT", parent, "TOPLEFT")
	Drag.Frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT")
	Drag.Frame.parent = parent
	Drag.Frame.MouseDown = false
	Drag.Frame:SetLayer(layer)
	Drag.hook = hook
	
	function Drag.Frame.Event:LeftDown()
		self.MouseDown = true
		mouseData = Inspect.Mouse()
		self.MyStartX = self.parent:GetLeft()
		self.MyStartY = self.parent:GetTop()
		self.StartX = mouseData.x - self.MyStartX
		self.StartY = mouseData.y - self.MyStartY
		tempX = self.parent:GetLeft()
		tempY = self.parent:GetTop()
		tempW = self.parent:GetWidth()
		tempH =	self.parent:GetHeight()
		self.parent:ClearAll()
		self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", tempX, tempY)
		self.parent:SetWidth(tempW)
		self.parent:SetHeight(tempH)
		self:SetBackgroundColor(0,0,0,0.5)
		Drag.hook("start")
	end
	
	function Drag.Frame.Event:MouseMove(mouseX, mouseY)
		if self.MouseDown then
			self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", (mouseX - self.StartX), (mouseY - self.StartY))
		end
	end
	
	function Drag.Frame.Event:LeftUp()
		if self.MouseDown then
			self.MouseDown = false
			self:SetBackgroundColor(0,0,0,0)
			Drag.hook("end")
		end
	end
	
	function Drag.Frame:Remove()	
		self.Event.LeftDown = nil
		self.Event.MouseMove = nil
		self.Event.LeftUp = nil
		Drag.hook = nil
		self:sRemove()
		self.Remove = nil		
	end	
	return Drag.Frame
end

function KBM.TankSwap:Pull()
	local GUI = {}
	if #self.TankStore > 0 then
		GUI = table.remove(self.TankStore)
	else
		GUI.Frame = UI.CreateFrame("Frame", "TankSwap_Frame", KBM.Context)
		GUI.Frame:SetLayer(1)
		GUI.Frame:SetHeight(KBM.Options.TankSwap.h)
		GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		-- GUI.Overlay = UI.CreateFrame("Texture", "TankSwap_Overlay", GUI.Frame)
		-- GUI.Overlay:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
		-- GUI.Overlay:SetPoint("BOTTOMRIGHT", GUI.Frame, "BOTTOMRIGHT")
		-- GUI.Overlay:SetLayer(5)
		-- GUI.Overlay:SetTexture("KingMolinator", "Media/BarSkin.png")
		GUI.TankFrame = UI.CreateFrame("Frame", "TankSwap_Tank_Frame", GUI.Frame)
		GUI.TankFrame:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
		GUI.TankFrame:SetPoint("BOTTOM", GUI.Frame, "CENTERY")
		GUI.TankHP = UI.CreateFrame("Texture", "TankSwap_Tank_HPFrame", GUI.TankFrame)
		GUI.TankHP:SetTexture("KingMolinator", "Media/BarTexture.png")
		GUI.TankHP:SetLayer(1)
		GUI.TankHP:SetBackgroundColor(0,0.8,0,0.33)
		GUI.TankShadow = UI.CreateFrame("Text", "TankSwap_Tank_Shadow", GUI.TankFrame)
		GUI.TankShadow:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.TankShadow:SetLayer(2)
		GUI.TankShadow:SetFontColor(0,0,0)
		GUI.TankText = UI.CreateFrame("Text", "TankSwap_Tank_Text", GUI.TankFrame)
		GUI.TankText:SetLayer(3)
		GUI.TankText:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.TankShadow:SetPoint("TOPLEFT", GUI.TankText, "TOPLEFT", 1, 1)
		GUI.TankText:SetPoint("CENTERLEFT", GUI.TankFrame, "CENTERLEFT", 2, 0)	
		GUI.DebuffFrame = UI.CreateFrame("Texture", "TankSwap Debuff Frame", GUI.Frame)
		GUI.DebuffFrame:SetPoint("TOPRIGHT", GUI.Frame, "TOPRIGHT")
		GUI.DebuffFrame:SetPoint("BOTTOMRIGHT", GUI.Frame, "CENTERRIGHT")
		GUI.DebuffFrame:SetPoint("LEFT", GUI.Frame, 0.8, nil)
		GUI.DebuffFrame:SetBackgroundColor(0,0,0,0.33)
		GUI.DebuffFrame:SetLayer(1)
		GUI.DebuffFrame.Shadow = UI.CreateFrame("Text", "TankSwap_Debuff_Shadow", GUI.DebuffFrame)
		GUI.DebuffFrame.Shadow:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.DebuffFrame.Shadow:SetFontColor(0,0,0)
		GUI.DebuffFrame.Shadow:SetLayer(2)
		GUI.DebuffFrame.Text = UI.CreateFrame("Text", "TankSwap_Debuff_Text", GUI.DebuffFrame)
		GUI.DebuffFrame.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.DebuffFrame.Text:SetLayer(3)
		GUI.DebuffFrame.Shadow:SetPoint("TOPLEFT", GUI.DebuffFrame.Text, "TOPLEFT", 1, 1)
		GUI.DebuffFrame.Text:SetPoint("CENTER", GUI.DebuffFrame, "CENTER")
		GUI.TankFrame:SetPoint("TOPRIGHT", GUI.DebuffFrame, "TOPLEFT")
		GUI.TankHP:SetPoint("TOP", GUI.TankFrame, "TOP")
		GUI.TankHP:SetPoint("LEFT", GUI.TankFrame, "LEFT")
		GUI.TankHP:SetPoint("BOTTOM", GUI.TankFrame, "BOTTOM")
		GUI.TankHP:SetWidth(GUI.TankFrame:GetWidth())
		GUI.DeCoolFrame = UI.CreateFrame("Texture", "TankSwap_CDFrame", GUI.Frame)
		GUI.DeCoolFrame:SetPoint("TOPLEFT", GUI.TankFrame, "BOTTOMLEFT")
		GUI.DeCoolFrame:SetPoint("BOTTOM", GUI.Frame, "BOTTOM")
		GUI.DeCoolFrame:SetPoint("RIGHT", GUI.Frame, "RIGHT")
		GUI.DeCoolFrame:SetBackgroundColor(0,0,0,0.33)
		GUI.DeCool = UI.CreateFrame("Texture", "TankSwap_CD_Progress", GUI.DeCoolFrame)
		GUI.DeCool:SetTexture("KingMolinator", "Media/BarTexture.png")
		GUI.DeCool:SetPoint("TOPLEFT", GUI.DeCoolFrame, "TOPLEFT")
		GUI.DeCool:SetPoint("BOTTOM", GUI.DeCoolFrame, "BOTTOM")
		GUI.DeCool:SetWidth(0)
		GUI.DeCool:SetBackgroundColor(0.5,0,8,0.33)
		GUI.DeCool.Shadow = UI.CreateFrame("Text", "TankSwap_CD_Shadow", GUI.DeCoolFrame)
		GUI.DeCool.Shadow:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.DeCool.Shadow:SetFontColor(0,0,0)
		GUI.DeCool.Shadow:SetLayer(2)
		GUI.DeCool.Text = UI.CreateFrame("Text", "TankSwap_CD_Text", GUI.DeCoolFrame)
		GUI.DeCool.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.DeCool.Shadow:SetPoint("TOPLEFT", GUI.DeCool.Text, "TOPLEFT", 1, 1)
		GUI.DeCool.Text:SetPoint("CENTER", GUI.DeCoolFrame, "CENTER")
		GUI.DeCool.Text:SetLayer(3)
		GUI.Dead = UI.CreateFrame("Texture", "TankSwap_Dead", GUI.DebuffFrame)
		GUI.Dead:SetTexture("KingMolinator", "Media/KBM_Death.png")
		GUI.Dead:SetLayer(1)
		GUI.Dead:SetPoint("TOPLEFT", GUI.DebuffFrame, "TOPLEFT", 4, 1)
		GUI.Dead:SetPoint("BOTTOMRIGHT", GUI.DebuffFrame, "BOTTOMRIGHT", -4, -1)
		GUI.Dead:SetAlpha(0.8)
		function GUI:SetTank(Text)
			self.TankShadow:SetText(Text)
			self.TankText:SetText(Text)
		end
		function GUI:SetDeCool(Text)
			self.DeCool.Shadow:SetText(Text)
			self.DeCool.Text:SetText(Text)
		end
		function GUI:SetStack(Text)
			self.DebuffFrame.Shadow:SetText(Text)
			self.DebuffFrame.Text:SetText(Text)
		end
		function GUI:SetDeath(bool)
			if bool then
				self.TankText:SetAlpha(0.5)
				self.DebuffFrame.Shadow:SetVisible(false)
				self.DebuffFrame.Text:SetVisible(false)
				self.Dead:SetVisible(true)
				self.TankHP:SetVisible(false)
				self.DeCoolFrame:SetVisible(false)
			else
				self.TankText:SetAlpha(1)
				self.Dead:SetVisible(false)
				self.DebuffFrame.Shadow:SetVisible(true)
				self.DebuffFrame.Text:SetVisible(true)
				self.TankHP:SetVisible(true)
				self.DeCoolFrame:SetVisible(false)
			end			
		end
	end
	return GUI
end

function KBM.TankSwap:Init()

	self.Tanks = {}
	self.TankCount = 0
	self.Active = false
	self.DebuffID = nil
	self.LastTank = nil
	self.Test = false
	self.TankStore = {}
	self.Enabled = KBM.Options.TankSwap.Enabled
	
	self.Anchor = UI.CreateFrame("Frame", "Tank-Swap Anchor", KBM.Context)
	self.Anchor:SetWidth(KBM.Options.TankSwap.w * KBM.Options.TankSwap.wScale)
	self.Anchor:SetHeight(KBM.Options.TankSwap.h * KBM.Options.TankSwap.hScale)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Anchor:SetLayer(5)
	if KBM.Options.TankSwap.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.TankSwap.x, KBM.Options.TankSwap.y)
	else
		self.Anchor:SetPoint("CENTER", UIParent, "CENTER")
	end
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Options.TankSwap.x = self:GetLeft()
			KBM.Options.TankSwap.y = self:GetTop()
		end
	end
	self.Anchor.Text = UI.CreateFrame("Text", "TankSwap info", self.Anchor)
	self.Anchor.Text:SetText("Tank-Swap Anchor")
	self.Anchor.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "TS Anchor Drag", 2)
	if KBM.MainWin:GetVisible() then
		self.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
		self.Anchor.Drag:SetVisible(KBM.Options.TankSwap.Unlocked)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end
	
	function self:Add(UnitID, Test)		
		if self.Test and not Test then
			self:Remove()
			self.Anchor:SetVisible(false)
		end
		local TankObj = {}
		TankObj.UnitID = UnitID
		TankObj.DebuffID = nil
		TankObj.Test = Test
		self.Active = true
		TankObj.Stacks = 0
		TankObj.Remaining = 0
		TankObj.Dead = false
		
		if Test then
			TankObj.Name = Test
			TankObj.UnitID = Test
			self.Test = true
			TankObj.Dead = false
		else
			local uDetails = Inspect.Unit.Detail(UnitID)
			if uDetails then
				TankObj.Name = uDetails.name
				if uDetails.health then
					if uDetails.health > 0 then
						TankObj.Dead = false
					else
						TankObj.Dead = true
					end
				else
					TankObj.Dead = true
				end
			end
		end
		
		TankObj.GUI = KBM.TankSwap:Pull()
		TankObj.GUI:SetTank(TankObj.Name)
		
		if self.TankCount == 0 then
			TankObj.GUI.Frame:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
			TankObj.GUI.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
		else
			TankObj.GUI.Frame:SetPoint("TOPLEFT", self.LastTank.GUI.Frame, "BOTTOMLEFT", 0, 2)
			TankObj.GUI.Frame:SetPoint("RIGHT", self.LastTank.GUI.Frame, "RIGHT")
		end
		
		self.LastTank = TankObj
		self.Tanks[TankObj.UnitID] = TankObj
		self.TankCount = self.TankCount + 1
		
		function TankObj:BuffUpdate(DebuffID)
			self.DebuffID = DebuffID
		end
		
		function TankObj:Death()
			self.Dead = true
			self.GUI:SetDeath(true)
		end
		
		function TankObj:UpdateHP()
			local uDetails = Inspect.Unit.Detail(self.UnitID)
			local HPMax = 1
			local HPCurrent = 1
			local HPPer = 1.0
			if uDetails then
				if uDetails.health then
					HPCurrent = uDetails.health
					if HPCurrent > 0 then
						if self.Dead then
							self.GUI:SetDeath(false)
							self.Dead = false
						end
						--if uDetails.healthCap then
						--	HPMax = uDetails.healthCap
						--else
							HPMax = uDetails.healthMax
						--end
						HPPer = HPCurrent / HPMax
						self.GUI.TankHP:SetWidth(self.GUI.TankFrame:GetWidth() * HPPer)
					else
						if not self.Dead then
							self:Death()
						end
					end
				else
					if not self.Dead then
						self:Death()
					end
				end
			end
		end
		TankObj.GUI:SetDeath(TankObj.Dead)
		if self.Test then
			TankObj.GUI:SetStack("2")
			TankObj.GUI:SetDeCool("99.9")
			TankObj.GUI.DeCoolFrame:SetVisible(true)
			TankObj.GUI.DeCool:SetWidth(TankObj.GUI.DeCoolFrame:GetWidth())
			TankObj.GUI.TankHP:SetWidth(TankObj.GUI.TankFrame:GetWidth())
		else
			TankObj.GUI:SetStack("")
			TankObj.GUI:SetDeCool("")
		end
		TankObj.GUI.Frame:SetVisible(true)
		return TankObj		
	end
	
	function self:Start(DebuffName, DebuffID)	
		if self.Enabled then
			local Spec = ""
			local UnitID = ""
			local uDetails = nil
			self.DebuffID = DebuffID
			self.DebuffName = DebuffName
			if LibSRM.Grouped() then
				for i = 1, 20 do
					Spec, UnitID = LibSRM.Group.Inspect(i)
					if UnitID then
						uDetails = Inspect.Unit.Detail(UnitID)
						if uDetails then
							if uDetails.role == "tank" then
								self:Add(UnitID)
							end
						end
					end
				end
			end
		end		
	end
	
	function self:Update()	
		local uDetails = ""
		for UnitID, TankObj in pairs(self.Tanks) do
			if TankObj.DebuffID then
				bDetails = Inspect.Buff.Detail(UnitID, TankObj.DebuffID)
				if bDetails then
					if bDetails.name == self.DebuffName then
						if bDetails.stack then
							TankObj.Stacks = bDetails.stack
						else
							TankObj.Stacks = 1
						end
						TankObj.Remaining = bDetails.remaining
						TankObj.Duration = bDetails.duration
						TankObj.GUI:SetDeCool(string.format("%0.01f", TankObj.Remaining))
						TankObj.GUI.DeCool:SetWidth(TankObj.GUI.DeCoolFrame:GetWidth() * (TankObj.Remaining/TankObj.Duration))
						TankObj.GUI.DeCoolFrame:SetVisible(true)
						TankObj.GUI:SetStack(tostring(TankObj.Stacks))
					end
				else
					TankObj.DebuffID = nil
					TankObj.Remaing = 0
					TankObj.Duration = 0
					TankObj.GUI.DeCoolFrame:SetVisible(false)
					TankObj.GUI.DeCool:SetWidth(0)
					TankObj.GUI:SetDeCool("")
					TankObj.GUI:SetStack("")
				end
			end
			TankObj:UpdateHP()
		end	
	end
	
	function self:Remove()	
		for UnitID, TankObj in pairs(self.Tanks) do
			table.insert(self.TankStore, TankObj.GUI)
			TankObj.GUI.Frame:SetVisible(false)
			TankObj.GUI = nil
		end
		self.Active = false
		self.Tanks = {}
		self.LastTank = nil
		self.TankCount = 0
		self.Test = false		
	end	
end

function KBM.Alert:Init()
	function self:ApplySettings()
		self.Anchor:ClearAll()
		if self.Settings.x then
			self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		else
			self.Anchor:SetPoint("CENTERX", UIParent, "CENTERX")
			self.Anchor:SetPoint("CENTERY", UIParent, nil, 0.25)
		end	
		self.Notify = self.Settings.Notify
		self.Flash = self.Settings.Flash
		self.Enabled = self.Settings.Enabled
		if KBM.MainWin:GetVisible() then
			self.Anchor:SetVisible(self.Settings.Visible)
			self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
			self.Left.red:SetVisible(self.Settings.Visible)
			self.Right.red:SetVisible(self.Settings.Visible)
			if self.Settings.Visible then
				self.AlertControl.Left:SetVisible(self.Settings.FlashUnlocked)
				self.AlertControl.Right:SetVisible(self.Settings.FlashUnlocked)
			end
		else
			self.Anchor:SetVisible(false)
			self.Anchor.Drag:SetVisible(false)
			self.Left.red:SetVisible(false)
			self.Right.red:SetVisible(false)
			self.AlertControl.Left:SetVisible(false)
			self.AlertControl.Right:SetVisible(false)
		end
	end

	self.List = {}
	self.Settings = KBM.Options.Alerts
	self.Anchor = UI.CreateFrame("Frame", "Alert Text Anchor", KBM.Context)
	self.Anchor:SetBackgroundColor(0,0,0,0)
	self.Anchor:SetLayer(5)
	self.Shadow = UI.CreateFrame("Text", "Alert Text Outline", self.Anchor)
	self.Shadow:SetFontColor(0,0,0)
	self.Shadow:SetLayer(1)
	self.Text = UI.CreateFrame("Text", "Alert Text", self.Anchor)
	self.Shadow:SetPoint("CENTER", self.Text, "CENTER", 2, 2)
	self.Text:SetFontSize(32)
	self.Text:SetText(" Alert Anchor ")
	self.Shadow:SetText(self.Text:GetText())
	self.Shadow:SetFontSize(self.Text:GetFontSize())
	self.Text:SetFontColor(1,1,1)
	self.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Text:SetLayer(2)
	self.Anchor:SetWidth(self.Text:GetWidth())
	self.Anchor:SetHeight(self.Text:GetHeight())
	self.Anchor:SetVisible(self.Settings.Visible)
	self.ColorList = {"red", "blue", "yellow", "orange", "purple", "dark_green"}
	self.Left = {}
	self.Right = {}
	self.Count = 0
	self.AlertControl = {}
	self.AlertControl.Left = UI.CreateFrame("Frame", "Left_Alert_Controller", KBM.Context)
	self.AlertControl.Left:SetVisible(false)
	self.AlertControl.Left:SetLayer(2)
	self.AlertControl.Left:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
	self.AlertControl.Left:SetPoint("BOTTOM", UIParent, "BOTTOM")
	self.AlertControl.Right = UI.CreateFrame("Frame", "Right_Alert_Controller", KBM.Context)
	self.AlertControl.Right:SetVisible(false)
	self.AlertControl.Right:SetLayer(2)
	self.AlertControl.Right:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")
	self.AlertControl.Right:SetPoint("BOTTOM", UIParent, "BOTTOM")
	
	for _t, Color in ipairs(self.ColorList) do
		self.Left[Color] = UI.CreateFrame("Texture", "Left_Alert "..Color, KBM.Context)
		self.Left[Color]:SetTexture("KingMolinator", "Media/Alert_Left_"..Color..".png")
		self.Left[Color]:SetPoint("TOPLEFT", self.AlertControl.Left, "TOPLEFT")
		self.Left[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Left, "BOTTOMRIGHT")
		self.Left[Color]:SetVisible(false)
		self.Right[Color] = UI.CreateFrame("Texture", "Right_Alert"..Color, KBM.Context)
		self.Right[Color]:SetTexture("KingMolinator", "Media/Alert_Right_"..Color..".png")
		self.Right[Color]:SetPoint("TOPLEFT", self.AlertControl.Right, "TOPLEFT")
		self.Right[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Right, "BOTTOMRIGHT")
		self.Right[Color]:SetVisible(false)
	end
	
	self.AlertControl.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
	self.AlertControl.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
	
	function self.AlertControl:WheelBack()
		if KBM.Alert.Settings.fScale < 1.5 then
			KBM.Alert.Settings.fScale = KBM.Alert.Settings.fScale + 0.05
			if KBM.Alert.Settings.fScale > 1.5 then
				KBM.Alert.Settings.fScale = 1.5
			end
			self.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
			self.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
		end
	end
	
	function self.AlertControl:WheelForward()
		if KBM.Alert.Settings.fScale > 0.25 then
			KBM.Alert.Settings.fScale = KBM.Alert.Settings.fScale - 0.05
			if KBM.Alert.Settings.fScale < 0.25 then
				KBM.Alert.Settings.fScale = 0.25
			end
			self.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
			self.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
		end	
	end
	
	function self.AlertControl.Left.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Left.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	function self.AlertControl.Right.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Right.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	self.Current = nil
	self.StopTime = 0
	self.Remaining = 0
	self.Alpha = 1
	self.Queue = {}
	self.Speed = 0.025
	self.Direction = -self.Speed
	self.Color = "red"
	
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Alert.Settings.x = self:GetLeft()
			KBM.Alert.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Alert Anchor Drag", 2)
	self.Anchor.Drag:SetLayer(3)
	
	function self:Create(Text, Duration, Flash, Countdown, Color)
		AlertObj = {}
		AlertObj.DefDuration = Duration
		AlertObj.Duration = Duration
		AlertObj.Flash = Flash
		if not Color then
			AlertObj.Color = self.Color
		else
			AlertObj.Color = Color
		end
		AlertObj.Text = Text
		AlertObj.Countdown = Countdown
		AlertObj.Enabled = true
		AlertObj.AlertAfter = nil
		AlertObj.isImportant = false
		AlertObj.HasMenu = true
		AlertObj.Type = "alert"
		if type(Text) ~= "string" then
			error("Expecting String for Text, got: "..type(Text))
		end
		if not self.Left[AlertObj.Color] then
			error("Alert:Create() Invalid color supplied:- "..AlertObj.Color)
		end
		
		function AlertObj:AlertEnd(endAlertObj)
			if type(endAlertObj) == "table" then
				if endAlertObj.Type == "alert" then
					self.AlertAfter = endAlertObj
				else
					error("KBM.Alert:AlertEnd - Expecting Alert Object: Got "..tostring(endAlertObj.Type))
				end
			else
				error("KBM.Alert:AlertEnd - Expecting at least table: Got "..tostring(type(endAlertObj)))
			end
		end
		
		function AlertObj:TimerEnd(endTimerObj)
			if type(endTimerObj) == "table" then
				if endTimerObj.Type == "timer" then
					self.TimerAfter = endTimerObj
				else
					error("KBM.Alert:TimerEnd - Expecting Timer Object: Got "..tostring(endTimerObj.Type))
				end
			else
				error("KBM.Alert:TimerEnd - Expecting at least table: Got "..tostring(type(endTimerObj)))
			end
		end

		function AlertObj:Important()
			self.isImportant = true
		end
		
		function AlertObj:NoMenu()
			self.HasMenu = false
			self.Enabled = true
		end
		
		self.Count = self.Count + 1
		table.insert(self.List, AlertObj)
		return AlertObj		
	end
	
	function self:Start(AlertObj, CurrentTime, Duration)		
		if self.Settings.Enabled then
			if AlertObj.Enabled then
				if self.Starting then
					return
				end
				if self.Active then
					if self.Current.Active then
						if self.Current.isImportant then
							return
						end
						self.Starting = true
						if not self.Current.Stopping then
							self:Stop()
						end
					end
				end
				self.Starting = true
				AlertObj.Active = true
				self.Duration = AlertObj.Duration
				if Duration then
					if not AlertObj.DefDuration then
						self.Duration = Duration
					end
				else
					if not AlertObj.DefDuration then
						self.Duration = 2
					end
				end
				self.Current = AlertObj
				AlertObj.Duration = self.Duration
				self.Alpha = 1
				if self.Settings.Flash then
					if not AlertObj.Settings then
						self.Color = AlertObj.Color
						AlertObj.Settings = KBM.Defaults.AlertObj()
					else
						if AlertObj.Settings.Custom then
							self.Color = AlertObj.Settings.Color
						else
							self.Color = AlertObj.Color
						end
					end
					self.Left[self.Color]:SetAlpha(1)
					self.Left[self.Color]:SetVisible(true)
					self.Right[self.Color]:SetAlpha(1)
					self.Right[self.Color]:SetVisible(true)
					self.Direction = -self.Speed
				end
				if self.Settings.Notify then
					if AlertObj.Text then
						self.Shadow:SetText(AlertObj.Text)
						self.Text:SetText(AlertObj.Text)
						self.Anchor:SetVisible(true)
						self.Anchor:SetAlpha(1)
					end
				end
				if self.Duration then
					self.StopTime = CurrentTime + AlertObj.Duration
					self.Remaining = self.StopTime - CurrentTime
				else
					self.StopTime = 0
				end
				self.Active = true
				self.Starting = false
				self:Update(CurrentTime)
			end
		end
	end
	
	function self:Stop(SpecObj)
		if (self.Current and not SpecObj) or (self.Current and SpecObj == self.Current) then
			if self.Current.Active then
				self.Current.Stopping = true
				self.Left[self.Color]:SetVisible(false)
				self.Right[self.Color]:SetVisible(false)
				self.Anchor:SetVisible(false)
				self.Shadow:SetText(" Alert Anchor ")
				self.Text:SetText(" Alert Anchor ")
				self.StopTime = 0
				self.Current.Active = false
				self.Current.Stopping = false
				self.Active = false
				if self.Current.AlertAfter and not self.Starting then
					if KBM.Encounter then
						KBM.Alert:Start(self.Current.AlertAfter, Inspect.Time.Real())
					end
				end
				if self.Current.TimerAfter then
					if KBM.Encounter then
						KBM.MechTimer:AddStart(self.Current.TimerAfter)
					end
				end
			end
		end
	end	
	
	function self:Update(CurrentTime)
		if self.Current.Stopping then
			if self.Alpha <= 0.1 then -- lag threshold
				self:Stop()
			else
				self.Alpha = self.Alpha + self.Direction
				if self.Settings.Flash then
					self.Left[self.Color]:SetAlpha(self.Alpha)
					self.Right[self.Color]:SetAlpha(self.Alpha)
				end
				if self.Settings.Notify then
					self.Anchor:SetAlpha(self.Alpha)
				end
			end
		else
			if self.Settings.Flash then
				if self.Current.Flash then
					self.Alpha = self.Alpha + self.Direction
					if self.Alpha <= 0.2 then
						self.Alpha = 0.2
						self.Direction = self.Speed
					elseif self.Alpha >= 1 then
						self.Alpha = 1
						self.Direction = -self.Speed
					end
					self.Left[self.Color]:SetAlpha(self.Alpha)
					self.Right[self.Color]:SetAlpha(self.Alpha)
				end
			end
			if self.Current.Countdown then
				if self.Remaining then
					self.Remaining = self.StopTime - CurrentTime
					if self.Remaining <= 0 then
						self.Remaining = 0
						self.Shadow:SetText(self.Current.Text)
						self.Text:SetText(self.Current.Text)
					else
						CDText = string.format("%0.1f - "..self.Current.Text, self.Remaining)
						self.Shadow:SetText(CDText)
						self.Text:SetText(CDText)
					end
				end
			end
			if self.StopTime then
				if self.StopTime <= CurrentTime then
					self.Direction = -self.Speed
					self.Current.Stopping = true
				end
			end
		end
	end
	self:ApplySettings()	
end

function KBM.CastBar:Init()
	self.Settings = KBM.Options.CastBar

	self.CastBarList = {}
	self.ActiveCastBars = {}
	self.RemoveCastBars = {}
	self.WaitCastBars = {}
	self.StartCastBars = {}
	self.Store = {}	
	self.ActiveCount = 0

	function self:Pull(Anchor)	
		local GUI = {}
		if #self.Store > 0 then
			GUI = table.remove(self.Store)
			GUI.Frame:SetVisible(false)
		else
			GUI.Frame = UI.CreateFrame("Frame", "CastBar Frame", KBM.Context)
			GUI.Frame:SetWidth(self.Settings.w * self.Settings.wScale)
			GUI.Frame:SetHeight(self.Settings.h * self.Settings.hScale)
			GUI.Frame:SetLayer(2)
			GUI.Progress = UI.CreateFrame("Frame", "CastBar Progress Frame", GUI.Frame)
			GUI.Progress:SetWidth(0)
			GUI.Shadow = UI.CreateFrame("Text", "Timer_Text_Shadow", GUI.Frame)
			GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
			GUI.Shadow:SetPoint("CENTER", GUI.Frame, "CENTER", 2, 2)
			GUI.Shadow:SetLayer(2)
			GUI.Shadow:SetFontColor(0,0,0)
			GUI.Shadow:SetMouseMasking("limited")
			GUI.Text = UI.CreateFrame("Text", "Castbar Text", GUI.Frame)
			GUI.Progress:SetLayer(1)
			GUI.Text:SetLayer(3)
			GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
			GUI.Text:SetPoint("CENTER", GUI.Frame, "CENTER")
			GUI.Progress:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
			GUI.Progress:SetPoint("BOTTOM", GUI.Frame, "BOTTOM")
			GUI.Frame:SetBackgroundColor(0,0,0,0.3)
			GUI.Progress:SetBackgroundColor(1,0,0,0.5)
			GUI.Frame:SetVisible(false)
			GUI.Texture = UI.CreateFrame("Texture", "Timer_Skin", GUI.Frame)
			GUI.Texture:SetTexture("KingMolinator", "Media/BarSkin.png")
			GUI.Texture:SetAlpha(self.Settings.TextureAlpha)
			GUI.Texture:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
			GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Frame, "BOTTOMRIGHT")
			GUI.Texture:SetLayer(4)
			GUI.Texture:SetMouseMasking("limited")
			
			function GUI:Update(uType)
				if uType == "end" then
					self.CastBarObj.Settings.x = self.Drag:GetLeft()
					self.CastBarObj.Settings.y = self.Drag:GetTop()
				end
			end			
			GUI.Drag = KBM.AttachDragFrame(GUI.Frame, function(uType) GUI:Update(uType) end , "CB Live Drag", 2)
			GUI.Drag.GUI = GUI
			
			function GUI:SetText(Text)
				self.Shadow:SetText(Text)
				self.Text:SetText(Text)
			end
			function GUI.Drag.Event:WheelForward()
			
				if self.GUI.CastBarObj.Settings.ScaleWidth then
					if self.GUI.CastBarObj.Settings.wScale < 1.5 then
						self.GUI.CastBarObj.Settings.wScale = self.GUI.CastBarObj.Settings.wScale + 0.025
						if self.GUI.CastBarObj.Settings.wScale > 1.5 then
							self.GUI.CastBarObj.Settings.wScale = 1.5
						end
						self.GUI.Frame:SetWidth(self.GUI.CastBarObj.Settings.wScale * self.GUI.CastBarObj.Settings.w)
					end
				end
				if self.GUI.CastBarObj.Settings.ScaleHeight then
					if self.GUI.CastBarObj.Settings.hScale < 1.5 then
						self.GUI.CastBarObj.Settings.hScale =self.GUI.CastBarObj.Settings.hScale + 0.025
						if self.GUI.CastBarObj.Settings.hScale > 1.5 then
							self.GUI.CastBarObj.Settings.hScale = 1.5
						end
						self.GUI.Frame:SetHeight(self.GUI.CastBarObj.Settings.hScale * self.GUI.CastBarObj.Settings.h)
					end
				end
				if self.GUI.CastBarObj.Settings.TextScale then
					if self.GUI.CastBarObj.Settings.tScale < 1.5 then
						self.GUI.CastBarObj.Settings.tScale = self.GUI.CastBarObj.Settings.tScale + 0.025
						if self.GUI.CastBarObj.Settings.tScale > 1.5 then
							self.GUI.CastBarObj.Settings.tScale = 1.5
						end
						self.GUI.Text:SetFontSize(self.GUI.CastBarObj.Settings.TextSize * self.GUI.CastBarObj.Settings.tScale)
						self.GUI.Shadow:SetFontSize(self.GUI.CastBarObj.Settings.TextSize * self.GUI.CastBarObj.Settings.tScale)
					end
				end
				
			end
			function GUI.Drag.Event:WheelBack()
				
				if self.GUI.CastBarObj.Settings.ScaleWidth then
					if self.GUI.CastBarObj.Settings.wScale > 0.5 then
						self.GUI.CastBarObj.Settings.wScale = self.GUI.CastBarObj.Settings.wScale - 0.025
						if self.GUI.CastBarObj.Settings.wScale < 0.5 then
							self.GUI.CastBarObj.Settings.wScale = 0.5
						end
						self.GUI.Frame:SetWidth(self.GUI.CastBarObj.Settings.wScale * self.GUI.CastBarObj.Settings.w)
					end
				end
				if self.GUI.CastBarObj.Settings.ScaleHeight then
					if self.GUI.CastBarObj.Settings.hScale > 0.5 then
						self.GUI.CastBarObj.Settings.hScale = self.GUI.CastBarObj.Settings.hScale - 0.025
						if self.GUI.CastBarObj.Settings.hScale < 0.5 then
							self.GUI.CastBarObj.Settings.hScale = 0.5
						end
						self.GUI.Frame:SetHeight(self.GUI.CastBarObj.Settings.hScale * self.GUI.CastBarObj.Settings.h)
					end
				end
				if self.GUI.CastBarObj.Settings.TextScale then
					if self.GUI.CastBarObj.Settings.tScale > 0.5 then
						self.GUI.CastBarObj.Settings.tScale = self.GUI.CastBarObj.Settings.tScale - 0.025
						if self.GUI.CastBarObj.Settings.tScale < 0.5 then
							self.GUI.CastBarObj.Settings.tScale = 0.5
						end
						self.GUI.Text:SetFontSize(self.GUI.CastBarObj.Settings.tScale * self.GUI.CastBarObj.Settings.TextSize)
						self.GUI.Shadow:SetFontSize(self.GUI.CastBarObj.Settings.TextSize * self.GUI.CastBarObj.Settings.tScale)
					end
				end
			end		
		end
		return GUI
		
	end
	
	self.Anchor = self:Add(KBM, {Name = "Global Castbar"}, true)
	self.Anchor.Anchor = true
	
end

function KBM.CastBar:Add(Mod, Boss, Enabled)

	local CastBarObj = {}
	CastBarObj.UnitID = nil
	CastBarObj.Boss = Boss
	CastBarObj.Filters = Boss.CastFilters
	CastBarObj.HasFilters = Boss.HasCastFilters
	if Boss.Settings then
		CastBarObj.Settings = Boss.Settings.CastBar
	end
	if not CastBarObj.Settings then
		if Mod.Settings then
			if Mod.Settings.CastBar then
				if Mod.Settings.CastBar.Override then
					CastBarObj.Settings = Mod.Settings.CastBar
				else
					CastBarObj.Settings = self.Settings
				end
			else
				CastBarObj.Settings = self.Settings
			end
		else
			CastBarObj.Settings = self.Settings
		end
	end	
	CastBarObj.Casting = false
	CastBarObj.LastCast = ""
	CastBarObj.Enabled = CastBarObj.Settings.Enabled
	CastBarObj.Mod = Mod
	CastBarObj.Active = false
	CastBarObj.Anchor = false
	
	function CastBarObj:ManageSettings()
		if not self.Anchor then
			if self.Boss.Settings then
				if self.Boss.Settings.CastBar then
					if self.Boss.Settings.CastBar.Override then
						self.Settings = self.Boss.Settings.CastBar
					else
						self.Settings = KBM.Options.CastBar
					end
				else
					self.Settings = KBM.Options.CastBar
				end
			else
				self.Settings = KBM.Options.CastBar
			end
		end
	end
	
	function CastBarObj:ApplySettings()
	
		self.GUI.Frame:ClearAll()
		if not self.Settings.x then
			self.GUI.Frame:SetPoint("CENTER", UIParent, 0.5, 0.7)
		else
			self.GUI.Frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		end
		self.GUI.Frame:SetWidth(self.Settings.w * self.Settings.wScale)
		self.GUI.Frame:SetHeight(self.Settings.h * self.Settings.hScale)
		self.GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.GUI.Shadow:SetVisible(self.Settings.Shadow)
		self.GUI.Texture:SetVisible(self.Settings.Texture)
		self.GUI.Progress:SetWidth(0)
		self.GUI:SetText(self.Boss.Name)
		if self.Settings.Enabled then
			if KBM.MainWin:GetVisible() then
				self.GUI.Frame:SetVisible(self.Settings.Visible)
			else
				self.GUI.Frame:SetVisible(false)
			end
		end
		if not self.Settings.Pinned then
			if KBM.MainWin:GetVisible() then
				self.GUI.Drag:SetVisible(self.Settings.Unlocked)
			end
		else
			self.GUI.Drag:SetVisible(false)
		end
	end
	
	function CastBarObj:Display()	
	
		self:ManageSettings()
		if KBM.MainWin:GetVisible() then
			if self.Settings.Visible and self.Settings.Enabled then
				self.Visible = true
				if not self.GUI then
					self.GUI = KBM.CastBar:Pull(true)
					self.GUI.CastBarObj = self
					self:ApplySettings()
				end
				self.GUI.Frame:SetVisible(true)
				if not self.Settings.Pinned then
					self.GUI.Drag:SetVisible(true)
				else
					self.GUI.Drag:SetVisible(false)
					if self.Boss.PinCastBar then
						self.Boss:PinCastBar()
					end
				end
			end
		end
	end
	
	function CastBarObj:Create(UnitID)
	
		self:ManageSettings()
		self.UnitID = UnitID
		self.LastCast = ""
		
		if not self.GUI then
			self.GUI = KBM.CastBar:Pull()
			self.GUI.CastBarObj = self
			self:ApplySettings()
		end
		if self.Settings.Pinned then
			if self.Boss.PinCastBar then
				self.Boss:PinCastBar()
			end
		end
		KBM.CastBar.ActiveCastBars[UnitID] = self
		self.Active = true
		
	end
	function CastBarObj:Start()
	
		self.Casting = true
		self.GUI.Frame:SetVisible(true)
		self.GUI.Progress:SetVisible(true)
		
	end
	function CastBarObj:Update()
	
		bDetails = Inspect.Unit.Castbar(self.UnitID)
		if bDetails then
			if bDetails.abilityName then
				if self.Settings.Enabled then
					if self.HasFilters then
						if self.Filters[bDetails.abilityName] then
							FilterObj = self.Filters[bDetails.abilityName]
							if FilterObj.Enabled then
								if not self.Casting then
									if FilterObj.Custom then
										self.GUI.Progress:SetBackgroundColor(KBM.Colors.List[FilterObj.Color].Red, KBM.Colors.List[FilterObj.Color].Green, KBM.Colors.List[FilterObj.Color].Blue, 0.33)
									else
										if self.Settings.Custom then
											self.GUI.Progress:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
										else
											self.GUI.Progress:SetBackgroundColor(1, 0, 0, 0.33)
										end
									end
									if FilterObj.Count then
										FilterObj.Prefix = KBM.Numbers.GetPlace(FilterObj.Current).." "
										if FilterObj.Current < FilterObj.Count then
											FilterObj.Current = FilterObj.Current + 1
										else
											FilterObj.Current = 1
										end
									else
										FilterObj.Prefix = ""
									end
									self.CastTime = bDetails.duration
									self.Progress = bDetails.remaining						
									self.GUI.Progress:SetWidth(self.GUI.Frame:GetWidth() * (1-(self.Progress/self.CastTime)))
									self.GUI:SetText(string.format("%0.01f", self.Progress).." - "..FilterObj.Prefix..bDetails.abilityName)
									self:Start()
								else
									self.CastTime = bDetails.duration
									self.Progress = bDetails.remaining						
									self.GUI.Progress:SetWidth(self.GUI.Frame:GetWidth() * (1-(self.Progress/self.CastTime)))
									self.GUI:SetText(string.format("%0.01f", self.Progress).." - "..FilterObj.Prefix..bDetails.abilityName)	
								end
							else
								self:Stop()
								self.Casting = false
							end
						else
							if not self.Casting then
								self:Start()
								if self.Custom then
									self.GUI.Progress:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
								else
									self.GUI.Progress:SetBackgroundColor(1, 0, 0, 0.33)
								end
							end
							self.CastTime = bDetails.duration
							self.Progress = bDetails.remaining
							self.GUI.Progress:SetWidth(self.GUI.Frame:GetWidth() * (1-(self.Progress/self.CastTime)))
							self.GUI:SetText(string.format("%0.01f", self.Progress).." - "..bDetails.abilityName)
						end
					else
						if not self.Casting then
							self:Start()
							if self.Custom then
								self.GUI.Progress:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
							else
								self.GUI.Progress:SetBackgroundColor(1, 0, 0, 0.33)
							end
						end
						self.CastTime = bDetails.duration
						self.Progress = bDetails.remaining
						self.GUI.Progress:SetWidth(self.GUI.Frame:GetWidth() * (1-(self.Progress/self.CastTime)))
						self.GUI:SetText(string.format("%0.01f", self.Progress).." - "..bDetails.abilityName)
					end
				end
				if self.LastCast ~= bDetails.abilityName then
					self.LastCast = bDetails.abilityName
					if KBM.Trigger.Cast[bDetails.abilityName] then
						if KBM.Trigger.Cast[bDetails.abilityName][self.Boss.Name] then
							TriggerObj = KBM.Trigger.Cast[bDetails.abilityName][self.Boss.Name]
							KBM.Trigger.Queue:Add(TriggerObj, nil, nil, bDetails.remaining)
						end
					end
				end
			else
				self:Stop()
				self.Casting = false
			end
		else
			if self.Casting or (self.LastCast ~= "") then
				if self.Progress then
					if self.Progress > 0.05 then
					-- if Inspect.Unit.Lookup(self.UnitID) then
						-- Interrupt
					-- end
					end
				end
				self:Stop()
				self.Casting = false
			end
		end
		
	end
	function CastBarObj:Stop()
	
		self.Casting = false
		self.LastCast = ""
		self.GUI:SetText(self.Boss.Name)
		self.GUI.Frame:SetVisible(false)
		self.Duration = 0
		self.CastTime = 0
		
	end
	function CastBarObj:Hide()
	
		if self.Visible then
			self.Visible = false
			if not self.Active then
				self.GUI.CastBarObj = nil
				self.GUI.Frame:SetVisible(false)
				table.insert(KBM.CastBar.Store, self.GUI)
				self.GUI = nil
			else
				self.GUI.Frame:SetVisible(false)
				self.GUI.Drag:SetVisible(false)
			end
		end
	
	end
	function CastBarObj:Remove()
	
		if self.UnitID then
			KBM.CastBar.ActiveCastBars[self.UnitID] = nil
		end
		self.UnitID = nil
		self.Active = false
		if not self.Settings.Visible or not KBM.MainWin:GetVisible() then
			if self.GUI then
				self.GUI.CastBarObj = nil
				self.GUI.Frame:SetVisible(false)
				table.insert(KBM.CastBar.Store, self.GUI)
				self.GUI = nil
			end
		end
		
	end
	self[Boss.Name] = CastBarObj
	if not self.CastBarList[Mod.ID] then
		self.CastBarList[Mod.ID] = {}
	end
	table.insert(self.CastBarList[Mod.ID], CastBarObj)
	return self[Boss.Name]

end

local function KBM_Reset()

	if KBM.Encounter then
		KBM.Idle.Wait = true
		KBM.Idle.Until = Inspect.Time.Real() + KBM.Idle.Duration
		KBM.Idle.Combat.Wait = false
		KBM.Encounter = false
		if KBM.CurrentMod then
			KBM.CurrentMod:Reset()
			KBM.CurrentMod = nil
			KBM.CurrentBoss = ""
			KBM_CurrentBossName = ""
		end
		KBM.BossID = {}
		KBM.TimeElapsed = 0
		KBM.TimeStart = 0
		KBM.EnrageTime = 0
		KBM.EnrageTimer = 0
		if KBM.EncTimer.Active then
			KBM.EncTimer:End()
		end
		if KBM.TankSwap.Active then
			KBM.TankSwap:Remove()
		end
		if KBM.Alert.Current then
			KBM.Alert:Stop()
		end
		if #KBM.MechTimer.ActiveTimers > 0 then
			for i, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
				KBM.MechTimer:AddRemove(Timer)
			end
			if #KBM.MechTimer.RemoveTimers > 0 then
				for i, Timer in ipairs(KBM.MechTimer.RemoveTimers) do
					Timer:Stop()
				end
			end
			KBM.MechTimer.RemoveTimers = {}
			KBM.MechTimer.ActiveTimers = {}
			KBM.MechTimer.StartTimers = {}
		end
		KBM.Trigger.Queue:Remove()
		KBM.EncTimer.Settings = KBM.Options.EncTimer
		KBM.EncTimer:ApplySettings()
		KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
		KBM.PhaseMonitor:ApplySettings()
		KBM.MechTimer.Settings = KBM.Options.MechTimer
		KBM.MechTimer:ApplySettings()
		KBM.Alert.Settings = KBM.Options.Alerts
		KBM.Alert:ApplySettings()
	else
		print("No encounter to reset.")
	end

end

function KBM.ConvertTime(Time)

	Time = math.floor(Time)
	local TimeString = "00"
	local TimeSeconds = 0
	local TimeMinutes = 0
	local TimeHours = 0
	if Time > 59 then
		TimeMinutes = math.floor(Time / 60)
		TimeSeconds = Time - (TimeMinutes * 60)
		if TimeMinutes > 59 then
			TimeHours = math.floor(TimeMinutes / 60)
			TimeMinutes = TimeMinutes - (TimeHours * 60)
			TimeString = string.format("%d:%02d:%02d", TimeHours, TimeMinutes, TimeSeconds)
		else
			TimeString = string.format("%02d:%02d", TimeMinutes, TimeSeconds)
		end
	else
		TimeString = string.format("%02d", Time)
	end
	return TimeString
	
end

function KBM:RaidCombatEnter()

	if KBM.Debug then
		print("Raid has entered combat")
	end
	if KBM.Idle.Combat.Wait then
		KBM.Idle.Combat.Wait = false
	end
	
end

function KBM.WipeIt()

	KBM.Idle.Combat.Wait = false
	if KBM.Encounter then
		KBM.TimeElapsed = KBM.Idle.Combat.StoreTime
		print(KBM.Language.Encounter.Wipe[KBM.Lang])
		print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
		KBM_Reset()
	end
	
end

function KBM:RaidCombatLeave()

	if KBM.Debug then
		print("Raid has left combat")
	end
	if KBM.Options.Enabled then
		if KBM.Encounter then
			if KBM.Debug then
				print("Possible Wipe, waiting raid out of combat")
			end
			KBM.Idle.Combat.Wait = true
			KBM.Idle.Combat.Until = Inspect.Time.Real() + KBM.Idle.Combat.Duration
			KBM.Idle.Combat.StoreTime = KBM.TimeElapsed
		end
	end
	
end

function KBM:Timer()

	if not KBM.Updating then
		KBM.Updating = true
		if KBM.QueuePage then
			if KBM.MainWin.CurrentPage then
				if KBM.MainWin.CurrentPage.Type == "encounter" then
					KBM.MainWin.CurrentPage:ClearPage()
				else
					KBM.MainWin.CurrentPage:Remove()
				end
			end
		end
		
		if KBM.Options.Enabled then
			if KBM.Encounter or KBM.Testing then
				local current = Inspect.Time.Real()
				local diff = (current - self.HeldTime)
				local udiff = (current - self.UpdateTime)
				if KBM.CurrentMod then
					KBM.CurrentMod:Timer(current, diff)
				end
				if diff >= 1 then
					self.LastElapsed = self.TimeElapsed
					self.TimeElapsed = math.floor(current) - self.StartTime
					if not KBM.Testing then
						if KBM.CurrentMod.Enrage then
							self.EnrageTimer = self.EnrageTime - math.floor(current)
						end
						if self.Options.EncTimer.Enabled then
							self.EncTimer:Update(current)
						end
					end
					self.HeldTime = current - (diff - math.floor(diff))
					self.UpdateTime = current
					if not KBM.Testing then
						if self.Trigger.Time[KBM.CurrentMod.ID] then
							for TimeCheck = (self.LastElapsed + 1), self.TimeElapsed do
								if self.Trigger.Time[KBM.CurrentMod.ID][TimeCheck] then
									self.Trigger.Time[KBM.CurrentMod.ID][TimeCheck]:Activate(current)
								end
							end
						end
					end
				end
				if udiff >= 0.05 then
					for UnitID, CastCheck in pairs(KBM.CastBar.ActiveCastBars) do
						CastCheck:Update()
					end
					for i, Timer in ipairs(self.MechTimer.ActiveTimers) do
						Timer:Update(current)
					end
					self.UpdateTime = current
					if not KBM.TankSwap.Test then
						if KBM.TankSwap.Active then
							KBM.TankSwap:Update()
						end
					end
				end
				self.Trigger.Queue:Activate()
				if self.MechTimer.RemoveCount > 0 then
					for i, Timer in ipairs(self.MechTimer.RemoveTimers) do
						Timer:Stop()
					end
					self.MechTimer.RemoveTimers = {}
					self.MechTimer.RemoveCount = 0
				end
				if self.MechTimer.StartCount > 0 then
					for i, Timer in ipairs(self.MechTimer.StartTimers) do
						Timer:Start(current, "From StartTimers list")
					end
					self.MechTimer.StartTimers = {}
					self.MechTimer.StartCount = 0
				end
				if self.Alert.Active then
					self.Alert:Update(current)
				end
				if KBM.Idle.Combat.Wait then
					if KBM.Idle.Combat.Until < current then
						KBM.WipeIt()
					end
				end
			end
				-- for UnitID, CastCheck in pairs(KBM.CastBar.List) do
					-- CastCheck:Update()
				-- end
				-- if KBM.Testing then
					-- if self.Alert.Current then
						-- self.Alert:Update(Inspect.Time.Real())
					-- end
				-- end
			if KBM.Testing then
				-- Random Triggers
				-- d = math.random(1,2000)
				-- if d < 20 then
					-- d = math.random(1, #KBM.Trigger.List)
					-- if KBM.Trigger.List[d].Type ~= "phase" and KBM.Trigger.List[d].Type ~= "percent" then
						-- KBM.Trigger.Queue:Add(KBM.Trigger.List[d], KBM.Player.UnitID, KBM.Player.UnitID, 2)
					-- end
				-- end
				-- Cycle All Alerts
				-- if not KBM.NextAlert then
					-- KBM.NextAlert = 1
				-- end
				-- if not KBM.Alert.Current then
					-- KBM.Alert.List[KBM.NextAlert].Enabled = true
					-- KBM.Alert:Start(KBM.Alert.List[KBM.NextAlert], Inspect.Time.Real(), 2)
					-- KBM.NextAlert = KBM.NextAlert + 1
					-- if KBM.NextAlert > KBM.Alert.Count then
						-- KBM.NextAlert = 1
					-- end
				-- end
			end
		end
		if KBM.QueuePage then
			if KBM.QueuePage.Type == "encounter" then
				KBM.QueuePage:SetPage()
			else
				KBM.QueuePage:Open()
			end
			KBM.QueuePage = nil
		end
		KBM.Updating = false
	end
	
end

local function KBM_CastBar(units)
	
end

local function KM_ToggleEnabled(result)
	
end

local function KBM_UnitRemoved(units)

	-- if KBM.Encounter then
		-- for UnitID, Specifier in pairs(units) do
			-- if not Inspect.Unit.Detail(UnitID) then
				-- if KBM.BossID[UnitID] then
					-- if KBM.CurrentMod then
						-- KBM.BossID[UnitID].available = false
						-- KBM.BossID[UnitID].IdleSince = Inspect.Time.Real()
					-- end
				-- end
			-- end
		-- end
	-- end
	
end

function KBM.GroupDeath(UnitID)

	if KBM.Options.Enabled then
		if KBM.Encounter then
			if KBM.TankSwap.Active then
				if KBM.TankSwap.Tanks[UnitID] then
					KBM.TankSwap.Tanks[UnitID]:Death()
				end
			end
		end
	end

end

local function KBM_Death(UnitID)
	
	if KBM.Options.Enabled then 
		if KBM.Encounter then
			if UnitID then
				if KBM.BossID[UnitID] then
					KBM.BossID[UnitID].dead = true
					if KBM.PhaseMonitor.Active then
						if KBM.PhaseMonitor.Objectives.Lists.Death[KBM.BossID[UnitID].name] then
							KBM.PhaseMonitor.Objectives.Lists.Death[KBM.BossID[UnitID].name]:Kill()
						end
					end
					if KBM.CurrentMod:Death(UnitID) then
						print(KBM.Language.Encounter.Victory[KBM.Lang])
						print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(Inspect.Time.Real() - KBM.StartTime))
						KBM_Reset()
					end
				end
			end
		end
	end
	
end

local function KBM_Help()
	print("King Boss Mods in game slash commands")
	print("/kbmon -- Turns the Addon to it's on state.")
	print("/kbmoff -- Switches the Addon off.")
	print("/kbmreset -- Resets the current encounter.")
	print("/kbmversion -- Displays the current version.")
	print("/kbmoptions -- Toggles the GUI Options screen.")
	print("/kbmhelp -- Displays what you're reading now :)")
end

function KBM.Notify(data)

	if KBM.Debug then
		print("Notify Capture;")
		dump(data)
	end

	if KBM.Options.Enabled then
		if KBM.Encounter then
			if data.message then
				if KBM.CurrentMod then
					if KBM.Trigger.Notify[KBM.CurrentMod.ID] then
						for i, TriggerObj in ipairs(KBM.Trigger.Notify[KBM.CurrentMod.ID]) do
							sStart, sEnd, Target = string.find(data.message, TriggerObj.Phrase)
							if sStart then
								unitID = nil
								if Target == KBM.Player.Name then
									unitID = KBM.Player.UnitID
								end
								KBM.Trigger.Queue:Add(TriggerObj, nil, unitID)
								break
							end
						end
					end
				end
			end
		end
	end
	
end

function KBM.NPCChat(data)

	if KBM.Debug then
		print("Chat Capture;")
		dump(data)
	end

	if KBM.Options.Enabled then
		if KBM.Encounter then
			if data.fromName then
				if KBM.CurrentMod then
					if KBM.Trigger.Say[KBM.CurrentMod.ID] then
						for i, TriggerObj in ipairs(KBM.Trigger.Say[KBM.CurrentMod.ID]) do
							if TriggerObj.Unit.Name == data.fromName then
								sStart, sEnd, Target = string.find(data.message, TriggerObj.Phrase)
								if sStart then
									KBM.Trigger.Queue:Add(TriggerObj)
									break
								end
							end
						end
					end
				end
			end
		end
	end
	
end

function KBM:BuffMonitor(unitID, Buffs, Type)

	-- Used to manage Triggers and soon Tank-Swap managing.
	if KBM.Options.Enabled then
		if KBM.Encounter then
			if Type == "new" then
				if unitID then
					for buffID, bool in pairs(Buffs) do
						bDetails = Inspect.Buff.Detail(unitID, buffID)
						if bDetails then
							if KBM.Trigger.Buff[KBM.CurrentMod.ID] then
								if KBM.Trigger.Buff[KBM.CurrentMod.ID][bDetails.name] then
									TriggerObj = KBM.Trigger.Buff[KBM.CurrentMod.ID][bDetails.name]
									if TriggerObj.Unit.UnitID == unitID then
										KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, bDetails.remaining)
									end
								end
							elseif KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID] then
								if KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID][bDetails.name] then
									TriggerObj = KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID][bDetails.name]
									if LibSRM.Group.UnitExists(unitID) then
										KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, bDetails.remaining)
									end
								end
							end
							if KBM.TankSwap.Active then
								if KBM.TankSwap.Tanks[unitID] then
									if KBM.TankSwap.DebuffName == bDetails.name then
										KBM.TankSwap.Tanks[unitID]:BuffUpdate(buffID)
									end
								end
							end
						end
					end
				end
			elseif Type == "remove" then
				if unitID then
					for BuffID, bool in pairs(Buffs) do
						bDetails = Inspect.Buff.Detail(unitID, BuffID)
						if bDetails then
							if KBM.Trigger.BuffRemove[KBM.CurrentMod.ID] then
								if KBM.Trigger.BuffRemove[KBM.CurrenMod.ID][bDetails.name] then
									TriggerObj = KBM.Trigger.BuffRemove[KBM.CurrentMod.ID][bDetails.name]
									if TriggerObj.Unit.UnitID == unitID then
										KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
									end
								end
							elseif KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID] then
								if KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID][bDetails.name] then
									TriggerObj = KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID][bDetails.name]
									if LibSRM.Group.UnitExists(unitID) then
										KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
end

local function KBM_Version()
	print("You are running:")
	print("King Boss Mods v"..AddonData.toc.Version)
end

function KBM.StateSwitch(bool)
	KBM.Options.Enabled = bool
	if KBM.Options.Enabled then
		print("King Boss Mods is now Enabled.")
	else
		print("King Boss Mods is now Disabled.")
		if KBM.Encounter then
			print("Stopping running Encounter.")
			KBM_Reset()
		end
	end
end

---------------------------------------------
-----          Menu Options            ------
---------------------------------------------
-- Phase Monitor options.
function KBM.MenuOptions.Phases:Options()
	
	-- Phase Monitor Callbacks.
	function self:Enabled(bool)
		KBM.Options.PhaseMon.Enabled = bool
		if KBM.Options.PhaseMon.Visible then
			if bool then
				KBM.PhaseMonitor.Anchor:SetVisible(true)
			else
				KBM.PhaseMonitor.Anchor:SetVisible(false)
			end
		end
	end
	function self:Visible(bool)
		KBM.Options.PhaseMon.Visible = bool
		KBM.PhaseMonitor.Anchor:SetVisible(bool)
		KBM.Options.PhaseMon.Unlocked = bool
		KBM.PhaseMonitor.Anchor.Drag:SetVisible(bool)
	end
	function self:PhaseDisplay(bool)
		KBM.Options.PhaseMon.PhaseDisplay = bool
	end
	function self:Objectives(bool)
		KBM.Options.PhaseMon.Objectives = bool
	end
	function self:ScaleWidth(bool)
		KBM.Options.PhaseMon.ScaleWidth = bool
	end
	function self:ScaleHeight(bool)
		KBM.Options.PhaseMon.ScaleHeight = bool
	end
	function self:TextScale(bool)
		KBM.Options.PhaseMon.TextScale = bool
	end
	
	local Options = self.MenuItem.Options
	Options:SetTitle()
	
	-- Timer Options
	local PhaseMon = Options:AddHeader(KBM.Language.Options.PhaseEnabled[KBM.Lang], self.Enabled, KBM.Options.PhaseMon.Enabled)
	PhaseMon:AddCheck(KBM.Language.Options.Phases[KBM.Lang], self.PhaseDisplay, KBM.Options.PhaseMon.PhaseDisplay)
	PhaseMon:AddCheck(KBM.Language.Options.Objectives[KBM.Lang], self.Objectives, KBM.Options.PhaseMon.Objectives)
	PhaseMon:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.Visible, KBM.Options.PhaseMon.Visible)
	PhaseMon:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.ScaleWidth, KBM.Options.PhaseMon.ScaleWidth)
	PhaseMon:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.ScaleHeight, KBM.Options.PhaseMon.ScaleHeight)
	PhaseMon:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.TextScale, KBM.Options.PhaseMon.TextScale)
	
end

-- Timer options.
function KBM.MenuOptions.Timers:Options()
	
	-- Encounter Timer callbacks.
	function self:EncTimersEnabled(bool)
		KBM.Options.EncTimer.Enabled = bool
	end
	function self:ShowEncTimer(bool)
		KBM.Options.EncTimer.Visible = bool
		KBM.EncTimer.Frame:SetVisible(bool)
		KBM.EncTimer.Enrage.Frame:SetVisible(bool)
		KBM.Options.EncTimer.Unlocked = bool
		KBM.EncTimer.Frame.Drag:SetVisible(bool)
	end
	function self:EncDuration(bool)
		KBM.Options.EncTimer.Duration = bool
	end
	function self:EncEnrage(bool)
		KBM.Options.EncTimer.Enrage = bool
	end
	function self:EncScaleHeight(bool, Check)
		KBM.Options.EncTimer.ScaleHeight = bool
	end
	function self:EncScaleWidth(bool, Check)
		KBM.Options.EncTimer.ScaleWidth = bool
	end
	function self:EncTextSize(bool, Check)
		KBM.Options.EncTimer.TextScale = bool
	end
	
	-- Timer Callbacks
	function self:MechEnabled(bool)
		KBM.Options.MechTimer.Enabled = bool
	end
	function self:MechShadow(bool)
		KBM.Options.MechTimer.Shadow = bool
	end
	function self:MechTexture(bool)
		KBM.Options.MechTimer.Texture = bool
	end
	function self:ShowMechAnchor(bool)
		KBM.Options.MechTimer.Visible = bool
		KBM.MechTimer.Anchor:SetVisible(bool)
		KBM.Options.MechTimer.Unlocked = bool
		KBM.MechTimer.Anchor.Drag:SetVisible(bool)
		if #KBM.MechTimer.ActiveTimers > 0 then
			KBM.MechTimer.Anchor.Text:SetVisible(false)
		else
			if bool then
				KBM.MechTimer.Anchor.Text:SetVisible(true)
			end
		end
	end
	function self:MechScaleHeight(bool, Check)
		KBM.Options.MechTimer.ScaleHeight = bool
	end
	function self:MechScaleWidth(bool, Check)
		KBM.Options.MechTimer.ScaleWidth = bool
	end
	function self:MechTextSize(bool, Check)
		KBM.Options.MechTimer.TextScale = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	
	-- Timer Options
	local Timers = Options:AddHeader(KBM.Language.Options.EncTimers[KBM.Lang], self.EncTimersEnabled, KBM.Options.EncTimer.Enabled)
	Timers:AddCheck(KBM.Language.Options.Timer[KBM.Lang], self.EncDuration, KBM.Options.EncTimer.Duration)
	Timers:AddCheck(KBM.Language.Options.Enrage[KBM.Lang], self.EncEnrage, KBM.Options.EncTimer.Enrage)
	Timers:AddCheck(KBM.Language.Options.ShowTimer[KBM.Lang], self.ShowEncTimer, KBM.Options.EncTimer.Visible)
	Timers:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.EncScaleWidth, KBM.Options.EncTimer.ScaleWidth)
	Timers:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.EncScaleHeight, KBM.Options.EncTimer.ScaleHeight)
	Timers:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.EncTextSize, KBM.Options.EncTimer.TextScale)
	local MechTimers = Options:AddHeader(KBM.Language.Options.MechanicTimers[KBM.Lang], self.MechEnabled, true)
	MechTimers.GUI.Check:SetEnabled(false)
	KBM.Options.MechTimer.Enabled = true
	MechTimers:AddCheck(KBM.Language.Options.Texture[KBM.Lang], self.MechTexture, KBM.Options.MechTimer.Texture)
	MechTimers:AddCheck(KBM.Language.Options.Shadow[KBM.Lang], self.MechShadow, KBM.Options.MechTimer.Shadow)
	MechTimers:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowMechAnchor, KBM.Options.MechTimer.Visible)
	MechTimers:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.MechScaleWidth, KBM.Options.MechTimer.ScaleWidth)
	MechTimers:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.MechScaleHeight, KBM.Options.MechTimer.ScaleHeight)
	MechTimers:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.MechTextSize, KBM.Options.MechTimer.TextScale)
	
end

-- Tank-Swap Close link.
function KBM.MenuOptions.TankSwap:Close()
	if KBM.TankSwap.Active then
		if KBM.TankSwap.Test then
			self.TestCheck.GUI.Check:SetChecked(false)
		end
	end
end

-- Tank Swap options.
function KBM.MenuOptions.TankSwap:Options()

	function self:Enabled(bool)
		KBM.Options.TankSwap.Enabled = bool
		KBM.TankSwap.Enabled = bool
	end
	function self:ShowAnchor(bool)
		KBM.Options.TankSwap.Visible = bool
		if not KBM.TankSwap.Active then
			KBM.TankSwap.Anchor:SetVisible(bool)
		end
	end
	function self:LockAnchor(bool)
		KBM.Options.TankSwap.Unlocked = bool
		KBM.TankSwap.Anchor.Drag:SetVisible(bool)
	end
	function self:ScaleWidth(bool, Check)
		KBM.Options.TankSwap.ScaleWidth = bool
		if not bool then
			KBM.Options.TankSwap.wScale = 1
			--Check.SliderObj.Bar.Frame:SetPosition(100)
			KBM.TankSwap.Anchor:SetWidth(KBM.Options.TankSwap.w)
		end
	end
	function self:wScaleChange(value)
		KBM.Options.TankSwap.wScale = value * 0.01
		KBM.TankSwap.Anchor:SetWidth(KBM.Options.TankSwap.w * KBM.Options.TankSwap.wScale)
	end
	function self:ScaleHeight(bool, Check)
		KBM.Options.TankSwap.ScaleHeight = bool
		if not bool then
			KBM.Options.TankSwap.hScale = 1
			--Check.SliderObj.Bar.Frame:SetPosition(100)
			KBM.TankSwap.Anchor:SetHeight(KBM.Options.TankSwap.h)
		end
	end
	function self:hScaleChange(value)
		KBM.Options.TankSwap.hScale = value * 0.01
		KBM.TankSwap.Anchor:SetHeight(KBM.Options.TankSwap.h * KBM.Options.TankSwap.hScale)
	end
	function self:TextSize(bool, Check)
		KBM.Options.TankSwap.TextScale = bool
		if not bool then
			KBM.Options.TankSwap.TextSize = 16
			--Check.Slider.Bar:SetPosition(KBM.Options.CastBar.TextSize)
			KBM.TankSwap.Anchor.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
		end
	end
	function self:TextChange(value)
		KBM.Options.TankSwap.TextSize = value
		KBM.CastBar.Anchor.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
	end
	function self:ShowTest(bool)
		if bool then
			KBM.TankSwap:Add("Dummy", "Tank A")
			KBM.TankSwap:Add("Dummy", "Tank B")
			KBM.TankSwap:Add("Dummy", "Tank C")
			KBM.TankSwap.Anchor:SetVisible(false)
		else
			KBM.TankSwap:Remove()
			KBM.TankSwap.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
		end
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()

	-- Tank-Swap Options. 
	local TankSwap = Options:AddHeader(KBM.Language.Options.TankSwapEnabled[KBM.Lang], self.Enabled, KBM.Options.TankSwap.Enabled)
	TankSwap:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowAnchor, KBM.Options.TankSwap.Visible)
	TankSwap:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.LockAnchor, KBM.Options.TankSwap.Unlocked)
	self.TestCheck = TankSwap:AddCheck(KBM.Language.Options.Tank[KBM.Lang], self.ShowTest, false)
	-- self.CastBars:AddCheck("Width scaling.", self.CastScaleWidth, KBM.Options.CastBar.ScaleWidth)
	-- self.CastBars:AddCheck("Height scaling.", self.CastScaleHeight, KBM.Options.CastBar.ScaleHeight)
	-- self.CastBars:AddCheck("Text Size", self.CastTextSize, KBM.Options.CastBar.TextScale)

end

-- Castbar options
function KBM.MenuOptions.CastBars:Options()

	-- Castbar Callbacks
	function self:Enabled(bool)
		KBM.Options.CastBar.Enabled = bool
	end
	function self:Texture(bool)
		KBM.Options.CastBar.Texture = bool
		if KBM.CastBar.Anchor.GUI then
			KBM.CastBar.Anchor.GUI.Texture:SetVisible(bool)
		end
	end
	function self:Shadow(bool)
		KBM.Options.CastBar.Shadow = bool
		if KBM.CastBar.Anchor.GUI then
			KBM.CastBar.Anchor.GUI.Shadow:SetVisible(bool)
		end
	end
	function self:Visible(bool)
		KBM.Options.CastBar.Visible = bool
		KBM.Options.CastBar.Unlocked = bool
		if bool then
			KBM.CastBar.Anchor:Display()
		else
			KBM.CastBar.Anchor:Hide()
		end
	end
	function self:Width(bool)
		KBM.Options.CastBar.ScaleWidth = bool
	end
	function self:Height(bool)
		KBM.Options.CastBar.ScaleHeight = bool
	end
	function self:Text(bool)
		KBM.Options.CastBar.TextScale = bool
	end
	
	local Options = self.MenuItem.Options
	Options:SetTitle()

	-- CastBar Options. 
	local CastBars = Options:AddHeader(KBM.Language.Options.CastbarEnabled[KBM.Lang], self.Enabled, KBM.Options.CastBar.Enabled)
	CastBars:AddCheck(KBM.Language.Options.Texture[KBM.Lang], self.Texture, KBM.Options.CastBar.Texture)
	CastBars:AddCheck(KBM.Language.Options.Shadow[KBM.Lang], self.Shadow, KBM.Options.CastBar.Shadow)
	CastBars:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.Visible, KBM.Options.CastBar.Visible)
	CastBars:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.Width, KBM.Options.CastBar.ScaleWidth)
	CastBars:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.Height, KBM.Options.CastBar.ScaleHeight)
	CastBars:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.Text, KBM.Options.CastBar.TextScale)

end

-- Alert options.
function KBM.MenuOptions.Alerts:Options()

	function self:AlertEnabled(bool)
		KBM.Options.Alerts.Enabled = bool
	end
	function self:ShowAnchor(bool)
		KBM.Options.Alerts.Visible = bool
		KBM.Alert.Anchor:SetVisible(bool)
		KBM.Alert.Left.red:SetVisible(bool)
		KBM.Alert.Right.red:SetVisible(bool)
		if bool then
			KBM.Alert.AlertControl.Left:SetVisible(KBM.Options.Alerts.FlashUnlocked)
			KBM.Alert.AlertControl.Right:SetVisible(KBM.Options.Alerts.FlashUnlocked)
		else
			KBM.Alert.AlertControl.Left:SetVisible(false)
			KBM.Alert.AlertControl.Right:SetVisible(false)
		end
		if bool then
			KBM.Alert.Anchor:SetAlpha(1)
			KBM.Alert.Left.red:SetAlpha(1)
			KBM.Alert.Right.red:SetAlpha(1)
		end
	end
	function self:LockAnchor(bool)
		KBM.Options.Alerts.Unlocked = bool
		KBM.Alert.Anchor.Drag:SetVisible(bool)
	end
	function self:UnlockFlash(bool)
		KBM.Options.Alerts.FlashUnlocked = bool
		if KBM.Options.Alerts.Visible then
			KBM.Alert.AlertControl.Left:SetVisible(bool)
			KBM.Alert.AlertControl.Right:SetVisible(bool)
		end
	end
	function self:FlashEnabled(bool)
		KBM.Options.Alerts.Flash = bool
	end
	function self:TextEnabled(bool)
		KBM.Options.Alerts.Notify = bool
	end
	
	local Options = self.MenuItem.Options
	Options:SetTitle()

	local Alert = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.AlertEnabled, KBM.Options.Alerts.Enabled)
	Alert:AddCheck(KBM.Language.Options.AlertFlash[KBM.Lang], self.FlashEnabled, KBM.Options.Alerts.Flash)
	Alert:AddCheck(KBM.Language.Options.AlertText[KBM.Lang], self.TextEnabled, KBM.Options.Alerts.Notify)
	Alert:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowAnchor, KBM.Options.Alerts.Visible)
	Alert:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.LockAnchor, KBM.Options.Alerts.Unlocked)
	Alert:AddCheck(KBM.Language.Options.UnlockFlash[KBM.Lang], self.UnlockFlash, KBM.Options.Alerts.FlashUnlocked)
	
end

-- Main options.
function KBM.MenuOptions.Main:Options()

	function self:Character(bool)
		KBM.Options.Character = bool
		if bool then
			KBM_GlobalOptions = KBM.Options
			KBM.Options = chKBM_GlobalOptions
			KBM.Options.Character = true
			for _, Mod in ipairs(KBM.ModList) do
				if Mod.SwapSettings then
					Mod:SwapSettings(bool)
				end
			end
		else
			chKBM_GlobalOptions = KBM.Options
			KBM.Options = KBM_GlobalOptions
			KBM.Options.Character = false
			for _, Mod in ipairs(KBM.ModList) do
				if Mod.SwapSettings then
					Mod:SwapSettings(bool)
				end
			end
		end
	end
	function self:Enabled(bool)
		KBM.StateSwitch(bool)
	end
	function self:ButtonVisible(bool)
		KBM.Options.Button.Visible = bool
		KBM.Button.Texture:SetVisible(bool)
	end
	function self:LockButton(bool)
		KBM.Options.Button.Unlocked = bool
		KBM.Button.Drag:SetVisible(bool)
	end

	local Options = self.MenuItem.Options
	Options:SetTitle()

	local Character = Options:AddHeader(KBM.Language.Options.Character[KBM.Lang], self.Character, KBM.Options.Character)
	local Enabled = Options:AddHeader(KBM.Language.Options.ModEnabled[KBM.Lang], self.Enabled, KBM.Options.Enabled)
	local Button = Options:AddHeader(KBM.Language.Options.Button[KBM.Lang], self.ButtonVisible, KBM.Options.Button.Visible)
	Button:AddCheck(KBM.Language.Options.LockButton[KBM.Lang], self.LockButton, KBM.Options.Button.Unlocked)
	
end

function KBM.MenuGroup:SetTenMan()
	self.tenMan = KBM.MainWin.Menu:CreateHeader("10-Man Raids", nil, nil, true)
end

function KBM.MenuGroup:SetMaster()
	self.MasterModes = KBM.MainWin.Menu:CreateHeader("Master Modes", nil, nil, true)
end

function KBM.MenuGroup:SetExpertTwo()
	self.ExpertTwo = KBM.MainWin.Menu:CreateHeader("Tier 2 Experts", nil, nil, true)
end

function KBM.MenuGroup:SetExpertOne()
	self.ExpertOne = KBM.MainWin.Menu:CreateHeader("Tier 1 Experts", nil, nil, true)
end

function KBM.ApplySettings()
	KBM.TankSwap.Enabled = KBM.Options.TankSwap.Enabled
end

function KBM_Debug()
	if KBM.Debug then
		print("Debugging disabled")
		KBM.Debug = false
		KBM.Options.Debug = false
	else
		print("Debugging enabled")
		KBM.Debug = true
		KBM.Options.Debug = true
	end
end

-- local function KBM_TestAlert(data)
	-- local Ran = false
	-- if KBM.Testing then
		-- if KBM.CurrentMod then
			-- print("Starting: "..data)
			-- for BossName, BossObj in pairs(KBM.CurrentMod.Bosses) do
				-- if BossObj.AlertsRef then
					-- if BossObj.AlertsRef[data] then
						-- KBM.Alert:Start(BossObj.AlertsRef[data], Inspect.Time.Real())						
						-- Ran = true
					-- end
				-- end
			-- end
			-- if not Ran then
				-- print("Could not find: "..data.." in "..KBM.CurrentMod.ID)
			-- end
		-- end
	-- end
-- end

-- local function KBM_SetMod(data)
	-- if KBM.Testing then
		-- if data == "" then
			-- KBM.CurrentMod = nil
			-- print("Mod reset")
		-- else
			-- KBM.CurrentMod = KBM.BossMod[data]
			-- print("Mod set to: "..data)
		-- end
	-- end
-- end

local function KBM_Start()
	KBM.InitOptions()
	KBM.Button:Init()
	KBM.TankSwap:Init()
	KBM.Alert:Init()
	KBM.MechTimer:Init()
	KBM.CastBar:Init()
	KBM.EncTimer:Init()
	KBM.PhaseMonitor:Init()
	KBM.Trigger:Init()
	local Header = KBM.MainWin.Menu:CreateHeader("Global Options")
	KBM.MenuOptions.Main.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.Settings[KBM.Lang], KBM.MenuOptions.Main, nil, Header)
	KBM.MenuOptions.Timers.MenuItem = KBM.MainWin.Menu:CreateEncounter("Timers", KBM.MenuOptions.Timers, true, Header)
	KBM.MenuOptions.Phases.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.PhaseMonitor[KBM.Lang], KBM.MenuOptions.Phases, true, Header) 
	KBM.MenuOptions.CastBars.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.Castbar[KBM.Lang], KBM.MenuOptions.CastBars, true, Header)
	KBM.MenuOptions.Alerts.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.Alert[KBM.Lang], KBM.MenuOptions.Alerts, true, Header)
	KBM.MenuOptions.TankSwap.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.TankSwap[KBM.Lang], KBM.MenuOptions.TankSwap, true, Header)	
	KBM.MenuGroup.twentyman = KBM.MainWin.Menu:CreateHeader("20-Man Raids", nil, nil, true)
	table.insert(Command.Slash.Register("kbmreset"), {KBM_Reset, "KingMolinator", "KBM Reset"})
	table.insert(Event.Chat.Notify, {KBM.Notify, "KingMolinator", "Notify Event"})
	table.insert(Event.Chat.Npc, {KBM.NPCChat, "KingMolinator", "NPC Chat"})
	table.insert(Event.Buff.Add, {function (unitID, Buffs) KBM:BuffMonitor(unitID, Buffs, "new") end, "KingMolinator", "Buff Monitor (Add)"})
	table.insert(Event.Buff.Change, {function (unitID, Buffs) KBM:BuffMonitor(unitID, Buffs, "change") end, "KingMolinator", "Buff Monitor (change)"})
	table.insert(Event.Buff.Remove, {function (unitID, Buffs) KBM:BuffMonitor(unitID, Buffs, "remove") end, "KingMolinator", "Buff Monitor (remove)"})
	table.insert(Event.SafesRaidManager.Combat.Damage, {KBM.MobDamage, "KingMolinator", "Combat Damage"})
	table.insert(Event.SafesRaidManager.Group.Combat.Damage, {KBM.RaidDamage, "KingMolinator", "Raid Damage"})
	-- table.insert(Event.Unit.Unavailable, {KBM_UnitRemoved, "KingMolinator", "Unit Unavailable"})
	table.insert(Event.Unit.Available, {KBM_UnitAvailable, "KingMolinator", "Unit Available"})
	table.insert(Event.System.Update.Begin, {function () KBM:Timer() end, "KingMolinator", "System Update"}) 
	table.insert(Event.SafesRaidManager.Combat.Death, {KBM_Death, "KingMolinator", "Combat Death"})
	table.insert(Event.SafesRaidManager.Combat.Enter, {KBM.CombatEnter, "KingMolinator", "Non raid combat enter"})
	table.insert(Event.SafesRaidManager.Combat.Leave, {KBM.CombatLeave, "KingMolinator", "Non raid combat leave"})
	table.insert(Event.SafesRaidManager.Group.Combat.Death, {KBM.GroupDeath, "KingMolinator", "Group Death"})
	table.insert(Event.SafesRaidManager.Group.Combat.End, {KBM.RaidCombatLeave, "KingMolinator", "Raid Combat Leave"})
	table.insert(Event.SafesRaidManager.Group.Combat.Start, {KBM.RaidCombatEnter, "KingMolinator", "Raid Combat Enter"})
	table.insert(Event.Unit.Castbar, {KBM_CastBar, "KingMolinator", "Cast Bar Event"})
	table.insert(Command.Slash.Register("kbmhelp"), {KBM_Help, "KingMolinator", "KBM Help"})
	table.insert(Command.Slash.Register("kbmversion"), {KBM_Version, "KingMolinator", "KBM Version Info"})
	table.insert(Command.Slash.Register("kbmoptions"), {KBM_Options, "KingMolinator", "KBM Open Options"})
	table.insert(Command.Slash.Register("kbmdebug"), {KBM_Debug, "KingMolinator", "KBM Debug on/off"})
	-- table.insert(Command.Slash.Register("talert"), {KBM_TestAlert, "KingMolinator", "Alert Testing function"})
	-- table.insert(Command.Slash.Register("setMod"), {KBM_SetMod, "KingMolinator", "Testing Command"})
	print("Welcome to King Boss Mods v"..AddonData.toc.Version)
	print("/kbmhelp for a list of commands.")
	print("/kbmoptions for options.")
	KBM.MenuOptions.Timers:Options()
	table.insert(Command.Slash.Register("kbmon"), {function() KBM.StateSwitch(true) end, "KingMolinator", "KBM On"})
	table.insert(Command.Slash.Register("kbmoff"), {function() KBM.StateSwitch(false) end, "KingMolinator", "KBM Off"})	
end

local function KBM_WaitReady(unitID, uDetails)
	KBM.Player.UnitID = unitID
	KBM.Player.Name = uDetails.name
	KBM_Start()
	for _, Mod in ipairs(KBM.ModList) do
		Mod:AddBosses(KBM_Boss)
		Mod:Start(KBM_MainWin)
	end
	KBM.ApplySettings()
	
	-- KBM.Settings = {}
	-- KBM.Settings.CastBar = KBM.Defaults.CastBar()
	
	-- KBM_PlayerCastBar = KBM.CastBar:Add(KBM, {Name = KBM.Player.Name, Mod = KBM}, true)
	-- KBM_PlayerCastBar:Create(KBM.Player.UnitID)
		
--	KBM.MenuGroup:SetMaster()
--	KBM.MenuGroup:SetExpertTwo()
--	KBM.MenuGroup:SetExpertOne()
	-- if KBM.Testing then
		-- TestBar = KBM.CastBar:Add(KBM, KBM.TestBoss, true)
		-- TestBar:Create(KBM.Player.UnitID)
		-- for i, TriggerObj in ipairs(KBM.Trigger.List) do
			-- TriggerObj:Activate()
		-- end
		-- TestTimer = KBM.MechTimer:Add("Summon Tank!", 30)
		-- TestTrigger = KBM.Trigger:Create("Summon: Skeletal Knight", "cast", KBM.TestBoss)
		-- TestTrigger:AddTimer(TestTimer)
	-- end
		
end

function KBM.RegisterMod(ModID, Mod)
	KBM.BossMod[ModID] = Mod
	table.insert(KBM.ModList, Mod)
end

table.insert(Event.Addon.SavedVariables.Load.Begin, {KBM_DefineVars, "KingMolinator", "Pre Load"})
table.insert(Event.Addon.SavedVariables.Load.End, {KBM_LoadVars, "KingMolinator", "Event"})
table.insert(Event.Addon.SavedVariables.Save.Begin, {KBM_SaveVars, "KingMolinator", "Event"})
table.insert(Event.SafesRaidManager.Player.Ready, {KBM_WaitReady, "KingMolinator", "Sync Wait"})