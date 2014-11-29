-- KBM Menu System: Drop Down
-- Written by Paul Snart
-- Copyright 2014
--
local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local Menu = KBM.Menu

function Menu.Object:CreateDropDown(Name, Settings, ID, Callback, Page)
	local DropObj = {}
	Menu.UI.SetDefaults(DropObj, Name, Settings, ID, Callback, Page)
	DropObj.ItemList = {}
	
	function DropObj:Render()
		self.UI = Menu.UI.Store.DropDown:RemoveLast()
		if not self.UI then
			self.UI = {}
			self.UI.Cradle = LibSGui.Frame:Create(self._root.UI.Content, true)
			self.UI.Cradle:SetLayer(2)
			self.UI.Text = LibSGui.ShadowText:Create(self.UI.Cradle, true)
			self.UI.DropDown = LibSGui.DropDown:Create(Name, self.UI.Cradle)
			self.UI.DropDown:SetVisible(true)
			self.UI.DropDown:SetPoint("TOPLEFT", self.UI.Text._cradle, "TOPRIGHT", 20, 0)
			self.UI.Text:SetPoint("CENTERY", self.UI.Cradle, "CENTERY")
			self.UI.Text:SetPoint("LEFT", self.UI.Cradle, "LEFT")
			self.UI.Text:SetFontSize(13)
			self.UI.Text:SetFontColor(0.95, 0.95, 0.75)
		else
			self.UI.Cradle:SetParent(self._root.UI.Content)
			self.UI.Cradle:SetVisible(true)		
		end
		
		if self.PageLink then
			self.UI.Cradle:SetPoint("RIGHT", self._root.UI.Cradle, "RIGHT")
			self.UI.Cradle:SetPoint("LEFT", self._root.UI.Cradle, "LEFT")
			self.UI.Text:SetPoint("RIGHT", self._root.UI.Cradle, "RIGHT")
		else
			self.UI.Cradle:ClearPoint("RIGHT")
			self.UI.Text:ClearPoint("RIGHT")
		end
		self.UI.Cradle:SetBackgroundColor(0,0,0,0)
		
		self.UI.Text._object = self
		self.UI.DropDown._object = self
		self.UI.Cradle._object = self

		self.UI.Cradle:SetHeight(24)
		
		self.Page:LinkY(self.UI.Cradle)
		self.Page:LinkX(self.UI.Text)

		function self:Enable(Children)
			if not Children then
				self.Enabled = true
				--self.UI.Check:SetEnabled(true)
				self.UI.Text:SetAlpha(1)
				self.UI.DropDown:Enable()
			end
			if Children ~= false then
				self:EnableChildren(Children)
			end
		end
		
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
		self.UI.DropDown:SetItems(self.ItemList)
		self.UI.DropDown:SetEnabled(self.Enabled)
		self.UI.DropDown:Select(self.Settings[self.ID] or 1)
		self.Page.LastObject = self
		self.Page.Rendered:InsertFirst(self)
		self.Active = true
		self:AddHeight()
		
		function self:ItemChange_Handler(Object, Item)
			self.Settings[ID] = Item
			self.Callback[ID](self.Callback, Item)
		end	
		Command.Event.Attach(Event.SafesGUILib.DropDown.Change, function(_, Object, Item) self:ItemChange_Handler(Object, Item) end, "drop_down_change_handler")
	end
	
	function DropObj:SetEnabled(bool)
		self.Enabled = bool
	end

	function DropObj:SetPage(Page)
		self.PageLink = Page
	end
	
	function DropObj:Update(Text)
		self.UI.Text:SetText(tostring(Text))
	end
	
	function DropObj:SetItemList(itemList)
		self.ItemList = itemList
	end
		
	function DropObj:Disable()
		self.UI.DropDown:Disable()
		self.UI.Text:SetAlpha(0.5)
	end
	
	function DropObj:Remove()
		Command.Event.Detach(Event.SafesGUILib.DropDown.Change, nil, "drop_down_change_handler")
		self.UI.Text._object = nil
		self.UI.DropDown._object = nil
		self.ChildState = true
		self:Enable(false)

		for _, RemoveObj in LibSata.EachIn(self.Rendered) do
			RemoveObj:Remove()
		end
		self.UI.Text:SetText()
		self.UI.Cradle:ClearAll()
		self.UI.Cradle:SetVisible(false)
		self.UI.Cradle:SetParent(Menu.DumpParent)
		self.UI.DropDown:RemoveAllItems()
		Menu.UI.Store.DropDown:Add(self.UI)
		self.Rendered:Clear()
		self.LastObject = nil
		self.UI = nil
		self.Active = false		
	end

	function DropObj:LinkY(Object, Spacer)
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
	
	return DropObj
end
