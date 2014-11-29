-- Tree View Object
-- Written by Paul Snart
-- Copyright 2013
--

local AddonIni, LibSGui = ...
local _int = LibSGui:_internal()
local LibSata = _int.LibSata

local TH = _int.TH

-- Define Panel Events
LibSGui.Event.TreeView = {}
LibSGui.Event.TreeView.Scrollbar = {}
LibSGui.Event.TreeView.Scrollbar.Change = Utility.Event.Create(AddonIni.id, "TreeView.Scrollbar.Change")
LibSGui.Event.TreeView.Scrollbar.Active = Utility.Event.Create(AddonIni.id, "TreeView.Scrollbar.Active")
LibSGui.Event.TreeView.Node = {}
LibSGui.Event.TreeView.Node.Change = Utility.Event.Create(AddonIni.id, "TreeView.Node.Change")
LibSGui.Event.TreeView.Node.Mouse = {}
LibSGui.Event.TreeView.Node.Mouse.In = Utility.Event.Create(AddonIni.id, "TreeView.Node.Mouse.In")
LibSGui.Event.TreeView.Node.Mouse.Out = Utility.Event.Create(AddonIni.id, "TreeView.Node.Mouse.Out")

-- Define Area
LibSGui.TreeView = {}

local EventIDList = {
	Collapse = true,
	Expand = true,
}

-- Defaults
local Default = {
	textBack = "artifactgroup_bg.png.dds",
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
		node._index = _int.totals.node
		_int.attachDefault(node)
		node:SetPoint("LEFT", _parent, "LEFT")
		node:SetPoint("RIGHT", _parent, "RIGHT")
		node._childCradle = _int:pullFrame(node._cradle, true)
		node._childCradle:SetPoint("BOTTOM", node._cradle, "BOTTOM", nil, -1)
		node._childCradle:SetPoint("TOP", node._cradle, "BOTTOM", nil, -2)
		node._childCradle:SetPoint("RIGHT", node._cradle, "RIGHT")
		node._textBack = _int:pullTexture(node._cradle, true)
		node._textBack:SetLayer(1)
		TH.LoadTexture(node._textBack, "Rift", Default.textBack)
		node._text = LibSGui.ShadowText:Create(node._cradle, true)
		node._text:SetPoint("CENTERY", node._textBack, "CENTERY")
		node._text:SetLayer(3)
		node._iconA = _int:pullTexture(node._cradle, true)
		node._iconA:SetLayer(3)
		node._iconA:SetWidth(16)
		node._iconA:SetHeight(16)
		node._iconA:SetAlpha(0.75)
		node._event = {}
		local idCollapse = "TreeView.Node"..node._index..".Collapse"
		local idExpand = "TreeView.Node"..node._index..".Expand"
		node._event._collapse = Utility.Event.Create(AddonIni.id, idCollapse)
		node._event._expand = Utility.Event.Create(AddonIni.id, idExpand)
		
		function node:_mouseIn()
			if self._nodeObj._enabled then
				self:SetBackgroundColor(0.2,0.2,0,0.25)
				self._nodeObj._root._currentMouseOver = self
				LibSGui.Event.TreeView.Node.Mouse.In(self._node)
			end
		end
		
		function node:_mouseOut()
			if self._nodeObj._enabled then
				self:SetBackgroundColor(0,0,0,0)
				self._nodeObj._root._currentMouseOver = nil
				LibSGui.Event.TreeView.Node.Mouse.Out(self._node)
			end
		end
		
		function node:_collapse()
			local nodeObj = self._nodeObj
			local _, lastChild = nodeObj._children:Last()
			self._childCradle:SetVisible(false)
			self._childCradle:SetPoint("BOTTOM", self._cradle, "BOTTOM", nil, -1)
			self._childCradle:SetPoint("TOP", self._cradle, "BOTTOM", nil, -2)
			nodeObj:_updateSize(-nodeObj._childSize)
			nodeObj._expanded = false
			TH.LoadTexture(self._iconA, AddonIni.id, "Media/Treeview_Arrow_Left.png")
			self._event._collapse()
			if nodeObj._root._selected then
				if nodeObj._root._selected._parentNode == nodeObj then
					nodeObj._root._highlight:SetVisible(false)
				end
			end
		end
		
		function node:_expand()
			local nodeObj = self._nodeObj
			local _, lastChild = nodeObj._children:Last()
			self._childCradle:SetVisible(true)
			self._childCradle:SetPoint("BOTTOM", lastChild._obj._cradle, "BOTTOM", nil, -1)
			self._childCradle:SetPoint("TOP", self._cradle, "BOTTOM", nil, 0)
			nodeObj._expanded = true
			nodeObj:_updateSize(nodeObj._childSize)
			TH.LoadTexture(self._iconA, AddonIni.id, "Media/Treeview_Arrow_Down.png")
			self._event._expand()
			if nodeObj._root._selected then
				if nodeObj._root._selected._parentNode == nodeObj then
					nodeObj._root._highlight:SetVisible(true)
				end
			end
		end
		
		function node:_mouseClick()
			local nodeObj = self._nodeObj
			local nodeUI = self._node
			local _, lastChild = nodeObj._children:Last()
			if self._nodeObj._enabled then
				if lastChild then
					if nodeObj._expanded then
						nodeUI:_collapse()
					else
						nodeUI:_expand()
					end
				else
					if nodeObj._root._selected ~= nodeObj then
						nodeObj:_renderHighlight()
						LibSGui.Event.TreeView.Node.Change(nodeObj._root, nodeObj)
					end
				end
			end
		end
		
		node._cradle:EventAttach(Event.UI.Input.Mouse.Cursor.In, node._mouseIn, "Mouse In Handler")
		node._cradle:EventAttach(Event.UI.Input.Mouse.Cursor.Out, node._mouseOut, "Mouse Out Handler")
		node._cradle:EventAttach(Event.UI.Input.Mouse.Left.Click, node._mouseClick, "Mouse Click Handler")	
		return node
	else
		local nodeObj, node = self.base.node:Last()
		self.base.node:Remove(nodeObj)
		node:SetVisible(true)
		node:SetParent(_parent)
		node._id = _id
		node._cradle._node = node
		return node
	end	
end

function _int:pushNode()

end

function _tvNode:Create(pNode, Text, Select, pTable)
	pTable = pTable or {}
	local Node = {}
	Node._type = "node"
	Node._children = LibSata:Create()
	Node._parent = pNode._parent
	Node._parentNode = pNode
	Node._root = pNode._root
	Node._text = tostring(Text)
	Node._visible = true
	Node._expanded = true
	Node._enabled = true
	Node.UserData = {}
	
	if pNode._layer == 0 then
		Node._obj = _int:pullNode(Node._root.Content)
		Node._obj._iconA:SetPoint("CENTERLEFT", Node._obj._cradle, "CENTERLEFT", 6, 0)
		Node._obj._childCradle:SetPoint("LEFT", Node._obj._iconA, "RIGHT")
		Node._layer = 1
		Node._obj._text:SetFontSize(Default.Header.fontSize)
		Node._obj._textBack:SetPoint("TOP", Node._obj._cradle, "TOP", nil, -2)
		Node._obj._textBack:SetPoint("BOTTOMRIGHT", Node._obj._cradle, "BOTTOMRIGHT", 0, 3)
		if pNode._children._count > 0 then
			local _, prevChild = pNode._children:Last()
			Node._obj:SetPoint("TOP", prevChild._obj._childCradle, "BOTTOM")
			Node._size = Default.Header.h - 1
		else
			Node._obj:SetPoint("TOP", Node._root.Content, "TOP")
			Node._size = Default.Header.h
		end
		Node._obj._cradle:SetHeight(Default.Header.h)
		TH.LoadTexture(Node._obj._iconA, AddonIni.id, "Media/Treeview_Arrow_Down.png")
		Node._obj._text:SetFontColor(Default.Header.r, Default.Header.g, Default.Header.b)
		Node._obj._text:SetPoint("LEFT", Node._obj._childCradle, "LEFT", 2, nil)
		Node._obj._textBack:SetPoint("LEFT", Node._obj._cradle, "LEFT", 0, nil)
		Node._obj._maxWidth = Node._obj._textBack:GetRight() - Node._obj._childCradle:GetLeft() - 3
	elseif pNode._layer == 1 then
		Node._obj = _int:pullNode(pNode._obj._childCradle)
		Node._obj._iconA:SetPoint("CENTERRIGHT", Node._obj._cradle, "CENTERLEFT")
		Node._layer = pNode._layer + 1
		Node._obj._text:SetFontSize(Default.Node.fontSize)
		Node._obj._textBack:SetPoint("TOP", Node._obj._cradle, "TOP", nil, -2)
		Node._obj._textBack:SetPoint("BOTTOMRIGHT", Node._obj._cradle, "BOTTOMRIGHT", 0, 2)
		Node._obj._textBack:SetAlpha(0.6)
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
		if pNode._expanded then
			pNode._obj._childCradle:SetPoint("BOTTOM", Node._obj._childCradle, "BOTTOM")
		end
		pNode._obj._childCradle:SetPoint("TOP", pNode._obj._cradle, "BOTTOM")
		Node._obj._cradle:SetHeight(Default.Node.h)
		Node._obj._text:SetFontColor(Default.Node.r, Default.Node.g, Default.Node.b)
		Node._obj._text:SetPoint("LEFT", Node._obj._textBack, "LEFT", 6, nil)
		Node._obj._textBack:SetPoint("LEFT", Node._obj._cradle, "LEFT", 0, nil)
		Node._obj._maxWidth = Node._obj._textBack:GetRight() - Node._obj._textBack:GetLeft() - 5
	else
		error("Node Create: Child nodes do not currently support their own children.")
	end
	
	Node._obj._cradle._nodeObj = Node
	Node._obj._nodeObj = Node
	
	function Node:Create(Text)
		local childNode = _tvNode:Create(self, Text)
		return childNode
	end
	
	function Node:Collapse()
		if self._expanded then
			self._obj:_collapse()
		end
	end
	
	function Node:Expand()
		if not self._expanded then
			self._obj:_expand()
		end
	end
	
	function Node:SetCollapsed(bool)
		if bool then
			if self._expanded then
				self._obj:_collapse()
			end
		else
			if not self._expanded then
				self._obj:_expand()
			end
		end
	end
	
	function Node:SetText(Text)
		self._obj._text:SetText(Text)
		if self._obj._text:GetWidth() > self._obj._maxWidth then
			self._obj._text:SetText(self._obj._text:GetText().."...")
			local start = Inspect.Time.Real()
			repeat
				local newText = string.sub(self._obj._text:GetText(), 1, -5)
				if string.byte(newText, -1) == 32 then
					newText = string.sub(newText, 1, -2)
				end
				self._obj._text:SetText(newText.."...")
				if Inspect.Time.Real() - start > 1 then
					break
				end
			until self._obj._text:GetWidth() < self._obj._maxWidth
		end
		self._text = Text
	end
	
	function Node:EventAttach(EventID, Callback, Label)
		if EventIDList[EventID] then
			Command.Event.Attach(Event[AddonIni.id].TreeView["Node"..self._obj._index][EventID], function() Callback(self) end, Label or "Node Event")
		else
			error("Unknown event ID for Node:EventAttach - "..tostring(EventID))
		end
	end
	
	function Node:GetText()
		return self._text
	end
	
	function Node:SetFontColor()
	
	end
	
	function Node:_renderHighlight()
		self._root._selected = self
		self._root._highlight:ClearAll()
		self._root._highlight:SetPoint("TOPLEFT", self._obj._textBack, "TOPLEFT", 1, 1)
		self._root._highlight:SetPoint("BOTTOMRIGHT", self._obj._textBack, "BOTTOMRIGHT", -2, 0)
		self._root._highlight:SetVisible(self._parentNode._expanded)
	end
	
	function Node:Select()
		self._root._selected = self
		self:_renderHighlight()
	end
	
	function Node:SetEnabled(bool)
		self._enabled = bool
		if bool then
			self._obj:SetAlpha(1)
		else
			self._obj:SetAlpha(0.5)
		end
	end
		
	if Select then
		Node:Select()
	end
	pNode._children:Add(Node)
	
	-- Resize Content to fit current state
	function Node:_updateSize(value)
		self._currentSize = self._currentSize + value
		if self._parentNode._layer ~= 0 then
			if self._expanded then
				self._parentNode._updateSize(value)
			end
		else
			if self._expanded then
				self._root:_updateSize(value)
			end
		end
	end
	
	function Node:_addChildSize(value)
		self._childSize = self._childSize + value
		self._currentSize = self._currentSize + value
		if self._parentNode._layer ~= 0 then
			self._parentNode:_addChildSize(value)
		else
			if self._expanded then
				self._root:_updateSize(value)
			end
		end
	end
	
	function Node:_addSize()
		if self._parentNode._layer ~= 0 then
			self._parentNode:_addChildSize(self._size)
		else
			if self._expanded then
				self._root:_updateSize(self._size)
			end
		end
	end

	Node._childSize = 0
	Node._currentSize = 0
	Node:_addSize()
	Node:SetText(Text)
	if pTable.Collapse then
		Node:Collapse()
	end
		
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
	treeview.UserData = {}
		
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
		if self._object.Scrollbar then
			if self._object.Scrollbar._active then
				self._object.Scrollbar:_checkBounds()
			end
		end
	end
	treeview._mask:EventAttach(Event.UI.Layout.Size, treeview.SizeChangeHandler, "TreeView Mask Size Change")
	treeview._mask._object = treeview
	
	treeview.Content = treeview._sunkenBorder.Content
	treeview.Content._object = treeview
	treeview.Content:ClearPoint("BOTTOM")
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
		pTable.Type = "treeview"
		pTable.Event = LibSGui.Event.TreeView.Scrollbar
		pTable.FrameA = self._raisedBorder.Content
		pTable.FrameB = self._sunkenBorder
		return _int._addScrollbar(self, pTable)
	end
		
	function treeview:_updateSize(value)
		self._size = self._size + value
		self.Content:SetHeight(self._size)
	end
	
	function treeview:Create(text, pTable)
		return _tvNode:Create(self, text, nil, pTable)
	end
	
	function treeview:ClearSelected()
		self._selected = nil
		self._highlight:SetVisible(false)
	end
	
	-- Unique Highlight texture for selected Node
	treeview._highlight = _int:pullTexture(treeview.Content)
	treeview._highlight:SetTexture("Rift", "Results_downSelected.png.dds")
	treeview._highlight:SetLayer(10)
	
	treeview:SetBorderWidth(4)
	treeview._sunkenBorder:SetBorderWidth(-2)
	treeview:_addScrollbar(pTable)
	--treeview.Content:SetBackgroundColor(1,0,0,0.3)
	return treeview
end