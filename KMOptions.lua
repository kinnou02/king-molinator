-- KM Options System for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011

local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
KBM.Scroller = {}

function KBM.Scroller:Create(Type, Size, Parent, Callback)

	local ScrollerObj = {}
	ScrollerObj.Callback = Callback
	ScrollerObj.Frame = UI.CreateFrame("Frame", "Scroller", Parent)
	ScrollerObj.Frame:SetBackgroundColor(0,0,0,0.5)
	ScrollerObj.Type = Type
	ScrollerObj.Position = 0
	ScrollerObj.Handle = UI.CreateFrame("Frame", "Scroller Handle", ScrollerObj.Frame)
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
	KBM.MainWin.ChildStore = {}
	KBM.MainWin.HeaderStore = {}
	KBM.MainWin.SpacerStore = {}
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
	
	function KBM.MainWin:PushHeader(GUI)
		for Event, Value in pairs(GUI.Frame.Event) do
			GUI.Frame[Event] = nil
		end
		for Event, Value in pairs(GUI.Text.Event) do
			GUI.Text[Event] = nil
		end
		for Event, Value in pairs(GUI.Check.Event) do
			GUI.Check[Event] = nil
		end
		GUI.Frame:SetVisible(false)
		table.insert(KBM.MainWin.HeaderStore, GUI)
	end
	
	function KBM.MainWin:PullHeader()

		local GUI = {}
		if #self.HeaderStore > 0 then
			GUI = table.remove(self.HeaderStore)
		else
			GUI.Frame = UI.CreateFrame("Frame", "Options Page Header", KBM.MainWin.Options.Frame)
			GUI.Frame:SetBackgroundColor(0,0,0,0)
			GUI.Text = UI.CreateFrame("Text", "Options Page Header Text", GUI.Frame)
			GUI.Text:SetFontColor(0.85,0.65,0)
			GUI.Text:SetFontSize(16)
			GUI.Text:SetLayer(0)
			GUI.Check = UI.CreateFrame("RiftCheckbox", "Options Page Checkbox", GUI.Frame)
			GUI.Check:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT")
		end
		GUI.Check:SetEnabled(true)
		GUI.Text:SetAlpha(1)
		return GUI
	
	end
	
	function KBM.MainWin:PushChild(GUI)
		for Event, Value in pairs(GUI.Frame.Event) do
			GUI.Frame[Event] = nil
		end
		for Event, Value in pairs(GUI.Text.Event) do
			GUI.Text[Event] = nil
		end
		for Event, Value in pairs(GUI.Check.Event) do
			GUI.Check[Event] = nil
		end
		GUI.Frame:SetVisible(false)
		table.insert(KBM.MainWin.ChildStore, GUI)	
	end
	
	function KBM.MainWin:PullChild()
	
		local GUI = {}
		if #self.ChildStore > 0 then
			GUI = table.remove(self.ChildStore)
		else
			GUI.Frame = UI.CreateFrame("Frame", "Options Page Child Frame", KBM.MainWin.Options.Frame)
			GUI.Frame:SetBackgroundColor(0,0,0,0)
			GUI.Check = UI.CreateFrame("RiftCheckbox", "Options Page Child Check", GUI.Frame)
			GUI.Check:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT")
			GUI.Text = UI.CreateFrame("Text", "Options Page Child Text", GUI.Frame)
			GUI.Text:SetFontSize(14)
			GUI.Text:SetFontColor(1,1,1,1)
			GUI.Text:SetPoint("CENTERLEFT", GUI.Check, "CENTERRIGHT")
			GUI.Text:SetLayer(1)
		end
		GUI.Check:SetEnabled(true)
		GUI.Text:SetAlpha(1)
		return GUI
	
	end
	
	function KBM.MainWin:PullSpacer()
	
		local GUI = {}
		if #self.SpacerStore > 0 then
			GUI = table.remove(self.SpacerStore)
		else
			GUI.Frame = UI.CreateFrame("Frame", "Options Page Space", KBM.MainWin.Options.Frame)
			GUI.Frame:SetBackgroundColor(0,0,0,0)			
		end
		return GUI
	
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
		KBM.MainWin.Options.FirstItem.GUI.Frame:SetPoint("TOP", KBM.MainWin.Options.Frame, "TOP", nil, -value)
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
		Header = UI.CreateFrame("Frame", "Header: "..Text, self)
		Header.Children = {}
		Header:SetWidth(self:GetWidth())
		Header.Check = UI.CreateFrame("RiftCheckbox", "Header Check: "..Text, Header)
		Header.Check:SetPoint("CENTERLEFT", Header, "CENTERLEFT", 4, 0)
		Default = Default or true
		if not Static then
			Header.Check:SetChecked(Default)
		else
			Header.Check:SetVisible(false)
			Header.Check:SetEnabled(false)
		end
		Header.Text = UI.CreateFrame("Text", "Header Text: "..Text, Header)
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
		Child = UI.CreateFrame("Frame", "Encounter_Header", Header)
		Child:SetWidth(self:GetWidth()-Header.Check:GetWidth())
		Child:SetPoint("RIGHT", self, "RIGHT")
		Child.Enabled = true
		Child.Check = UI.CreateFrame("RiftCheckbox", "Encounter_Check", Child)
		Child.Check:SetPoint("CENTERLEFT", Child, "CENTERLEFT", 4, 0)
		if Default == nil then
			Child.Check:SetChecked(false)
			Child.Check:SetEnabled(false)
			Child.Check:SetVisible(false)
		else
			Child.Check:SetChecked(Default)
		end
		Child.Text = UI.CreateFrame("Text", "Encounter_Text", Child)
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
					KBM.QueuePage = self
				end
			end
		end
		function Child:Open()
			KBM.MainWin.Options.PageSize = 0
			self.Link:Options()
			KBM.MainWin.Options.Scroller:SetRange(KBM.MainWin.Options.PageSize, KBM.MainWin.Options.Height)
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
			SpacerObj.GUI = KBM.MainWin:PullSpacer()
			if self.LastItem.LastChild then
				SpacerObj.GUI.Frame:SetPoint("TOP", self.LastItem.LastChild.GUI.Frame, "BOTTOM")
				SpacerObj.GUI.Frame:SetPoint("LEFT", KBM.MainWin.Options.Frame, "LEFT")
			else
				SpacerObj.GUI.Frame:SetPoint("TOPLEFT", self.LastItem.GUI.Frame, "BOTTOMLEFT")
			end
			SpacerObj.GUI.Frame:SetWidth(KBM.MainWin.Options.Frame:GetWidth())
			SpacerObj.GUI.Frame:SetHeight(Size)
			self.LastItem = SpacerObj
			table.insert(self.List, SpacerObj)
			KBM.MainWin.Options:AddSize(SpacerObj.GUI.Frame)
			function SpacerObj:Remove()
				table.insert(KBM.MainWin.SpacerStore, self.GUI)
				self.GUI = nil
			end
		end
		function Child.Options:AddHeader(Text, Callback, Default)
			local HeaderObj = {}
			HeaderObj.GUI = KBM.MainWin:PullHeader()
			HeaderObj.GUI.Text:SetText(Text)
			HeaderObj.GUI.Check.Header = HeaderObj
			HeaderObj.GUI.Frame.Header = HeaderObj
			if self.LastItem then
				if self.LastItem.LastChild then
					HeaderObj.GUI.Frame:SetPoint("TOP", self.LastItem.LastChild.GUI.Frame, "BOTTOM")
					HeaderObj.GUI.Frame:SetPoint("LEFT", KBM.MainWin.Options.Frame, "LEFT")
				else
					HeaderObj.GUI.Frame:SetPoint("TOPLEFT", self.LastItem.GUI.Frame, "BOTTOMLEFT")
				end
			else
				HeaderObj.GUI.Frame:SetPoint("TOPLEFT", KBM.MainWin.Options.Frame, "TOPLEFT")
				KBM.MainWin.Options.FirstItem = HeaderObj
			end
			function HeaderObj:EnableChildren()
				for _, ChildObj in ipairs(self.Children) do
					ChildObj:Enable()
				end
			end
			function HeaderObj:DisableChildren()
				for _, ChildObj in ipairs(self.Children) do
					ChildObj:Disable()
				end
			end
			if not Callback then
				HeaderObj.GUI.Check.Callback = nil
				HeaderObj.GUI.Check:SetEnabled(false)
				HeaderObj.GUI.Check:SetVisible(false)
			else
				HeaderObj.GUI.Check.Callback = Callback
				function HeaderObj.GUI.Check.Event:CheckboxChange()
					if self.Callback then
						self:Callback(self:GetChecked())
					end
					if self:GetChecked() then
						self.Header:EnableChildren()
					else
						self.Header:DisableChildren()
					end
				end
			end
			HeaderObj.GUI.Text:SetPoint("CENTERLEFT", HeaderObj.GUI.Check, "CENTERRIGHT")
			HeaderObj.GUI.Frame:SetWidth(HeaderObj.GUI.Text:GetWidth()+HeaderObj.GUI.Check:GetWidth())
			HeaderObj.GUI.Frame:SetHeight(HeaderObj.GUI.Text:GetHeight())
			KBM.MainWin.Options:AddSize(HeaderObj.GUI.Frame)
			HeaderObj.Children = {}
			HeaderObj.LastChild = HeaderObj
			self.LastItem = HeaderObj
			function HeaderObj.GUI.Frame.Event:LeftClick()
				if self.Header.GUI.Check:GetEnabled() then
					if self.Header.GUI.Check:GetChecked() then
						self.Header.GUI.Check:SetChecked(false)
					else
						self.Header.GUI.Check:SetChecked(true)
					end
				end
			end
			table.insert(self.List, HeaderObj)
			function HeaderObj:AddCheck(Text, Callback, Default, Slider)
				local CheckObj = {}
				CheckObj.GUI = KBM.MainWin:PullChild()
				CheckObj.GUI.Text:SetText(Text)
				if self.LastChild == self then
					CheckObj.GUI.Frame:SetPoint("LEFT", self.GUI.Check, "RIGHT")
					CheckObj.GUI.Frame:SetPoint("TOP", self.GUI.Frame, "BOTTOM")
				else
					CheckObj.GUI.Frame:SetPoint("TOPLEFT", self.LastChild.GUI.Frame, "BOTTOMLEFT")
				end
				CheckObj.GUI.Check.Callback = Callback
				CheckObj.GUI.Frame:SetWidth(CheckObj.GUI.Text:GetWidth()+CheckObj.GUI.Check:GetWidth())
				CheckObj.GUI.Frame:SetHeight(CheckObj.GUI.Text:GetHeight())
				CheckObj.GUI.Frame.Base = CheckObj
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
				function CheckObj.GUI.Check.Event:CheckboxChange()
					local bool = self:GetChecked()
					if self.Callback then
						if self.SliderObj then
							self:Callback(bool, CheckObj)
							if bool then
								self.SliderObj:Enable()
							else
								self.SliderObj:Disable()
							end
						else
							self:Callback(bool)
						end
					end
				end
				function CheckObj.GUI.Frame.Event:LeftClick()
					if self.Base.GUI.Check:GetEnabled() then
						if self.Base.GUI.Check:GetChecked() then
							self.Base.GUI.Check:SetChecked(false)
						else
							self.Base.GUI.Check:SetChecked(true)
						end
					end
				end
				function CheckObj:Enable()
					self.GUI.Check:SetEnabled(true)
					self.GUI.Text:SetAlpha(1)
				end
				function CheckObj:Disable()
					self.GUI.Check:SetEnabled(false)
					self.GUI.Text:SetAlpha(0.5)
				end
				function CheckObj:Remove()
					if self.SliderObj then
						self.SliderObj:Remove()
						self.SliderObj = nil
					end
					KBM.MainWin:PushChild(self.GUI)
					for Obj, pObject in pairs(self) do
						self[Obj] = nil
					end
				end
				self.LastChild = CheckObj
				KBM.MainWin.Options:AddSize(CheckObj.GUI.Frame)
				if self.GUI.Check:GetChecked() then
					CheckObj:Enable()
				else
					CheckObj:Disable()
				end
				CheckObj.GUI.Check:SetChecked(Default)
				CheckObj.GUI.Frame:SetVisible(true)
				return CheckObj
			end
			function HeaderObj:Remove()
				for _, Child in ipairs(self.Children) do
					Child:Remove()
					Child = nil
				end
				self.Children = {}
				self.LastChild = nil
				KBM.MainWin:PushHeader(self.GUI)
				for Obj, pObject in pairs(self) do
					self[Obj] = nil
				end
			end
			HeaderObj.GUI.Frame:SetVisible(true)
			HeaderObj.GUI.Check:SetChecked(Default)
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