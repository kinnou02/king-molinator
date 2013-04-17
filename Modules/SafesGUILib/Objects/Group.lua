-- Group Object
-- Written by Paul Snart
-- Copyright 2013
--

local AddonDetails, LibSGui = ...
local _int = LibSGui:_internal()

local TH = _int.TH

-- Define Group Events
LibSGui.Event.Group = {}

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
	
	-- Create Mask for Group Content
	group._mask = _int:pullMask(group._cradle, true)
	group._mask:SetLayer(3)
	group._mask:SetPoint("TOPLEFT", group._cradle, "TOPLEFT", 3, 2)
	group._mask:SetPoint("BOTTOMRIGHT", group._cradle, "BOTTOMRIGHT", -3, -2)
	group._mask._group = group
	
	-- Create Content Frame	and Link to Mask
	group.Content = _int:pullFrame(panel._mask, true)
	group.Content:SetPoint("TOPLEFT", panel._mask, "TOPLEFT")
	group.Content:SetPoint("BOTTOMRIGHT", panel._mask, "BOTTOMRIGHT")
	group.Content._panel = panel
		
	function group:GetContent()
		return group.Content()
	end
	
	function group:GetContentWidth()
		return group.Content:GetWidth()
	end
	
	function group:GetContentHeight()
		return group.Content:GetHeight()
	end
		
	function group:SetWidth(newWidth)
		
	end
	
	function group:SetHeight(newHeight)
	
	end
	
	return group, group.Content
end