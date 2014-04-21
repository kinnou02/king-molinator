-- KBM Menu System: Plain Header
-- Written by Paul Snart
-- Copyright 2014
--
local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local Menu = KBM.Menu

function Menu.Object:CreatePlainHeader(Name, Settings, ID, Callback, Page)
	local PlainHObj = {}
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
			self.UI.Text:SetPoint("RIGHT", self._root.UI.Cradle, "RIGHT")
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
		self.UI.Text:SetParent(Menu.DumpParent)
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