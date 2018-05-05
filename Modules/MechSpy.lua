local AddonIni, KBM = ...

KBM.Defaults.MechObj = {}
function KBM.Defaults.MechObj.Create(Color)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		error("Color error for MechObj.Create ("..tostring(Color)..")\nColor Index does not exist.")
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

function KBM.Defaults.MechObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.MechRef) do
		if BossObj.Settings.MechRef[ID] then
			if type(BossObj.Settings.MechRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.MechRef.Enabled then
					Data.Enabled = BossObj.Settings.MechRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.MechRef[ID]
				BossObj.Settings.MechRef[ID].ID = ID
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
					Data.Color = Data.Default_Color
				end
				if Data.Settings.Custom then
					Data.Color = Data.Settings.Color
				else
					Data.Color = Data.Default_Color
				end
			end
		else
			print("Warning: "..ID.." is undefined in MechRef")
			print("for boss: "..BossObj.Name)
			print("---------------")
		end
	end
end

function KBM.MechSpy:Pull()
	local GUI = {}
	if #self.Store > 0 then
		GUI = table.remove(self.Store)
	else
		GUI.Background = UI.CreateFrame("Frame", "Spy_Frame", KBM.Context)
		GUI.Background:SetHeight(self.Anchor:GetHeight())
		GUI.Background:SetPoint("LEFT", self.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", self.Anchor, "RIGHT")
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.TimeBar = UI.CreateFrame("Frame", "Spy_Progress_Frame", GUI.Background)
		GUI.TimeBar:SetWidth(self.Anchor:GetWidth())
		GUI.TimeBar:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.TimeBar:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.TimeBar:SetLayer(1)
		GUI.TimeBar:SetBackgroundColor(0,0,1,0.33)
		GUI.TimeBar:SetMouseMasking("limited")
		GUI.Shadow = UI.CreateFrame("Text", "Spy_Text_Shadow", GUI.Background)
		GUI.Shadow:SetFontSize(self.Anchor.Text:GetFontSize())
		GUI.Shadow:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
		GUI.Shadow:SetPoint("CENTERLEFT", GUI.Background, "CENTERLEFT", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetMouseMasking("limited")
		GUI.Text = UI.CreateFrame("Text", "Spy_Text_Frame", GUI.Shadow)
		GUI.Text:SetFontSize(self.Anchor.Text:GetFontSize())
		GUI.Text:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
		GUI.Text:SetPoint("TOPLEFT", GUI.Shadow, "TOPLEFT", -1, -1)
		GUI.Text:SetLayer(3)
		GUI.Text:SetFontColor(1,1,1)
		GUI.Text:SetMouseMasking("limited")
		GUI.Texture = UI.CreateFrame("Texture", "Spy_Skin", GUI.Background)
		KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/BarSkin.png")
		GUI.Texture:SetAlpha(KBM.Constant.MechSpy.TextureAlpha)
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(4)
		GUI.Texture:SetMouseMasking("limited")
		function GUI:SetText(Text)
			self.Text:SetText(Text)
			self.Shadow:SetText(Text)
		end
	end
	return GUI
end

function KBM.MechSpy:PullHeader()
	local GUI = {}
	if #self.HeaderStore > 0 then
		GUI = table.remove(self.HeaderStore)
	else
		GUI.Background = UI.CreateFrame("Frame", "Spy_Frame", KBM.Context)
		GUI.Background:SetPoint("LEFT", self.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", self.Anchor, "RIGHT")
		GUI.Background:SetHeight(self.Anchor:GetHeight())
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.Background:SetLayer(6)
		GUI.Cradle = UI.CreateFrame("Frame", "Spy_Cradle", GUI.Background)
		GUI.Cradle:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Cradle:SetPoint("RIGHT", GUI.Background, "RIGHT")
		GUI.Cradle:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.Texture = UI.CreateFrame("Texture", "MechSpy_Header_Texture", GUI.Background)
		KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/MSpy_Texture.png")
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(1)
		GUI.Shadow = UI.CreateFrame("Text", "Mechanic_Spy_Header_Shadow", GUI.Background)
		GUI.Shadow:SetText("")
		GUI.Shadow:SetPoint("CENTERRIGHT", GUI.Background, "CENTERRIGHT", -1, 1)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
		GUI.Shadow:SetLayer(2)
		GUI.Text = UI.CreateFrame("Text", "Mechanic_Spy_Header_Text", GUI.Shadow)
		GUI.Text:SetText("")
		GUI.Text:SetPoint("TOPRIGHT", GUI.Shadow, "TOPRIGHT", -1, -1)
		GUI.Text:SetLayer(3)
		GUI.Text:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
		function GUI:SetText(Text)
			self.Text:SetText(Text)
			self.Shadow:SetText(Text)
		end
		function GUI:SetColor(R, G, B, A)
			GUI.Texture:SetBackgroundColor(R, G, B, A)		
		end
	end
	return GUI
end

function KBM.MechSpy:ApplySettings()
	self.Anchor:ClearAll()
	if self.Settings.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
	else
		self.Anchor:SetPoint("BOTTOMRIGHT", UIParent, 0.9, 0.5)
	end
	self.Anchor:SetWidth(math.floor(KBM.Constant.MechSpy.w * self.Settings.wScale))
	self.Anchor:SetHeight(math.floor(KBM.Constant.MechSpy.h * self.Settings.hScale))
	self.Anchor.Text:SetFontSize(math.floor(KBM.Constant.MechSpy.TextSize * self.Settings.tScale))
	self.Anchor.Shadow:SetFontSize(self.Anchor.Text:GetFontSize())
	if KBM.Menu.Active then
		self.Anchor:SetVisible(self.Settings.Visible)
		self.Anchor.Drag:SetVisible(self.Settings.Visible)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end
end

function KBM.MechSpy:Init()
	self.List = {
		Mod = {},
		Active = {},
	}
	self.Active = false
	self.Last = nil
	self.StopTimers = {}
	self.Store = {}
	self.HeaderStore = {}
	self.Settings = KBM.Options.MechSpy
	self.Anchor = UI.CreateFrame("Frame", "MechSpy_Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Texture = UI.CreateFrame("Texture", "MechSpy_Anchor_Texture", self.Anchor)
	KBM.LoadTexture(self.Texture, "KingMolinator", "Media/MSpy_Texture.png")
	self.Texture:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
	self.Texture:SetPoint("BOTTOMRIGHT", self.Anchor, "BOTTOMRIGHT")
	self.Texture:SetLayer(1)
	self.Texture:SetBackgroundColor(1,0,0,0.33)
	
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.MechSpy.Settings.x = self:GetLeft()
			KBM.MechSpy.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Shadow = UI.CreateFrame("Text", "Mechanic_Spy_Anchor_Shadow", self.Anchor)
	self.Anchor.Shadow:SetText(KBM.Language.Anchors.MechSpy[KBM.Lang])
	self.Anchor.Shadow:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
	self.Anchor.Shadow:SetPoint("CENTERRIGHT", self.Anchor, "CENTERRIGHT", -1, 1)
	self.Anchor.Shadow:SetFontColor(0,0,0)
	self.Anchor.Shadow:SetLayer(2)
	self.Anchor.Text = UI.CreateFrame("Text", "Mechanic_Spy_Anchor_Text", self.Anchor.Shadow)
	self.Anchor.Text:SetText(KBM.Language.Anchors.MechSpy[KBM.Lang])
	self.Anchor.Text:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
	self.Anchor.Text:SetPoint("TOPRIGHT", self.Anchor.Shadow, "TOPRIGHT", -1, -1)
	self.Anchor.Text:SetLayer(3)
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor_Drag", 5)
	
	function self.Anchor.Drag.Event:WheelForward()
		if KBM.MechSpy.Settings.ScaleWidth then
			if KBM.MechSpy.Settings.wScale < 1.5 then
				KBM.MechSpy.Settings.wScale = KBM.MechSpy.Settings.wScale + 0.025
				if KBM.MechSpy.Settings.wScale > 1.5 then
					KBM.MechSpy.Settings.wScale = 1.5
				end
				KBM.MechSpy.Anchor:SetWidth(math.floor(KBM.MechSpy.Settings.wScale * KBM.Constant.TankSwap.w))
			end
		end
		
		if KBM.MechSpy.Settings.ScaleHeight then
			if KBM.MechSpy.Settings.hScale < 1.5 then
				KBM.MechSpy.Settings.hScale = KBM.MechSpy.Settings.hScale + 0.025
				if KBM.MechSpy.Settings.hScale > 1.5 then
					KBM.MechSpy.Settings.hScale = 1.5
				end
				KBM.MechSpy.Anchor:SetHeight(math.floor(KBM.MechSpy.Settings.hScale * KBM.Constant.MechSpy.h))
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
							end
						end
					end
				end
			end
		end
		
		if KBM.MechSpy.Settings.ScaleText then
			if KBM.MechSpy.Settings.tScale < 1.5 then
				KBM.MechSpy.Settings.tScale = KBM.MechSpy.Settings.tScale + 0.025
				if KBM.MechSpy.Settings.tScale > 1.5 then
					KBM.MechSpy.Settings.tScale = 1.5
				end
				KBM.MechSpy.Anchor.Text:SetFontSize(math.floor(KBM.Constant.MechSpy.TextSize * KBM.MechSpy.Settings.tScale))
				KBM.MechSpy.Anchor.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						Mechanic.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
								Timer.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
							end
						end
					end
				end
			end
		end
	end
	
	function self.Anchor.Drag.Event:WheelBack()		
		if KBM.MechSpy.Settings.ScaleWidth then
			if KBM.MechSpy.Settings.wScale > 0.5 then
				KBM.MechSpy.Settings.wScale = KBM.MechSpy.Settings.wScale - 0.025
				if KBM.MechSpy.Settings.wScale < 0.5 then
					KBM.MechSpy.Settings.wScale = 0.5
				end
				KBM.MechSpy.Anchor:SetWidth(math.floor(KBM.MechSpy.Settings.wScale * KBM.Constant.MechSpy.w))
			end
		end
		
		if KBM.MechSpy.Settings.ScaleHeight then
			if KBM.MechSpy.Settings.hScale > 0.5 then
				KBM.MechSpy.Settings.hScale = KBM.MechSpy.Settings.hScale - 0.025
				if KBM.MechSpy.Settings.hScale < 0.5 then
					KBM.MechSpy.Settings.hScale = 0.5
				end
				KBM.MechSpy.Anchor:SetHeight(math.floor(KBM.MechSpy.Settings.hScale * KBM.Constant.MechSpy.h))
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
							end
						end
					end
				end
			end
		end
		
		if KBM.MechSpy.Settings.ScaleText then
			if KBM.MechSpy.Settings.tScale > 0.5 then
				KBM.MechSpy.Settings.tScale = KBM.MechSpy.Settings.tScale - 0.025
				if KBM.MechSpy.Settings.tScale < 0.5 then
					KBM.MechSpy.Settings.tScale = 0.5
				end
				KBM.MechSpy.Anchor.Text:SetFontSize(math.floor(KBM.MechSpy.Settings.tScale * KBM.Constant.MechSpy.TextSize))
				KBM.MechSpy.Anchor.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						Mechanic.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
								Timer.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
							end
						end
					end
				end
			end
		end
	end
	self:ApplySettings()
	
	function self:Begin()
		if self.Settings.Enabled then
			self.Active = true
			for Name, BossObj in pairs(KBM.CurrentMod.Bosses) do
				if BossObj.MechRef then
					for ID, SpyObj in pairs(BossObj.MechRef) do
						SpyObj:Begin()
					end
				end
			end
		end
	end
	
	function self:Update(CurrentTime)
		if self.Active then
			for i, SpyObj in ipairs(self.List.Active) do
				for Name, TimerObj in pairs(SpyObj.Timers) do
					TimerObj:Update(CurrentTime)
				end
				for i, TimerObj in ipairs(SpyObj.StopTimers) do
					TimerObj:Stop()
				end
				SpyObj.StopTimers = {}
			end
		end
	end
	
	function self:End()
		self.Active = false
		for i, SpyObj in ipairs(self.List.Active) do
			SpyObj.StopTimers = {}
			SpyObj:End()
		end
		self.List.Active = {}
	end	
	
end

function KBM.MechSpy:Add(Name, Duration, Type, BossObj)

	local Mechanic = {}
	Mechanic.Active = false
	Mechanic.Visible = false
	Mechanic.Timers = {}
	Mechanic.StopTimers = {}
	Mechanic.Names = {}
	Mechanic.Removing = false
	Mechanic.Boss = BossObj
	Mechanic.Starting = false
	Mechanic.RemoveCount = 0
	Mechanic.StartCount = 0
	if not Duration then
		Mechanic.Time = 2
		Mechanic.Dynamic = true
		Mechanic.Duration = 2
	else
		Mechanic.Time = Duration
		Mechanic.Dynamic = false
		Mechanic.Duration = Duration
		if Duration == -1 then
			Mechanic.Static = true
		end
	end
	Mechanic.Enabled = true
	Mechanic.Name = Name
	Mechanic.Phase = 0
	Mechanic.PhaseMax = 0
	Mechanic.Type = "spy"
	Mechanic.Source = false
	Mechanic.Custom = false
	Mechanic.HasMenu = true
	Mechanic.Color = KBM.MechSpy.Settings.Color
	if type(Name) ~= "string" then
		error("Expecting String for Name, got "..type(Name))
	end
	
	function Mechanic:Show()
		if not self.Visible then
			if not KBM.MechSpy.FirstHeader then
				KBM.MechSpy.FirstHeader = self
				KBM.MechSpy.LastHeader = self
				self.HeaderBefore = nil
				self.HeaderAfter = nil
				self.GUI.Background:SetPoint("TOP", KBM.MechSpy.Anchor, "TOP")
			else
				self.HeaderBefore = KBM.MechSpy.LastHeader
				self.HeaderBefore.HeaderAfter = self
				self.HeaderAfter = nil
				KBM.MechSpy.LastHeader = self
				self.GUI.Background:SetPoint("TOP", self.HeaderBefore.GUI.Cradle, "BOTTOM")
			end
			self.Visible = true
		end
		self.GUI.Background:SetVisible(true)
	end
	
	function Mechanic:SetSource()
		self.Source = true
	end
	
	function Mechanic:Hide()
		self.GUI.Background:SetVisible(false)
		if self.Visible then
			if KBM.MechSpy.FirstHeader == self then
				KBM.MechSpy.FirstHeader = self.HeaderAfter
				if self.HeaderAfter then
					self.HeaderAfter.HeaderBefore = nil
					self.HeaderAfter.GUI.Background:SetPoint("TOP", KBM.MechSpy.Anchor, "TOP")
				end
			elseif KBM.MechSpy.LastHeader == self then
				KBM.MechSpy.LastHeader = self.HeaderBefore
				if self.HeaderBefore then
					self.HeaderBefore.HeaderAfter = nil
				end
			else
				self.HeaderBefore.HeaderAfter = self.HeaderAfter
				self.HeaderAfter.HeaderBefore = self.HeaderBefore
				self.HeaderAfter.GUI.Background:SetPoint("TOP", self.HeaderBefore.GUI.Cradle, "BOTTOM")
			end
			self.HeaderBefore = nil
			self.HeaderAfter = nil
			self.GUI.Cradle:SetPoint("BOTTOM", self.GUI.Background, "BOTTOM")
			self.GUI.Background:SetPoint("TOP", KBM.MechSpy.Anchor, "TOP")
			self.Visible = false
		end
	end
	
	function Mechanic:Begin()
		if KBM.MechSpy.Settings.Enabled then
			self.Active = true
			self.Visible = false
			self.GUI = KBM.MechSpy:PullHeader()
			if self.Settings then
				if self.Settings.Custom then
					self.GUI:SetColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
				else
					self.GUI:SetColor(KBM.Colors.List[self.Color].Red, KBM.Colors.List[self.Color].Green, KBM.Colors.List[self.Color].Blue, 0.33)
				end
			else
				self.GUI:SetColor(KBM.Colors.List[KBM.MechSpy.Settings.Color].Red, KBM.Colors.List[KBM.MechSpy.Settings.Color].Green, KBM.Colors.List[KBM.MechSpy.Settings.Color].Blue, 0.33)
			end
			self.GUI:SetText(self.Name)
			table.insert(KBM.MechSpy.List.Active, self)
			if KBM.MechSpy.Settings.Show then
				self:Show()
			else
				self:Hide()
			end
		end
	end
	
	function Mechanic:End()
		self.Active = false
		for Name, Timer in pairs(self.Names) do
			Timer:Stop()
		end
		self.Timers = {}
		self:Hide()
		table.insert(KBM.MechSpy.HeaderStore, self.GUI)
		self.GUI = nil
	end
	
	function Mechanic:SpyAfter(SpyObj)
		if not self.SpyAfterList then
			self.SpyAfterList = {}
		end
		table.insert(self.SpyAfterList, SpyObj)
	end
	
	function Mechanic:Stop(Name)
		if Name then
			if self.Names[Name] then
				if KBM.Debug then
					print("Mechanic Spy stopping: "..Name)
				end
				self.Names[Name]:Stop()
			end
		else
			for Name, Timer in pairs(self.Names) do
				Timer:Stop()
			end
		end
	end
		
	function Mechanic:Start(Name, Duration)
		if KBM.Debug then
			print("Mechanic Spy Called")
		end
		if KBM.Encounter then
			if KBM.MechSpy.Settings.Enabled then
				if self.Enabled == true and type(Name) == "string" then
					if KBM.Debug then
						print("Mechanic Spy launching Timer: "..Name)
					end
					if self.Names[Name] then
						self.Names[Name]:Stop()
					end
					local CurrentTime = Inspect.Time.Real()
					local Anchor = self.GUI.Background
					if not self.Visible then
						self:Show()
					end
					Timer = {}
					Timer.Name = Name
					Timer.GUI = KBM.MechSpy:Pull()
					Timer.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
					Timer.TimeStart = CurrentTime
					if self.Static then
						Duration = 0
						Timer.Time = 0
						Timer.Static = true
						Timer.GUI.TimeBar:SetWidth(math.ceil(Timer.GUI.Background:GetWidth()))
					else
						Timer.Static = false
						if not self.Dynamic then
							Duration = self.Duration
							Timer.Time = self.Time
						else
							if Duration == nil or Duration < 1 then
								Duration = self.Duration
							end
							Timer.Time = Duration
						end
					end
					Timer.Remaining = Duration
					Timer.GUI:SetText(string.format(" %0.01f : ", Timer.Remaining)..Timer.Name)
								
					if self.Settings then
						if self.Settings.Custom then
							Timer.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
						else
							Timer.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Color].Red, KBM.Colors.List[self.Color].Green, KBM.Colors.List[self.Color].Blue, 0.33)
						end
					else
						Timer.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[KBM.MechSpy.Settings.Color].Red, KBM.Colors.List[KBM.MechSpy.Settings.Color].Green, KBM.Colors.List[KBM.MechSpy.Settings.Color].Blue, 0.33)
					end
					
					if #self.Timers > 0 then
						for i, cTimer in ipairs(self.Timers) do
							if Timer.Remaining < cTimer.Remaining then
								Timer.Active = true
								if i == 1 then
									Timer.GUI.Background:SetPoint("TOP", self.GUI.Background, "BOTTOM", nil, 1)
									cTimer.GUI.Background:SetPoint("TOP", Timer.GUI.Background, "BOTTOM", nil, 1)
									self.FirstTimer = Timer
								else
									Timer.GUI.Background:SetPoint("TOP", self.Timers[i-1].GUI.Background, "BOTTOM", nil, 1)
									cTimer.GUI.Background:SetPoint("TOP", Timer.GUI.Background, "BOTTOM", nil, 1)
								end
								table.insert(self.Timers, i, Timer)
								break
							end
						end
						if not Timer.Active then
							Timer.GUI.Background:SetPoint("TOP", self.LastTimer.GUI.Background, "BOTTOM", nil, 1)
							table.insert(self.Timers, Timer)
							self.LastTimer = Timer
							Timer.Active = true
						end
					else
						Timer.GUI.Background:SetPoint("TOP", self.GUI.Background, "BOTTOM", nil, 1)
						table.insert(self.Timers, Timer)
						Timer.Active = true
						self.LastTimer = Timer
						self.FirstTimer = Timer
					end
					self.Names[Name] = Timer
					Timer.GUI.Background:SetVisible(true)
					Timer.Starting = false
					Timer.Parent = self
					self.GUI.Cradle:SetPoint("BOTTOM", self.LastTimer.GUI.Background, "BOTTOM")
					function Timer:Stop()
						if not self.Deleting then
							if self.Active then
								self.Active = false
								self.Deleting = true
								self.GUI.Background:SetVisible(false)
								for i, Timer in ipairs(self.Parent.Timers) do
									if Timer == self then
										if #self.Parent.Timers == 1 then
											self.Parent.LastTimer = nil
											self.Parent.GUI.Cradle:SetPoint("BOTTOM", self.Parent.GUI.Background, "BOTTOM")
											if not KBM.MechSpy.Settings.Show then
												self.Parent:Hide()
											end
										elseif i == 1 then
											self.Parent.Timers[i+1].GUI.Background:SetPoint("TOP", self.Parent.GUI.Background, "BOTTOM", nil, 1)
										elseif i == #self.Parent.Timers then
											self.Parent.LastTimer = self.Parent.Timers[i-1]
											self.Parent.GUI.Cradle:SetPoint("BOTTOM", self.Parent.LastTimer.GUI.Background, "BOTTOM")
										else
											self.Parent.Timers[i+1].GUI.Background:SetPoint("TOP", self.Parent.Timers[i-1].GUI.Background, "BOTTOM", nil, 1)
										end
										table.remove(self.Parent.Timers, i)
										break
									end
								end
								table.insert(KBM.MechSpy.Store, self.GUI)
								self.Remaining = 0
								self.TimeStart = 0
								self.GUI = nil
								self.Removing = false
								self.Deleting = false
								self.Parent.Names[self.Name] = nil
								if KBM.Encounter then
									if self.Parent.SpyAfterList then
										for i, SpyObj in ipairs(self.Parent.SpyAfterList) do
											SpyObj:Start(self.Name)
										end
									end
								end
							end
						end
					end
					function Timer:Update(CurrentTime)
						local text = ""
						if self.Active then
							if self.Waiting then
							
							else
								if self.Static == false then
									self.Remaining = self.Time - (CurrentTime - self.TimeStart)
								else
									self.Remaining = CurrentTime - self.TimeStart
								end
								if self.Remaining < 10 then
									text = string.format(" %0.01f : ", self.Remaining)..self.Name
								elseif self.Remaining >= 60 then
									text = " "..KBM.ConvertTime(self.Remaining).." : "..self.Name
								else
									text = " "..math.floor(self.Remaining).." : "..self.Name
								end
								self.GUI:SetText(text)
								if self.Static == false then
									self.GUI.TimeBar:SetWidth(math.ceil(self.GUI.Background:GetWidth() * (self.Remaining/self.Time)))
									if self.Remaining <= 0 then
										self.Remaining = 0
										table.insert(self.Parent.StopTimers, self)
									end
								end
							end
						end
					end
					Timer:Update(Inspect.Time.Real())
				end
			end
		end		
	end
	
	function Mechanic:Queue(Duration)
		if KBM.MechSpy.Settings.Enabled then
			if self.Enabled then
				self:AddStart(self, Duration)
			end
		end
	end
	
	function Mechanic:NoMenu()
		self.Enabled = true
		self.NoMenu = true
		self.HasMenu = false
	end
	
	function Mechanic:SetLink(Spy)
		if type(Spy) == "table" then
			if Spy.Type ~= "spy" then
				error("Supplied Object is not a Mechanic Spy, got: "..tostring(Spy.Type))
			else
				self.Link = Spy
				self:NoMenu()
				for SettingID, Value in pairs(self.Settings) do
					if SettingID ~= "ID" then
						self.Link.Settings[SettingID] = Value
					end
				end
				if not Spy.Linked then
					Spy.Linked = {}
				end
				table.insert(Spy.Linked, self)
			end
		else
			error("Expecting at least a table got: "..type(Spy))
		end		
	end
			
	function Mechanic:SetPhase(Phase)
		self.Phase = Phase
	end
	
	if not self.List[BossObj.Mod] then
		self.List[BossObj.Mod] = {}
	end
	table.insert(self.List[BossObj.Mod], Mechanic)
	
	return Mechanic
end