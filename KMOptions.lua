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

function KBM.InitTabs()
	KBM.Tabs = {}
	KBM.Tabs.Total = 0
	KBM.Tabs.Current = nil
	KBM.Tabs.List = {}
	KBM.Tabs.Height = {
		Selected = 31,
		Unselected = 25,
	}
	KBM.Tabs.GUI = {}
	KBM.Tabs.GUI.Page = UI.CreateFrame("Frame", "Encounter_Tabber", KBM.MainWin)
	KBM.Tabs.GUI.Page:SetPoint("TOPLEFT", KBM.MainWin.Options.Frame, "TOPLEFT")
	KBM.Tabs.GUI.Page:SetPoint("BOTTOMRIGHT", KBM.MainWin.Content, "BOTTOMRIGHT")
	KBM.Tabs.GUI.Page:SetLayer(2)
	
	function KBM.Tabs:Create(Name, Type)	
		if not Type then
			Type = "Single"
		end
		self.Total = self.Total + 1
		self.Size = (self.GUI.Page:GetWidth() / self.Total) - 2
		
		for TabName, Tab in pairs(self.List) do
			Tab.Frame:SetWidth(self.Size)
		end
		
		local Tab = {}
		Tab.Name = Name
		Tab.Type = Type
		Tab.Selected = false
		Tab.Frame = UI.CreateFrame("Frame", "Tabber_"..Name, self.GUI.Page)
		
		if self.Total == 1 then
			self.LastTab = Tab
			Tab.Frame:SetPoint("LEFT", self.GUI.Page, "LEFT")
		else
			Tab.Previous = self.LastTab
			Tab.Frame:SetPoint("LEFT", Tab.Previous.Frame, "RIGHT", 1, nil)
			self.LastTab = Tab
		end
		
		Tab.Frame:SetPoint("BOTTOM", self.GUI.Page, "TOP", nil, self.Height.Unselected)
		Tab.Frame:SetWidth(self.Size)
		Tab.Frame:SetHeight(self.Height.Unselected)
		Tab.Texture = UI.CreateFrame("Texture", "Tabber_Texture_"..Name, Tab.Frame)
		Tab.Texture:SetTexture("KingMolinator", "Media/Tabber_Off.png")
		Tab.Texture:SetPoint("TOPLEFT", Tab.Frame, "TOPLEFT")
		Tab.Texture:SetPoint("BOTTOMRIGHT", Tab.Frame, "BOTTOMRIGHT")
		Tab.Texture:SetLayer(1)
		Tab.TextShadow = UI.CreateFrame("Text", "Tabbar_TextShadow_"..Name, Tab.Frame)
		Tab.TextShadow:SetText(Name)
		Tab.TextShadow:SetFontSize(14)
		Tab.TextShadow:SetFontColor(0,0,0)
		Tab.TextShadow:SetLayer(2)
		Tab.Text = UI.CreateFrame("Text", "Tabber_Text_"..Name, Tab.TextShadow)
		Tab.Text:SetText(Name)
		Tab.Text:SetPoint("CENTER", Tab.Texture, "CENTER", 0, 1)
		Tab.TextShadow:SetPoint("TOPLEFT", Tab.Text, "TOPLEFT", 1, 2)
		Tab.Text:SetFontSize(14)
		Tab.Text:SetFontColor(0.7, 0.7, 0.7)
		Tab.Text:SetLayer(3)
		Tab.Page = UI.CreateFrame("Frame", "Tabber_Page_"..Name, self.GUI.Page)
		Tab.Page:SetPoint("TOP", Tab.Frame, "BOTTOM")
		Tab.Page:SetPoint("LEFT", self.GUI.Page, "LEFT")
		Tab.Page:SetPoint("BOTTOMRIGHT", self.GUI.Page, "BOTTOMRIGHT")
		Tab.MainMask = UI.CreateFrame("Mask", "Tabber_Main_Mask_"..Name, Tab.Page)
		Tab.Main = UI.CreateFrame("Frame", "Tabber_Main_Page_"..Name, Tab.MainMask)
		Tab.MainMask:SetPoint("TOPLEFT", Tab.Main, "TOPLEFT")
		Tab.MainMask:SetPoint("BOTTOMRIGHT", Tab.Main, "BOTTOMRIGHT")
		Tab.Main:SetPoint("TOPLEFT", Tab.Page, "TOPLEFT")
		Tab.Main:SetPoint("BOTTOM", Tab.Page, "BOTTOM")
		Tab.MaxPageSize = Tab.Main:GetHeight()-4
		Tab.Main.Tab = Tab
		
		function Tab.Main:Callback(Position)
			if self.Data.Main.FirstItem.GUI then
				self.Data.Main.FirstItem.GUI.Frame:SetPoint("TOP", Tab.Page, "TOP", nil, -Position)
			end
		end
		
		function Tab.Main.Event:WheelForward()
			self.Scroller:SetPosition(-20)
		end
		
		function Tab.Main.Event:WheelBack()
			self.Scroller:SetPosition(20)
		end
		
		if Tab.Type == "Single" then
			Tab.Main.Scroller = KBM.Scroller:Create("V", Tab.MaxPageSize, Tab.Page, Tab.Main.Callback)
			Tab.Main.Scroller.Frame:SetPoint("TOPLEFT", Tab.Main, "TOPRIGHT", 8, 2)
			Tab.Main:SetWidth(Tab.Page:GetWidth()-Tab.Main.Scroller.Frame:GetWidth() - 14)
		else
			Tab.Main.Scroller = KBM.Scroller:Create("V", Tab.MaxPageSize, Tab.Page, function (Value) Tab.Main.Callback(Tab, Value) end)
			Tab.Main.Scroller.Frame:SetPoint("TOPLEFT", Tab.Main, "TOPRIGHT", 8, 2)
			Tab.Main:SetWidth((Tab.Page:GetWidth() * 0.57)-Tab.Main.Scroller.Frame:GetWidth())
			Tab.SubMask = UI.CreateFrame("Mask", "Tabber_Sub_Mask_"..Name, Tab.Page)
			Tab.Sub = UI.CreateFrame("Frame", "Tabber_Sub_Page_"..Name, Tab.SubMask)
			function Tab.Sub:Callback(Position)
				if self.Data.Sub.FirstItem.GUI then
					self.Data.Sub.FirstItem.GUI.Frame:SetPoint("TOP", Tab.Page, "TOP", nil, -Position)
				end
			end
			function Tab.Sub.Event:WheelForward()
				self.Scroller:SetPosition(-20)
			end
			function Tab.Sub.Event:WheelBack()
				self.Scroller:SetPosition(20)
			end
			Tab.SubMask:SetPoint("TOPLEFT", Tab.Sub, "TOPLEFT")
			Tab.SubMask:SetPoint("BOTTOMRIGHT", Tab.Sub, "BOTTOMRIGHT")
			Tab.Sub:SetPoint("TOPLEFT", Tab.Main.Scroller.Frame, "TOPRIGHT")
			Tab.Sub:SetPoint("BOTTOM", Tab.Page, "BOTTOM")
			Tab.Sub.Scroller = KBM.Scroller:Create("V", Tab.Sub:GetHeight()-4, Tab.Page, Tab.Sub.Callback)
			Tab.Sub.Scroller.Frame:SetPoint("TOPLEFT", Tab.Sub, "TOPRIGHT")
			Tab.Sub:SetWidth((Tab.Page:GetWidth() * 0.40)-Tab.Sub.Scroller.Frame:GetWidth() + 2)
		end
		
		Tab.Page:SetVisible(false)
		Tab.Stores = {
			Main = {
				Header = {},
				Child = {},
				ColorGUI = {},
				PageSize = 0,
			},
			Sub = {
				Header = {},
				Child = {},
				ColorGUI = {},
				PageSize = 0,
			}
		}
		Tab.Frame.Tab = Tab
		
		function Tab:Deselect()		
			self.Page:SetVisible(false)
			self.Text:SetFontColor(0.7, 0.7, 0.7)
			self.Text:SetFontSize(14)
			self.TextShadow:SetFontSize(14)
			self.Selected = false
			self.TextShadow:SetPoint("CENTER", self.Texture, "CENTER", 1, 2)
			self.Frame:SetHeight(KBM.Tabs.Height.Unselected)
			self.PageSize = 0
			self.Texture:SetTexture("KingMolinator", "Media/Tabber_Off.png")
			
			if self.Data then
				for _, Header in ipairs(self.Data.Main.Headers) do
					Header:Hide()
				end			
			end		
			self.Main.Scroller:SetRange(self.Stores.Main.PageSize, self.MaxPageSize)		
		end
		
		function Tab.Frame.Event:MouseIn()			
			if self.Tab.Active then
				self.Tab.MouseOver = true
				if not self.Tab.Selected then
					self.Tab.Text:SetFontColor(1, 1, 1)
					self.Tab.Text:SetFontSize(16)
					self.Tab.TextShadow:SetFontSize(16)
				end
			end			
		end
		
		function Tab.Frame.Event:MouseOut()		
			if self.Tab.Active then
				self.MouseOver = false
				if not self.Tab.Selected then
					self.Tab.Text:SetFontColor(0.7, 0.7, 0.7)
					self.Tab.Text:SetFontSize(14)
					self.Tab.TextShadow:SetFontSize(14)
				end
			end		
		end
		
		function Tab.Frame.Event:LeftClick()			
			if self.Tab.Active then
				if not self.Tab.Selected then
					self.Tab:Select()
				end
			end		
		end
		
		function Tab:Enabled(bool)		
			self.Active = bool
			if bool then
				if not self.Selected then
					self.Text:SetFontColor(0.7, 0.7, 0.7)
				end
			else
				if not self.Selected then
					self.Text:SetFontColor(0.3, 0.3, 0.3)
				end
			end		
		end
		
		function Tab:PushHeader(GUI)		
			for Event, Value in pairs(GUI.Frame.Event) do
				GUI.Frame[Event] = nil
			end
			for Event, Value in pairs(GUI.Text.Event) do
				GUI.Text[Event] = nil
			end
			for Event, Value in pairs(GUI.Check.Event) do
				GUI.Check[Event] = nil
			end
			GUI.Frame.Header = nil
			GUI.Check.Header = nil
			GUI.Frame:SetVisible(false)
			table.insert(self.Stores[GUI.Side].Header, GUI)		
		end

		function Tab:PushColorGUI(GUI)
			GUI.Active = false
			for Event, Value in pairs(GUI.Frame.Event) do
				GUI.Frame[Event] = nil
			end
			for Event, Value in pairs(GUI.Text.Event) do
				GUI.Text[Event] = nil
			end
			for Event, Value in pairs(GUI.Check.Event) do
				GUI.Check[Event] = nil
			end
			GUI.Manager = nil
			GUI.Frame.Child = nil
			GUI.Check.Child = nil
			GUI.Text.Child = nil
			GUI.Frame:SetVisible(false)
			GUI.Hook = nil
			GUI.ColorObj[GUI.Color].Check:SetChecked(false)
			table.insert(self.Stores[GUI.Side].ColorGUI, GUI)		
		end
		
		function Tab:PushChild(GUI)	
			for Event, Value in pairs(GUI.Frame.Event) do
				GUI.Frame[Event] = nil
			end
			for Event, Value in pairs(GUI.Text.Event) do
				GUI.Text[Event] = nil
			end
			for Event, Value in pairs(GUI.Check.Event) do
				GUI.Check[Event] = nil
			end
			GUI.Frame.Child = nil
			GUI.Check.Child = nil
			GUI.Frame:SetVisible(false)
			table.insert(self.Stores[GUI.Side].Child, GUI)			
		end
		
		function Tab:PullColorGUI(Side, Color)
		
			local GUI = {}
			if not Side then
				Side = "Main"
			end
			if #self.Stores[Side].ColorGUI > 0 then
				GUI = table.remove(self.Stores[Side].ColorGUI)
				GUI.ColorObj[Color].Check:SetChecked(true)
			else
				GUI.Frame = UI.CreateFrame("Frame", "Options_Page_Child_Color", self[Side])
				GUI.Frame:SetHeight((KBM.Colors.Count + 1) * 34)
				GUI.Frame:SetWidth(175)
				GUI.Frame:SetBackgroundColor(0,0,0,0)
				GUI.Check = UI.CreateFrame("RiftCheckbox", "Options_Page_Color_Check", GUI.Frame)				
				GUI.Check:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT", 4, 2)
				GUI.Check:SetLayer(2)
				GUI.ShadowText = UI.CreateFrame("Text", "Options_Page_Child_ShadowText", GUI.Frame)
				GUI.ShadowText:SetFontSize(14)
				GUI.ShadowText:SetFontColor(0,0,0,0.9)
				GUI.ShadowText:SetLayer(1)
				GUI.Text = UI.CreateFrame("Text", "Options_Page_Child_Text", GUI.Frame)
				GUI.Text:SetFontSize(14)
				GUI.Text:SetFontColor(1,1,1,1)
				GUI.ShadowText:SetPoint("TOPLEFT", GUI.Text, "TOPLEFT", 1, 1)
				GUI.Text:SetPoint("CENTERLEFT", GUI.Check, "CENTERRIGHT")
				GUI.Text:SetLayer(2)
				GUI.Side = Side
				function GUI:SetText(Text)
					self.ShadowText:SetText(Text)
					self.Text:SetText(Text)
				end
				local Last = GUI.Text
				GUI.ColorObj = {}
				for ColorID, ColorData in pairs(KBM.Colors.List) do
					GUI.ColorObj[ColorID] = {}
					GUI.ColorObj[ColorID].Frame = UI.CreateFrame("Frame", "ColorObj_"..ColorData.Name, GUI.Frame)
					GUI.ColorObj[ColorID].Frame:SetHeight(30)
					GUI.ColorObj[ColorID].Frame:SetPoint("RIGHT", GUI.Frame, "RIGHT")
					GUI.ColorObj[ColorID].Frame:SetPoint("TOPLEFT", Last, "BOTTOMLEFT", 0, 4)
					GUI.ColorObj[ColorID].Frame:SetBackgroundColor(ColorData.Red, ColorData.Green, ColorData.Blue, 0.33)
					GUI.ColorObj[ColorID].Texture = UI.CreateFrame("Texture", "ColorObj_Texture_"..ColorData.Name, GUI.ColorObj[ColorID].Frame)
					GUI.ColorObj[ColorID].Texture:SetTexture("KingMolinator", "Media/BarSkin.png")
					GUI.ColorObj[ColorID].Texture:SetPoint("TOPLEFT", GUI.ColorObj[ColorID].Frame, "TOPLEFT")
					GUI.ColorObj[ColorID].Texture:SetPoint("BOTTOMRIGHT", GUI.ColorObj[ColorID].Frame, "BOTTOMRIGHT")
					GUI.ColorObj[ColorID].Shadow = UI.CreateFrame("Text", "ColorObj_Shadow_"..ColorData.Name, GUI.ColorObj[ColorID].Texture)
					GUI.ColorObj[ColorID].Shadow:SetText(ColorData.Name)
					GUI.ColorObj[ColorID].Shadow:SetFontColor(0,0,0)
					GUI.ColorObj[ColorID].Shadow:SetPoint("CENTER", GUI.ColorObj[ColorID].Texture, "CENTER", 2, 2)
					GUI.ColorObj[ColorID].Shadow:SetFontSize(14)
					GUI.ColorObj[ColorID].Text = UI.CreateFrame("Text", "ColorObj_Text_"..ColorData.Name, GUI.ColorObj[ColorID].Shadow)
					GUI.ColorObj[ColorID].Text:SetText(ColorData.Name)
					GUI.ColorObj[ColorID].Text:SetFontColor(1,1,1)
					GUI.ColorObj[ColorID].Text:SetPoint("CENTER", GUI.ColorObj[ColorID].Texture, "CENTER")
					GUI.ColorObj[ColorID].Text:SetFontSize(14)
					GUI.ColorObj[ColorID].Check = UI.CreateFrame("RiftCheckbox", "ColorObj_Check_"..ColorData.Name, GUI.Frame)
					GUI.ColorObj[ColorID].Check:SetPoint("CENTERRIGHT", GUI.ColorObj[ColorID].Texture, "CENTERLEFT")
					Last = GUI.ColorObj[ColorID].Frame
					if ColorID == Color then
						GUI.ColorObj[ColorID].Check:SetChecked(true)
					end
					ColorObj = GUI.ColorObj[ColorID]
					ColorObj.GUI = GUI
					ColorObj.ID = ColorID
					ColorObj.Check.ColorObj = ColorObj
					ColorObj.Texture.ColorObj = ColorObj
					function ColorObj.Check.Event:CheckboxChange()
					
						if self.ColorObj.GUI.Active then
							if self:GetChecked() and not self.ColorObj.GUI.Removing then
								if self.ColorObj.GUI.Color then
									self.ColorObj.GUI.Removing = true
									self.ColorObj.GUI.ColorObj[self.ColorObj.GUI.Color].Check:SetChecked(false)
								end
								self.ColorObj.GUI.Color = self.ColorObj.ID
								if self.ColorObj.GUI.Hook then
									self.ColorObj.GUI:Hook(true, self.ColorObj.ID)
								end
								self:SetEnabled(false)
							else
								if self.ColorObj.GUI.Removing then
									self:SetEnabled(true)
								end
								self.ColorObj.GUI.Removing = false
							end
						end
						
					end
					function ColorObj.Texture.Event:LeftClick()
						
						if self.ColorObj.Check:GetEnabled() then 
							if not self.ColorObj.Check:GetChecked() then
								self.ColorObj.Check:SetChecked(true)
							end
						end
						
					end
				end
				function GUI:SetEnabled(bool)
				
					for ColorID, ColorObj in pairs(self.ColorObj) do
						if bool then
							ColorObj.Frame:SetAlpha(1)
							ColorObj.Check:SetEnabled(true)
						else
							ColorObj.Frame:SetAlpha(0.5)
							ColorObj.Check:SetEnabled(false)
						end
					end
					if bool then
						if self.Color then
							self.ColorObj[self.Color].Check:SetEnabled(false)
						end
					end
					
				end
			end
			GUI.Color = Color
			GUI.Active = true
			return GUI		
		end
		
		function Tab:PullChild(Side)		
			local GUI = {}
			if not Side then
				Side = "Main"
			end
			if #self.Stores[Side].Child > 0 then
				GUI = table.remove(self.Stores[Side].Child)
			else
				GUI.Frame = UI.CreateFrame("Frame", "Options_Page_Child_Frame", self[Side])
				GUI.Check = UI.CreateFrame("RiftCheckbox", "Options_Page_Child_Check", GUI.Frame)
				GUI.Check:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT", 4, 0)
				GUI.Check:SetLayer(2)
				GUI.ShadowText = UI.CreateFrame("Text", "Options_Page_Child_ShadowText", GUI.Frame)
				GUI.ShadowText:SetFontSize(14)
				GUI.ShadowText:SetFontColor(0,0,0,0.9)
				GUI.ShadowText:SetLayer(1)
				GUI.Text = UI.CreateFrame("Text", "Options_Page_Child_Text", GUI.Frame)
				GUI.Text:SetFontSize(14)
				GUI.Text:SetFontColor(1,1,1,1)
				GUI.ShadowText:SetPoint("TOPLEFT", GUI.Text, "TOPLEFT", 1, 1)
				GUI.Text:SetPoint("CENTERLEFT", GUI.Check, "CENTERRIGHT")
				GUI.Text:SetLayer(2)
				GUI.Text:SetMouseMasking("limited")
				GUI.Side = Side
				function GUI:SetText(Text)
					self.ShadowText:SetText(Text)
					self.Text:SetText(Text)
				end		
			end
			GUI.Check:SetEnabled(true)
			GUI.Frame:SetBackgroundColor(0,0,0,0)
			GUI.Text:SetAlpha(1)
			return GUI	
		end
		
		function Tab:PullHeader(Side)			
			local GUI = {}
			if not Side then
				Side = "Main"
			end
			if #self.Stores[Side].Header > 0 then
				GUI = table.remove(self.Stores[Side].Header)
			else
				GUI.Frame = UI.CreateFrame("Frame", "Options_Page_Header", self[Side])
				GUI.Check = UI.CreateFrame("RiftCheckbox", "Options_Page_Checkbox", GUI.Frame)
				GUI.Check:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT", 4, 0)
				GUI.Check:SetLayer(2)
				GUI.ShadowText = UI.CreateFrame("Text", "Options_Page_Header_ShadowText", GUI.Frame)
				GUI.ShadowText:SetFontSize(16)
				GUI.ShadowText:SetFontColor(0,0,0,0.9)
				GUI.ShadowText:SetLayer(1)
				GUI.Text = UI.CreateFrame("Text", "Options_Page_Header_Text", GUI.Frame)
				GUI.Text:SetFontColor(0.85,0.65,0)
				GUI.Text:SetFontSize(16)
				GUI.ShadowText:SetPoint("TOPLEFT", GUI.Text, "TOPLEFT", 1, 1)
				GUI.Text:SetPoint("CENTERLEFT", GUI.Check, "CENTERRIGHT")
				GUI.Text:SetLayer(2)
				GUI.Side = Side
				function GUI:SetText(Text)
					self.ShadowText:SetText(Text)
					self.Text:SetText(Text)
				end
			end
			GUI.Check:SetEnabled(true)
			GUI.Frame:SetBackgroundColor(0,0,0,0)
			GUI.Text:SetAlpha(1)
			return GUI			
		end
		
		function Tab:Select(Open)			
			self.Stores.Main.PageSize = 0
			self.Stores.Sub.PageSize = 0
			if KBM.Tabs.Current then
				if not Open then
					KBM.Tabs.Current:Deselect()
				end
			end
			
			KBM.Tabs.Current = self
			self.Text:SetFontColor(1, 1, 1)
			self.TextShadow:SetFontSize(16)
			self.Text:SetFontSize(16)
			self.Selected = true
			self.Frame:SetHeight(KBM.Tabs.Height.Selected)
			self.Texture:SetPoint("TOPLEFT", self.Frame, "TOPLEFT")
			self.Texture:SetPoint("BOTTOMRIGHT", self.Frame, "BOTTOMRIGHT")
			self.TextShadow:SetPoint("CENTER", self.Texture, "CENTER", 1, 1)
			self.Texture:SetTexture("KingMolinator", "Media/Tabber.png")
			
			if self.Data then
				for _, Header in ipairs(self.Data.Main.Headers) do
					Header:Display()
				end
			end			
			self.Page:SetVisible(true)
			self.Main.Scroller:SetRange(self.Stores.Main.PageSize, self.MaxPageSize)			
		end	
		
		function Tab:SetData(DataObj)		
			self.Data = DataObj			
		end
		
		function Tab:ClearData()		
			self.Data = nil		
		end
		
		function Tab:AddSize(Side, Object)
			self.Stores[Side].PageSize = self.Stores[Side].PageSize + Object.GUI.Frame:GetHeight() + Object.ChildSize
		end		
		self.List[Name] = Tab	
	end

	KBM.Tabs:Create("Encounter", "Single")
	KBM.Tabs:Create("Timers", "Double")
	KBM.Tabs:Create("Alerts", "Double")
	KBM.Tabs:Create("Castbars", "Double")
	KBM.Tabs:Create("Records", "Single")

	function KBM.Tabs:Open(DataObj)		
		self.Data = DataObj
		for TabName, Data in pairs(DataObj.Tabs) do
			self.List[TabName]:SetData(Data)
			self.List[TabName]:Enabled(Data.Enabled)
		end
		if DataObj.Selected then
			self.List[DataObj.Selected]:Select(true)
		else
			self.List.Encounter:Select(true)
		end
		self.GUI.Page:SetVisible(true)		
	end
	
	function KBM.Tabs:Close()	
		self.GUI.Page:SetVisible(false)
		for TabName, Tab in pairs(self.List) do
			if Tab.Selected then
				self.Data.Selected = TabName
				Tab:Deselect()
			end
			Tab:ClearData()
		end
		self.Data = nil	
	end
	
	function KBM.Tabs.Populate()
		local Tabs = {
			Encounter = {
				Enabled = true,
				Main = {
					Headers = {},
					LastHeader = nil,
					FirstHeader = nil,
				},
				Selected = nil,
			},
			Timers = {
				Enabled = true,
				Main = {
					Headers = {},
				},
				Sub = {
					Headers = {},
				},
				Selected = nil,
			},
			Alerts = {
				Enabled = true,
				Main = {
					Headers = {},
				},
				Sub = {
					Headers = {},
				},
				Selected = nil,
			},
			Castbars = {
				Enabled = true,
				Main = {
					Headers = {},
					LastHeader = nil,
					FirstHeader = nil,
				},
				Sub = {},
				Selected = nil,
			},
			Records = {
				Enabled = true,
				Main = {
					Headers = {},
				},
			},
		}
		return Tabs	
	end
	
	KBM.Tabs.GUI.Page:SetVisible(false)
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
	KBM.MainWin:SetWidth(800)
	KBM.MainWin:SetHeight(550)
	KBM.MainWin:SetTitle("King Boss Mods: Options")
				
	if not KBM.Options.Frame.x then
		KBM.MainWin:SetPoint("CENTER", UIParent, "CENTER")
	else
		KBM.MainWin:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.Frame.x, KBM.Options.Frame.y)
	end
	
	KBM.MainWin.Border = KBM.MainWin:GetBorder()
	KBM.MainWin.Content = KBM.MainWin:GetContent()

	local BorderX = KBM.MainWin.Border:GetLeft()
	local BorderY = KBM.MainWin.Border:GetTop()
	local ContentX = KBM.MainWin.Content:GetLeft()
	local ContentY = KBM.MainWin.Content:GetTop()
	local ContentW = KBM.MainWin.Content:GetWidth()
	local ContentH = KBM.MainWin.Content:GetHeight()
	
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
			GUI.Frame = UI.CreateFrame("Frame", "Options_Page_Header", KBM.MainWin.Options.Frame)
			GUI.Frame:SetBackgroundColor(0,0,0,0)
			GUI.Check = UI.CreateFrame("RiftCheckbox", "Options_Page_Checkbox", GUI.Frame)
			GUI.Check:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT")
			GUI.Check:SetLayer(2)
			GUI.TextShadow = UI.CreateFrame("Text", "Options_Page_Header_TextShadow", GUI.Frame)
			GUI.TextShadow:SetFontColor(0,0,0,0.9)
			GUI.TextShadow:SetFontSize(16)
			GUI.TextShadow:SetPoint("CENTERLEFT", GUI.Check, "CENTERRIGHT", 1, 1)
			GUI.TextShadow:SetLayer(1)
			GUI.Text = UI.CreateFrame("Text", "Options_Page_Header_Text", GUI.Frame)
			GUI.Text:SetFontColor(0.85,0.65,0)
			GUI.Text:SetFontSize(16)
			GUI.Text:SetPoint("CENTERLEFT", GUI.Check, "CENTERRIGHT")
			GUI.Text:SetLayer(2)
			function GUI:SetText(Text)
				self.TextShadow:SetText(Text)
				self.Text:SetText(Text)
			end
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
			GUI.Frame = UI.CreateFrame("Frame", "Options_Page_Child_Frame", KBM.MainWin.Options.Frame)
			GUI.Frame:SetBackgroundColor(0,0,0,0)
			GUI.Check = UI.CreateFrame("RiftCheckbox", "Options_Page_Child_Check", GUI.Frame)
			GUI.Check:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT")
			GUI.Check:SetLayer(2)
			GUI.TextShadow = UI.CreateFrame("Text", "Options_Page_Child_TextShadow", GUI.Frame)
			GUI.TextShadow:SetFontSize(14)
			GUI.TextShadow:SetFontColor(0,0,0,0.9)
			GUI.TextShadow:SetPoint("CENTERLEFT", GUI.Check, "CENTERRIGHT", 1, 1)
			GUI.TextShadow:SetLayer(1)
			GUI.Text = UI.CreateFrame("Text", "Options_Page_Child_Text", GUI.Frame)
			GUI.Text:SetFontSize(14)
			GUI.Text:SetFontColor(1,1,1,1)
			GUI.Text:SetPoint("CENTERLEFT", GUI.Check, "CENTERRIGHT")
			GUI.Text:SetLayer(2)
			function GUI:SetText(Text)
				self.TextShadow:SetText(Text)
				self.Text:SetText(Text)
			end
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
			GUI.Frame = UI.CreateFrame("Frame", "Options_Page_Space", KBM.MainWin.Options.Frame)
			GUI.Frame:SetBackgroundColor(0,0,0,0)			
		end
		return GUI
	
	end
	
	function KBM.MainWin.DefaultTabs()
		local TabObject = {
			MenuSize = 0,
			Headers = {},
		}
		return TabObject
	end

	-- Define Menu related holders
	KBM.MainWin.Tabs = {
		Main = KBM.MainWin.DefaultTabs(),
		Plug = KBM.MainWin.DefaultTabs(),
		Raid = KBM.MainWin.DefaultTabs(),
		Sliver = KBM.MainWin.DefaultTabs(),
		Group = KBM.MainWin.DefaultTabs(),
		Selected = {
			Main = "Main",
			Instance = "Raid",
		}
	}
	KBM.MainWin.Masks = {}
	KBM.MainWin.Scroller = {}

	-- Initialize Left Panel
	KBM.MainWin.MenuArea = UI.CreateFrame("Frame", "KBM_Menu_Area", KBM.MainWin)
	KBM.MainWin.MenuArea:SetPoint("TOPLEFT", KBM.MainWin.Content, "TOPLEFT")
	KBM.MainWin.MenuArea:SetPoint("BOTTOMRIGHT", KBM.MainWin.Content, 0.3, 1)
	
	-- Initialize Content Splitter
	KBM.MainWin.SplitFrame = UI.CreateFrame("Frame", "KBM_Splitter", KBM.MainWin)
	KBM.MainWin.SplitFrame:SetWidth(14)
	KBM.MainWin.SplitFrame:SetHeight(ContentH)
	KBM.MainWin.SplitFrame:SetPoint("TOPRIGHT", KBM.MainWin.MenuArea, "TOPRIGHT")
	KBM.MainWin.SplitHandle = UI.CreateFrame("Frame", "KBM Splitter Handle", KBM.MainWin.SplitFrame)
	KBM.MainWin.SplitHandle:SetWidth(5)
	KBM.MainWin.SplitHandle:SetHeight(ContentH)
	KBM.MainWin.SplitHandle:SetPoint("CENTER", KBM.MainWin.SplitFrame, "CENTER")
	KBM.MainWin.SplitHandle:SetBackgroundColor(0.85,0.65,0,0.5)

	local TabHeight = 30
	local TabHeight_Idle = 26
	local IconSize = 24
	local IconSize_Idle = 17
	local IconSize_High = 20
	local FontSize = 16
	local FontSize_Idle = 12
	local FontSize_High = 14
	local MainHeight = KBM.MainWin.MenuArea:GetHeight() * 0.35

	-- Initialize Left Panel Scrollbars
	KBM.MainWin.Scroller.Main = UI.CreateFrame("RiftScrollbar", "KBM_Main_Scroller", KBM.MainWin.MenuArea)
	KBM.MainWin.Scroller.Main:SetPoint("TOPRIGHT", KBM.MainWin.SplitFrame, "TOPLEFT")
	KBM.MainWin.Scroller.Main:SetHeight(MainHeight)
	KBM.MainWin.Scroller.Instance = UI.CreateFrame("RiftScrollbar", "KBM_Main_Scroller", KBM.MainWin.MenuArea)
	KBM.MainWin.Scroller.Instance:SetPoint("TOPRIGHT", KBM.MainWin.SplitFrame, "TOPLEFT")
	
	local MenuWidth = KBM.MainWin.MenuArea:GetWidth() - KBM.MainWin.SplitFrame:GetWidth() - KBM.MainWin.Scroller.Main:GetWidth() - 6
	local TabWidth = {
		Main = (MenuWidth + KBM.MainWin.Scroller.Main:GetWidth()) * 0.5,
		Instance = ((MenuWidth + KBM.MainWin.Scroller.Main:GetWidth()) * 0.33) + 1,
	}

	-- Tab & Scroller Functions
	function KBM.MainWin.Scroller.Main.Event:ScrollbarChange()
		local TabObj = KBM.MainWin.Tabs[KBM.MainWin.Tabs.Selected.Main]
		TabObj.FirstItem:SetPoint("TOP", TabObj.Menu, "TOP", nil, -self:GetPosition() * TabObj.Multiplier)
	end
	function KBM.MainWin.Scroller.Main.Event:ScrollbarGrab()
		self.Grabbed = true
	end
	function KBM.MainWin.Scroller.Main.Event:ScrollbarRelease()
		self.Grabbed = false
	end
	function KBM.MainWin.Scroller.Instance.Event:ScrollbarChange()
		local TabObj = KBM.MainWin.Tabs[KBM.MainWin.Tabs.Selected.Instance]
		TabObj.FirstItem.GUI.Frame:SetPoint("TOP", TabObj.Menu, "TOP", nil, -self:GetPosition() * TabObj.Multiplier)
	end
	function KBM.MainWin.Scroller.Instance.Event:ScrollbarGrab()
		self.Grabbed = true
	end
	function KBM.MainWin.Scroller.Instance.Event:ScrollbarRelease()
		self.Grabbed = false
	end
	function KBM.MainWin.Tabs:UpdateScroller(Tab)
		if Tab == self.Selected.Main or Tab == self.Selected.Instance then
			if self[Tab].MenuSize < self[Tab].Menu:GetHeight() then
				self[Tab].Scroller:SetEnabled(false)
			else
				if not self[Tab].Scroller:GetEnabled() then
					self[Tab].Scroller:SetEnabled(true)
				end
				local Max = self[Tab].MenuSize - self[Tab].Menu:GetHeight()
				self[Tab].Scroller:SetRange(0, Max / self[Tab].Multiplier)
			end
		end	
	end

	function KBM.MainWin.Tabs:CreateFunctions(Tab)
		local TabObj = self[Tab]
		TabObj.Tab.ID = Tab
		TabObj.Tab.Parent = TabObj
		TabObj.Tab.Position = 0
		if not TabObj.Multiplier then
			TabObj.Multiplier = 5
		end
		function TabObj.Tab.Event:MouseIn()
			if KBM.MainWin.Tabs.Selected[self.Parent.Type] ~= self.ID then
				if self.Parent.Type == "Instance" then
					self.Parent.Icon:SetAlpha(1)
					self.Parent.Icon:SetWidth(IconSize_High)
					self.Parent.Icon:SetHeight(IconSize_High)
				else
					self.Parent.Shadow:SetAlpha(1)
					self.Parent.Shadow:SetFontSize(FontSize_High)
					self.Parent.Text:SetFontSize(FontSize_High)
				end
			end
		end
		function TabObj.Tab.Event:MouseOut()
			if KBM.MainWin.Tabs.Selected[self.Parent.Type] ~= self.ID then
				if self.Parent.Type == "Instance" then
					self.Parent.Icon:SetAlpha(0.5)
					self.Parent.Icon:SetWidth(IconSize_Idle)
					self.Parent.Icon:SetHeight(IconSize_Idle)
				else
					self.Parent.Shadow:SetAlpha(0.6)
					self.Parent.Shadow:SetFontSize(FontSize_Idle)
					self.Parent.Text:SetFontSize(FontSize_Idle)
				end
			end
		end
		function TabObj.Tab.Event:LeftClick()
			if KBM.MainWin.Tabs.Selected[self.Parent.Type] ~= self.ID then
				local Current = KBM.MainWin.Tabs[KBM.MainWin.Tabs.Selected[self.Parent.Type]]
				Current.Menu:SetVisible(false)
				Current.Texture:SetTexture("KingMolinator", "Media/Tabber_Off.png")
				Current.Tab:SetHeight(TabHeight_Idle)
				Current.Tab.Position = Current.Scroller:GetPosition()
				KBM.MainWin.Tabs.Selected[self.Parent.Type] = self.ID
				self.Parent.Menu:SetVisible(true)
				self.Parent.Texture:SetTexture("KingMolinator", "Media/Tabber.png")
				self.Parent.Tab:SetHeight(TabHeight)
				if self.Parent.Type == "Instance" then
					self.Parent.Icon:SetAlpha(1)
					self.Parent.Icon:SetWidth(IconSize)
					self.Parent.Icon:SetHeight(IconSize)
					Current.Icon:SetAlpha(0.5)
					Current.Icon:SetWidth(IconSize_Idle)
					Current.Icon:SetHeight(IconSize_Idle)
				else
					self.Parent.Shadow:SetAlpha(1)
					self.Parent.Shadow:SetFontSize(FontSize)
					self.Parent.Text:SetFontSize(FontSize)
					Current.Shadow:SetAlpha(0.6)
					Current.Shadow:SetFontSize(FontSize_Idle)
					Current.Text:SetFontSize(FontSize_Idle)
				end
				KBM.MainWin.Tabs:UpdateScroller(self.ID)
				if self.Parent.Scroller:GetEnabled() then
					self.Parent.Scroller:SetPosition(self.Position)
				end
			end
		end
	end
	
	-- Initialize Main Tabs
	KBM.MainWin.Tabs.Main.Tab = UI.CreateFrame("Frame", "KBM_Tab_KBM", KBM.MainWin.MenuArea)
	KBM.MainWin.Tabs.Main.Tab:SetPoint("BOTTOMLEFT", KBM.MainWin.MenuArea, "TOPLEFT", 4, TabHeight + 4)
	KBM.MainWin.Tabs.Main.Tab:SetWidth(TabWidth.Main)
	KBM.MainWin.Tabs.Main.Tab:SetHeight(TabHeight)
	KBM.MainWin.Tabs.Main.Scroller = KBM.MainWin.Scroller.Main
	KBM.MainWin.Tabs.Main.Type = "Main"
	KBM.MainWin.Tabs.Main.Texture = UI.CreateFrame("Texture", "KBM_Main_Texture", KBM.MainWin.Tabs.Main.Tab)
	KBM.MainWin.Tabs.Main.Texture:SetTexture("KingMolinator", "Media/Tabber.png")
	KBM.MainWin.Tabs.Main.Texture:SetPoint("TOPLEFT", KBM.MainWin.Tabs.Main.Tab, "TOPLEFT")
	KBM.MainWin.Tabs.Main.Texture:SetPoint("BOTTOMRIGHT", KBM.MainWin.Tabs.Main.Tab, "BOTTOMRIGHT")
	KBM.MainWin.Tabs.Main.Shadow = UI.CreateFrame("Text", "KBM_Main_Tab_Shadow", KBM.MainWin.Tabs.Main.Tab)
	KBM.MainWin.Tabs.Main.Shadow:SetText("KBM")
	KBM.MainWin.Tabs.Main.Shadow:SetFontColor(0,0,0,1)
	KBM.MainWin.Tabs.Main.Shadow:SetPoint("CENTER", KBM.MainWin.Tabs.Main.Tab, "CENTER", 1, 1)
	KBM.MainWin.Tabs.Main.Shadow:SetFontSize(FontSize)
	KBM.MainWin.Tabs.Main.Shadow:SetLayer(2)
	KBM.MainWin.Tabs.Main.Text = UI.CreateFrame("Text", "KBM_Main_Tab_Text", KBM.MainWin.Tabs.Main.Shadow)
	KBM.MainWin.Tabs.Main.Text:SetText("KBM")
	KBM.MainWin.Tabs.Main.Text:SetFontColor(1,1,1,1)
	KBM.MainWin.Tabs.Main.Text:SetPoint("TOPLEFT", KBM.MainWin.Tabs.Main.Shadow, "TOPLEFT", -1, -1)
	KBM.MainWin.Tabs.Main.Text:SetFontSize(FontSize)
	KBM.MainWin.Tabs:CreateFunctions("Main")
	KBM.MainWin.Scroller.Main:ClearPoint("TOP")
	KBM.MainWin.Scroller.Main:SetPoint("TOP", KBM.MainWin.Tabs.Main.Tab, "BOTTOM", nil, 3)
	KBM.MainWin.Tabs.Plug.Tab = UI.CreateFrame("Frame", "KBM_Tab_PlugIn", KBM.MainWin.MenuArea)
	KBM.MainWin.Tabs.Plug.Tab:SetPoint("BOTTOMLEFT", KBM.MainWin.Tabs.Main.Tab, "BOTTOMRIGHT", 2, 0)
	KBM.MainWin.Tabs.Plug.Tab:SetWidth(TabWidth.Main)
	KBM.MainWin.Tabs.Plug.Scroller = KBM.MainWin.Scroller.Main
	KBM.MainWin.Tabs.Plug.Tab:SetHeight(TabHeight_Idle)
	KBM.MainWin.Tabs.Plug.Type = "Main"
	KBM.MainWin.Tabs.Plug.Texture = UI.CreateFrame("Texture", "KBM_Main_Texture", KBM.MainWin.Tabs.Plug.Tab)
	KBM.MainWin.Tabs.Plug.Texture:SetTexture("KingMolinator", "Media/Tabber_Off.png")
	KBM.MainWin.Tabs.Plug.Texture:SetPoint("TOPLEFT", KBM.MainWin.Tabs.Plug.Tab, "TOPLEFT")
	KBM.MainWin.Tabs.Plug.Texture:SetPoint("BOTTOMRIGHT", KBM.MainWin.Tabs.Plug.Tab, "BOTTOMRIGHT")
	KBM.MainWin.Tabs.Plug.Shadow = UI.CreateFrame("Text", "KBM_Plug_Tab_Shadow", KBM.MainWin.Tabs.Plug.Tab)
	KBM.MainWin.Tabs.Plug.Shadow:SetText("Plug-Ins")
	KBM.MainWin.Tabs.Plug.Shadow:SetFontColor(0,0,0,1)
	KBM.MainWin.Tabs.Plug.Shadow:SetPoint("CENTER", KBM.MainWin.Tabs.Plug.Tab, "CENTER", 1, 1)
	KBM.MainWin.Tabs.Plug.Shadow:SetFontSize(FontSize_Idle)
	KBM.MainWin.Tabs.Plug.Shadow:SetAlpha(0.6)
	KBM.MainWin.Tabs.Plug.Shadow:SetLayer(2)
	KBM.MainWin.Tabs.Plug.Text = UI.CreateFrame("Text", "KBM_Plug_Tab_Text", KBM.MainWin.Tabs.Plug.Shadow)
	KBM.MainWin.Tabs.Plug.Text:SetText("Plug-Ins")
	KBM.MainWin.Tabs.Plug.Text:SetFontColor(1,1,1,1)
	KBM.MainWin.Tabs.Plug.Text:SetPoint("TOPLEFT", KBM.MainWin.Tabs.Plug.Shadow, "TOPLEFT", -1, -1)
	KBM.MainWin.Tabs.Plug.Text:SetFontSize(FontSize_Idle)
	KBM.MainWin.Tabs:CreateFunctions("Plug")
	
	-- Initialize Main Mask
	KBM.MainWin.Masks.Main = UI.CreateFrame("Mask", "KBM_Global_Menu_Mask", KBM.MainWin.MenuArea)
	KBM.MainWin.Masks.Main:SetMouseMasking("limited")
	KBM.MainWin.Masks.Main:SetWidth(MenuWidth)
	KBM.MainWin.Masks.Main:SetHeight(MainHeight)
	KBM.MainWin.Masks.Main:SetPoint("TOPLEFT", KBM.MainWin.Tabs.Main.Tab, "BOTTOMLEFT", 5, 5)
	
	-- Initialize Main Tabs pages
	KBM.MainWin.Tabs.Main.Menu = UI.CreateFrame("Frame", "KBM_Global_Menu", KBM.MainWin.Masks.Main)
	KBM.MainWin.Tabs.Main.Menu:SetMouseMasking("limited")
	KBM.MainWin.Tabs.Main.Menu:SetPoint("TOPLEFT", KBM.MainWin.Masks.Main, "TOPLEFT")
	KBM.MainWin.Tabs.Main.Menu:SetPoint("BOTTOMRIGHT", KBM.MainWin.Masks.Main, "BOTTOMRIGHT")
	KBM.MainWin.Tabs.Plug.Menu = UI.CreateFrame("Frame", "KBM_PlugIn_Menu", KBM.MainWin.Masks.Main)
	KBM.MainWin.Tabs.Plug.Menu:SetMouseMasking("limited")
	KBM.MainWin.Tabs.Plug.Menu:SetPoint("TOPLEFT", KBM.MainWin.Masks.Main, "TOPLEFT")
	KBM.MainWin.Tabs.Plug.Menu:SetPoint("BOTTOMRIGHT", KBM.MainWin.Masks.Main, "BOTTOMRIGHT")
	KBM.MainWin.Tabs.Plug.Menu:SetVisible(false)
	
	-- Initialize Instance Tabs
	KBM.MainWin.Tabs.Raid.Tab = UI.CreateFrame("Frame", "KBM_Raid_Tab", KBM.MainWin.MenuArea)
	KBM.MainWin.Tabs.Raid.Tab:SetPoint("LEFT", KBM.MainWin.MenuArea, "LEFT", 4, nil)
	KBM.MainWin.Tabs.Raid.Tab:SetPoint("BOTTOM", KBM.MainWin.Masks.Main, "BOTTOM", nil, TabHeight + 4)
	KBM.MainWin.Tabs.Raid.Tab:SetWidth(TabWidth.Instance)
	KBM.MainWin.Tabs.Raid.Tab:SetHeight(TabHeight)
	KBM.MainWin.Tabs.Raid.Scroller = KBM.MainWin.Scroller.Instance
	KBM.MainWin.Tabs.Raid.Type = "Instance"
	KBM.MainWin.Tabs.Raid.Texture = UI.CreateFrame("Texture", "KBM_Raid_Texture", KBM.MainWin.Tabs.Raid.Tab)
	KBM.MainWin.Tabs.Raid.Texture:SetTexture("KingMolinator", "Media/Tabber.png")
	KBM.MainWin.Tabs.Raid.Texture:SetPoint("TOPLEFT", KBM.MainWin.Tabs.Raid.Tab, "TOPLEFT")
	KBM.MainWin.Tabs.Raid.Texture:SetPoint("BOTTOMRIGHT", KBM.MainWin.Tabs.Raid.Tab, "BOTTOMRIGHT")
	KBM.MainWin.Tabs.Raid.Icon = UI.CreateFrame("Texture", "KBM_Raid_Icon", KBM.MainWin.Tabs.Raid.Tab)
	KBM.MainWin.Tabs.Raid.Icon:SetTexture("KingMolinator", "Media/Raid_Icon.png")
	KBM.MainWin.Tabs.Raid.Icon:SetPoint("CENTER", KBM.MainWin.Tabs.Raid.Tab, "CENTER")
	KBM.MainWin.Tabs.Raid.Icon:SetHeight(IconSize)
	KBM.MainWin.Tabs.Raid.Icon:SetWidth(IconSize)
	KBM.MainWin.Tabs.Raid.Icon:SetLayer(2)
	KBM.MainWin.Scroller.Instance:ClearPoint("TOP")
	KBM.MainWin.Scroller.Instance:SetPoint("TOP", KBM.MainWin.Tabs.Raid.Tab, "BOTTOM", nil, 3)
	KBM.MainWin.Scroller.Instance:SetPoint("BOTTOM", KBM.MainWin.MenuArea, "BOTTOM")
	KBM.MainWin.Tabs.Sliver.Tab = UI.CreateFrame("Frame", "KBM_Sliver_Tab", KBM.MainWin.MenuArea)
	KBM.MainWin.Tabs.Sliver.Tab:SetPoint("BOTTOMLEFT", KBM.MainWin.Tabs.Raid.Tab, "BOTTOMRIGHT", 1, 0)
	KBM.MainWin.Tabs.Sliver.Tab:SetWidth(TabWidth.Instance)
	KBM.MainWin.Tabs.Sliver.Tab:SetHeight(TabHeight_Idle)
	KBM.MainWin.Tabs.Sliver.Scroller = KBM.MainWin.Scroller.Instance
	KBM.MainWin.Tabs.Sliver.Type = "Instance"
	KBM.MainWin.Tabs.Sliver.Texture = UI.CreateFrame("Texture", "KBM_Sliver_Texture", KBM.MainWin.Tabs.Sliver.Tab)
	KBM.MainWin.Tabs.Sliver.Texture:SetTexture("KingMolinator", "Media/Tabber_Off.png")
	KBM.MainWin.Tabs.Sliver.Texture:SetPoint("TOPLEFT", KBM.MainWin.Tabs.Sliver.Tab, "TOPLEFT")
	KBM.MainWin.Tabs.Sliver.Texture:SetPoint("BOTTOMRIGHT", KBM.MainWin.Tabs.Sliver.Tab, "BOTTOMRIGHT")
	KBM.MainWin.Tabs.Sliver.Icon = UI.CreateFrame("Texture", "KBM_Sliver_Icon", KBM.MainWin.Tabs.Sliver.Tab)
	KBM.MainWin.Tabs.Sliver.Icon:SetTexture("KingMolinator", "Media/Sliver_Icon.png")
	KBM.MainWin.Tabs.Sliver.Icon:SetPoint("CENTER", KBM.MainWin.Tabs.Sliver.Tab, "CENTER")
	KBM.MainWin.Tabs.Sliver.Icon:SetHeight(IconSize_Idle)
	KBM.MainWin.Tabs.Sliver.Icon:SetWidth(IconSize_Idle)
	KBM.MainWin.Tabs.Sliver.Icon:SetAlpha(0.5)
	KBM.MainWin.Tabs.Sliver.Icon:SetLayer(2)
	KBM.MainWin.Tabs.Group.Tab = UI.CreateFrame("Frame", "KBM_Group_Tab", KBM.MainWin.MenuArea)
	KBM.MainWin.Tabs.Group.Tab:SetPoint("BOTTOMLEFT", KBM.MainWin.Tabs.Sliver.Tab, "BOTTOMRIGHT", 1, 0)
	KBM.MainWin.Tabs.Group.Tab:SetWidth(TabWidth.Instance)
	KBM.MainWin.Tabs.Group.Tab:SetHeight(TabHeight_Idle)
	KBM.MainWin.Tabs.Group.Scroller = KBM.MainWin.Scroller.Instance
	KBM.MainWin.Tabs.Group.Type = "Instance"
	KBM.MainWin.Tabs.Group.Multiplier = 10
	KBM.MainWin.Tabs.Group.Texture = UI.CreateFrame("Texture", "KBM_Group_Texture", KBM.MainWin.Tabs.Group.Tab)
	KBM.MainWin.Tabs.Group.Texture:SetTexture("KingMolinator", "Media/Tabber_Off.png")
	KBM.MainWin.Tabs.Group.Texture:SetPoint("TOPLEFT", KBM.MainWin.Tabs.Group.Tab, "TOPLEFT")
	KBM.MainWin.Tabs.Group.Texture:SetPoint("BOTTOMRIGHT", KBM.MainWin.Tabs.Group.Tab, "BOTTOMRIGHT")
	KBM.MainWin.Tabs.Group.Icon = UI.CreateFrame("Texture", "KBM_Group_Icon", KBM.MainWin.Tabs.Group.Tab)
	KBM.MainWin.Tabs.Group.Icon:SetTexture("KingMolinator", "Media/Group_Icon.png")
	KBM.MainWin.Tabs.Group.Icon:SetPoint("CENTER", KBM.MainWin.Tabs.Group.Tab, "CENTER")
	KBM.MainWin.Tabs.Group.Icon:SetHeight(IconSize_Idle)
	KBM.MainWin.Tabs.Group.Icon:SetWidth(IconSize_Idle)
	KBM.MainWin.Tabs.Group.Icon:SetAlpha(0.5)
	KBM.MainWin.Tabs.Group.Icon:SetLayer(2)

	local InstanceHeight = KBM.MainWin.Scroller.Instance:GetHeight()
	
	-- Initialize Instance Mask
	KBM.MainWin.Masks.Instance = UI.CreateFrame("Mask", "KBM_Instance_Mask", KBM.MainWin)
	KBM.MainWin.Masks.Instance:SetMouseMasking("limited")
	KBM.MainWin.Masks.Instance:SetWidth(MenuWidth)
	KBM.MainWin.Masks.Instance:SetHeight(InstanceHeight - 5)
	KBM.MainWin.Masks.Instance:SetPoint("TOPLEFT", KBM.MainWin.Tabs.Raid.Tab, "BOTTOMLEFT", 0, 5)
	
	-- Initialize Instance Tabs Pages
	KBM.MainWin.Tabs.Raid.Menu = UI.CreateFrame("Frame", "KBM_Raid_Menu", KBM.MainWin.Masks.Instance)
	KBM.MainWin.Tabs.Raid.Menu:SetMouseMasking("limited")
	KBM.MainWin.Tabs.Raid.Menu:SetPoint("TOPLEFT", KBM.MainWin.Masks.Instance, "TOPLEFT")
	KBM.MainWin.Tabs.Raid.Menu:SetPoint("BOTTOMRIGHT", KBM.MainWin.Masks.Instance, "BOTTOMRIGHT")
	KBM.MainWin.Tabs:CreateFunctions("Raid")
	KBM.MainWin.Tabs.Sliver.Menu = UI.CreateFrame("Frame", "KBM_Sliver_Menu", KBM.MainWin.Masks.Instance)
	KBM.MainWin.Tabs.Sliver.Menu:SetMouseMasking("limited")
	KBM.MainWin.Tabs.Sliver.Menu:SetPoint("TOPLEFT", KBM.MainWin.Masks.Instance, "TOPLEFT")
	KBM.MainWin.Tabs.Sliver.Menu:SetPoint("BOTTOMRIGHT", KBM.MainWin.Masks.Instance, "BOTTOMRIGHT")
	KBM.MainWin.Tabs.Sliver.Menu:SetVisible(false)
	KBM.MainWin.Tabs:CreateFunctions("Sliver")
	KBM.MainWin.Tabs.Group.Menu = UI.CreateFrame("Frame", "KBM_Group_Menu", KBM.MainWin.Masks.Instance)
	KBM.MainWin.Tabs.Group.Menu:SetMouseMasking("limited")
	KBM.MainWin.Tabs.Group.Menu:SetPoint("TOPLEFT", KBM.MainWin.Masks.Instance, "TOPLEFT")
	KBM.MainWin.Tabs.Group.Menu:SetPoint("BOTTOMRIGHT", KBM.MainWin.Masks.Instance, "BOTTOMRIGHT")
	KBM.MainWin.Tabs.Group.Menu:SetVisible(false)
	KBM.MainWin.Tabs:CreateFunctions("Group")
	
	-- Define Functions
	function KBM.MainWin.Masks.Main.Event:WheelForward()
		if KBM.MainWin.Scroller.Main:GetEnabled() then
			KBM.MainWin.Scroller.Main:NudgeUp()
		end
	end
	function KBM.MainWin.Masks.Main.Event:WheelBack()
		if KBM.MainWin.Scroller.Main:GetEnabled() then
			KBM.MainWin.Scroller.Main:NudgeDown()
		end
	end
	
	function KBM.MainWin.Masks.Instance.Event:WheelForward()
		if KBM.MainWin.Scroller.Instance:GetEnabled() then
			KBM.MainWin.Scroller.Instance:NudgeUp()
		end
	end
	function KBM.MainWin.Masks.Instance.Event:WheelBack()
		if KBM.MainWin.Scroller.Instance:GetEnabled() then
			KBM.MainWin.Scroller.Instance:NudgeDown()
		end
	end
		
	KBM.MainWin.Menu = {}
		
	--function KBM.MainWin.Scrollback(value)
		--KBM.MainWin.FirstItem:SetPoint("TOP", KBM.MainWin.Menu, "TOP", nil, -value)
	--end	
	-- KBM.MainWin.Scroller = KBM.Scroller:Create("V", KBM.MainWin.Menu:GetHeight(), KBM.MainWin, KBM.MainWin.Scrollback)
	-- KBM.MainWin.Scroller.Frame:SetPoint("TOPRIGHT", KBM.MainWin.SplitFrame, "TOPLEFT")
	local OptionsWidth = ContentW - KBM.MainWin.MenuArea:GetWidth() - KBM.MainWin.SplitFrame:GetWidth() - 10
	-- KBM.MainWin.Menu:ClearWidth()
	-- KBM.MainWin.Menu:SetPoint("TOPRIGHT", KBM.MainWin.Scroller.Frame, "TOPLEFT")

	--function KBM.MainWin.Menu.Event:WheelForward()
		-- KBM.MainWin.Scroller:SetPosition(-20)
	--end
	--function KBM.MainWin.Menu.Event:WheelBack()
		-- KBM.MainWin.Scroller:SetPosition(20)
	--end
	
	-- KBM.MainWin.Scroller.Frame:SetVisible(false)
	
	KBM.MainWin.Options.Mask = UI.CreateFrame("Mask", "KBM Options Mask", KBM.MainWin)
	KBM.MainWin.Options.Mask:SetMouseMasking("limited")
	KBM.MainWin.Options.Frame = UI.CreateFrame("Frame", "KBM Options Frame", KBM.MainWin.Options.Mask)
	KBM.MainWin.Options.Frame:SetMouseMasking("limited")
	KBM.MainWin.Options.Mask:SetPoint("TOPLEFT", KBM.MainWin.Options.Frame, "TOPLEFT")
	KBM.MainWin.Options.Mask:SetPoint("BOTTOMRIGHT", KBM.MainWin.Options.Frame, "BOTTOMRIGHT")
	KBM.MainWin.Options.PageSize = 0
	KBM.MainWin.Options.Header = UI.CreateFrame("Frame", "KBM Options Header", KBM.MainWin)
	KBM.MainWin.Options.Header:SetHeight(40)
	KBM.MainWin.Options.Header:SetBackgroundColor(0,0,0,0.25)
	KBM.MainWin.Options.Header:SetPoint("TOPRIGHT", KBM.MainWin.Content, "TOPRIGHT", -5, 0)
	KBM.MainWin.Options.Header:SetPoint("LEFT", KBM.MainWin.SplitFrame, "RIGHT")
	KBM.MainWin.Options.HeadShadow = UI.CreateFrame("Text", "KBM_Header_Shadow", KBM.MainWin.Options.Header)
	KBM.MainWin.Options.HeadShadow:SetPoint("TOPRIGHT", KBM.MainWin.Options.Header, "TOPRIGHT", 1, 1)
	KBM.MainWin.Options.HeadShadow:SetFontColor(0,0,0,1)
	KBM.MainWin.Options.HeadShadow:SetFontSize(18)
	KBM.MainWin.Options.HeadText = UI.CreateFrame("Text", "KBM Header Text", KBM.MainWin.Options.HeadShadow)
	KBM.MainWin.Options.HeadText:SetPoint("TOPRIGHT", KBM.MainWin.Options.Header, "TOPRIGHT")
	KBM.MainWin.Options.HeadText:SetFontColor(0.85,0.65,0.0)
	KBM.MainWin.Options.HeadText:SetFontSize(18)
	KBM.MainWin.Options.SubShadow = UI.CreateFrame("Text", "KBM_SubText_Shadow", KBM.MainWin.Options.Header)
	KBM.MainWin.Options.SubShadow:SetPoint("BOTTOMLEFT", KBM.MainWin.Options.Header, "BOTTOMLEFT", 5, 1)
	KBM.MainWin.Options.SubShadow:SetFontColor(0,0,0,1)
	KBM.MainWin.Options.SubShadow:SetFontSize(18)
	KBM.MainWin.Options.SubText = UI.CreateFrame("Text", "KBM SubText Text", KBM.MainWin.Options.SubShadow)
	KBM.MainWin.Options.SubText:SetPoint("BOTTOMLEFT", KBM.MainWin.Options.Header, "BOTTOMLEFT", 4, 0)
	KBM.MainWin.Options.SubText:SetFontColor(1,1,1)
	KBM.MainWin.Options.SubText:SetFontSize(18)
	KBM.MainWin.Options.Footer = UI.CreateFrame("Frame", "KBM Options Footer", KBM.MainWin)
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
	KBM.MainWin.Options.Scroller = KBM.Scroller:Create("V", KBM.MainWin.Options.Height, KBM.MainWin, KBM.MainWin.Options.Scrollback)
	KBM.MainWin.Options.Scroller.Frame:SetPoint("TOPRIGHT", KBM.MainWin.Options.Header, "BOTTOMRIGHT",0, 10)
	KBM.MainWin.Options.Frame:SetPoint("RIGHT", KBM.MainWin.Options.Scroller.Frame, "LEFT")
	KBM.MainWin.Options.Scroller.Frame:SetLayer(3)
	KBM.MainWin.Options.Scroller.Handle:SetLayer(4)
	
	KBM.MainWin.Options.Close = UI.CreateFrame("RiftButton", "Close Options", KBM.MainWin.Handle)
	KBM.MainWin.Options.Close:SetSkin("close")
	KBM.MainWin.Options.Close:SetPoint("BOTTOMRIGHT", KBM.MainWin.Handle, "BOTTOMRIGHT", -8, -5.5)
	KBM.MainWin.Options.Close:SetText("Close")
	
	KBM.InitTabs()
	
	KBM.MainWin.CurrentPage = nil
		
	function KBM.MainWin:AddSize(Frame, Tab)
		Tab = Tab or "Main"
		self.Tabs[Tab].MenuSize = self.Tabs[Tab].MenuSize + Frame:GetHeight()
		self.Tabs:UpdateScroller(Tab)
	end
	function KBM.MainWin:SubSize(Size)
		self.MenuSize = self.MenuSize - Size
		-- self.Scroller:SetRange(self.MenuSize, self.Scroller.Frame:GetHeight())
	end
	function KBM.MainWin.Tabs:SubSize(Size, Tab)
		self[Tab].MenuSize = self[Tab].MenuSize - Size
		self:UpdateScroller(Tab)
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
		KBM.MainWin.Options:Close()
	end
	
	function KBM.MainWin.Options.Close()
		KBM.MainWin:SetVisible(false)
		if KBM.MainWin.CurrentPage then
			if KBM.MainWin.CurrentPage.Type == "encounter" then
				KBM.MainWin.CurrentPage:ClearPage()
			else
				if KBM.MainWin.CurrentPage.Link.Close then
					KBM.MainWin.CurrentPage.Link:Close()
				end
			end
		end	
		if KBM.Options.CastBar.Visible then
			KBM.CastBar.Anchor:Hide()
		end		
		if KBM.Encounter then
			if KBM.CurrentMod.Settings.Alerts then
				if KBM.CurrentMod.Settings.Alerts.Override then
					KBM.Alert.Settings = KBM.CurrentMod.Settings.Alerts
				else
					KBM.Alert.Settings = KBM.Options.Alerts
				end
			end
			if KBM.CurrentMod.Settings.MechTimer then
				if KBM.CurrentMod.Settings.MechTimer.Override then
					KBM.MechTimer.Settings = KBM.CurrentMod.Settings.MechTimer
				else
					KBM.MechTimer.Settings = KBM.Options.MechTimer
				end
			end
			if KBM.CurrentMod.Settings.PhaseMon then
				if KBM.CurrentMod.Settings.PhaseMon.Override then
					KBM.PhaseMonitor.Settings = KBM.CurrentMod.Settings.PhaseMon
				else
					KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
				end
			end
			if KBM.CurrentMod.Settings.EncTimer then
				if KBM.CurrentMod.Settings.EncTimer.Override then
					KBM.EncTimer.Settings = KBM.CurrentMod.Settings.EncTimer
				else
					KBM.EncTimer.Settings = KBM.Options.EncTimer
				end
			end
			if KBM.CurrentMod.Settings.CastBar then
				for BossName, BossObj in pairs(KBM.CurrentMod.Bosses) do
					if BossObj.CastBar then
						BossObj.CastBar:Hide()
					end
				end
			end
		end
		KBM.Alert:ApplySettings()
		KBM.MechTimer:ApplySettings()
		KBM.PhaseMonitor:ApplySettings()
		KBM.EncTimer:ApplySettings()
		KBM.TankSwap.Anchor:SetVisible(false)
		KBM.TankSwap.Anchor.Drag:SetVisible(false)
		if KBM.PlugIn.Count > 0 then
			for ID, PlugIn in pairs(KBM.PlugIn.List) do
				if PlugIn.MenuClose then
					PlugIn:MenuClose()
				end
			end
		end
	end
	
	function KBM.MainWin.Options.Open()
		KBM.MainWin:SetVisible(true)
		if KBM.Options.CastBar.Visible then
			KBM.CastBar.Anchor:Display()
		end
		if KBM.MainWin.CurrentPage then
			if KBM.MainWin.CurrentPage.Type == "encounter" then
				KBM.MainWin.CurrentPage:SetPage()
			else
				if KBM.MainWin.CurrentPage.Link.Open then
					KBM.MainWin.CurrentPage.Link:Open()
				end
			end
		end
		KBM.Alert:ApplySettings()
		KBM.MechTimer:ApplySettings()
		KBM.PhaseMonitor:ApplySettings()
		KBM.EncTimer:ApplySettings()
		if KBM.Options.TankSwap.Visible then
			KBM.TankSwap.Anchor:SetVisible(true)
			KBM.TankSwap.Anchor.Drag:SetVisible(KBM.Options.TankSwap.Unlocked)
		end
		if KBM.PlugIn.Count > 0 then
			for ID, PlugIn in pairs(KBM.PlugIn.List) do
				if PlugIn.MenuOpen then
					PlugIn:MenuOpen()
				end
			end
		end
	end

	function KBM.MainWin.Menu:CreateHeader(Text, Hook, Default, Static, Tab)
	
		local Header = {}
		Tab = Tab or "Main"					
		local TabObj = KBM.MainWin.Tabs[Tab]
		
		Header = UI.CreateFrame("Frame", "Header: "..Text, TabObj.Menu)
		Header.Tab = Tab
		Header.Children = {}
		Header:SetPoint("LEFT", TabObj.Menu, "LEFT")
		Header:SetPoint("RIGHT", KBM.MainWin.Scroller.Main, "LEFT")
		Header.Check = UI.CreateFrame("RiftCheckbox", "Header Check: "..Text, Header)
		Header.Check:SetPoint("CENTERLEFT", Header, "CENTERLEFT", 4, 0)
		Header.Type = "header"
		Default = Default or true
		if not Static then
			Header.Check:SetChecked(Default)
		else
			Header.Check:SetVisible(false)
			Header.Check:SetEnabled(false)
		end
		Header.TextShadow = UI.CreateFrame("Text", "Header_Text_Shadow", Header)
		Header.TextShadow:SetText(Text)
		Header.TextShadow:SetFontColor(0,0,0,0.9)
		Header.Text = UI.CreateFrame("Text", "Header_Text_"..Text, Header)
		Header.Text:SetText(Text)
		if Static then
			Header.Text:SetFontColor(0.85,0.85,0.0)
			Header.Text:SetFontSize(18)
			Header.TextShadow:SetFontSize(18)
			Header:SetBackgroundColor(0,0,0,0.33)
			Header.Enabled = false
		else
			Header.Text:SetFontColor(0.85,0.65,0.0)
			Header.Text:SetFontSize(16)
			Header.TextShadow:SetFontSize(16)
			Header.Enabled = true
		end
		Header.TextShadow:SetPoint("CENTERLEFT", Header.Check, "CENTERRIGHT", 1, 1)
		Header.TextShadow:SetLayer(1)
		Header.Text:SetPoint("CENTERLEFT", Header.Check, "CENTERRIGHT")
		Header.Text:SetLayer(2)
		table.insert(TabObj.Headers, Header)
		if not TabObj.LastHeader then
			Header:SetPoint("TOP", TabObj.Menu, "TOP")
		else
			TabObj.PrevHeader = TabObj.LastHeader
			TabObj.PrevHeader.NextHeader = Header
			if TabObj.LastHeader.LastChild then
				if TabObj.LastHeader.LastChild.Type == "encounter" then
					Header:SetPoint("TOP", TabObj.LastHeader.LastChild.GUI.Frame, "BOTTOM")
				else
					Header:SetPoint("TOP", TabObj.LastHeader.LastChild, "BOTTOM")
				end
			else
				if TabObj.LastHeader.Type == "instance" then
					Header:SetPoint("TOP", TabObj.LastHeader.GUI.Frame, "BOTTOM")
				else
					Header:SetPoint("TOP", TabObj.LastHeader, "BOTTOM")
				end
			end
		end
		Header:SetHeight(Header.Text:GetHeight())
		TabObj.LastHeader = Header
		function Header.Check.Event:CheckboxChange()
			if self:GetChecked() then
				for _, Child in ipairs(self:GetParent().Children) do
					Child:SetVisible(true)
				end
				self:GetParent().LastChild:SetPoint("TOP", self:GetParent().LastChild.Prev, "BOTTOM")
				KBM.MainWin.Tabs:SubSize(-self:GetParent().ChildSize, Header.Tab)
			else
				for _, Child in ipairs(self:GetParent().Children) do
					Child:SetVisible(false)
				end
				self:GetParent().LastChild:SetPoint("TOP", self:GetParent(), "TOP")
				KBM.MainWin.Tabs:SubSize(self:GetParent().ChildSize, Header.Tab)
			end
		end
		function Header.Event:MouseIn()
			if self.Enabled and not (KBM.MainWin.Scroller.Main.Grabbed or KBM.MainWin.Scroller.Instance.Grabbed) then
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
		KBM.MainWin:AddSize(Header, Tab)
		KBM.HeaderList[Text] = Header
		if not TabObj.FirstItem then
			TabObj.FirstItem = Header
		end
		Header.ChildSize = 0
		return Header
	end
	function KBM.MainWin.Menu:CreateInstance(Name, Default, Hook, Tab)
		
		Tab = Tab or "Raid"
		
		-- New Menu Handler
		local Instance = {}
		local TabObj = KBM.MainWin.Tabs[Tab]
		Instance.Tab = Tab
		Instance.GUI = {}
		Instance.GUI.Frame = UI.CreateFrame("Frame", "Instance_"..Name, TabObj.Menu)
		Instance.GUI.Frame.Instance = Instance
		Instance.Children = {}
		Instance.LastChild = nil
		Instance.Name = Name
		Instance.GUI.Frame:SetWidth(MenuWidth)
		Instance.GUI.Check = UI.CreateFrame("RiftCheckbox", "Instance_Check_"..Name, Instance.GUI.Frame)
		Instance.GUI.Check:SetPoint("CENTERLEFT", Instance.GUI.Frame, "CENTERLEFT", 4, 0)
		Default = Default or true
		Instance.GUI.Check:SetChecked(Default)
		Instance.GUI.TextShadow = UI.CreateFrame("Text", "Instance_Text_"..Name, Instance.GUI.Frame)
		Instance.GUI.TextShadow:SetWidth(Instance.GUI.Frame:GetWidth() - Instance.GUI.Check:GetWidth())
		Instance.GUI.TextShadow:SetText(Name)
		Instance.GUI.TextShadow:SetFontColor(0,0,0,0.9)
		Instance.GUI.TextShadow:SetFontSize(16)
		Instance.GUI.TextShadow:SetLayer(1)
		Instance.GUI.Text = UI.CreateFrame("Text", "Instance_Text_"..Name, Instance.GUI.Frame)
		Instance.GUI.Text:SetWidth(Instance.GUI.Frame:GetWidth() - Instance.GUI.Check:GetWidth())
		Instance.GUI.Text:SetText(Name)
		Instance.GUI.Text:SetFontColor(0.85,0.65,0)
		Instance.GUI.Text:SetFontSize(16)
		Instance.GUI.Text:SetLayer(2)
		Instance.Enabled = true
		Instance.GUI.Text:SetHeight(Instance.GUI.Text:GetHeight())
		Instance.GUI.Frame:SetHeight(Instance.GUI.Text:GetHeight())
		Instance.GUI.TextShadow:SetPoint("CENTERLEFT", Instance.GUI.Check, "CENTERRIGHT", 1, 1)
		Instance.GUI.Text:SetPoint("CENTERLEFT", Instance.GUI.Check, "CENTERRIGHT")
		Instance.Type = "instance"
		table.insert(TabObj.Headers, Instance)
		if not TabObj.LastHeader then
			Instance.GUI.Frame:SetPoint("TOP", TabObj.Menu, "TOP")
		else
			Instance.PrevHeader = TabObj.LastHeader
			Instance.PrevHeader.NextHeader = Instance
			if TabObj.LastHeader.LastChild then
				if TabObj.LastHeader.LastChild.Type == "encounter" then
					Instance.GUI.Frame:SetPoint("TOP", TabObj.LastHeader.LastChild.GUI.Frame, "BOTTOM")
				else
					Instance.GUI.Frame:SetPoint("TOP", TabObj.LastHeader.LastChild, "BOTTOM")
				end
			else
				if TabObj.LastHeader.Type == "instance" then
					Instance.GUI.Frame:SetPoint("TOP", TabObj.LastHeader.GUI.Frame, "BOTTOM")
				else
					Instance.GUI.Frame:SetPoint("TOP", TabObj.LastHeader, "BOTTOM")
				end
			end
		end
		Instance.GUI.Frame:SetPoint("LEFT", TabObj.Menu, "LEFT")
		TabObj.LastHeader = Instance
		Instance.GUI.Check.Instance = Instance
		
		function Instance.GUI.Check.Event:CheckboxChange()		
			if self.Instance.LastChild then
				if self:GetChecked() then
					for _, Child in ipairs(self.Instance.Children) do
						Child.GUI.Frame:SetVisible(true)
					end
					self.Instance.LastChild.GUI.Frame:SetPoint("TOP", self.Instance.LastChild.Prev.GUI.Frame, "BOTTOM")
					KBM.MainWin.Tabs:SubSize(-self.Instance.ChildSize, self.Instance.Tab)
				else
					for _, Child in ipairs(self.Instance.Children) do
						Child.GUI.Frame:SetVisible(false)
					end
					self.Instance.LastChild.GUI.Frame:SetPoint("TOP", self.Instance.GUI.Frame, "TOP")
					KBM.MainWin.Tabs:SubSize(self.Instance.ChildSize, self.Instance.Tab)
				end
			end			
		end
		
		function Instance.GUI.Frame.Event:MouseIn()		
			if self.Instance.Enabled and not (KBM.MainWin.Scroller.Main.Grabbed or KBM.MainWin.Scroller.Instance.Grabbed) then
				self:SetBackgroundColor(0,0,0,0.5)
			end			
		end
		
		function Instance.GUI.Frame.Event:MouseOut()		
			if self.Instance.Enabled then
				self:SetBackgroundColor(0,0,0,0)
			end			
		end
		
		function Instance.GUI.Frame.Event:LeftClick()		
			if self.Instance.Enabled then
				if self.Instance.GUI.Check:GetChecked() then
					self.Instance.GUI.Check:SetChecked(false)
				else
					self.Instance.GUI.Check:SetChecked(true)
				end
			end			
		end
		
		function Instance:AddChildSize(Child)
			self.ChildSize = self.ChildSize + Child:GetHeight()
		end
		
		KBM.MainWin:AddSize(Instance.GUI.Frame, Tab)
		KBM.HeaderList[Name] = Instance
		if not TabObj.FirstItem then
			TabObj.FirstItem = Instance
		end
		Instance.ChildSize = 0
		
		function Instance:CreateEncounter(Boss, Default)			
			local Menu = KBM.MainWin.Tabs[Instance.Tab].Menu
			local Encounter = {}
			Encounter.Boss = Boss
			Encounter.GUI = {}
			Encounter.Pages = {}
			Encounter.Name = Boss.Mod.MenuName
			Encounter.Pages.Tabs = KBM.Tabs.Populate()
			Encounter.Headers = {}
			Encounter.GUI.Frame = UI.CreateFrame("Frame", "Instance_Encounter", Menu)
			Encounter.GUI.Frame:SetWidth(self.GUI.Frame:GetWidth()-self.GUI.Check:GetWidth())
			Encounter.GUI.Frame:SetPoint("RIGHT", self.GUI.Frame, "RIGHT")
			Encounter.GUI.Frame.Encounter = Encounter
			Encounter.Enabled = Default
			Encounter.Type = "encounter"
			Encounter.GUI.Check = UI.CreateFrame("RiftCheckbox", "Encounter_Check", Encounter.GUI.Frame)
			Encounter.GUI.Check:SetChecked(Boss.Mod.Settings.Enabled)
			Encounter.GUI.Check:SetPoint("CENTERLEFT", Encounter.GUI.Frame, "CENTERLEFT", 4, 0)
			Encounter.GUI.Check.Encounter = Encounter
			Encounter.GUI.Check:SetEnabled(false)
			Encounter.GUI.TextShadow = UI.CreateFrame("Text", "Encounter_Text", Encounter.GUI.Frame)
			Encounter.GUI.TextShadow:SetFontSize(13)
			Encounter.GUI.TextShadow:SetText(Encounter.Name)
			Encounter.GUI.TextShadow:SetFontColor(0,0,0,0.9)
			Encounter.GUI.TextShadow:SetLayer(1)
			Encounter.GUI.Text = UI.CreateFrame("Text", "Encounter_Text", Encounter.GUI.Frame)
			Encounter.GUI.Text:SetFontSize(13)
			Encounter.GUI.Text:SetText(Encounter.Name)
			Encounter.GUI.Text:SetFontColor(1,1,1)
			Encounter.GUI.Text:SetLayer(2)
			Encounter.GUI.Frame:SetHeight(Encounter.GUI.Text:GetHeight())
			Encounter.GUI.TextShadow:SetPoint("TOPLEFT", Encounter.GUI.Text, "TOPLEFT", 1 ,1)
			Encounter.GUI.Text:SetPoint("CENTERLEFT", Encounter.GUI.Check, "CENTERRIGHT")
			table.insert(self.Children, Encounter)
			Encounter.Instance = self
			
			if not self.LastChild then
				self.LastChild = Encounter
				Encounter.GUI.Frame:SetPoint("TOP", self.GUI.Frame, "BOTTOM")
				Encounter.Prev = self
			else
				Encounter.Prev = self.LastChild
				Encounter.GUI.Frame:SetPoint("TOP", self.LastChild.GUI.Frame, "BOTTOM")
				self.LastChild = Encounter
			end
			
			if self.NextHeader then
				if self.NextHeader.Type == "instance" then
					self.NextHeader.GUI.Frame:SetPoint("TOP", Encounter.GUI.Frame, "BOTTOM")
				else
					self.NextHeader:SetPoint("TOP", Encounter.GUI.Frame, "BOTTOM")
				end
			end
			
			function Encounter.Enabled(bool)			
				self.GUI.Check:SetEnabled(bool)
				self.Enabled = bool
				if bool then
					self.GUI.Text:SetFontColor(1,1,1)
				else
					self.GUI.Text:SetFontColor(0.5,0.5,0.5)
				end			
			end
			
			function Encounter.GUI.Check.Event:CheckboxChange()
				local bool = self:GetChecked()
				self.Encounter.Boss.Mod.Enabled = bool
				self.Encounter.Boss.Mod.Settings.Enabled = bool
			end
			
			function Encounter.GUI.Frame.Event:MouseIn()				
				if self.Encounter.Enabled and not (KBM.MainWin.Scroller.Main.Grabbed or KBM.MainWin.Scroller.Instance.Grabbed) then
					self:SetBackgroundColor(0,0,0,0.5)
				end				
			end
			
			function Encounter.GUI.Frame.Event:MouseOut()				
				if self.Encounter.Enabled then
					self:SetBackgroundColor(0,0,0,0)
				end				
			end
			
			function Encounter.GUI.Frame.Event:LeftClick()				
				if self.Encounter.Enabled then
					if KBM.MainWin.CurrentPage ~= self.Encounter then
						KBM.QueuePage = self.Encounter
					end
				end				
			end
			
			function Encounter:SetPage()
				KBM.MainWin.Options.Scroller.Frame:SetVisible(false)			
				KBM.MainWin.CurrentPage = self
				KBM.MainWin.Options.Footer:SetVisible(false)
				KBM.MainWin.Options.HeadShadow:SetText(self.Instance.Name)
				KBM.MainWin.Options.HeadText:SetText(self.Instance.Name)
				KBM.MainWin.Options.SubShadow:SetText(self.Name)
				KBM.MainWin.Options.SubText:SetText(self.Name)
				Encounter:ApplyRecords()
				
				KBM.Tabs:Open(self.Pages)
				if self.Boss.Mod.Settings.EncTimer then
					if self.Boss.Mod.Settings.EncTimer.Override then
						KBM.EncTimer.Settings = self.Boss.Mod.Settings.EncTimer
						KBM.EncTimer:ApplySettings()
					end
				end
				
				if self.Boss.Mod.Settings.PhaseMon then
					if self.Boss.Mod.Settings.PhaseMon.Override then
						KBM.PhaseMonitor.Settings = self.Boss.Mod.Settings.PhaseMon
						KBM.PhaseMonitor:ApplySettings()
					end
				end
				
				if self.Boss.Mod.Settings.MechTimer then
					if self.Boss.Mod.Settings.MechTimer.Override then
						KBM.MechTimer.Settings = self.Boss.Mod.Settings.MechTimer
						KBM.MechTimer:ApplySettings()
					end
				end
				
				if self.Boss.Mod.Settings.Alerts then
					if self.Boss.Mod.Settings.Alerts.Override then
						KBM.Alert.Settings = self.Boss.Mod.Settings.Alerts
						KBM.Alert:ApplySettings()
					end
				end
				
				if self.Boss.Mod.Settings.CastBar then
					if self.Boss.Mod.Settings.CastBar.Multi then
						KBM.CastBar.Anchor:Hide()
						for BossName, BossObj in pairs(self.Boss.Mod.Bosses) do
							if BossObj.CastBar then
								BossObj.CastBar:Display()
							end
						end
					elseif self.Boss.Mod.Settings.CastBar.Override then
						KBM.CastBar.Anchor:Hide()
						self.Boss.CastBar:Display()
					end
				end
				if self.Boss.Mod.Custom then
					if self.Boss.Mod.Custom.SetPage then
						self.Boss.Mod.Custom.SetPage()
					end
				end
			end
			
			function Encounter:ClearPage()
				KBM.MainWin.CurrentPage = self
				KBM.Tabs:Close()
				KBM.EncTimer.Settings = KBM.Options.EncTimer
				KBM.EncTimer:ApplySettings()
				KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
				KBM.PhaseMonitor:ApplySettings()
				KBM.MechTimer.Settings = KBM.Options.MechTimer
				KBM.MechTimer:ApplySettings()
				KBM.Alert.Settings = KBM.Options.Alerts
				KBM.Alert:ApplySettings()
				
				if self.Boss.Mod.Settings.CastBar then
					if self.Boss.Mod.Settings.CastBar.Multi then
						for BossName, BossObj in pairs(self.Boss.Mod.Bosses) do
							if BossObj.CastBar then
								BossObj.CastBar:Hide()
							end
						end
						KBM.CastBar.Anchor:Display()
					elseif self.Boss.Mod.Settings.CastBar.Override then
						self.Boss.CastBar:Hide()
						KBM.CastBar.Anchor:Display()
					end
				end
				if self.Boss.Mod.Custom then
					if self.Boss.Mod.Custom.ClearPage then
						self.Boss.Mod.Custom.ClearPage()
					end
				end
				KBM.MainWin.Options.Scroller.Frame:SetVisible(true)
				
			end
			
			function Encounter:CreateHeader(Name, Type, Tab, Side)				
				if not Side then
					Side = "Main"
				end
				
				local Header = {}
				Header.Type = Type
				Header.Name = Name
				Header.Side = Side
				Header.Checked = false
				Header.Tab = Tab
				Header.Encounter = self
				Header.Children = {}
				Header.LastChild = nil
				Header.ChildSize = 0
				Header.Boss = self.Boss
				
				if Side == "Sub" then
					if not self.LastHeader then
						self.Pages.Tabs[Tab].Sub[Name] = {}
						self.Pages.Tabs[Tab].Sub[Name].Headers = {}
					end
				end
				
				function Header:SetHook(Hook)				
					self.Hook = Hook					
				end
				
				function Header:SetChecked(bool)					
					self.Checked = bool					
				end
				
				function Header:EnableChildren(bool)
					for _, Child in ipairs(self.Children) do
						Child:Enable(bool)
					end
				end
				
				function Header:Display()				
					self.ChildSize = 0
					self.GUI = KBM.Tabs.List[self.Tab]:PullHeader(self.Side)
					
					if self.Type == "plain" then
						self.GUI.Check:SetVisible(false)
						self.GUI.Text:ClearPoint("LEFT")
						self.GUI.Text:SetPoint("LEFT", self.GUI.Check, "LEFT")
					else
						self.GUI.Check:SetChecked(self.Checked)
						self.GUI.Text:ClearPoint("LEFT")
						self.GUI.Text:SetPoint("LEFT", self.GUI.Check, "RIGHT")
						if self.Hook then
							self.GUI.Check:SetEnabled(true)				
						else
							self.GUI.Check:SetEnabled(false)
						end
					end
					
					self.GUI:SetText(self.Name)
					self.GUI.Frame:SetWidth(self.GUI.Text:GetWidth() + self.GUI.Check:GetWidth())
					self.GUI.Frame:SetHeight(self.GUI.Text:GetHeight())
					self.GUI.Check.Header = self
					self.GUI.Frame.Header = self
					
					if self.Type == "check" then					
						function self.GUI.Check.Event:CheckboxChange()						
							if self.Header then
								if self.Header.Hook then
									self.Header.Checked = self:GetChecked()
									self.Header:Hook(self.Header.Checked)					
									self.Header:EnableChildren(self:GetChecked())
								end
							end							
						end
						
						function self.GUI.Frame.Event:LeftClick()						
							if self.Header then
								if self.Header.GUI.Check:GetEnabled() then
									if self.Header.GUI.Check:GetChecked() then
										self.Header.GUI.Check:SetChecked(false)
									else
										self.Header.GUI.Check:SetChecked(true)
									end
								end
							end						
						end						
					end
					
					if self.Previous then
						if self.Previous.LastChild then
							self.GUI.Frame:SetPoint("LEFT", self.Previous.GUI.Frame, "LEFT")
							self.GUI.Frame:SetPoint("TOP", self.Previous.LastChild.GUI.Frame, "BOTTOM")
						else
							self.GUI.Frame:SetPoint("TOPLEFT", self.Previous.GUI.Frame, "BOTTOMLEFT")
						end
					else
						self.GUI.Frame:SetPoint("TOPLEFT", KBM.Tabs.List[self.Tab][self.Side], "TOPLEFT", 0, 6)
					end
					
					self.GUI.Frame:SetVisible(true)
					
					for _, Child in ipairs(self.Children) do
						Child:Display()
					end	
					
					KBM.Tabs.List[self.Tab]:AddSize(self.Side, self)					
				end
				
				function Header:Hide()				
					KBM.Tabs.List[self.Tab]:PushHeader(self.GUI)
					self.GUI = nil
					for _, Child in ipairs(self.Children) do
						Child:Hide()
					end				
				end
				
				function Header:CreateOption(Name, Type, Hook)				
					local Option = {}
					Option.Catagory = "option"
					Option.Name = Name
					Option.Header = self
					Option.Type = Type
					Option.Hook = Hook
					Option.Checked = false
					Option.Selected = false
					Option.Encounter = self.Encounter
					Option.Boss = self.Boss
					Option.Tab = self.Encounter.Pages.Tabs[self.Tab]
					Option.SubHeaders = {}
					Option.Enabled = true
					
					function Option:SetChecked(bool)					
						self.Checked = bool
					end
					
					function Option:CreateHeader(Name, Type)
						Header = self.Header.Encounter:CreateHeader(Name, Type, self.Header.Tab, "Sub")
						table.insert(self.SubHeaders, Header)
						return Header
					end
					
					function Option:SubDisplay()
						for _, Header in ipairs(self.SubHeaders) do
							Header:Display()
						end
					end
					
					function Option:SubHide()
						for _, Header in ipairs(self.SubHeaders) do
							Header:Hide()
						end
					end
					
					function Option:Display()
						if self.Type == "color" then
							self.GUI = KBM.Tabs.List[self.Header.Tab]:PullColorGUI(self.Header.Side, self.Color)
						else
							self.GUI = KBM.Tabs.List[self.Header.Tab]:PullChild(self.Header.Side)
							self.GUI.Frame:ClearAll()
						end
						
						if self.Type == "plain" then
							self.GUI.Check:SetVisible(false)
						end
						
						self.GUI.Check:SetChecked(self.Checked)
						if self.Hook then
							self.GUI.Check:SetEnabled(true)
						else
							self.GUI.Check:SetEnabled(false)
						end
						self.GUI:SetText(self.Name)

						if self.Type == "color" then
							self.GUI.Hook = self.Hook
							self.GUI.Manager = self
							self:Enable(self.Data.Settings.Enabled)
							if self.Data.Settings.Enabled then
								self.GUI:SetEnabled(self.Data.Settings.Custom)
							end
						else
							if self.Type == "check" then
								self.GUI.Frame:SetWidth(self.GUI.Text:GetWidth() + self.GUI.Check:GetWidth())
							else
								self.GUI.Frame:SetWidth(KBM.Tabs.List[self.Header.Tab][self.Header.Side]:GetWidth())
							end
							self.GUI.Frame:SetHeight(self.GUI.Text:GetHeight())
							self:Enable(self.Enabled)
						end
						
						self.GUI.Check.Child = self
						self.GUI.Frame.Child = self
						self.GUI.Text.Child = self
						
						if self.Selected then
							self.GUI.Frame:SetBackgroundColor(0.85,0.65,0,0.5)
							self:SubDisplay()
						end
						
						function self.GUI.Check.Event:CheckboxChange()							
							if self.Child then
								if self.Child.Hook then
									self.Child.Checked = self:GetChecked()
									self.Child:Hook(self.Child.Checked)
									if self.Child.Controller then
										if self.Child.Controller.GUI then
											self.Child.Controller.GUI.Check:SetChecked(self:GetChecked())
										else
											self.Child.Controller.Checked = self:GetChecked()
										end
									end
								end
							end							
						end
						
						function self.GUI.Frame.Event:MouseIn()
							if self.Child then
								if self.Child.Enabled then
									if not KBM.Tabs.List[self.Child.Header.Tab][self.Child.Header.Side].Scroller.Handle.MouseDown then
										if self.Child.Type == "excheck" or self.Child.Type == "plain" then
											if not self.Child.Selected then
												self:SetBackgroundColor(0,0,0,0.5)
											end
										end
									end
								end
							end							
						end

						function self.GUI.Frame.Event:MouseOut()
						
							if self.Child then
								if self.Child.Enabled then
									if self.Child.Type == "excheck" or self.Child.Type == "plain" then
										if self.Child.Selected then
											self:SetBackgroundColor(0.85,0.65,0,0.5)	
										else
											self:SetBackgroundColor(0,0,0,0)
										end
									end
								end
							end
							
						end
						if self.Type == "color" then
						
							function self.GUI.Text.Event:LeftClick()							
								if self.Child then
									if self.Child.GUI.Check:GetEnabled() then
										if self.Child.GUI.Check:GetChecked() then
											self.Child.GUI.Check:SetChecked(false)
										else
											self.Child.GUI.Check:SetChecked(true)
										end
									end
								end							
							end
							
						else
						
							function self.GUI.Frame.Event:LeftClick()						
								if self.Child then
									if self.Child.Type == "check" or self.Child.Selected then
										if self.Child.GUI.Check:GetEnabled() then
											if self.Child.GUI.Check:GetChecked() then
												self.Child.GUI.Check:SetChecked(false)
											else
												self.Child.GUI.Check:SetChecked(true)
											end
										end
									elseif self.Child.Type == "explain" or self.Child.Type == "excheck" then
										if self.Child.Enabled then
											if not self.Child.Selected then
												if self.Child.Tab.Selected then
													self.Child.Tab.Selected.GUI.Frame:SetBackgroundColor(0,0,0,0)
													self.Child.Tab.Selected.Selected = false
													self.Child.Tab.Selected:SubHide()
												end
												self:SetBackgroundColor(0.85,0.65,0,0.5)
												self.Child.Selected = true
												self.Child.Tab.Selected = self.Child
												self.Child:SubDisplay()
											end
										end
									end
								end								
							end
							
						end
						
						if self.Previous then
							self.GUI.Frame:SetPoint("TOPLEFT", self.Previous.GUI.Frame, "BOTTOMLEFT")
						else
							self.GUI.Frame:SetPoint("LEFT", self.Header.GUI.Check, "RIGHT")
							self.GUI.Frame:SetPoint("TOP", self.Header.GUI.Frame, "BOTTOM")
						end
						
						if self.Header.Type == "check" or self.Header.Type == "excheck" then
							self:Enable(self.Header.Checked)
						end
						
						self.GUI.Frame:SetVisible(true)
						self.Header.ChildSize = self.Header.ChildSize + self.GUI.Frame:GetHeight()						
					end
					
					function Option:Hide()						
						if self.Type == "color" then
							self.GUI = KBM.Tabs.List[self.Header.Tab]:PushColorGUI(self.GUI)
							self.GUI = nil
						else
							self.GUI = KBM.Tabs.List[self.Header.Tab]:PushChild(self.GUI)
							self.GUI = nil
						end
						if self.Selected then
							self:SubHide()
						end						
					end
					
					function Option:Enable(bool)
						if bool then
							self.Enabled = true
							if self.GUI then
								self.GUI.Text:SetAlpha(1)
								self.GUI.Check:SetEnabled(true)
								if self.Type == "color" then
									self.GUI:SetEnabled(self.Data.Custom)
								end
							end
						else
							self.Enabled = false
							if self.GUI then
								self.GUI.Text:SetAlpha(0.5)
								self.GUI.Check:SetEnabled(false)
								if self.Selected then
									self:SubHide()
									self.Tab.Selected = nil
									self.Selected = false
									self.GUI.Frame:SetBackgroundColor(0,0,0,0)
								end
								if self.Type == "color" then
									self.GUI:SetEnabled(false)
								end
							end
						end
					end
					
					Option.Previous = self.LastChild
					self.LastChild = Option
					table.insert(self.Children, Option)
					return Option
				
				end
				
				if Header.Side == "Main" then
					Header.Previous = self.Pages.Tabs[Tab][Side].LastHeader
					if not Header.Previous then
						self.Pages.Tabs[Tab][Side].FirstItem = Header
					end
					self.Pages.Tabs[Tab][Side].LastHeader = Header
					table.insert(self.Pages.Tabs[Tab][Side].Headers, Header)
				else
					Header.Previous = self.Pages.Tabs[Tab].Sub[Name].LastHeader
					if not Header.Previous then
						self.Pages.Tabs[Tab].Sub[Name].FirstItem = Header
					end
					self.Pages.Tabs[Tab].Sub[Name].LastHeader = Header
					table.insert(self.Pages.Tabs[Tab].Sub[Name].Headers, Header)
				end
				return Header
				
			end
			function Encounter:CastBar()
			
				function self:CreateOptions(BossObj, Index)

					if not BossObj.Menu then
						BossObj.Menu = {}
					end
					BossObj.Menu.Filters = {}
				
					local Child = nil
					local Header = nil
					local Callbacks = {}
					Callbacks.Boss = BossObj
					local MenuName = ""
					if BossObj.NameShort then
						MenuName = BossObj.NameShort
					else
						MenuName = BossObj.Name
					end
					
					if Index > 0 then
						function Callbacks:Enabled(bool)
							self.Boss.Settings.CastBar.Enabled = bool
							if bool then
								self.Boss.CastBar:Display()
							else
								self.Boss.CastBar:Hide()
							end
						end
						function Callbacks:Pinned(bool)
							self.Header.Boss.Settings.CastBar.Pinned = bool
							self.Header.Boss.CastBar:Hide()
							self.Header.Boss.CastBar:Display()
						end
						function Callbacks:Visible(bool)
							self.Header.Boss.Settings.CastBar.Visible = bool
							self.Header.Boss.Settings.CastBar.Unlocked = bool
							if bool then
								self.Header.Boss.CastBar:Display()
							else
								self.Header.Boss.CastBar:Hide()
							end
						end
						function Callbacks:Width(bool)
							self.Header.Boss.Settings.CastBar.ScaleWidth = bool
						end
						function Callbacks:Height(bool)
							self.Header.Boss.Settings.CastBar.ScaleHeight = bool
						end
						function Callbacks:Text(bool)
							self.Header.Boss.Settings.CastBar.TextScale = bool
						end
						
						local Settings = BossObj.Settings.CastBar
						Header = self:CreateHeader("Enable "..MenuName.."'s castbar.", "check", "Castbars", "Main")
						Header:SetChecked(Settings.Enabled)
						Header:SetHook(Callbacks.Enabled)
						Header.Boss = BossObj
						if BossObj.PinCastBar then
							Child = Header:CreateOption(BossObj.Settings.PinMenu, "check", Callbacks.Pinned)
							Child:SetChecked(Settings.Pinned)
						end
						Child = Header:CreateOption(KBM.Language.Options.ShowAnchor[KBM.Lang], "check", Callbacks.Visible)
						Child:SetChecked(Settings.Visible)
						Child = Header:CreateOption(KBM.Language.Options.UnlockWidth[KBM.Lang], "check", Callbacks.Width)
						Child:SetChecked(Settings.ScaleWidth)
						Child = Header:CreateOption(KBM.Language.Options.UnlockHeight[KBM.Lang], "check", Callbacks.Height)
						Child:SetChecked(Settings.ScaleHeight)
						Child = Header:CreateOption(KBM.Language.Options.UnlockText[KBM.Lang], "check", Callbacks.Text)
						Child:SetChecked(Settings.TextScale)
							
					else
						function Callbacks:Override(bool)
							self.Encounter.Boss.Mod.Settings.CastBar.Override = bool
							if bool then
								self.Encounter.Boss.CastBar.Settings = self.Encounter.Boss.Mod.Settings.CastBar
								KBM.CastBar.Anchor:Hide()
								self.Encounter.Boss.CastBar:Display()
							else
								self.Encounter.Boss.CastBar.Settings = KBM.CastBar.Settings
								self.Encounter.Boss.CastBar:Hide()
								KBM.CastBar.Anchor:Display()
							end
						end
						function Callbacks:Enabled(bool)
							self.Header.Encounter.Boss.Mod.Settings.CastBar.Enabled = bool
							if bool then
								self.Header.Encounter.Boss.CastBar:Display()
							else
								self.Header.Encounter.Boss.CastBar:Hide()
							end
						end
						function Callbacks:Pinned(bool)
							self.Header.Boss.Settings.CastBar.Pinned = bool
							self.Header.Boss.CastBar:Hide()
							self.Header.Boss.CastBar:Display()
						end
						function Callbacks:Visible(bool)
							self.Header.Encounter.Boss.Mod.Settings.CastBar.Visible = bool
							self.Header.Encounter.Boss.Mod.Settings.CastBar.Unlocked = bool
							if bool then
								self.Header.Encounter.Boss.CastBar:Display()
							else
								self.Header.Encounter.Boss.CastBar:Hide()
							end
						end
						function Callbacks:Width(bool)
							self.Header.Encounter.Boss.Mod.Settings.CastBar.ScaleWidth = bool
						end
						function Callbacks:Height(bool)
							self.Header.Encounter.Boss.Mod.Settings.CastBar.ScaleHeight = bool
						end
						function Callbacks:Text(bool)
							self.Header.Encounter.Boss.Mod.Settings.CastBar.TextScale = bool
						end
						
						local Settings = BossObj.Mod.Settings.CastBar
						Header = self:CreateHeader(KBM.Language.Options.CastbarOverride[KBM.Lang], "check", "Castbars", "Main")
						Header:SetChecked(Settings.Override)
						Header:SetHook(Callbacks.Override)
						Header.Boss = BossObj
						Child = Header:CreateOption(KBM.Language.Options.Enabled[KBM.Lang], "check", Callbacks.Enabled)
						Child:SetChecked(Settings.Enabled)
						if BossObj.PinCastBar then
							Child = Header:CreateOption(BossObj.Settings.PinMenu, "check", Callbacks.Pinned)
							Child:SetChecked(Settings.Pinned)
						end
						Child = Header:CreateOption(KBM.Language.Options.ShowAnchor[KBM.Lang], "check", Callbacks.Visible)
						Child:SetChecked(Settings.Visible)
						Child = Header:CreateOption(KBM.Language.Options.UnlockWidth[KBM.Lang], "check", Callbacks.Width)
						Child:SetChecked(Settings.ScaleWidth)
						Child = Header:CreateOption(KBM.Language.Options.UnlockHeight[KBM.Lang], "check", Callbacks.Height)
						Child:SetChecked(Settings.ScaleHeight)
						Child = Header:CreateOption(KBM.Language.Options.UnlockText[KBM.Lang], "check", Callbacks.Text)
						Child:SetChecked(Settings.TextScale)
												
					end
					if BossObj.CastBar.HasFilters then
						function Callbacks:Enabled(bool)
							self.Encounter.Boss.Settings.Filters.Enabled = bool
						end

						local Settings = BossObj.Settings.Filters
						Header = self:CreateHeader("Enable "..MenuName.."'s filters.", "check", "Castbars", "Main")
						Header:SetChecked(Settings.Enabled)
						Header:SetHook(Callbacks.Enabled)
						Header.Boss = BossObj
						
						for FilterName, FilterData in pairs(BossObj.CastFilters) do
						
							local Callbacks = {}
							Callbacks.Option = self
							
							function Callbacks:Callback(bool)					
								self.Data.Enabled = bool
								self.Data.Settings.Enabled = bool
								self.Boss.Menu.Filters[self.Data.ID].ColorGUI:Enable(bool)
							end
							
							function Callbacks:Enabled(bool)
								self.Data.Enabled = bool
								self.Data.Settings.Enabled = bool
								self.Boss.Menu.Filters[self.Data.ID].ColorGUI:Enable(bool)
							end
							
							function Callbacks:Color(bool, Color)							
								if not Color then
									self.Data.Custom = bool
									self.Data.Settings.Custom = bool
									self.GUI:SetEnabled(bool)
								elseif Color then
									self.Manager.Data.Color = Color
									self.Manager.Data.Settings.Color = Color
									self.Manager.Color = Color
								end
							end
							
							Child = Header:CreateOption(FilterName, "excheck", Callbacks.Callback)
							Child.Data = FilterData
							Child:SetChecked(FilterData.Enabled)
							local SubHeader = Child:CreateHeader(FilterName, "plain")
							SubHeader.Boss = BossObj
							BossObj.Menu.Filters[FilterData.ID] = {}
							BossObj.Menu.Filters[FilterData.ID].Enabled = SubHeader:CreateOption(KBM.Language.Options.Enabled[KBM.Lang], "check", Callbacks.Enabled)
							BossObj.Menu.Filters[FilterData.ID].Enabled:SetChecked(FilterData.Settings.Enabled)
							BossObj.Menu.Filters[FilterData.ID].Enabled.Data = FilterData
							BossObj.Menu.Filters[FilterData.ID].Enabled.Controller = Child
							Child.Controller = BossObj.Menu.Filters[FilterData.ID].Enabled
							BossObj.Menu.Filters[FilterData.ID].ColorGUI = SubHeader:CreateOption(KBM.Language.Color.Custom[KBM.Lang], "color", Callbacks.Color)
							BossObj.Menu.Filters[FilterData.ID].ColorGUI:SetChecked(FilterData.Settings.Custom)
							BossObj.Menu.Filters[FilterData.ID].ColorGUI.Enabled = FilterData.Settings.Enabled
							BossObj.Menu.Filters[FilterData.ID].ColorGUI.Color = FilterData.Settings.Color
							BossObj.Menu.Filters[FilterData.ID].ColorGUI.Data = FilterData							
						end								
					end							
				end
				
				local Number = 0
				if self.Boss.Mod.Settings.CastBar then
					if self.Boss.Mod.Settings.CastBar.Multi then
						for BossName, BossObj in pairs(self.Boss.Mod.Bosses) do
							Number = Number + 1
							if BossObj.Settings then
								if BossObj.Settings.CastBar then
									self:CreateOptions(BossObj, Number)
								end
							end
						end
					else
						self:CreateOptions(self.Boss, 0)
					end
				end			
			end

			function Encounter:MechTimer()
				local Child = nil
				local Header = nil
				local Callbacks = {}
				Callbacks.Boss = self.Boss
			
				-- Mechanic Timer callbacks
				function Callbacks:Override(bool)
					self.Encounter.Boss.Mod.Settings.MechTimer.Override = bool
					if bool then
						KBM.MechTimer.Settings = self.Encounter.Boss.Mod.Settings.MechTimer
					else
						KBM.MechTimer.Settings = KBM.Options.MechTimer
					end
					KBM.MechTimer:ApplySettings()
				end
				
				function Callbacks:Enabled(bool)
					self.Header.Encounter.Boss.Mod.Settings.MechTimer.Enabled = bool
				end
				
				function Callbacks:Visible(bool)
					self.Header.Encounter.Boss.Mod.Settings.MechTimer.Visible = bool
					self.Header.Encounter.Boss.Mod.Settings.MechTimer.Unlocked = bool
					KBM.MechTimer.Anchor:SetVisible(bool)
					KBM.MechTimer.Anchor.Drag:SetVisible(bool)
				end
				
				function Callbacks:Width(bool)
					self.Header.Encounter.Boss.Mod.Settings.MechTimer.ScaleWidth = bool
				end
				
				function Callbacks:Height(bool)
					self.Header.Encounter.Boss.Mod.Settings.MechTimer.ScaleHeight = bool
				end
				
				function Callbacks:Text(bool)
					self.Header.Encounter.Boss.Mod.Settings.MechTimer.TextScale = bool
				end
			
				if self.Boss.Mod.Settings.MechTimer then
					local Settings = self.Boss.Mod.Settings.MechTimer
					Header = self:CreateHeader(KBM.Language.Options.MechTimerOverride[KBM.Lang], "check", "Timers", "Main")
					Header:SetChecked(Settings.Override)
					Header:SetHook(Callbacks.Override)
					Child = Header:CreateOption(KBM.Language.Options.Enabled[KBM.Lang], "check", Callbacks.Enabled)
					Child:SetChecked(Settings.Enabled)
					Child = Header:CreateOption(KBM.Language.Options.ShowAnchor[KBM.Lang], "check", Callbacks.Visible)
					Child:SetChecked(Settings.Visible)
					Child = Header:CreateOption(KBM.Language.Options.UnlockWidth[KBM.Lang], "check", Callbacks.Width)
					Child:SetChecked(Settings.ScaleWidth)
					Child = Header:CreateOption(KBM.Language.Options.UnlockHeight[KBM.Lang], "check", Callbacks.Height)
					Child:SetChecked(Settings.ScaleHeight)
					Child = Header:CreateOption(KBM.Language.Options.UnlockText[KBM.Lang], "check", Callbacks.Text)
					Child:SetChecked(Settings.TextScale)
				end
				
				function self:CreateOptions(BossObj)
				
					BossObj.Menu = {}
					BossObj.Menu.Timers = {}

					local Callbacks = {}
					local MenuName = ""
					if BossObj.NameShort then
						MenuName = BossObj.NameShort
					else
						MenuName = BossObj.Name
					end
					
					function Callbacks:Enabled(bool)
						self.Boss.Settings.TimersRef.Enabled = bool
						self.Boss:SetTimers(bool)
					end
										
					if BossObj.TimersRef then					
						Header = self:CreateHeader(KBM.Language.Options.TimersEnabled[KBM.Lang].." ("..MenuName..")", "check", "Timers", "Main")
						Header:SetChecked(BossObj.Settings.TimersRef.Enabled)
						Header:SetHook(Callbacks.Enabled)
						Header.Boss = BossObj
						
						for TimerID, TimerData in pairs(BossObj.TimersRef) do
							if TimerData.HasMenu then
								local Callbacks = {}
								Callbacks.Option = self
								
								function Callbacks:Callback(bool)
									self.Data.Enabled = bool
									self.Data.Settings.Enabled = bool
									self.Boss.Menu.Timers[self.Data.Settings.ID].ColorGUI:Enable(bool)
									if not bool then
										KBM.MechTimer:AddRemove(self.Data)
									end
								end
								
								function Callbacks:Enabled(bool)
									self.Data.Enabled = bool
									self.Data.Settings.Enabled = bool
									self.Boss.Menu.Timers[self.Data.Settings.ID].ColorGUI:Enable(bool)
									if not bool then
										KBM.MechTimer:AddRemove(self.Data)
									end
								end
								
								function Callbacks:Color(bool, Color)							
									if not Color then
										self.Data.Settings.Custom = bool
										self.GUI:SetEnabled(bool)
									elseif Color then
										self.Manager.Data.Settings.Color = Color
										self.Manager.Color = Color
									end								
								end
							
								MenuName = TimerData.Name
								if TimerData.MenuName then
									MenuName = TimerData.MenuName
								end
							
								Child = Header:CreateOption(MenuName, "excheck", Callbacks.Callback)
								Child.Data = TimerData
								Child:SetChecked(TimerData.Settings.Enabled)							
								local SubHeader = Child:CreateHeader(MenuName, "plain")
								SubHeader.Boss = BossObj
								BossObj.Menu.Timers[TimerID] = {}
								BossObj.Menu.Timers[TimerID].Enabled = SubHeader:CreateOption(KBM.Language.Options.Enabled[KBM.Lang], "check", Callbacks.Enabled)
								BossObj.Menu.Timers[TimerID].Enabled:SetChecked(TimerData.Settings.Enabled)
								BossObj.Menu.Timers[TimerID].Enabled.Data = TimerData
								BossObj.Menu.Timers[TimerID].Enabled.Controller = Child
								Child.Controller = BossObj.Menu.Timers[TimerID].Enabled
								BossObj.Menu.Timers[TimerID].ColorGUI = SubHeader:CreateOption(KBM.Language.Color.Custom[KBM.Lang], "color", Callbacks.Color)
								BossObj.Menu.Timers[TimerID].ColorGUI:SetChecked(TimerData.Settings.Custom)
								BossObj.Menu.Timers[TimerID].ColorGUI.Enabled = TimerData.Settings.Enabled
								BossObj.Menu.Timers[TimerID].ColorGUI.Color = TimerData.Settings.Color
								BossObj.Menu.Timers[TimerID].ColorGUI.Data = TimerData
							end
						end
					end
				end
				
				local TimerCreated = false
				for BossName, BossObj in pairs(self.Boss.Mod.Bosses) do
					if BossObj.TimersRef then
						self:CreateOptions(BossObj)
						TimerCreated = true
					end
				end							
				if not TimerCreated then
					self.Pages.Tabs.Timers.Enabled = false									
				end
			end		

			function Encounter:Alerts()
				local Child = nil
				local Header = nil
				local Callbacks = {}
				Callbacks.Boss = self.Boss
						
				-- Alert callbacks
				function Callbacks:Override(bool)
					self.Encounter.Boss.Mod.Settings.Alerts.Override = bool
					if bool then
						KBM.Alert.Settings = self.Encounter.Boss.Mod.Settings.Alerts
					else
						KBM.Alert.Settings = KBM.Options.Alerts
					end
					KBM.Alert:ApplySettings()
				end
				
				function Callbacks:Enabled(bool)
					self.Header.Encounter.Boss.Mod.Settings.Alerts.Enabled = bool
				end
				
				function Callbacks:Flash(bool)
					self.Header.Encounter.Boss.Mod.Settings.Alerts.Flash = bool
				end
				
				function Callbacks:Notify(bool)
					self.Header.Encounter.Boss.Mod.Settings.Alerts.Text = bool
				end
				
				function Callbacks:Visible(bool)
					self.Header.Encounter.Boss.Mod.Settings.Alerts.Visible = bool
					self.Header.Encounter.Boss.Mod.Settings.Alerts.Unlocked = bool
					KBM.Alert.Anchor:SetVisible(bool)
					KBM.Alert.Anchor.Drag:SetVisible(bool)
					KBM.Alert:ApplySettings()
				end
				
				function Callbacks:ScaleText(bool)
					self.Header.Encounter.Boss.Mod.Settings.Alerts.ScaleText = bool
				end
				
				function Callbacks:FlashUnlocked(bool)
					self.Header.Encounter.Boss.Mod.Settings.Alerts.FlashUnlocked = bool
					KBM.Alert:ApplySettings()
				end
							
				if self.Boss.Mod.Settings.Alerts then
					local Settings = self.Boss.Mod.Settings.Alerts
					Header = self:CreateHeader(KBM.Language.Options.AlertsOverride[KBM.Lang], "check", "Alerts", "Main")
					Header:SetChecked(Settings.Override)
					Header:SetHook(Callbacks.Override)
					Child = Header:CreateOption(KBM.Language.Options.Enabled[KBM.Lang], "check", Callbacks.Enabled)
					Child:SetChecked(Settings.Enabled)
					Child = Header:CreateOption(KBM.Language.Options.AlertFlash[KBM.Lang], "check", Callbacks.Flash)
					Child:SetChecked(Settings.Flash)
					Child = Header:CreateOption(KBM.Language.Options.AlertText[KBM.Lang], "check", Callbacks.Notify)
					Child:SetChecked(Settings.Notify)
					Child = Header:CreateOption(KBM.Language.Options.ShowAnchor[KBM.Lang], "check", Callbacks.Visible)
					Child:SetChecked(Settings.Visible)
					Child = Header:CreateOption(KBM.Language.Options.UnlockText[KBM.Lang], "check", Callbacks.ScaleText)
					Child:SetChecked(Settings.ScaleText)
					Child = Header:CreateOption(KBM.Language.Options.UnlockFlash[KBM.Lang], "check", Callbacks.FlashUnlocked)
					Child:SetChecked(Settings.FlashUnlocked)
				end
				
				function self:CreateOptions(BossObj)
				
					BossObj.Menu.Alerts = {}

					local Callbacks = {}
					local MenuName = ""
					if BossObj.NameShort then
						MenuName = BossObj.NameShort
					else
						MenuName = BossObj.Name
					end
		
					function Callbacks:Enabled(bool)
						self.Boss.Settings.AlertsRef.Enabled = bool
						self.Boss:SetAlerts(bool)
					end
		
					if BossObj.AlertsRef then
					
						Header = self:CreateHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang].." ("..MenuName..")", "check", "Alerts", "Main")
						Header:SetChecked(BossObj.Settings.AlertsRef.Enabled)
						Header:SetHook(Callbacks.Enabled)
						Header.Boss = BossObj
						
						for AlertID, AlertData in pairs(BossObj.AlertsRef) do
							if AlertData.HasMenu then
								local Callbacks = {}
								Callbacks.Option = self
								
								function Callbacks:Callback(bool)
									self.Data.Enabled = bool
									self.Data.Settings.Enabled = bool
									self.Boss.Menu.Alerts[self.Data.Settings.ID].Border:Enable(bool)
									self.Boss.Menu.Alerts[self.Data.Settings.ID].Notify:Enable(bool)
									self.Boss.Menu.Alerts[self.Data.Settings.ID].ColorGUI:Enable(bool)
								end
								
								function Callbacks:Enabled(bool)
									self.Data.Enabled = bool
									self.Data.Settings.Enabled = bool
									self.Boss.Menu.Alerts[self.Data.Settings.ID].Border:Enable(bool)
									self.Boss.Menu.Alerts[self.Data.Settings.ID].Notify:Enable(bool)
									self.Boss.Menu.Alerts[self.Data.Settings.ID].ColorGUI:Enable(bool)
								end
								
								function Callbacks:Border(bool)
									self.Data.Settings.Border = bool
								end
								
								function Callbacks:Notify(bool)
									self.Data.Settings.Notify = bool
								end
								
								function Callbacks:Sound(bool)
									self.Data.Settings.Sound = bool
								end
								
								function Callbacks:Color(bool, Color)							
									if not Color then
										self.Data.Settings.Custom = bool
										self.GUI:SetEnabled(bool)
									elseif Color then
										self.Manager.Data.Settings.Color = Color
										self.Manager.Color = Color
									end								
								end

								local MenuName = AlertData.Text
								if AlertData.MenuName then
									MenuName = AlertData.MenuName
								end
								
								Child = Header:CreateOption(MenuName, "excheck", Callbacks.Callback)
								Child.Data = AlertData
								Child:SetChecked(AlertData.Settings.Enabled)							
								local SubHeader = Child:CreateHeader(MenuName, "plain")
								SubHeader.Boss = BossObj
								BossObj.Menu.Alerts[AlertID] = {}
								BossObj.Menu.Alerts[AlertID].Enabled = SubHeader:CreateOption(KBM.Language.Options.Enabled[KBM.Lang], "check", Callbacks.Enabled)
								BossObj.Menu.Alerts[AlertID].Enabled:SetChecked(AlertData.Settings.Enabled)
								BossObj.Menu.Alerts[AlertID].Enabled.Data = AlertData
								BossObj.Menu.Alerts[AlertID].Enabled.Controller = Child
								BossObj.Menu.Alerts[AlertID].Border = SubHeader:CreateOption(KBM.Language.Options.Border[KBM.Lang], "check", Callbacks.Border)
								BossObj.Menu.Alerts[AlertID].Border:SetChecked(AlertData.Settings.Border)
								BossObj.Menu.Alerts[AlertID].Border.Data = AlertData
								BossObj.Menu.Alerts[AlertID].Border.Enabled = AlertData.Settings.Enabled
								BossObj.Menu.Alerts[AlertID].Notify = SubHeader:CreateOption(KBM.Language.Options.Notify[KBM.Lang], "check", Callbacks.Notify)
								BossObj.Menu.Alerts[AlertID].Notify:SetChecked(AlertData.Settings.Notify)
								BossObj.Menu.Alerts[AlertID].Notify.Data = AlertData
								BossObj.Menu.Alerts[AlertID].Notify.Enabled = AlertData.Settings.Enabled
								BossObj.Menu.Alerts[AlertID].Sound = SubHeader:CreateOption(KBM.Language.Options.Sound[KBM.Lang], "check", Callbacks.Sound)
								BossObj.Menu.Alerts[AlertID].Sound:SetChecked(AlertData.Settings.Sound)
								BossObj.Menu.Alerts[AlertID].Sound.Data = AlertData
								BossObj.Menu.Alerts[AlertID].Sound.Enabled = false
								Child.Controller = BossObj.Menu.Alerts[AlertID].Enabled
								BossObj.Menu.Alerts[AlertID].ColorGUI = SubHeader:CreateOption(KBM.Language.Color.Custom[KBM.Lang], "color", Callbacks.Color)
								BossObj.Menu.Alerts[AlertID].ColorGUI:SetChecked(AlertData.Settings.Custom)
								BossObj.Menu.Alerts[AlertID].ColorGUI.Enabled = AlertData.Settings.Enabled
								BossObj.Menu.Alerts[AlertID].ColorGUI.Color = AlertData.Settings.Color
								BossObj.Menu.Alerts[AlertID].ColorGUI.Data = AlertData
							end
						end
					end
				end
				
				local AlertCreated = false
				for BossName, BossObj in pairs(self.Boss.Mod.Bosses) do
					if BossObj.AlertsRef then
						self:CreateOptions(BossObj)
						AlertCreated = true
					end
				end								
				if not AlertCreated then
					self.Pages.Tabs.Alerts.Enabled = false
				end
			end		
			
			function Encounter:PhaseMon()			
				local Child = nil
				local Header = nil
				local Callbacks = {}
				Callbacks.Boss = self.Boss
				
				-- Phase Monitor Callbacks.
				function Callbacks:Override(bool)
					self.Encounter.Boss.Mod.Settings.PhaseMon.Override = bool
					if bool then
						KBM.PhaseMonitor.Settings = self.Encounter.Boss.Mod.Settings.PhaseMon
					else
						KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
					end
					KBM.PhaseMonitor:ApplySettings()				
				end
				
				function Callbacks:Enabled(bool)
					self.Header.Encounter.Boss.Mod.Settings.PhaseMon.Enabled = bool
				end
				
				function Callbacks:Visible(bool)
					self.Header.Encounter.Boss.Mod.Settings.PhaseMon.Visible = bool
					KBM.PhaseMonitor.Anchor:SetVisible(bool)
					self.Header.Encounter.Boss.Mod.Settings.PhaseMon.Unlocked = bool
					KBM.PhaseMonitor.Anchor.Drag:SetVisible(bool)
				end
				
				function Callbacks:Phase(bool)
					self.Header.Encounter.Boss.Mod.Settings.PhaseMon.PhaseDisplay = bool
				end
				
				function Callbacks:Objectives(bool)
					self.Header.Encounter.Boss.Mod.Settings.PhaseMon.Objectives = bool
				end
				
				function Callbacks:Width(bool)
					self.Header.Encounter.Boss.Mod.Settings.PhaseMon.ScaleWidth = bool
				end
				
				function Callbacks:Height(bool)
					self.Header.Encounter.Boss.Mod.Settings.PhaseMon.ScaleHeight = bool
				end
				
				function Callbacks:Text(bool)
					self.Header.Encounter.Boss.Mod.Settings.PhaseMon.TextScale = bool
				end
						
				if self.Boss.Mod.Settings.PhaseMon then
					local Settings = self.Boss.Mod.Settings.PhaseMon
					Header = self:CreateHeader(KBM.Language.Options.PhaseMonOverride[KBM.Lang], "check", "Encounter", "Main")
					Header:SetChecked(Settings.Override)
					Header:SetHook(Callbacks.Override)
					Child = Header:CreateOption(KBM.Language.Options.Enabled[KBM.Lang], "check", Callbacks.Enabled)
					Child:SetChecked(Settings.Enabled)
					Child = Header:CreateOption(KBM.Language.Options.ShowAnchor[KBM.Lang], "check", Callbacks.Visible)
					Child:SetChecked(Settings.Visible)
					Child = Header:CreateOption(KBM.Language.Options.UnlockWidth[KBM.Lang], "check", Callbacks.Width)
					Child:SetChecked(Settings.ScaleWidth)
					Child = Header:CreateOption(KBM.Language.Options.UnlockHeight[KBM.Lang], "check", Callbacks.Height)
					Child:SetChecked(Settings.ScaleHeight)
					Child = Header:CreateOption(KBM.Language.Options.UnlockText[KBM.Lang], "check", Callbacks.Text)
					Child:SetChecked(Settings.TextScale)
				end
			end
			
			function Encounter:EncTimer()			
				local Child = nil
				local Header = nil
				local Callbacks = {}
				Callbacks.Boss = self.Boss
			
				-- Encounter Timer callbacks
				function Callbacks:Override(bool)
					self.Encounter.Boss.Mod.Settings.EncTimer.Override = bool
					if bool then
						KBM.EncTimer.Settings = self.Encounter.Boss.Mod.Settings.EncTimer
					else
						KBM.EncTimer.Settings = KBM.Options.EncTimer
					end
					KBM.EncTimer:ApplySettings()
				end
				
				function Callbacks:Enabled(bool)
					self.Header.Encounter.Boss.Mod.Settings.EncTimer.Enabled = bool
				end
				
				function Callbacks:Visible(bool)
					self.Header.Encounter.Boss.Mod.Settings.EncTimer.Visible = bool
					self.Header.Encounter.Boss.Mod.Settings.EncTimer.Unlocked = bool
					KBM.EncTimer.Frame:SetVisible(bool)
					KBM.EncTimer.Enrage.Frame:SetVisible(bool)
					KBM.EncTimer.Frame.Drag:SetVisible(bool)
				end
				
				function Callbacks:Width(bool)
					self.Header.Encounter.Boss.Mod.Settings.EncTimer.ScaleWidth = bool
				end
				
				function Callbacks:Height(bool)
					self.Header.Encounter.Boss.Mod.Settings.EncTimer.ScaleHeight = bool
				end
				
				function Callbacks:Text(bool)
					self.Header.Encounter.Boss.Mod.Settings.EncTimer.TextScale = bool
				end
			
				if self.Boss.Mod.Settings.EncTimer then
					local Settings = self.Boss.Mod.Settings.EncTimer
					Header = self:CreateHeader(KBM.Language.Options.EncTimerOverride[KBM.Lang], "check", "Encounter", "Main")
					Header:SetChecked(Settings.Override)
					Header:SetHook(Callbacks.Override)
					Child = Header:CreateOption(KBM.Language.Options.Enabled[KBM.Lang], "check", Callbacks.Enabled)
					Child:SetChecked(Settings.Enabled)
					Child = Header:CreateOption(KBM.Language.Options.ShowAnchor[KBM.Lang], "check", Callbacks.Visible)
					Child:SetChecked(Settings.Visible)
					Child = Header:CreateOption(KBM.Language.Options.UnlockWidth[KBM.Lang], "check", Callbacks.Width)
					Child:SetChecked(Settings.ScaleWidth)
					Child = Header:CreateOption(KBM.Language.Options.UnlockHeight[KBM.Lang], "check", Callbacks.Height)
					Child:SetChecked(Settings.ScaleHeight)
					Child = Header:CreateOption(KBM.Language.Options.UnlockText[KBM.Lang], "check", Callbacks.Text)
					Child:SetChecked(Settings.TextScale)
				end
			end
			
			function Encounter:ApplyRecords()
				local Settings = self.Boss.Mod.Settings.Records
				if Settings.Best then
					if Settings.Best > 0 then
						self.Boss.Mod.MenuStore.Records.Best.Name = KBM.ConvertTime(Settings.Best)
						if Settings.Date then
							self.Boss.Mod.MenuStore.Records.Date.Name = Settings.Date
						end
					else
						self.Boss.Mod.MenuStore.Records.Best.Name = KBM.Language.Records.NoRecord[KBM.Lang]
					end
				else
					self.Boss.Mod.MenuStore.RecordsStore.Best.Name = KBM.Language.Records.NoRecord[KBM.Lang]
				end
				if Settings.Kills > Settings.Attempts then
					local Adjust = Settings.Kills - Settings.Attempts
					Settings.Attempts = Settings.Attempts + Adjust
				end
				if Settings.Wipes ~= (Settings.Attempts - Settings.Kills) then
					Settings.Kills = (Settings.Attempts - Settings.Wipes)
				end
				self.Boss.Mod.MenuStore.Records.Attempts.Name = KBM.Language.Records.Attempts[KBM.Lang]..Settings.Attempts
				self.Boss.Mod.MenuStore.Records.Kills.Name = KBM.Language.Records.Kills[KBM.Lang]..Settings.Kills
				self.Boss.Mod.MenuStore.Records.Wipes.Name = KBM.Language.Records.Wipes[KBM.Lang]..Settings.Wipes
				if Settings.Attempts > 0 then
					self.Boss.Mod.MenuStore.Records.Rate.Name = KBM.Language.Records.Rate[KBM.Lang]..string.format("%0.1f", (Settings.Kills/Settings.Attempts) * 100)
				else
					self.Boss.Mod.MenuStore.Records.Rate.Name = KBM.Language.Records.Rate[KBM.Lang].."n/a"
				end
			end
			
			function Encounter:Records()
				local Child = nil
				local Header = nil
				local Callbacks = {}
				Callbacks.Boss = self.Boss
				if not self.Boss.Mod.MenuStore then
					self.Boss.Mod.MenuStore = {}
				end
				self.Boss.Mod.MenuStore.Records = {}
				
				local Settings = self.Boss.Mod.Settings.Records
				Header = self:CreateHeader(KBM.Language.Records.Best[KBM.Lang], "plain", "Records", "Main")
				self.Boss.Mod.MenuStore.Records.Best = Header:CreateOption(KBM.ConvertTime(Settings.Best), "plain")
				self.Boss.Mod.MenuStore.Records.Date = Header:CreateOption(KBM.Language.Records.Date[KBM.Lang].."n/a", "plain")
				Header = self:CreateHeader(KBM.Language.Records.Details[KBM.Lang], "plain", "Records", "Main")
				self.Boss.Mod.MenuStore.Records.Attempts = Header:CreateOption(KBM.Language.Records.Attempts[KBM.Lang]..Settings.Attempts, "plain")
				self.Boss.Mod.MenuStore.Records.Kills = Header:CreateOption(KBM.Language.Records.Kills[KBM.Lang]..Settings.Kills, "plain")
				self.Boss.Mod.MenuStore.Records.Wipes = Header:CreateOption(KBM.Language.Records.Wipes[KBM.Lang]..Settings.Wipes, "plain")
				self.Boss.Mod.MenuStore.Records.Rate = Header:CreateOption(KBM.Language.Records.Rate[KBM.Lang].."n/a", "plain")
				self:ApplyRecords()
			end
			
			-- Initialize Encounter Tab
			if Boss.Mod.Custom then
				if Boss.Mod.Custom.Encounter then
					Boss.Mod.Custom.Encounter.Menu(Encounter)
				end
			end
			Encounter:EncTimer()
			Encounter:PhaseMon()
			
			-- Initialize Timers Tab
			Encounter:MechTimer()
			
			-- Initialize Alerts Tab
			Encounter:Alerts()
			
			-- Initialize Castbars Tab
			if Encounter.Boss.Mod.Settings.CastBar then
				Encounter:CastBar()
			else
				Encounter.Pages.Tabs.Castbars.Enabled = false
			end
			
			-- Initialize Records Tab
			Encounter:Records()
			
			KBM.MainWin:AddSize(Encounter.GUI.Frame, Instance.Tab)
			self:AddChildSize(Encounter.GUI.Frame)
		end
		return Instance		
	end
	
	function KBM.MainWin.Menu:CreateEncounter(Text, Link, Default, Header)
		Child = UI.CreateFrame("Frame", "Encounter_Header", Header)
		Child:SetPoint("LEFT", Header.Check, "RIGHT", -4, nil)
		Child:SetPoint("RIGHT", Header, "RIGHT")
		Child.Enabled = true
		Child.Check = UI.CreateFrame("RiftCheckbox", "Encounter_Check", Child)
		Child.Check:SetPoint("CENTERLEFT", Child, "CENTERLEFT", 4, 0)
		Child.Type = "child"
		if Default == nil then
			Child.Check:SetChecked(false)
			Child.Check:SetEnabled(false)
			Child.Check:SetVisible(false)
		else
			Child.Check:SetChecked(Default)
		end
		Child.Check.Child = Child
		Child.TextShadow = UI.CreateFrame("Text", "Encounter_Text_Shadow", Child)
		Child.TextShadow:SetWidth(Child:GetWidth() - Child.Check:GetWidth())
		Child.TextShadow:SetText(Text)
		Child.TextShadow:SetFontSize(13)
		Child.TextShadow:SetFontColor(0,0,0,0.9)
		Child.TextShadow:SetLayer(1)
		Child.Text = UI.CreateFrame("Text", "Encounter_Text", Child)
		Child.Text:SetWidth(Child:GetWidth() - Child.Check:GetWidth())
		Child.Text:SetText(Text)
		Child.Text:SetFontSize(13)
		Child.Text:SetFontColor(1,1,1)
		Child.Text:SetLayer(2)
		Child:SetHeight(Child.Text:GetHeight())
		Child.TextShadow:SetPoint("CENTERLEFT", Child.Check, "CENTERRIGHT",1 ,1)
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
		function Child:SetHook(Hook)
			self.Check.Hook = Hook
		end
		function Child:SetEnabled(bool)
			self.Check:SetEnabled(bool)
			self.Enabled = bool
			if bool then
				self.Text:SetFontColor(1,1,1)
			else
				self.Text:SetFontColor(0.5,0.5,0.5)
			end
			self:SetBackgroundColor(0,0,0,0)
		end
		function Child.Event:MouseIn()
			if self.Enabled and not (KBM.MainWin.Scroller.Main.Grabbed or KBM.MainWin.Scroller.Instance.Grabbed) then
				self:SetBackgroundColor(0,0,0,0.5)
			end
		end
		function Child.Event:MouseOut()
			if self.Enabled then
				self:SetBackgroundColor(0,0,0,0)
			end
		end
		function Child.Check.Event:CheckboxChange()
			if self.Child.Enabled then
				if self.Hook then
					self:Hook(self:GetChecked())
				end
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
			if KBM.MainWin.CurrentPage then
				if KBM.MainWin.CurrentPage.Type == "encounter" then
				
				else
					if KBM.MainWin.CurrentPage.Link.Close then
						KBM.MainWin.CurrentPage.Link:Close()
					end
				end
			end
			for _, Item in ipairs(self.List) do
				Item:Remove()
				Item = nil
			end
			self.List = {}
		end
		function Child.Options:SetTitle()
			KBM.MainWin.CurrentPage = self
			KBM.MainWin.Options.HeadShadow:SetText(self.Child.Header.Text:GetText())
			KBM.MainWin.Options.HeadText:SetText(self.Child.Header.Text:GetText())
			KBM.MainWin.Options.SubShadow:SetText(self.Child.Text:GetText())
			KBM.MainWin.Options.SubText:SetText(self.Child.Text:GetText())
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
			HeaderObj.Loaded = false
			HeaderObj.GUI:SetText(Text)
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
					if self.Header.Loaded then
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
			end
			HeaderObj.GUI.Text:SetPoint("CENTERLEFT", HeaderObj.GUI.Check, "CENTERRIGHT")
			HeaderObj.GUI.Frame:SetWidth(HeaderObj.GUI.Text:GetWidth()+HeaderObj.GUI.Check:GetWidth())
			HeaderObj.GUI.Frame:SetHeight(HeaderObj.GUI.Text:GetHeight())
			KBM.MainWin.Options:AddSize(HeaderObj.GUI.Frame)
			HeaderObj.Children = {}
			HeaderObj.LastChild = HeaderObj
			self.LastItem = HeaderObj
			function HeaderObj.GUI.Frame.Event:LeftClick()
				if self.Header.Loaded then
					if self.Header.GUI.Check:GetEnabled() then
						if self.Header.GUI.Check:GetChecked() then
							self.Header.GUI.Check:SetChecked(false)
						else
							self.Header.GUI.Check:SetChecked(true)
						end
					end
				end
			end
			table.insert(self.List, HeaderObj)
			function HeaderObj:AddCheck(Text, Callback, Default, Slider)
				local CheckObj = {}
				CheckObj.GUI = KBM.MainWin:PullChild()
				CheckObj.GUI:SetText(Text)
				CheckObj.Loaded = false
				CheckObj.GUI.Frame.Base = CheckObj
				CheckObj.GUI.Check.Base = CheckObj
				if self.LastChild == self then
					CheckObj.GUI.Frame:SetPoint("LEFT", self.GUI.Check, "RIGHT")
					CheckObj.GUI.Frame:SetPoint("TOP", self.GUI.Frame, "BOTTOM")
				else
					CheckObj.GUI.Frame:SetPoint("TOPLEFT", self.LastChild.GUI.Frame, "BOTTOMLEFT")
				end
				CheckObj.GUI.Check.Callback = Callback
				CheckObj.GUI.Frame:SetWidth(CheckObj.GUI.Text:GetWidth()+CheckObj.GUI.Check:GetWidth())
				CheckObj.GUI.Frame:SetHeight(CheckObj.GUI.Text:GetHeight())
				table.insert(self.Children, CheckObj)
				function CheckObj.GUI.Check.Event:CheckboxChange()
					if self.Base.Loaded then
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
				end
				function CheckObj.GUI.Frame.Event:LeftClick()
					if self.Base.Loaded then
						if self.Base.GUI.Check:GetEnabled() then
							if self.Base.GUI.Check:GetChecked() then
								self.Base.GUI.Check:SetChecked(false)
							else
								self.Base.GUI.Check:SetChecked(true)
							end
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
				CheckObj.Loaded = true
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
			HeaderObj.Loaded = true
			return HeaderObj
		end
		function Child.Options:AddCheck(Text)
		end
		function Child.Options:ClearPage()
		
		end
		Header.LastChild = Child
		KBM.MainWin:AddSize(Child, Header.Tab)
		Header:AddChildSize(Child)
		return Child
	end
			
end