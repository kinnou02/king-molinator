-- KBM Menu System: Objects
-- Written by Paul Snart
-- Copyright 2013
--
local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local Menu = KBM.Menu
local RenderQueue = LibSata:Create()

Menu.UI = {
	Store = {
		Check = LibSata:Create(),
		Group = LibSata:Create(),
		Header = LibSata:Create(),
		PlainHeader = LibSata:Create(),
		Color = LibSata:Create(),
	},
}
Menu.Object = {}
Menu.Renderer = nil
Menu.Queue = {}

local DumpParent = UI.CreateFrame("Frame", "UI DumpFrame", KBM.Context)

function Menu.UI.SetDefaults(Object, Name, Settings, ID, Callback, Page)
	Object.UI = {}
	Object.Object = LibSata:Create()
	Object.Callback = Callback
	Object.Settings = Settings
	Object.ID = ID
	Object.Page = Page
	Object.Rendered = LibSata:Create()
	Object.Name = tostring(Name)
	Object._root = Page._root
	Object.ChildState = true
	Object.Enabled = true
	Page.Object:Add(Object)
	
	function Object:CreateCheck(Name, Settings, ID, Callback)
		return Menu.Object:CreateCheck(Name, Settings, ID, Callback, self)
	end
	function Object:CreateHeader(Name, Settings, ID, Callback)
		return Menu.Object:CreateHeader(Name, Settings, ID, Callback, self)
	end
	function Object:CreateGroup(Name, Settings, ID, Callback)
		return Menu.Object:CreateGroup(Name, Settings, ID, Callback, self)
	end
	function Object:CreateColorPicker(Name, Settings, ID, Callback)
		return Menu.Object:CreateColorPicker(Name, Settings, ID, Callback, self)
	end
	function Object:CreatePlainHeader(Name, Settings, ID, Callback)
		return Menu.Object:CreatePlainHeader(Name, Settings, ID, Callback, self)
	end
	function Object:Queue()
		RenderQueue:Add(self)
		for _, SubObject in LibSata.EachIn(self.Object) do
			SubObject:Queue()
		end
	end
	
	function Object:Clear()
		for _, SubObject in LibSata.EachIn(self.Object) do
			SubObject:Clear()
		end
		self.Object = self.Object:Delete()
		self.Rendered = self.Rendered:Delete()
		for ID, Table in pairs(self) do
			self[ID] = nil
		end
	end

	function Object:DisableChildren(Children)
		if Children then
			self.ChildState = false
			for tObj, Object in LibSata.EachIn(self.Object) do
				if Object.Active then
					Object:Disable()
				end
			end
		else
			for tObj, Object in LibSata.EachIn(self.Object) do
				if Object.Active then
					Object:Disable()
				end
			end			
		end
	end
	
	function Object:Disable(Children)
		if not Children then
			self.Enabled = false
			self.UI.Check:SetEnabled(false)
			self.UI.Cradle:SetAlpha(0.5)
		end
		if Children ~= false then
			self:DisableChildren(Children)
		end
	end
	
	function Object:EnableChildren(Children)
		if Children then
			self.ChildState = true
			for tObj, Object in LibSata.EachIn(self.Object) do
				if Object.Active then
					Object:Enable()
				end
			end				
		else
			for tObj, Object in LibSata.EachIn(self.Object) do
				if Object.Active then
					if self.ChildState then
						Object:Enable()
					else
						Object:Disable()
					end
				end
			end
		end
	end
			
	function Object:Enable(Children)
		if not Children then
			self.Enabled = true
			self.UI.Check:SetEnabled(true)
			self.UI.Cradle:SetAlpha(1)
		end
		if Children ~= false then
			self:EnableChildren(Children)
		end
	end
	
	function Object:AddHeight()
		self.Height = self.UI.Cradle:GetHeight()
		self._root.Height = self._root.Height + self.Height
	end
	
	if Page._root.Type == "Encounter" then
		RenderQueue:Add(Object)
	end	
end

function Menu.Object:CreateCheck(Name, Settings, ID, Callback, Page)
	CheckObj = {}
	Menu.UI.SetDefaults(CheckObj, Name, Settings, ID, Callback, Page)
	CheckObj.Type = "Check"
	
	function CheckObj:Render()
		--print("CH: Rendering: "..self.Name)
		self.UI = Menu.UI.Store.Check:RemoveLast()
		if not self.UI then
			self.UI = {}
			self.UI.Cradle = LibSGui.Frame:Create(self._root.UI.Content, true)
			self.UI.Text = LibSGui.ShadowText:Create(self.UI.Cradle, true)
			self.UI.Check = UI.CreateFrame("RiftCheckbox", "UI.Check.Check", self.UI.Cradle)
			self.UI.Check:SetPoint("CENTERY", self.UI.Cradle, "CENTERY")
			self.UI.Check:SetPoint("LEFT", self.UI.Cradle, "LEFT")
			self.UI.Text:SetPoint("CENTERY", self.UI.Cradle, "CENTERY")
			self.UI.Text:SetPoint("LEFT", self.UI.Check, "RIGHT")
			self.UI.Text:SetFontSize(13)
			self.UI.Text:SetFontColor(0.95, 0.95, 0.75)
		else
			self.UI.Cradle:SetParent(self._root.UI.Content)
			self.UI.Cradle:SetVisible(true)
		end
		self.UI.Cradle:SetBackgroundColor(0,0,0,0)
		
		if self.PageLink then
			self.UI.Cradle:SetPoint("RIGHT", self._root.UI.Cradle, "RIGHT")
			self.UI.Cradle:SetPoint("LEFT", self._root.UI.Cradle, "LEFT")
			self.UI.Text:SetPoint("RIGHT", self._root.UI.Cradle, "RIGHT")
		else
			self.UI.Cradle:ClearPoint("RIGHT")
			self.UI.Text:ClearPoint("RIGHT")
		end		
						
		self.UI.Cradle:SetHeight(20)
		
		self.UI.Text._object = self
		self.UI.Check._object = self
		self.UI.Cradle._object = self
		
		self.Page:LinkY(self.UI.Cradle)
		self.Page:LinkX(self.UI.Check)
	
		if self.Callback then
			self.UI.Check:SetVisible(true)
			if self.Settings then
				self.UI.Check:SetChecked(self.Settings[ID])
			else
				self.UI.Check:SetChecked(false)
			end
			function self:Checkbox_Handler()
				self._object.Callback[ID](self._object._root, self:GetChecked())
			end
			self.UI.Check:EventAttach(Event.UI.Checkbox.Change, self.Checkbox_Handler, self.ID..": checkbox callback handler")
			function self:MouseIn_Handler()
				if self.Enabled then
					self.UI.Cradle:SetBackgroundColor(0,0,0,0.4)
				end
			end
			function self:MouseOut_Handler()
				if self.Enabled then
					if self._root.Selected == self then
						self.UI.Cradle:SetBackgroundColor(0.4,0.3,0.1,0.4)
					else
						self.UI.Cradle:SetBackgroundColor(0,0,0,0)
					end
				end
			end
			function self:TextClick_Handler()
				if self.Enabled then
					if self.UI.Check:GetChecked() then
						self.UI.Check:SetChecked(false)
					else
						self.UI.Check:SetChecked(true)
					end
				end
			end
			function self:TextClick_Select()
				if self.Enabled then
					if self._root.Selected ~= self then
						if self._root.Selected then
							self._root.Selected.UI.Cradle:SetBackgroundColor(0,0,0,0)
						end
						self.PageLink._root:Remove()
						self._root.Selected = self
						self.Callback.Select(self._root)
					else
						if self.Settings then
							if self.UI.Check:GetChecked() then
								self.UI.Check:SetChecked(false)
							else
								self.UI.Check:SetChecked(true)
							end
						else
							self.Callback[ID](self.Page)
						end
					end
				end
			end
			if self.PageLink then
				self.UI.Text:EventAttach(Event.UI.Input.Mouse.Cursor.In, function() self:MouseIn_Handler() end, self.ID..": mouse in handler")
				self.UI.Text:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function () self:MouseOut_Handler() end, self.ID..": mouse out handler")
				self.UI.Text:EventAttach(Event.UI.Input.Mouse.Left.Click, function() self:TextClick_Select() end, "text click handler")
			else
				self.UI.Text:EventAttach(Event.UI.Input.Mouse.Left.Click, function() self:TextClick_Handler() end, "text click handler")
			end
		else
			self.UI.Check:SetVisible(false)
			self.UI.Check:SetChecked(false)
		end
		
		-- Adjust States
		if not self.Page.ChildState or not self.Page.Enabled then
			self:Disable()
		else
			if self.Enabled then
				self:Enable()
			else
				self:Disable()
			end
		end
		
		self.UI.Text:SetText(self.Name)
		self.Page.LastObject = self
		self.Page.Rendered:InsertFirst(self)
		self.Active = true
		self:AddHeight()
	end
	
	function CheckObj:SetPage(Page)
		self.PageLink = Page
	end
	
	function CheckObj:Update(Text)
		self.UI.Text:SetText(tostring(Text))
	end
	
	function CheckObj:Remove()	
		-- Remove Events
		self.UI.Check:EventDetach(Event.UI.Checkbox.Change, self.Checkbox_Handler, self.ID..": checkbox callback handler")
		self.UI.Text:EventDetach(Event.UI.Input.Mouse.Cursor.In, nil, self.ID..": mouse in handler")
		self.UI.Text:EventDetach(Event.UI.Input.Mouse.Cursor.Out, nil, self.ID..": mouse out handler")
		self.UI.Text:EventDetach(Event.UI.Input.Mouse.Left.Click, nil, "text click handler")
		self.UI.Text._object = nil
		self.UI.Check._object = nil
		self.ChildState = true
		self:Enable(false)
		
		-- Clear up UI
		for _, RemoveObj in LibSata.EachIn(self.Rendered) do
			RemoveObj:Remove()
		end
		self.UI.Text:SetText()
		self.UI.Cradle:ClearAll()
		self.UI.Cradle:SetVisible(false)
		self.UI.Cradle:SetParent(DumpParent)
		Menu.UI.Store.Check:Add(self.UI)
		self.Rendered:Clear()
		self.LastObject = nil
		self.UI = nil
		self.Active = false
	end
	
	function CheckObj:LinkY(Object, Spacer)
		if self.LastObject then
			self.LastObject:LinkY(Object, Spacer)
		else
			Spacer = Spacer or 0
			if Spacer then
				self._root:Pad(Spacer)
				Object:SetPoint("TOP", self.UI.Cradle, "BOTTOM", nil, Spacer)
			else
				Object:SetPoint("TOP", self.UI.Cradle, "BOTTOM")
			end
		end
	end
		
	function CheckObj:LinkX(Object)
		Object:SetPoint("LEFT", self.UI.Check, "RIGHT")			
	end
	
	return CheckObj
end

function Menu.Object:CreatePlainHeader(Name, Settings, ID, Callback, Page)
	PlainHObj = {}
	Menu.UI.SetDefaults(PlainHObj, Name, Settings, ID, Callback, Page)
	PlainHObj.Type = "Plain"
	
	function PlainHObj:Render()
		self.UI = Menu.UI.Store.PlainHeader:RemoveLast()
		if not self.UI then
			self.UI = {}
			self.UI.Text = LibSGui.ShadowText:Create(self._root.UI.Content, true)
			self.UI.Text:SetFontSize(16)
			self.UI.Text:SetFontColor(0.9, 0.8, 0.4)
			self.UI.Text:SetWordwrap(true)
			self.UI.Text:SetPoint("RIGHT", self._root.UI.Cradle, "RIGHT")
		else
			self.UI.Text:SetParent(self._root.UI.Content)
			self.UI.Text:SetVisible(true)
		end
										
		self.UI.Text._object = self
		
		self.Page:LinkY(self.UI.Text)
		self.Page:LinkX(self.UI.Text)
		
		-- Adjust States
		if not self.Page.ChildState or not self.Page.Enabled then
			self:Disable()
		else
			self:Enable()
		end
		
		self.UI.Text:SetText(self.Name)
		self.Page.LastObject = self
		self.Page.Rendered:InsertFirst(self)
		self.Active = true
		self:AddHeight()
	end
		
	function PlainHObj:Update(Text)
		self.UI.Text:SetText(tostring(Text))
	end
	
	function PlainHObj:Disable(Children)
		if not Children then
			self.Enabled = false
			self.UI.Text:SetAlpha(0.5)
		end
		if Children ~= false then
			self:DisableChildren(Children)
		end
	end
		
	function PlainHObj:Enable(Children)
		if not Children then
			self.Enabled = true
			self.UI.Text:SetAlpha(1)
		end
		if Children ~= false then
			self:EnableChildren(Children)
		end	
	end
	
	function PlainHObj:Remove()	
		-- Remove Events
		self.UI.Text._object = nil
		self.ChildState = true
		self:Enable(false)
		
		-- Clear up UI
		for _, RemoveObj in LibSata.EachIn(self.Rendered) do
			RemoveObj:Remove()
		end
		self.UI.Text:SetText()
		self.UI.Text:SetParent(DumpParent)
		Menu.UI.Store.PlainHeader:Add(self.UI)
		self.Rendered:Clear()
		self.LastObject = nil
		self.UI = nil
		self.Active = false
	end

	function PlainHObj:LinkY(Object, Spacer)
		if self.LastObject then
			self.LastObject:LinkY(Object, Spacer)
		else
			if Spacer then
				self._root:Pad(Spacer)
				Object:SetPoint("TOP", self.UI.Text._cradle, "BOTTOM", nil, 2+Spacer)
			else
				Object:SetPoint("TOP", self.UI.Text._cradle, "BOTTOM", nil, 2)
			end
		end
	end

	function PlainHObj:AddHeight()
		self.Height = self.UI.Text:GetHeight() + 2
		self._root.Height = self._root.Height + self.Height
	end
	
	function PlainHObj:LinkX(Object)
		Object:SetPoint("LEFT", self.UI.Text._cradle, "LEFT")			
	end
	
	return PlainHObj
end

function Menu.Object:CreateHeader(Name, Settings, ID, Callback, Page)
	HeaderObj = {}
	Menu.UI.SetDefaults(HeaderObj, Name, Settings, ID, Callback, Page)
	HeaderObj.Type = "Header"
	
	function HeaderObj:Render()
		--print("HD: Rendering: "..self.Name)
		self.UI = Menu.UI.Store.Header:RemoveLast()
		if not self.UI then
			self.UI = {}
			self.UI.Cradle = LibSGui.Frame:Create(self._root.UI.Content, true)
			self.UI.Text = LibSGui.ShadowText:Create(self.UI.Cradle, true)
			self.UI.Check = UI.CreateFrame("RiftCheckbox", "UI.Header.Check", self.UI.Cradle)
			self.UI.Check:SetPoint("CENTERY", self.UI.Cradle, "CENTERY")
			self.UI.Check:SetPoint("LEFT", self.UI.Cradle, "LEFT")
			self.UI.Text:SetPoint("CENTERY", self.UI.Cradle, "CENTERY")
			self.UI.Text:SetPoint("LEFT", self.UI.Check, "RIGHT")
			self.UI.Text:SetFontSize(16)
			self.UI.Text:SetFontColor(0.9, 0.8, 0.4)
		else
			self.UI.Cradle:SetParent(self._root.UI.Content)
			self.UI.Cradle:SetVisible(true)
		end		
		self.UI.Cradle:SetHeight(23)
		
		self.UI.Text._object = self
		self.UI.Check._object = self
		self.UI.Cradle._object = self
		
		self.Page:LinkY(self.UI.Cradle)
		self.Page:LinkX(self.UI.Check)
		
		self.UI.Text:SetText(self.Name)
		
		if self.Callback then
			if self.Settings then
				self.UI.Check:SetVisible(true)
				self.UI.Check:SetChecked(self.Settings[ID])
				function self:Checkbox_Handler()
					local state = self:GetChecked()
					self._object.Callback[ID](self._object._root, state)
					if not state then
						self._object:Disable(true)
					else
						self._object:Enable(true)
					end
				end
				self.UI.Check:EventAttach(Event.UI.Checkbox.Change, self.Checkbox_Handler, self.ID..": checkbox callback handler")
				self.ChildState = self.Settings[ID]			
			else
				self.UI.Check:SetVisible(false)
				self.UI.Check:SetChecked(false)
			end
			
			-- Adjust States
			if not self.Page.ChildState then
				self:Disable()
			elseif not self.ChildState then
				self:Disable(true)
				self:Enable(false)
			else
				self:Enable()
			end
			
			function self:TextClick_Handler()
				if self.Enabled then
					if self.Settings then
						if self.UI.Check:GetChecked() then
							self.UI.Check:SetChecked(false)
						else
							self.UI.Check:SetChecked(true)
						end
					else
						self.Callback[ID](self.Page)
					end
				end
			end
			self.UI.Text:EventAttach(Event.UI.Input.Mouse.Left.Click, function() self:TextClick_Handler() end, self.ID..": text click handler")
		else
			self.UI.Check:SetVisible(false)
			self.UI.Check:SetChecked(false)
		end
		self.Page.LastObject = self
		self.Page.Rendered:InsertFirst(self)
		self:AddHeight()
		self.Active = true
	end
	
	function HeaderObj:Update(Text)
		self.UI.Text:SetText(tostring(Text))
	end
	
	function HeaderObj:Remove()
		-- Remove Events
		self.UI.Text:EventDetach(Event.UI.Input.Mouse.Left.Click, nil, self.ID..": text click handler")
		self.UI.Check:EventDetach(Event.UI.Checkbox.Change, self.Checkbox_Handler, self.ID..": checkbox callback handler")
		self.UI.Text._object = nil
		self.UI.Check._object = nil
		self.UI.Cradle._object = nil
		self.ChildState = true
		self:Enable(false)
		
		-- Clear up UI
		for _, RemoveObj in LibSata.EachIn(self.Rendered) do
			RemoveObj:Remove()
		end
		self.UI.Text:SetText()
		self.UI.Cradle:ClearAll()
		self.UI.Cradle:SetParent(DumpParent)
		self.UI.Cradle:SetVisible(false)
		Menu.UI.Store.Header:Add(self.UI)
		self.Rendered:Clear()
		self.LastObject = nil
		self.UI = nil
		self.Active = false
	end

	function HeaderObj:LinkY(Object, Spacer)
		if self.LastObject then
			self.LastObject:LinkY(Object, Spacer)
		else
			Object:SetPoint("TOP", self.UI.Cradle, "BOTTOM")
		end
	end
		
	function HeaderObj:LinkX(Object)
		Object:SetPoint("LEFT", self.UI.Check, "RIGHT")			
	end
		
	return HeaderObj
end

function Menu.Object:CreateColorPicker(Name, Settings, ID, Callback, Page)
	ColorObj = {}
	Menu.UI.SetDefaults(ColorObj, Name, Settings, ID, Callback, Page)
	ColorObj.Type = "Color"
	
	function ColorObj:SetEnabled(bool)
		for ColorID, ColorObj in pairs(self.UI.ColorObj) do
			if bool then
				ColorObj.Cradle:SetAlpha(1)
				ColorObj.Check:SetEnabled(true)
			else
				ColorObj.Cradle:SetAlpha(0.5)
				ColorObj.Check:SetEnabled(false)
			end
		end
		if bool then
			if self.Color then
				self.UI.ColorObj[self.Color].Check:SetEnabled(false)
			end
		end
	end
	
	function ColorObj:Render()
		self.UI = Menu.UI.Store.Color:RemoveLast()
		self.Color = self.Settings.Color
		if not self.UI then
			self.UI = {}
			self.UI.Cradle = UI.CreateFrame("Frame", "Options_Page_Child_Color", self._root.UI.Content)
			self.UI.Cradle:SetHeight((KBM.Colors.Count + 1) * 34)
			self.UI.Cradle:SetPoint("RIGHT", self._root.UI.Cradle, "RIGHT", -4, nil)
			self.UI.Check = UI.CreateFrame("RiftCheckbox", "Options_Page_Color_Check", self.UI.Cradle)
			self.UI.Check:SetPoint("TOPLEFT", self.UI.Cradle, "TOPLEFT", 0, 2)
			self.UI.Check:SetLayer(2)
			self.UI.Text = LibSGui.ShadowText:Create(self.UI.Cradle, true)
			self.UI.Text:SetFontSize(13)
			self.UI.Text:SetFontColor(0.95, 0.95, 0.75)
			self.UI.Text:SetLayer(1)
			self.UI.Text:SetPoint("CENTERLEFT", self.UI.Check, "CENTERRIGHT")
						
			self.UI.ColorObj = {}
						
			local Last = self.UI.Text._cradle		
			for ColorID, ColorData in pairs(KBM.Colors.List) do
				self.UI.ColorObj[ColorID] = {}
				local sColorObj = self.UI.ColorObj[ColorID]
				sColorObj.Cradle = UI.CreateFrame("Frame", "ColorObj_"..ColorData.Name, self.UI.Cradle)
				sColorObj.Cradle:SetHeight(27)
				sColorObj.Cradle:SetPoint("RIGHT", self.UI.Cradle, "RIGHT")
				sColorObj.Cradle:SetPoint("TOPLEFT", Last, "BOTTOMLEFT", 0, 3)
				sColorObj.Cradle:SetBackgroundColor(ColorData.Red, ColorData.Green, ColorData.Blue, 0.33)
				sColorObj.Texture = UI.CreateFrame("Texture", "ColorObj_Texture_"..ColorData.Name, sColorObj.Cradle)
				KBM.LoadTexture(sColorObj.Texture, "KingMolinator", "Media/BarSkin.png")
				sColorObj.Texture:SetPoint("TOPLEFT", self.UI.ColorObj[ColorID].Cradle, "TOPLEFT")
				sColorObj.Texture:SetPoint("BOTTOMRIGHT", self.UI.ColorObj[ColorID].Cradle, "BOTTOMRIGHT")
				sColorObj.Texture:SetAlpha(0.65)
				sColorObj.Text = LibSGui.ShadowText:Create(sColorObj.Cradle, true)
				sColorObj.Text:SetText(ColorData.Name)
				sColorObj.Text:SetFontColor(98,0.98,0.98)
				sColorObj.Text:SetPoint("CENTER", sColorObj.Texture, "CENTER")
				sColorObj.Text:SetFontSize(13)
				sColorObj.Text:SetLayer(2)
				sColorObj.Check = UI.CreateFrame("RiftCheckbox", "ColorObj_Check_"..ColorData.Name, self.UI.Cradle)
				sColorObj.Check:SetPoint("CENTERRIGHT", sColorObj.Texture, "CENTERLEFT")
				Last = sColorObj.Cradle
				if ColorID == self.Color then
					sColorObj.Check:SetChecked(true)
				end
				sColorObj.ID = ColorID
				sColorObj.Check.ColorObj = ColorObj
				sColorObj.Check.sColorObj = sColorObj
				sColorObj.Texture.ColorObj = ColorObj
				sColorObj.Texture.sColorObj = sColorObj
				
				function sColorObj:CheckboxChange_Handler()
					if self.ColorObj.Active then
						if self:GetChecked() and not self.ColorObj.Removing then
							if self.ColorObj.Color then
								self.ColorObj.Removing = true
								self.ColorObj.UI.ColorObj[self.ColorObj.Color].Check:SetChecked(false)
							end
							self.ColorObj.Color = self.sColorObj.ID
							if self.ColorObj.Callback then
								self.ColorObj.Callback.Color(self.ColorObj._root, true, self.sColorObj.ID)
							end
							self:SetEnabled(false)
						else
							if self.ColorObj.Removing then
								self:SetEnabled(true)
							end
							self.ColorObj.Removing = false
						end
					end
				end
				sColorObj.Check:EventAttach(Event.UI.Checkbox.Change, sColorObj.CheckboxChange_Handler, ColorID.." Object Selected: Checkbox")
				
				function sColorObj:Texture_Handler()
					if self.sColorObj.Check:GetEnabled() then 
						if not self.sColorObj.Check:GetChecked() then
							self.sColorObj.Check:SetChecked(true)
						end
					end	
				end
				sColorObj.Texture:EventAttach(Event.UI.Input.Mouse.Left.Click, sColorObj.Texture_Handler, ColorID.." Texture click handler")
			end		
		else
			for ID, sColorObj in pairs(self.UI.ColorObj) do
				sColorObj.Texture.ColorObj = self
				sColorObj.Check.ColorObj = self
			end
			self.UI.Cradle:SetParent(self._root.UI.Content)
			self.UI.Cradle:SetPoint("RIGHT", self._root.UI.Cradle, "RIGHT", -4, nil)
			self.UI.Cradle:SetVisible(true)
			self:SetColor(self.Color)
		end		
		self.UI.Cradle:SetHeight(23)
		
		self.UI.Cradle._object = self
		self.UI.Check._object = self
		self.UI.Text._object = self
		
		self.Page:LinkY(self.UI.Cradle)
		self.Page:LinkX(self.UI.Cradle)
		
		self.UI.Text:SetText("Custom Color")
		
		if self.Callback then
			if self.Settings then
				self.UI.Check:SetVisible(true)
				self.UI.Check:SetChecked(self.Settings.Custom)
				function self:Checkbox_Handler()
					if self._object.Active then
						local state = self:GetChecked()
						self._object.Callback[ID](self._object._root, state)
						if not state then
							self._object:Disable(true)
						else
							self._object:Enable(true)
						end
					end
				end
				self.UI.Check:EventAttach(Event.UI.Checkbox.Change, self.Checkbox_Handler, self.ID..": checkbox callback handler")
				self.ChildState = self.Settings[ID]			
			else
				self.UI.Check:SetVisible(false)
				self.UI.Check:SetChecked(false)
			end
			
			-- Adjust States
			if not self.Page.ChildState then
				self:Disable()
			elseif not self.ChildState then
				self:Disable(true)
				self:Enable(false)
			else
				
				self:SetEnabled(self.Settings.Custom)
			end
			
			function self:TextClick_Handler()
				if self.Enabled then
					if self.Settings then
						if self.UI.Check:GetChecked() then
							self.UI.Check:SetChecked(false)
						else
							self.UI.Check:SetChecked(true)
						end
					else
						self.Callback[ID](self.Page)
					end
				end
			end
			self.UI.Text:EventAttach(Event.UI.Input.Mouse.Left.Click, function() self:TextClick_Handler() end, self.ID..": text click handler")
		else
			self.UI.Check:SetVisible(false)
			self.UI.Check:SetChecked(false)
		end
		self.Page.LastObject = self
		self.Page.Rendered:InsertFirst(self)
		self:AddHeight()
		self.Active = true
	end
	
	function ColorObj:Enable()
		self:SetEnabled(true)
	end
	
	function ColorObj:Disable()
		self:SetEnabled(false)
	end
	
	function ColorObj:SetColor(Color)
		self.Active = false
		if self.Color then
			self.UI.ColorObj[self.Color].Check:SetChecked(false)
		end
		self.UI.ColorObj[Color].Check:SetChecked(true)
		self.Color = Color
		self.Active = true
	end
	
	function ColorObj:Update(Text)
		self.UI.Text:SetText(tostring(Text))
	end
	
	function ColorObj:Remove()
		-- Remove Events
		self.Active = false
		self.UI.ColorObj[self.Color].Check:SetChecked(false)
		self.UI.Text:EventDetach(Event.UI.Input.Mouse.Left.Click, nil, self.ID..": text click handler")
		self.UI.Check:EventDetach(Event.UI.Checkbox.Change, self.Checkbox_Handler, self.ID..": checkbox callback handler")
		self.UI.Text._object = nil
		self.UI.Check._object = nil
		self.UI.Cradle._object = nil
		self.Color = nil
		self.ChildState = true
		self:Enable(false)
		
		-- Clear up UI
		for _, RemoveObj in LibSata.EachIn(self.Rendered) do
			RemoveObj:Remove()
		end
		self.UI.Text:SetText()
		self.UI.Cradle:ClearAll()
		self.UI.Cradle:SetParent(DumpParent)
		self.UI.Cradle:SetVisible(false)
		--Menu.UI.Store.Header[self._root.Type]:Add(self.UI)
		Menu.UI.Store.Color:Add(self.UI)
		self.Rendered:Clear()
		self.LastObject = nil
		self.UI = nil
	end

	function ColorObj:LinkY(Object, Spacer)
		if self.LastObject then
			self.LastObject:LinkY(Object, Spacer)
		else
			Object:SetPoint("TOP", self.UI.Cradle, "BOTTOM")
		end
	end
		
	function ColorObj:LinkX(Object)
		Object:SetPoint("LEFT", self.UI.Check, "RIGHT")			
	end
		
	return ColorObj
end

function Menu.Object:CreateSpacer()
	
end

function Menu.Object:CreateGroup(Name, Settings, ID, Callback, Page)
	GroupObj = {}
	Menu.UI.SetDefaults(GroupObj, Name, Settings, ID, Callback, Page)
	
	function GroupObj:Render()	
	end
			
	function GroupObj:Remove()
	end
	
	return GroupObj
end

function Menu.Queue.PageEnd(Page)
	local Marker = {
		Type = "End",
		Page = Page,
	}
	RenderQueue:Add(Marker)
end

function Menu.RenderHalt()
	RenderQueue:Clear()
end

function Menu.RenderUpdate()
	local MaxTime = 0.02
	local endTime = Inspect.Time.Real() + MaxTime
	local x = 0
	repeat 
		QueueObj = RenderQueue:RemoveFirst() 
		if QueueObj then
			if QueueObj.Type == "End" then
				QueueObj.Page:Displayed()
			else
				QueueObj:Render()
				if Inspect.Time.Real() >= endTime then
					x = x + 1
					--print("CC: Yield: "..x)
					--coroutine.yield()
					endTime = Inspect.Time.Real() + MaxTime
				end
			end
		end
	until not QueueObj
	--print("CC: Rendering Complete")
end

function Menu.UI.UpdateHandler()
	if RenderQueue._count > 0 then
		Menu.RenderUpdate()
	end
	
	--[[
	if Menu.Renderer then
		if coroutine.status(Menu.Renderer) == "dead" then
			Menu.Renderer = nil
			--print("Rendering Complete")		
		else
			--if Inspect.Time.Real() > Menu.NextCall then
				assert(coroutine.resume(Menu.Renderer))
				--Menu.NextCall = Inspect.Time.Real() + 1
			--end
		end
	else
		if RenderQueue._count > 0 then
			--print("Starting Renderer")
			Menu.Renderer = coroutine.create(Menu.RenderUpdate)
			assert(coroutine.resume(Menu.Renderer))
			--Menu.NextCall = Inspect.Time.Real() + 1 
		end
	end]]--
end

Command.Event.Attach(Event.System.Update.Begin, Menu.UI.UpdateHandler, "Render Handler")