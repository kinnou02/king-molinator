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
LibSGui.Event.Panel.Scrollbar.Change = Utility.Event.Create("SafesGUILib", "Panel.Scrollbar.Change")
LibSGui.Event.Panel.Scrollbar.Active = Utility.Event.Create("SafesGUILib", "Panel.Scrollbar.Active")

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
		if self._object.Scrollbar then
			if self._object.Scrollbar._active then
				self._object.Scrollbar:_checkBounds()
			end
		end
	end
	panel._mask:EventAttach(Event.UI.Layout.Size, panel.SizeChangeHandler, "Panel Mask Size Change")
	panel._mask._object = panel
	
	panel.Content = panel._sunkenBorder.Content
	panel.Content._object = panel
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
		pTable.Type = "panel"
		pTable.Event = LibSGui.Event.Panel.Scrollbar
		pTable.FrameA = self._raisedBorder.Content
		pTable.FrameB = self._sunkenBorder
		return _int._addScrollbar(self, pTable)
	end
	
	panel:SetBorderWidth(4)
	return panel, panel.Content
end