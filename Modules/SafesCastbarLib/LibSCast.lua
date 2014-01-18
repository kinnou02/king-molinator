-- Safe's Castbar Library
-- Written By Paul Snart
-- Copyright 2013
--
--
-- To access this from within your Add-on.
--
-- In your RiftAddon.toc
-- ---------------------
-- Embed: SafesCastbarLib
-- Dependency: SafesCastbarLib, {"required", "before"}
--
-- In your Add-on's initialization
-- -------------------------------
-- local LibSCast = Inspect.Addon.Detail("SafesCastbarLib").data

local AddonIni, LibSCast = ...

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

local LSTIni = Inspect.Addon.Detail("SafesTableLib")
local LibSata = LSTIni.data

local KTHIni = Inspect.Addon.Detail("KBMTextureHandler")
local LibTexture = KTHIni.data

local _store = {}
local _int = {
	Default = {},
	Packs = {},
	UpdateTime = 0,
}
local _tracking = {}
local _active = {}
local _typeHandlers = {}
local _queue = LibSata:Create()

-- Language Settings
LibSCast.Lang = {}
LibSCast.Language = Inspect.System.Language()

local _event = {
	Cast = {
		Start = Utility.Event.Create(AddonIni.id, "Cast.Start"), -- UnitID, CastData = Event.SafesCastbarLib.Cast.Start()
		End = Utility.Event.Create(AddonIni.id, "Cast.End"), -- UnitID, CastData = Event.SafesCastbarLib.Cast.End()
	},
	Channel = {
		Start = Utility.Event.Create(AddonIni.id, "Channel.Start"), -- UnitID, CastData = Event.SafesCastbarLib.Channel.Start()
		End = Utility.Event.Create(AddonIni.id, "Channel.End"), -- UnitID, CastData = Event.SafesCastbarLib.Channel.End()
	},
	Interrupt = Utility.Event.Create(AddonIni.id, "Interrupt"), -- UnitID, CastData = Event.SafesCastbarLib.Interrupt() 
	Castbar = {
		Show = Utility.Event.Create(AddonIni.id, "Castbar.Show"), -- Castbar = Event.SafesCastbarLib.Castbar.Show()
		Hide = Utility.Event.Create(AddonIni.id, "Castbar.Hide"), -- Castbar = Event.SafesCastbarLib.Castbar.Hide()
	},
}

function _int.Default.Settings()
	local _set = {
		version = AddonIni.toc.Version,
		enabled = true, -- Should the castbar start.
		pinned = false, -- Is the castbar handled via a pin function. Usually castbars linked to other controlling frames.
		visible = true, -- Should the castbar currently be rendered.
		relX = 0.5, -- Percentage based screen positioning. Default is central, top 3rd.
		relY = 0.25, --/
		pack = "Rift",
		unlocked = true, -- Can be moved via left mouse button hold and drag. Pinned Castbars can never be unlocked.
		alpha = 1.0, -- Global alpha for the entire castbar.
		name = false,
		text = {
			enabled = true,
			alpha = 1.0,
			shadow = false, -- Enable text shadow
			border = true, -- Enable text border
			color = {
				font = {
					r = 1,
					g = 1,
					b = 1,
					a = 1,
				},
				shadow = {
					r = 0,
					g = 0,
					b = 0,
					a = 1,
				},
			},
		},
		texture = {
			background = {
				enabled = true, -- By default the background textures are enabled.
				alpha = 1.0, -- Alpha level 0.00 - 1.00
			},
			foreground = {
				enabled = true, -- By default the foreground textures are enabled.
				alpha = 1.0, -- Alpha level 0.00 - 1.00
			},
			icon = {
				enabled = false, -- Displays a cast icon, and uses "icon" frame. ** Not currently supported. **
				alpha = 1.0,
			},
			progI = {
				alpha = 0.8,
			},
			progN = {
				alpha = 0.8,
			},
			intBar = {
				alpha = 0.8,
			},
			-- Add additional texture settings locally in your addon.
		},
		scale = {
			unlocked = true,
			widthUnlocked = true,
			heightUnlocked = true,
			w = 1.0, -- Width Scale as percentage (1 = 100%)
			h = 1.0, -- Height Scale as percentage (1 = 100%)
			t = 1.0, -- Text Scale as percentage (1 = 100%)
		},
	}
	return _set
end
LibSCast.Default = {}
LibSCast.Default.BarSettings = _int.Default.Settings

function _int.Default.BarColors()
	-- local barCols = {
		-- cradle = {
			-- a = 0.2,
		-- },
		-- progI = {
			-- r = 0.05,
			-- g = 0.6,
			-- b = 0.5,
			-- a = 0.8,
		-- },
		-- progN = {
			-- r = 0.58,
			-- g = 0.48,
			-- b = 0.05,
			-- a = 0.8,
		-- },
		-- intBar = {
			-- r = 0.7,
			-- g = 0,
			-- b = 0,
			-- a = 0.8,
		-- },
	-- }
	local barCols = {
		cradle = {
			a = 0.2,
		},
		progI = {
			r = 0.05,
			g = 0.6,
			b = 0.5,
			a = 0.8,
		},
		progN = {
			r = 0.6,
			g = 0,
			b = 0,
			a = 0.8,
		},
		intBar = {
			r = 0.7,
			g = 0,
			b = 0,
			a = 0.8,
		},
	}	
	return barCols
end

function _int.Default.TextureColors()
	local textureCols = {
		cradle = {
			a = 0,
		},
		progI = {
			r = 0,
			g = 0,
			b = 0,
			a = 0,
		},
	}
	textureCols.progN = textureCols.progI
	textureCols.intBar = textureCols.progI
	return textureCols

end

function _int.Default.SimplePack()
	-- Create Plain Style Castbar
	-- Default Normal Bar.
	--
	local _defaultBar = {
		id = "default",
		total = 0,
		store = LibSata:Create(),
		default = {
			w = 275,
			h = 32,
			textSize = 15,
			progBar = {
				tx = 0, -- Top X Point (All as relative values)
				ty = 0, -- Top Y Point
				bx = 1, -- Bottom X Point
				by = 1, -- Bottom Y Point.
			},
			anim = {
				duration = 0.8, -- In Seconds of entire animation
			},
		},
		texture = {
			foreground = {
				location = AddonIni.id,
				file = "Media/Castbar_Simple.png",
			},
		},
	}
	_defaultBar.barScale = _defaultBar.default.progBar.bx - _defaultBar.default.progBar.tx 
	_int.Default:CreateBar(_defaultBar)
	
	local barPack = {
		default = _defaultBar, -- Required when sending bar packs.
	}	
	LibSCast:TPackAdd("Simple", "Simple", barPack)
end

function _int.AttachEditFrame(BarObj)
	local ui = BarObj.ui
	local offset = {
		x = 0,
		y = 0,
	}

	BarObj.ui.editFrame = UI.CreateFrame("Frame", "LibSCast-EditFrame_"..BarObj.ui.cradle:GetName(), BarObj.ui.cradle)
	BarObj.ui.editFrame:SetLayer(10)
	BarObj.ui.editFrame:SetAllPoints(BarObj.ui.cradle)
	BarObj.ui.editFrame:SetVisible(false)
	BarObj.ui.editFrame.BarObj = BarObj
	
	local EventFunc = {}
	function EventFunc:HandleMouseDown()
		local Mouse = Inspect.Mouse()
		
		self:SetBackgroundColor(0,0,0,0.5)
		offset = {
			x = Mouse.x - (UIParent:GetWidth() * self.BarObj.Settings.relX),
			y = Mouse.y - (UIParent:GetHeight() * self.BarObj.Settings.relY),
		}
		
		self:EventAttach(Event.UI.Input.Mouse.Cursor.Move, EventFunc.HandleMouseMove, "LibSCast-EditFrame-MouseMoveHandler_"..ui.cradle:GetName())
	end
	
	function EventFunc:HandleMouseMove(handle, x, y)
		ui.cradle:SetPoint("CENTER", UIParent, "TOPLEFT", x - offset.x, y - offset.y)
	end
	
	function EventFunc:HandleMouseUp()
		local Mouse = Inspect.Mouse()
		
		self:SetBackgroundColor(0,0,0,0)
		self:EventDetach(Event.UI.Input.Mouse.Cursor.Move, EventFunc.HandleMouseMove)
		self.BarObj.Settings.relX = (Mouse.x - offset.x) / UIParent:GetWidth()
		self.BarObj.Settings.relY = (Mouse.y - offset.y) / UIParent:GetHeight()
				
		ui.cradle:SetPoint("CENTER", UIParent, self.BarObj.Settings.relX, self.BarObj.Settings.relY)
	end
	
	function EventFunc:HandleMouseWheelForward()
		local changed = false
		
		if self.BarObj.Settings.scale.widthUnlocked then
			if self.BarObj.Settings.scale.w < 2 then
				self.BarObj.Settings.scale.w = self.BarObj.Settings.scale.w + 0.05
				changed = true
				if self.BarObj.Settings.scale.w > 2 then
					self.BarObj.Settings.scale.w = 2
				end
			end
		end
		
		if self.BarObj.Settings.scale.heightUnlocked then
			if self.BarObj.Settings.scale.h < 2 then
				self.BarObj.Settings.scale.h = self.BarObj.Settings.scale.h + 0.05
				changed = true
				if self.BarObj.Settings.scale.h > 2 then
					self.BarObj.Settings.scale.h = 2
				end
				self.BarObj.Settings.scale.t = self.BarObj.Settings.scale.h
			end
		end
		
		if changed then
			self.BarObj:ApplyScale()
		end
	end
	
	function EventFunc:HandleMouseWheelBack()
		local changed = false
		
		if self.BarObj.Settings.scale.widthUnlocked then
			if self.BarObj.Settings.scale.w > 0.5 then
				self.BarObj.Settings.scale.w = self.BarObj.Settings.scale.w - 0.05
				changed = true
				if self.BarObj.Settings.scale.w < 0.5 then
					self.BarObj.Settings.scale.w = 0.5
				end
			end
		end
		
		if self.BarObj.Settings.scale.heightUnlocked then
			if self.BarObj.Settings.scale.h > 0.5 then
				self.BarObj.Settings.scale.h = self.BarObj.Settings.scale.h - 0.05
				changed = true
				if self.BarObj.Settings.scale.h < 0.5 then
					self.BarObj.Settings.scale.h = 0.5
				end
				self.BarObj.Settings.scale.t = self.BarObj.Settings.scale.h
			end
		end
		
		if changed then
			self.BarObj:ApplyScale()
		end	
	end
	
	function EventFunc:HandleMouseWheelClick()
		local changed = false
		
		if self.BarObj.Settings.scale.w then
			if self.BarObj.Settings.scale.w ~= 1 then
				changed = true
				self.BarObj.Settings.scale.w = 1
			end
		end
	
		if self.BarObj.Settings.scale.h then
			if self.BarObj.Settings.scale.h ~= 1 then
				changed = true
				self.BarObj.Settings.scale.h = 1
				self.BarObj.Settings.scale.t = 1
			end
		end
		
		if changed then
			self.BarObj:ApplyScale()
		end
	end
	
	function BarObj:unlockSize(bool)
		if bool then
			ui.editFrame:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, EventFunc.HandleMouseWheelForward, "LibSCast-EditFrame-MouseWheelForwardHandler_"..ui.cradle:GetName())
			ui.editFrame:EventAttach(Event.UI.Input.Mouse.Wheel.Back, EventFunc.HandleMouseWheelBack, "LibSCast-EditFrame-MouseWheelBackHandler_"..ui.cradle:GetName())
			ui.editFrame:EventAttach(Event.UI.Input.Mouse.Middle.Click, EventFunc.HandleMouseWheelClick, "LibSCast-EditFrame-MouseMiddleClickHandler_"..ui.cradle:GetName())
		else
			ui.editFrame:EventDetach(Event.UI.Input.Mouse.Wheel.Forward, EventFunc.HandleMouseWheelForward)
			ui.editFrame:EventDetach(Event.UI.Input.Mouse.Wheel.Back, EventFunc.HandleMouseWheelBack)
			ui.editFrame:EventDetach(Event.UI.Input.Mouse.Middle.Click, EventFunc.HandleMouseWheelClick)		
		end
	end
	
	BarObj.ui.editFrame:EventAttach(Event.UI.Input.Mouse.Left.Down, EventFunc.HandleMouseDown, "LibSCast-EditFrame-MouseDownHandler_"..ui.cradle:GetName())
	BarObj.ui.editFrame:EventAttach(Event.UI.Input.Mouse.Left.Up, EventFunc.HandleMouseUp, "LibSCast-EditFrame-MouseUpHandler_"..ui.cradle:GetName())
	BarObj.ui.editFrame:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, EventFunc.HandleMouseUp, "LibSCast-EditFrame-MouseUpoutsideHandler_"..ui.cradle:GetName())
	if BarObj.Settings.scale.unlocked then
		BarObj:unlockSize(true)
	end
end

function _int.Default:CreateBar(_tBar)
	function _tBar:Create(PackInstance)
		local bar = {
			duration = 1, -- Default cast/channel duration in seconds.
			id = self.id,
			ui = nil,-- UI Element location.
			store = self.store,
			barObj = self,
			packInstance = PackInstance, -- The bar which is requesting this ui element. Used for various settings.
			packObj = PackInstance.PackObj,
			castObj = PackInstance.CastObj,
			loaded = false,
			anim = {},
			texture = self.texture,
			showing = false,
			Visible = false,
			Active = false,
		}
		
		-- Manage Correct Color layout.
		if self.texture.progI then
			if not self.color then
				self.color = _int.Default.TextureColors()
			end
		else
			if not self.color then
				self.color = _int.Default.BarColors()
			end
		end
		if not self.color.progN then
			self.color.progN = self.color.progI
		end
		if not self.color.intBar then
			self.color.intBar = self.color.progI
		end		
		
		function bar:Load(forceLoad)
			-- print("<-- "..self.castObj.Name.." [LOAD ATTEMPT]")
			self.Settings = self.castObj.Settings
			if self.loaded then
				-- print("Loaded, about to return")
				if not forceLoad then
					-- print("Normal Load, flagging [TRUE]")
					self.standardLoad = true
				end
				-- print("--> [LOAD BREAK] "..bar.castObj.Name)
				return
			end
			if not forceLoad then
				-- print("Standard load [QUEUE]")
				if not self.LoadObj then
					-- print("Placing in queue")
					self.standardLoad = true
					self.LoadObj = _queue:Add(self)
					self.Update = self.Load
					-- print("--> [LOAD QUEUED] "..bar.castObj.Name)
					return
				else
					-- print("[QUEUE SKIP] flagging as standardLoad")
					self.standardLoad = true
				end
			end
			self.LoadObj = nil
			self.color = self.barObj.color
			self.ui = self.store:RemoveLast()
			--print("Rift "..self.id.." Bar Loaded")
			if not self.ui then
				local barObj = self.barObj
				barObj.total = barObj.total + 1
				self.ui = {}
				self.ui.cradle = UI.CreateFrame("Frame", self.packObj.id.."_"..self.id.."_"..barObj.total, self.packInstance.parent)
				self.ui.cradle:SetVisible(false)
				_int.AttachEditFrame(self)
				if self.texture.foreground then
					self.ui.foreground = UI.CreateFrame("Texture", self.packObj.id.."_"..self.id.."_"..barObj.total..": Foreground", self.ui.cradle)
					self.ui.foreground:SetLayer(3)
					self.ui.foreground:SetPoint("TOPLEFT", self.ui.cradle, "TOPLEFT")
					self.ui.foreground:SetPoint("BOTTOMRIGHT", self.ui.cradle, "BOTTOMRIGHT")
					LibTexture.LoadTexture(self.ui.foreground, self.texture.foreground.location, self.texture.foreground.file)
				end
				self.ui.text = UI.CreateFrame("Text", self.packObj.id.."_"..self.id.."_"..barObj.total..": Text", self.ui.cradle)
				self.ui.text:SetPoint("CENTER", self.ui.cradle, "CENTER")
				self.ui.text:SetLayer(4)
				self.ui.text:SetEffectGlow({offsetX = 0, offsetY = 0, colorR = 0, colorG = 0, colorB = 0, strength = 4, blurX = 2, blurY = 1})
				self.ui.mask = UI.CreateFrame("Mask", self.packObj.id..".."..self.id.."_"..barObj.total..": Progress Bar Mask", self.ui.cradle)
				self.ui.mask:SetWidth(0)
				self.ui.mask:SetLayer(2)
				self.ui.mask:SetPoint("TOPLEFT", self.ui.cradle, barObj.default.progBar.tx, barObj.default.progBar.ty) 
				self.ui.mask:SetPoint("BOTTOM", self.ui.cradle, nil, barObj.default.progBar.by)
				if self.texture.progI then
					-- Interruptible Progress Bar
					self.ui.progI = UI.CreateFrame("Texture", self.packObj.id.."_"..self.id.."_"..barObj.total..": Progress Bar Int", self.ui.mask)
					self.ui.progI:SetVisible(false)
					self.ui.progI:SetAlpha(0.8)
					LibTexture.LoadTexture(self.ui.progI, self.texture.progI.location, self.texture.progI.file)
					self.ui.progI:SetPoint("TOPLEFT", self.ui.mask, "TOPLEFT")
					self.ui.progI:SetPoint("BOTTOMRIGHT", self.ui.cradle, barObj.default.progBar.bx, barObj.default.progBar.by)
					-- Uninterruptible Progress Bar
					if self.texture.progN then
						self.ui.progN = UI.CreateFrame("Texture", self.packObj.id.."_"..self.id.."_"..barObj.total..": Progress Bar No Int", self.ui.mask)
						LibTexture.LoadTexture(self.ui.progN, self.texture.progN.location, self.texture.progN.file)
						self.ui.progN:SetVisible(false)
						self.ui.progN:SetPoint("TOPLEFT", self.ui.mask, "TOPLEFT")
						self.ui.progN:SetPoint("BOTTOMRIGHT", self.ui.cradle, barObj.default.progBar.bx, barObj.default.progBar.by)
						self.ui.progN:SetAlpha(0.8)
					else
						self.ui.progN = self.ui.progI
					end
					-- Interrupted Cast Texture
					self.intTexture = false
					if self.texture.intBar then
						self.intTexture = true
						self.ui.intBar = UI.CreateFrame("Texture", self.packObj.id.."_"..self.id.."_"..barObj.total..": Interrupt Bar", self.ui.mask)
						LibTexture.LoadTexture(self.ui.intBar, self.texture.intBar.location, self.texture.intBar.file)
						self.ui.intBar:SetVisible(false)
						self.ui.intBar:SetPoint("TOPLEFT", self.ui.mask, "TOPLEFT")
						self.ui.intBar:SetPoint("BOTTOMRIGHT", self.ui.cradle, barObj.default.progBar.bx, barObj.default.progBar.by)
						self.ui.intBar:SetAlpha(0.8)
					else
						self.ui.intBar = self.ui.progN
					end
				else
					self.ui.progI = UI.CreateFrame("Frame", self.packObj.id.."_"..self.id.."_"..barObj.total..": Progress Bar Int", self.ui.mask)
					self.ui.progI:SetVisible(false)
					self.ui.progI:SetAlpha(0.8)
					self.ui.progI:SetPoint("TOPLEFT", self.ui.mask, "TOPLEFT")
					self.ui.progI:SetPoint("BOTTOMRIGHT", self.ui.cradle, barObj.default.progBar.bx, barObj.default.progBar.by)
					self.ui.progN = self.ui.progI
					self.ui.intBar = self.ui.progI
				end
				self.glow = false
				if self.texture.glow then
					self.glow = true
					self.ui.glow = UI.CreateFrame("Texture", self.packObj.id.."_"..self.id.."_"..barObj.total..": Glow", self.ui.cradle)
					LibTexture.LoadTexture(self.ui.glow, self.texture.glow.location, self.texture.glow.file)
					self.ui.glow:SetAlpha(0)
					self.ui.glow:SetLayer(5)
					self.ui.glow:SetPoint("TOPLEFT", self.ui.cradle, barObj.default.glow.tx, barObj.default.glow.ty)
					self.ui.glow:SetPoint("BOTTOMRIGHT", self.ui.cradle, barObj.default.glow.bx, barObj.default.glow.by)
					self.currentGlow = "file"
					self.barObj.default.glow.duration = 1 - self.barObj.default.glow.start
				end
			else
				--print(self.packInstance.id.." Recycled from Store "..self.id..": "..self.store:Count())
				self.ui.cradle:ClearAll()
				self.ui.cradle:SetParent(self.packInstance.parent)
				self.glow = false
				if self.texture.glow then
					self.glow = true
					self.barObj.default.glow.duration = 1 - self.barObj.default.glow.start
					self.ui.glow:SetAlpha(0)
					self.currentGlow = "file"
				end
				self.ui.editFrame.BarObj = self
			end
			self.ui.cradle:SetBackgroundColor(0,0,0,self.color.cradle.a)
			self.progBar = self.ui.progI
			self.progColor = self.color.progI
			self.progBar:SetBackgroundColor(self.progColor.r, self.progColor.g, self.progColor.b, self.progColor.a)
			self.loaded = true
			if not self.Settings.relX then
				self.Settings.relX = 0.5
				self.Settings.relY = 0.2
			end
			self:RenderSettings()
			if self.WaitStart then
				self.Update = self.Start
				self.WaitStart = false
			end
			-- print("--> [LOAD END] "..bar.castObj.Name)
		end
		
		function bar:GetHeight()
			return math.ceil(self.barObj.default.h * self.Settings.scale.h)
		end
		
		function bar:GetWidth()
			return math.ceil(self.barObj.default.w * self.Settings.scale.w)
		end
		
		function bar:GetDefaultHeight()
			return self.barObj.default.h
		end
		
		function bar:GetDefaultWidth()
			return self.barObj.default.w
		end
		
		function bar:ApplyScale()
			if self.loaded then
				self.ui.cradle:SetWidth(math.ceil(self.barObj.default.w * self.Settings.scale.w))
				self.ui.cradle:SetHeight(math.ceil(self.barObj.default.h * self.Settings.scale.h))
				self.ui.text:SetFontSize(math.ceil(self.barObj.default.textSize * self.Settings.scale.t))
				self.progWidth = math.ceil(self.ui.cradle:GetWidth() * self.barObj.barScale)
			end
		end
		
		function bar:RenderSettings()
			-- print("<-- [RENDER SETTINGS]")
			if self.loaded then
				if self.castObj.pinFunction then
					-- print("[EXTERNAL] Calling Pin function")
					self.castObj.pinFunction(self)
				else
					self.ui.cradle:ClearAll()
					-- print("[INTERNAL] Setting Layout")
					self.ui.cradle:SetPoint("CENTER", UIParent, self.Settings.relX, self.Settings.relY)
					self.ui.cradle:SetWidth(math.ceil(self.barObj.default.w * self.Settings.scale.w))
					self.ui.cradle:SetHeight(math.ceil(self.barObj.default.h * self.Settings.scale.h))
					self.ui.text:SetFontSize(math.ceil(self.barObj.default.textSize * self.Settings.scale.t))
				end
				self.progWidth = math.ceil(self.ui.cradle:GetWidth() * self.barObj.barScale)
				if self.ui.foreground then
					self.ui.foreground:SetVisible(self.Settings.texture.foreground.enabled)
					self.ui.foreground:SetAlpha(self.Settings.texture.foreground.alpha)
				end
			end
			-- print("--> [RENDER SETTINGS]")
		end
		
		function bar:SetTexture(Texture, Enabled)
			if self.ui[Texture] then
				if self.ui[Texture]:GetVisible() ~= Enabled then
					self.ui[Texture]:SetVisible(Enabled)
				end
			end
		end
		
		function bar:Begin(CastData)
			self.CastData = CastData
			self.StartObj = _queue:Add(self)
			if not self.loaded then
				self.WaitStart = true
			else
				self.Update = self.Start
			end
		end
		
		function bar:Start()
			local CastData = self.CastData
			self.Name = CastData.abilityName or ""
			self.Duration = CastData.duration or 1
			self.Remaining = CastData.remaining or 1
			self.Progress = self.Duration/self.Remaining
			self.ui.text:SetText(string.format("%0.01f", self.Remaining).." - "..self.Name)
			self.ui.cradle:SetAlpha(1)
			self.ui.intBar:SetVisible(false)
			if CastData.uninterruptible then
				self.progBar = self.ui.progN
				self.progColor = self.color.progN
				self.ui.progI:SetVisible(false)
				if self.glow then
					if self.currentGlow ~= "fileN" then
						if self.barObj.texture.glow.fileN then
							LibTexture.LoadTexture(self.ui.glow, self.barObj.texture.glow.location, self.barObj.texture.glow.fileN)
							self.currentGlow = "fileN"
						end
					end
					self.ui.glow:SetAlpha(0)
					self.ui.glow:SetVisible(true)
				end
			else
				self.progBar = self.ui.progI
				self.progColor = self.color.progI
				self.ui.progN:SetVisible(false)
				if self.glow then
					if self.currentGlow ~= "file" then
						if self.barObj.texture.glow.file then
							LibTexture.LoadTexture(self.ui.glow, self.barObj.texture.glow.location, self.barObj.texture.glow.file)
							self.currentGlow = "file"
						end
					end
					self.ui.glow:SetAlpha(0)
					self.ui.glow:SetVisible(true)
				end
			end
			self.ui.mask:SetWidth(0)
			self.progBar:SetBackgroundColor(self.progColor.r, self.progColor.g, self.progColor.b, self.progColor.a)
			self.progBar:SetVisible(true)
			self.ui.cradle:SetVisible(true)
			if CastData.channeled then
				self.Update = self.ChannelUpdate
			else
				self.Update = self.CastUpdate
			end
			self.StartObj = nil
			self.Active = true
			if not self.showing then
				_event.Castbar.Show(self, self.castObj)
				self.Visible = true
			end
		end
		
		function bar:Interrupt()
			if self.Loaded then
				self.anim.endTime = Inspect.Time.Real() + self.barObj.default.anim.duration
				if self.CastData.uninterruptible then
					self.ui.text:SetText(LibSCast.Lang.Stopped)
				else
					self.ui.text:SetText(LibSCast.Lang.Interrupted)
				end
				self.progBar:SetVisible(false)
				self.ui.intBar:SetBackgroundColor(self.color.intBar.r, self.color.intBar.g, self.color.intBar.b, self.color.intBar.a)
				self.ui.intBar:SetVisible(true)
				self.ui.mask:SetWidth(self.progWidth)
				self.Update = self.InterruptAnim
				if not self.UpdateObj then
					self.UpdateObj = _queue:Add(self)
				end
			else
				self:Stop()
			end
		end
		
		function bar:End()
			if self.loaded then
				self.anim.endTime = Inspect.Time.Real() + self.barObj.default.anim.duration
				self.Update = self.EndAnim
				self.ui.text:SetText(self.Name)
				self.ui.mask:SetWidth(self.progWidth)
				if not self.UpdateObj then
					self.UpdateObj = _queue:Add(self)
				end
			else
				self:Stop()
			end
		end
		
		function bar:Stop()
			if self.loaded then
				self.ui.cradle:SetVisible(self.showing)
				if self.showing then
					self.ui.cradle:SetAlpha(1)
					self.ui.mask:SetWidth(0)
					if self.glow then
						self.ui.glow:SetVisible(false)
					end
				end
				self.ui.text:SetText(self.castObj.Name)
				if not self.showing then
					if self.Visible then
						_event.Castbar.Hide(self, self.castObj)
						self.Visible = false
					end
				end
			else
				if self.LoadObj then
					_queue:Remove(self.LoadObj)
					self.LoadObj = nil
					self.standardLoad = false
				end
			end
			if self.UpdateObj then
				_queue:Remove(self.UpdateObj)
				self.UpdateObj = nil
			end
			if self.StartObj then
				_queue:Remove(self.StartObj)
				self.WaitStart = false
				self.StartObj = nil
			end
			self.Active = false
		end
			
		function bar:Recycle()
			if self.loaded then
				-- print("<-- "..self.castObj.Name.." [RECYCLE]")
				if self.Active then
					self:Stop()
				end
				if not self.showing then
					-- print(self.castObj.Name.." removing UI elements")
					self.ui.cradle:SetVisible(false)
					--self.ui.cralde:ClearAllPoints()
					if self.Visible then
						_event.Castbar.Hide(self, self.castObj)
						self.Visible = false
					end
					self.WaitStart = false
					self.store:Add(self.ui)
					self.ui = nil
					self.loaded = false
					self.standardLoad = false
				end
				-- print("--> [RECYCLE]")
				-- print(self.packInstance.id.." Recycled to "..self.id..": "..self.store:Count())
			else
				if self.LoadObj then
					_queue:Remove(self.LoadObj)
					self.LoadObj = nil
				end
				self.WaitStart = false
				self.standardLoad = false
			end
		end
				
		function bar:Queue(Remaining)
			self.Remaining = Remaining				
			if not self.UpdateObj then
				self.UpdateObj = _queue:Add(self)
			end
		end
		
		function bar:CastUpdate()
			self.Progress = 1 - self.Remaining/self.Duration
			if self.ui then
				local default = self.barObj.default
				local newWidth = math.floor(self.progWidth * self.Progress)
				if newWidth ~= self.ui.mask:GetWidth() then
					if newWidth < 0 then 
						newWidth = 0
					end
					self.ui.mask:SetWidth(newWidth)
				end
				local newText = string.format("%0.01f", self.Remaining).." - "..self.Name
				if newText ~= self.ui.text:GetText() then
					self.ui.text:SetText(newText)
				end
				if self.glow then
					if self.Progress > default.glow.start then
						self.ui.glow:SetAlpha(1 * ((self.Progress - default.glow.start)/default.glow.duration))
					end
				end
			end
			self.UpdateObj = nil
		end
		
		function bar:ChannelUpdate()
			self.Progress = 1 - self.Remaining/self.Duration
			if self.ui then
				if self.Progress > 0 then
					local default = self.barObj.default
					local newWidth = math.ceil(self.progWidth * (1 - self.Progress))
					if newWidth ~= self.ui.mask:GetWidth() then
						if newWidth < 0 then 
							newWidth = 0
						end
						self.ui.mask:SetWidth(newWidth)
					end
					local newText = string.format("%0.01f", self.Remaining).." - "..self.Name
					if newText ~= self.ui.text:GetText() then
						self.ui.text:SetText(newText)
					end
					if self.glow then
						if self.Progress > default.glow.start then
							self.ui.glow:SetAlpha(1 * ((self.Progress - default.glow.start)/default.glow.duration))
						end
					end
				end
			end
			self.UpdateObj = nil
		end
		
		function bar:InterruptAnim()
			self.anim.remaining = self.anim.endTime - Inspect.Time.Real()
			local default = self.barObj.default
			self.anim.progress = self.anim.remaining * default.anim.duration
			if self.anim.remaining <= 0.01 then
				self.UpdateObj = nil
				self.anim.endTime = 0
				self:Stop()
				return
			else
				self.ui.cradle:SetAlpha(self.anim.progress)
			end
			self.UpdateObj = _queue:Add(self)
		end
		
		function bar:EndAnim()
			self.anim.remaining = self.anim.endTime - Inspect.Time.Real()
			local default = self.barObj.default
			self.anim.progress = self.anim.remaining * default.anim.duration
			if self.anim.remaining <= 0.01 then
				self.UpdateObj = nil
				self.anim.endTime = 0
				self:Stop()
				return
			else
				self.ui.cradle:SetAlpha(self.anim.progress)
			end
			self.UpdateObj = _queue:Add(self)
		end
		
		function bar:SetVisible(bool)
			if bool then
				if not self.showing then
					-- print(bar.castObj.Name..": Setting to visible true")
					if not self.loaded then
						self:Load(true)
					end
					self.ui.cradle:SetVisible(true)
					if not self.Active then
						self.ui.text:SetText(self.castObj.Name)
						self.ui.cradle:SetAlpha(1)
						self.ui.mask:SetWidth(0)
						if self.glow then
							self.ui.glow:SetAlpha(0)
						end
						_event.Castbar.Show(self, self.castObj)
						self.Visible = true
					end
					self.showing = true
				end
			else
				if self.showing then
					-- print(bar.castObj.Name..": Setting to visible false")
					self.showing = false
					if not self.Active then
						self.ui.cradle:SetVisible(false)
						if not self.Active then
							_event.Castbar.Hide(self, self.castObj)
							self.Visible = false
							if not self.standardLoad then
								self:Recycle()
							end
						end
					end
				end
			end
		end
		
		function bar:SetEditMode(bool)
			if self.castObj.Enabled then
				if self.loaded then
					self:Load(true)
					self.ui.editFrame:SetVisible(bool)
				end
			end
		end
		
		return bar
	end
end

function _int.Default:RiftPack()
	-- Create Rift Style Castbar
	-- Default Normal Bar.
	--
	local _defaultBar = {
		id = "default",
		total = 0,
		store = LibSata:Create(),
		default = {
			w = 275,
			h = 35,
			textSize = 14,
			progBar = {
				tx = 0.03, -- Top X Point (All as relative values)
				ty = 0.15, -- Top Y Point
				bx = 0.975, -- Bottom X Point
				by = 0.85, -- Bottom Y Point.
			},
			glow = {
				tx = 0.01,
				ty = 0,
				bx = 0.99,
				by = 1,
				start = 0.75, -- Percentage Glow will start to fade in.
			},
			anim = {
				duration = 0.8, -- In Seconds of entire animation
			},
		},
		texture = {
			foreground = {
				location = AddonIni.id,
				file = "Media/Castbar_Outline.png",
			},
			progI = {
				location = AddonIni.id,
				file = "Media/Castbar_Cyan.png",
			},
			progN = {
				location = AddonIni.id,
				file = "Media/Castbar_Yellow.png",
			},
			intBar = {
				location = AddonIni.id,
				file = "Media/Castbar_Red.png",
			},
			glow = {
				location = AddonIni.id,
				file = "Media/Castbar_Complete.png",
				fileN = "Media/Castbar_CompleteN.png",
			},
		},
	}
	_defaultBar.barScale = _defaultBar.default.progBar.bx - _defaultBar.default.progBar.tx -- You can do this, or manually enter it, just ensure it's there.
	-- Create methods so the bar conforms to the Library controller. 
	-- Note: you may overwrite any method after this point forward, providing you understand how to handle the methods yourself.
	-- this allows for custom animations and any additional texture/frame manipulation during casts. Otherwise, the fault methods should be enough.
	_int.Default:CreateBar(_defaultBar)

	local _raidBar = {
		id = "raid",
		total = 0,
		store = LibSata:Create(),
		default = {
			w = 321,
			h = 60,
			textSize = 14,
			progBar = {
				tx = 0.085, -- Top X Point (All as relative values)
				ty = 0.35, -- Top Y Point
				bx = 0.92, -- Bottom X Point
				by = 0.66, -- Bottom Y Point.
			},
			glow = {
				tx = 0.05,
				ty = 0.1,
				bx = 0.95,
				by = 0.9,
				start = 0.75, -- Percentage Glow will start to fade in.
			},
			anim = {
				duration = 0.8, -- In Seconds of entire animation
			},
		},
		texture = {
			foreground = {
				location = AddonIni.id,
				file = "Media/Castbar_Boss.png",
			},
			progI = {
				location = AddonIni.id,
				file = "Media/Castbar_Cyan.png",
			},
			progN = {
				location = AddonIni.id,
				file = "Media/Castbar_Yellow.png",
			},
			intBar = {
				location = AddonIni.id,
				file = "Media/Castbar_Red.png",
			},
			glow = {
				location = AddonIni.id,
				file = "Media/Castbar_Complete.png",
				fileN = "Media/Castbar_CompleteN.png",
			},
		},
	}
	_raidBar.barScale = _raidBar.default.progBar.bx - _raidBar.default.progBar.tx 
	_int.Default:CreateBar(_raidBar)
	
	local barPack = {
		default = _defaultBar, -- Required when sending bar packs.
		group = _raidBar,
		raid = _raidBar, -- if you wish to have different bar types for various units (Boss, Player, Elite, PvP etc)
	}	
	LibSCast:TPackAdd("Rift", "Rift", barPack)
end

function LibSCast:TPackAdd(PackID, Name, barPack)
	local Command = "LibSCast:TPackAdd(string PackID, string Name, table defBar): "
	if type(PackID) ~= "string" then
		error(Command.."Expecting string for PackID, got - "..type(PackID))
	else
		local PackObj = {
			id = PackID, -- Used for reference.
			name = Name, -- Display name for end users. (Building options lists for example)
			bars = {
				default = barPack.default,
				raid = barPack.raid or barPack.default, -- Usually bosses and some raid trash/adds.
				group = barPack.group or barPack.default, -- Most other elite units.
				player = barPack.player or barPack.default, -- Standard player bars (all player units), usually the same as default.
				pvp = barPack.pvp or barPack.default, -- Standard player/npc bars when they're flagged for PvP.
			}, -- Where the set bars are kept: raid, group, player, pvp, default
		}
		if not _int.Packs[PackObj.id] then
			_int.Packs[PackObj.id] = PackObj
		else
			error(Command.." ID conflict for: "..PackObj.id)
		end
				
		function PackObj:Create(CastObj, CastData)
			-- Creates an instance of a Pack Object or uses one from local storage.
			-- Used when a Cast Object starts via :StartType or :Start
			--
			
			local PackInstance = {
				id = self.id,
				PackObj = self,
				CastObj = CastObj,
				Type = "LibSCast_PackObj",
				bars = {},
				barObj = {},
				parent = CastObj.Parent, -- Frame/Context to parent to.
			}
			for id, barObj in pairs(self.bars) do
				if not PackInstance.barObj[barObj.id] then
					PackInstance.barObj[barObj.id] = barObj:Create(PackInstance)
				end
				PackInstance.bars[id] = PackInstance.barObj[barObj.id]
			end
			
			function PackInstance:LoadAll()
				for id, bar in pairs(self.barObj) do
					bar:Load()
				end
			end
			
			function PackInstance:Load(id)
				self.bars[id]:Load()
			end
			
			function PackInstance:UpdateSettings()
				for id, bar in pairs(self.barObj) do
					if bar.loaded then
						bar:RenderSettings()
					end
				end
			end
			
			function PackInstance:SettingsTable(NewSettings)
				for id, bar in pairs(self.barObj) do
					bar.Settings = NewSettings
				end
			end
			
			function PackInstance:SetTexture(Texture, Enabled)
				for id, bar in pairs(self.barObj) do
					if bar.loaded then
						bar:SetTexture(Texture, Enabled)
					end
				end
			end
			
			function PackInstance:SetEditMode(bool)
				for id, bar in pairs(self.barObj) do
					bar:SetEditMode(bool)
				end
			end
			
			function PackInstance:UpdatePin()
				for id, bar in pairs(self.barObj) do
					if bar.loaded then
						bar:RenderSettings()
					end			
				end
			end

			function PackInstance:Recycle()
				-- Places created Bar Objects in a store for later use.
				-- This instance is no longer usable.
				--
				for id, bar in pairs(self.barObj) do
					if bar.loaded then
						bar:SetVisible(false)
						bar:Recycle()
					end
				end
			end
			
			function PackInstance:Remove()
				self:Recycle()				
				self.bars = nil
				self.barObj = nil
			end
			
		--	print("Pack Instance created: "..self.id)
			return PackInstance
		end		
	end
end

function _int.Default:CreatePacks()
	self:SimplePack()
	self:RiftPack()
end

function _int:Castbar_Processor(UnitID)
	-- Handles data updates and dispatches render queue.
	local CastPro = {
		Castbars = {},
		Cast = {},
		UnitID = UnitID,
		UnitObj = LibSUnit:RequestDetails(UnitID),
		Active = false,
		Count = 0,
	}
	
	function CastPro:Add(CastObj)
		-- Adds a cast object for events and/or rendering.
		if not self.Castbars[CastObj] then
			self.Castbars[CastObj] = CastObj
			self.Count = self.Count + 1
		end
	end
	
	function CastPro:Remove(CastObj)
		-- Removes a cast object from events and/or rendering.
		if self.Castbars[CastObj] then
			self.Castbars[CastObj] = nil
			self.Count = self.Count - 1
			if self.Count == 0 then
				_tracking[self.UnitID] = nil
			end
		end
	end
	
	function CastPro:Begin()
		-- Triggered when castbars become visible to the player.
		local CastData = Inspect.Unit.Castbar(self.UnitID)
		if CastData then
			self.Cast.Data = CastData
			local _continue = false
			if self.Active then
				if self.Cast.Start == CastData.begin then
					return
				else
					self:Stop()
				end
			elseif self.Cast.Start == CastData.begin then
				_continue = true
			end
			_active[self.UnitID] = self
			self.Cast.Start = CastData.begin
			for _, CastObj in pairs(self.Castbars) do
				if not CastObj.Passive then
					CastObj:Begin(self.Cast.Data)
				end
			end
			self.Active = true
			if not _continue then
				if CastData.channeled then
					_event.Channel.Start(self.UnitID, CastData)
				else
					_event.Cast.Start(self.UnitID, CastData)
				end
			end
		end
	end
	
	function CastPro:Interrupt()
		-- Triggered when castbars are no longer visible to the player, but are possibly interrupted.
		_active[self.UnitID] = nil
		for _, CastObj in pairs(self.Castbars) do
			if not CastObj.Passive then
				CastObj:Interrupt()
			end
		end
		self.Active = false
		_event.Interrupt(self.UnitID, self.Cast.Data)
	end
	
	function CastPro:End()
		-- Triggered when castbars are no longer visible to the player.
		_active[self.UnitID] = nil
		for _, CastObj in pairs(self.Castbars) do
			if not CastObj.Passive then
				CastObj:End()
			end
		end
		self.Active = false
		if self.Cast.Data.channel then
			_event.Channel.End(self.UnitID, self.Cast.Data)
		else
			_event.Cast.End(self.UnitID, self.Cast.Data)
		end
	end
	
	function CastPro:Stop()
		-- Triggered when a unit is no longer available and when a new cast starts with an existing cast in progress.
		_active[self.UnitID] = nil
		for _, CastObj in pairs(self.Castbars) do
			if not CastObj.Passive then
				CastObj:EndNoAnim()
			end
		end
		self.Active = false
	end
		
	function CastPro:Update()
		local CastData = Inspect.Unit.Castbar(self.UnitID)
		if CastData then
			if CastData.begin == self.Cast.Start then
				self.Cast.Data = CastData
				for _, CastObj in pairs(self.Castbars) do
					if not CastObj.Passive then
						CastObj:Update(CastData.remaining)
					end
				end
			else
				if self.Cast.Data then
					self.Cast.Data.remaining = Inspect.Time.Real() - self.Cast.Start
				end
				self:Begin()
			end
		else
			self:Visible(false)
		end
	end
		
	function CastPro:Visible(bool)
		--print("------")
		--print("Cast State Changed: "..tostring(bool))
		if bool then
			self:Begin()
		else
			if self.Active then
				--print("Cast ended for: "..self.UnitObj.Name)
				-- Calculate if the cast was interrupted.
				if self.UnitObj.CurrentKey ~= "Idle" and self.Cast.Data ~= nil then
					local Time = Inspect.Time.Real()
					local Expected = self.Cast.Start + self.Cast.Data.duration
					local Difference = Time - Expected
					if self.Cast.Data.remaining < 0 or self.Cast.Data.expired ~= nil or Difference > 0 then
						self:End()
					else
						self:Interrupt()
					end
					-- print("Time Started: "..tostring(self.Cast.Data.begin))
					-- print("Duration: "..tostring(self.Cast.Data.duration))
					-- print("Expired: "..tostring(self.Cast.Data.expired))
					-- print("Remaining: "..tostring(self.Cast.Data.remaining))
					-- print("Adjusted Difference: "..tostring(Difference))
				else
					self:Stop()
				end
			end
			self.Active = false
		end
	end
	_tracking[UnitID] = CastPro
	
	return CastPro
end

function LibSCast:Create(ID, Parent, Pack, Settings, Style)
	-- Create a castbar object, this is something which can have settings.
	-- These have no UI until issued a CastObj:Start() or CastObj:StartType(UnitType)
	-- If no Pack is supplied this is a passive Castbar object with no UI.
	-- They can be interchangeable with any unit. Think of them as UI housing objects.
	--
	local CastObj = {
		id = ID,
		Settings = Settings or _int.Default:Settings(),
		Pack = Pack,
		Style = Style or "dynamic", -- Uses a set Bar type from the Pack if supplied, or Unit type if dynamic.
		Parent = Parent, -- Parent Frame to link to.
		Active = false,
		Name = ID,
		Visible = false,
		Loaded = false,
		CurrentBar = nil, -- Current UI Object in use.
		BarID = Style or "default",
	}
	if Pack then
		CastObj.Passive = false
		CastObj.Pack = _int.Packs[Pack] or _int.Packs["Simple"]
		CastObj.PackInstance = CastObj.Pack:Create(CastObj)
	else
		CastObj.Passive = true
	end
	CastObj.Enabled = CastObj.Settings.enabled
		
	if not _int.Packs[Pack] and not CastObj.Passive then
		error("LibSCast:Create(ID, Parent, Pack, Settings, Style) : Unknown Texture Pack '"..tostring(Pack).."'")
	else
		function CastObj:SetPack(Pack)
			--print("Pack changing to: "..tostring(Pack))
			self.CurrentBar = nil
			if self.PackInstance then
				self.PackInstance:Remove()
				self.Loaded = false
			end
			if Pack then
				--print("Creating new Pack")
				self.Pack = _int.Packs[Pack] or _int.Packs["Simple"]
				self.Passive = false
				self.PackInstance = self.Pack:Create(self, self.CastData)
				local oldVisible = self.Visible
				self.Visible = false
				self:SetVisible(oldVisible)
				if self.Active then
					self:Load()
					if self.Engine then
						if self.Engine.Active then
							self:Begin(self.Engine.Cast.Data)
						end
					end
				end
			else
				self.PackInstance = nil
				self.Passive = true
			end
		end
		
		function CastObj:SetTexture(Texture, Enabled)
			self.PackInstance:SetTexture(Texture, Enabled)
		end
		
		function CastObj:UpdateSettings()
			self.PackInstance:UpdateSettings()
		end
	
		function CastObj:Start(UnitID, Enabled)
			-- Start a castbar object tracking via UID only.
			if Enabled ~= nil then
				self.Enabled = Enabled
			end
			
			if self.Active then
				self:Stop()
			end
			if not self.Type then
				self.Type = UnitID
			end
			self.UnitID = UnitID
			self.Active = true
			if not self.Passive then
				if self.Enabled then
					if not self.Loaded then
						self:Load()
					end
				end
				if self.Style == "dynamic" then
					local cDetails = LibSUnit:RequestDetails(self.UnitID) -- Caster Unit Details
					if cDetails then
						local tier = cDetails.Tier or "default"
						if cDetails.PvP then
							tier = "pvp"
						elseif cDetails.Player then
							tier = "player"
						end	
						self.BarID = tier
					else
						self.BarID = "default"
					end
				else			
					self.BarID = self.Style
				end
				self.CurrentBar = self.PackInstance.bars[self.BarID]
				if self.Visible then
					if self.LastVisible then
						if self.PackInstance.bars[self.LastVisible] ~= self.CurrentBar then
							self.PackInstance.bars[self.LastVisible]:SetVisible(false)
						end
					end
					self.CurrentBar:SetVisible(true)
					self.LastVisible = self.BarID
				end
			else
				self.CurrentBar = nil
			end
			if _tracking[UnitID] then
				self.Engine = _tracking[UnitID]
				self.Engine:Add(self)
				if self.Engine.Active then
					self:Begin(self.Engine.Cast.Data)
				else
					self.Engine:Begin()
				end
			else
				self.Engine = _int:Castbar_Processor(UnitID)
				self.Engine:Add(self)
				self.Engine:Begin()
			end	
		end
		
		function CastObj:Load()
			if self.Enabled then
				if not self.Passive then
					if not self.Loaded then
						self.Loaded = true
						if self.Style == "dynamic" then
							self.PackInstance:LoadAll()
							self.BarID = "default"
							self.CurrentBar = self.PackInstance.bars["default"]
						else
							self.PackInstance:Load(self.Style)
							self.CurrentBar = self.PackInstance.bars[self.Style]
							self.BarID = self.Style
						end
					end
				end
			end		
		end
		
		function CastObj:Unload()
			if self.Loaded then
				self.Loaded = false
				self.CurrentBar = nil
				self.PackInstance:Recycle()
			end
		end
		
		function CastObj:StartType(UnitType)
			-- Start a castbar object tracking via type ie; "player", "player.target" etc...
			self.Type = UnitType
			self.Static = true
			self:Load()
			local currentUID = Inspect.Unit.Lookup(UnitType)
			if currentUID then
				self:Start(currentUID)
			end
			if not _typeHandlers[UnitType] then
				_typeHandlers[UnitType] = Library.LibUnitChange.Register(UnitType)
			end
			function self.Handler(handle, NewID)
				if NewID then
					self:Start(NewID)
				else
					self:Stop()
				end
			end
			Command.Event.Attach(_typeHandlers[UnitType], self.Handler, "LibSUnit - UnitID Change Handler for "..UnitType, -1)
		end
		
		function CastObj:Stop()
			-- Stop tracking, and remove UI and place it in cache for recycling. (Used with CastObj:Start)
			-- Use this for simple removal from the castbar engine.
			if self.Enabled then
				if self.CurrentBar then
					self.CurrentBar:Stop()
				end
			end
			self.UnitID = nil
			if self.Engine then
				self.Engine:Remove(self)
			end
			self.Engine = nil
			self.Active = false
		end
		
		function CastObj:Remove()
			-- Advanced Feature: Removes the CastObj entirely. (Can be used with either CastObj:Start and CastObj:StartType)
			-- ** Warning: This will remove all access to the object and will no longer be available. Usually best with Passive Cast Objects **
			self:Stop()
			self.Started = false
			if self.Static then
				Command.Event.Detach(_typeHandlers[self.Type], self.Handler)
			end
			if self.Loaded then
				if not self.Visible then
					self:Unload()
				end
			end
		end
		
		function CastObj:Recycle()
			self:Remove()
			self.PackInstance:Recycle()
			self.PackInstance = nil
		end
		
		function CastObj:Begin(CastData)
			self.CastData = CastData
			if self.Enabled then
				self.CurrentBar:Begin(CastData)
			end
		end
		
		function CastObj:End()
			if self.Enabled then
				self.CurrentBar:End()
			end
		end
		
		function CastObj:Interrupt()
			if self.Enabled then
				self.CurrentBar:Interrupt()
			end
		end
		
		function CastObj:EndNoAnim()
			if self.Enabled then
				self.CurrentBar:Stop()
			end
		end
		
		function CastObj:Update(remaining)
			if self.Enabled then
				self.CurrentBar:Queue(remaining)
			end
		end
		
		function CastObj:Pin(_pinFunction)
			if not self.pinned then
				-- print("[PIN] Apply")
				-- When started, this castbar will call the _pinFunction to align itself.
				if type(_pinFunction) ~= "function" then
					error(self.id..":Pin(_pinFunction) expecting function got "..type(_pinFunction))
				end
				self.pinFunction = _pinFunction
				self.pinned = true
				self.PackInstance:UpdatePin()
				-- print("--[PIN]")
				return self.CurrentBar
			end
		end
		
		function CastObj:Unpin()
			if self.pinned then
				-- print("[UNPIN] Apply")
				-- Returns a castbar to an unpinned state and will use relX,relY combo for positioning (defaults to center, top quarter of screen)
				self.pinned = false
				self.pinFunction = nil
				self.PackInstance:UpdatePin()
				-- print("--[UNPIN]")
				return self.CurrentBar
			end
		end
		
		function CastObj:Enable(bool)
			if self.Enabled ~= bool then
				self.Enabled = bool
				if not self.Passive then
					if self.Active then
						if bool then
							self:Load()
							if self.Engine then
								if self.Engine.Active then
								--	print("Activating current cast")
									self:Begin(self.Engine.Cast.Data)
								end
							end
							self.CurrentBar:SetVisible(self.Visible)
						else
						--	print("Unloading: "..self.Name)
							self:Unload()
						end
					end
				end
			end
		end
		
		function CastObj:SettingsTable(NewSettings)
			self.Settings = NewSettings
			self.PackInstance:SettingsTable(NewSettings)
		end
		
		function CastObj:SetVisible(bool)
			if not self.Passive then
				if self.Visible ~= bool then
					self.Visible = bool
					if bool then
						if not CastObj.CurrentBar then
							self.CurrentBar = self.PackInstance.bars[self.BarID]
						end
						self.CurrentBar:SetVisible(true)
						self.LastVisible = self.BarID
					else
						if self.CurrentBar then
							self.CurrentBar:SetVisible(false)
							self.LastVisible = nil
						end
					end
				end
			end
		end
		
		function CastObj:Unlocked(bool)
			if not self.Passive then
				self.PackInstance:SetEditMode(bool)			
			end
		end
	end
	
	return CastObj
end

function _int.Update_Handler(handle)
	if _queue._count > 0 then
		local cTime = Inspect.Time.Real()
		local renderBreak = cTime + 0.02
		local breakObj = _queue:Add("break")
		repeat
			local bar = _queue:RemoveFirst()
			if type(bar) == "table" then
				bar:Update()
			else
				if bar ~= "break" then
					_queue:Remove(breakObj)
				end
				break
			end
		until Inspect.Time.Real() > renderBreak
	end
	for UnitID, CastPro in pairs(_active) do
		CastPro:Update()
	end
end

function _int.Castbar_Handler(handle, units)
	for UnitID, Visible in pairs(units) do
		if _tracking[UnitID] then
			if Visible then
				_tracking[UnitID]:Visible(Visible)
			end
		end
	end
end

_int.Default:CreatePacks()

Command.Event.Attach(Event.Unit.Castbar, _int.Castbar_Handler, "Castbar Visibility Handler", -1)
Command.Event.Attach(Event.System.Update.Begin, _int.Update_Handler, "Castbar Update Handler", -1)
