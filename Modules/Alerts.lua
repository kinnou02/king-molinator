local AddonIni, KBM = ...

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
		Default_Color = Color,
		Custom = false,
		Border = true,
		Notify = true,
		Sound = true,
	}
	return AlertObj
end

function KBM.Defaults.AlertObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.AlertsRef) do
		if BossObj.Settings.AlertsRef[ID] then
			if type(BossObj.Settings.AlertsRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.AlertsRef.Enabled then
					Data.Enabled = BossObj.Settings.AlertsRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.AlertsRef[ID]
				if not Data.HasMenu then
					Data.Enabled = true
					Data.Settings.Enabled = true
				end
				Data.Default_Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
				if not KBM.Colors.List[Data.Settings.Color] then
					error(	"AlertObj Assign Error: "..Data.ID..
							"/nColor Index ("..Data.Settings.Color..") does not exist, ignoring settings."..
							"/nFor: "..BossObj.Name)
					Data.Settings.Color = Data.Default_Color
				else
					if Data.Settings.Custom then
						Data.Color = Data.Settings.Color
					else
						Data.Color = Data.Default_Color
					end
				end
				BossObj.Settings.AlertsRef[ID].ID = ID
			end
		else
			error(	"Warning: "..ID.." is undefined in AlertsRef"..
					"\nfor boss: "..BossObj.Name)
		end
	end
end

function KBM.Alert:Init()
	function self:ApplySettings()
		self.Anchor:ClearAll()
		self.Text:SetFontSize(KBM.Constant.Alerts.TextSize * self.Settings.tScale)
		self.Text:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
		self.Shadow:SetFontSize(self.Text:GetFontSize())
		self.Shadow:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
		if self.Settings.x then
			self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		else
			self.Anchor:SetPoint("CENTERX", UIParent, "CENTERX")
			self.Anchor:SetPoint("CENTERY", UIParent, nil, 0.25)
		end	
		self.Notify = self.Settings.Notify
		self.Flash = self.Settings.Flash
		self.Enabled = self.Settings.Enabled
		self.AlertControl.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
		self.AlertControl.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
		self.AlertControl.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
		self.AlertControl.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
		if KBM.Menu.Active then
			self.Anchor:SetVisible(self.Settings.Visible)
			self.Anchor.Drag:SetVisible(self.Settings.Visible)
			if self.Settings.Vertical then
				self.Left.red:SetVisible(self.Settings.Visible)
				self.Right.red:SetVisible(self.Settings.Visible)
			else
				self.Left.red:SetVisible(false)
				self.Right.red:SetVisible(false)
			end
			if self.Settings.Horizontal then
				self.Top.red:SetVisible(self.Settings.Visible)
				self.Bottom.red:SetVisible(self.Settings.Visible)
			else
				self.Top.red:SetVisible(false)
				self.Bottom.red:SetVisible(false)
			end
			if self.Settings.Visible then
				if self.Settings.Vertical then
					self.AlertControl.Left:SetVisible(self.Settings.FlashUnlocked)
					self.AlertControl.Right:SetVisible(self.Settings.FlashUnlocked)
				end
				if self.Settings.Horizontal then
					self.AlertControl.Top:SetVisible(self.Settings.FlashUnlocked)
					self.AlertControl.Bottom:SetVisible(self.Settings.FlashUnlocked)
				end
			end
		else
			self.Anchor:SetVisible(false)
			self.Anchor.Drag:SetVisible(false)
			self.Left.red:SetVisible(false)
			self.Right.red:SetVisible(false)
			self.Top.red:SetVisible(false)
			self.Bottom.red:SetVisible(false)
			self.AlertControl.Left:SetVisible(false)
			self.AlertControl.Right:SetVisible(false)
			self.AlertControl.Top:SetVisible(false)
			self.AlertControl.Bottom:SetVisible(false)
		end
	end

	self.List = {}
	self.Settings = KBM.Options.Alerts
	self.Anchor = UI.CreateFrame("Frame", "Alert Text Anchor", KBM.Context)
	self.Anchor:SetBackgroundColor(0,0,0,0)
	self.Anchor:SetLayer(KBM.Layer.DragInactive)
	self.Shadow = UI.CreateFrame("Text", "Alert Text Outline", self.Anchor)
	self.Shadow:SetFontColor(0,0,0)
	self.Shadow:SetLayer(1)
	self.Text = UI.CreateFrame("Text", "Alert Text", self.Anchor)
	self.Shadow:SetPoint("CENTER", self.Text, "CENTER", 2, 2)
	self.Text:SetText(KBM.Language.Anchors.AlertText[KBM.Lang])
	self.Shadow:SetText(self.Text:GetText())
	self.Shadow:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
	self.Shadow:SetFontSize(self.Text:GetFontSize())
	self.Text:SetFontColor(1,1,1)
	self.Text:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
	self.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Text:SetLayer(2)
	self.Anchor:SetVisible(self.Settings.Visible)
	self.ColorList = {"red", "blue", "cyan", "yellow", "orange", "purple", "dark_green", "pink", "dark_grey"}
	self.Left = {}
	self.Right = {}
	self.Top = {}
	self.Bottom = {}
	self.Count = 0
	self.AlertControl = {}
	self.AlertControl.Left = UI.CreateFrame("Frame", "Left_Alert_Controller", KBM.Context)
	self.AlertControl.Left:SetVisible(false)
	self.AlertControl.Left:SetLayer(KBM.Layer.DragInactive)
	self.AlertControl.Left:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
	self.AlertControl.Left:SetPoint("BOTTOM", UIParent, "BOTTOM")
	self.AlertControl.Right = UI.CreateFrame("Frame", "Right_Alert_Controller", KBM.Context)
	self.AlertControl.Right:SetVisible(false)
	self.AlertControl.Right:SetLayer(KBM.Layer.DragInactive)
	self.AlertControl.Right:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")
	self.AlertControl.Right:SetPoint("BOTTOM", UIParent, "BOTTOM")
	self.AlertControl.Top = UI.CreateFrame("Frame", "Top_Alert_Controller", KBM.Context)
	self.AlertControl.Top:SetVisible(false)
	self.AlertControl.Top:SetLayer(KBM.Layer.DragInactive)
	self.AlertControl.Top:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
	self.AlertControl.Top:SetPoint("RIGHT", UIParent, "RIGHT")
	self.AlertControl.Bottom = UI.CreateFrame("Frame", "Bottom_Alert_Controller", KBM.Context)
	self.AlertControl.Bottom:SetVisible(false)
	self.AlertControl.Bottom:SetLayer(KBM.Layer.DragInactive)
	self.AlertControl.Bottom:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT")
	self.AlertControl.Bottom:SetPoint("RIGHT", UIParent, "RIGHT")
	
	for _t, Color in ipairs(self.ColorList) do
		self.Left[Color] = UI.CreateFrame("Texture", "Left_Alert "..Color, KBM.Context)
		KBM.LoadTexture(self.Left[Color], "KingMolinator", "Media/Alert_Left_"..Color..".png")
		self.Left[Color]:SetPoint("TOPLEFT", self.AlertControl.Left, "TOPLEFT")
		self.Left[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Left, "BOTTOMRIGHT")
		self.Left[Color]:SetVisible(false)
		self.Left[Color]:SetLayer(KBM.Layer.Alerts)
		self.Right[Color] = UI.CreateFrame("Texture", "Right_Alert"..Color, KBM.Context)
		KBM.LoadTexture(self.Right[Color], "KingMolinator", "Media/Alert_Right_"..Color..".png")
		self.Right[Color]:SetPoint("TOPLEFT", self.AlertControl.Right, "TOPLEFT")
		self.Right[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Right, "BOTTOMRIGHT")
		self.Right[Color]:SetVisible(false)
		self.Right[Color]:SetLayer(KBM.Layer.Alerts)
		self.Top[Color] = UI.CreateFrame("Texture", "Top_Alert "..Color, KBM.Context)
		KBM.LoadTexture(self.Top[Color], "KingMolinator", "Media/Alert_Top_"..Color..".png")
		self.Top[Color]:SetPoint("TOPLEFT", self.AlertControl.Top, "TOPLEFT")
		self.Top[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Top, "BOTTOMRIGHT")
		self.Top[Color]:SetVisible(false)
		self.Top[Color]:SetLayer(KBM.Layer.Alerts)
		self.Bottom[Color] = UI.CreateFrame("Texture", "Bottom_Alert "..Color, KBM.Context)
		KBM.LoadTexture(self.Bottom[Color], "KingMolinator", "Media/Alert_Bottom_"..Color..".png")
		self.Bottom[Color]:SetPoint("TOPLEFT", self.AlertControl.Bottom, "TOPLEFT")
		self.Bottom[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Bottom, "BOTTOMRIGHT")
		self.Bottom[Color]:SetVisible(false)
		self.Bottom[Color]:SetLayer(KBM.Layer.Alerts)
	end
	
	self.AlertControl.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
	self.AlertControl.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
	self.AlertControl.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
	self.AlertControl.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
	
	function self.AlertControl:WheelBack()
		if KBM.Alert.Settings.fScale < 1.5 then
			KBM.Alert.Settings.fScale = KBM.Alert.Settings.fScale + 0.05
			if KBM.Alert.Settings.fScale > 1.5 then
				KBM.Alert.Settings.fScale = 1.5
			end
			self.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
			self.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
			self.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
			self.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
		end
	end
	
	function self.AlertControl:WheelForward()
		if KBM.Alert.Settings.fScale > 0.15 then
			KBM.Alert.Settings.fScale = KBM.Alert.Settings.fScale - 0.05
			if KBM.Alert.Settings.fScale < 0.15 then
				KBM.Alert.Settings.fScale = 0.15
			end
			self.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
			self.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
			self.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
			self.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
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
	
	function self.AlertControl.Top.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Top.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	function self.AlertControl.Bottom.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Bottom.Event:WheelForward()
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
	self.Anchor.Drag:ClearAll()
	self.Anchor.Drag:SetPoint("TOPRIGHT", self.Text, "TOPRIGHT")
	self.Anchor.Drag:SetPoint("BOTTOMLEFT", self.Text, "BOTTOMLEFT")
	function self.Anchor.Drag.Event:WheelForward()
		if KBM.Alert.Settings.ScaleText then
			if KBM.Alert.Settings.tScale < 2 then
				KBM.Alert.Settings.tScale = KBM.Alert.Settings.tScale + 0.02
				if KBM.Alert.Settings.tScale > 2 then
					KBM.Alert.Settings.tScale = 2
				end
				KBM.Alert.Shadow:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)
				KBM.Alert.Text:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)	
			end
		end		
	end
	
	function self.Anchor.Drag.Event:WheelBack()	
		if KBM.Alert.Settings.ScaleText then
			if KBM.Alert.Settings.tScale > 0.8 then
				KBM.Alert.Settings.tScale = KBM.Alert.Settings.tScale - 0.02
				if KBM.Alert.Settings.tScale < 0.8 then
					KBM.Alert.Settings.tScale = 0.8
				end
				KBM.Alert.Shadow:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)
				KBM.Alert.Text:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)	
			end
		end
	end
	
	self:ApplySettings()	
end

function KBM.Alert:Create(Text, Duration, Flash, Countdown, Color)
	local AlertObj = {}
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
	AlertObj.Linked = nil
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

	function AlertObj:SetLink(Alert)
		if type(Alert) == "table" then
			if Alert.Type ~= "alert" then
				error("Supplied Object is not an Alert, got: "..tostring(Alert.Type))
			else
				self.Link = Alert
				self:NoMenu()
				for SettingID, Value in pairs(self.Settings) do
					if SettingID ~= "ID" then
						self.Link.Settings[SettingID] = Value
					end
				end
				if not Alert.Linked then
					Alert.Linked = {}
				end
				table.insert(Alert.Linked, self)
			end
		else
			error("Expecting at least a table got: "..type(Alert))
		end		
	end
	
	self.Count = self.Count + 1
	table.insert(self.List, AlertObj)
	return AlertObj		
end

function KBM.Alert:Start(AlertObj, CurrentTime, Duration)
	local CurrentTime = Inspect.Time.Real()
	if self.Settings.Enabled then
		if AlertObj.Enabled then
			if self.Starting and not AlertObj.isImportant then
				if KBM.Debug then
					print("Alert starting overlap: Aborting")
				end
				return
			end
			if self.Active then
				if self.Current.Active then
					if not AlertObj.isImportant then
						if self.Current.isImportant then
							if not self.Current.Stopping then
								return
							end
						end
					end
					self.Starting = true
					self:Stop()
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
				else
					self.Duration = AlertObj.DefDuration
				end
			end
			self.Current = AlertObj
			AlertObj.Duration = self.Duration
			self.Alpha = 1.0
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
				if AlertObj.Settings.Border then
					if self.Settings.Vertical then
						self.Left[self.Color]:SetAlpha(1.0)
						self.Left[self.Color]:SetVisible(true)
						self.Right[self.Color]:SetAlpha(1.0)
						self.Right[self.Color]:SetVisible(true)
					end
					if self.Settings.Horizontal then
						self.Top[self.Color]:SetAlpha(1.0)
						self.Top[self.Color]:SetVisible(true)
						self.Bottom[self.Color]:SetAlpha(1.0)
						self.Bottom[self.Color]:SetVisible(true)						
					end
					self.Direction = false
					self.FadeStart = CurrentTime
				end
			end
			if self.Settings.Notify then
				if AlertObj.Text then
					if AlertObj.Settings.Notify then
						self.Shadow:SetText(AlertObj.Text)
						self.Text:SetText(AlertObj.Text)
						self.Anchor:SetVisible(true)
						self.Anchor:SetAlpha(1.0)
					end
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

function KBM.Alert:Stop(SpecObj)
	if (self.Current and not SpecObj) or (self.Current and SpecObj == self.Current) then
		if self.Current.Active then
			self.Current.Stopping = true
			self.Left[self.Color]:SetVisible(false)
			self.Right[self.Color]:SetVisible(false)
			self.Top[self.Color]:SetVisible(false)
			self.Bottom[self.Color]:SetVisible(false)
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
					if not self.Current.TAStarted then
						KBM.MechTimer:AddStart(self.Current.TimerAfter)
						self.Current.TAStart = false
					end
				end
			end
		end
	end
end	

function KBM.Alert:Update(CurrentTime)
	local CurrentTime = Inspect.Time.Real()
	if self.Current.Stopping then
		if self.Alpha == 0 then
			self:Stop()
		else
			local TimeDiff = CurrentTime - self.FadeStart
			self.Alpha = 1.0 - (TimeDiff * 1.25)
			if self.Alpha < 0 then
				self.Alpha = 0.0
			end
			if self.Settings.Flash then
				if self.Current.Settings.Border then
					if self.Settings.Vertical then
						self.Left[self.Color]:SetAlpha(self.Alpha)
						self.Right[self.Color]:SetAlpha(self.Alpha)
					end
					if self.Settings.Horizontal then
						self.Top[self.Color]:SetAlpha(self.Alpha)
						self.Bottom[self.Color]:SetAlpha(self.Alpha)
					end
				end
			end
			if self.Settings.Notify then
				if self.Current.Settings.Notify then
					self.Anchor:SetAlpha(self.Alpha)
				end
			end
		end
	else
		if self.Settings.Flash then
			if self.Current.Flash then
				if self.Current.Settings.Border then
					local TimeDiff = CurrentTime - self.FadeStart
					if self.Direction then
						if TimeDiff > 0.5 then
							self.Alpha = 1.0
							self.Direction = false
							self.FadeStart = CurrentTime
						else
							self.Alpha = TimeDiff * 2
						end
					else
						if TimeDiff > 0.5 then
							self.Alpha = 0.0
							self.Direction = true
							self.FadeStart = CurrentTime
						else
							self.Alpha = 1.0 - (TimeDiff * 2)
						end
					end
					if self.Settings.Vertical then
						self.Left[self.Color]:SetAlpha(self.Alpha)
						self.Right[self.Color]:SetAlpha(self.Alpha)
					end
					if self.Settings.Horizontal then
						self.Top[self.Color]:SetAlpha(self.Alpha)
						self.Bottom[self.Color]:SetAlpha(self.Alpha)
					end
				end
			end
		end
		if self.Current.Countdown then
			if self.Remaining then
				self.Remaining = self.StopTime - CurrentTime
				if self.Current.Settings.Notify then
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
		end
		if self.StopTime then
			if self.StopTime <= CurrentTime then
				self.Direction = false
				self.FadeStart = (CurrentTime - (1.0 - self.Alpha))
				self.Current.Stopping = true
				if self.Current.AlertAfter and not self.Starting then
					self:Stop()
				elseif self.Current.TimerAfter then
					if KBM.Encounter then
						KBM.MechTimer:AddStart(self.Current.TimerAfter)
						self.Current.TAStarted = true
					end
				end
			end
		end
	end
end
