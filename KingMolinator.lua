-- King Boss Mods
-- Written By Paul Snart
-- Copyright 2011

KBM_GlobalOptions = nil
chKBM_GlobalOptions = nil

local KingMol_Main = {}
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.BossMod = {}
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
			Alert = {
				Enabled = true,
				Flash = true,
				Notify = true,
				Visible = false,
				Unlocked = false,
				x = false,
				y = false,
			},
			EncTimer = {
				x = false,
				y = false,
				w = 150,
				h = 25,
				wScale = 1,
				hScale = 1,
				Enabled = true,
				Unlocked = true,
				Visible = true,
				ScaleWidth = false,
				ScaleHeight = false,
				TextSize = 15,
				TextScale = false,
				Enrage = true,
				Duration = true,
			},
			PhaseMon = {
				x = false,
				y = false,
				w = 225,
				h = 50,
				wScale = 1,
				hScale = 1,
				Enabled = true,
				Unlocked = true,
				Visible = true,
				ScaleWidth = false,
				ScaleHeight = false,
				TextSize = 14,
				TextScale = false,
				Objectives = true,
				PhaseDisplay = true,
			},
			MechTimer = {
				x = false,
				y = false,
				w = 350,
				h = 32,
				wScale = 1,
				hScale = 1,
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
			},
			CastBar = {
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
				ScaleHeight = false,
				TextScale = false,
				TextSize = 18,
			},
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

local function KBM_LoadVars(AddonID)

	local TargetLoad = nil

	if AddonID == "KingMolinator" then
		if KBM_GlobalOptions.Character then
			TargetLoad = chKBM_GlobalOptions
		else
			TargetLoad = KBM_GlobalOptions
		end
		if type(TargetLoad) == "table" then
			for Setting, Value in pairs(TargetLoad) do
				if type(TargetLoad[Setting]) == "table" then
					if KBM.Options[Setting] ~= nil then
						for tSetting, tValue in pairs(TargetLoad[Setting]) do
							if KBM.Options[Setting][tSetting] ~= nil then
								KBM.Options[Setting][tSetting] = tValue
							end
						end
					end
				else
					if KBM.Options[Setting] ~= nil then
						KBM.Options[Setting] = Value
					end
				end
			end
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
		KBM.Options.PhaseMon.w = 225
		KBM.Options.PhaseMon.TextSize = 14
		KBM.Options.MechTimer.TextSize = 18
		KBM.Options.MechTimer.TextureAlpha = 0.75
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

KBM.Lang = Inspect.System.Language()
KBM.Language = {}
KBM.MenuGroup = {}
local KBM_Boss = {}
KBM.SubBoss = {}
KBM.BossID = {}
KBM.Encounter = false
KBM.HeaderList = {}
KBM.CurrentBoss = ""
local KBM_CurrentMod = nil
local KBM_PlayerID = nil
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

	local SetPhrase = {}
	SetPhrase.English = Phrase
	SetPhrase.French = Phrase
	SetPhrase.German = Phrase
	SetPhrase.Russian = Phrase
	SetPhrase.Korean = Phrase
	function SetPhrase:SetFrench(frPhrase)
		self.French = frPhrase
	end
	function SetPhrase:SetGerman(gePhrase)
		self.German = gePhrase
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
KBM.Language.Color.Red = KBM.Language:Add("Red")
KBM.Language.Color.Blue = KBM.Language:Add("Blue")
KBM.Language.Color.Dark_Green = KBM.Language:Add("Dark Green")
KBM.Language.Color.Yellow = KBM.Language:Add("Yellow")
KBM.Language.Color.Orange = KBM.Language:Add("Orange")
KBM.Language.Color.Purple = KBM.Language:Add("Purple")
-- Cast-bar related
KBM.Language.Options = {}
KBM.Language.Options.Castbar = KBM.Language:Add("Cast-bars")
KBM.Language.Options.Castbar.French = "Barres-cast"
KBM.Language.Options.Castbar.German = "Zauberbalken"
KBM.Language.Options.CastbarEnabled = KBM.Language:Add("Cast-bars enabled.")
KBM.Language.Options.CastbarEnabled.French = "Barres-cast activ\195\169."
KBM.Language.Options.CastbarEnabled.German = "Zauberbalken anzeigen."
-- Timer Options
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
-- Misc.
KBM.Language.Options.Character = KBM.Language:Add("Saving settings for this character only.")
KBM.Language.Options.Enabled = KBM.Language:Add("Enable King Boss Mods v"..AddonData.toc.Version)
KBM.Language.Options.Settings = KBM.Language:Add("Settings")
KBM.Language.Options.Settings.French = "Configurations"
KBM.Language.Options.Settings.German = "Einstellungen"
KBM.Language.Options.Shadow = KBM.Language:Add("Show text shadows.")
KBM.Language.Options.Texture = KBM.Language:Add("Enable textured overlay.")
-- Timer Dictionary
KBM.Language.Timers = {}
KBM.Language.Timers.Time = KBM.Language:Add("Time:")
KBM.Language.Timers.Time.French = "Dur\195\169e:"
KBM.Language.Timers.Time.German = "Zeit:"
KBM.Language.Timers.Enrage = KBM.Language:Add("Enrage in:")
KBM.Language.Timers.Enrage.French = "Enrage dans:"

function KBM.MechTimer:Init()

	self.TimerList = {}
	self.ActiveTimers = {}
	self.RemoveTimers = {}
	self.RemoveCount = 0
	self.StartTimers = {}
	self.StartCount = 0
	self.LastTimer = nil
	self.Store = {}
	self.Anchor = UI.CreateFrame("Frame", "Timer Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetWidth(KBM.Options.MechTimer.w * KBM.Options.MechTimer.wScale)
	self.Anchor:SetHeight(KBM.Options.MechTimer.h * KBM.Options.MechTimer.hScale)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	if KBM.Options.MechTimer.x then
		self.Anchor:SetPoint("LEFT", UIParent, "LEFT", KBM.Options.MechTimer.x, nil)
	else
		self.Anchor:SetPoint("CENTERX", UIParent, "CENTERX")
	end
	if KBM.Options.MechTimer.y then
		self.Anchor:SetPoint("TOP", UIParent, "TOP", nil, KBM.Options.MechTimer.y)
	else
		self.Anchor:SetPoint("CENTERY", UIParent, "CENTERY")
	end
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Options.MechTimer.x = self:GetLeft()
			KBM.Options.MechTimer.y = self:GetTop()
		end
	end
	self.Anchor.Text = UI.CreateFrame("Text", "Timer Info", self.Anchor)
	self.Anchor.Text:SetFontSize(KBM.Options.MechTimer.TextSize)
	self.Anchor.Text:SetText(" 00.0 Timer Anchor")
	self.Anchor.Text:SetPoint("CENTERLEFT", self.Anchor, "CENTERLEFT")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor Drag", 2)
	self.Anchor:SetVisible(KBM.Options.MechTimer.Visible)
	self.Anchor.Drag:SetVisible(KBM.Options.MechTimer.Unlocked)
	
end

function KBM.MechTimer:Pull()

	local GUI = {}
	if #self.Store > 0 then
		GUI = table.remove(self.Store)
	else
		GUI.Background = UI.CreateFrame("Frame", "Timer_Frame", KBM.Context)
		GUI.Background:SetWidth(KBM.Options.MechTimer.w * KBM.Options.MechTimer.wScale)
		GUI.Background:SetHeight(KBM.Options.MechTimer.h * KBM.Options.MechTimer.hScale)
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.TimeBar = UI.CreateFrame("Frame", "Timer_Progress_Frame", GUI.Background)
		GUI.TimeBar:SetWidth(KBM.Options.MechTimer.w * KBM.Options.MechTimer.wScale)
		GUI.TimeBar:SetHeight(KBM.Options.MechTimer.h * KBM.Options.MechTimer.hScale)
		GUI.TimeBar:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.TimeBar:SetLayer(1)
		GUI.TimeBar:SetBackgroundColor(0,0,1,0.33)
		GUI.CastInfo = UI.CreateFrame("Text", "Timer_Text_Frame", GUI.Background)
		GUI.CastInfo:SetFontSize(KBM.Options.MechTimer.TextSize)
		GUI.CastInfo:SetPoint("CENTERLEFT", GUI.Background, "CENTERLEFT")
		GUI.CastInfo:SetLayer(3)
		GUI.CastInfo:SetFontColor(1,1,1)
		GUI.Shadow = UI.CreateFrame("Text", "Timer_Text_Shadow", GUI.Background)
		GUI.Shadow:SetFontSize(KBM.Options.MechTimer.TextSize)
		GUI.Shadow:SetPoint("CENTER", GUI.CastInfo, "CENTER", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Texture = UI.CreateFrame("Texture", "Timer_Skin", GUI.Background)
		GUI.Texture:SetTexture("KingMolinator", "Media/BarSkin.png")
		GUI.Texture:SetAlpha(KBM.Options.MechTimer.TextureAlpha)
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(4)
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
			if self.Active then
				KBM.MechTimer:AddStart(self)
				return
			end
			local Anchor = KBM.MechTimer.Anchor
			self.GUI = KBM.MechTimer:Pull()
			self.TimeStart = CurrentTime
			self.Remaining = self.Time
			self.GUI.CastInfo:SetText(string.format(" %0.01f : ", self.Remaining)..self.Name)
			if KBM.Options.MechTimer.Shadow then
				self.GUI.Shadow:SetText(self.GUI.CastInfo:GetText())
				self.GUI.Shadow:SetVisible(true)
			else
				self.GUI.Shadow:SetVisible(false)
			end
			if KBM.Options.MechTimer.Texture then
				self.GUI.Texture:SetVisible(true)
			else
				self.GUI.Texture:SetVisible(false)
			end
			if self.Delay then
				self.Time = Delay
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
					if self.Phase == KBM_CurrentMod.Phase or self.Phase == 0 then
						KBM.MechTimer:AddStart(self)
					end
				end
			end
		end
	end
	
	function Timer:AddAlert(AlertObj, Time)
		self.Alerts[Time] = {}
		self.Alerts[Time].Triggered = false
		self.Alerts[Time].AlertObj = AlertObj
	end
	
	function Timer:AddTimer(TimerObj, Time)
		self.Timers[Time] = {}
		self.Timers[Time].Triggered = false
		self.Timers[Time].TimerObj = TimerObj
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
		if self.Active then
			self.Remaining = self.Time - (CurrentTime - self.TimeStart)
			local text = string.format(" %0.01f : ", self.Remaining)..self.Name
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

	function self.Queue:Add(TriggerObj, Caster, Target, Duration)
	
		if KBM.Encounter or KBM.Testing then
			if TriggerObj.Queued or self.Removing then
				return
			else
				TriggerObj.Queued = true
			end
			self.Locked = true
			table.insert(self.List, TriggerObj)
			TriggerObj.Caster = Caster
			TriggerObj.Target = Target
			TriggerObj.Duration = Duration
			self.Locked = false
			self.Queued = true
		end
		
	end
	
	function self.Queue:Activate()
	
		if self.Queued then
			if KBM.Encounter or KBM.Testing then
				if self.Removing then
					return
				end
				self.Locked = true
				for i, TriggerObj in ipairs(self.List) do
					TriggerObj:Activate(TriggerObj.Caster, TriggerObj.Target, TriggerObj.Duration)
					TriggerObj.Queued = false
				end
				self.List = {}
				self.Locked = false
				self.Queued = false
			end
		end
		
	end
	
	function self.Queue:Remove()
		
		self.Removing = true
		self.Locked = true
		self.List = {}
		self.Locked = false
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
			table.insert(self.Timers, TimerObj)
		end
		function TriggerObj:AddAlert(AlertObj, Player)
			AlertObj.Player = Player
			table.insert(self.Alerts, AlertObj)
		end
		function TriggerObj:AddPhase(PhaseObj)
			self.Phase = PhaseObj 
		end
		function TriggerObj:AddStop(Object)
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
					if KBM_PlayerID == Target then
						KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
						Triggered = true
					end
				else
					KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
					Triggered = true
				end
			end
			for i, Obj in ipairs(self.Stop) do
				Obj:Stop()
				Triggered = true
			end
			if KBM.Encounter then
				if self.Phase then
					self.Phase()
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
			self.Buff[Trigger] = TriggerObj
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

function KBM:CallFrame(parent)

	print("Warning: CallFrame used, old Recycling system, please report: WCF848")
	local frame = nil
	self.TotalFrames = self.TotalFrames + 1
	frame = UI.CreateFrame("Frame", "Frame_Store"..tostring(self.TotalFrames), parent)
	return frame
	
end

function KBM:CallCheck(parent)

	print("Warning: CallCheck used, old Recycling system, please report: WCC879")
	self.TotalChecks = self.TotalChecks + 1
	Checkbox = UI.CreateFrame("RiftCheckbox", "Check Store"..self.TotalChecks, parent)
	return Checkbox
	
end

function KBM:CallText(parent, debugInfo)

	print("Warning: CallText used, old Recycling system, please report: WCT910")
	local Textfbox = nil
	self.TotalTexts = self.TotalTexts + 1
	Textfbox = UI.CreateFrame("Text", "Textf Store"..self.TotalTexts, parent)
	return Textfbox
	
end

function KBM:CallSlider(parent)
	
end

local function KBM_Options()

	if KBM.MainWin:GetVisible() then
		KBM.MainWin:SetVisible(false)
	else
		KBM.MainWin:SetVisible(true)
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
		GUI.Text:SetFontSize(KBM.Options.PhaseMon.TextSize)
		GUI.Objective = UI.CreateFrame("Text", "Objective_Tracker", GUI.Frame)
		GUI.Objective:SetPoint("CENTERRIGHT", GUI.Frame, "CENTERRIGHT")
		GUI.Objective:SetFontSize(KBM.Options.PhaseMon.TextSize)
	end
	return GUI

end

function KBM.PhaseMonitor:Init()
	
	self.Anchor = UI.CreateFrame("Frame", "Phase Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetWidth(KBM.Options.PhaseMon.w * KBM.Options.PhaseMon.wScale)
	self.Anchor:SetHeight(KBM.Options.PhaseMon.h * KBM.Options.PhaseMon.hScale)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	if not KBM.Options.PhaseMon.x then
		self.Anchor:SetPoint("CENTERTOP", UIParent, "CENTERTOP")
	else
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.PhaseMon.x, KBM.Options.PhaseMon.y)
	end
	self.Anchor.Text = UI.CreateFrame("Text", "Phase Anchor Text", self.Anchor)
	self.Anchor.Text:SetFontSize(KBM.Options.PhaseMon.TextSize)
	self.Anchor.Text:SetText("Phases and Objectives")
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")

	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Options.PhaseMon.x = self:GetLeft()
			KBM.Options.PhaseMon.y = self:GetTop()
		end
	end
		
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Phase Anchor Drag", 2)
	self.Anchor:SetVisible(KBM.Options.PhaseMon.Visible)
	self.Anchor.Drag:SetVisible(KBM.Options.PhaseMon.Unlocked)

	self.Frame = UI.CreateFrame("Frame", "Phase Monitor", KBM.Context)
	self.Frame:SetLayer(5)
	self.Frame:SetBackgroundColor(0,0,0.9,0.33)
	self.Frame:SetPoint("LEFT", self.Anchor, "LEFT")
	self.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
	self.Frame:SetPoint("TOP", self.Anchor, "TOP")
	self.Frame:SetPoint("BOTTOM", self.Anchor, "CENTERY")
	self.Frame.Text = UI.CreateFrame("Text", "Phase Monitor Text", self.Frame)
	self.Frame.Text:SetText("Phase: 1")
	self.Frame.Text:SetFontSize(KBM.Options.PhaseMon.TextSize)
	self.Frame.Text:SetPoint("CENTER", self.Frame, "CENTER")
	
	self.Frame:SetVisible(false)
	
	self.Objectives = {}
	self.ObjectiveStore = {}
	self.Phase = {}
	self.Phase.Object = nil
	self.Active = false
	
	self.Objectives.Lists = {}
	self.Objectives.Lists.Death = {}
	self.Objectives.Lists.Percent = {}
	self.Objectives.Lists.Time = {}
	self.Objectives.Lists.All = {}
	self.Objectives.Lists.LastObjective = nil
	
	function self.Objectives.Lists:Add(Object)
		if #self.All then
			Object.Previous = self.All[#self.All]
		end
		self.LastObjective = Object
		table.insert(self.All, Object)
		if Object.Previous then
			Object.GUI.Frame:SetPoint("TOP", Object.Previous.GUI.Frame, "BOTTOM")
		else
			Object.GUI.Frame:SetPoint("TOP", KBM.PhaseMonitor.Frame, "BOTTOM")
		end
		
	end
	function self.Objectives.Lists:Remove(Object)
	
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
		
		function PhaseObj:Update(Time)
			Time = math.floor(Time)
		end
		
		function PhaseObj:SetPhase(Phase)
			self.Phase = Phase
			KBM.PhaseMonitor:SetPhase(Phase)
		end
		
		function PhaseObj.Objectives:AddDeath(Name, Total)
			
			local DeathObj = {}
			DeathObj.Count = 0
			DeathObj.Total = Total
			DeathObj.GUI = KBM.PhaseMonitor:PullObjective()
			DeathObj.GUI.Text:SetText(Name)
			DeathObj.GUI.Objective:SetText(DeathObj.Count.."/"..DeathObj.Total)
			
			function DeathObj:Kill()
				if self.Count < Total then
					self.Count = self.Count + 1
					self.GUI.Objective:SetText(self.Count.."/"..self.Total)
				end
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Death[Name] = DeathObj
			KBM.PhaseMonitor.Objectives.Lists:Add(DeathObj)
			
			DeathObj.GUI.Frame:SetVisible(true)
			
		end
		
		function PhaseObj.Objectives:AddPercent(Name, Target, Current)
		
			local PercentObj = {}
			PercentObj.Name = Name
			PercentObj.Target = Target
			PercentObj.PercentRaw = Current
			PercentObj.Percent = math.ceil(Current)
			PercentObj.GUI = KBM.PhaseMonitor:PullObjective()
			PercentObj.GUI.Text:SetText(Name)
			PercentObj.GUI.Objective:SetText(PercentObj.Percent.."%/"..PercentObj.Target.."%")
			
			function PercentObj:Update(PercentRaw)
				self.PercentRaw = PercentRaw
				self.Percent = math.ceil(PercentRaw)
				if self.Percent >= Target then
					self.GUI.Objective:SetText(self.Percent.."%/"..self.Target.."%")
				end
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Percent[Name] = PercentObj
			KBM.PhaseMonitor.Objectives.Lists:Add(PercentObj)
			
			PercentObj.GUI.Frame:SetVisible(true)
						
		end
		
		function PhaseObj.Objectives:AddTime(Time)
	
		end
		
		function PhaseObj.Objectives:Remove()
			for _, Object in ipairs(KBM.PhaseMonitor.Objectives.Lists.All) do
				Object.GUI.Frame:SetVisible(false)
				table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
			end
			for ListName, List in pairs(KBM.PhaseMonitor.Objectives.Lists) do
				if type(List) == "table" then
					KBM.PhaseMonitor.Objectives.Lists[ListName] = {}
				end
			end
		end
		
		function PhaseObj:Start(Time)
			self.StartTime = math.floor(Time)
			self.Phase = self.DefaultPhase
			if KBM.Options.PhaseMon.PhaseDisplay then
				KBM.PhaseMonitor.Frame:SetVisible(true)
			end
			KBM.PhaseMonitor.Active = true
			self:SetPhase(self.Phase)
		end
		function PhaseObj:End(Time)
			self.Objectives:Remove()
			KBM.PhaseMonitor.Frame:SetVisible(false)
			KBM.PhaseMonitor.Active = false
		end
	
		self.Object = PhaseObj
		return PhaseObj
	end
	function self.Phase:Remove()
	
	end
end

function KBM.EncTimer:Init()
	
	self.TestMode = false
	self.Frame = UI.CreateFrame("Frame", "Encounter Timer", KBM.Context)
	self.Frame:SetLayer(5)
	self.Frame:SetWidth(KBM.Options.EncTimer.w)
	self.Frame:SetHeight(KBM.Options.EncTimer.h)
	if not KBM.Options.EncTimer.x then
		self.Frame:SetPoint("CENTERTOP", UIParent, "CENTERTOP")
	else
		self.Frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.EncTimer.x, KBM.Options.EncTimer.y)
	end
	self.Frame:SetBackgroundColor(0,0,0,0.33)
	self.Frame.Text = UI.CreateFrame("Text", "Encounter Text", self.Frame)
	self.Frame.Text:SetText("Time: 00m:00s")
	self.Frame.Text:SetFontSize(KBM.Options.EncTimer.TextSize)
	self.Frame.Text:SetPoint("CENTER", self.Frame, "CENTER")
	self.Enrage = {}
	self.Enrage.Frame = UI.CreateFrame("Frame", "Enrage Timer", KBM.Context)
	self.Enrage.Frame:SetPoint("TOPLEFT", self.Frame, "BOTTOMLEFT")
	self.Enrage.Frame:SetPoint("RIGHT", self.Frame, "RIGHT")
	self.Enrage.Frame:SetHeight(self.Frame:GetHeight())
	self.Enrage.Frame:SetBackgroundColor(0,0,0,0.33)
	self.Enrage.Text = UI.CreateFrame("Text", "Enrage Text", self.Enrage.Frame)
	self.Enrage.Text:SetText("Enrage in: 00m:00s")
	self.Enrage.Text:SetFontSize(KBM.Options.EncTimer.TextSize)
	self.Enrage.Text:SetPoint("CENTER", self.Enrage.Frame, "CENTER")
	self.Enrage.Progress = UI.CreateFrame("Frame", "Enrage Progress", self.Enrage.Frame)
	self.Enrage.Progress:SetPoint("TOPLEFT", self.Enrage.Frame, "TOPLEFT")
	self.Enrage.Progress:SetPoint("BOTTOM", self.Enrage.Frame, "BOTTOM")
	self.Enrage.Progress:SetPoint("RIGHT", self.Enrage.Frame, 0, nil)
	self.Enrage.Progress:SetBackgroundColor(0.9,0,0,0.33)
	function self:UpdateMove(uType)
		if uType == "end" then
			KBM.Options.EncTimer.x = self.Frame:GetLeft()
			KBM.Options.EncTimer.y = self.Frame:GetTop()
		end
	end
	function self:Update(current)
		local EnrageString = ""
		if KBM.Options.EncTimer.Duration then
			self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
		end
		if KBM.Options.EncTimer.Enrage then
			if KBM_CurrentMod.Enrage then
				if current < KBM.EnrageTime then
					EnrageString = KBM.ConvertTime(KBM.EnrageTime - current + 1)
					self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." "..EnrageString)
					self.Enrage.Progress:SetPoint("RIGHT", self.Enrage.Frame, KBM.TimeElapsed/KBM_CurrentMod.Enrage, nil)
				else
					self.Enrage.Text:SetText("!! Enraged !!")
					self.Enrage.Progress:SetPoint("RIGHT", self.Enrage.Frame, "RIGHT")
				end
			end
		end
	end
	function self:Start(Time)
		if KBM.Options.EncTimer.Duration then
			self.Frame:SetVisible(true)
			self.Active = true
		end
		if KBM.Options.EncTimer.Enrage then
			if KBM_CurrentMod.Enrage then
				self.Enrage.Frame:SetVisible(true)
				self.Enrage.Progress:SetPoint("RIGHT", self.Enrage.Frame, "LEFT")
				self.Active = true
			end
		end
		if self.Active then
			self:Update(Time)
		end
	end
	function self:TestUpdate()
	
	end
	function self:End()
		self.Active = false
		self.Frame:SetVisible(false)
		self.Enrage.Frame:SetVisible(false)
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
	self.Frame:SetVisible(KBM.Options.EncTimer.Visible)
	self.Enrage.Frame:SetVisible(KBM.Options.EncTimer.Visible)
	self.Frame.Drag:SetVisible(KBM.Options.EncTimer.Unlocked)
	
end

function KBM.CheckActiveBoss(uDetails, UnitID)

	current = Inspect.Time.Real()
	if KBM.Options.Enabled then
		if (not KBM.Idle.Wait or (KBM.Idle.Wait and KBM.Idle.Until < current)) or KBM.Encounter then
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
										KBM_CurrentMod = KBM.BossID[UnitID].Mod
										if not KBM_CurrentMod.EncounterRunning then
											print(KBM.Language.Encounter.Start[KBM.Lang].." "..BossObj.Descript)
											print(KBM.Language.Encounter.GLuck[KBM.Lang])
											KBM.TimeElapsed = 0
											KBM.StartTime = math.floor(current)
											KBM_CurrentMod.Phase = 1
											if KBM_CurrentMod.Enrage then
												KBM.EnrageTime = KBM.StartTime + KBM_CurrentMod.Enrage
											end
											if KBM.Options.EncTimer.Enabled then
												KBM.EncTimer:Start(KBM.StartTime)
											end
										end
									end
									if BossObj.Mod.ID == KBM_CurrentMod.ID then
										KBM.BossID[UnitID].Boss = KBM_CurrentMod:UnitHPCheck(uDetails, UnitID)
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
					if KBM_CurrentMod then
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
				KBM.BossID[tUnitID].PercentRaw = (tDetails.health/tDetails.healthMax)*100
				KBM.BossID[tUnitID].Percent = math.ceil(KBM.BossID[tUnitID].PercentRaw)
				if KBM.BossID[tUnitID].Percent ~= KBM.BossID[tUnitID].PercentLast then
					if KBM.Trigger.Percent[KBM_CurrentMod.ID] then
						if KBM.Trigger.Percent[KBM_CurrentMod.ID][tDetails.name] then
							if KBM.BossID[tUnitID].PercentLast - KBM.BossID[tUnitID].Percent > 1 then
								for PCycle = KBM.BossID[tUnitID].PercentLast, KBM.BossID[tUnitID].Percent, -1 do
									if KBM.Trigger.Percent[KBM_CurrentMod.ID][tDetails.name][PCycle] then
										TriggerObj = KBM.Trigger.Percent[KBM_CurrentMod.ID][tDetails.name][PCycle]
										KBM.Trigger.Queue:Add(TriggerObj, nil, tUnitID)
									end
								end
							else
								if KBM.Trigger.Percent[KBM_CurrentMod.ID][tDetails.name][KBM.BossID[tUnitID].Percent] then
									TriggerObj = KBM.Trigger.Percent[KBM_CurrentMod.ID][tDetails.name][KBM.BossID[tUnitID].Percent]
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
		GUI.Frame = UI.CreateFrame("Frame", "TankSwap Base Frame", KBM.Context)
		GUI.Frame:SetLayer(1)
		GUI.Frame:SetHeight(KBM.Options.TankSwap.h)
		GUI.Frame:SetBackgroundColor(0,0,0,0.4)
		GUI.TankFrame = UI.CreateFrame("Frame", "TankSwap Tank Frame", GUI.Frame)
		GUI.TankFrame:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
		GUI.TankFrame:SetPoint("BOTTOMLEFT", GUI.Frame, "CENTERLEFT")
		GUI.TankHP = UI.CreateFrame("Frame", "TankSwap Tank HP Frame", GUI.TankFrame)
		GUI.TankHP:SetLayer(1)
		GUI.TankText = UI.CreateFrame("Text", "TankSwap Tank Text", GUI.TankFrame)
		GUI.TankText:SetLayer(2)
		GUI.TankText:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.TankText:SetPoint("CENTERLEFT", GUI.TankFrame, "CENTERLEFT", 2, 0)
		GUI.DebuffFrame = UI.CreateFrame("Frame", "TankSwap Debuff Frame", GUI.Frame)
		GUI.DebuffFrame:SetPoint("TOPRIGHT", GUI.Frame, "TOPRIGHT")
		GUI.DebuffFrame:SetPoint("BOTTOMRIGHT", GUI.Frame, "CENTERRIGHT")
		GUI.DebuffFrame:SetPoint("LEFT", GUI.Frame, 0.8, nil)
		GUI.DebuffFrame:SetBackgroundColor(0.5,0,0,0.4)
		GUI.DebuffFrame:SetLayer(1)
		GUI.DebuffFrame.Text = UI.CreateFrame("Text", "TankSwap Debuff Text", GUI.DebuffFrame)
		GUI.DebuffFrame.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.DebuffFrame.Text:SetLayer(2)
		GUI.DebuffFrame.Text:SetPoint("CENTER", GUI.DebuffFrame, "CENTER")
		GUI.TankFrame:SetPoint("TOPRIGHT", GUI.DebuffFrame, "TOPLEFT")
		GUI.TankHP:SetPoint("TOPLEFT", GUI.TankFrame, "TOPLEFT")
		GUI.TankHP:SetPoint("BOTTOM", GUI.TankFrame, "BOTTOM")
		GUI.TankHP:SetPoint("RIGHT", GUI.TankFrame, 1, nil)
		GUI.DeCoolFrame = UI.CreateFrame("Frame", "TankSwap Cooldown Frame", GUI.Frame)
		GUI.DeCoolFrame:SetPoint("TOPLEFT", GUI.TankFrame, "BOTTOMLEFT")
		GUI.DeCoolFrame:SetPoint("BOTTOM", GUI.Frame, "BOTTOM")
		GUI.DeCoolFrame:SetPoint("RIGHT", GUI.Frame, "RIGHT")
		GUI.DeCool = UI.CreateFrame("Frame", "TankSwap Cooldown Progress", GUI.DeCoolFrame)
		GUI.DeCool:SetPoint("TOPLEFT", GUI.DeCoolFrame, "TOPLEFT")
		GUI.DeCool:SetPoint("BOTTOM", GUI.DeCoolFrame, "BOTTOM")
		GUI.DeCool:SetPoint("RIGHT", GUI.DeCoolFrame, 1, nil)
		GUI.DeCool:SetBackgroundColor(0,0,1,0.4)
		GUI.DeCool.Text = UI.CreateFrame("Text", "TankSwap Cooldown Text", GUI.DeCoolFrame)
		GUI.DeCool.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.DeCool.Text:SetPoint("CENTER", GUI.DeCoolFrame, "CENTER")
		GUI.DeCool.Text:SetLayer(2)		
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
	self.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
	self.Anchor.Drag:SetVisible(KBM.Options.TankSwap.Unlocked)
	function self:Add(UnitID, Test)
		local TankObj = {}
		TankObj.UnitID = UnitID
		TankObj.Test = Test
		self.Active = true
		TankObj.Stacks = 0
		TankObj.Remaining = 0
		if Test then
			TankObj.Name = Test
			TankObj.UnitID = Test
			self.Test = true
		else
			local uDetails = Inspect.Unit.Detail(UnitID)
			if uDetails then
				TankObj.Name = uDetails.name
			end
		end
		TankObj.GUI = KBM.TankSwap:Pull()
		TankObj.GUI.TankText:SetText(TankObj.Name)
		if self.TankCount == 0 then
			TankObj.GUI.Frame:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
			TankObj.GUI.Frame:SetPoint("TOPRIGHT", self.Anchor, "TOPRIGHT")
		else
			TankObj.GUI.Frame:SetPoint("TOPLEFT", self.LastTank.GUI.Frame, "BOTTOMLEFT", 0, 2)
			TankObj.GUI.Frame:SetPoint("RIGHT", self.LastTank.GUI.Frame, "RIGHT")
		end
		self.LastTank = TankObj
		self.Tanks[TankObj.UnitID] = TankObj
		self.TankCount = self.TankCount + 1
		if self.Test then
			TankObj.GUI.DebuffFrame.Text:SetText("2")
			TankObj.GUI.DeCool.Text:SetText("99.9")
			TankObj.GUI.Frame:SetVisible(true)
		end
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
		for UnitID, TankObj in pairs(self.Tanks) do
			Buffs = Inspect.Buff.List(UnitID)
			TankObj.Stacks = 0
			TankObj.Remaining = 0
			if Buffs then
				for BuffID, bool in pairs(Buffs) do
					bDetails = Inspect.Buff.Detail(UnitID, BuffID)
					if bDetails then
						if bDetails.name == self.DebuffName then
							if bDetails.stack then
								TankObj.Stacks = bDetails.stack
							else
								TankObj.Stacks = 0
							end
							if bDetails.remaining > 0 then
								TankObj.Remaining = bDetails.remaining
								TankObj.Duration = bDetails.duration
							else
								TankObj.Remaining = 0
							end
							break
						end
					end
				end
			end
			if TankObj.Remaining <= 0 then
				TankObj.GUI.DeCoolFrame:SetVisible(false)
				TankObj.GUI.DeCool:SetPoint("RIGHT", TankObj.GUI.DeCoolFrame, 1, nil)
				TankObj.GUI.DebuffFrame.Text:SetVisible(false)
			else
				TankObj.GUI.DeCool.Text:SetText(string.format("%0.01f", TankObj.Remaining))
				TankObj.GUI.DeCool:SetPoint("RIGHT", TankObj.GUI.DeCoolFrame, (TankObj.Remaining/TankObj.Duration), nil)
				TankObj.GUI.DeCoolFrame:SetVisible(true)
				if TankObj.Stacks then
					TankObj.GUI.DebuffFrame.Text:SetText(tostring(TankObj.Stacks))
				else
					TankObj.GUI.DebuffFrame.Text:SetText("-")
				end
				TankObj.GUI.DebuffFrame.Text:SetVisible(true)
			end
		end
	end
	function self:Remove()
		for UnitID, TankObj in pairs(self.Tanks) do
			table.insert(self.TankStore, TankObj.GUI)
			TankObj.GUI.Frame:SetVisible(false)
			TankObj.GUI = nil
		end
		self.Tanks = {}
		self.LastTank = nil
		self.TankCount = 0
		self.Active = false
		self.Test = false
	end
	
end

function KBM.Alert:Init()

	self.List = {}
	self.Anchor = UI.CreateFrame("Frame", "Alert Text Anchor", KBM.Context)
	self.Anchor:SetBackgroundColor(0,0,0,0)
	self.Anchor:SetLayer(5)
	if KBM.Options.Alert.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.Alert.x, KBM.Options.Alert.y)
	else
		self.Anchor:SetPoint("CENTERX", UIParent, "CENTERX")
		self.Anchor:SetPoint("CENTERY", UIParent, nil, 0.25)
	end
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
	self.Anchor:SetVisible(KBM.Options.Alert.Visible)
	self.ColorList = {"red", "blue", "yellow", "orange", "purple", "dark_green"}
	self.Left = {}
	self.Right = {}
	for _t, Color in ipairs(self.ColorList) do
		self.Left[Color] = UI.CreateFrame("Texture", "Left Alert "..Color, KBM.Context)
		self.Left[Color]:SetTexture("KingMolinator", "Media/Alert_Left_"..Color..".png")
		self.Left[Color]:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
		self.Left[Color]:SetPoint("BOTTOM", UIParent, "BOTTOM")
		self.Left[Color]:SetVisible(false)
		self.Right[Color] = UI.CreateFrame("Texture", "Right Alert"..Color, KBM.Context)
		self.Right[Color]:SetTexture("KingMolinator", "Media/Alert_Right_"..Color..".png")
		self.Right[Color]:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")
		self.Right[Color]:SetPoint("BOTTOM", UIParent, "BOTTOM")
		self.Right[Color]:SetVisible(false)
	end
	self.Enabled = true
	self.Current = nil
	self.StopTime = 0
	self.Remaining = 0
	self.Alpha = 1
	self.Queue = {}
	self.Notify = KBM.Options.Alert.Notify
	self.Flash = KBM.Options.Alert.Flash
	self.Speed = 0.025
	self.Direction = -self.Speed
	self.Color = "red"
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Options.Alert.x = self:GetLeft()
			KBM.Options.Alert.y = self:GetTop()
		end
	end
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Alert Anchor Drag", 2)
	self.Anchor.Drag:SetLayer(3)
	self.Anchor.Drag:SetVisible(KBM.Options.Alert.Unlocked)
	
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
		AlertObj.Enabled = false
		AlertObj.AlertAfter = nil
		AlertObj.isImportant = false
		
		function AlertObj:AlertEnd(endAlertObj)
			self.AlertAfter = endAlertObj
		end

		function AlertObj:Important()
			self.isImportant = true
		end
		
		table.insert(self.List, AlertObj)
		return AlertObj
	end
	function self:Start(AlertObj, CurrentTime, Duration)
		
		if KBM.Options.Alert.Enabled then
			if self.Starting then
				return
			end
			if self.Current then
				if self.Current.isImportant then
					return
				end
				self.Starting = true
				self:Stop()
			else
				self.Starting = true
			end
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
			if KBM.Options.Alert.Flash then
				self.Color = AlertObj.Color
				self.Left[self.Color]:SetAlpha(1)
				self.Left[self.Color]:SetVisible(true)
				self.Right[self.Color]:SetAlpha(1)
				self.Right[self.Color]:SetVisible(true)
				self.Direction = -self.Speed
				self.Flash = AlertObj.Flash
			end
			if KBM.Options.Alert.Notify then
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
			self:Update(CurrentTime)
			self.Starting = false
		end
	end
	function self:Stop()
		self.Left[self.Color]:SetVisible(false)
		self.Right[self.Color]:SetVisible(false)
		self.Anchor:SetVisible(false)
		self.Shadow:SetText(" Alert Anchor ")
		self.Text:SetText(" Alert Anchor ")
		self.Current.Stopping = false
		self.StopTime = 0
		if self.Current.AlertAfter and not self.Starting then
			local TempObj = self.Current
			self.Current = nil
			self:Start(TempObj.AlertAfter, Inspect.Time.Real())
			TempObj = nil
		else
			self.Current = nil
		end
	end	
	function self:Update(CurrentTime)
		if self.Current.Stopping then
			if self.Alpha <= 0.1 then -- lag threshold
				self:Stop()
			else
				self.Alpha = self.Alpha + self.Direction
				if KBM.Options.Alert.Flash then
					self.Left[self.Color]:SetAlpha(self.Alpha)
					self.Right[self.Color]:SetAlpha(self.Alpha)
				end
				if KBM.Options.Alert.Notify then
					self.Anchor:SetAlpha(self.Alpha)
				end
			end
		else
			if self.Flash then
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
			if self.Current.Countdown then
				if self.Remaining then
					self.Remaining = self.StopTime - CurrentTime
					if self.Remaining <= 0 then
						self.Remaining = 0
						self.Shadow:SetText(self.Current.Text)
						self.Text:SetText(self.Current.Text)
					else
						local CDText = string.format("%0.1f - "..self.Current.Text, self.Remaining)
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
	
end

function KBM.CastBar:Init()

	self.CastBarList = {}
	self.ActiveCastBars = {}
	self.RemoveCastBars = {}
	self.WaitCastBars = {}
	self.StartCastBars = {}
	self.Store = {}
	self.Anchor = UI.CreateFrame("Frame", "CastBar Anchor", KBM.Context)
	self.Anchor:SetWidth(KBM.Options.CastBar.w * KBM.Options.CastBar.wScale)
	self.Anchor:SetHeight(KBM.Options.CastBar.h * KBM.Options.CastBar.hScale)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	if KBM.Options.CastBar.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.CastBar.x, KBM.Options.CastBar.y)
	else
		self.Anchor:SetPoint("CENTER", UIParent, "CENTER")
	end
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Options.CastBar.x = self:GetLeft()
			KBM.Options.CastBar.y = self:GetTop()
		end
	end
	self.Anchor.Text = UI.CreateFrame("Text", "CastBar Info", self.Anchor)
	self.Anchor.Text:SetText("CastBar Anchor")
	self.Anchor.Text:SetFontSize(KBM.Options.CastBar.TextSize)
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end , "CB Anchor Drag", 2)
	self.Anchor:SetVisible(KBM.Options.CastBar.Visible)
	self.Anchor.Drag:SetVisible(KBM.Options.CastBar.Unlocked)

end

function KBM.CastBar:Pull()
	
	local GUI = {}
	if #self.Store > 0 then
		GUI = table.remove(self.Store)
		GUI.Frame:SetVisible(false)
	else
		GUI.Frame = UI.CreateFrame("Frame", "CastBar Frame", KBM.Context)
		GUI.Frame:SetWidth(KBM.Options.CastBar.w)
		GUI.Frame:SetHeight(KBM.Options.CastBar.h)
		GUI.Progress = UI.CreateFrame("Frame", "CastBar Progress Frame", GUI.Frame)
		GUI.Progress:SetWidth(0)
		GUI.Progress:SetHeight(GUI.Frame:GetHeight())
		GUI.Text = UI.CreateFrame("Text", "Castbar Text", GUI.Frame)
		GUI.Progress:SetLayer(1)
		GUI.Text:SetLayer(2)
		GUI.Text:SetFontSize(KBM.Options.CastBar.TextSize)
		GUI.Text:SetPoint("CENTER", GUI.Frame, "CENTER")
		GUI.Progress:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
		GUI.Frame:SetBackgroundColor(0,0,0,0.3)
		GUI.Progress:SetBackgroundColor(0.7,0,0,0.5)
		GUI.Frame:SetVisible(false)
	end
	return GUI
	
end

function KBM.CastBar:Add(Mod, Boss, Enabled)

	local CastBarObj = {}
	CastBarObj.UnitID = nil
	CastBarObj.Boss = Boss
	CastBarObj.Filters = Boss.CastFilters
	CastBarObj.HasFilters = Boss.HasCastFilters
	CastBarObj.Casting = false
	CastBarObj.LastCast = nil
	CastBarObj.Enabled = Enabled
	CastBarObj.Mod = Mod
	CastBarObj.Active = false
	function CastBarObj:Create(UnitID)
		self.UnitID = UnitID
		self.GUI = KBM.CastBar:Pull()
		self.GUI.Frame:SetWidth(KBM.Options.CastBar.w)
		self.GUI.Frame:SetHeight(KBM.Options.CastBar.h)
		self.GUI.Progress:SetWidth(0)
		self.GUI.Progress:SetHeight(self.GUI.Frame:GetHeight())
		if not KBM.Options.CastBar.x then
			self.GUI.Frame:SetPoint("CENTERX", UIParent, "CENTERX")
		else
			self.GUI.Frame:SetPoint("LEFT", UIParent, "LEFT", KBM.Options.CastBar.x, nil)
		end
		if not KBM.Options.CastBar.y then
			self.GUI.Frame:SetPoint("CENTERY", UIParent, "CENTERY")
		else
			self.GUI.Frame:SetPoint("TOP", UIParent, "TOP", nil, KBM.Options.CastBar.y)
		end
		KBM.CastBar.ActiveCastBars[UnitID] = self
		if Boss.PinCastBar then
			Boss:PinCastBar()
		end
		self.Active = true
	end
	function CastBarObj:Update()
		bDetails = Inspect.Unit.Castbar(self.UnitID)
		if bDetails then
			if bDetails.abilityName then
				if self.Enabled and KBM.Options.CastBar.Enabled then
					if self.HasFilters then
						if self.Filters[bDetails.abilityName] then
							if self.Filters[bDetails.abilityName].Enabled then
								if not self.Casting then
									self.Casting = true
									self.GUI.Frame:SetVisible(true)
								end
								bCastTime = bDetails.duration
								bProgress = bDetails.remaining						
								self.GUI.Progress:SetWidth(self.GUI.Frame:GetWidth() * (1-(bProgress/bCastTime)))
								self.GUI.Text:SetText(string.format("%0.01f", bProgress).." - "..bDetails.abilityName)
							else
								self.Casting = false
								self.GUI.Frame:SetVisible(false)
							end
						end
					else
						if not self.Casting then
							self.Casting = true
							self.GUI.Frame:SetVisible(true)
						end
						bCastTime = bDetails.duration
						bProgress = bDetails.remaining						
						self.GUI.Progress:SetWidth(self.GUI.Frame:GetWidth() * (1-(bProgress/bCastTime)))
						self.GUI.Text:SetText(string.format("%0.01f", bProgress).." - "..bDetails.abilityName)
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
				self.Casting = false
				self.GUI.Frame:SetVisible(false)
				self.LastCast = ""
			end
		else
			self.Casting = false
			self.GUI.Frame:SetVisible(false)
			self.LastCast = ""
		end
	end
	function CastBarObj:Remove()
		KBM.CastBar.ActiveCastBars[self.UnitID] = nil
		self.UnitID = nil
		self.Active = false
		self.GUI.Frame:SetVisible(false)
		table.insert(KBM.CastBar.Store, self.GUI)
		self.GUI = nil
	end
	self[Boss.Name] = CastBarObj
	return self[Boss.Name]

end

local function KBM_Reset()

	if KBM.Encounter then
		if KBM_CurrentMod then
			KBM.Idle.Wait = true
			KBM.Idle.Until = Inspect.Time.Real() + KBM.Idle.Duration
			KBM.Encounter = false
			KBM_CurrentMod:Reset()
			KBM_CurrentMod = nil
			KBM.CurrentBoss = ""
			KBM.BossID = {}
			KBM_CurrentBossName = ""
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
			KBM.Idle.Combat.Wait = false
		end
	else
		print("No encounter to reset.")
	end

end

function KBM.ConvertTime(Time)

	local TimeString = "00"
	local TimeSeconds = 0
	local TimeMinutes = 0
	local TimeHours = 0
	if Time >= 60 then
		TimeMinutes = math.floor(Time / 60)
		TimeSeconds = math.floor(Time) - (TimeMinutes * 60)
		if TimeMinutes >= 60 then
			TimeHours = math.floor(TimeMinutes / 60)
			TimeMinutes = TimeMinutes - (TimeHours * 60)
			TimeString = string.format("%dh:%02dm:%02ds", TimeHours, TimeMinutes, TimeSeconds)
		else
			TimeString = string.format("%02dm:%02ds", TimeMinutes, TimeSeconds)
		end
	else
		TimeString = string.format("%02ds", Time)
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
			local Dead = 0
			local Total = 0
			for BossID, BossObj in pairs(KBM.BossID) do
				if BossObj.dead then
					Dead = Dead + 1
				end
				Total = Total + 1
			end
			if Dead ~= Total then
				if KBM.Debug then
					print("Possible Wipe, waiting raid out of combat")
				end
				KBM.Idle.Combat.Wait = true
				KBM.Idle.Combat.Until = Inspect.Time.Real() + KBM.Idle.Combat.Duration
				KBM.Idle.Combat.StoreTime = KBM.TimeElapsed
			end
		end
	end
	
end

function KBM:Timer()

	if not KBM.Updating then
		KBM.Updating = true
		if KBM.QueuePage then
			if KBM.MainWin.CurrentPage then
				KBM.MainWin.CurrentPage:Remove()
			end
		end
		
		if KBM.Options.Enabled then
			if KBM.Encounter or KBM.Testing then
				local current = Inspect.Time.Real()
				local diff = (current - self.HeldTime)
				local udiff = (current - self.UpdateTime)
				if KBM_CurrentMod then
					KBM_CurrentMod:Timer(current, diff)
				end
				if diff >= 1 then
					self.TimeElapsed = math.floor(current) - self.StartTime
					if not KBM.Testing then
						if KBM_CurrentMod.Enrage then
							self.EnrageTimer = self.EnrageTime - math.floor(current)
						end
						if self.Options.EncTimer.Enabled then
							self.EncTimer:Update(current)
						end
					end
					self.HeldTime = current - (diff - math.floor(diff))
					self.UpdateTime = current
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
				if self.Alert.Current then
					self.Alert:Update(current)
				end
				if KBM.Idle.Combat.Wait then
					if KBM.Idle.Combat.Until < current then
						KBM.WipeIt()
					end
				end
			else
				-- for UnitID, CastCheck in pairs(KBM.CastBar.List) do
					-- CastCheck:Update()
				-- end
				-- if KBM.Testing then
					-- if self.Alert.Current then
						-- self.Alert:Update(Inspect.Time.Real())
					-- end
				-- end
			end
			-- if KBM.Testing then
				-- d = math.random(1,2000)
				-- if d < 20 then
					-- d = math.random(1, #KBM.Trigger.List)
					-- if KBM.Trigger.List[d].Type ~= "phase" and KBM.Trigger.List[d].Type ~= "percent" then
						-- KBM.Trigger.Queue:Add(KBM.Trigger.List[d], KBM_PlayerID, KBM_PlayerID, 2)
					-- end
				-- end
			-- end
		end
		if KBM.QueuePage then
			KBM.QueuePage:Open()
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
					-- if KBM_CurrentMod then
						-- KBM.BossID[UnitID].available = false
						-- KBM.BossID[UnitID].IdleSince = Inspect.Time.Real()
					-- end
				-- end
			-- end
		-- end
	-- end
	
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
					if KBM_CurrentMod:Death(UnitID) then
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
				if KBM_CurrentMod then
					if KBM.Trigger.Notify[KBM_CurrentMod.ID] then
						for i, TriggerObj in ipairs(KBM.Trigger.Notify[KBM_CurrentMod.ID]) do
							sStart, sEnd, Target = string.find(data.message, TriggerObj.Phrase)
							if sStart then
								unitID = nil
								if Target == KBM_PlayerName then
									unitID = KBM_PlayerID
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
				if KBM_CurrentMod then
					if KBM.Trigger.Say[KBM_CurrentMod.ID] then
						for i, TriggerObj in ipairs(KBM.Trigger.Say[KBM_CurrentMod.ID]) do
							if TriggerObj.Unit.Name == data.fromName then
								if string.find(data.message, TriggerObj.Phrase) then
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
			if unitID then
				for buffID, bool in pairs(Buffs) do
					bDetails = Inspect.Buff.Detail(unitID, buffID)
					if bDetails then
						if Type == "new" then
							if KBM.Trigger.Buff[bDetails.name] then
								TriggerObj = KBM.Trigger.Buff[bDetails.name]
								KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, bDetails.remaining)
							end
						end
					end
				end
			end
		end
	end
	
end

-- Phase Monitor options.
function KBM.MenuOptions.Phases:Options()
	
	-- Phase Monitor Callbacks.
	function self:Enabled(bool)
		KBM.Options.PhaseMon.Enabled = bool
	end
	function self:Visible(bool)
		KBM.Options.PhaseMon.Visible = bool
		KBM.PhaseMonitor.Anchor:SetVisible(bool)
	end
	function self:Unlocked(bool)
		KBM.Options.PhaseMon.Unlocked = bool
		KBM.PhaseMonitor.Anchor.Drag:SetVisible(bool)
	end
	function self:PhaseDisplay(bool)
		KBM.Options.PhaseMon.PhaseDisplay = bool
	end
	function self:Objectives(bool)
		KBM.Options.PhaseMon.Objectives = bool
	end

	local Options = self.MenuItem.Options
	Options:SetTitle()
	
	-- Timer Options
	local PhaseMon = Options:AddHeader(KBM.Language.Options.PhaseEnabled[KBM.Lang], self.Enabled, KBM.Options.PhaseMon.Enabled)
	PhaseMon:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.Visible, KBM.Options.PhaseMon.Visible)
	PhaseMon:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.Unlocked, KBM.Options.PhaseMon.Unlocked)
	PhaseMon:AddCheck(KBM.Language.Options.Phases[KBM.Lang], self.PhaseDisplay, KBM.Options.PhaseMon.PhaseDisplay)
	PhaseMon:AddCheck(KBM.Language.Options.Objectives[KBM.Lang], self.Objectives, KBM.Options.PhaseMon.Objectives)
	
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
	end
	function self:LockEncTimer(bool)
		KBM.Options.EncTimer.Unlocked = bool
		KBM.EncTimer.Frame.Drag:SetVisible(bool)
	end
	function self:EncDuration(bool)
		KBM.Options.EncTimer.Duration = bool
	end
	function self:EncEnrage(bool)
		KBM.Options.EncTimer.Enrage = bool
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
	end
	function self:LockMechAnchor(bool)
		KBM.Options.MechTimer.Unlocked = bool
		KBM.MechTimer.Anchor.Drag:SetVisible(bool)
	end
	function self:MechScaleHeight(bool, Check)
		KBM.Options.MechTimer.ScaleHeight = bool
		if not bool then
			KBM.Options.MechTimer.hScale = 1
			Check.Slider.Bar:SetPosition(100)
			KBM.MechTimer.Anchor:SetHeight(KBM.Options.MechTimer.h)
		end
	end
	function self:MechhScaleChange(value)
		KBM.Options.MechTimer.hScale = value * 0.01
		KBM.MechTimer.Anchor:SetHeight(KBM.Options.MechTimer.h * KBM.Options.MechTimer.hScale)
	end
	function self:MechScaleWidth(bool, Check)
		KBM.Options.MechTimer.ScaleWidth = bool
		if not bool then
			KBM.Options.MechTimer.wScale = 1
			Check.Slider.Bar:SetPosition(100)
			KBM.MechTimer.Anchor:SetWidth(KBM.Options.MechTimer.w)
		end
	end
	function self:MechwScaleChange(value)
		KBM.Options.MechTimer.wScale = value * 0.01
		KBM.MechTimer.Anchor:SetWidth(KBM.Options.MechTimer.w * KBM.Options.MechTimer.wScale)
	end
	function self:MechTextSize(bool, Check)
		KBM.Options.MechTimer.TextScale = bool
		if not bool then
			KBM.Options.MechTimer.TextSize = 14
			Check.Slider.Bar:SetPosition(KBM.Options.MechTimer.TextSize)
			KBM.MechTimer.Anchor.Text:SetFontSize(KBM.Options.MechTimer.TextSize)
		end
	end
	function self:MechTextChange(value)
		KBM.Options.MechTimer.TextSize = value
		KBM.MechTimer.Anchor.Text:SetFontSize(KBM.Options.MechTimer.TextSize)
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	
	-- Timer Options
	local Timers = Options:AddHeader(KBM.Language.Options.EncTimers[KBM.Lang], self.EncTimersEnabled, KBM.Options.EncTimer.Enabled)
	Timers:AddCheck(KBM.Language.Options.ShowTimer[KBM.Lang], self.ShowEncTimer, KBM.Options.EncTimer.Visible)
	Timers:AddCheck(KBM.Language.Options.LockTimer[KBM.Lang], self.LockEncTimer, KBM.Options.EncTimer.Unlocked)
	Timers:AddCheck(KBM.Language.Options.Timer[KBM.Lang], self.EncDuration, KBM.Options.EncTimer.Duration)
	Timers:AddCheck(KBM.Language.Options.Enrage[KBM.Lang], self.EncEnrage, KBM.Options.EncTimer.Enrage)
	local MechTimers = Options:AddHeader(KBM.Language.Options.MechanicTimers[KBM.Lang], self.MechEnabled, true)
	MechTimers.GUI.Check:SetEnabled(false)
	KBM.Options.MechTimer.Enabled = true
	MechTimers:AddCheck(KBM.Language.Options.Texture[KBM.Lang], self.MechTexture, KBM.Options.MechTimer.Texture)
	MechTimers:AddCheck(KBM.Language.Options.Shadow[KBM.Lang], self.MechShadow, KBM.Options.MechTimer.Shadow)
	MechTimers:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowMechAnchor, KBM.Options.MechTimer.Visible)
	MechTimers:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.LockMechAnchor, KBM.Options.MechTimer.Unlocked)
	-- self.MechTimers:AddCheck("Width scaling.", self.MechScaleWidth, KBM.Options.MechTimer.ScaleWidth)
	-- self.MechTimers:AddCheck("Enable Width mouse wheel scaling.", self.MechWidthMouse, KBM.Options.MechTimer.WidthMouse)
	-- local slider = self.MechTimers:AddSlider(50, 150, nil, (KBM.Options.MechTimer.wScale*100))
	-- Mechwidth:LinkSlider(slider, self.MechwScaleChange)
	-- local Mechheight = self.MechTimers:AddCheck("Height scaling.", self.MechScaleHeight, KBM.Options.MechTimer.ScaleHeight)
	-- slider = self.MechTimers:AddSlider(50, 150, nil, (KBM.Options.MechTimer.hScale*100))
	-- Mechheight:LinkSlider(slider, self.MechhScaleChange)
	-- local MechText = self.MechTimers:AddCheck("Text Size", self.MechTextSize, KBM.Options.MechTimer.TextScale)
	-- slider = self.MechTimers:AddSlider(8, 20, nil, KBM.Options.MechTimer.TextSize)
	-- MechText:LinkSlider(slider, self.MechTextChange)
	
end

function KBM.MenuOptions.TankSwap:Close()
	if KBM.TankSwap.Active then
		if KBM.TankSwap.Test then
			self.ShowTest(false)
			KBM.TankSwap.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
		end
	end
end

local function KBM_Version()
	print("You are running:")
	print("King Boss Mods v"..AddonData.toc.Version)
end

-- Tank Swap Menu Handler
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
	TankSwap:AddCheck(KBM.Language.Options.Tank[KBM.Lang], self.ShowTest, false)
	-- self.CastBars:AddCheck("Width scaling.", self.CastScaleWidth, KBM.Options.CastBar.ScaleWidth)
	-- self.CastBars:AddCheck("Height scaling.", self.CastScaleHeight, KBM.Options.CastBar.ScaleHeight)
	-- self.CastBars:AddCheck("Text Size", self.CastTextSize, KBM.Options.CastBar.TextScale)

end

function KBM.MenuOptions.CastBars:Options()

	-- Castbar Callbacks
	function self:CastBarEnabled(bool)
		KBM.Options.CastBar.Enabled = bool
	end
	function self:ShowCastAnchor(bool)
		KBM.Options.CastBar.Visible = bool
		KBM.CastBar.Anchor:SetVisible(bool)
	end
	function self:LockCastAnchor(bool)
		KBM.Options.CastBar.Unlocked = bool
		KBM.CastBar.Anchor.Drag:SetVisible(bool)
	end
	function self:CastScaleWidth(bool, Check)
		KBM.Options.CastBar.ScaleWidth = bool
		if not bool then
			KBM.Options.CastBar.wScale = 1
			Check.SliderObj.Bar.Frame:SetPosition(100)
			KBM.CastBar.Anchor:SetWidth(KBM.Options.CastBar.w)
		end
	end
	function self:CastwScaleChange(value)
		KBM.Options.CastBar.wScale = value * 0.01
		KBM.CastBar.Anchor:SetWidth(KBM.Options.CastBar.w * KBM.Options.CastBar.wScale)
	end
	function self:CastScaleHeight(bool, Check)
		KBM.Options.CastBar.ScaleHeight = bool
		if not bool then
			KBM.Options.CastBar.hScale = 1
			Check.SliderObj.Bar.Frame:SetPosition(100)
			KBM.CastBar.Anchor:SetHeight(KBM.Options.CastBar.h)
		end
	end
	function self:CasthScaleChange(value)
		KBM.Options.CastBar.hScale = value * 0.01
		KBM.CastBar.Anchor:SetHeight(KBM.Options.CastBar.h * KBM.Options.CastBar.hScale)
	end
	function self:CastTextSize(bool, Check)
		KBM.Options.CastBar.TextScale = bool
		if not bool then
			KBM.Options.CastBar.TextSize = 20
			Check.Slider.Bar:SetPosition(KBM.Options.CastBar.TextSize)
			KBM.CastBar.Anchor.Text:SetFontSize(KBM.Options.CastBar.TextSize)
		end
	end
	function self:CastTextChange(value)
		KBM.Options.CastBar.TextSize = value
		KBM.CastBar.Anchor.Text:SetFontSize(KBM.Options.CastBar.TextSize)
	end
	
	local Options = self.MenuItem.Options
	Options:SetTitle()

	-- CastBar Options. 
	local CastBars = Options:AddHeader(KBM.Language.Options.CastbarEnabled[KBM.Lang], self.CastBarEnabled, KBM.Options.CastBar.Enabled)
	CastBars:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowCastAnchor, KBM.Options.CastBar.Visible)
	CastBars:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.LockCastAnchor, KBM.Options.CastBar.Unlocked)
	-- self.CastBars:AddCheck("Width scaling.", self.CastScaleWidth, KBM.Options.CastBar.ScaleWidth)
	-- self.CastBars:AddCheck("Height scaling.", self.CastScaleHeight, KBM.Options.CastBar.ScaleHeight)
	-- self.CastBars:AddCheck("Text Size", self.CastTextSize, KBM.Options.CastBar.TextScale)

end

function KBM.MenuOptions.Alerts:Options()

	function self:AlertEnabled(bool)
		KBM.Options.Alert.Enabled = bool
	end
	function self:ShowAnchor(bool)
		KBM.Options.Alert.Visible = bool
		KBM.Alert.Anchor:SetVisible(bool)
		if bool then
			KBM.Alert.Anchor:SetAlpha(1)
		end
	end
	function self:LockAnchor(bool)
		KBM.Options.Alert.Unlocked = bool
		KBM.Alert.Anchor.Drag:SetVisible(bool)
	end
	function self:FlashEnabled(bool)
		KBM.Options.Alert.Flash = bool
	end
	function self:TextEnabled(bool)
		KBM.Options.Alert.Notify = bool
	end
	
	local Options = self.MenuItem.Options
	Options:SetTitle()

	local Alert = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.AlertEnabled, KBM.Options.Alert.Enabled)
	Alert:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowAnchor, KBM.Options.Alert.Visible)
	Alert:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.LockAnchor, KBM.Options.Alert.Unlocked)
	Alert:AddCheck(KBM.Language.Options.AlertFlash[KBM.Lang], self.FlashEnabled, KBM.Options.Alert.Flash)
	Alert:AddCheck(KBM.Language.Options.AlertText[KBM.Lang], self.TextEnabled, KBM.Options.Alert.Notify)
	
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
	local Enabled = Options:AddHeader(KBM.Language.Options.Enabled[KBM.Lang], self.Enabled, KBM.Options.Enabled)
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

local function KBM_Start()
	KBM.Button:Init()
	KBM.TankSwap:Init()
	KBM.Alert:Init()
	KBM.MechTimer:Init()
	KBM.CastBar:Init()
	KBM.EncTimer:Init()
	KBM.PhaseMonitor:Init()
	KBM.Trigger:Init()
	KBM.InitOptions()
	local Header = KBM.MainWin.Menu:CreateHeader("Options")
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
	table.insert(Event.SafesRaidManager.Combat.Damage, {KBM.MobDamage, "KingMolinator", "Combat Damage"})
	table.insert(Event.SafesRaidManager.Group.Combat.Damage, {KBM.RaidDamage, "KingMolinator", "Raid Damage"})
	-- table.insert(Event.Unit.Unavailable, {KBM_UnitRemoved, "KingMolinator", "Unit Unavailable"})
	table.insert(Event.Unit.Available, {KBM_UnitAvailable, "KingMolinator", "Unit Available"})
	table.insert(Event.System.Update.Begin, {function () KBM:Timer() end, "KingMolinator", "System Update"}) 
	table.insert(Event.SafesRaidManager.Combat.Death, {KBM_Death, "KingMolinator", "Combat Death"})
	table.insert(Event.SafesRaidManager.Combat.Enter, {KBM.CombatEnter, "KingMolinator", "Non raid combat enter"})
	table.insert(Event.SafesRaidManager.Combat.Leave, {KBM.CombatLeave, "KingMolinator", "Non raid combat leave"})
	table.insert(Event.SafesRaidManager.Group.Combat.End, {KBM.RaidCombatLeave, "KingMolinator", "Raid Combat Leave"})
	table.insert(Event.SafesRaidManager.Group.Combat.Start, {KBM.RaidCombatEnter, "KingMolinator", "Raid Combat Enter"})
	table.insert(Event.Unit.Castbar, {KBM_CastBar, "KingMolinator", "Cast Bar Event"})
	table.insert(Command.Slash.Register("kbmhelp"), {KBM_Help, "KingMolinator", "KBM Help"})
	table.insert(Command.Slash.Register("kbmversion"), {KBM_Version, "KingMolinator", "KBM Version Info"})
	table.insert(Command.Slash.Register("kbmoptions"), {KBM_Options, "KingMolinator", "KBM Open Options"})
	table.insert(Command.Slash.Register("kbmdebug"), {KBM_Debug, "KingMolinator", "KBM Debug on/off"})
	print("Welcome to King Boss Mods v"..AddonData.toc.Version)
	print("/kbmhelp for a list of commands.")
	print("/kbmoptions for options.")
	KBM.MenuOptions.Timers:Options()
	table.insert(Command.Slash.Register("kbmon"), {function() KBM.StateSwitch(true) end, "KingMolinator", "KBM On"})
	table.insert(Command.Slash.Register("kbmoff"), {function() KBM.StateSwitch(false) end, "KingMolinator", "KBM Off"})	
end

local function KBM_WaitReady(unitID)
	KBM_PlayerID = unitID
	KBM_PlayerName = Inspect.Unit.Detail(unitID).name
	KBM_Start()
	for _, Mod in ipairs(KBM.ModList) do
		Mod:AddBosses(KBM_Boss)
		Mod:Start(KBM_MainWin)
	end
	KBM.ApplySettings()
		
--	KBM.MenuGroup:SetMaster()
--	KBM.MenuGroup:SetExpertTwo()
--	KBM.MenuGroup:SetExpertOne()
	-- if KBM.Testing then
		-- TestBar = KBM.CastBar:Add(KBM, KBM.TestBoss, true)
		-- TestBar:Create(KBM_PlayerID)
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