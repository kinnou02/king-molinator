-- Tabber Object
-- Written by Paul Snart
-- Copyright 2013
--

local AddonDetails, LibSGui = ...
local _int = LibSGui:_internal()

local TH = _int.TH

LibSGui.Event.Tabber = {}
LibSGui.Event.Tabber.Change = Utility.Event.Create("SafesGUILib", "Event.Tabber.Change")
LibSGui.Event.Tabber.Scrollbar = {}
LibSGui.Event.Tabber.Scrollbar.Change = Utility.Event.Create("SafesGUILib", "Event.Tabber.Scrollbar.Change")
LibSGui.Event.Tabber.Scrollbar.Active = Utility.Event.Create("SafesGUILib", "Event.Tabber.Scrollbar.Active")

-- Define Area
LibSGui.Tabber = {}

function LibSGui.Tabber:Create(title, _parent, pTable)
	pTable = pTable or {}
	
	local tabber = _int:buildBase("tabber", _parent)
	
	-- Create an identical Panel frame.
	-- Repeated code is used to ensure seperate Event handling rather then wrapping Event.Panel.Scrollbar.
	-- I've gone for each tab having its own .Content but sharing a global Panel. This is memory intensive, but is performance savvy (sup Watchdog).
	-- This method also avoids having to wrap loads of :Create functions in to a .Content frame, and allows for fast tab switching.
	-- However, if your tabber group is repeated, you can obviously build each tabber's content, rather than have multiple tabber objects.
	-- For example, KBM's main content tabber for encounters is global, with the .Content frames being built when an encounter is selected.
	--
	tabber.Title = title
	tabber._cradle:SetVisible(pTable.Visible or false)
	if pTable.TOP then
		tabber._cradle:SetPoint("TOP", _parent, pTable.TOP)
	else
		tabber._cradle:SetPoint("TOP", _parent, "TOP")
	end
	if pTable.LEFT then
		tabber._cradle:SetPoint("LEFT", _parent, pTable.LEFT)
	else
		tabber._cradle:SetPoint("LEFT", _parent, "LEFT")
	end
	if pTable.h then
		tabber._cradle:SetHeight(pTable.h)
	else
		tabber._cradle:SetPoint("BOTTOM", _parent, "BOTTOM")
	end
	if pTable.w then
		tabber._cradle:SetWidth(pTable.w)
	else
		tabber._cradle:SetPoint("RIGHT", _parent, "RIGHT")
	end
	tabber._parent = _parent
	
	tabber._multi = 5
	tabber._div = 0.2 -- (1/tabber._multi)
	tabber.Offset = {
		x = 0,
		y = 0,
	}
	tabber._tabs = {}
	tabber._tabs.Tab = {}
	tabber._tabs.Count = 0
	tabber._tabs.Selected = nil
	
	function tabber:CreateTab(Name, Icon, Orientation, Selected)
		local Tab = {}

		Selected = Selected or false
		if Orientation ~= "TOP" or Orientation ~= "BOTTOM" then
			Tab._ori = "TOP"
		else
			Tab._ori = "BOTTOM"
		end
		Tab._tab = {[Tab._ori] = {Texture = _int:pullTexture(self._cradle, false)}}
		Tab._tab[Tab._ori].Texture:SetLayer(4)
		Tab.Content = _int:pullFrame(self._mask, Selected)
	end
	
	-- Create Base Raised Border
	tabber._raisedBorder = _int:pullFrameRaised(tabber._cradle, true)
	
	-- Create Base Sunken Border
	tabber._sunkenCradle = _int:pullFrame(tabber._cradle, true)
	tabber._sunkenCradle:SetLayer(2)
	tabber._sunkenBorder = _int:pullFrameSunken(tabber._sunkenCradle)
	
	-- Create Content Frame
	tabber._mask = _int:pullMask(tabber._cradle, true)
	tabber._mask:SetLayer(3)
	tabber._mask:SetPoint("TOPLEFT", tabber._sunkenCradle, "TOPLEFT", 3, 2)
	tabber._mask:SetPoint("BOTTOMRIGHT", tabber._sunkenCradle, "BOTTOMRIGHT", -3, -2)
	tabber._mask._tabber = tabber
	
	function tabber:SizeChangeHandler()
		if self._tabber.Scrollbar then
			if self._tabber.Scrollbar._active then
				self._tabber.Scrollbar:_checkBounds()
			end
		end
	end
	tabber._mask:EventAttach(Event.UI.Layout.Size, tabber.SizeChangeHandler, "Tabber Mask Size Change")
	
	tabber.Content = _int:pullFrame(tabber._mask, true)
	tabber.Content:SetPoint("TOPLEFT", tabber._mask, "TOPLEFT")
	tabber.Content:SetPoint("RIGHT", tabber._mask, "RIGHT")
	tabber.Content:SetHeight(tabber._mask:GetHeight())
	tabber.Content._tabber = tabber
	tabber.Content:EventAttach(Event.UI.Layout.Size, tabber.SizeChangeHandler, "Tabber Content Size Change")
	
	function tabber:GetScrollbar()
		return tabber.Scrollbar
	end
	
	function tabber:GetContent()
		return tabber.Content()
	end
	
	function tabber:SetPoint(...)
		self._cradle:SetPoint(...)
	end
	
	function tabber:ClearPoint(_point)
		self._cradle:ClearPoint(_point)
	end
	
	function tabber:GetContentWidth()
		return tabber.Content:GetWidth()
	end
	
	function tabber:GetContentHeight()
		return tabber.Content:GetHeight()
	end
	
	function tabber:GetBoundsWidth()
		return tabber._mask:GetWidth()
	end
	
	function tabber:GetBoundsHeight()
		return tabber._mask:GetHeight()
	end
	
	function tabber:SetWidth(newWidth)
		self._cradle:ClearPoint("RIGHT")
		self._cradle:ClearPoint("LEFT")
		self._cradle:SetPoint("LEFT", self._parent, "LEFT")
		self._cradle:SetWidth(math.ceil(newWidth))
	end
	
	function tabber:SetHeight(newHeight)
		self._cradle:ClearPoint("BOTTOM")
		self._cradle:ClearPoint("TOP")
		self._cradle:SetPoint("TOP", self._parent, "TOP")
		self._cradle:SetHeight(math.ceil(newHeight))
	end
	
	function tabber:SetContentWidth(newWidth)
		-- not currently supported
		if _int._debug then
			print("Tabber:SetContentWidth() not currently supported")
		end
	end
	
	function tabber:SetContentHeight(newHeight)
		if type(newHeight) == "number" then
			--print("old height: "..self.Content:GetHeight())
			if newHeight > 0 then
				self.Content:SetHeight(newHeight)
			else
				if _int._debug then
					error("[Tabber:SetContentHeight] Expecting a number greater than zero, got: "..tostring(newHeight))
				end
			end
		else
			if _int._debug then
				error("[Tabber:SetContentHeight] Expecting number, got: "..type(newHeight))
			end
		end
	end

	function tabber:AddScrollbar(pTable)
		pTable = pTable or {}
		pTable.Vertical = pTable.Vertical or true -- Defaults to Vertical (No current support for Horizontal)
		pTable.Hide = pTable.Hide or false -- Hide the scrollbar if not required, False = Disable and visible when not required, else hidden.
		pTable.Dynamic = pTable.Dynamic or false -- If Hide is enabled and Dynamic is enabled the Tabber will adjust the width of the Content to replace the scrollbar area.
		
		if type(self) == "table" then
			if self._type == "tabber" then
				if not self.Scrollbar then
					self.Scrollbar = _int:pullScrollbar(self._cradle, true)
					self.Scrollbar:SetLayer(2)
					self.Scrollbar._tabber = self
					self.Scrollbar._hidden = pTable.Hide
					self.Scrollbar._dynamic = pTable.Dynamic
					self.Scrollbar:SetPoint("TOPRIGHT", self._raisedBorder.TopRight, "TOPRIGHT", -8, 8)
					self.Scrollbar:SetPoint("BOTTOM", self._raisedBorder.BottomRight, "BOTTOM", nil, -8)
					self._sunkenCradle:ClearPoint("RIGHT")
					self._sunkenCradle:SetPoint("RIGHT", self.Scrollbar, "LEFT", -4, nil)
					function self.Scrollbar:_checkBounds()
						local newDiff = math.floor(self._tabber.Content:GetHeight() - self._tabber._mask:GetHeight()) * self._tabber._div
						if newDiff ~= self._tabber._diff then
							self._tabber._diff = newDiff
							if self._tabber._diff > 0 then
								self:SetRange(0, self._tabber._diff)
								self:SetEnabled(true)
								self._tabber.Content:ClearPoint("TOP")
								self._tabber.Content:SetPoint("TOP", self._tabber._mask, "TOP", nil, -math.floor(self:GetPosition() * self._tabber._multi))
								LibSGui.Event.Tabber.Scrollbar.Active(self._tabber, true)
							else
								self:SetRange(0,0)
								self:SetEnabled(false)
								if self._hidden then
									self:SetVisible(false)
									if self._dynamic then
										self._tabber._sunkenCradle:ClearPoint("RIGHT")
										self._tabber._sunkenCradle:SetPoint("RIGHT", self._tabber._raisedBorder.BottomRight, "LEFT", 4, nil)
									end
								end
								LibSGui.Event.Tabber.Scrollbar.Active(self._tabber, false)
							end
						end
					end
					function self.Scrollbar:ScrollChangeHandler(handle)
						self._tabber.Content:ClearPoint("TOP")
						self._tabber.Content:SetPoint("TOP", self._tabber._mask, "TOP", nil, -math.floor(self:GetPosition() * 5))
						LibSGui.Event.Tabber.Scrollbar.Change(self._tabber, self:GetPosition())
					end
					self.Scrollbar:EventAttach(Event.UI.Scrollbar.Change, self.Scrollbar.ScrollChangeHandler, "Tabber Scroller Change")
					self.Scrollbar._active = true
					self.Scrollbar:_checkBounds()
					return self.Scrollbar
				else
					if _int._debug then
						error("[Tabber:AddScrollbar] There is already a Scrollbar assigned to this Tabber")
					end
				end
			else
				if _int._debug then
					error("[Tabber:AddScrollbar] Expecting Tabber Object, got: "..tostring(self._type))
				end
			end
		else
			if _int._debug then
				error("[Tabber:AddScrollbar] Expecting Table, got: "..type(self))
			end
		end
	end

	tabber:CreateTab(title or "Tab")
	
	tabber._sunkenCradle:SetPoint("TOPLEFT", tabber._raisedBorder.TopLeft, "BOTTOMRIGHT", -4, -4)
	tabber._sunkenCradle:SetPoint("BOTTOMRIGHT", tabber._raisedBorder.BottomRight, "TOPLEFT", 4, 4)
	
	return tabber, tabber.Content
end