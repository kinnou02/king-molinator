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

local _int = {
	_context = UI.CreateContext("LibSGui_Parking_Context"),
	_debug = true,
	TH = TH,
	base = {
		frame = LibSata:Create(),
		texture = LibSata:Create(),
		scrollbar = LibSata:Create(),
		button = LibSata:Create(),
		checkbox = LibSata:Create(),
		window = LibSata:Create(),
		frameRaised = LibSata:Create(),
		frameSunken = LibSata:Create(),
		mask = LibSata:Create(),
	},
	objects = {
		window = LibSata:Create(),
		check = LibSata:Create(),
		scollbar = LibSata:Create(),
		group = LibSata:Create(),
		panel = LibSata:Create(),
		tabber = LibSata:Create(),
	},
	textures = {
		-- Raised
		TLRPanel = "Media/Group_TL_raise.png",
		TRRPanel = "Media/Group_TR_raise.png",
		TRPanel = "Media/Group_T_raise.png",
		LRPanel = "Media/Group_L_raise.png",
		MRPanel = "Media/Group_M_raise.png",
		RRPanel = "Media/Group_R_raise.png",
		BLRPanel = "Media/Group_BL_raise.png",
		BRPanel = "Media/Group_B_raise.png",
		BRRPanel = "Media/Group_BR_raise.png",
		-- Sunken
		TLSPanel = "Media/Group_TL_normal.png",
		TRSPanel = "Media/Group_TR_normal.png",
		TSPanel = "Media/Group_T_normal.png",
		LSPanel = "Media/Group_L_normal.png",
		MSPanel = "Media/Group_M_normal.png",
		RSPanel = "Media/Group_R_normal.png",
		BLSPanel = "Media/Group_BL_normal.png",
		BSPanel = "Media/Group_B_normal.png",
		BRSPanel = "Media/Group_BR_normal.png",
	},
	totals = {},
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
	["check"] = {
	},
	["scrollbar"] = {
	},
	["group"] = {
	},
	["panel"] = {
	},
	["tabber"] = {
	},
}
function _int:pullFrameRaised(_parent)
	local frameRaised = {}
	local Count = self.base.frameRaised:Count()
	if Count == 0 then
		
		-- Raised Section
		-- Initialize top raised section of Panel Object.
		frameRaised.TopLeft = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameRaised.TopLeft, AddonIni.id, _int.textures.TLRPanel)
		frameRaised.TopLeft:SetPoint("TOPLEFT", _parent, "TOPLEFT")
		frameRaised.TopLeft:SetAlpha(0.35)
		frameRaised.TopRight = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameRaised.TopRight, AddonIni.id, _int.textures.TRRPanel)
		frameRaised.TopRight:SetPoint("TOPRIGHT", _parent, "TOPRIGHT")
		frameRaised.TopRight:SetAlpha(0.35)
		frameRaised.Top = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameRaised.Top, AddonIni.id, _int.textures.TRPanel)
		frameRaised.Top:SetPoint("TOPLEFT", frameRaised.TopLeft, "TOPRIGHT")
		frameRaised.Top:SetPoint("BOTTOMRIGHT", frameRaised.TopRight, "BOTTOMLEFT")
		frameRaised.Top:SetAlpha(0.35)
		
		-- Initial bottom raised section of Panel Object.
		frameRaised.BottomLeft = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameRaised.BottomLeft, AddonIni.id, _int.textures.BLRPanel)
		frameRaised.BottomLeft:SetPoint("BOTTOMLEFT", _parent, "BOTTOMLEFT")
		frameRaised.BottomLeft:SetAlpha(0.35)
		frameRaised.BottomRight = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameRaised.BottomRight, AddonIni.id, _int.textures.BRRPanel)
		frameRaised.BottomRight:SetPoint("BOTTOMRIGHT", _parent, "BOTTOMRIGHT")
		frameRaised.BottomRight:SetAlpha(0.35)
		frameRaised.Bottom = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameRaised.Bottom, AddonIni.id, _int.textures.BRPanel)
		frameRaised.Bottom:SetPoint("TOPLEFT", frameRaised.BottomLeft, "TOPRIGHT")
		frameRaised.Bottom:SetPoint("BOTTOMRIGHT", frameRaised.BottomRight, "BOTTOMLEFT", 0, 0.5)
		frameRaised.Bottom:SetAlpha(0.35)

		-- Line up Left and Right, and fill middle section for raised Panel.
		frameRaised.Left = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameRaised.Left, AddonIni.id, _int.textures.LRPanel)
		frameRaised.Left:SetPoint("TOPLEFT", frameRaised.TopLeft, "BOTTOMLEFT")
		frameRaised.Left:SetPoint("BOTTOMRIGHT", frameRaised.BottomLeft, "TOPRIGHT", 0, 0.5)
		frameRaised.Left:SetAlpha(0.35)
		frameRaised.Right = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameRaised.Right, AddonIni.id, _int.textures.RRPanel)
		frameRaised.Right:SetPoint("TOPLEFT", frameRaised.TopRight, "BOTTOMLEFT")
		frameRaised.Right:SetPoint("BOTTOMRIGHT", frameRaised.BottomRight, "TOPRIGHT", 0, 0.5)
		frameRaised.Right:SetAlpha(0.35)
		frameRaised.Middle = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameRaised.Middle, AddonIni.id, _int.textures.MRPanel)
		frameRaised.Middle:SetPoint("TOPLEFT", frameRaised.Top, "BOTTOMLEFT")
		frameRaised.Middle:SetPoint("BOTTOMRIGHT", frameRaised.Bottom, "TOPRIGHT", 0, 0.5)
		frameRaised.Middle:SetAlpha(0.35)
		
		return frameRaised
	else
		--print("Frame Raised available in cache of "..Count)
		local frameObj, frameRaised = self.base.frameRaised:Last()
		self.base.frame:Remove(frameObj)
		
		-- Raised Section
		-- Initialize top raised section of Panel Object.
		frameRaised.TopLeft:SetPoint("TOPLEFT", _parent, "TOPLEFT")
		frameRaised.TopLeft:SetParent(_parent)
		frameRaised.TopLeft:SetVisible(true)
		frameRaised.TopRight:SetPoint("TOPRIGHT", _parent, "TOPRIGHT")
		frameRaised.TopRight:SetParent(_parent)
		frameRaised.TopRight:SetVisible(true)
		frameRaised.Top:SetPoint("TOPLEFT", frameRaised.TopLeft, "TOPRIGHT")
		frameRaised.Top:SetPoint("BOTTOMRIGHT", frameRaised.TopRight, "BOTTOMLEFT")
		frameRaised.Top:SetParent(_parent)
		frameRaised.Top:SetVisible(true)
		
		-- Initial bottom raised section of Panel Object.
		frameRaised.BottomLeft:SetPoint("BOTTOMLEFT", _parent, "BOTTOMLEFT")
		frameRaised.BottomLeft:SetParent(_parent)
		frameRaised.BottomLeft:SetVisible(true)
		frameRaised.BottomRight:SetPoint("BOTTOMRIGHT", _parent, "BOTTOMRIGHT")
		frameRaised.BottomRight:SetParent(_parent)
		frameRaised.BottomRight:SetVisible(true)
		frameRaised.Bottom:SetPoint("TOPLEFT", frameRaised.BottomLeft, "TOPRIGHT")
		frameRaised.Bottom:SetPoint("BOTTOMRIGHT", frameRaised.BottomRight, "BOTTOMLEFT")
		frameRaised.Bottom:SetParent(_parent)
		frameRaised.Bottom:SetVisible(true)
		
		-- Line up Left and Right, and fill middle section for raised Panel.
		frameRaised.Left:SetPoint("TOPLEFT", frameRaised.TopLeft, "BOTTOMLEFT")
		frameRaised.Left:SetPoint("BOTTOMRIGHT", frameRaised.BottomLeft, "TOPRIGHT", 0, 0.5)
		frameRaised.Left:SetParent(_parent)
		frameRaised.Left:SetVisible(true)
		frameRaised.Right:SetPoint("TOPLEFT", frameRaised.TopRight, "BOTTOMLEFT")
		frameRaised.Right:SetPoint("BOTTOMRIGHT", frameRaised.BottomRight, "TOPRIGHT", 0, 0.5)
		frameRaised.Right:SetParent(_parent)
		frameRaised.Right:SetVisible(true)
		frameRaised.Middle:SetPoint("TOPLEFT", frameRaised.Top, "BOTTOMLEFT")
		frameRaised.Middle:SetPoint("BOTTOMRIGHT", frameRaised.Bottom, "TOPRIGHT", 0, 0.5)
		frameRaised.Middle:SetParent(_parent)
		frameRaised.Middle:SetVisible(true)
		
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
		
		-- Raised Section
		-- Initialize top raised section of Panel Object.
		frameSunken.TopLeft = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameSunken.TopLeft, AddonIni.id, _int.textures.TLSPanel)
		frameSunken.TopLeft:SetPoint("TOPLEFT", _parent, "TOPLEFT")
		frameSunken.TopLeft:SetAlpha(0.55)
		frameSunken.TopRight = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameSunken.TopRight, AddonIni.id, _int.textures.TRSPanel)
		frameSunken.TopRight:SetPoint("TOPRIGHT", _parent, "TOPRIGHT")
		frameSunken.TopRight:SetAlpha(0.55)
		frameSunken.Top = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameSunken.Top, AddonIni.id, _int.textures.TSPanel)
		frameSunken.Top:SetPoint("TOPLEFT", frameSunken.TopLeft, "TOPRIGHT")
		frameSunken.Top:SetPoint("BOTTOMRIGHT", frameSunken.TopRight, "BOTTOMLEFT")
		frameSunken.Top:SetAlpha(0.55)
		
		-- Initial bottom raised section of Panel Object.
		frameSunken.BottomLeft = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameSunken.BottomLeft, AddonIni.id, _int.textures.BLSPanel)
		frameSunken.BottomLeft:SetPoint("BOTTOMLEFT", _parent, "BOTTOMLEFT")
		frameSunken.BottomLeft:SetAlpha(0.55)
		frameSunken.BottomRight = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameSunken.BottomRight, AddonIni.id, _int.textures.BRSPanel)
		frameSunken.BottomRight:SetPoint("BOTTOMRIGHT", _parent, "BOTTOMRIGHT")
		frameSunken.BottomRight:SetAlpha(0.55)
		frameSunken.Bottom = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameSunken.Bottom, AddonIni.id, _int.textures.BSPanel)
		frameSunken.Bottom:SetPoint("TOPLEFT", frameSunken.BottomLeft, "TOPRIGHT")
		frameSunken.Bottom:SetPoint("BOTTOMRIGHT", frameSunken.BottomRight, "BOTTOMLEFT")
		frameSunken.Bottom:SetAlpha(0.55)

		-- Line up Left and Right, and fill middle section for raised Panel.
		frameSunken.Left = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameSunken.Left, AddonIni.id, _int.textures.LSPanel)
		frameSunken.Left:SetPoint("TOPLEFT", frameSunken.TopLeft, "BOTTOMLEFT")
		frameSunken.Left:SetPoint("BOTTOMRIGHT", frameSunken.BottomLeft, "TOPRIGHT", 0, 0.5)
		frameSunken.Left:SetAlpha(0.55)
		frameSunken.Right = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameSunken.Right, AddonIni.id, _int.textures.RSPanel)
		frameSunken.Right:SetPoint("TOPLEFT", frameSunken.TopRight, "BOTTOMLEFT")
		frameSunken.Right:SetPoint("BOTTOMRIGHT", frameSunken.BottomRight, "TOPRIGHT", 0, 0.5)
		frameSunken.Right:SetAlpha(0.55)
		frameSunken.Middle = _int:pullTexture(_parent, true)
		TH.LoadTexture(frameSunken.Middle, AddonIni.id, _int.textures.MSPanel)
		frameSunken.Middle:SetPoint("TOPLEFT", frameSunken.Top, "BOTTOMLEFT")
		frameSunken.Middle:SetPoint("BOTTOMRIGHT", frameSunken.Bottom, "TOPRIGHT", 0, 0.5)
		frameSunken.Middle:SetAlpha(0.55)
		
		return frameSunken
	else
		--print("Frame Raised available in cache of "..Count)
		local frameObj, frameSunken = self.base.frameSunken:Last()
		self.base.frame:Remove(frameObj)
		
		-- Raised Section
		-- Initialize top raised section of Panel Object.
		frameSunken.TopLeft:SetPoint("TOPLEFT", _parent, "TOPLEFT")
		frameSunken.TopLeft:SetParent(_parent)
		frameSunken.TopLeft:SetVisible(true)
		frameSunken.TopRight:SetPoint("TOPRIGHT", _parent, "TOPRIGHT")
		frameSunken.TopRight:SetParent(_parent)
		frameSunken.TopRight:SetVisible(true)
		frameSunken.Top:SetPoint("TOPLEFT", frameSunken.TopLeft, "TOPRIGHT")
		frameSunken.Top:SetPoint("BOTTOMRIGHT", frameSunken.TopRight, "BOTTOMLEFT")
		frameSunken.Top:SetParent(_parent)
		frameSunken.Top:SetVisible(true)
		
		-- Initial bottom raised section of Panel Object.
		frameSunken.BottomLeft:SetPoint("BOTTOMLEFT", _parent, "BOTTOMLEFT")
		frameSunken.BottomLeft:SetParent(_parent)
		frameSunken.BottomLeft:SetVisible(true)
		frameSunken.BottomRight:SetPoint("BOTTOMRIGHT", _parent, "BOTTOMRIGHT")
		frameSunken.BottomRight:SetParent(_parent)
		frameSunken.BottomRight:SetVisible(true)
		frameSunken.Bottom:SetPoint("TOPLEFT", frameSunken.BottomLeft, "TOPRIGHT")
		frameSunken.Bottom:SetPoint("BOTTOMRIGHT", frameSunken.BottomRight, "BOTTOMLEFT")
		frameSunken.Bottom:SetParent(_parent)
		frameSunken.Bottom:SetVisible(true)
		
		-- Line up Left and Right, and fill middle section for raised Panel.
		frameSunken.Left:SetPoint("TOPLEFT", frameSunken.TopLeft, "BOTTOMLEFT")
		frameSunken.Left:SetPoint("BOTTOMRIGHT", frameSunken.BottomLeft, "TOPRIGHT", 0, 0.5)
		frameSunken.Left:SetParent(_parent)
		frameSunken.Left:SetVisible(true)
		frameSunken.Right:SetPoint("TOPLEFT", frameSunken.TopRight, "BOTTOMLEFT")
		frameSunken.Right:SetPoint("BOTTOMRIGHT", frameSunken.BottomRight, "TOPRIGHT", 0, 0.5)
		frameSunken.Right:SetParent(_parent)
		frameSunken.Right:SetVisible(true)
		frameSunken.Middle:SetPoint("TOPLEFT", frameSunken.Top, "BOTTOMLEFT")
		frameSunken.Middle:SetPoint("BOTTOMRIGHT", frameSunken.Bottom, "TOPRIGHT", 0, 0.5)
		frameSunken.Middle:SetParent(_parent)
		frameSunken.Middle:SetVisible(true)
		
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


function _int:pullFrame(_parent, _visible)
	local frame
	local Count = self.base.frame:Count()
	if Count == 0 then
		frame = UI.CreateFrame("Frame", "LibSGui_Frame_"..Count, _parent)
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

function _int:pullMask(_parent, _visible)
	local mask
	local Count = self.base.mask:Count()
	if Count == 0 then
		mask = UI.CreateFrame("Mask", "LibSGui_Frame_"..Count, _parent)
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
		scrollbar = UI.CreateFrame("RiftScrollbar", "LibSGui_Scrollbar_"..Count, _parent)
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
		texture = UI.CreateFrame("Texture", "LibSGui_Texture_"..Count, _parent)
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

function _int:pullButton(_parent)
	local button
	local Count = self.base.button:Count()
	if Count == 0 then
		button = UI.CreateFrame("RiftButton", "LibSGui_Button_"..Count, _parent)
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
			if base.w then
				base._cradle:SetWidth(base.w)
			end
			if base.h then
				base._cradle:SetHeight(base.h)
			end
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