-- Panel Object
-- Written by Paul Snart
-- Copyright 2013
--

local AddonDetails, LibSGui = ...
local _int = LibSGui:_internal()

local TH = _int.TH

-- Define Panel Events
LibSGui.Event.Panel = {}
LibSGui.Event.Panel.Scrollbar = {}
LibSGui.Event.Panel.Scrollbar.Change = Utility.Event.Create("SafesGUILib", "Event.Panel.Scrollbar.Change")
LibSGui.Event.Panel.Scrollbar.Active = Utility.Event.Create("SafesGUILib", "Event.Panel.Scrollbar.Active")

-- Define Area
LibSGui.Panel = {}

function LibSGui.Panel:Create(title, _parent, pTable)
	pTable = pTable or {}
	pTable.w = tonumber(pTable.w)
	pTable.h = tonumber(pTable.h)
	
	local panel = _int:buildBase("panel", _parent)
	
	panel.Title = title
	panel._cradle:SetVisible(pTable.Visible or false)
	if pTable.TOP then
		panel._cradle:SetPoint("TOP", TOP.Frame or _parent, pTable.TOP.Location)
	else
		panel._cradle:SetPoint("TOP", _parent, "TOP")
	end
	if pTable.LEFT then
		panel._cradle:SetPoint("LEFT", LEFT.Frame or _parent, pTable.LEFT.Location)
	else
		panel._cradle:SetPoint("LEFT", _parent, "LEFT")
	end
	if pTable.h then
		panel._cradle:SetHeight(pTable.h)
	else
		panel._cradle:SetPoint("BOTTOM", _parent, "BOTTOM")
	end
	if pTable.w then
		panel._cradle:SetWidth(pTable.w)
	else
		panel._cradle:SetPoint("RIGHT", _parent, "RIGHT")
	end
	panel._parent = _parent
	
	panel._multi = 10
	panel._div = 0.1 -- (1/panel._multi)
	panel.Offset = {
		x = 0,
		y = 0,
	}
	
	-- Create Base Raised Border
	panel._raisedBorder = _int:pullFrameRaised(panel._cradle, true)
	
	-- Create Base Sunken Border
	panel._sunkenBorder = _int:pullFrameSunken(panel._raisedBorder.Content)
	panel._mask = panel._sunkenBorder._mask
	
	function panel:SizeChangeHandler()
		if self._panel.Scrollbar then
			if self._panel.Scrollbar._active then
				self._panel.Scrollbar:_checkBounds()
			end
		end
	end
	panel._mask:EventAttach(Event.UI.Layout.Size, panel.SizeChangeHandler, "Panel Mask Size Change")
	panel._mask._panel = panel
	
	panel.Content = panel._sunkenBorder.Content
	panel.Content._panel = panel
	panel.Content:EventAttach(Event.UI.Layout.Size, panel.SizeChangeHandler, "Panel Content Size Change")
	
	panel.SetBorderWidth = function(panel, w, Type) panel._raisedBorder:SetBorderWidth(w, Type) end
	panel.ClearBorderWidth = function(panel, w, Type) panel._raisedBorder:ClearBorderWidth() end
		
	function panel:GetScrollbar()
		return panel.Scrollbar
	end
	
	function panel:GetContent()
		return panel.Content()
	end
	
	function panel:GetContentWidth()
		return panel.Content:GetWidth()
	end
	
	function panel:GetContentHeight()
		return panel.Content:GetHeight()
	end
	
	function panel:GetBoundsWidth()
		return panel._mask:GetWidth()
	end
	
	function panel:GetBoundsHeight()
		return panel._mask:GetHeight()
	end
	
	function panel:SetWidth(newWidth)
		self._cradle:ClearPoint("RIGHT")
		self._cradle:ClearPoint("LEFT")
		self._cradle:SetPoint("LEFT", self._parent, "LEFT")
		self._cradle:SetWidth(math.ceil(newWidth))
	end
	
	function panel:SetHeight(newHeight)
		self._cradle:ClearPoint("BOTTOM")
		self._cradle:SetHeight(math.ceil(newHeight))
	end
	
	function panel:SetContentWidth(newWidth)
		-- not currently supported
		if _int._debug then
			print("Panel:SetContentWidth() not currently supported")
		end
	end
	
	function panel:SetContentHeight(newHeight)
		if type(newHeight) == "number" then
			--print("old height: "..self.Content:GetHeight())
			if newHeight > 0 then
				self.Content:ClearPoint("BOTTOM")
				self.Content:SetHeight(newHeight)
			else
				if _int._debug then
					error("[Panel:SetContentHeight] Expecting a number greater than zero, got: "..tostring(newHeight))
				end
			end
		else
			if _int._debug then
				error("[Panel:SetContentHeight] Expecting number, got: "..type(newHeight))
			end
		end
	end

	function panel:AddScrollbar(pTable)
		pTable = pTable or {}
		pTable.Vertical = pTable.Vertical or true -- Defaults to Vertical (No current support for Horizontal)
		pTable.Hide = pTable.Hide or false -- Hide the scrollbar if not required, False = Disable and visible when not required, else hidden.
		pTable.Dynamic = pTable.Dynamic or false -- If Hide is enabled and Dynamic is enabled the Panel will adjust the width of the Content to replace the scrollbar area.
		
		if type(self) == "table" then
			if self._type == "panel" then
				if not self.Scrollbar then
					self.Scrollbar = _int:pullScrollbar(self._cradle, true)
					self.Scrollbar:SetLayer(2)
					self.Scrollbar._panel = self
					self.Scrollbar._hidden = pTable.Hide
					self.Scrollbar._dynamic = pTable.Dynamic
					self.Scrollbar:SetPoint("TOPRIGHT", self._raisedBorder.Content, "TOPRIGHT")
					self.Scrollbar:SetPoint("BOTTOM", self._raisedBorder.Content, "BOTTOM")
					self._sunkenBorder:ClearPoint("RIGHT")
					self._sunkenBorder:SetPoint("RIGHT", self.Scrollbar, "LEFT", -3, nil)
					function self:MouseWheelBackHandler(handle)
						self._panel.Scrollbar:Nudge(5)
					end
					function self:MouseWheelForwardHandler(handle)
						self._panel.Scrollbar:Nudge(-5)
					end
					function self:_addWheelEvents()
						self._mask:EventAttach(Event.UI.Input.Mouse.Wheel.Back, self.MouseWheelBackHandler, "Mouse Wheel Back Handler")
						self._mask:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, self.MouseWheelForwardHandler, "Mouse Wheel Forward Handler")
					end
					function self:_removeWheelEvents()
						self._mask:EventDetach(Event.UI.Input.Mouse.Wheel.Back, self.MouseWheelBackHandler, "Mouse Wheel Back Handler")
						self._mask:EventDetach(Event.UI.Input.Mouse.Wheel.Forward, self.MouseWheelForwardHandler, "Mouse Wheel Forward Handler")					
					end
					function self.Scrollbar:_checkBounds()
						local newDiff = math.floor(self._panel.Content:GetHeight() - self._panel._mask:GetHeight()) * self._panel._div
						if newDiff ~= self._panel._diff then
							self._panel._diff = newDiff
							if self._panel._diff > 0 then
								self:SetRange(0, self._panel._diff)
								self:SetEnabled(true)
								self._panel.Content:ClearPoint("TOP")
								self._panel.Content:SetPoint("TOP", self._panel._mask, "TOP", nil, -math.floor(self:GetPosition() * self._panel._multi))
								LibSGui.Event.Panel.Scrollbar.Active(self._panel, true)
								self._panel:_addWheelEvents()
							else
								self:SetRange(0,0)
								self:SetEnabled(false)
								if self._hidden then
									self:SetVisible(false)
									if self._dynamic then
										self._panel._sunkenBorder:ClearPoint("RIGHT")
										self._panel._sunkenBorder:SetPoint("RIGHT", self._panel._raisedBorder_cradle, "RIGHT")
									end
								end
								LibSGui.Event.Panel.Scrollbar.Active(self._panel, false)
								self._panel:_removeWheelEvents()
							end
						end
					end
					function self.Scrollbar:ScrollChangeHandler(handle)
						self._panel.Content:ClearPoint("TOP")
						self._panel.Content:SetPoint("TOP", self._panel._mask, "TOP", nil, -math.floor(self:GetPosition() * self._panel._multi))
						LibSGui.Event.Panel.Scrollbar.Change(self._panel, self:GetPosition())
					end
					self.Scrollbar:EventAttach(Event.UI.Scrollbar.Change, self.Scrollbar.ScrollChangeHandler, "Panel Scroller Change")
					self.Scrollbar._active = true
					self.Scrollbar:_checkBounds()
					return self.Scrollbar
				else
					if _int._debug then
						error("[Panel:AddScrollbar] There is already a Scrollbar assigned to this Panel")
					end
				end
			else
				if _int._debug then
					error("[Panel:AddScrollbar] Expecting Panel Object, got: "..tostring(self._type))
				end
			end
		else
			if _int._debug then
				error("[Panel:AddScrollbar] Expecting Table, got: "..type(self))
			end
		end
	end
	
	panel:SetBorderWidth(4)
	return panel, panel.Content
end