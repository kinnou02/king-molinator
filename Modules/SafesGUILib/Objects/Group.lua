-- Group Object
-- Written by Paul Snart
-- Copyright 2013
--

local AddonDetails, LibSGui = ...
local _int = LibSGui:_internal()

local TH = _int.TH

-- Define Group Events
LibSGui.Event.Group = {}
LibSGui.Event.Group.Scrollbar = {}
LibSGui.Event.Group.Scrollbar.Change = Utility.Event.Create("SafesGUILib", "Event.Group.Scrollbar.Change")
LibSGui.Event.Group.Scrollbar.Active = Utility.Event.Create("SafesGUILib", "Event.Group.Scrollbar.Active")

-- Define Area
LibSGui.Group = {}

function LibSGui.Group:Create(title, _parent, pTable)
	pTable = pTable or {}
	
	local group = _int:buildBase("group", _parent)
	
	group.Title = title
	group._raised = pTable.Raised or false
	group._cradle:SetVisible(pTable.Visible or false)
	group._cradle:SetPoint("TOPLEFT", _parent, "TOPLEFT")
	group._cradle:SetPoint("BOTTOMRIGHT", _parent, "BOTTOMRIGHT")
	
	group._multi = 10
	group._div = 0.1 -- (1/group._multi)
	group.Offset = {
		x = 0,
		y = 0,
	}
		
	if group._raised then
		-- Create Base Raised Border
		group._border = _int:pullFrameRaised(group._cradle, true)
	else
		-- Create Base Sunken Border
		group._border = _int:pullFrameSunken(group._cradle, true)
	end
	function group:SizeChangeHandler()
		if self._group.Scrollbar then
			if self._group.Scrollbar._active then
				self._group.Scrollbar:_checkBounds()
			end
		end
	end	

	group._mask = group._border._mask
	group._mask._group = group
	group._mask:EventAttach(Event.UI.Layout.Size, group.SizeChangeHandler, "Group Mask Size Change")

	group.SetBorderWidth = function(group, w, Type) group._border:SetBorderWidth(w, Type) end
	group.ClearBorderWidth = function(group, w, Type) group._border:ClearBorderWidth() end

	-- Create Content Frame	and Link to Mask
	group.Content = group._border.Content
	group.Content._group = group
	group.Content:EventAttach(Event.UI.Layout.Size, group.SizeChangeHandler, "Group Content Size Change")
		
	function group:GetContent()
		return self.Content
	end
	
	function group:GetContentWidth()
		return self.Content:GetWidth()
	end
	
	function group:GetContentHeight()
		return self.Content:GetHeight()
	end
	
	function group:SetContentHeight(newHeight)
		if type(newHeight) == "number" then
			if newHeight > 0 then
				self.Content:ClearPoint("BOTTOM")
				self.Content:SetHeight(newHeight)
			else
				if _int._debug then
					error("[Group:SetContentHeight] Expecting a number greater than zero, got: "..tostring(newHeight))
				end
			end
		else
			if _int._debug then
				error("[Group:SetContentHeight] Expecting number, got: "..type(newHeight))
			end
		end
	end
	
	function group:AddScrollbar(pTable)
		pTable = pTable or {}
		pTable.Vertical = pTable.Vertical or true -- Defaults to Vertical (No current support for Horizontal)
		pTable.Hide = pTable.Hide or false -- Hide the scrollbar if not required, False = Disable and visible when not required, else hidden.
		pTable.Dynamic = pTable.Dynamic or false -- If Hide is enabled and Dynamic is enabled the Group will adjust the width of the Content to replace the scrollbar area.
		
		if type(self) == "table" then
			if self._type == "group" then
				if not self.Scrollbar then
					self.Scrollbar = _int:pullScrollbar(self._cradle, true)
					self.Scrollbar:SetLayer(2)
					self.Scrollbar._group = self
					self.Scrollbar._hidden = pTable.Hide
					self.Scrollbar._dynamic = pTable.Dynamic
					self.Scrollbar:SetPoint("TOPRIGHT", self._cradle, "TOPRIGHT")
					self.Scrollbar:SetPoint("BOTTOM", self._cradle, "BOTTOM")
					self._border:ClearPoint("RIGHT")
					self._border:SetPoint("RIGHT", self.Scrollbar, "LEFT", -3, nil)
					function self:MouseWheelBackHandler(handle)
						self._group.Scrollbar:Nudge(5)
					end
					function self:MouseWheelForwardHandler(handle)
						self._group.Scrollbar:Nudge(-5)
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
						local newDiff = math.floor(self._group.Content:GetHeight() - self._group._mask:GetHeight()) * self._group._div
						if newDiff ~= self._group._diff then
							self._group._diff = newDiff
							if self._group._diff > 0 then
								self:SetRange(0, self._group._diff)
								self:SetEnabled(true)
								self._group.Content:ClearPoint("TOP")
								self._group.Content:SetPoint("TOP", self._group._mask, "TOP", nil, -math.floor(self:GetPosition() * self._group._multi))
								LibSGui.Event.Group.Scrollbar.Active(self._group, true)
								self._group:_addWheelEvents()
							else
								self:SetRange(0,0)
								self:SetEnabled(false)
								if self._hidden then
									self:SetVisible(false)
									if self._dynamic then
										self._group._border:ClearPoint("RIGHT")
										self._group._border:SetPoint("RIGHT", self._group._cradle, "RIGHT")
									end
								end
								LibSGui.Event.Group.Scrollbar.Active(self._group, false)
								self._group:_removeWheelEvents()
							end
						end
					end
					function self.Scrollbar:ScrollChangeHandler(handle)
						self._group.Content:ClearPoint("TOP")
						self._group.Content:SetPoint("TOP", self._group._mask, "TOP", nil, -math.floor(self:GetPosition() * self._group._multi))
						LibSGui.Event.Group.Scrollbar.Change(self._group, self:GetPosition())
					end
					self.Scrollbar:EventAttach(Event.UI.Scrollbar.Change, self.Scrollbar.ScrollChangeHandler, "Group Scroller Change")
					self.Scrollbar._active = true
					self.Scrollbar:_checkBounds()
					return self.Scrollbar
				else
					if _int._debug then
						error("[Group:AddScrollbar] There is already a Scrollbar assigned to this Group")
					end
				end
			else
				if _int._debug then
					error("[Group:AddScrollbar] Expecting Group Object, got: "..tostring(self._type))
				end
			end
		else
			if _int._debug then
				error("[Group:AddScrollbar] Expecting Table, got: "..type(self))
			end
		end
	end
			
	return group, group.Content
end