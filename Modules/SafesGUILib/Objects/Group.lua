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
		if self._object.Scrollbar then
			if self._object.Scrollbar._active then
				self._object.Scrollbar:_checkBounds()
			end
		end
	end	

	group._mask = group._border._mask
	group._mask._object = group
	group._mask:EventAttach(Event.UI.Layout.Size, group.SizeChangeHandler, "Group Mask Size Change")

	group.SetBorderWidth = function(group, w, Type) group._border:SetBorderWidth(w, Type) end
	group.ClearBorderWidth = function(group, w, Type) group._border:ClearBorderWidth() end

	-- Create Content Frame	and Link to Mask
	group.Content = group._border.Content
	group.Content._object = group
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
		pTable.Type = "group"
		pTable.Event = LibSGui.Event.Group.Scrollbar
		pTable.FrameA = self._cradle
		pTable.FrameB = self._border
		return _int._addScrollbar(self, pTable)
	end
				
	return group, group.Content
end