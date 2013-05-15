-- Scrollbar Object
-- Written by Paul Snart
-- Copyright 2013
--

local AddonDetails, LibSGui = ...
local _int = LibSGui:_internal()

local TH = _int.TH

-- Define Area
LibSGui.Scrollbar = {}

function LibSGui:CreateScrollbar()

end

function _int._addScrollbar(self, pTable)
	pTable = pTable or {}
	pTable.Vertical = pTable.Vertical or true -- Defaults to Vertical (No current support for Horizontal)
	pTable.Hide = pTable.Hide or false -- Hide the scrollbar if not required, False = Disable and visible when not required, else hidden.
	pTable.Dynamic = pTable.Dynamic or false -- If Hide is enabled and Dynamic is enabled the Group will adjust the width of the Content to replace the scrollbar area.
	pTable.Type = pTable.Type or ""
	pTable.Event = pTable.Event or {}
	
	if type(self) == "table" then
		if self._type == pTable.Type then
			if not self.Scrollbar then
				self.Scrollbar = _int:pullScrollbar(self._cradle, true)
				self.Scrollbar:SetLayer(2)
				self.Scrollbar._frameA = pTable.FrameA
				self.Scrollbar._frameB = pTable.FrameB
				self.Scrollbar._event = pTable.Event
				self.Scrollbar._object = self
				self.Scrollbar._hidden = pTable.Hide
				self.Scrollbar._dynamic = pTable.Dynamic
				self.Scrollbar:SetPoint("TOPRIGHT", pTable.FrameA, "TOPRIGHT")
				self.Scrollbar:SetPoint("BOTTOM", pTable.FrameA, "BOTTOM")
				pTable.FrameB:ClearPoint("RIGHT")
				pTable.FrameB:SetPoint("RIGHT", self.Scrollbar, "LEFT", -3, nil)
				function self:MouseWheelBackHandler(handle)
					self._object.Scrollbar:Nudge(5)
				end
				function self:MouseWheelForwardHandler(handle)
					self._object.Scrollbar:Nudge(-5)
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
					local newDiff = math.floor(self._object.Content:GetHeight() - self._object._mask:GetHeight()) * self._object._div
					if newDiff ~= self._object._diff then
						self._object._diff = newDiff
						if self._object._diff > 0 then
							self:SetRange(0, self._object._diff)
							self:SetEnabled(true)
							if self._hidden then
								self:SetVisible(true)
								if self._dynamic then
									self._frameB:ClearPoint("RIGHT")
									self._frameB:SetPoint("RIGHT", self, "LEFT", -3, nil)
								end
							end
							self._object.Content:ClearPoint("TOP")
							self._object.Content:SetPoint("TOP", self._object._mask, "TOP", nil, -math.floor(self:GetPosition() * self._object._multi))
							self._event.Active(self._object, true)
							self._object:_addWheelEvents()
						else
							self:SetRange(0,0)
							self:SetEnabled(false)
							if self._hidden then
								self:SetVisible(false)
								if self._dynamic then
									self._frameB:ClearPoint("RIGHT")
									self._frameB:SetPoint("RIGHT", self._frameA, "RIGHT")
								end
							end
							self._event.Active(self._object, false)
							self._object:_removeWheelEvents()
						end
					end
				end
				function self.Scrollbar:ScrollChangeHandler(handle)
					self._object.Content:ClearPoint("TOP")
					self._object.Content:SetPoint("TOP", self._object._mask, "TOP", nil, -math.floor(self:GetPosition() * self._object._multi))
					self._event.Change(self._object, self:GetPosition())
				end
				self.Scrollbar:EventAttach(Event.UI.Scrollbar.Change, self.Scrollbar.ScrollChangeHandler, self._type.." Scroller Change")
				self.Scrollbar._active = true
				self.Scrollbar:_checkBounds()
				return self.Scrollbar
			else
				if _int._debug then
					error("["..pTable.Type..":AddScrollbar] There is already a Scrollbar assigned to this Group")
				end
			end
		else
			if _int._debug then
				error("["..pTable.Type..":AddScrollbar] Expecting "..pTable.Type.." Object, got: "..tostring(self._type))
			end
		end
	else
		if _int._debug then
			error("["..pTable.Type..":AddScrollbar] Expecting Table, got: "..type(self))
		end
	end

end