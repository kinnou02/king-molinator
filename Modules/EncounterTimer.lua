local AddonIni, KBM = ...

function KBM.EncTimer:Init()	
	self.TestMode = false
	self.Settings = KBM.Options.EncTimer
	self.Frame = UI.CreateFrame("Frame", "Encounter_Timer", KBM.Context)
	self.Frame:SetLayer(5)
	self.Frame:SetBackgroundColor(0,0,0,0.33)
	self.Frame.Shadow = UI.CreateFrame("Text", "Time_Shadow", self.Frame)
	self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
	self.Frame.Shadow:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
	self.Frame.Shadow:SetPoint("CENTER", self.Frame, "CENTER", 1, 1)
	self.Frame.Shadow:SetLayer(1)
	self.Frame.Shadow:SetFontColor(0,0,0,1)
	self.Frame.Text = UI.CreateFrame("Text", "Encounter_Text", self.Frame)
	self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
	self.Frame.Text:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
	self.Frame.Text:SetPoint("CENTER", self.Frame, "CENTER")
	self.Frame.Text:SetLayer(2)
	self.Enrage = {}
	self.Enrage.Frame = UI.CreateFrame("Frame", "Enrage Timer", KBM.Context)
	self.Enrage.Frame:SetPoint("TOPLEFT", self.Frame, "BOTTOMLEFT")
	self.Enrage.Frame:SetPoint("RIGHT", self.Frame, "RIGHT")
	self.Enrage.Frame:SetBackgroundColor(0,0,0,0.33)
	self.Enrage.Frame:SetLayer(5)
	self.Enrage.Shadow = UI.CreateFrame("Text", "Time_Shadow", self.Enrage.Frame)
	self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
	self.Enrage.Shadow:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
	self.Enrage.Shadow:SetPoint("CENTER", self.Enrage.Frame, "CENTER", 1, 1)
	self.Enrage.Shadow:SetLayer(2)
	self.Enrage.Shadow:SetFontColor(0,0,0,1)
	self.Enrage.Text = UI.CreateFrame("Text", "Enrage Text", self.Enrage.Shadow)
	self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
	self.Enrage.Text:SetFont(AddonIni.identifier, "font\\Montserrat-Bold.otf")
	self.Enrage.Text:SetPoint("CENTER", self.Enrage.Frame, "CENTER")
	self.Enrage.Progress = UI.CreateFrame("Texture", "Enrage Progress", self.Enrage.Frame)
	KBM.LoadTexture(self.Enrage.Progress, "KingMolinator", "Media/BarTexture.png")
	self.Enrage.Progress:SetPoint("TOPLEFT", self.Enrage.Frame, "TOPLEFT")
	self.Enrage.Progress:SetPoint("BOTTOM", self.Enrage.Frame, "BOTTOM")
	self.Enrage.Progress:SetWidth(0)
	self.Enrage.Progress:SetBackgroundColor(0.9,0,0,0.33)
	self.Enrage.Progress:SetLayer(1)
	
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
		self.Frame.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Frame.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Enrage.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Enrage.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		if KBM.Menu.Active then
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
			self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
			self.Frame.Text:SetText(self.Frame.Shadow:GetText())
		end
		
		if self.Settings.Enrage then
			if KBM.CurrentMod.Enrage then
				if self.Paused then
					EnrageString = KBM.ConvertTime(KBM.CurrentMod.Enrage)
				else
					if current < KBM.EnrageTime then
						EnrageString = KBM.ConvertTime(KBM.EnrageTime - current + 1)
						self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." "..EnrageString)
						self.Enrage.Text:SetText(self.Enrage.Shadow:GetText())
						self.Enrage.Progress:SetWidth(math.floor(self.Enrage.Frame:GetWidth()*((KBM.TimeElapsed - self.EnrageStart)/KBM.CurrentMod.Enrage)))
					else
						self.Enrage.Shadow:SetText(KBM.Language.Timers.Enraged[KBM.Lang])
						self.Enrage.Text:SetText(KBM.Language.Timers.Enraged[KBM.Lang])
						self.Enrage.Progress:SetWidth(self.Enrage.Frame:GetWidth())
					end
				end
			end
		end		
	end
	
	function self:Unpause()
		self.EnrageStart = KBM.TimeElapsed
		KBM.EnrageTime = Inspect.Time.Real() + KBM.CurrentMod.Enrage
		self.Paused = false
	end
	
	function self:Start(Time)
		self.IsEnraged = false
		self.EnrageStart = 0
		if self.Settings.Enabled then
			if self.Settings.Duration then
				self.Frame:SetVisible(true)
				self.Active = true
			end
			if self.Settings.Enrage then
				if KBM.CurrentMod.Enrage then
					if KBM.CurrentMod.EnragePaused then
						self.Paused = true
					end
					self.Enrage.Frame:SetVisible(true)
					self.Enrage.Progress:SetWidth(0)
					self.Enrage.Progress:SetVisible(true)
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
		self.IsEnraged = false
		self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
		self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
		self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
		self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
		self.Enrage.Progress:SetVisible(false)
		self.Enrage.Progress:SetWidth(0)
	end
	
	function self:SetTest(bool)	
		if bool then
			self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
			self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
			self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
			self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
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
				KBM.EncTimer.Frame.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Frame.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)	
				KBM.EncTimer.Enrage.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Enrage.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
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
				KBM.EncTimer.Frame.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Frame.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)	
				KBM.EncTimer.Enrage.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Enrage.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
			end
		end
	end
	self:ApplySettings()	
end