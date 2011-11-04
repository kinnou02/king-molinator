-- KM Options System for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011

KBM = KBM_RegisterApp()

function KBM.InitOptions()
	KBM.MainWin = UI.CreateFrame("RiftWindow", "Safe's Boss Mods", KBM.Context)
	KBM.MainWin:SetVisible(false)
	KBM.MainWin:SetController("border")
	KBM.MainWin:SetWidth(700)
	KBM.MainWin:SetHeight(550)
	KBM.MainWin:SetTitle("KM Boss Mods: Options")
				
	if not KBM.Options.Frame.x then
		KBM.MainWin:SetPoint("CENTER", UIParent, "CENTER")
	else
		KBM.MainWin:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.Frame.x, KBM.Options.Frame.y)
	end
	
	KBM.MainWin.Border = KBM.MainWin:GetBorder()
	KBM.MainWin.Content = KBM.MainWin:GetContent()

	BorderX = KBM.MainWin.Border:GetLeft()
	BorderY = KBM.MainWin.Border:GetTop()
	ContentX = KBM.MainWin.Content:GetLeft()
	ContentY = KBM.MainWin.Content:GetTop()
	ContentW = KBM.MainWin.Content:GetWidth()
	ContentH = KBM.MainWin.Content:GetHeight()
	
	KBM.MainWin.Handle = UI.CreateFrame("Frame", "SBM Window Handle", KBM.MainWin)
	KBM.MainWin.Handle:SetPoint("TOPLEFT", KBM.MainWin, "TOPLEFT")
	KBM.MainWin.Handle:SetWidth(KBM.MainWin.Border:GetWidth())
	KBM.MainWin.Handle:SetHeight(ContentY-BorderY)
	KBM.MainWin.Handle.parent = KBM.MainWin.Handle:GetParent()
	
	function KBM.MainWin.Handle.Event:LeftDown()
		local cMouse = Inspect.Mouse()
		local holdx = self.parent:GetLeft()
		local holdy = self.parent:GetTop()
		local holdw = self.parent:GetWidth()
		local holdh = self.parent:GetHeight()
		self.OffsetX = cMouse.x - holdx
		self.OffsetY = cMouse.y - holdy
		self.MouseDown = true
		self.parent:ClearAll()
		self.parent:SetWidth(holdw)
		self.parent:SetHeight(holdh)
		self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", holdx, holdy)
	end
	function KBM.MainWin.Handle.Event:MouseMove(newX, newY)
		if self.MouseDown then
			self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", newX - self.OffsetX, newY - self.OffsetY)
		end
	end
	function KBM.MainWin.Handle.Event:LeftUp()
		if self.MouseDown then
			self.MouseDown = false
			KBM.Options.Frame.x = self:GetLeft()
			KBM.Options.Frame.y = self:GetTop()
		end
	end
	
	MenuWidth = math.floor(ContentW * 0.30)-10

	KBM.MainWin.Menu = UI.CreateFrame("Frame", "SBM Menu Frame", KBM.MainWin.Content)
	KBM.MainWin.Menu:SetWidth(MenuWidth)
	KBM.MainWin.Menu:SetHeight(ContentH)
	KBM.MainWin.Menu:SetPoint("TOPLEFT", KBM.MainWin.Content, "TOPLEFT",5, 5)
	KBM.MainWin.Menu.Headers = {}
	KBM.MainWin.Menu.LastHeader = nil
	
	KBM.MainWin.SplitFrame = UI.CreateFrame("Frame", "KBM Splitter", KBM.MainWin.Content)
	KBM.MainWin.SplitFrame:SetWidth(14)
	KBM.MainWin.SplitFrame:SetHeight(ContentH)
	KBM.MainWin.SplitFrame:SetPoint("LEFT", KBM.MainWin.Menu, "RIGHT")
	KBM.MainWin.SplitFrame:SetPoint("TOP", KBM.MainWin.Content, "TOP")
	KBM.MainWin.SplitHandle = UI.CreateFrame("Frame", "KBM Splitter Handle", KBM.MainWin.SplitFrame)
	KBM.MainWin.SplitHandle:SetWidth(5)
	KBM.MainWin.SplitHandle:SetHeight(ContentH)
	KBM.MainWin.SplitHandle:SetPoint("CENTER", KBM.MainWin.SplitFrame, "CENTER")
	KBM.MainWin.SplitHandle:SetBackgroundColor(1,1,1,0.5)

	OptionsWidth = ContentW - KBM.MainWin.Menu:GetWidth() - KBM.MainWin.SplitFrame:GetWidth() - 10
	KBM.MainWin.Options = UI.CreateFrame("Frame", "KBM Options Frame", KBM.MainWin.Content)
	KBM.MainWin.Options:SetWidth(OptionsWidth)
	KBM.MainWin.Options:SetHeight(ContentH)
	KBM.MainWin.Options:SetPoint("TOPLEFT", KBM.MainWin.SplitFrame, "TOPRIGHT")
	
	KBM.MainWin.Options.Close = UI.CreateFrame("RiftButton", "Close Options", KBM.MainWin.Options)
	KBM.MainWin.Options.Close:SetPoint("BOTTOMRIGHT", KBM.MainWin.Options, "BOTTOMRIGHT")
	KBM.MainWin.Options.Close:SetText("Close")
	
	KBM.MainWin.CurrentPage = nil
	
	function KBM.MainWin.Options.Close.Event:LeftPress()
		KBM.MainWin:SetVisible(false)
		if KBM.MainWin.CurrentPage.Link.Close then
			KBM.MainWin.CurrentPage.Link:Close()
		end
	end

	function KBM.MainWin.Menu:CreateHeader(Text, Hook, Default)
		Header = {}
		Header = KBM:CallFrame(self)
		Header.Children = {}
		Header:SetWidth(self:GetWidth())
		Header.Check = KBM:CallCheck(Header)
		Header.Check:SetPoint("CENTERLEFT", Header, "CENTERLEFT", 4, 0)
		if Hook ~= nil and Default ~= nil then
			Header.Check:SetChecked(Default)
		else
			Header.Check:SetVisible(false)
			Header.Check:SetEnabled(false)
		end
		Header.Text = KBM:CallText(Header)
		Header.Text:SetWidth(Header:GetWidth() - Header.Check:GetWidth())
		Header.Text:SetText(Text)
		Header.Text:SetFontSize(16)
		Header.Text:SetHeight(Header.Text:GetFullHeight())
		Header:SetHeight(Header.Text:GetHeight())
		Header.Text:SetPoint("CENTERLEFT", Header.Check, "CENTERRIGHT")
		Header.Text:SetFontColor(0.85,0.65,0.0)
		Header.Enabled = true
		table.insert(self.Headers, Header)
		if not self.LastHeader then
			self.LastHeader = Header
			Header:SetPoint("TOPLEFT", self, "TOPLEFT")
		else
			if self.LastHeader.LastChild then
				Header:SetPoint("TOP", self.LastHeader.LastChild, "BOTTOM")
				Header:SetPoint("LEFT", self, "LEFT")
			else
				Header:SetPoint("TOP", self.LastHeader, "BOTTOM")
				Header:SetPoint("LEFT", self, "LEFT")
				self.LastHeader = Header
			end
		end
		function Header.Event:MouseIn()
			if self.Enabled then
				self:SetBackgroundColor(0,0,0,0.5)
			end
		end
		function Header.Event:MouseOut()
			if self.Enabled then
				self:SetBackgroundColor(0,0,0,0)
			end
		end
		function Header.Event:LeftClick()
			if self.Enabled then
				if self.Hook then
					--self.Hook:Options()
				end
			end
		end
		Header.LastChild = nil
		KBM.HeaderList[Text] = Header
		return Header
	end
	function KBM.MainWin.Menu:CreateEncounter(Text, Link, Default, Header)
		Child = {}
		Child = KBM:CallFrame(self)
		Child:SetWidth(self:GetWidth()-Header.Check:GetWidth())
		Child:SetPoint("RIGHT", self, "RIGHT")
		Child.Enabled = true
		Child.Check = KBM:CallCheck(Child)
		Child.Check:SetPoint("CENTERLEFT", Child, "CENTERLEFT", 4, 0)
		if Default == nil then
			Child.Check:SetChecked(false)
			Child.Check:SetEnabled(false)
			Child.Check:SetVisible(false)
		else
			Child.Check:SetChecked(Default)
		end
		Child.Text = KBM:CallText(Child)
		Child.Text:SetWidth(Child:GetWidth() - Child.Check:GetWidth())
		Child.Text:SetText(Text)
		Child.Text:SetFontSize(13)
		Child.Text:SetHeight(Child.Text:GetFullHeight())
		Child:SetHeight(Child.Text:GetHeight())
		Child.Text:SetPoint("CENTERLEFT", Child.Check, "CENTERRIGHT")
		table.insert(Header.Children, Child)
		if not Header.LastChild then
			Header.LastChild = Child
			Child:SetPoint("TOP", Header, "BOTTOM")
		else
			Child:SetPoint("TOP", Header.LastChild, "BOTTOM")
			Header.LastChild = Child
		end
		function Child:Enabled(bool)
			self.Check:SetEnabled(bool)
			self.Enabled = bool
			if bool then
				self.Text:SetFontColor(1,1,1)
			else
				self.Text:SetFontColor(0.5,0.5,0.5)
			end
		end
		function Child.Event:MouseIn()
			if self.Enabled then
				self:SetBackgroundColor(0,0,0,0.5)
			end
		end
		function Child.Event:MouseOut()
			if self.Enabled then
				self:SetBackgroundColor(0,0,0,0)
			end
		end
		Child.Link = Link
		Child.Options = {}
		Child.Options.List = {}
		Child.Options.Link = Link
		Child.Options.Child = Child
		Child.Header = Header
		Child.Options.Title = {}
		Child.Options.LastItem = nil
		function Child.Event:LeftClick()
			if self.Enabled then
				if KBM.MainWin.CurrentPage ~= self.Options then
					self.Link:Options()
				end
			end
		end
		function Child.Options:Remove()
			self.Title:Remove()
			self.Title = nil
			for _, Item in ipairs(self.List) do
				Item:Remove()
				Item = nil
			end
			self.List = {}
		end
		function Child.Options:SetTitle()
			if KBM.MainWin.CurrentPage then
				if KBM.MainWin.CurrentPage.Link.Close then
					KBM.MainWin.CurrentPage.Link:Close()
				end
				KBM.MainWin.CurrentPage:Remove()
				KBM.MainWin.CurrentPage = self
			else
				KBM.MainWin.CurrentPage = self
			end
			local TitleObj = {}
			TitleObj.Frame = KBM:CallFrame(KBM.MainWin.Options)
			TitleObj.Frame:SetPoint("TOPLEFT", KBM.MainWin.Options, "TOPLEFT")
			TitleObj.Frame:SetWidth(KBM.MainWin.Options:GetWidth())
			TitleObj.Frame:SetHeight(40)
			TitleObj.Frame:SetBackgroundColor(0,0,0,0.25)
			TitleObj.HeadText = {}
			TitleObj.HeadText.Frame = KBM:CallText(TitleObj.Frame)
			TitleObj.HeadText.Frame:SetPoint("TOPRIGHT", TitleObj.Frame, "TOPRIGHT")
			TitleObj.HeadText.Frame:SetFontColor(0.85,0.65,0.0)
			TitleObj.HeadText.Frame:SetFontSize(18)
			TitleObj.HeadText.Frame:SetText(self.Child.Header.Text:GetText())
			TitleObj.HeadText.Frame:ResizeToText()
			TitleObj.SubText = {}
			TitleObj.SubText.Frame = KBM:CallText(TitleObj.Frame)
			TitleObj.SubText.Frame:SetPoint("BOTTOMLEFT", TitleObj.Frame, "BOTTOMLEFT", 4, 0)
			TitleObj.SubText.Frame:SetFontColor(1,1,1)
			TitleObj.SubText.Frame:SetFontSize(18)
			TitleObj.SubText.Frame:SetText(self.Child.Text:GetText())
			TitleObj.SubText.Frame:ResizeToText()
			TitleObj.Separator = {}
			TitleObj.Separator.Frame = KBM:CallFrame(KBM.MainWin.Options)
			TitleObj.Separator.Frame:SetPoint("TOPLEFT", TitleObj.Frame, "BOTTOMLEFT")
			TitleObj.Separator.Frame:SetWidth(TitleObj.Frame:GetWidth())
			TitleObj.Separator.Frame:SetHeight(10)
			TitleObj.Separator.Frame:SetBackgroundColor(0,0,0,0)
			self.LastItem = TitleObj.Separator
			function TitleObj:Remove()
				self.HeadText.Frame:sRemove()
				self.SubText.Frame:sRemove()
				self.Separator.Frame:sRemove()
				self.Frame:sRemove()
			end
			self.Title = TitleObj
		end
		function Child.Options:AddSpacer(Size)
			if not Size then
				Size = 10
			end
			local SpacerObj = {}
			SpacerObj.Frame = KBM:CallFrame(KBM.MainWin.Options)
			SpacerObj.Frame:SetBackgroundColor(0,0,0,0)
			if self.LastItem.LastChild then
				SpacerObj.Frame:SetPoint("TOP", self.LastItem.LastChild.Frame, "BOTTOM")
				SpacerObj.Frame:SetPoint("LEFT", KBM.MainWin.Options, "LEFT")
			else
				SpacerObj.Frame:SetPoint("TOPLEFT", self.LastItem.Frame, "BOTTOMLEFT")
			end
			SpacerObj.Frame:SetWidth(KBM.MainWin.Options:GetWidth())
			SpacerObj.Frame:SetHeight(Size)
			self.LastItem = SpacerObj
			table.insert(self.List, SpacerObj)
			function SpacerObj:Remove()
				self.Frame:sRemove()
			end
		end
		function Child.Options:AddHeader(Text, Callback, Default)
			local HeaderObj = {}
			HeaderObj.Frame = KBM:CallFrame(KBM.MainWin.Options)
			if self.LastItem.LastChild then
				HeaderObj.Frame:SetPoint("TOP", self.LastItem.LastChild.Frame, "BOTTOM")
				HeaderObj.Frame:SetPoint("LEFT", KBM.MainWin.Options, "LEFT")
			else
				HeaderObj.Frame:SetPoint("TOPLEFT", self.LastItem.Frame, "BOTTOMLEFT")
			end
			HeaderObj.Text = {}
			HeaderObj.Text.Frame = KBM:CallText(HeaderObj.Frame)
			HeaderObj.Text.Frame:SetFontColor(0.85,0.65,0)
			HeaderObj.Text.Frame:SetFontSize(16)
			HeaderObj.Text.Frame:SetLayer(0)
			HeaderObj.Text.Frame:SetText(Text)
			HeaderObj.Text.Frame:ResizeToText()
			HeaderObj.Check = {}
			HeaderObj.Check.Frame = KBM:CallCheck(HeaderObj.Frame)
			HeaderObj.Check.Frame:SetPoint("CENTERLEFT", HeaderObj.Frame, "CENTERLEFT")
			if not Callback then
				HeaderObj.Check.Frame:SetEnabled(false)
				HeaderObj.Check.Frame:SetVisible(false)
			else
				HeaderObj.Check.Frame:SetChecked(Default)
				HeaderObj.Check.Callback = Callback
				function HeaderObj.Check.Frame.Event:CheckboxChange()
					if HeaderObj.Check.Callback then
						HeaderObj.Check:Callback(self:GetChecked())
					end
				end
			end
			HeaderObj.Text.Frame:SetPoint("CENTERLEFT", HeaderObj.Check.Frame, "CENTERRIGHT")
			HeaderObj.Frame:SetWidth(HeaderObj.Text.Frame:GetWidth()+HeaderObj.Check.Frame:GetWidth())
			HeaderObj.Frame:SetHeight(HeaderObj.Text.Frame:GetHeight())
			HeaderObj.Children = {}
			HeaderObj.LastChild = HeaderObj
			self.LastItem = HeaderObj
			function HeaderObj.Frame.Event:LeftClick()
				if HeaderObj.Check.Frame:GetEnabled() then
					if HeaderObj.Check.Frame:GetChecked() then
						HeaderObj.Check.Frame:SetChecked(false)
					else
						HeaderObj.Check.Frame:SetChecked(true)
					end
				end
			end
			table.insert(self.List, HeaderObj)
			function HeaderObj:AddCheck(Text, Callback, Default, Slider)
				local CheckObj = {}
				CheckObj.Frame = KBM:CallFrame(KBM.MainWin.Options)
				CheckObj.Frame:SetBackgroundColor(0,0,0,0)
				if self.LastChild == self then
					CheckObj.Frame:SetPoint("LEFT", self.Check.Frame, "RIGHT")
					CheckObj.Frame:SetPoint("TOP", self.Frame, "BOTTOM")
				else
					CheckObj.Frame:SetPoint("TOPLEFT", self.LastChild.Frame, "BOTTOMLEFT")
				end
				CheckObj.Check = {}
				CheckObj.Check.Frame = KBM:CallCheck(CheckObj.Frame)
				CheckObj.Check.Frame:SetChecked(Default)
				CheckObj.Check.Frame:SetPoint("CENTERLEFT", CheckObj.Frame, "CENTERLEFT")
				CheckObj.Text = {}
				CheckObj.Text.Frame = KBM:CallText(CheckObj.Frame)
				CheckObj.Text.Frame:SetFontSize(14)
				CheckObj.Text.Frame:SetFontColor(1,1,1,1)
				CheckObj.Text.Frame:SetText(Text)
				CheckObj.Text.Frame:SetPoint("CENTERLEFT", CheckObj.Check.Frame, "CENTERRIGHT")
				CheckObj.Text.Frame:ResizeToText()
				CheckObj.Text.Frame:SetLayer(1)
				CheckObj.Frame:SetWidth(CheckObj.Text.Frame:GetWidth()+CheckObj.Check.Frame:GetWidth())
				CheckObj.Frame:SetHeight(CheckObj.Text.Frame:GetHeight())
				CheckObj.Check.Callback = Callback
				-- if Slider then
					-- local SliderObj = {}
					-- SliderObj.Frame = KBM:CallFrame(KBM.MainWin.Options)
					-- SliderObj.Frame:SetPoint("TOPLEFT", CheckObj.Frame, "BOTTOMLEFT")
					-- SliderObj.Bar = {}
					-- SliderObj.Bar.Frame = KBM:CallSlider(SliderObj.Frame)
					-- SliderObj.Bar.Frame:SetRange(Slider.Min, Slider.Max)
					-- SliderObj.Bar.Frame:SetLayer(1)
					-- SliderObj.Bar.Frame:SetPoint("CENTERLEFT", SliderObj.Frame, "CENTERLEFT", 20, 0)
					-- SliderObj.Bar.Frame:SetPosition(Slider.Default)
					-- if Slider.Width then
						-- SliderObj.Bar.Frame:SetWidth(Slider.Width)
					-- end
					-- SliderObj.Bar.Frame:SetHeight(10)
					-- SliderObj.Frame:SetWidth(20 + SliderObj.Bar.Frame:GetWidth())
					-- SliderObj.Frame:SetHeight(SliderObj.Bar.Frame:GetHeight() + 12)
					-- SliderObj.Text = {}
					-- SliderObj.Text.Frame = KBM:CallFrame(SliderObj.Frame)
					-- SliderObj.Text.Frame:SetPoint("BOTTOMRIGHT", SliderObj.Frame, "TOPRIGHT")
					-- SliderObj.Text.Frame:SetBackgroundColor(0,0,0,1)
					-- SliderObj.Text.Frame:SetHeight(CheckObj.Frame:GetHeight())
					-- SliderObj.Text.Frame:SetWidth(36)
					-- SliderObj.Text.Display = KBM:CallText(SliderObj.Text.Frame)
					-- SliderObj.Text.Display:SetPoint("CENTER", SliderObj.Text.Frame, "CENTER")
					-- SliderObj.Text.Display:SetFontSize(16)
					-- SliderObj.Text.Display:SetText(tostring(Slider.Default))
					-- SliderObj.Text.Display:ResizeToText()
					-- if Slider.Callback then
						-- SliderObj.Callback = Slider.Callback
						-- function SliderObj.Bar.Frame.Event:SliderChange()
							-- SliderObj:Callback(self:GetPosition())
						-- end
					-- end
					-- function SliderObj:Enable()
						-- self.Bar.Frame:SetEnabled(true)
						-- self.Bar.Frame:SetAlpha(1)
						-- self.Text.Frame:SetAlpha(1)
					-- end
					-- function SliderObj:Disable()
						-- self.Bar.Frame:SetEnabled(false)
						-- self.Bar.Frame:SetAlpha(0.5)
						-- self.Text.Frame:SetAlpha(0.5)
					-- end
					-- if Default then
						-- SliderObj:Enable()
					-- else
						-- SliderObj:Disable()
					-- end
					-- function SliderObj:Remove()
						-- self.Enable = nil
						-- self.Disable = nil
						-- self.Text.Display:sRemove()
						-- self.Text.Frame:sRemove()
						-- self.Bar.Frame:sRemove()
						-- self = nil
					-- end
					-- CheckObj.SliderObj = SliderObj
					-- self.LastChild = SliderObj
				-- else
				-- end
				table.insert(self.Children, CheckObj)
				function CheckObj.Check.Frame.Event:CheckboxChange()
					local bool = self:GetChecked()
					if CheckObj.Check.Callback then
						if CheckObj.SliderObj then
							CheckObj.Check:Callback(bool, CheckObj)
							if bool then
								CheckObj.SliderObj:Enable()
							else
								CheckObj.SliderObj:Disable()
							end
						else
							CheckObj.Check:Callback(bool)
						end
					end
				end
				function CheckObj.Frame.Event:LeftClick()
					if CheckObj.Check.Frame:GetEnabled() then
						if CheckObj.Check.Frame:GetChecked() then
							CheckObj.Check.Frame:SetChecked(false)
						else
							CheckObj.Check.Frame:SetChecked(true)
						end
					end
				end
				function CheckObj:Enable()
					self.Check.Frame:SetEnabled(true)
				end
				function CheckObj:Disable()
					self.Check.Frame:SetEnabled(false)
				end
				function CheckObj:Remove()
					if self.SliderObj then
						self.SliderObj:Remove()
						self.SliderObj = nil
					end
					self.Check.Frame:sRemove()
					self.Text.Frame:sRemove()
					self.Frame:sRemove()
				end
				self.LastChild = CheckObj
				return CheckObj
			end
			function HeaderObj:EnableChildren()
			
			end
			function HeaderObj:DisableChildren()
			
			end
			function HeaderObj:Remove()
				self.Check.Frame:sRemove()
				self.Text.Frame:sRemove()
				for _, Child in ipairs(self.Children) do
					Child:Remove()
					Child = nil
				end
				self.Children = {}
				self.Frame:sRemove()
			end
			return HeaderObj
		end
		function Child.Options:AddCheck(Text)
		end
		function Child.Options:ClearPage()
		
		end
		return Child
	end
			
end