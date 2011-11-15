-- King Boss Mods
-- Written By Paul Snart
-- Copyright 2011

KBM_GlobalOptions = nil
local KBM_BossMod = {}
local KingMol_Main = {}
local KBM = {}
KBM.Testing = false
KBM.TestFilters = {}
KBM.MenuOptions = {
	Timers = {},
	CastBars = {},
	TankSwap = {},
	Alerts = {},
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
			AutoReset = true,
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
				Unlocked = false,
				Visible = false,
				ScaleWidth = false,
				ScaleHeight = false,
				TextSize = 15,
				TextScale = false,
				Enrage = true,
				Duration = true,
			},
			MechTimer = {
				x = false,
				y = false,
				w = 350,
				h = 32,
				wScale = 1,
				hScale = 1,
				Enabled = true,
				Unlocked = false,
				Visible = false,
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
				Enabled = false,
				Unlocked = false,
				Visible = false,
				ScaleWidth = false,
				wScale = 1,
				hScale = 1,
				ScaleHeight = false,
				TextScale = false,
				TextSize = 20,
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
				Visible = false,
				Unlocked = false,
			},
			BestTimes = {
			},
		}
		KBM_GlobalOptions = KBM.Options
		for _, Mod in ipairs(KBM_BossMod) do
			Mod:InitVars()
		end
	end
end

local function KBM_LoadVars(AddonID)
	if AddonID == "KingMolinator" then
		if type(KBM_GlobalOptions) == "table" then
			for Setting, Value in pairs(KBM_GlobalOptions) do
				if type(KBM_GlobalOptions[Setting]) == "table" then
					if KBM.Options[Setting] ~= nil then
						for tSetting, tValue in pairs(KBM_GlobalOptions[Setting]) do
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
		for _, Mod in ipairs(KBM_BossMod) do
			Mod:LoadVars()
		end
	end
end

local function KBM_SaveVars(AddonID)
	if AddonID == "KingMolinator" then
		KBM_GlobalOptions = KBM.Options
		for _, Mod in ipairs(KBM_BossMod) do
			Mod:SaveVars()
		end
	end
end

function KBM_ToAbilityID(num)
	return string.format("a%016X", num)
end

KBM.Lang = Inspect.System.Language()
KBM.Language = {}
KBM.MenuGroup = {}
local KBM_Boss = {}
KBM.BossID = {}
KBM.Encounter = false
KBM.HeaderList = {}
KBM.CurrentBoss = ""
KBM.Phase = 1
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
KBM.CheckStore = {}
KBM.SlideStore = {}
KBM.TextfStore = {}
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
KBM.Language.Encounter.GLuck = KBM.Language:Add("Good luck!")
KBM.Language.Encounter.Wipe = KBM.Language:Add("Encounter ended, possible wipe.")
KBM.Language.Encounter.Victory = KBM.Language:Add("Encounter Victory!")
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
KBM.Language.Options.MechanicTimers = KBM.Language:Add("Mechanic Timers enabled.")
KBM.Language.Options.MechanicTimers.French = "Timers de M\195\169canisme."
KBM.Language.Options.MechanicTimers.German = "Mechanik Timers."
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
KBM.Language.Options.Timer.German = "Kampfdauer anzeige."
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
KBM.Language.Options.Settings = KBM.Language:Add("Settings")
KBM.Language.Options.Settings.French = "Configurations"
KBM.Language.Options.Settings.German = "Einstellungen"
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
	self.StartTimers = {}
	self.LastTimer = nil
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
	self.Anchor.Text:SetText(" 00.0 Timer Anchor")
	self.Anchor.Text:SetFontSize(KBM.Options.MechTimer.TextSize)
	self.Anchor.Text:ResizeToText()
	self.Anchor.Text:SetPoint("CENTERLEFT", self.Anchor, "CENTERLEFT")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor Drag", 2)
	self.Anchor:SetVisible(KBM.Options.MechTimer.Visible)
	self.Anchor.Drag:SetVisible(KBM.Options.MechTimer.Unlocked)
end

function KBM.MechTimer:Add(Name, Duration, Repeat)
	local Timer = {}
	Timer.Active = false
	Timer.Alerts = {}
	Timer.Timers = {}
	Timer.TimeStart = nil
	Timer.Removing = false
	Timer.Starting = false
	Timer.Time = Duration
	Timer.Delay = iStart
	Timer.Enabled = true
	Timer.Repeat = Repeat
	Timer.Name = Name
	function Timer:Start(CurrentTime)
		if self.Enabled then
			if self.Active then
				if not self.Removing then
					self.Removing = true
					table.insert(KBM.MechTimer.RemoveTimers, self)
				end
				if not self.Starting then
					table.insert(KBM.MechTimer.StartTimers, self)
					self.Starting = true
				end
				return
			end
			self.Starting = false
			local Anchor = KBM.MechTimer.Anchor
			self.Background = KBM:CallFrame(KBM.Context)
			self.Background:SetWidth(KBM.Options.MechTimer.w * KBM.Options.MechTimer.wScale)
			self.Background:SetHeight(KBM.Options.MechTimer.h * KBM.Options.MechTimer.hScale)
			self.Background:SetBackgroundColor(0,0,0,0.33)
			self.TimeBar = KBM:CallFrame(self.Background)
			self.TimeBar:SetWidth(KBM.Options.MechTimer.w * KBM.Options.MechTimer.wScale)
			self.TimeBar:SetHeight(KBM.Options.MechTimer.h * KBM.Options.MechTimer.hScale)
			self.TimeBar:SetPoint("TOPLEFT", self.Background, "TOPLEFT")
			self.TimeBar:SetLayer(1)
			self.TimeBar:SetBackgroundColor(0,0,1,0.33)
			self.TimeStart = CurrentTime
			self.Remaining = self.Time
			if self.Delay then
				self.Time = Delay
			end
			self.CastInfo = KBM:CallText(self.Background, self.Trigger)
			self.CastInfo:SetText(string.format(" %0.01f : ", self.Remaining)..self.Name)
			self.CastInfo:SetFontSize(KBM.Options.MechTimer.TextSize)
			self.CastInfo:SetPoint("CENTERLEFT", self.Background, "CENTERLEFT")
			self.CastInfo:SetLayer(2)
			self.CastInfo:ResizeToText()
			self.CastInfo:SetFontColor(1,1,1)
			if #KBM.MechTimer.ActiveTimers > 0 then
				for i, cTimer in ipairs(KBM.MechTimer.ActiveTimers) do
					if self.Remaining < cTimer.Remaining then
						self.Active = true
						if i == 1 then
							self.Background:SetPoint("TOPLEFT", Anchor, "TOPLEFT")
							cTimer.Background:SetPoint("TOPLEFT", self.Background, "BOTTOMLEFT", 0, 1)
						else
							self.Background:SetPoint("TOPLEFT", KBM.MechTimer.ActiveTimers[i-1].Background, "BOTTOMLEFT", 0, 1)
							cTimer.Background:SetPoint("TOPLEFT", self.Background, "BOTTOMLEFT", 0, 1)
						end
						table.insert(KBM.MechTimer.ActiveTimers, i, self)
						break
					end
				end
				if not self.Active then
					self.Background:SetPoint("TOPLEFT", KBM.MechTimer.LastTimer.Background, "BOTTOMLEFT", 0, 1)
					table.insert(KBM.MechTimer.ActiveTimers, self)
					KBM.MechTimer.LastTimer = self
					self.Active = true
				end
			else
				self.Background:SetPoint("TOPLEFT", KBM.MechTimer.Anchor, "TOPLEFT")
				table.insert(KBM.MechTimer.ActiveTimers, self)
				self.Active = true
				KBM.MechTimer.LastTimer = self
			end
		end
	end
	function Timer:Stop()
		for i, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
			if Timer == self then
				if #KBM.MechTimer.ActiveTimers == 1 then
					KBM.MechTimer.LastTimer = nil
				elseif i == 1 then
					KBM.MechTimer.ActiveTimers[i+1].Background:SetPoint("TOPLEFT", KBM.MechTimer.Anchor, "TOPLEFT")
				elseif i == #KBM.MechTimer.ActiveTimers then
					KBM.MechTimer.LastTimer = KBM.MechTimer.ActiveTimers[i-1]
				else
					KBM.MechTimer.ActiveTimers[i+1].Background:SetPoint("TOPLEFT", KBM.MechTimer.ActiveTimers[i-1].Background, "BOTTOMLEFT", 0, 1)
				end
				table.remove(KBM.MechTimer.ActiveTimers, i)
				break
			end
		end
		self.Active = false
		self.Remaining = 0
		self.TimeStart = 0
		self.Removing = false
		for i, AlertObj in pairs(self.Alerts) do
			self.Alerts[i].Triggered = false
		end
		self.CastInfo:sRemove()
		self.TimeBar:sRemove()
		self.Background:sRemove()
		-- if KBM.Testing then
			-- self.Starting = true
			-- table.insert(KBM.MechTimer.StartTimers, self)
		if self.Repeat then
			self.Starting = true
			table.insert(KBM.MechTimer.StartTimers, self)
		end
	end
	function Timer:AddAlert(AlertObj, Time)
		self.Alerts[Time] = {}
		self.Alerts[Time].Triggered = false
		self.Alerts[Time].AlertObj = AlertObj
	end
	function Timer:AddTimer(TimerObj, Time)
	
	end
	function Timer:AddTrigger(TriggerObj, Time)
	
	end
	function Timer:Update(CurrentTime)
		if self.Active then
			self.Remaining = self.Time - (CurrentTime - self.TimeStart)
			local text = string.format(" %0.01f : ", self.Remaining)..self.Name
			self.CastInfo:SetText(text)
			self.CastInfo:ResizeToText()
			self.TimeBar:SetWidth(self.Background:GetWidth() * (self.Remaining/self.Time))
			if self.Remaining <= 0 then
				self.Remaining = 0
				table.insert(KBM.MechTimer.RemoveTimers, self)
				self.Removing = true
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
	-- if KBM.Testing then
		-- Timer:Start(Inspect.Time.Real())
		-- table.insert(self.testTimerList, iTrigger)
	-- end
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
		if KBM.Encounter then
			if TriggerObj.Queued or self.Removing then
				return
			else
				TriggerObj.Queued = true
			end
			repeat
			until not self.Locked
			self.Locked = true
			table.insert(self.List, TriggerObj)
			TriggerObj.Caster = Caster
			TriggerObj.Target = Target
			TriggerObj.Data = Data		
			self.Locked = false
		end
	end
	
	function self.Queue:Activate()
		if KBM.Encounter then
			if self.Removing then
				return
			end
			repeat
			until not self.Locked
			self.Locked = true
			for i, TriggerObj in ipairs(self.List) do
				TriggerObj:Activate(TriggerObj.Caster, TriggerObj.Target, TriggerObj.Data)
				TriggerObj.Queued = false
			end
			self.List = {}
			self.Locked = false
		end
	end
	
	function self.Queue:Remove()
		self.Removing = true
		repeat
		until not self.Locked
		self.Locked = true
		self.List = {}
		self.Locked = false
		self.Removing = false
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
			if self.Type == "damage" then
				for i, Timer in ipairs(self.Timers) do
					if Timer.Active then
						if Timer.Remaining < 3 then
							Timer:Start(Inspect.Time.Real())
						end
					else
						Timer:Start(Inspect.Time.Real())
					end
				end
			else
				for i, Timer in ipairs(self.Timers) do
					Timer:Start(Inspect.Time.Real())
				end
			end
			for i, AlertObj in ipairs(self.Alerts) do
				if AlertObj.Player then
					if KBM_PlayerID == Target then
						KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
					end
				else
					KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
				end
			end
			for i, Obj in ipairs(self.Stop) do
				Obj:Stop()
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
			TriggerObj.Percent = Trigger
			self.Percent[Unit.Name] = TriggerObj
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
	local frame = nil
	if #self.FrameStore == 0 then
		self.TotalFrames = self.TotalFrames + 1
		frame = UI.CreateFrame("Frame", "Frame Store"..self.TotalFrames, parent)
		function frame:sRemove()
			for EventName, pFunction in pairs(self.Event) do
				self.Event[EventName] = nil
			end
			self:SetParent(KBM.Context)
			self:ClearAll()
			self:SetVisible(false)
			self:SetLayer(0)
			self:SetBackgroundColor(0,0,0,0)
			table.insert(KBM.FrameStore, self)
		end
	else
		frame = table.remove(self.FrameStore)
		frame:SetParent(parent)
		frame:SetVisible(parent:GetVisible())
		frame:SetAlpha(1)
	end
	return frame
end

function KBM:CallCheck(parent)
	local Checkbox = nil
	if #self.CheckStore == 0 then
		self.TotalChecks = self.TotalChecks + 1
		Checkbox = UI.CreateFrame("RiftCheckbox", "Check Store"..self.TotalChecks, parent)
		function Checkbox:sRemove()
			for EventName, pFunction in pairs(self.Event) do
				self.Event[EventName] = nil
			end
			self:ClearAll()
			self:SetParent(KBM.Context)
			self:SetVisible(false)
			self:SetLayer(0)
			table.insert(KBM.CheckStore, self)
		end
	else
		Checkbox = table.remove(self.CheckStore)
		Checkbox:SetParent(parent)
		Checkbox:SetVisible(parent:GetVisible())
		Checkbox:SetEnabled(true)
		Checkbox:SetAlpha(1)
	end
	return Checkbox
end

function KBM:CallText(parent, debugInfo)
	local Textfbox = nil
	if #self.TextfStore == 0 then
		self.TotalTexts = self.TotalTexts + 1
		Textfbox = UI.CreateFrame("Text", "Textf Store"..self.TotalTexts, parent)
		function Textfbox:sRemove()
			for EventName, pFunction in pairs(self.Event) do
				self.Event[EventName] = nil
			end
			self:SetText("")
			self:ClearAll()
			self:SetParent(KBM.Context)
			self:SetVisible(false)
			self:SetLayer(0)
			table.insert(KBM.TextfStore, self)
		end
	else
		Textfbox = table.remove(self.TextfStore)
		Textfbox:SetParent(parent)
		Textfbox:SetFontColor(1,1,1,1)
		Textfbox:SetVisible(parent:GetVisible())
		Textfbox:SetAlpha(1)
	end
	return Textfbox
end

function KBM:CallSlider(parent)
	local Slider = nil
	if #self.SlideStore == 0 then
		self.TotalSliders = self.TotalSliders + 1
		Slider = UI.CreateFrame("RiftSlider", "Slide Store"..self.TotalSliders, parent)
		function Slider:sRemove()
			for EventName, pFunction in pairs(self.Event) do
				self.Event[EventName] = nil
			end
			self:SetParent(KBM.Context)
			self:SetVisible(false)
			self:ClearAll()
			self:SetLayer(0)
			table.insert(KBM.SlideStore, self)
		end
	else
		Slider = table.remove(self.SlideStore)
		Slider:SetParent(parent)
		Slider:SetVisible(true)
		Slider:SetEnabled(true)
		Slider:SetAlpha(1)
	end
	return Slider
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

function KBM.PhaseMonitor:Init()
	
	self.TestMode = false
	self.Frame = UI.CreateFrame("Frame", "Phase Monitor", KBM.Context)
	
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
	self.Frame.Text:ResizeToText()
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
	self.Enrage.Text:ResizeToText()
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
			self.Frame.Text:ResizeToText()
		end
		if KBM.Options.EncTimer.Enrage then
			if KBM_CurrentMod.Enrage then
				if current < KBM.EnrageTime then
					EnrageString = KBM.ConvertTime(KBM.EnrageTime - current + 1)
					self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." "..EnrageString)
					self.Enrage.Text:ResizeToText()
					self.Enrage.Progress:SetPoint("RIGHT", self.Enrage.Frame, KBM.TimeElapsed/KBM_CurrentMod.Enrage, nil)
				else
					self.Enrage.Text:SetText("!! Enraged !!")
					self.Enrage.Text:ResizeToText()
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
			self.Enrage.Text:ResizeToText()
			self.Frame.Text:SetText(KBM.Language.Timers.Timer[KBM.Lang].." 00m:00s")
			self.Frame.Text:ResizeToText()
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
	if not KBM.BossID[UnitID] then
		if uDetails then
			if KBM_Boss[uDetails.name] then
				--if uDetails.level == KBM_Boss[uDetails.name].Level then
					KBM.BossID[UnitID] = {}
					KBM.BossID[UnitID].name = uDetails.name
					KBM.BossID[UnitID].monitor = true
					KBM.BossID[UnitID].Mod = KBM_Boss[uDetails.name].Mod
					KBM.BossID[UnitID].IdleSince = false
					if KBM_Boss[uDetails.name].TimeOut then
						KBM.BossID[UnitID].TimeOut = KBM_Boss[uDetails.name].TimeOut
					else
						KBM.BossID[UnitID].TimeOut = 0
					end
					if uDetails.health > 0 then
						KBM.BossID[UnitID].dead = false
						KBM.BossID[UnitID].available = true
						if not KBM.Encounter then
							KBM.Encounter = true
							KBM.CurrentBoss = UnitID
							KBM_CurrentBossName = uDetails.name
							KBM_CurrentMod = KBM.BossID[UnitID].Mod
							if not KBM_CurrentMod.EncounterRunning then
								print(KBM.Language.Encounter.Start[KBM.Lang].." "..KBM_Boss[uDetails.name].Descript)
								print(KBM.Language.Encounter.GLuck[KBM.Lang])
								KBM.TimeElapsed = 0
								KBM.StartTime = Inspect.Time.Real()
								if KBM_CurrentMod.Enrage then
									KBM.EnrageTime = KBM.StartTime + KBM_CurrentMod.Enrage
								end
								if KBM.Options.EncTimer.Enabled then
									KBM.EncTimer:Start(KBM.StartTime)
								end
							end
						end
						KBM.BossID[UnitID].Boss = KBM_CurrentMod:UnitHPCheck(uDetails, UnitID)
						
					else
						KBM.BossID[UnitID].dead = true
						KBM.BossID[UnitID].available = false
					end					
				--end
			end
		end
	else
		if not KBM.BossID[UnitID].dead then
			if KBM.BossID[UnitID].IdleSince then
				if uDetails then
					KBM_CurrentMod:UnitHPCheck(uDetails, UnitID)
					KBM.BossID[UnitID].IdleSince = false
					KBM.BossID[UnitID].available = true
				-- else
					-- KBM.BossID[UnitID].IdleSince = Inspect.Time.Real()
				end
			end
		end
	end
end

local function KBM_UnitHPCheck(info)

	-- Damage Based Events
	--
	local tUnitID = info.target
	local cUnitID = info.caster
	local tDetails = Inspect.Unit.Detail(tUnitID)
	local cDetails = Inspect.Unit.Detail(cUnitID)
	if tDetails and cDetails then
		if cDetails.player then
			if not tDetails.player then
				KBM.CheckActiveBoss(tDetails, tUnitID)
			end
		end
		if tDetails.player then
			if not cDetails.player then
				KBM.CheckActiveBoss(cDetails, cUnitID)
			end
		end
	end
	if KBM.Encounter then
		if tUnitID then
			if KBM.BossID[tUnitID] then
				if KBM.BossID[tUnitID].IdleSince then
					KBM.BossID[tUnitID].IdleSince = Inspect.Time.Real()
				end
			end
		end
		if cUnitID then
			if KBM.BossID[cUnitID] then
				if KBM.BossID[cUnitID].IdleSince then
					KBM.BossID[cUnitID].IdleSince = Inspect.Time.Real()
				end
			end
		end
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

local function KBM_UnitAvailable(units)

	if KBM.Encounter then
		for UnitID, Specifier in pairs(units) do
			if KBM.BossID[UnitID] then
				if KBM.BossID[UnitID].IdleSince then
					KBM.CheckActiveBoss(Inspect.Unit.Detail(UnitID), UnitID)
				end
			end
		end
	end
	
end

function KBM.AttachDragFrame(parent, hook, name, layer)

	if not name then name = "" end
	if not layer then layer = 0 end
	
	local Drag = {}
	Drag.Frame = KBM:CallFrame(parent)
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

function KBM.TankSwap:Init()
	self.Tanks = {}
	self.TankCount = 0
	self.Active = false
	self.DebuffID = nil
	self.LastTank = nil
	self.Test = false
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
	self.Anchor.Text:ResizeToText()
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
		TankObj.Frame = KBM:CallFrame(KBM.Context)
		TankObj.Frame:SetLayer(1)
		TankObj.Frame:SetHeight(KBM.Options.TankSwap.h)
		TankObj.Frame:SetBackgroundColor(0,0,0,0.4)
		if self.TankCount == 0 then
			TankObj.Frame:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
			TankObj.Frame:SetPoint("TOPRIGHT", self.Anchor, "TOPRIGHT")
		else
			TankObj.Frame:SetPoint("TOPLEFT", self.LastTank.Frame, "BOTTOMLEFT", 0, 2)
			TankObj.Frame:SetPoint("RIGHT", self.LastTank.Frame, "RIGHT")
		end
		TankObj.TankFrame = KBM:CallFrame(TankObj.Frame)
		TankObj.TankFrame:SetPoint("TOPLEFT", TankObj.Frame, "TOPLEFT")
		TankObj.TankFrame:SetPoint("BOTTOMLEFT", TankObj.Frame, "CENTERLEFT")
		TankObj.TankHP = KBM:CallFrame(TankObj.TankFrame)
		TankObj.TankHP:SetLayer(1)
		TankObj.TankText = KBM:CallText(TankObj.TankFrame)
		TankObj.TankText:SetLayer(2)
		TankObj.TankText:SetText(TankObj.Name)
		TankObj.TankText:SetFontSize(KBM.Options.TankSwap.TextSize)
		TankObj.TankText:ResizeToText()
		TankObj.TankText:SetPoint("CENTERLEFT", TankObj.TankFrame, "CENTERLEFT", 2, 0)
		TankObj.DebuffFrame = KBM:CallFrame(TankObj.Frame)
		TankObj.DebuffFrame:SetPoint("TOPRIGHT", TankObj.Frame, "TOPRIGHT")
		TankObj.DebuffFrame:SetPoint("BOTTOMRIGHT", TankObj.Frame, "CENTERRIGHT")
		TankObj.DebuffFrame:SetPoint("LEFT", TankObj.Frame, 0.8, nil)
		TankObj.DebuffFrame:SetBackgroundColor(0.5,0,0,0.4)
		TankObj.DebuffFrame:SetLayer(1)
		TankObj.DebuffFrame.Text = KBM:CallText(TankObj.DebuffFrame)
		TankObj.DebuffFrame.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
		TankObj.DebuffFrame.Text:SetLayer(2)
		TankObj.DebuffFrame.Text:ResizeToText()
		TankObj.DebuffFrame.Text:SetPoint("CENTER", TankObj.DebuffFrame, "CENTER")
		TankObj.TankFrame:SetPoint("TOPRIGHT", TankObj.DebuffFrame, "TOPLEFT")
		TankObj.TankHP:SetPoint("TOPLEFT", TankObj.TankFrame, "TOPLEFT")
		TankObj.TankHP:SetPoint("BOTTOM", TankObj.TankFrame, "BOTTOM")
		TankObj.TankHP:SetPoint("RIGHT", TankObj.TankFrame, 1, nil)
		TankObj.DeCoolFrame = KBM:CallFrame(TankObj.Frame)
		TankObj.DeCoolFrame:SetPoint("TOPLEFT", TankObj.TankFrame, "BOTTOMLEFT")
		TankObj.DeCoolFrame:SetPoint("BOTTOM", TankObj.Frame, "BOTTOM")
		TankObj.DeCoolFrame:SetPoint("RIGHT", TankObj.Frame, "RIGHT")
		TankObj.DeCool = KBM:CallFrame(TankObj.DeCoolFrame)
		TankObj.DeCool:SetPoint("TOPLEFT", TankObj.DeCoolFrame, "TOPLEFT")
		TankObj.DeCool:SetPoint("BOTTOM", TankObj.DeCoolFrame, "BOTTOM")
		TankObj.DeCool:SetPoint("RIGHT", TankObj.DeCoolFrame, 1, nil)
		TankObj.DeCool:SetBackgroundColor(0,0,1,0.4)
		TankObj.DeCool.Text = KBM:CallText(TankObj.DeCoolFrame)
		TankObj.DeCool.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
		TankObj.DeCool.Text:ResizeToText()
		TankObj.DeCool.Text:SetPoint("CENTER", TankObj.DeCoolFrame, "CENTER")
		TankObj.DeCool.Text:SetLayer(2)
		self.LastTank = TankObj
		self.Tanks[TankObj.UnitID] = TankObj
		self.TankCount = self.TankCount + 1
		if self.Test then
			TankObj.DebuffFrame.Text:SetText("2")
			TankObj.DebuffFrame.Text:ResizeToText()
			TankObj.DeCool.Text:SetText("99.9")
			TankObj.DeCool.Text:ResizeToText()
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
				TankObj.DeCoolFrame:SetVisible(false)
				TankObj.DeCool:SetPoint("RIGHT", TankObj.DeCoolFrame, 1, nil)
				TankObj.DebuffFrame.Text:SetVisible(false)
			else
				TankObj.DeCool.Text:SetText(string.format("%0.01f", TankObj.Remaining))
				TankObj.DeCool:SetPoint("RIGHT", TankObj.DeCoolFrame, (TankObj.Remaining/TankObj.Duration), nil)
				TankObj.DeCool.Text:ResizeToText()
				TankObj.DeCoolFrame:SetVisible(true)
				if TankObj.Stacks then
					TankObj.DebuffFrame.Text:SetText(TankObj.Stacks)
				else
					TankObj.DebuffFrame.Text:SetText("-")
				end
				TankObj.DebuffFrame.Text:ResizeToText()
				TankObj.DebuffFrame.Text:SetVisible(true)
			end
		end
	end
	function self:Remove()
		for UnitID, TankObj in pairs(self.Tanks) do
			TankObj.DeCool.Text:sRemove()
			TankObj.DebuffFrame.Text:sRemove()
			TankObj.DeCool:sRemove()
			TankObj.DeCoolFrame:sRemove()
			TankObj.DebuffFrame:sRemove()
			TankObj.TankText:sRemove()
			TankObj.TankHP:sRemove()
			TankObj.TankFrame:sRemove()
			TankObj.Frame:sRemove()
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
	self.Shadow:ResizeToText()
	self.Text:ResizeToText()
	self.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Text:SetLayer(2)
	self.Anchor:SetWidth(self.Text:GetWidth())
	self.Anchor:SetHeight(self.Text:GetHeight())
	self.Anchor:SetVisible(KBM.Options.Alert.Visible)
	self.ColorList = {"red", "blue", "yellow", "orange", "purple", "dark_green"}
	self.Left = {}
	self.Right = {}
	for _t, Color in ipairs(self.ColorList) do
		self.Left[Color] = UI.CreateFrame("Texture", "Left Alert", KBM.Context)
		self.Left[Color]:SetTexture("KingMolinator", "Media/Alert_Left_"..Color..".png")
		self.Left[Color]:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
		self.Left[Color]:SetPoint("BOTTOM", UIParent, "BOTTOM")
		self.Left[Color]:SetVisible(false)
		self.Right[Color] = UI.CreateFrame("Texture", "Right Alert", KBM.Context)
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
		
		function AlertObj:AlertEnd(endAlertObj)
			self.AlertAfter = endAlertObj
		end
		
		table.insert(self.List, AlertObj)
		return AlertObj
	end
	function self:Start(AlertObj, CurrentTime, Duration)
		if self.Current then
			self:Stop()
		end
		if KBM.Options.Alert.Enabled then
			if Duration then
				if not self.DefaultDuration then
					self.Duration = Duration
				end
			else
				if not self.DefaultDuration then
					self.Duration = 2
				end
			end
			self.Current = AlertObj
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
					self.Text:SetText(AlertObj.Text)
					self.Shadow:SetText(AlertObj.Text)
					self.Shadow:ResizeToText()
					self.Text:ResizeToText()
					self.Anchor:SetVisible(true)
					self.Anchor:SetAlpha(1)
				end
			end
			if AlertObj.Duration then
				self.StopTime = CurrentTime + AlertObj.Duration
				self.Remaining = self.StopTime - CurrentTime
			else
				self.StopTime = false
			end
			self:Update(CurrentTime)
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
						self.Text:SetText(self.Current.Text)
						self.Shadow:SetText(self.Current.Text)
						self.Shadow:ResizeToText()
						self.Text:ResizeToText()
					else
						local CDText = string.format("%0.1f - "..self.Current.Text, self.Remaining)
						self.Shadow:SetText(CDText)
						self.Text:SetText(CDText)
						self.Shadow:ResizeToText()
						self.Text:ResizeToText()
					end
				end
			end
			if self.StopTime then
				if self.StopTime <= CurrentTime then
					if self.Current.AlertAfter then
						self:Start(self.Current.AlertAfter, Inspect.Time.Real())
					else
						self.Direction = -self.Speed
						self.Current.Stopping = true
					end
				end
			end
		end
	end
	function self:Stop()
		self.Current.Stopping = false
		self.Current = nil
		self.StopTime = false
		self.Left[self.Color]:SetVisible(false)
		self.Right[self.Color]:SetVisible(false)
		self.Anchor:SetVisible(false)
		self.Text:SetText(" Alert Anchor ")
		self.Shadow:SetText(" Alert Anchor ")
		self.Text:ResizeToText()
		self.Shadow:ResizeToText()
	end
	
end

function KBM.CastBar:Init()

	self.CastBarList = {}
	self.ActiveCastBars = {}
	self.RemoveCastBars = {}
	self.WaitCastBars = {}
	self.StartCastBars = {}
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
	self.Anchor.Text:ResizeToText()
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end , "CB Anchor Drag", 2)
	self.Anchor:SetVisible(KBM.Options.CastBar.Visible)
	self.Anchor.Drag:SetVisible(KBM.Options.CastBar.Unlocked)

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
	function CastBarObj:Position(uType)
		if uType == "end" then
			self.Boss.Settings.CastBar.x = self.Frame.GetLeft() 
			self.Boss.Settings.CastBar.y = self.Frame.GetRight()
		end
	end
	function CastBarObj:Create(UnitID)
		self.UnitID = UnitID
		self.Frame = KBM:CallFrame(KBM.Context)
		self.Frame:SetWidth(KBM.Options.CastBar.w)
		self.Frame:SetHeight(KBM.Options.CastBar.h)
		self.Progress = KBM:CallFrame(self.Frame)
		self.Progress:SetWidth(0)
		self.Progress:SetHeight(self.Frame:GetHeight())
		self.Text = KBM:CallText(self.Frame)
		self.Progress:SetLayer(1)
		self.Text:SetLayer(2)
		self.Text:SetPoint("CENTER", self.Frame, "CENTER")
		if not KBM.Options.CastBar.x then
			self.Frame:SetPoint("CENTERX", UIParent, "CENTERX")
		else
			self.Frame:SetPoint("LEFT", UIParent, "LEFT", KBM.Options.CastBar.x, nil)
		end
		if not KBM.Options.CastBar.y then
			self.Frame:SetPoint("CENTERY", UIParent, "CENTERY")
		else
			self.Frame:SetPoint("TOP", UIParent, "TOP", nil, KBM.Options.CastBar.y)
		end
		self.Progress:SetPoint("TOPLEFT", self.Frame, "TOPLEFT")
		self.Frame:SetBackgroundColor(0,0,0,0.3)
		self.Progress:SetBackgroundColor(0.7,0,0,0.5)
		self.Drag = KBM.AttachDragFrame(self.Frame, function(uType) self:Position(uType) end, self.Boss.Name.." Drag", 2)
		self.Drag:SetVisible(false)
		KBM.CastBar.ActiveCastBars[UnitID] = self
		if Boss.PinCastBar then
			Boss:PinCastBar()
		end
	end
	function CastBarObj:Update()
		bDetails = Inspect.Unit.Castbar(self.UnitID)
		if bDetails then
			if bDetails.abilityName then
				if self.Enabled then
					if self.HasFilters then
						if self.Filters[bDetails.abilityName] then
							if self.Filters[bDetails.abilityName].Enabled then
								if not self.Casting then
									self.Casting = true
									self.Frame:SetVisible(true)
								end
								bCastTime = bDetails.duration
								bProgress = bDetails.remaining						
								self.Progress:SetWidth(self.Frame:GetWidth() * (1-(bProgress/bCastTime)))
								self.Text:SetText(string.format("%0.01f", bProgress).." - "..bDetails.abilityName)
								self.Text:ResizeToText()
							else
								self.Casting = false
								self.Frame:SetVisible(false)
							end
						end
					else
						if not self.Casting then
							self.Casting = true
							self.Frame:SetVisible(true)
						end
						bCastTime = bDetails.duration
						bProgress = bDetails.remaining						
						self.Progress:SetWidth(self.Frame:GetWidth() * (1-(bProgress/bCastTime)))
						self.Text:SetText(string.format("%0.01f", bProgress).." - "..bDetails.abilityName)
						self.Text:ResizeToText()	
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
				self.Frame:SetVisible(false)
				self.LastCast = ""
			end
		else
			self.Casting = false
			self.Frame:SetVisible(false)
			self.LastCast = ""
		end
	end
	function CastBarObj:Remove()
		KBM.CastBar.ActiveCastBars[self.UnitID] = nil
		self.UnitID = nil
		self.Text:sRemove()
		self.Progress:sRemove()
		self.Frame:sRemove()
		self.Drag:Remove()
	end
	self[Boss.Name] = CastBarObj
	return self[Boss.Name]

end

local function KBM_Reset()
	if KBM.Encounter then
		if KBM_CurrentMod then
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
					table.insert(KBM.MechTimer.RemoveTimers, Timer)
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
		end
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
	if Time >= 60 then
		TimeMinutes = math.floor(Time / 60)
		TimeSeconds = Time - (TimeMinutes * 60)
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

function KBM:CheckBossStates(current)
	for UnitID, BossData in pairs(self.BossID) do
		if not BossData.available then
			if BossData.IdleSince then
				if BossData.IdleSince + BossData.TimeOut <= current then
					if KBM_CurrentMod:RemoveUnits(UnitID) then
						print(KBM.Language.Encounter.Wipe[KBM.Lang])
						print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(BossData.IdleSince - KBM.StartTime))
						KBM_Reset()
						break
					end			
				end
			end
		end
	end
end

function KBM:Timer()
	if KBM.Encounter then
		local current = Inspect.Time.Real()
		local diff = (current - self.HeldTime)
		local udiff = (current - self.UpdateTime)
		if KBM_CurrentMod then
			KBM_CurrentMod:Timer(current, diff)
		end
		if diff >= 1 then
			self.TimeElapsed = current - self.StartTime
			if not KBM.Testing then
				if KBM_CurrentMod.Enrage then
					self.EnrageTimer = self.EnrageTime - current
				end
				if self.Options.EncTimer.Enabled then
					self.EncTimer:Update(current)
				end
			end
			self.HeldTime = current - (diff - math.floor(diff))
			self.UpdateTime = current
			self:CheckBossStates(current)			
		end
		if udiff >= 0.05 then
			for UnitID, CastCheck in pairs(KBM.CastBar.ActiveCastBars) do
				CastCheck:Update()
			end
			if #self.MechTimer.ActiveTimers > 0 then
				for i, Timer in ipairs(self.MechTimer.ActiveTimers) do
					Timer:Update(current)
				end
			end
			self.UpdateTime = current
			if not KBM.TankSwap.Test then
				if KBM.TankSwap.Active then
					KBM.TankSwap:Update()
				end
			end
		end
		if self.Alert.Current then
			self.Alert:Update(Inspect.Time.Real())
		end
		self.Trigger.Queue:Activate()
		if #self.MechTimer.RemoveTimers > 0 then
			for i, Timer in ipairs(self.MechTimer.RemoveTimers) do
				Timer:Stop()
			end
			self.MechTimer.RemoveTimers = {}
		end
		if #self.MechTimer.StartTimers > 0 then
			for i, Timer in ipairs(self.MechTimer.StartTimers) do
				Timer:Start(current)
			end
			self.MechTimer.StartTimers = {}
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
			-- KBM.Trigger.Queue:Add(KBM.Trigger.List[d], KBM_PlayerID, KBM_PlayerID, d)
		-- end
	-- end	
end

local function KBM_CastBar(units)

	if KBM.Encounter then
		if KBM_CurrentCBHook then
			KBM_CurrentCBHook(units)
		end
	--else
		-- Testing Only!
		--KM_CastBar(units)
	end
end

function KBM:TimeToHours(Time)
	self.TimeVisual.String = "00"
	if Time >= 60 then
		self.TimeVisual.Minutes = math.floor(Time / 60)
		self.TimeVisual.Seconds = Time - (self.TimeVisual.Minutes * 60)
		if self.TimeVisual.Minutes >= 60 then
			self.TimeVisual.Hours = math.floor(self.TimeVisual.Minutes / 60)
			self.TimeVisual.Minutes = self.TimeVisual.Minutes - math.floor(self.TimeVisual.Hours * 60)
		else
			self.TimeVisual.String = string.format("%02d:%02d", self.TimeVisual.Minutes, self.TimeVisual.Seconds)
		end
	else
		self.TimeVisual.Seconds = Time
		self.TimeVisual.String = string.format("%02d", self.TimeVisual.Seconds)
	end
end

local function KM_ToggleEnabled(result)
	
end

local function KBM_UnitRemoved(units)

	if KBM.Encounter then
		for UnitID, Specifier in pairs(units) do
			if not Inspect.Unit.Detail(UnitID) then
				if KBM.BossID[UnitID] then
					if KBM_CurrentMod then
						KBM.BossID[UnitID].available = false
						KBM.BossID[UnitID].IdleSince = Inspect.Time.Real()
					end
				end
			end
		end
	end
	
end

local function KBM_Death(info)
	
	if KBM.Encounter then
		local UnitID = info.target
		if UnitID then
			local uDetails = Inspect.Unit.Detail(UnitID)
			if uDetails then
				if not uDetails.player then
					if KBM.BossID[UnitID] then
						KBM.BossID[UnitID].dead = true
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
	
end

local function KBM_AutoReset()
	-- if KBM.Options.AutoReset then
		-- KBM.Options.AutoReset = false
		-- print("Auto-Reset is now off.")
	-- else
		-- KBM.Options.AutoReset = true
		-- print("Auto-Reset is now on (Experimental: Please report the accuracy of this.)")
	-- end
end

local function KBM_Help()
	print("King Boss Mods in game slash commands")
	print("/kbmreset -- Resets the current encounter.")
	print("/kbmoptions -- Toggles the GUI Options screen.")
	print("/kbmhelp -- Displays what you're reading now :)")
end

function KBM.Notify(data)
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

function KBM.NPCChat(data)
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

-- Used to manage Triggers and soon Tank-Swap managing.
function KBM:BuffMonitor(unitID, Buffs, Type)
	if unitID then
		for buffID, bool in pairs(Buffs) do
			bDetails = Inspect.Buff.Detail(unitID, buffID)
			if bDetails then
				if Type == "added" then
					if KBM.Trigger.Buff[bDetails.name] then
						TriggerObj = KBM.Trigger.Buff[bDetails.name]
						KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, bDetails.remaining)
					end
				end
			end
		end
	end
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
			KBM.MechTimer.Anchor.Text:ResizeToText()
		end
	end
	function self:MechTextChange(value)
		KBM.Options.MechTimer.TextSize = value
		KBM.MechTimer.Anchor.Text:SetFontSize(KBM.Options.MechTimer.TextSize)
		KBM.MechTimer.Anchor.Text:ResizeToText()
	end
	Options = self.MenuItem.Options
	Options:SetTitle()
	
	-- Timer Options
	self.Menu = {}
	self.Menu.EncTimers = Options:AddHeader(KBM.Language.Options.EncTimers[KBM.Lang], self.EncTimersEnabled, KBM.Options.EncTimer.Enabled)
	self.Menu.EncTimers:AddCheck(KBM.Language.Options.ShowTimer[KBM.Lang], self.ShowEncTimer, KBM.Options.EncTimer.Visible)
	self.Menu.EncTimers:AddCheck(KBM.Language.Options.LockTimer[KBM.Lang], self.LockEncTimer, KBM.Options.EncTimer.Unlocked)
	self.Menu.EncTimers:AddCheck(KBM.Language.Options.Timer[KBM.Lang], self.EncDuration, KBM.Options.EncTimer.Duration)
	self.Menu.EncTimers:AddCheck(KBM.Language.Options.Enrage[KBM.Lang], self.EncEnrage, KBM.Options.EncTimer.Enrage)
	self.Menu.MechTimers = Options:AddHeader(KBM.Language.Options.MechanicTimers[KBM.Lang], self.MechEnabled, true)
	self.Menu.MechTimers.Check.Frame:SetEnabled(false)
	KBM.Options.MechTimer.Enabled = true
	self.Menu.MechTimers:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowMechAnchor, KBM.Options.MechTimer.Visible)
	self.Menu.MechTimers:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.LockMechAnchor, KBM.Options.MechTimer.Unlocked)
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
			self.TestLink.Check.Frame:SetChecked(false)
			KBM.TankSwap.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
		end
	end
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
			KBM.TankSwap.Anchor.Text:ResizeToText()
		end
	end
	function self:TextChange(value)
		KBM.Options.TankSwap.TextSize = value
		KBM.CastBar.Anchor.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
		KBM.CastBar.Anchor.Text:ResizeToText()
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
	Options = self.MenuItem.Options
	Options:SetTitle()

	-- Tank-Swap Options. 
	self.TankSwap = Options:AddHeader(KBM.Language.Options.TankSwapEnabled[KBM.Lang], self.Enabled, KBM.Options.TankSwap.Enabled)
	self.TankSwap:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowAnchor, KBM.Options.TankSwap.Visible)
	self.TankSwap:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.LockAnchor, KBM.Options.TankSwap.Unlocked)
	self.TestLink = self.TankSwap:AddCheck(KBM.Language.Options.Tank[KBM.Lang], self.ShowTest, false)
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
			KBM.CastBar.Anchor.Text:ResizeToText()
		end
	end
	function self:CastTextChange(value)
		KBM.Options.CastBar.TextSize = value
		KBM.CastBar.Anchor.Text:SetFontSize(KBM.Options.CastBar.TextSize)
		KBM.CastBar.Anchor.Text:ResizeToText()
	end
	
	Options = self.MenuItem.Options
	Options:SetTitle()

	-- CastBar Options. 
	self.CastBars = Options:AddHeader(KBM.Language.Options.CastbarEnabled[KBM.Lang], self.CastBarEnabled, true)
	self.CastBars.Check.Frame:SetEnabled(false)
	KBM.Options.CastBar.Enabled = true
	self.CastBars:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowCastAnchor, KBM.Options.CastBar.Visible)
	self.CastBars:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.LockCastAnchor, KBM.Options.CastBar.Unlocked)
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
	
	Options = self.MenuItem.Options
	Options:SetTitle()

	self.Alert = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.AlertEnabled, KBM.Options.Alert.Enabled)
	self.Alert:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowAnchor, KBM.Options.Alert.Visible)
	self.Alert:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.LockAnchor, KBM.Options.Alert.Unlocked)
	self.Alert:AddCheck(KBM.Language.Options.AlertFlash[KBM.Lang], self.FlashEnabled, KBM.Options.Alert.Flash)
	self.Alert:AddCheck(KBM.Language.Options.AlertText[KBM.Lang], self.TextEnabled, KBM.Options.Alert.Notify)
	
end

function KBM.MenuOptions.Main:Options()

	function self:ButtonVisible(bool)
		KBM.Options.Button.Visible = bool
		KBM.Button.Texture:SetVisible(bool)
	end
	function self:LockButton(bool)
		KBM.Options.Button.Unlocked = bool
		KBM.Button.Drag:SetVisible(bool)
	end

	Options = self.MenuItem.Options
	Options:SetTitle()

	self.Button = Options:AddHeader(KBM.Language.Options.Button[KBM.Lang], self.ButtonVisible, KBM.Options.Button.Visible)
	self.Button:AddCheck(KBM.Language.Options.LockButton[KBM.Lang], self.LockButton, KBM.Options.Button.Unlocked)
	
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

local function KBM_Start()
	KBM.Button:Init()
	KBM.TankSwap:Init()
	KBM.Alert:Init()
	KBM.MechTimer:Init()
	KBM.CastBar:Init()
	KBM.EncTimer:Init()
	KBM.Trigger:Init()
	KBM.InitOptions()
	local Header = KBM.MainWin.Menu:CreateHeader("Options")
	KBM.MenuOptions.Main.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.Settings[KBM.Lang], KBM.MenuOptions.Main, nil, Header)
	KBM.MenuOptions.Timers.MenuItem = KBM.MainWin.Menu:CreateEncounter("Timers", KBM.MenuOptions.Timers, true, Header)
	KBM.MenuOptions.CastBars.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.Castbar[KBM.Lang], KBM.MenuOptions.CastBars, true, Header)
	KBM.MenuOptions.Alerts.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.Alert[KBM.Lang], KBM.MenuOptions.Alerts, true, Header)
	KBM.MenuOptions.TankSwap.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.TankSwap[KBM.Lang], KBM.MenuOptions.TankSwap, true, Header)
	KBM.MenuGroup.twentyman = KBM.MainWin.Menu:CreateHeader("20-Man Raids", nil, nil, true)
	table.insert(Command.Slash.Register("kbmreset"), {KBM_Reset, "KingMolinator", "KBM Reset"})
	table.insert(Event.Chat.Notify, {KBM.Notify, "KingMolinator", "Notify Event"})
	table.insert(Event.Chat.Npc, {KBM.NPCChat, "KingMolinator", "NPC Chat"})
	table.insert(Event.Buff.Add, {function (unitID, Buffs) KBM:BuffMonitor(unitID, Buffs, "new") end, "KingMolinator", "Buff Monitor (Add)"})
	table.insert(Event.Buff.Change, {function (unitID, Buffs) KBM:BuffMonitor(unitID, Buffs, "change") end, "KingMolinator", "Buff Monitor (change)"})
	table.insert(Event.Combat.Damage, {KBM_UnitHPCheck, "KingMolinator", "Combat Damage"})
	table.insert(Event.Unit.Unavailable, {KBM_UnitRemoved, "KingMolinator", "Unit Unavailable"})
	table.insert(Event.Unit.Available, {KBM_UnitAvailable, "KingMolinator", "Unit Available"})
	table.insert(Event.System.Update.Begin, {function () KBM:Timer() end, "KingMolinator", "System Update"}) 
	table.insert(Event.Combat.Death, {KBM_Death, "KingMolinator", "Combat Death"})
	table.insert(Event.Unit.Castbar, {KBM_CastBar, "KingMolinator", "Cast Bar Event"})
	table.insert(Command.Slash.Register("kbmhelp"), {KBM_Help, "KingMolinator", "KBM Hekp"})
	table.insert(Command.Slash.Register("kbmautoreset"), {KBM_AutoReset, "KingMolinator", "KBM Auto Reset Toggle"})
	table.insert(Command.Slash.Register("kbmoptions"), {KBM_Options, "KingMolinator", "KBM Open Options"})
	print("/kbmhelp for a list of commands.")
	print("/kbmoptions for options.")
	KBM.MenuOptions.Timers:Options()
end

local function KBM_WaitReady(unitID)
	KBM_PlayerID = unitID
	KBM_PlayerName = Inspect.Unit.Detail(unitID).name
	KBM_Start()
	for _, Mod in ipairs(KBM_BossMod) do
		Mod:AddBosses(KBM_Boss)
		Mod:Start(KBM_MainWin)
	end
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

function KBM_RegisterApp()
	return KBM
end

function KBM_RegisterMod(ModID, Mod)
	table.insert(KBM_BossMod, Mod)
	return KBM
end

table.insert(Event.Addon.SavedVariables.Load.Begin, {KBM_DefineVars, "KingMolinator", "Pre Load"})
table.insert(Event.Addon.SavedVariables.Load.End, {KBM_LoadVars, "KingMolinator", "Event"})
table.insert(Event.Addon.SavedVariables.Save.Begin, {KBM_SaveVars, "KingMolinator", "Event"})
table.insert(Event.SafesRaidManager.Player.Ready, {KBM_WaitReady, "KingMolinator", "Sync Wait"})
