-- Safe's GUI Library
-- Written By Paul Snart
-- Copyright 2012
--
--
-- To access this from within your Add-on.
--
-- In your RiftAddon.toc
-- ---------------------
-- Embed: SafesGUILib
-- Dependency: SafesGUILib, {"required", "before"}
--
-- In your Add-on's initialization
-- -------------------------------
-- local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local AddonIni, LibSGui = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data

local KBMTH_AddonDetails = Inspect.Addon.Detail("KBMTextureHandler")
local TH = KBMTH_AddonDetails.data

LibSGui.Event = {}
LibSGui.Frame = {}
LibSGui.Text = {}
LibSGui.Texture = {}
LibSGui.ShadowText = {}

local _int = {
	_context = UI.CreateContext("LibSGui_Parking_Context"),
	_debug = true,
	TH = TH,
	base = {
		frame = LibSata:Create(),
		texture = LibSata:Create(),
		scrollbar = LibSata:Create(),
		slider = LibSata:Create(),
		button = LibSata:Create(),
		checkbox = LibSata:Create(),
		window = LibSata:Create(),
		frameRaised = LibSata:Create(),
		frameSunken = LibSata:Create(),
		mask = LibSata:Create(),
		text = LibSata:Create(),
		textfield = LibSata:Create(),
		node = LibSata:Create(),
		shadowtext = LibSata:Create(),
	},
	objects = {
		window = LibSata:Create(),
		checkbox = LibSata:Create(),
		scrollbar = LibSata:Create(),
		group = LibSata:Create(),
		panel = LibSata:Create(),
		tabber = LibSata:Create(),
		dropdown = LibSata:Create(),
		treeview = LibSata:Create(),
		listview = LibSata:Create(),
		sliderex = LibSata:Create(),
	},
	panelDefault = {
		raised = {
			x = 4,
			y = 4,
			alpha = 0.35,
		},
		sunken = {
			x = 3,
			y = 3,
			alpha = 0.55,
		},
	},
	textures = {
		-- Raised
		raised = {
			TOPLEFT = "Media/Group_TL_raise.png",
			TOPRIGHT = "Media/Group_TR_raise.png",
			TOP = "Media/Group_T_raise.png",
			LEFT = "Media/Group_L_raise.png",
			MIDDLE = "Media/Group_M_raise.png",
			RIGHT = "Media/Group_R_raise.png",
			BOTTOMLEFT = "Media/Group_BL_raise.png",
			BOTTOM = "Media/Group_B_raise.png",
			BOTTOMRIGHT= "Media/Group_BR_raise.png",
		},
		-- Sunken
		sunken = {
			TOPLEFT = "Media/Group_TL_normal.png",
			TOPRIGHT = "Media/Group_TR_normal.png",
			TOP = "Media/Group_T_normal.png",
			LEFT = "Media/Group_L_normal.png",
			MIDDLE = "Media/Group_M_normal.png",
			RIGHT = "Media/Group_R_normal.png",
			BOTTOMLEFT = "Media/Group_BL_normal.png",
			BOTTOM = "Media/Group_B_normal.png",
			BOTTOMRIGHT = "Media/Group_BR_normal.png",
		},
	},
	totals = {},
	LibSata = LibSata,
}

for n, t in pairs(_int.base) do
	_int.totals[n] = 0
end

-- Enviroment Tracking and Management
_int._context:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
_int._context:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT")
_int.env = {
	w = UIParent:GetWidth() or 0,
	h = UIParent:GetHeight() or 0,
}
function _int._context.Event.Size()
	_int.env.w = UIParent:GetWidth()
	_int.env.h = UIParent:GetHeight()
end

local _typeList = {
	["window"] = {
		w = 400,
		h = 400,
	},
	["checkbox"] = {
	},
	["scrollbar"] = {
	},
	["group"] = {
	},
	["panel"] = {
	},
	["tabber"] = {
		w = 128,
		h = 32,
	},
	["listview"] = {
	},
	["treeview"] = {
	},
	["dropdown"] = {
	},
	["sliderex"] = {
	},
}

function _int.renderPanel(panel, Type)
	-- Initialize top section.
	panel.TopLeft = _int:pullTexture(panel._cradle, true)
	TH.LoadTexture(panel.TopLeft, AddonIni.id, _int.textures[Type].TOPLEFT)
	panel.TopLeft:SetPoint("TOPLEFT", panel._cradle, "TOPLEFT")
	panel.TopLeft:SetAlpha(_int.panelDefault[Type].alpha)
	panel.TopRight = _int:pullTexture(panel._cradle, true)
	TH.LoadTexture(panel.TopRight, AddonIni.id, _int.textures[Type].TOPRIGHT)
	panel.TopRight:SetPoint("TOPRIGHT", panel._cradle, "TOPRIGHT")
	panel.TopRight:SetAlpha(_int.panelDefault[Type].alpha)
	panel.Top = _int:pullTexture(panel._cradle, true)
	TH.LoadTexture(panel.Top, AddonIni.id, _int.textures[Type].TOP)
	panel.Top:SetPoint("TOPLEFT", panel.TopLeft, "TOPRIGHT")
	panel.Top:SetPoint("BOTTOMRIGHT", panel.TopRight, "BOTTOMLEFT")
	panel.Top:SetAlpha(_int.panelDefault[Type].alpha)
	
	-- Initial bottom section.
	panel.BottomLeft = _int:pullTexture(panel._cradle, true)
	TH.LoadTexture(panel.BottomLeft, AddonIni.id, _int.textures[Type].BOTTOMLEFT)
	panel.BottomLeft:SetPoint("BOTTOMLEFT", panel._cradle, "BOTTOMLEFT")
	panel.BottomLeft:SetAlpha(_int.panelDefault[Type].alpha)
	panel.BottomRight = _int:pullTexture(panel._cradle, true)
	TH.LoadTexture(panel.BottomRight, AddonIni.id, _int.textures[Type].BOTTOMRIGHT)
	panel.BottomRight:SetPoint("BOTTOMRIGHT", panel._cradle, "BOTTOMRIGHT")
	panel.BottomRight:SetAlpha(_int.panelDefault[Type].alpha)
	panel.Bottom = _int:pullTexture(panel._cradle, true)
	TH.LoadTexture(panel.Bottom, AddonIni.id, _int.textures[Type].BOTTOM)
	panel.Bottom:SetPoint("TOPLEFT", panel.BottomLeft, "TOPRIGHT")
	panel.Bottom:SetPoint("BOTTOMRIGHT", panel.BottomRight, "BOTTOMLEFT", 0, 0.5)
	panel.Bottom:SetAlpha(_int.panelDefault[Type].alpha)

	-- Line up Left and Right, and fill middle section.
	panel.Left = _int:pullTexture(panel._cradle, true)
	TH.LoadTexture(panel.Left, AddonIni.id, _int.textures[Type].LEFT)
	panel.Left:SetPoint("TOPLEFT", panel.TopLeft, "BOTTOMLEFT")
	panel.Left:SetPoint("BOTTOMRIGHT", panel.BottomLeft, "TOPRIGHT", 0, 0.5)
	panel.Left:SetAlpha(_int.panelDefault[Type].alpha)
	panel.Right = _int:pullTexture(panel._cradle, true)
	TH.LoadTexture(panel.Right, AddonIni.id, _int.textures[Type].RIGHT)
	panel.Right:SetPoint("TOPLEFT", panel.TopRight, "BOTTOMLEFT")
	panel.Right:SetPoint("BOTTOMRIGHT", panel.BottomRight, "TOPRIGHT", 0, 0.5)
	panel.Right:SetAlpha(_int.panelDefault[Type].alpha)
	panel.Middle = _int:pullTexture(panel._cradle, true)
	TH.LoadTexture(panel.Middle, AddonIni.id, _int.textures[Type].MIDDLE)
	panel.Middle:SetPoint("TOPLEFT", panel.Top, "BOTTOMLEFT")
	panel.Middle:SetPoint("BOTTOMRIGHT", panel.Bottom, "TOPRIGHT", 0, 0.5)
	panel.Middle:SetAlpha(_int.panelDefault[Type].alpha)
	
	-- Content Mask
	panel._mask = _int:pullMask(panel._cradle, true)
	panel._mask:SetLayer(3)
	panel._mask:SetPoint("TOPLEFT", panel._cradle, "TOPLEFT", _int.panelDefault[Type].x, _int.panelDefault[Type].y)
	panel._mask:SetPoint("BOTTOMRIGHT", panel._cradle, "BOTTOMRIGHT", -_int.panelDefault[Type].x, -_int.panelDefault[Type].y)
	
	-- Content Frame
	panel.Content = _int:pullFrame(panel._mask, true)
	panel.Content:SetAllPoints(panel._mask)

	function panel:SetBorderWidth(w, borderType)
		if type(w) == "number" then
			--w = math.abs(w)
			wX = w + _int.panelDefault[Type].x
			wY = w + _int.panelDefault[Type].y
			if borderType == "TOP" or borderType == "BOTTOM" then
				self._mask:ClearPoint(borderType)
				if borderType == "TOP" then
					self._mask:SetPoint("TOP", self._cradle, "TOP", nil, wY)
				else
					self._mask:SetPoint("BOTTOM", self._cradle, "BOTTOM", nil, -wY)				
				end
			elseif borderType == "LEFT" or borderType == "RIGHT" then
				self._mask:ClearPoint(borderType)
				if borderType == "LEFT" then
					self._mask:SetPoint("LEFT", self._cradle, "LEFT", wX, nil)
				else
					self._mask:SetPoint("RIGHT", self._cradle, "RIGHT", -wX, nil)				
				end
			elseif borderType == "TOPBOTTOM" then
				self._mask:ClearPoint("TOP")
				self._mask:ClearPoint("BOTTOM")
				self._mask:SetPoint("TOP", self._cradle, "TOP", nil, wY)
				self._mask:SetPoint("BOTTOM", self._cradle, "BOTTOM", nil, -wY)
			elseif borderType == "LEFTRIGHT" then
				self._mask:ClearPoint("LEFT")
				self._mask:ClearPoint("RIGHT")
				self._mask:SetPoint("LEFT", self._cradle, "LEFT", wX, nil)
				self._mask:SetPoint("RIGHT", self._cradle, "RIGHT", -wX, nil)
			elseif borderType == "TOPLEFT" or borderType == "BOTTOMRIGHT" then
				self._mask:ClearPoint(borderType)
				if borderType == "TOPLEFT" then
					self._mask:SetPoint("TOPLEFT", self._cradle, "TOPLEFT", wX, wY)
				else
					self._mask:SetPoint("BOTTOMRIGHT", self._cradle, "BOTTOMRIGHT", -wX, -wY)		
				end
			elseif not borderType then
				self._mask:ClearAll()
				self._mask:SetPoint("TOPLEFT", self._cradle, "TOPLEFT", wX, wY)
				self._mask:SetPoint("BOTTOMRIGHT", self._cradle, "BOTTOMRIGHT", -wX, -wY)
			end
		end
	end
	function panel:ClearBorderWidth()
		self._mask:ClearAll()
		self._mask:SetPoint("TOPLEFT", self._cradle, "TOPLEFT", _int.panelDefault[Type].x, _int.panelDefault[Type].y)
		self._mask:SetPoint("BOTTOMRIGHT", self._cradle, "BOTTOMRIGHT", -_int.panelDefault[Type].x, -_int.panelDefault[Type].y)
	end
end

function _int:pullFrameRaised(_parent)
	local frameRaised = {}
	local Count = self.base.frameRaised:Count()
	if Count == 0 then
		-- Create Cradle
		frameRaised._cradle = _int:pullFrame(_parent, true)
		frameRaised._cradle:SetAllPoints(_parent)
		_int.attachDefault(frameRaised)
		
		-- Raised Section
		_int.renderPanel(frameRaised, "raised")
		return frameRaised
	else
		--print("Frame Raised available in cache of "..Count)
		local frameObj, frameRaised = self.base.frameRaised:Last()
		self.base.frame:Remove(frameObj)
		
		frameRaised._cradle:ClearAll()
		frameRaised._cradle:SetAllPoints(_parent)
				
		--print("New Frame Raised count is: "..self.base.frameRaised:Count())
		return frameRaised
	end
end

function _int:pushFrameRaised(frameRaised)
	if type(frameRaised) == "table" then
		for frameName, Frame in pairs(frameRaised) do
			frame:SetVisible(false)
			frame:ClearAll()
			frame:SetParent(self._context)
			frame:SetLayer(1)
		end
		self.base.frame:Add(frameRaised)
		--print("Frame Raised added to cache: Total available = "..self.base.frameRaised:Count())
	else
		if _int._debug then
			error("No Frame Raised Group supplied in: _int:pushFrameRaised(frameRaised)")
		end
	end
end

function _int:pullFrameSunken(_parent)
	local frameSunken = {}
	local Count = self.base.frameSunken:Count()
	if Count == 0 then
		-- Create Cradle
		frameSunken._cradle = _int:pullFrame(_parent, true)
		frameSunken._cradle:SetAllPoints(_parent)
		_int.attachDefault(frameSunken)
		
		-- Sunken Panel
		_int.renderPanel(frameSunken, "sunken")

		return frameSunken
	else
		--print("Frame Raised available in cache of "..Count)
		local frameObj, frameSunken = self.base.frameSunken:Last()
		self.base.frame:Remove(frameObj)
		
		frameSunken._cradle:ClearAll()
		frameSunken._cradle:SetAllPoints(_parent)
			
		--print("New Frame Raised count is: "..self.base.frameSunken:Count())
		return frameSunken
	end
end

function _int:pushframeSunken(frameSunken)
	if type(frameSunken) == "table" then
		for frameName, Frame in pairs(frameSunken) do
			frame:SetVisible(false)
			frame:ClearAll()
			frame:SetParent(self._context)
			frame:SetLayer(1)
		end
		self.base.frame:Add(frameSunken)
		--print("Frame Raised added to cache: Total available = "..self.base.frameSunken:Count())
	else
		if _int._debug then
			error("No Frame Raised Group supplied in: _int:pushframeSunken(frameSunken)")
		end
	end
end

function LibSGui.Frame:Create(_parent, _visible)
	return _int:pullFrame(_parent, _visible)
end

function _int:pullFrame(_parent, _visible)
	local frame
	local Count = self.base.frame:Count()
	if Count == 0 then
		_int.totals.frame = _int.totals.frame + 1
		frame = UI.CreateFrame("Frame", "LibSGui_Frame_".._int.totals.frame, _parent)
		frame:SetVisible(_visible or false)
		return frame
	else
		--print("Frame available in cache of "..Count)
		local frameObj, frame = self.base.frame:Last()
		self.base.frame:Remove(frameObj)
		frame:SetVisible(_visible or false)
		frame:SetParent(_parent)
		--print("New Frame count is: "..self.base.frame:Count())
		return frame
	end
end

function _int:pushFrame(frame)
	if frame then
		frame:SetVisible(false)
		frame:SetBackgroundColor(0,0,0,0)
		frame:ClearAll()
		frame:SetParent(self._context)
		frame:SetLayer(1)
		self.base.frame:Add(frame)
		--print("Frame added to cache: Total available = "..self.base.frame:Count())
	else
		if _int._debug then
			error("No Frame supplied in: _int:pushFrame(frame)")
		end
	end
end

function _int:pullText(_parent, _visible)
	local text
	local Count = self.base.text:Count()
	if Count == 0 then
		_int.totals.text = _int.totals.text + 1
		text = UI.CreateFrame("Text", "LibSGui_Text_".._int.totals.text, _parent)
		text:SetVisible(_visible or false)
		return text
	else
		--print("Text available in cache of "..Count)
		local textObj, text = self.base.text:Last()
		self.base.text:Remove(frameObj)
		text:SetVisible(_visible or false)
		text:SetParent(_parent)
		text:SetText("")
		--print("New Text count is: "..self.base.text:Count())
		return text
	end
end

function _int:pushText(text)
	if text then
		text:SetVisible(false)
		text:SetBackgroundColor(0,0,0,0)
		text:ClearAll()
		text:SetParent(self._context)
		text:SetLayer(1)
		self.base.text:Add(text)
		--print("Text added to cache: Total available = "..self.base.text:Count())
	else
		if _int._debug then
			error("No Text Frame supplied in: _int:pushText(text)")
		end
	end
end

function LibSGui.Text:Create(_parent, _visible)
	return _int:pullText(_parent, _visible)
end

function LibSGui.ShadowText:Create(_parent, _visible)
	local st = {}
	st._cradle = _int:pullText(_parent, _visible)
	st._cradle:SetFontColor(0,0,0)
	st.Text = _int:pullText(st._cradle, true)
	st.Text:SetPoint("TOP", st._cradle, "TOP", nil, -1)
	st.Text:SetPoint("LEFT", st._cradle, "LEFT", -1, nil)
	st.Text:SetPoint("RIGHT", st._cradle, "RIGHT", -1, nil)
	st.Text:SetPoint("BOTTOM", st._cradle, "BOTTOM", nil, -1)
	_int.attachDefault(st)
	function st:SetText(Text)
		self._cradle:SetText(Text)
		self.Text:SetText(Text)
	end
	function st:SetFontColor(...)
		self.Text:SetFontColor(...)
	end
	function st:SetFontSize(s)
		self._cradle:SetFontSize(s)
		self.Text:SetFontSize(s)
	end
	function st:GetText()
		return self._cradle:GetText()
	end
	return st
end

function _int:pullMask(_parent, _visible)
	local mask
	local Count = self.base.mask:Count()
	if Count == 0 then
		_int.totals.mask = _int.totals.mask + 1
		mask = UI.CreateFrame("Mask", "LibSGui_Frame_".._int.totals.mask, _parent)
		mask:SetVisible(_visible or false)
		return mask
	else
		--print("Mask available in cache of "..Count)
		local maskObj, mask = self.base.mask:Last()
		self.base.mask:Remove(maskObj)
		mask:SetVisible(_visible or false)
		mask:SetParent(_parent)
		--print("New Mask count is: "..self.base.mask:Count())
		return mask
	end
end

function _int:pushMask(mask)
	if mask then
		mask:SetVisible(false)
		mask:ClearAll()
		mask:SetParent(self._context)
		mask:SetLayer(1)
		self.base.mask:Add(mask)
		--print("Mask added to cache: Total available = "..self.base.mask:Count())
	else
		if _int._debug then
			error("No Mask supplied in: _int:pushMask(mask)")
		end
	end
end

function _int:pullScrollbar(_parent, _visible)
	local scrollbar
	local Count = self.base.scrollbar:Count()
	if Count == 0 then
		_int.totals.scrollbar = _int.totals.scrollbar + 1
		scrollbar = UI.CreateFrame("RiftScrollbar", "LibSGui_Scrollbar_".._int.totals.scrollbar, _parent)
		scrollbar:SetVisible(_visible or false)
		return scrollbar
	else
		--print("Scrollbar available in cache of "..Count)
		local scrollbarObj, scrollbar = self.base.scrollbar:Last()
		self.base.scrollbar:Remove(scrollbarObj)
		scrollbar:SetVisible(_visible or false)
		scrollbar:SetParent(_parent)
		--print("New Scrollbar count is: "..self.base.scrollbar:Count())
		return scrollbar
	end
end

function _int:pushScrollbar(scrollbar)
	if scrollbar then
		scrollbar:SetVisible(false)
		scrollbar:ClearAll()
		scrollbar:SetParent(self._context)
		scrollbar:SetLayer(1)
		self.base.scrollbar:Add(mask)
		--print("Scrollbar added to cache: Total available = "..self.base.scrollbar:Count())
	else
		if _int._debug then
			error("No Scrollbar supplied in: _int:pushScrollbar(scrollbar)")
		end
	end
end

function _int:pullTexture(_parent, _visible)
	local texture
	local Count = self.base.texture:Count()
	if Count == 0 then
		_int.totals.texture = _int.totals.texture + 1
		texture = UI.CreateFrame("Texture", "LibSGui_Texture_".._int.totals.texture, _parent)
		texture:SetVisible(_visible or false)
		return texture
	else
		--print("Texture available in cache of "..Count)
		local textureObj, texture = self.base.texture:Last()
		self.base.texture:Remove(textureObj)
		texture:SetVisible(_visible or false)
		texture:SetParent(_parent)
		--print("New Texture count is: "..self.base.texture:Count())
		return texture
	end
end

function _int:pushTexture(texture)
	if texture then
		texture:SetVisible(false)
		texture:ClearAll()
		texture:SetParent(self._context)
		texture:SetLayer(1)
		texture:SetTexture()
		self.base.texture:Add(texture)
		--print("Texture added to cache: Total available = "..self.base.frame:Count())
	else
		if _int._debug then
			error("No Texture supplied in: _int:pushTexture(texture)")
		end
	end
end

function LibSGui.Texture:Create(_parent, _visible)
	return _int:pullTexture(_parent, _visible)
end

function _int:pullButton(_parent)
	local button
	local Count = self.base.button:Count()
	if Count == 0 then
		_int.totals.button = _int.totals.button + 1
		button = UI.CreateFrame("RiftButton", "LibSGui_Button_".._int.totals.button, _parent)
		return button
	else
		--print("Button available in cache of "..Count)
		local buttonObj, button = self.base.button:Last()
		self.base.button:Remove(buttonObj)
		button:SetParent(_parent)
		--print("New Button count is: "..self.base.button:Count())
		return button
	end
end

function _int:pushButton(button)
	if button then
		button:ClearAll()
		button:SetParent(self._context)
		button:SetSkin("default")
		button:SetLayer(1)
		self.base.button:Add(button)
		--print("Button added to cache: Total available = "..self.base.button:Count())
	else
		if _int._debug then
			error("No window supplied in: _int:pushWindow(window)")
		end
	end
end

function _int.attachDefault(base)
	function base:SetWidth(w)
		self._cradle:SetWidth(w)
	end
	function base:SetHeight(h)
		self._cradle:SetHeight(h)
	end
	function base:SetPoint(...)
		self._cradle:SetPoint(...)
	end
	function base:ClearPoint(p)
		self._cradle:ClearPoint(p)
	end
	function base:ClearWidth()
		self._cradle:ClearWidth()
	end
	function base:ClearHeight()
		self._cradle:ClearHeight()
	end
	function base:SetBackgroundColor(...)
		self._cradle:SetBackgroundColor(...)
	end
	function base:SetAlpha(a)
		self._cradle:SetAlpha(a)
	end
	function base:SetAllPoints(frame)
		if frame then
			if type(frame) == "table" then
				if frame._cradle then
					self._cradle:SetAllPoints(frame._cradle)
				else
					self._cradle:SetAllPoints(frame)
				end
			end
		else
			self._cradle:SetAllPoints()
		end
	end
	function base:GetWidth()
		return self._cradle:GetWidth()
	end
	function base:GetHeight()
		return self._cradle:GetHeight()
	end
	function base:GetTop()
		return self._cradle:GetTop()
	end
	function base:GetBottom()
		return self._cradle:GetBottom()
	end
	function base:GetLeft()
		return self._cradle:GetLeft()
	end
	function base:GetRight()
		return self._cradle:GetRight()
	end
	function base:SetVisible(bool)
		self._cradle:SetVisible(bool)
	end
	function base:SetLayer(layer)
		self._cradle:SetLayer(layer)
	end
end

function _int:buildBase(_type, _parent)
	if type(_type) == "string" then
		if _typeList[_type] then
			local base = {
				x = _typeList[_type].x or false,
				y = _typeList[_type].y or false,
				w = _typeList[_type].w or false,
				h = _typeList[_type].h or false,
				offsetX = 0,
				offsetY = 0,
				_cradle = self:pullFrame(_parent),
				_type = _type,
				_active = false,
				_drag = false,
				User = {},
				_callbacks = {},
			}
			base._cradle.base = base
			if base.w then
				base._cradle:SetWidth(base.w)
			end
			if base.h then
				base._cradle:SetHeight(base.h)
			end
			_int.attachDefault(base)
			
			return base
		else
			if _int._debug then
				print("Error: Available GUI types are as follows (Case sensitive);")
				for _id, _table in pairs(_typeList) do
					print(_id)
				end
				error("Expeting a valid GUI string:\nGot: "..tostring(_type))
			end
		end
	else
		if _int._debug then
			print("Error: _int:buildBase(string _type)")
			error("Expeting _type to be of type 'string'\nGot :"..type(_type))
		end
	end
end


function LibSGui:Debug()
	_int._debug = true
end

function LibSGui:CreateCheck()

end

function LibSGui:CreateScrollbar()

end

function LibSGui:CreateGroup()

end

function LibSGui:_internal()
	return _int
end