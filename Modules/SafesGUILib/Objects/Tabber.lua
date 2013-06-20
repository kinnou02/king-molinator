-- Tabber Object
-- Written by Paul Snart
-- Copyright 2013
--

local AddonIni, LibSGui = ...
local _int = LibSGui:_internal()

local TH = _int.TH

LibSGui.Event.Tabber = {}
LibSGui.Event.Tabber.Change = Utility.Event.Create(AddonIni.id, "Tabber.Change")

-- Define Area
LibSGui.Tabber = {}
local Default = {
	TabWidth = 128,
	TextSize = 12,
	SelectedTextSize = 14,
	HighlightTextSize = 14,
	HighlightSelectedTextSize = 16,
}

function LibSGui.Tabber:Create(title, _parent, pTable)
	pTable = pTable or {}
	pTable.Selected = pTable.Selected or false
	pTable.Orientation = pTable.Orientation or "TOP"
	
	local tabber = _int:buildBase("tabber", _parent)

	-- Tabber Objects are a simple set of tabs which can be orientated for TOP (default) or BOTTOM.
	-- Each Tabber Object can optionally be assigned a content frame to be shown/hidden on selection.
	-- When a Tab is selected you'll receive an Event.SafesGUILib.Tabber.Change notification.
	-- Dimensions: Height determines the tab height, and Width will fit the number of tabs in (fully aligned)
	--
	tabber.Title = title
	tabber._cradle:SetVisible(pTable.Visible or false)
	tabber._ori = pTable.Orientation
	
	tabber._tabs = {}
	tabber.Count = 0
	tabber.Selected = nil
	tabber.UserData = {}
	tabber.aWidth = tabber._cradle:GetWidth()
	tabber.TextSize = {
		Normal = Default.TextSize,
		Selected = Default.SelectedTextSize,
		HighlightNormal = Default.HighlightTextSize,
		HighlightSelected = Default.HighlightSelectedTextSize,
	}
	
	function tabber:CreateTab(Name, Icon, Selected, Location)
		local Tab = {}
		Location = Location or "Rift"
		Name = Name or ""
		self.Count = self.Count + 1
		Tab.index = self.Count
		self._aWidth = math.ceil(self._cradle:GetWidth() / self.Count)
		Tab.HasIcon = false
		
		if type(Icon) == "string" and type(Location) == "string" then
			Tab.HasIcon = true
		end
		
		Selected = Selected or false
		if self._ori ~= "BOTTOM" then
			Tab._file = {[true] = "Media/Tabber.png", [false] = "Media/Tabber_Off.png"}
		else
			Tab._file = {[true] = "Media/Tabber_Bottom.png", [false] = "Media/Tabber_Bottom_Off.png"}
		end
		Tab.Texture = _int:pullTexture(self._cradle, true)
		Tab.Label = Name
		Tab.Texture:SetLayer(1)
		Tab.Tabber = self
		if self._ori == "TOP" then
			Tab.Texture:SetPoint("BOTTOM", self._cradle, "BOTTOM")
		else
			Tab.Texture:SetPoint("TOP", self._cradle, "TOP")
		end
		if self.Count == 1 then
			Tab.Texture:SetPoint("RIGHT", self._cradle, "RIGHT")
			Tab.Texture:SetPoint("LEFT", self._cradle, "LEFT")
		else
			self._tabs[self.Count - 1].Texture:ClearPoint("RIGHT")
			if self.Count == 2 then
				self._tabs[self.Count - 1].Texture:ClearPoint("LEFT")
				self._tabs[1].Texture:SetPoint("LEFT", self._cradle, "LEFT")
			end
			Tab.Texture:SetPoint("RIGHT", self._cradle, "RIGHT")
			for n = 1, self.Count - 1 do
				self._tabs[n].Texture:SetWidth(self._aWidth - 1)
			end
		end
		self._tabs[self.Count] = Tab
		Tab.Icon = _int:pullTexture(self._cradle, false)
		Tab.Icon:SetLayer(3)
		Tab.Text = LibSGui.ShadowText:Create(self._cradle, false)
		Tab.Text:SetLayer(3)
		Tab.Text:SetFontColor(0.95, 0.95, 0.75)
		Tab.Icon:SetPoint("CENTER", Tab.Texture, "CENTER")
		Tab.Default = {
			w = 0,
			h = 0,
		}
		Tab.Enabled = true
		
		function Tab:UpdateIcon()
			if self.Default.w > 0 and self.Default.h > 0 then
				local newHeight = self.Texture:GetHeight() - 6
				local newRatio = newHeight / self.Default.h
				self.Icon:SetHeight(newHeight)
				self.Icon:SetWidth(self.Default.w * newRatio)
			end
		end
		
		function Tab:IconLoaded()
			self.Default.w = self.Icon:GetTextureWidth()
			self.Default.h = self.Icon:GetTextureHeight()
			self:UpdateIcon()
		end
		
		if Tab.HasIcon then
			Tab.Text:SetVisible(false)
			Tab.Icon:SetVisible(true)
			TH.LoadTexture(Tab.Icon, Location, Icon, false, function() Tab:IconLoaded() end)
		else
			Tab.Text:SetVisible(true)
			Tab.Icon:SetVisible(false)
			Tab.Text:SetText(Tab.Label)
		end
		Tab.Enabled = true
		Tab.Texture.Tab = Tab
			
		function Tab:SetPoints()
			if self.Selected then
				if self.Tabber._ori == "TOP" then
					self.Texture:SetPoint("TOP", self.Tabber._cradle, "TOP")
				else
					self.Texture:SetPoint("BOTTOM", self.Tabber._cradle, "BOTTOM")
				end
				self.Text:SetPoint("CENTER", self.Texture, "CENTER", 0, 2)
				self.Text:SetAlpha(1)
				self.Text:SetFontSize(self.Tabber.TextSize.Selected)
				
				self.Icon:SetAlpha(1)
				
				self:UpdateIcon()
			else
				if self.index ~= 1 then
					self.Texture:SetPoint("LEFT", self.Tabber._tabs[self.index - 1].Texture, "RIGHT", 1, nil)
				else
					if self.index == self.Tabber.Count then
					
					end
				end
				self.Text:SetAlpha(0.5)
				self.Text:SetFontSize(self.Tabber.TextSize.Normal)
				self.Icon:SetAlpha(0.5)
				if self.Tabber._ori == "TOP" then
					self.Texture:SetPoint("TOP", self.Tabber._cradle, "TOP", nil, 6)
					Tab.Text:SetPoint("CENTER", Tab.Texture, "CENTER", 0, 2)
				else
					self.Texture:SetPoint("BOTTOM", self.Tabber._cradle, "BOTTOM", nil, -6)
					Tab.Text:SetPoint("CENTER", Tab.Texture, "CENTER", 0, 2)
				end
				self:UpdateIcon()
			end
		end
		
		function Tab:Select()
			if self.Tabber.Selected then
				self.Tabber.Selected.Selected = false
				TH.LoadTexture(self.Tabber.Selected.Texture, AddonIni.id, Tab._file[false])
				self.Tabber.Selected:SetPoints()
			end
			TH.LoadTexture(Tab.Texture, AddonIni.id, Tab._file[true])
			self.Selected = true
			self.Tabber.Selected = self
			self:SetPoints()
		end
		if Selected then
			Tab:Select()
		else
			TH.LoadTexture(Tab.Texture, AddonIni.id, Tab._file[false])
			Tab:SetPoints()
		end
		
		function Tab:SetText(Text)
			Text = tostring(Text)
			if Tab.HasIcon then
				self.Icon:SetVisible(false)
			end
			Tab.Text:SetText(Text)
			Tab.Label = Text
		end
		
		function Tab:SetIcon(Location, Icon)
			if self.Label ~= "" then
				self.Text:SetVisible(false)
			end
			TH.LoadTexture(self.Icon, Location, Icon)
		end
		
		function Tab:Disable()
			self.Enabled = false
			if self.Selected then
				self.Selected = false
				self.Tabber.Selected = nil
				TH.LoadTexture(self.Texture, AddonIni.id, Tab._file[false])
				self:SetPoints()
			end
			self.Icon:SetAlpha(0.15)
			self.Text:SetFontColor(0.4, 0.4, 0.4)
		end
		
		function Tab:Enable()
			self.Enabled = true
			self.Icon:SetAlpha(1)
			self.Text:SetFontColor(0.95, 0.95, 0.75)
		end
		
		function Tab:GetEnabled()
			return Tab.Enabled
		end
		
		function Tab:ClearIcon()
			if self.Label ~= "" then
				self.Text:SetVisible(true)
			end
			self.Icon:SetVisible(false)
		end
		
		function Tab:ClickHandler()
			self = self.Tab
			if self.Enabled then
				if not self.Selected then
					self:Select()
					self.MouseIn(self.Texture)
					LibSGui.Event.Tabber.Change(self.Tabber, self)
				end
			end
		end
		
		function Tab:MouseIn()
			self = self.Tab
			if self.Enabled then
				if self.Selected then
					--self.Text:SetFontSize(self.Tabber.TextSize.HighlightSelected)
				else
					self.Text:SetFontSize(self.Tabber.TextSize.HighlightNormal)
					self.Text:SetAlpha(1)
					self.Icon:SetAlpha(1)
					self.Icon:SetWidth(self.Icon:GetWidth() + 2)
					self.Icon:SetHeight(self.Icon:GetHeight() + 2)
				end
				self.Text:SetFontColor(1,1,1)
			end
		end
		
		function Tab:MouseOut()
			self = self.Tab
			if self.Enabled then
				if self.Selected then
					--self.Text:SetFontSize(self.Tabber.TextSize.Selected)
				else
					self.Text:SetFontSize(self.Tabber.TextSize.Normal)
					self.Text:SetAlpha(0.5)
					self.Icon:SetAlpha(0.5)
					self.Icon:SetWidth(self.Icon:GetWidth() - 2)
					self.Icon:SetHeight(self.Icon:GetHeight() - 2)
				end
				self.Text:SetFontColor(0.95, 0.95, 0.75)
			end
		end
		Tab.Texture:EventAttach(Event.UI.Input.Mouse.Cursor.In, Tab.MouseIn, "Tab "..Tab.index..": Mouse In Handler")
		Tab.Texture:EventAttach(Event.UI.Input.Mouse.Cursor.Out, Tab.MouseOut, "Tab "..Tab.index..": Mouse Out Handler")
		Tab.Texture:EventAttach(Event.UI.Input.Mouse.Left.Click, Tab.ClickHandler, "Tab "..Tab.index..": Click Handler")
		
		return Tab
	end
	
	function tabber:GetSelected()
		return self.Selected
	end
	
	function tabber:AlignWidth()
		local newWidth = math.floor(self._cradle:GetWidth() / self.Count)
		if newWidth ~= self._aWidth then
			self._aWidth = newWidth
			for n = 1, self.Count- 1 do
				self._tabs[n].Texture:SetWidth(self._aWidth)
			end		
		end
	end
	tabber._cradle:EventAttach(Event.UI.Layout.Size, function() tabber:AlignWidth() end, "Align Buttons")
	
	function tabber:SetWidth(w)
		self._cradle:SetWidth(math.floor(w))
	end
	
	local defaultTab = tabber:CreateTab(title, pTable.Icon, true, pTable.Location)
		
	return tabber, defaultTab
end