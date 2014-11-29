-- KBM Menu System: Check Option
-- Written by Paul Snart
-- Copyright 2014
--
local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local Menu = KBM.Menu

function Menu.Object:CreateCheck(Name, Settings, ID, Callback, Page)
	local CheckObj = {}
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
				local state = self:GetChecked()
				LibSGui:ClearFocus()
				self._object.Callback[ID](self._object._root, state)
				if not state then
					self._object:Disable(true)
				else
					self._object:Enable(true)
				end
			end
			self.UI.Check:EventAttach(Event.UI.Checkbox.Change, self.Checkbox_Handler, self.ID..": checkbox callback handler")
			if self.Settings then
				self.ChildState = self.Settings[ID]
			end
			
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
		-- if not self.Page.ChildState then
			-- self:Disable()
		-- elseif not self.ChildState then
			-- self:Disable(true)
			-- self:Enable(false)
		-- else
			-- self:Enable()
		-- end
		
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
		self.UI.Cradle:SetParent(Menu.DumpParent)
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
