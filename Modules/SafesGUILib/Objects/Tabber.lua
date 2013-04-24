-- Tabber Object
-- Written by Paul Snart
-- Copyright 2013
--

local AddonIni, LibSGui = ...
local _int = LibSGui:_internal()

local TH = _int.TH

LibSGui.Event.Tabber = {}
LibSGui.Event.Tabber.Change = Utility.Event.Create(AddonIni.id, "Event.Tabber.Change")

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
	tabber.aWidth = tabber._cradle:GetWidth()
	tabber.TextSize = {
		Normal = Default.TextSize,
		Selected = Default.SelectedTextSize,
		HighlightNormal = Default.HighlightTextSize,
		HighlightSelected = Default.HighlightSelectedTextSize,
	}
	
	function tabber:CreateTab(Name, Icon, Selected)
		local Tab = {}
		Name = tostring(Name) or ""
		self.Count = self.Count + 1
		Tab.index = self.Count
		self._aWidth = math.ceil(self._cradle:GetWidth() / self.Count)
		
		Selected = Selected or false
		if self._ori ~= "BOTTOM" then
			Tab._file = {[true] = "Media/Tabber.png", [false] = "Media/Tabber_Off.png"}
		else
			Tab._file = {[true] = "Media/Tabber_Bottom.png", [false] = "Media/Tabber_Bottom_Off.png"}
		end
		Tab.Texture = _int:pullTexture(self._cradle, true)
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
			else
				--self._tabs[self.Count - 1].Texture:SetPoint("LEFT", self._tabs[self.Count - 2].Texture, "LEFT")
			end
			Tab.Texture:SetPoint("RIGHT", self._cradle, "RIGHT")
			for n = 1, self.Count - 1 do
				self._tabs[n].Texture:SetWidth(self._aWidth - 1)
			end
		end
		self._tabs[self.Count] = Tab
		Tab.Text = _int:pullText(self._cradle, true)
		Tab.Text:SetText(Name)
		Tab.Text:SetLayer(3)
		Tab.Text:SetFontColor(0.95, 0.95, 0.75)
		Tab.Enabled = true
		Tab.Texture.Tab = Tab
		
		function Tab:SetPoints()
			if self.Selected then
				self.Texture:SetPoint("TOP", self.Tabber._cradle, "TOP")
				Tab.Text:SetPoint("CENTER", Tab.Texture, "CENTER", 0, 1)
				Tab.Text:SetAlpha(1)
				Tab.Text:SetFontSize(self.Tabber.TextSize.Selected)
			else
				if self.index ~= 1 then
					self.Texture:SetPoint("LEFT", self.Tabber._tabs[self.index - 1].Texture, "RIGHT", 1, nil)
				else
					if self.index == self.Tabber.Count then
					
					end
				end
				Tab.Text:SetAlpha(0.5)
				Tab.Text:SetFontSize(self.Tabber.TextSize.Normal)
				if self.Tabber._ori == "TOP" then
					self.Texture:SetPoint("TOP", self.Tabber._cradle, "TOP", nil, 6)
					Tab.Text:SetPoint("CENTER", Tab.Texture, "CENTER", 0, 1)
				else
					self.Texture:SetPoint("BOTTOM", self.Tabber._cradle, "BOTTOM", nil, -6)
					Tab.Text:SetPoint("CENTER", Tab.Texture, "CENTER", 0, -1)
				end
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
		
		function Tab:ClickHandler()
			self = self.Tab
			if not self.Selected then
				self:Select()
				self.MouseIn(self.Texture)
			end
		end
		
		function Tab:MouseIn()
			self = self.Tab
			if self.Text:GetText() ~= "" then
				if self.Selected then
					self.Text:SetFontSize(self.Tabber.TextSize.HighlightSelected)
				else
					self.Text:SetFontSize(self.Tabber.TextSize.HighlightNormal)
					self.Text:SetAlpha(1)
				end
				self.Text:SetFontColor(1,1,1)
			end
		end
		
		function Tab:MouseOut()
			self = self.Tab
			if self.Text:GetText() ~= "" then
				if self.Selected then
					self.Text:SetFontSize(self.Tabber.TextSize.Selected)
				else
					self.Text:SetFontSize(self.Tabber.TextSize.Normal)
					self.Text:SetAlpha(0.5)
				end
				self.Text:SetFontColor(0.95, 0.95, 0.75)
			end
		end
		Tab.Texture:EventAttach(Event.UI.Input.Mouse.Cursor.In, Tab.MouseIn, "Tab "..Tab.index..": Mouse In Handler")
		Tab.Texture:EventAttach(Event.UI.Input.Mouse.Cursor.Out, Tab.MouseOut, "Tab "..Tab.index..": Mouse Out Handler")
		Tab.Texture:EventAttach(Event.UI.Input.Mouse.Left.Click, Tab.ClickHandler, "Tab "..Tab.index..": Click Handler")
	end
	
	function tabber:AlignWidth()
		local newWidth = math.ceil(self._cradle:GetWidth() / self.Count)
		if newWidth ~= self._aWidth then
			self._aWidth = newWidth
			for n = 1, self.Count- 1 do
				self._tabs[n].Texture:SetWidth(self._aWidth)
			end		
		end
	end
	tabber._cradle:EventAttach(Event.UI.Layout.Size, function() tabber:AlignWidth() end, "Align Buttons")
	
	function tabber:SetWidth(w)
		self._cradle:SetWidth(math.ceil(w))
	end
	
	tabber:CreateTab(title, pTable.Icon, true)
		
	return tabber
end