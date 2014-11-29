-- KBM Menu System: Header
-- Written by Paul Snart
-- Copyright 2014
--
local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local Menu = KBM.Menu

function Menu.Object:CreateHeader(Name, Settings, ID, Callback, Page)
	local HeaderObj = {}
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
					LibSGui:ClearFocus()
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
		self.UI.Cradle:SetParent(Menu.DumpParent)
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