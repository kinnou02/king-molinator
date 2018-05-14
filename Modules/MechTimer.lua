local AddonIni, KBM = ...

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
		Default_Color = Color,
		Custom = false,
	}
	return TimerObj
end

function KBM.Defaults.TimerObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.TimersRef) do
		if BossObj.Settings.TimersRef[ID] then
			if type(BossObj.Settings.TimersRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.TimersRef.Enabled then
					Data.Enabled = BossObj.Settings.TimersRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.TimersRef[ID]
				BossObj.Settings.TimersRef[ID].ID = ID
				if not Data.HasMenu then
					Data.Enabled = true
					Data.Settings.Enabled = true
				end
				Data.Default_Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
				if not KBM.Colors.List[Data.Settings.Color] then
					print("TimerObj Assign Error: "..Data.ID)
					print("Color Index ("..Data.Settings.Color..") does not exist, ignoring settings.")
					print("For: "..BossObj.Name)
					Data.Settings.Color = Data.Default_Color
				end
				if Data.Custom then
					Data.Color = Data.Settings.Color
				else
					Data.Color = Data.Default_Color
				end
				--Data.Settings.Default_Color = nil
			end
		else
			print("Warning: "..ID.." is undefined in TimersRef")
			print("for boss: "..BossObj.Name)
			print("---------------")
		end
	end
end

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
	if KBM.Menu.Active then
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
	self.Cached = 0
	self.TempGUI = {}
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
	self.Anchor.Text:SetText(" 0.0 "..KBM.Language.Anchors.Timers[KBM.Lang])
	self.Anchor.Text:SetFont(AddonIni.identifier, KBM.Options.Font.Custom)
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
		GUI.Background:SetLayer(KBM.Layer.Timers)
		GUI.TimeBar = UI.CreateFrame("Frame", "Timer_Progress_Frame", GUI.Background)
		--KBM.LoadTexture(GUI.TimeBar, "KingMolinator", "Media/BarTexture2.png")
		GUI.TimeBar:SetWidth(KBM.MechTimer.Anchor:GetWidth())
		GUI.TimeBar:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.TimeBar:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.TimeBar:SetLayer(1)
		GUI.TimeBar:SetBackgroundColor(0,0,1,0.33)
		GUI.TimeBar:SetMouseMasking("limited")
		GUI.CastInfo = UI.CreateFrame("Text", "Timer_Text_Frame", GUI.Background)
		GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
		GUI.CastInfo:SetFont(AddonIni.identifier, KBM.Options.Font.Custom)
		GUI.CastInfo:SetPoint("CENTERLEFT", GUI.Background, "CENTERLEFT")
		GUI.CastInfo:SetLayer(3)
		GUI.CastInfo:SetFontColor(1,1,1)
		GUI.CastInfo:SetMouseMasking("limited")
		GUI.Shadow = UI.CreateFrame("Text", "Timer_Text_Shadow", GUI.Background)
		GUI.Shadow:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
		GUI.Shadow:SetFont(AddonIni.identifier, KBM.Options.Font.Custom)
		GUI.Shadow:SetPoint("CENTER", GUI.CastInfo, "CENTER", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetMouseMasking("limited")
		GUI.Texture = UI.CreateFrame("Texture", "Timer_Skin", GUI.Background)
		KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/BarSkin.png")
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
	if not Duration then
		Timer.Time = 2
		Timer.Dynamic = true
	else
		Timer.Time = Duration
		Timer.Dynamic = false
	end
	Timer.Delay = iStart
	Timer.Enabled = true
	Timer.Linked = nil
	Timer.Repeat = Repeat
	Timer.Name = Name
	Timer.Phase = 0
	Timer.PhaseMax = 0
	Timer.Type = "timer"
	Timer.Waiting = false
	Timer.WaitNext = false
	Timer.Priority = 0
	Timer.Custom = false
	Timer.Color = KBM.MechTimer.Settings.Color
	Timer.HasMenu = true
	if type(Name) ~= "string" then
		error("Expecting String for Name, got "..type(Name))
	end
	
	function self:AddRemove(Object, Force)
		if not Object.Removing then
			if Object.Active then
				Object.Removing = true
				Object.ForceStop = Force or false
				table.insert(self.RemoveTimers, Object)
				self.RemoveCount = self.RemoveCount + 1
			end
		end
	end
	
	function self:AddStart(Object, Duration)
		if not Object.Starting then
			if Object.Enabled then
				self.Queued = false
				Object.Starting = true
				if Object.Dynamic then
					Object.Time = Duration
				end
				self.StartCount = self.StartCount + 1
				table.insert(self.StartTimers, Object)
				self:AddRemove(Object)
			end
		end
	end
	
	function Timer:Wait(Priority)
		self.WaitNext = true
		self.Priority = tonumber(Priority) or -1
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
			self.ForceStop = false
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
				if self.Settings.Custom then
					self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
				else
					self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Color].Red, KBM.Colors.List[self.Color].Green, KBM.Colors.List[self.Color].Blue, 0.33)
				end
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
	
	function Timer:Queue(Duration)
		if self.Enabled then
			KBM.MechTimer:AddStart(self, Duration)
		end
	end
	
	function Timer:Stop()
		if self.Active then
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
				self.Waiting = false
				for i, AlertObj in pairs(self.Alerts) do
					self.Alerts[i].Triggered = false
				end
				for i, TimerObj in pairs(self.Timers) do
					self.Timers[i].Triggered = false
				end
				self.GUI = nil
				self.Removing = false
				self.Deleting = false
				if KBM.Encounter then
					if not self.ForceStop then
						if self.Repeat then
							KBM.MechTimer:AddStart(self)
						end
						if self.TimerAfter then
							for i, TimerObj in ipairs(self.TimerAfter) do
								if TimerObj.Phase >= KBM.CurrentMod.Phase or TimerObj.Phase == 0 then
									KBM.MechTimer:AddStart(TimerObj)
								end
							end
						end
						if self.AlertAfter then
							KBM.Alert:Start(self.AlertAfter, Inspect.Time.Real())
						end
					end
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
					if not self.TimerAfter then
						self.TimerAfter = {}
					end
					table.insert(self.TimerAfter, TimerObj)
				else
					if not self.Timers[Time] then
						self.Timers[Time] = {
							Triggered = false,
							Timers = {},
						}
					end
					table.insert(self.Timers[Time].Timers, TimerObj)
				end
			end
		else
			error("Expecting TimerObj got "..type(TimerObj))
		end
	end
	
	function Timer:AddTrigger(TriggerObj, Time)
		if not self.Triggers[Time] then
			self.Triggers[Time] = {}
		end
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
				self.Remaining = math.floor(self.Time - (CurrentTime - self.TimeStart))
				if self.Remaining ~= self.lastRemaining then
					self.GUI.CastInfo:SetText(" "..self.Remaining.." : "..self.Name)
					self.GUI.Shadow:SetText(self.GUI.CastInfo:GetText())
					self.lastRemaining = self.Remaining
				end
			else
				self.Remaining = self.Time - (CurrentTime - self.TimeStart)
				if self.Remaining < 10 then
					text = string.format(" %0.01f : ", self.Remaining)..self.Name
				elseif self.Remaining >= 60 then
					text = " "..KBM.ConvertTime(self.Remaining).." : "..self.Name
				else
					text = " "..math.floor(self.Remaining).." : "..self.Name
				end
				if text ~= self.GUI.CastInfo:GetText() then
					self.GUI.CastInfo:SetText(text)
					self.GUI.Shadow:SetText(text)
				end
				newWidth = math.floor(self.GUI.Background:GetWidth() * (self.Remaining/self.Time))
				if self.GUI.TimeBar:GetWidth() ~= newWidth then
					self.GUI.TimeBar:SetWidth(self.GUI.Background:GetWidth() * (self.Remaining/self.Time))
				end
				if self.Remaining <= 0 then
					self.Remaining = 0
					if not self.WaitNext then
						KBM.MechTimer:AddRemove(self)
					else
						self.Waiting = true
						self.GUI.TimeBar:SetWidth(self.GUI.Background:GetWidth())
						self.GUI.CastInfo:SetText(math.floor(self.Remaining).." : "..self.Name)
						self.GUI.Shadow:SetText(self.GUI.CastInfo:GetText())
					end
				end
				if KBM.Encounter then
					TriggerTime = math.ceil(self.Remaining)
					if self.Timers[TriggerTime] then
						if not self.Timers[TriggerTime].Triggered then
							for i, TimerObj in pairs(self.Timers[TriggerTime].Timers) do
								KBM.MechTimer:AddStart(TimerObj)
							end
							self.Timers[TriggerTime].Triggered = true
						end
					end
					if self.Alerts[TriggerTime] then
						if not self.Alerts[TriggerTime].Triggered then
							KBM.Alert:Start(self.Alerts[TriggerTime].AlertObj, CurrentTime)
							self.Alerts[TriggerTime].Triggered = true
						end
					end
				end
			end
		end
	end
	
	function Timer:NoMenu()
		self.HasMenu = false
		self.Enabled = true
	end
	
	function Timer:SetLink(Timer)
		if type(Timer) == "table" then
			if Timer.Type ~= "timer" then
				error("Supplied Object is not a Timer, got: "..tostring(Timer.Type))
			else
				self.Link = Timer
				self:NoMenu()
				for SettingID, Value in pairs(self.Settings) do
					if SettingID ~= "ID" then
						self.Link.Settings[SettingID] = Value
					end
				end
				if not Timer.Linked then
					Timer.Linked = {}
				end
				table.insert(Timer.Linked, self)
			end
		else
			error("Expecting at least a table got: "..type(Timer))
		end
	end
	
	return Timer
	
end