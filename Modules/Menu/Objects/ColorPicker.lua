-- KBM Menu System: Color Picker
-- Written by Paul Snart
-- Copyright 2014
--
local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local Menu = KBM.Menu

function Menu.Object:CreateColorPicker(Name, Object, ID, Callback, Page)
	local ColorObj = {}
	Menu.UI.SetDefaults(ColorObj, Name, Object.Settings, ID, Callback, Page)
	ColorObj.Type = "Color"
	ColorObj.KBMObject = Object
	
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
		self.Color = self.KBMObject.Color
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
		
		self.UI.Text:SetText(KBM.Language.Color.Custom[KBM.Lang])
		
		if self.Callback then
			if self.Settings then
				self.UI.Check:SetVisible(true)
				self.UI.Check:SetChecked(self.Settings.Custom)
				function self:Checkbox_Handler()
					if self._object.Active then
						local state = self:GetChecked()
						self._object.Callback[ID](self._object._root, state)
						self._object:SetColor(self._object.KBMObject.Color)
						if not state then
							self._object:Disable(true)
						else
							self._object:Enable(true)
						end
					end
				end
				self.UI.Check:EventAttach(Event.UI.Checkbox.Change, self.Checkbox_Handler, self.ID..": checkbox callback handler")
				self.ChildState = self.KBMObject.Color			
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
		self.UI.Cradle:SetParent(Menu.DumpParent)
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