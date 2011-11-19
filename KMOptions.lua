-- KM Options System for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.Scroller = {}

function KBM.Scroller:Create(Type, Size, Parent, Callback)

	local ScrollerObj = {}
	ScrollerObj.Callback = Callback
	ScrollerObj.Frame = KBM:CallFrame(Parent)
	ScrollerObj.Frame:SetBackgroundColor(0,0,0,0.5)
	ScrollerObj.Type = Type
	ScrollerObj.Position = 0
	ScrollerObj.Handle = KBM:CallFrame(ScrollerObj.Frame)
	if Type == "H" then
		
	else
		ScrollerObj.Handle:SetPoint("LEFT", ScrollerObj.Frame, "LEFT")
		ScrollerObj.Handle:SetPoint("RIGHT", ScrollerObj.Frame, "RIGHT")
		ScrollerObj.Handle:SetPoint("TOP", ScrollerObj.Frame, "TOP")
	end
	ScrollerObj.Handle:SetBackgroundColor(1,1,1,0.5)
	ScrollerObj.Handle:SetLayer(2)
	ScrollerObj.Handle:SetVisible(false)
	ScrollerObj.Handle.In = false
	ScrollerObj.Handle.MouseDown = false
	ScrollerObj.Handle.StartY = 0
	ScrollerObj.Handle.Position = 0
	ScrollerObj.Handle.Multiplier = 2.5
	function ScrollerObj.Handle.Event:MouseIn()
		if not self.MouseDown then
			self:SetBackgroundColor(1,1,1,0.75)
		end
		self.In = true
	end
	function ScrollerObj.Handle.Event:MouseOut()
		if not self.MouseDown then
			self:SetBackgroundColor(1,1,1,0.5)
		end
		self.In = false
	end
	function ScrollerObj.Handle.Event:LeftDown()
		self:SetBackgroundColor(1,1,1,0.25)
		self.StartY = Inspect.Mouse().y
		self.Position = self.Controller.Position
		self.MouseDown = true
	end
	function ScrollerObj.Handle.Event:MouseMove(x,y)
		if self.MouseDown then
			local offsetY = y - self.StartY
			self.Controller.Position = self.Position + offsetY
			if self.Controller.Position < 0 then
				self.Controller.Position = 0
			end
			if self.Controller.Position > self.Controller.Range then
				self.Controller.Position = self.Controller.Range
			end
			self:SetPoint("TOP", self.Controller.Frame, "TOP", nil, self.Controller.Position)
			if self.Controller.Callback then
				self.Controller.Callback(self.Controller.Position * self.Multiplier)
			end
		end
	end
	function ScrollerObj.Handle.Event:LeftUp()
		if self.In then
			self:SetBackgroundColor(1,1,1,0.75)
		else
			self:SetBackgroundColor(1,1,1,0.5)
		end
		self.MouseDown = false
	end
	function ScrollerObj.Handle.Event:LeftUpoutside()
		ScrollerObj.Handle.Event.LeftUp(self)
	end
	function ScrollerObj:UpdateHandle()
		if self.Type == "H" then
		
		else
			if self.Range > self.Frame:GetHeight() then
			
			else
				self.Handle:SetHeight(self.Height - self.Range)
				self.Handle:SetPoint("TOP", self.Frame, "TOP")
			end
		end
	end
	function ScrollerObj:SetHeight(Height)
		self.Height = Height
		self.Frame:SetHeight(Height)
	end
	function ScrollerObj:SetWidth(Width)
		self.Width = Width
		self.Frame:SetWidth(Width)
	end
	function ScrollerObj:SetRange(Size, Total)
		self.Size = Size
		self.Total = Total
		self.Range = (Size - Total) / self.Handle.Multiplier
		if self.Range < 0 then
			self.Handle:SetVisible(false)
		else
			self.Handle:SetVisible(true)
			self:UpdateHandle()
		end
		self:SetPosition(self.Position)
	end
	function ScrollerObj:SetPosition(Value)
		if self.Handle:GetVisible() then
			self.Position = self.Position + (Value / self.Handle.Multiplier)
			if self.Position < 0 then
				self.Position = 0
			elseif self.Position > self.Range then
				self.Position = self.Range
			end
			self.Handle:SetPoint("TOP", self.Frame, "TOP", nil, self.Position)
			if self.Callback then
				self.Callback(self.Position * self.Handle.Multiplier)
			end
		end
	end
	if Type == "H" then
		ScrollerObj:SetWidth(Size)
		ScrollerObj:SetHeight(12)
	else
		ScrollerObj:SetHeight(Size)
		ScrollerObj:SetWidth(12)
	end
	ScrollerObj.Handle.Controller = ScrollerObj
	return ScrollerObj
	
end

function KBM.InitOptions()
	KBM.MainWin = UI.CreateFrame("RiftWindow", "King Boss Mods", KBM.Context)
	KBM.MainWin.Options = {}
	KBM.MainWin.MenuSize = 0
	KBM.MainWin:SetVisible(false)
	KBM.MainWin:SetController("border")
	KBM.MainWin:SetWidth(730)
	KBM.MainWin:SetHeight(550)
	KBM.MainWin:SetTitle("King Boss Mods: Options")
				
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
	
	MenuWidth = math.floor(ContentW * 0.33)-10
	
	KBM.MainWin.Mask = UI.CreateFrame("Mask", "KBM Menu Mask", KBM.MainWin.Content)
	
	KBM.MainWin.Menu = UI.CreateFrame("Frame", "KBM Menu Frame", KBM.MainWin.Mask)
	KBM.MainWin.Menu:SetMouseMasking("limited")
	KBM.MainWin.Mask:SetPoint("TOPLEFT", KBM.MainWin.Menu, "TOPLEFT")
	KBM.MainWin.Mask:SetPoint("BOTTOMRIGHT", KBM.MainWin.Menu, "BOTTOMRIGHT")
	KBM.MainWin.Menu:SetWidth(MenuWidth)
	KBM.MainWin.Menu:SetHeight(ContentH)
	KBM.MainWin.Menu:SetPoint("TOPLEFT", KBM.MainWin.Content, "TOPLEFT",5, 5)
	KBM.MainWin.Menu.Headers = {}
	KBM.MainWin.Menu.LastHeader = nil
	
	KBM.MainWin.SplitFrame = UI.CreateFrame("Frame", "KBM Splitter", KBM.MainWin.Content)
	KBM.MainWin.SplitFrame:SetWidth(14)
	KBM.MainWin.SplitFrame:SetHeight(ContentH)
	KBM.MainWin.SplitFrame:SetPoint("LEFT", KBM.MainWin.Content, "LEFT", MenuWidth, nil)
	KBM.MainWin.SplitFrame:SetPoint("TOP", KBM.MainWin.Content, "TOP")
	KBM.MainWin.SplitHandle = UI.CreateFrame("Frame", "KBM Splitter Handle", KBM.MainWin.SplitFrame)
	KBM.MainWin.SplitHandle:SetWidth(5)
	KBM.MainWin.SplitHandle:SetHeight(ContentH)
	KBM.MainWin.SplitHandle:SetPoint("CENTER", KBM.MainWin.SplitFrame, "CENTER")
	KBM.MainWin.SplitHandle:SetBackgroundColor(0.85,0.65,0,0.5)

	function KBM.MainWin.Scrollback(value)
		KBM.MainWin.FirstItem:SetPoint("TOP", KBM.MainWin.Menu, "TOP", nil, -value)
	end	
	KBM.MainWin.Scroller = KBM.Scroller:Create("V", KBM.MainWin.Menu:GetHeight(), KBM.MainWin.Content, KBM.MainWin.Scrollback)
	KBM.MainWin.Scroller.Frame:SetPoint("TOPRIGHT", KBM.MainWin.SplitFrame, "TOPLEFT")
	OptionsWidth = ContentW - KBM.MainWin.Menu:GetWidth() - KBM.MainWin.SplitFrame:GetWidth() - 10
	KBM.MainWin.Menu:ClearWidth()
	KBM.MainWin.Menu:SetPoint("TOPRIGHT", KBM.MainWin.Scroller.Frame, "TOPLEFT")

	function KBM.MainWin.Menu.Event:WheelForward()
		KBM.MainWin.Scroller:SetPosition(-20)
	end
	function KBM.MainWin.Menu.Event:WheelBack()
		KBM.MainWin.Scroller:SetPosition(20)
	end
	
	KBM.MainWin.Options.Mask = UI.CreateFrame("Mask", "KBM Options Mask", KBM.MainWin.Content)
	KBM.MainWin.Options.Frame = UI.CreateFrame("Frame", "KBM Options Frame", KBM.MainWin.Options.Mask)
	KBM.MainWin.Options.Mask:SetPoint("TOPLEFT", KBM.MainWin.Options.Frame, "TOPLEFT")
	KBM.MainWin.Options.Mask:SetPoint("BOTTOMRIGHT", KBM.MainWin.Options.Frame, "BOTTOMRIGHT")
	KBM.MainWin.Options.PageSize = 0
	KBM.MainWin.Options.Header = UI.CreateFrame("Frame", "KBM Options Header", KBM.MainWin.Content)
	KBM.MainWin.Options.Header:SetWidth(OptionsWidth)
	KBM.MainWin.Options.Header:SetHeight(40)
	KBM.MainWin.Options.Header:SetBackgroundColor(0,0,0,0.25)
	KBM.MainWin.Options.Header:SetPoint("TOPRIGHT", KBM.MainWin.Content, "TOPRIGHT", -5, 0)
	KBM.MainWin.Options.HeadText = UI.CreateFrame("Text", "KBM Header Text", KBM.MainWin.Options.Header)
	KBM.MainWin.Options.HeadText:SetPoint("TOPRIGHT", KBM.MainWin.Options.Header, "TOPRIGHT")
	KBM.MainWin.Options.HeadText:SetFontColor(0.85,0.65,0.0)
	KBM.MainWin.Options.HeadText:SetFontSize(18)
	KBM.MainWin.Options.SubText = UI.CreateFrame("Text", "KBM SubText Text", KBM.MainWin.Options.Header)
	KBM.MainWin.Options.SubText:SetPoint("BOTTOMLEFT", KBM.MainWin.Options.Header, "BOTTOMLEFT", 4, 0)
	KBM.MainWin.Options.SubText:SetFontColor(1,1,1)
	KBM.MainWin.Options.SubText:SetFontSize(18)
	KBM.MainWin.Options.Footer = UI.CreateFrame("Frame", "KBM Options Footer", KBM.MainWin.Content)
	KBM.MainWin.Options.Footer:SetWidth(OptionsWidth)
	KBM.MainWin.Options.Footer:SetHeight(40)
	KBM.MainWin.Options.Footer:SetBackgroundColor(0,0,0,0.25)
	KBM.MainWin.Options.Footer:SetPoint("BOTTOMRIGHT", KBM.MainWin.Content, "BOTTOMRIGHT", -5, 0)
	KBM.MainWin.Options.Frame:SetPoint("TOPLEFT", KBM.MainWin.Options.Header, "BOTTOMLEFT", 0, 10)
	KBM.MainWin.Options.Frame:SetPoint("BOTTOM", KBM.MainWin.Options.Footer, "TOP", nil, -10)
	KBM.MainWin.Options.Height = KBM.MainWin.Options.Frame:GetHeight()
	function KBM.MainWin.Options.Scrollback(value)
		KBM.MainWin.Options.FirstItem.Frame:SetPoint("TOP", KBM.MainWin.Options.Frame, "TOP", nil, -value)
	end
	KBM.MainWin.Options.Scroller = KBM.Scroller:Create("V", KBM.MainWin.Options.Height, KBM.MainWin.Content, KBM.MainWin.Options.Scrollback)
	KBM.MainWin.Options.Scroller.Frame:SetPoint("TOPRIGHT", KBM.MainWin.Options.Header, "BOTTOMRIGHT",0, 10)
	KBM.MainWin.Options.Frame:SetPoint("RIGHT", KBM.MainWin.Options.Scroller.Frame, "LEFT")
	KBM.MainWin.Options.Scroller.Frame:SetLayer(3)
	KBM.MainWin.Options.Scroller.Handle:SetLayer(4)
	
	KBM.MainWin.Options.Close = UI.CreateFrame("RiftButton", "Close Options", KBM.MainWin.Handle)
	KBM.MainWin.Options.Close:SetSkin("close")
	KBM.MainWin.Options.Close:SetPoint("BOTTOMRIGHT", KBM.MainWin.Handle, "BOTTOMRIGHT", -8, -5.5)
	KBM.MainWin.Options.Close:SetText("Close")
	
	KBM.MainWin.CurrentPage = nil
	
	function KBM.MainWin:AddSize(Frame)
		self.MenuSize = self.MenuSize + Frame:GetHeight()
		self.Scroller:SetRange(self.MenuSize, self.Scroller.Frame:GetHeight())
	end
	function KBM.MainWin:SubSize(Size)
		self.MenuSize = self.MenuSize - Size
		self.Scroller:SetRange(self.MenuSize, self.Scroller.Frame:GetHeight())
	end
	
	function KBM.MainWin.Options.Frame.Event:WheelForward()
		KBM.MainWin.Options.Scroller:SetPosition(-20)
	end
	function KBM.MainWin.Options.Frame.Event:WheelBack()
		KBM.MainWin.Options.Scroller:SetPosition(20)
	end
	
	function KBM.MainWin.Options:AddSize(Frame)
		self.PageSize = self.PageSize + Frame:GetHeight()
	end
	
	function KBM.MainWin.Options.Close.Event:LeftPress()
		KBM.MainWin:SetVisible(false)
		if KBM.MainWin.CurrentPage.Link.Close then
			KBM.MainWin.CurrentPage.Link:Close()
		end
	end

	function KBM.MainWin.Menu:CreateHeader(Text, Hook, Default, Static)
		Header = {}
		Header = KBM:CallFrame(self)
		Header.Children = {}
		Header:SetWidth(self:GetWidth())
		Header.Check = KBM:CallCheck(Header)
		Header.Check:SetPoint("CENTERLEFT", Header, "CENTERLEFT", 4, 0)
		Default = Default or true
		if not Static then
			Header.Check:SetChecked(Default)
		else
			Header.Check:SetVisible(false)
			Header.Check:SetEnabled(false)
		end
		Header.Text = KBM:CallText(Header)
		Header.Text:SetWidth(Header:GetWidth() - Header.Check:GetWidth())
		Header.Text:SetText(Text)
		if Static then
			Header.Text:SetFontColor(0.85,0.85,0.0)
			Header.Text:SetFontSize(18)
			Header:SetBackgroundColor(0,0,0,0.33)
			Header.Enabled = false
		else
			Header.Text:SetFontColor(0.85,0.65,0.0)
			Header.Text:SetFontSize(16)
			Header.Enabled = true
		end
		Header.Text:SetHeight(Header.Text:GetFullHeight())
		Header:SetHeight(Header.Text:GetHeight())
		Header.Text:SetPoint("CENTERLEFT", Header.Check, "CENTERRIGHT")
		table.insert(self.Headers, Header)
		if not self.LastHeader then
			Header:SetPoint("TOPLEFT", self, "TOPLEFT")
		else
			if self.LastHeader.LastChild then
				Header:SetPoint("TOP", self.LastHeader.LastChild, "BOTTOM")
				Header:SetPoint("LEFT", self, "LEFT")
			else
				Header:SetPoint("TOP", self.LastHeader, "BOTTOM")
				Header:SetPoint("LEFT", self, "LEFT")
			end
		end
		self.LastHeader = Header
		function Header.Check.Event:CheckboxChange()
			if self:GetChecked() then
				for _, Child in ipairs(self:GetParent().Children) do
					Child:SetVisible(true)
				end
				self:GetParent().LastChild:SetPoint("TOP", self:GetParent().LastChild.Prev, "BOTTOM")
				KBM.MainWin:SubSize(-self:GetParent().ChildSize)
			else
				for _, Child in ipairs(self:GetParent().Children) do
					Child:SetVisible(false)
				end
				self:GetParent().LastChild:SetPoint("TOP", self:GetParent(), "TOP")
				KBM.MainWin:SubSize(self:GetParent().ChildSize)
			end
		end
		function Header.Event:MouseIn()
			if self.Enabled and not KBM.MainWin.Scroller.Handle.MouseDown then
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
				if self.Check:GetChecked() then
					self.Check:SetChecked(false)
				else
					self.Check:SetChecked(true)
				end
			end
		end
		function Header:AddChildSize(Child)
			self.ChildSize = self.ChildSize + Child:GetHeight()
		end
		--Header.LastChild = nil
		KBM.MainWin:AddSize(Header)
		KBM.HeaderList[Text] = Header
		if not KBM.MainWin.FirstItem then
			KBM.MainWin.FirstItem = Header
		end
		Header.ChildSize = 0
		return Header
	end
	function KBM.MainWin.Menu:CreateEncounter(Text, Link, Default, Header)
		Child = {}
		Child = KBM:CallFrame(Header)
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
			Child.Prev = Header
		else
			Child:SetPoint("TOP", Header.LastChild, "BOTTOM")
			Child.Prev = Header.LastChild
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
			if self.Enabled and not KBM.MainWin.Scroller.Handle.MouseDown then
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
					KBM.MainWin.Options.PageSize = 0
					self.Link:Options()
					KBM.MainWin.Options.Scroller:SetRange(KBM.MainWin.Options.PageSize, KBM.MainWin.Options.Height)
				end
			end
		end
		function Child.Options:Remove()
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
			KBM.MainWin.Options.HeadText:SetText(self.Child.Header.Text:GetText())
			KBM.MainWin.Options.HeadText:ResizeToText()
			KBM.MainWin.Options.SubText:SetText(self.Child.Text:GetText())
			KBM.MainWin.Options.SubText:ResizeToText()
			self.LastItem = nil
		end
		function Child.Options:AddSpacer(Size)
			if not Size then
				Size = 10
			end
			local SpacerObj = {}
			SpacerObj.Frame = KBM:CallFrame(KBM.MainWin.Options.Frame)
			SpacerObj.Frame:SetBackgroundColor(0,0,0,0)
			if self.LastItem.LastChild then
				SpacerObj.Frame:SetPoint("TOP", self.LastItem.LastChild.Frame, "BOTTOM")
				SpacerObj.Frame:SetPoint("LEFT", KBM.MainWin.Options.Frame, "LEFT")
			else
				SpacerObj.Frame:SetPoint("TOPLEFT", self.LastItem.Frame, "BOTTOMLEFT")
			end
			SpacerObj.Frame:SetWidth(KBM.MainWin.Options.Frame:GetWidth())
			SpacerObj.Frame:SetHeight(Size)
			self.LastItem = SpacerObj
			table.insert(self.List, SpacerObj)
			KBM.MainWin.Options:AddSize(SpacerObj.Frame)
			function SpacerObj:Remove()
				self.Frame:sRemove()
			end
		end
		function Child.Options:AddHeader(Text, Callback, Default)
			local HeaderObj = {}
			HeaderObj.Frame = KBM:CallFrame(KBM.MainWin.Options.Frame)
			if self.LastItem then
				if self.LastItem.LastChild then
					HeaderObj.Frame:SetPoint("TOP", self.LastItem.LastChild.Frame, "BOTTOM")
					HeaderObj.Frame:SetPoint("LEFT", KBM.MainWin.Options.Frame, "LEFT")
				else
					HeaderObj.Frame:SetPoint("TOPLEFT", self.LastItem.Frame, "BOTTOMLEFT")
				end
			else
				HeaderObj.Frame:SetPoint("TOPLEFT", KBM.MainWin.Options.Frame, "TOPLEFT")
				KBM.MainWin.Options.FirstItem = HeaderObj
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
			KBM.MainWin.Options:AddSize(HeaderObj.Frame)
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
				CheckObj.Frame = KBM:CallFrame(KBM.MainWin.Options.Frame)
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
				KBM.MainWin.Options:AddSize(CheckObj.Frame)
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
		Header.LastChild = Child
		KBM.MainWin:AddSize(Child)
		Header:AddChildSize(Child)
		return Child
	end
			
end