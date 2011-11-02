-- King Molinator: Boss Mods
-- Written By Paul Snart
-- Copyright 2011

KBM_GlobalOptions = nil
local KBM_BossMod = {}
local KingMol_Main = {}
local KBM = {}
KBM.Testing = false
KBM.TestFilters = {}
KBM.MenuOptions = {
	MechTimers = {},
	CastBars = {},
	TankSwap = {},
	Enabled = true,
	Handler = nil,
	Options = nil,
	Name = "Options",
	ID = "Options",
}

--math.randomseed(Inspect.Time.Real())

local function KBM_DefineVars(AddonID)
	if AddonID == "KingMolinator" then
		KBM.Options = {
			AutoReset = true,
			Frame = {
				x = false,
				y = false,
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
				h = 50,
				wScale = 1,
				hScale = 1,
				ScaleWidth = false,
				ScaleHeight = false,
				TextScale = false,
				TextSize = 16,
				Enabled = true,
				Visible = false,
				Unlocked = false,
			}
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
		KBM.Options.TankSwap.h = 40
		KBM.Options.TankSwap.TextSize = 14
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
local KBM_Boss = {}
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
KBM.TimeElapsed = 0
KBM.UpdateTime = 0
KBM.CastBar = {}
KBM.CastBar.List = {}

-- Addon Primary Context
KBM.Context = UI.CreateContext("KBM_Context")
local KM_Name = "KM:Boss Mods"

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

function KBM.MechTimer:Init()
	self.TimerList = {}
	self.ActiveTimers = {}
	self.RemoveTimers = {}
	self.WaitTimers = {}
	self.StartTimers = {}
	self.RepeatTimers = {}
	self.LastTimer = nil
	self.DamageTimers = {}
	self.SayTimers = {}
	self.NotifyTimers = {}
	self.CastTimers = {}
	self.BuffTimers = {}
	self.CombatTimers = {}
	self.Anchor = UI.CreateFrame("Frame", "Timer Anchor", KBM.Context)
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

function KBM.MechTimer:Add(iTrigger, iType, iTime, iBoss, iStart, iName)
	local Timer = {}
	Timer.Active = false
	Timer.TimeStart = nil
	if type(iTrigger) == "table" then
		Timer.Trigger = iName
	else
		Timer.Trigger = iTrigger
	end
	if not iName then
		Timer.Name = iTrigger
	else
		Timer.Name = iName
	end
	Timer.Type = iType
	Timer.Time = iTime
	Timer.Boss = iBoss
	Timer.Delay = iStart
	Timer.Enabled = true
	function Timer:Start(CurrentTime)
		if self.Enabled then
			if self.Active then
				self.Active = false
				table.insert(KBM.MechTimer.RemoveTimers, self)
				table.insert(KBM.MechTimer.StartTimers, self)
				return
			end
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
					self.Active = true
					KBM.MechTimer.LastTimer = self
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
		self.CastInfo:sRemove()
		self.TimeBar:sRemove()
		self.Background:sRemove()
		if self.iType == "repeat" then
			table.insert(KBM.MechTimer.StartTimers, self)
		end
	end
	function Timer:Update(CurrentTime)
		if self.Active then
			self.Remaining = self.Time - (CurrentTime - self.TimeStart)
			local text = string.format(" %0.01f : ", self.Remaining)..self.Name
			self.CastInfo:SetText(text)
			self.CastInfo:ResizeToText()
			self.TimeBar:SetWidth(self.Background:GetWidth() * (self.Remaining/self.Time))
			if self.Remaining <= 0 then
				self.Active = false
				table.insert(KBM.MechTimer.RemoveTimers, self)
			end
		end
	end
	if iType == "damage" then
		self.DamageTimers[iTrigger] = Timer
		iBoss.Timers[iTrigger] = Timer
	elseif iType == "say" then
		if type(iTrigger) == "table" then
			for sTrigger in pairs(iTrigger) do
				self.SayTimers[sTrigger] = Timer
				iBoss.Timers[sTrigger] = Timer
			end
		else
			self.SayTimers[iTrigger] = Timer
			iBoss.Timers[iTrigger] = Timer
		end
	elseif iType == "cast" then
		self.CastTimers[iTrigger] = Timer
		iBoss.Timers[iTrigger] = Timer
	elseif iType == "notify" then
		if type(iTrigger) == "table" then
			for nTrigger in pairs(iTrigger) do
				self.NotifyTimers[nTrigger] = Timer
				iBoss.Timers[nTrigger] = Timer
			end
		else
			self.NotifyTimers[iTrigger] = Timer
			iBoss.Timers[iTrigger] = Timer
		end
	elseif iType == "buff" then
		self.Bufftimers[iTrigger] = Timer
		iBoss.Timers[iTrigger] = Timer
	elseif iType == "repeat" then
		self.RepeatTimers[iTrigger] = Timer
		iBoss.Timers[iTrigger] = Timer
	else -- iType == "Combat start"
		self.CombatTimers[iTrigger] = Timer
		iBoss.Timers[iTrigger] = Timer
	end
	if KBM.Testing then
		--Timer:Start(Inspect.Time.Real())
		table.insert(self.testTimerList, iTrigger)
	end
	return Timer
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

local function KBM_UnitHPCheck(info)

	local uDetails = {}
	local UnitID = info.target
	local uDetails = Inspect.Unit.Detail(UnitID)
	if uDetails then
		if not KBM.BossID[UnitID] then
			if KBM_Boss[uDetails.name] then
				if info.caster then
					bDetails = Inspect.Unit.Detail(info.caster)
					if bDetails then
						if bDetails.player then
							if uDetails.level == KBM_Boss[uDetails.name].Level then
								KBM.BossID[UnitID] = {}
								KBM.BossID[UnitID].name = uDetails.name
								KBM.BossID[UnitID].monitor = true
								KBM.BossID[UnitID].Mod = KBM_Boss[uDetails.name].Mod
								if uDetails.health > 0 then
									KBM.BossID[UnitID].dead = false
									KBM.BossID[UnitID].available = true
									KBM.Encounter = true
									KBM.CurrentBoss = UnitID
									KBM_CurrentBossName = uDetails.Name
									KBM_CurrentMod = KBM.BossID[UnitID].Mod
									if not KBM_CurrentMod.EncounterRunning then
										print("Encounter Started: "..KBM_Boss[uDetails.name].Descript)
										print("Good luck!")
										KBM.TimeElapsed = 0
										KBM.StartTime = Inspect.Time.Real()
									end
									KBM.BossID[UnitID].Boss = KBM_CurrentMod:UnitHPCheck(uDetails, UnitID)
								else
									KBM.BossID[UnitID].dead = true
									KBM.BossID[UnitID] = nil
								end
							end
						end
					end
				end
			end
		end
	end
	if #KBM.MechTimer.DamageTimers > 0 then
		if KBM_CurrentMod then
			if info.abilityName then
				if KBM.MechTimer.DamageTimer[info.abilityName] then
					if not KBM.MechTimer.DamageTimer[info.abilityName].Active then
						KBM.MechTimer.DamageTimer[info.abilityName]:Start(Inspect.Time.Real())
					end
				end
			end
		end
	end
end

local function KBM_UnitAvailable(units)
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
	
	self.Anchor = UI.CreateFrame("Frame", "Tank-Swap Anchor", KBM.Context)
	self.Anchor:SetWidth(KBM.Options.TankSwap.w * KBM.Options.TankSwap.wScale)
	self.Anchor:SetHeight(KBM.Options.TankSwap.h * KBM.Options.TankSwap.hScale)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
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
		local Spec = ""
		local UnitID = ""
		local uDetails = nil
		self.DebuffID = DebuffID
		self.DebuffName = DebuffName
		if LibSRM.Player.Grouped() then
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
	function self:Update()
		for UnitID, TankObj in pairs(self.Tanks) do
			Buffs = Inspect.Buff.List(UnitID)
			TankObj.Stacks = 0
			TankObj.Remaining = 0
			if Buffs then
				for n, BuffID in ipairs(Buffs) do
					bDetails = Inspect.Buff.Detail(BuffID)
					if bDetails then
						if bDetails.name == self.DebuffName then
							if bDetails.stack then
								TankObj.Stacks = bDetails.stack
							end
							if bDetails.remaining > 0 then
								TankObj.Remaining = bDetails.remaining
								TankObj.Duration = bDetails.duration
							end
							break
						end
					end
				end
			end
			if TankObj.Stacks == 0 or TankObj.Remaining <= 0 then
				TankObj.DeCoolFrame:SetVisible(false)
				TankObj.DeCool:SetPoint("RIGHT", TankObj.DeCoolFrame, 1, nil)
				TankObj.DebuffFrame.Text:SetVisible(false)
			else
				TankObj.DeCool.Text:SetText(string.format("%0.01f", TankObj.Remaining))
				TankObj.DeCool:SetPoint("RIGHT", TankObj.DeCoolFrame, (TankObj.Remaing/TankObj.Duration), nil)
				TankObj.DeCool.Text:ResizeToText()
				TankObj.DeCoolFrame:SetVisible(true)
				TankObj.DebuffFrame.Text:SetText(TankObj.Stacks)
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
		if bDetails and self.Enabled then
			if bDetails.abilityName then
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
				if self.LastCast ~= bDetails.abilityName then
					self.LastCast = bDetails.abilityName
					if KBM.MechTimer.CastTimers[bDetails.abilityName] then
						if KBM.MechTimer.CastTimers[bDetails.abilityName].Enabled then
							KBM.MechTimer.CastTimers[bDetails.abilityName]:Start(Inspect.Time.Real())
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

function KBM.ConvertTime(Time)
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

function KBM:Timer()
	if KBM.Encounter or KBM.Testing then
		local current = Inspect.Time.Real()
		local diff = (current - self.HeldTime)
		local udiff = (current - self.UpdateTime)
		if KBM_CurrentMod then
			KBM_CurrentMod:Timer(current, diff)
		end
		if diff >= 1 then
			self.TimeElapsed = current - self.StartTime
			self:TimeToHours(self.TimeElapsed)
			self.HeldTime = current - (diff - math.floor(diff))
			self.UpdateTime = current
		end
		if udiff >= 0.025 then
			if #self.MechTimer.ActiveTimers > 0 then
				for i, Timer in ipairs(self.MechTimer.ActiveTimers) do
					Timer:Update(current)
				end
				if #self.MechTimer.RemoveTimers > 0 then
					for i, Timer in ipairs(self.MechTimer.RemoveTimers) do
						Timer:Stop()
					end
					self.MechTimer.RemoveTimers = {}
				end
			end
			if #self.MechTimer.StartTimers > 0 then
				for i, Timer in ipairs(self.MechTimer.StartTimers) do
					Timer:Start(current)
				end
				self.MechTimer.StartTimers = {}
			end
			for UnitID, CastCheck in pairs(KBM.CastBar.ActiveCastBars) do
				CastCheck:Update()
			end
			self.UpdateTime = current
			if KBM.TankSwap.Active then
				KBM.TankSwap:Update()
			end
		end
	else
		-- for UnitID, CastCheck in pairs(KBM.CastBar.List) do
			-- CastCheck:Update()
		-- end
		if not KBM.Encounter then
			if #self.MechTimer.ActiveTimers > 0 then
				for i, Timer in ipairs(self.MechTimer.ActiveTimers) do
					table.insert(self.MechTimer.RemoveTimers, Timer)
				end
				if #self.MechTimer.RemoveTimers > 0 then
					for i, Timer in ipairs(self.MechTimer.RemoveTimers) do
						Timer:Stop()
					end
				end
				self.MechTimer.RemoveTimers = {}
				self.MechTimer.ActiveTimers = {}
				self.MechTimer.StartTimers = {}
			end
		end
	end
		
end

local function KBM_CastBar(units)
	--print("KBM_CastBar Event Handled")
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

local function KBM_Reset()
	if KBM.Encounter then
		if KBM_CurrentMod then
			KBM_CurrentMod:Reset()
			KBM_CurrentMod = nil
			KBM.CurrentBoss = ""
			KBM.BossID = {}
			KBM_CurrentBossName = ""
			KBM.Encounter = false
			KBM.TimeElapsed = 0
			KBM.TimeStart = 0
			if KBM.TankSwap.Active then
				KBM.TankSwap:Remove()
			end
		end
	else
		print("No encounter to reset.")
	end
end

local function KBM_UnitRemoved(units)
	--[[local uDetails = {}]]
	if KBM.Encounter then
		if KBM.Options.AutoReset then
			for UnitID, Specifier in pairs(units) do
				if not Inspect.Unit.Detail(UnitID) then
					if KBM.BossID[UnitID] then
						if KBM_CurrentMod then
							KBM.BossID[UnitID] = nil
							if KBM_CurrentMod:RemoveUnits(UnitID) then
								print("Encounter Ended, possible wipe.")
								print("Time: "..KBM.ConvertTime(Inspect.Time.Real() - KBM.StartTime))
								KBM_Reset()
							end
						end
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
						KBM.BossID[UnitID] = nil
						if KBM_CurrentMod:Death(UnitID) then
							print("Encounter Victory")
							print("Time: "..KBM.ConvertTime(Inspect.Time.Real() - KBM.StartTime))
							KBM_Reset()
						end
					end
				end
			end
		end
	end
	
end

local function KBM_AutoReset()
	if KBM.Options.AutoReset then
		KBM.Options.AutoReset = false
		print("Auto-Reset is now off.")
	else
		KBM.Options.AutoReset = true
		print("Auto-Reset is now on (Experimental: Please report the accuracy of this.)")
	end
end

local function KBM_Help()
	print("King Molinator in game slash commands")
	print("/kbmautoreset -- Toggle on/off, if you wish the addon to calculate a wipe (experimental).")
	print("/kbmreset -- Resets the monitor's data, and recalculates.")
	print("/kbmoptions -- Toggles the GUI Options screen.")
	print("/kbmhelp -- Displays what you're reading now :)")
end

function KBM.Notify(data)
	--print(data.message)
	if KBM.Encounter then
		if data.message then
			if KBM_CurrentMod then
				for Trigger, Timer in pairs(KBM_CurrentMod.Timers) do
					if string.find(data.message, Trigger, 1, true) then
						Timer:Start(Inspect.Timer.Real())
						break
					end
				end
			end
		end
	end
end

function KBM.NPCChat(data)
	--print(data.fromName..": "..data.message)
	if KBM.Encounter then
		if data.fromName then
			if KBM.BossID[from] then
				for Trigger, Timer in pairs(KBM.BossID[from].Boss.Timers) do
					if string.find(data.message, Trigger, 1, true) then
						Timer:Start(Inspect.Timer.Real())
						break
					end
				end
			end
		end
	end
end

function KBM.MenuOptions.MechTimers:Options()
	
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
	self.MechTimers = Options:AddHeader("Mechanic Timers", self.MechEnabled, true)
	self.MechTimers.Check.Frame:SetEnabled(false)
	KBM.Options.MechTimer.Enabled = true
	self.MechTimers:AddCheck("Show Anchor (for positioning.)", self.ShowMechAnchor, KBM.Options.MechTimer.Visible)
	self.MechTimers:AddCheck("Anchor unlocked.", self.LockMechAnchor, KBM.Options.MechTimer.Unlocked)
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

function KBM.MenuOptions.TankSwap:Options()

	-- Castbar Callbacks
	function self:Enabled(bool)
		KBM.Options.TankSwap.Enabled = bool
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
	self.TankSwap = Options:AddHeader("Tank-Swaps", self.Enabled, true)
	self.TankSwap.Check.Frame:SetEnabled(false)
	KBM.Options.TankSwap.Enabled = false
	self.TankSwap:AddCheck("Show Anchor (for positioning.)", self.ShowAnchor, KBM.Options.TankSwap.Visible)
	self.TankSwap:AddCheck("Anchor unlocked.", self.LockAnchor, KBM.Options.TankSwap.Unlocked)
	self.TestLink = self.TankSwap:AddCheck("Show Test Tanks.", self.ShowTest, false)
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
	self.CastBars = Options:AddHeader("Cast-bars", self.CastBarEnabled, false)
	self.CastBars.Check.Frame:SetEnabled(false)
	KBM.Options.CastBar.Enabled = false
	self.CastBars:AddCheck("Show Anchor (for positioning.)", self.ShowCastAnchor, KBM.Options.CastBar.Visible)
	self.CastBars:AddCheck("Anchor unlocked.", self.LockCastAnchor, KBM.Options.CastBar.Unlocked)
	-- self.CastBars:AddCheck("Width scaling.", self.CastScaleWidth, KBM.Options.CastBar.ScaleWidth)
	-- self.CastBars:AddCheck("Height scaling.", self.CastScaleHeight, KBM.Options.CastBar.ScaleHeight)
	-- self.CastBars:AddCheck("Text Size", self.CastTextSize, KBM.Options.CastBar.TextScale)

end

local function KBM_Start()
	KBM.TankSwap:Init()
	KBM.MechTimer:Init()
	KBM.CastBar:Init()
	KBM.InitOptions()
	local Header = KBM.MainWin.Menu:CreateHeader("Options")
	KBM.MenuOptions.MechTimers.MenuItem = KBM.MainWin.Menu:CreateEncounter("Timers", KBM.MenuOptions.MechTimers, true, Header)
	KBM.MenuOptions.CastBars.MenuItem = KBM.MainWin.Menu:CreateEncounter("Cast-bars", KBM.MenuOptions.CastBars, true, Header)
	KBM.MenuOptions.TankSwap.MenuItem = KBM.MainWin.Menu:CreateEncounter("Tank-Swaps", KBM.MenuOptions.TankSwap, true, Header)
	table.insert(Command.Slash.Register("kbmreset"), {KBM_Reset, "KingMolinator", "KBM Reset"})
	table.insert(Event.Chat.Notify, {KBM.Notify, "KingMolinator", "Notify Event"})
	table.insert(Event.Chat.Npc, {KBM.NPCChat, "KingMolinator", "NPC Chat"}) 
	table.insert(Event.Combat.Damage, {KBM_UnitHPCheck, "KingMolinator", "Event"})
	table.insert(Event.Unit.Unavailable, {KBM_UnitRemoved, "KingMolinator", "Event"})
	table.insert(Event.System.Update.Begin, {function () KBM:Timer() end, "KingMolinator", "Event"}) 
	table.insert(Event.Combat.Death, {KBM_Death, "KingMolinator", "Event"})
	table.insert(Event.Unit.Castbar, {KBM_CastBar, "KingMolinator", "Cast Bar Event"})
	table.insert(Command.Slash.Register("kbmhelp"), {KBM_Help, "KingMolinator", "KBM Hekp"})
	table.insert(Command.Slash.Register("kbmautoreset"), {KBM_AutoReset, "KingMolinator", "KBM Auto Reset Toggle"})
	table.insert(Command.Slash.Register("kbmoptions"), {KBM_Options, "KingMolinator", "KBM Open Options"})
	print("/kbmhelp for a list of commands.")
	print("/kbmoptions for options.")
	KBM.MenuOptions.MechTimers:Options()
end

local function KBM_WaitReady(unitID)
	KBM_Start()
	for _, Mod in ipairs(KBM_BossMod) do
		Mod:AddBosses(KBM_Boss)
		Mod:Start(KBM_MainWin)
	end
	KBM_PlayerID = unitID
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
