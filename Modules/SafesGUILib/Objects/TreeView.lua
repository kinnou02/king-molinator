-- Tree View Object
-- Written by Paul Snart
-- Copyright 2013
--

local AddonIni, LibSGui = ...
local _int = LibSGui:_internal()
local LibSata = _int.LibSata

local TH = _int.TH

-- "TextBkgnd.png.dds"
-- "raid_slot_filled.png.dds"

-- Define Panel Events
LibSGui.Event.TreeView = {}
LibSGui.Event.TreeView.Scrollbar = {}
LibSGui.Event.TreeView.Scrollbar.Change = Utility.Event.Create("SafesGUILib", "Event.TreeView.Scrollbar.Change")
LibSGui.Event.TreeView.Scrollbar.Active = Utility.Event.Create("SafesGUILib", "Event.TreeView.Scrollbar.Active")
LibSGui.Event.TreeView.Node = {}
LibSGui.Event.TreeView.Node.Expand = Utility.Event.Create("SafesGUILib", "Event.TreeView.Node.Expand")
LibSGui.Event.TreeView.Node.Collapse = Utility.Event.Create("SafesGUILib", "Event.TreeView.Node.Collapse")
LibSGui.Event.TreeView.Node.Change = Utility.Event.Create("SafesGUILib", "Event.TreeView.Node.Change")
LibSGui.Event.TreeView.Node.Mouse = {}
LibSGui.Event.TreeView.Node.Mouse.In = Utility.Event.Create("SafesGUILib", "Event.TreeView.Node.Mouse.In")
LibSGui.Event.TreeView.Node.Mouse.Out = Utility.Event.Create("SafesGUILib", "Event.TreeView.Node.Mouse.Out")

-- Define Area
LibSGui.TreeView = {}

-- Defaults
local Default = {
	textBack = "artifactgroup_bg.png.dds",
	--textBack = "SortButton_Header_(Up).png.dds",
	Header = {
		fontSize = 14,
		h = 27,
		r = 0.88,
		g = 0.68,
		b = 0.25,
	},
	Node = {
		fontSize = 12,
		h = 22,
		r = 0.95,
		g = 0.95,
		b = 0.75,
	},
	spacer = 0,
}

Default.MouseOver = _int:pullTexture(_int._context, false)
Default.MouseOver:SetTexture("Rift", "TextBkgnd.png.dds")
Default.MouseOver:SetBackgroundColor(1,1,1,0.5)

local _tvNode = {}

function _int:pullNode(_parent, _id)
	local node = {}
	local Count = self.base.node:Count()
	if Count == 0 then
		_int.totals.node = _int.totals.node + 1
		node._cradle = _int:pullFrame(_parent, true)
		node._cradle._node = node
		node._id = _id
		_int.attachDefault(node)
		node:SetPoint("LEFT", _parent, "LEFT")
		node:SetPoint("RIGHT", _parent, "RIGHT")
		node._childCradle = _int:pullFrame(node._cradle, true)
		node._childCradle:SetPoint("TOP", node._cradle, "BOTTOM", nil, -1)
		node._childCradle:SetPoint("BOTTOM", node._cradle, "BOTTOM", nil, -1)
		node._childCradle:SetPoint("RIGHT", node._cradle, "RIGHT")
		node._textBack = _int:pullTexture(node._cradle, true)
		node._textBack:SetLayer(1)
		TH.LoadTexture(node._textBack, "Rift", Default.textBack)
		node._text = LibSGui.ShadowText:Create(node._cradle, true)
		node._text:SetPoint("CENTERY", node._textBack, "CENTERY", nil, 1)
		node._text:SetLayer(3)
		node._iconA = _int:pullTexture(node._cradle, true)
		node._iconA:SetLayer(3)
		node._iconA:SetWidth(16)
		node._iconA:SetHeight(16)
		node._iconA:SetAlpha(0.75)
		--node._textBack:SetAlpha(0.75)
		function node:_mouseIn()
			self:SetBackgroundColor(0.2,0.2,0,0.25)
			-- Default.MouseOver:SetParent(self)
			-- Default.MouseOver:SetVisible(true)
			-- Default.MouseOver:SetAllPoints(self)
			-- Default.MouseOver:SetLayer(2)
			LibSGui.Event.TreeView.Node.Mouse.In(self._node)
		end
		function node:_mouseOut()
			self:SetBackgroundColor(0,0,0,0)
			-- Default.MouseOver:SetParent(_int._context)
			-- Default.MouseOver:SetVisible(false)
			-- Default.MouseOver:ClearAll()
			LibSGui.Event.TreeView.Node.Mouse.Out(self._node)
		end
		function node:_mouseClick()
			local nodeObj = self._nodeObj
			local nodeUI = self._node
			local _, lastChild = nodeObj._children:Last()
			if lastChild then
				if nodeObj._expanded then
					nodeUI._childCradle:SetVisible(false)
					nodeUI._childCradle:SetPoint("BOTTOM", self, "BOTTOM", nil, -1)
					nodeUI._childCradle:SetPoint("TOP", self, "BOTTOM", nil, -1)
					nodeObj:_updateSize(-nodeObj._childSize)
					nodeObj._expanded = false
					TH.LoadTexture(nodeUI._iconA, AddonIni.id, "Media/Treeview_Arrow_Left.png")
					LibSGui.Event.TreeView.Node.Collapse(nodeObj)
				else
					nodeUI._childCradle:SetVisible(true)
					nodeUI._childCradle:SetPoint("BOTTOM", lastChild._obj._cradle, "BOTTOM", nil, -1)
					nodeUI._childCradle:SetPoint("TOP", self, "BOTTOM", nil, 0)
					nodeObj._expanded = true
					nodeObj:_updateSize(nodeObj._childSize)
					TH.LoadTexture(nodeUI._iconA, AddonIni.id, "Media/Treeview_Arrow_Down.png")
					LibSGui.Event.TreeView.Node.Expand(nodeObj)
				end
			end
		end
		node._cradle:EventAttach(Event.UI.Input.Mouse.Cursor.In, node._mouseIn, "Mouse In Handler")
		node._cradle:EventAttach(Event.UI.Input.Mouse.Cursor.Out, node._mouseOut, "Mouse Out Handler")
		node._cradle:EventAttach(Event.UI.Input.Mouse.Left.Click, node._mouseClick, "Mouse Click Handler")
		
		return node
	else
		--print("Node available in cache of "..Count)
		local nodeObj, node = self.base.node:Last()
		self.base.node:Remove(nodeObj)
		node:SetVisible(true)
		node:SetParent(_parent)
		node._id = _id
		node._cradle._node = node
		--print("New Node count is: "..self.base.node:Count())
		return node
	end	
end

function _int:pushNode()

end

function _tvNode:Create(pNode, Text, Select)
	local Node = {}
	Node._type = "node"
	Node._children = LibSata:Create()
	Node._parent = pNode._parent
	Node._parentNode = pNode
	Node._root = pNode._root
	Node._text = tostring(Text)
	Node._expanded = true
	if pNode._layer == 0 then
		Node._obj = _int:pullNode(Node._root.Content)
		Node._obj._iconA:SetPoint("CENTERLEFT", Node._obj._cradle, "CENTERLEFT", 6, 0)
		Node._obj._childCradle:SetPoint("LEFT", Node._obj._iconA, "RIGHT")
		Node._layer = 1
		Node._obj._text:SetFontSize(Default.Header.fontSize)
		Node._obj._text:SetText(Text)
		Node._obj._textBack:SetPoint("TOP", Node._obj._cradle, "TOP", nil, -2)
		Node._obj._textBack:SetPoint("BOTTOMRIGHT", Node._obj._cradle, "BOTTOMRIGHT", 0, 3)
		if pNode._children._count > 0 then
			local _, prevChild = pNode._children:Last()
			Node._obj:SetPoint("TOP", prevChild._obj._childCradle, "BOTTOM")
			Node._size = Default.Header.h
		else
			Node._obj:SetPoint("TOP", Node._root.Content, "TOP")
			Node._size = Default.Header.h
		end
		Node._obj._cradle:SetHeight(Default.Header.h)
		TH.LoadTexture(Node._obj._iconA, AddonIni.id, "Media/Treeview_Arrow_Down.png")
		Node._obj._text:SetFontColor(Default.Header.r, Default.Header.g, Default.Header.b)
		Node._obj._text:SetPoint("LEFT", Node._obj._childCradle, "LEFT", 2, nil)
		Node._obj._text:SetPoint("RIGHT", Node._obj._cradle, "RIGHT")
		Node._obj._textBack:SetPoint("LEFT", Node._obj._cradle, "LEFT", 0, nil)
	elseif pNode._layer == 1 then
		Node._obj = _int:pullNode(pNode._obj._childCradle)
		Node._obj._iconA:SetPoint("CENTERRIGHT", Node._obj._cradle, "CENTERLEFT")
		Node._layer = pNode._layer + 1
		Node._obj._text:SetFontSize(Default.Node.fontSize)
		Node._obj._text:SetText(Text)
		Node._obj._textBack:SetPoint("TOP", Node._obj._cradle, "TOP", nil, -2)
		Node._obj._textBack:SetPoint("BOTTOMRIGHT", Node._obj._cradle, "BOTTOMRIGHT", 0, 2)
		if pNode._children._count > 0 then
			local _, lastNode = pNode._children:Last()
			Node._obj:SetPoint("TOP", lastNode._obj._childCradle, "BOTTOM", nil, 1)
			Node._size = Default.Node.h
			TH.LoadTexture(Node._obj._iconA, AddonIni.id, "Media/Node_Connect_Last.png")
			TH.LoadTexture(lastNode._obj._iconA, AddonIni.id, "Media/Node_Connect_Mid.png")
		else
			Node._obj:SetPoint("TOP", pNode._obj._childCradle, "TOP")
			Node._size = Default.Node.h
			TH.LoadTexture(Node._obj._iconA, AddonIni.id, "Media/Node_Connect_Last.png")
		end
		pNode._obj._childCradle:SetPoint("TOP", pNode._obj._cradle, "BOTTOM")
		pNode._obj._childCradle:SetPoint("BOTTOM", Node._obj._childCradle, "BOTTOM")
		Node._obj._cradle:SetHeight(Default.Node.h)
		Node._obj._text:SetFontColor(Default.Node.r, Default.Node.g, Default.Node.b)
		Node._obj._text:SetPoint("LEFT", Node._obj._textBack, "LEFT", 7, nil)
		Node._obj._text:SetPoint("RIGHT", Node._obj._cradle, "RIGHT")
		Node._obj._textBack:SetPoint("LEFT", Node._obj._cradle, "LEFT", 0, nil)
	else
		error("Node Create: Child nodes do not currently support their own children.")
	end
	Node._obj._cradle._nodeObj = Node
	
	function Node:Create(Text)
		local childNode = _tvNode:Create(self, Text)
		return childNode
	end
	
	function Node:SetText()
	
	end
	
	function Node:SetFontColor()
	
	end
	
	function Node:Select()
	
	end
	
	if Select then
		Node:Select()
	end
	pNode._children:Add(Node)
	
	-- Resize Content to fit current state
	function Node:_updateSize(value)
		self._currentSize = self._currentSize + value
		if self._parentNode._layer ~= 0 then
			self._parentNode._updateSize(value)
		else
			self._root:_updateSize(value)
		end
	end
	
	function Node:_addChildSize(value)
		self._childSize = self._childSize + value
		self._currentSize = self._currentSize + value
		if self._parentNode._layer ~= 0 then
			self._parentNode:_addChildSize(value)
		else
			self._root:_updateSize(value)
		end
	end
	
	function Node:_addSize()
		if self._parentNode._layer ~= 0 then
			self._parentNode:_addChildSize(self._size)
		else
			self._root:_updateSize(self._size)
		end
	end

	Node._childSize = 0
	Node._currentSize = 0
	Node:_addSize()
		
	return Node
end

function LibSGui.TreeView:Create(_id, _parent, pTable)
	pTable = pTable or {}
	pTable.w = tonumber(pTable.w)
	pTable.h = tonumber(pTable.h)
	
	local treeview = _int:buildBase("treeview", _parent)
	
	treeview.Title = title
	treeview._cradle:SetVisible(pTable.Visible or false)
	if pTable.TOP then
		treeview._cradle:SetPoint("TOP", TOP.Frame or _parent, pTable.TOP.Location)
	else
		treeview._cradle:SetPoint("TOP", _parent, "TOP")
	end
	if pTable.LEFT then
		treeview._cradle:SetPoint("LEFT", LEFT.Frame or _parent, pTable.LEFT.Location)
	else
		treeview._cradle:SetPoint("LEFT", _parent, "LEFT")
	end
	if pTable.h then
		treeview._cradle:SetHeight(pTable.h)
	else
		treeview._cradle:SetPoint("BOTTOM", _parent, "BOTTOM")
	end
	if pTable.w then
		treeview._cradle:SetWidth(pTable.w)
	else
		treeview._cradle:SetPoint("RIGHT", _parent, "RIGHT")
	end
	treeview._parent = _parent
	treeview._children = LibSata:Create()
	treeview._layer = 0
	treeview._size = 1
	treeview._id = _id
	
	treeview._multi = 5
	treeview._div = 0.2 -- (1/treeview._multi)
	treeview.Offset = {
		x = 0,
		y = 0,
	}
	
	-- Create Node Table
	treeview._root = treeview
	
	-- Create Base Raised Border
	treeview._raisedBorder = _int:pullFrameRaised(treeview._cradle, true)
	
	-- Create Base Sunken Border
	treeview._sunkenBorder = _int:pullFrameSunken(treeview._raisedBorder.Content)
	treeview._mask = treeview._sunkenBorder._mask
	
	function treeview:SizeChangeHandler()
		if self._treeview.Scrollbar then
			if self._treeview.Scrollbar._active then
				self._treeview.Scrollbar:_checkBounds()
			end
		end
	end
	treeview._mask:EventAttach(Event.UI.Layout.Size, treeview.SizeChangeHandler, "TreeView Mask Size Change")
	treeview._mask._treeview = treeview
	
	treeview.Content = treeview._sunkenBorder.Content
	treeview.Content._treeview = treeview
	treeview.Content:EventAttach(Event.UI.Layout.Size, treeview.SizeChangeHandler, "TreeView Content Size Change")
	
	treeview.SetBorderWidth = function(treeview, w, Type) treeview._raisedBorder:SetBorderWidth(w, Type) end
	treeview.ClearBorderWidth = function(treeview, w, Type) treeview._raisedBorder:ClearBorderWidth() end
		
	function treeview:GetScrollbar()
		return treeview.Scrollbar
	end
	
	function treeview:GetContent()
		return treeview.Content()
	end
	
	function treeview:GetContentWidth()
		return treeview.Content:GetWidth()
	end
	
	function treeview:GetContentHeight()
		return treeview.Content:GetHeight()
	end
	
	function treeview:GetBoundsWidth()
		return treeview._mask:GetWidth()
	end
	
	function treeview:GetBoundsHeight()
		return treeview._mask:GetHeight()
	end
	
	function treeview:SetWidth(newWidth)
		self._cradle:ClearPoint("RIGHT")
		self._cradle:ClearPoint("LEFT")
		self._cradle:SetPoint("LEFT", self._parent, "LEFT")
		self._cradle:SetWidth(math.ceil(newWidth))
	end
	
	function treeview:SetHeight(newHeight)
		self._cradle:ClearPoint("BOTTOM")
		self._cradle:SetHeight(math.ceil(newHeight))
	end
	
	function treeview:_addScrollbar(pTable)
		pTable = pTable or {}
		pTable.Vertical = pTable.Vertical or true -- Defaults to Vertical (No current support for Horizontal)
		pTable.Hide = pTable.Hide or false -- Hide the scrollbar if not required, False = Disable and visible when not required, else hidden.
		pTable.Dynamic = pTable.Dynamic or false -- If Hide is enabled and Dynamic is enabled the TreeView will adjust the width of the Content to replace the scrollbar area.
		
		if type(self) == "table" then
			if self._type == "treeview" then
				if not self.Scrollbar then
					self.Scrollbar = _int:pullScrollbar(self._cradle, true)
					self.Scrollbar:SetLayer(2)
					self.Scrollbar._treeview = self
					self.Scrollbar._hidden = pTable.Hide
					self.Scrollbar._dynamic = pTable.Dynamic
					self.Scrollbar:SetPoint("TOPRIGHT", self._raisedBorder.Content, "TOPRIGHT")
					self.Scrollbar:SetPoint("BOTTOM", self._raisedBorder.Content, "BOTTOM")
					self._sunkenBorder:ClearPoint("RIGHT")
					self._sunkenBorder:SetPoint("RIGHT", self.Scrollbar, "LEFT", -3, nil)
					function self:MouseWheelBackHandler(handle)
						self._treeview.Scrollbar:Nudge(5)
					end
					function self:MouseWheelForwardHandler(handle)
						self._treeview.Scrollbar:Nudge(-5)
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
						local newDiff = math.floor(self._treeview.Content:GetHeight() - self._treeview._mask:GetHeight()) * self._treeview._div
						if newDiff ~= self._treeview._diff then
							self._treeview._diff = newDiff
							if self._treeview._diff > 0 then
								self:SetRange(0, self._treeview._diff)
								self:SetEnabled(true)
								self._treeview.Content:ClearPoint("TOP")
								self._treeview.Content:SetPoint("TOP", self._treeview._mask, "TOP", nil, -math.floor(self:GetPosition() * self._treeview._multi))
								LibSGui.Event.TreeView.Scrollbar.Active(self._treeview, true)
								self._treeview:_addWheelEvents()
							else
								self:SetRange(0,0)
								self:SetEnabled(false)
								if self._hidden then
									self:SetVisible(false)
									if self._dynamic then
										self._treeview._sunkenBorder:ClearPoint("RIGHT")
										self._treeview._sunkenBorder:SetPoint("RIGHT", self._treeview._raisedBorder_cradle, "RIGHT")
									end
								end
								LibSGui.Event.TreeView.Scrollbar.Active(self._treeview, false)
								self._treeview:_removeWheelEvents()
							end
						end
					end
					function self.Scrollbar:ScrollChangeHandler(handle)
						self._treeview.Content:ClearPoint("TOP")
						self._treeview.Content:SetPoint("TOP", self._treeview._mask, "TOP", nil, -math.floor(self:GetPosition() * self._treeview._multi))
						LibSGui.Event.TreeView.Scrollbar.Change(self._treeview, self:GetPosition())
					end
					self.Scrollbar:EventAttach(Event.UI.Scrollbar.Change, self.Scrollbar.ScrollChangeHandler, "TreeView Scroller Change")
					self.Scrollbar._active = true
					self.Scrollbar:_checkBounds()
					return self.Scrollbar
				else
					if _int._debug then
						error("[TreeView:AddScrollbar] There is already a Scrollbar assigned to this TreeView")
					end
				end
			else
				if _int._debug then
					error("[TreeView:AddScrollbar] Expecting TreeView Object, got: "..tostring(self._type))
				end
			end
		else
			if _int._debug then
				error("[TreeView:AddScrollbar] Expecting Table, got: "..type(self))
			end
		end
	end
	
	function treeview:_updateSize(value)
		self._size = self._size + value
		self.Content:SetHeight(self._size)
	end
	
	function treeview:Create(text)
		return _tvNode:Create(self, text)
	end
	
	treeview:SetBorderWidth(4)
	treeview._sunkenBorder:SetBorderWidth(-2)
	treeview:_addScrollbar(pTable)
	treeview.Content:ClearPoint("BOTTOM")
	--treeview.Content:SetBackgroundColor(1,0,0,0.3)
	return treeview
end