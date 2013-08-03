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
	CastBar = {
		Cast = {}
	},
}

function _int.Default.Settings()
	local _set = {
		enabled = true, -- Should the castbar start.
		pinned = false, -- Is the castbar handled via a pin function. Usually castbars linked to other controlling frames.
		visible = false, -- Should the castbar currently be rendered.
		relX = 0.5, -- Percentage based screen positioning. Default is central, top 3rd.
		relY = 0.25, --/
		unlocked = false, -- Can be moved via left mouse button hold and drag. Pinned Castbars can never be unlocked.
		alpha = 1.0, -- Global alpha for the entire castbar.
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
				enabled = false, -- Displays a cast icon, and uses "icon" frame.
				alpha = 1.0,
			},
			progbarI = {
				alpha = 1.0,
			},
			progbarN = {
				alpha = 1.0,
			},
			-- Add additional texture settings locally in your addon.
		},
		scale = {
			w = 1.0, -- Width Scale as percentage (1 = 100%)
			h = 1.0, -- Height Scale as percentage (1 = 100%)
			t = 1.0, -- Text Scale as percentage (1 = 100%)
		},
	}
	return _set
end
LibSCast.Default = {}
LibSCast.Default.BarSettings = _int.Default.Settings

function _int.Default.SimplePack()
	-- Required Structure for Castbar UI Objects
	-- Includes base methods and settings.
	--
	local _tBar = {
		id = "default", -- Must be unique local to a pack. An must always containt a "default" bar.
		_total = 0, -- used for unique Frame Names.
		_store = LibSata:Create(), -- For recycling UI elements.
	}
	
	function _tBar:Create(PackObj)
		-- Creates the UI elements, all custom elements should parent .cradle.
		-- This will only be called by the library if none are available in storage.
		local bar = {
			duration = 1, -- Default cast/channel duration in seconds.
			id = "default",
			ui = nil,-- UI Element location.
			packObj = PackObj, -- The bar which is requesting this ui element. Used for various settings.
			loaded = false,
		}
		--print("Simple Bar Created")
		function bar:Load()
			-- Used for initializing UI Elements. Either pulling from storage or create a new UI group.
			-- Best used when a CastObj:Start or CastObj:StartType is called to load all castbars in to memory.
			--
			--print("Standard Bar Loaded")
			self.ui = self._store:RemoveLast()
			if not self.ui then
				-- Create new UI elements.
				self.ui = {}
				self.ui.cradle = UI.CreateFrame("Frame", self.packObj.."_"..self.id.."_"..self._total, self._packObj.Parent)
				self.ui.cradle:SetBackgroundColor(0,0,0,0.5)
			end
			self.loaded = true
		end
		
		function bar:Start()
			-- Prepare the bar for visual display, setting any UI elements appropriately. 
			--
			self.Update = self.CastUpdate -- If you have animations for Interrupt or End events then ensure you set self.Update to the correct handler.
		
		end
		
		function bar:Interrupt()
			-- Change state to start an Interrupt animation, or End animation (if the same), or simply remove the bar UI from display.
			--
			self.Update = self.InterruptAnim -- If you wish to animate interrupt events change self.Update to self.InterruptAnim
			
		end
		
		function bar:End()
			-- Change state to start an End animation, or simply remove the bar UI from display.
			--
			self.Update = self.EndAnim -- If you wish to animate end of cast events change self.Update to self.EndAnim
		
		end
			
		function bar:Recycle()
			-- Used for placing UI elements in local storage.
			-- Best used when a CastObj:Stop is called.
			--
		end

		function bar:CastUpdate(progress, duration)
			-- Updates the castbar progress state, use duration and progress to update texture and text where applicable.
			
		end
		
		function bar:InterruptAnim()
			-- Only required if you're going to animate interruptions in any way. (Such as fading)
		
		end
		
		function bar:EndAnim()
			-- Only required if you're going to animate end of casts in any way. (Such as fading)
		
		end
		
		function bar:SetEditMode(bool)
		
		end
		bar.Update = bar.CastUpdate -- Set the default update handler.
		
		return bar
	end	
	
	local barPack = {
		default = _tBar, -- Required when sending bar packs.
	}
	LibSCast:TPackAdd("Simple", "Simple", barPack)
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
			loaded = false,
			anim = {},
			texture = self.texture,
		}
		function bar:Load()
			if self.loaded then
				return
			end
			if not self.LoadObj then
				self.LoadObj = _queue:Add(self)
				self.Update = self.Load
				return
			end
			self.LoadObj = nil
			self.ui = self.store:RemoveLast()
			--print("Rift "..self.id.." Bar Loaded")
			if not self.ui then
				local barObj = self.barObj
				barObj.total = barObj.total + 1
				self.ui = {}
				self.ui.cradle = UI.CreateFrame("Frame", self.packObj.id.."_"..self.id.."_"..barObj.total, self.packInstance.parent)
				self.ui.cradle:SetVisible(false)
				self.ui.foreground = UI.CreateFrame("Texture", self.packObj.id.."_"..self.id.."_"..barObj.total..": Foreground", self.ui.cradle)
				self.ui.foreground:SetLayer(3)
				self.ui.foreground:SetPoint("TOPLEFT", self.ui.cradle, "TOPLEFT")
				self.ui.foreground:SetPoint("BOTTOMRIGHT", self.ui.cradle, "BOTTOMRIGHT")
				LibTexture.LoadTexture(self.ui.foreground, self.texture.foreground.location, self.texture.foreground.file)
				self.ui.text = UI.CreateFrame("Text", self.packObj.id.."_"..self.id.."_"..barObj.total..": Text", self.ui.cradle)
				self.ui.text:SetPoint("CENTER", self.ui.cradle, "CENTER")
				self.ui.text:SetLayer(4)
				self.ui.text:SetEffectGlow({offsetX = 0, offsetY = 0, colorR = 0, colorG = 0, colorB = 0, strength = 2, blurX = 3, blurY = 3})
				self.ui.mask = UI.CreateFrame("Mask", self.packObj.id..".."..self.id.."_"..barObj.total..": Progress Bar Mask", self.ui.cradle)
				self.ui.mask:SetWidth(0)
				self.ui.mask:SetLayer(2)
				self.ui.mask:SetPoint("TOPLEFT", self.ui.cradle, barObj.default.progBar.tx, barObj.default.progBar.ty) 
				self.ui.mask:SetPoint("BOTTOM", self.ui.cradle, nil, barObj.default.progBar.by)
				-- Interruptible Progress Bar
				self.ui.progI = UI.CreateFrame("Texture", self.packObj.id.."_"..self.id.."_"..barObj.total..": Progress Bar Int", self.ui.mask)
				self.ui.progI:SetVisible(false)
				self.ui.progI:SetAlpha(0.8)
				LibTexture.LoadTexture(self.ui.progI, self.texture.progBarI.location, self.texture.progBarI.file)
				self.ui.progI:SetPoint("TOPLEFT", self.ui.mask, "TOPLEFT")
				self.ui.progI:SetPoint("BOTTOMRIGHT", self.ui.cradle, barObj.default.progBar.bx, barObj.default.progBar.by)
				-- Uninterruptible Progress Bar
				self.ui.progN = UI.CreateFrame("Texture", self.packObj.id.."_"..self.id.."_"..barObj.total..": Progress Bar No Int", self.ui.mask)
				LibTexture.LoadTexture(self.ui.progN, self.texture.progBarN.location, self.texture.progBarN.file)
				self.ui.progN:SetVisible(false)
				self.ui.progN:SetPoint("TOPLEFT", self.ui.mask, "TOPLEFT")
				self.ui.progN:SetPoint("BOTTOMRIGHT", self.ui.cradle, barObj.default.progBar.bx, barObj.default.progBar.by)
				self.ui.intBar = UI.CreateFrame("Texture", self.packObj.id.."_"..self.id.."_"..barObj.total..": Interrupt Bar", self.ui.mask)
				LibTexture.LoadTexture(self.ui.intBar, self.texture.intBar.location, self.texture.intBar.file)
				self.ui.intBar:SetVisible(false)
				self.ui.intBar:SetPoint("TOPLEFT", self.ui.mask, "TOPLEFT")
				self.ui.intBar:SetPoint("BOTTOMRIGHT", self.ui.cradle, barObj.default.progBar.bx, barObj.default.progBar.by)		
				self.ui.glow = UI.CreateFrame("Texture", self.packObj.id.."_"..self.id.."_"..barObj.total..": Glow", self.ui.cradle)
				LibTexture.LoadTexture(self.ui.glow, self.texture.glow.location, self.texture.glow.file)
				self.ui.glow:SetAlpha(0)
				self.ui.glow:SetLayer(5)
				self.ui.glow:SetPoint("TOPLEFT", self.ui.cradle, barObj.default.glow.tx, barObj.default.glow.ty)
				self.ui.glow:SetPoint("BOTTOMRIGHT", self.ui.cradle, barObj.default.glow.bx, barObj.default.glow.by)
				self.currentGlow = "file"
			else
				self.cradle:SetParent(self.packInstance.parent)
			end
			self.loaded = true
			self.Settings = self.packInstance.CastObj.Settings
			self.barObj.default.glow.duration = 1 - self.barObj.default.glow.start
			if not self.Settings.relX then
				self.Settings.relX = 0.5
				self.Settings.relY = 0.2
			end
			self:ApplySettings()
			if self.WaitStart then
				self.Update = self.Start
				self.WaitStart = false
			end
		end
		
		function bar:ApplySettings()
			if self.Settings.pinned then
				self.CastObj.pinFunction(self)
			else
				self.ui.cradle:SetPoint("CENTER", UIParent, self.Settings.relX, self.Settings.relY)
				self.ui.cradle:SetWidth(math.ceil(self.barObj.default.w * self.Settings.scale.w))
				self.ui.cradle:SetHeight(math.ceil(self.barObj.default.h * self.Settings.scale.h))
				self.ui.text:SetFontSize(math.ceil(self.barObj.default.textSize * self.Settings.scale.t))
			end
			self.progWidth = math.ceil(self.ui.cradle:GetWidth() * self.barObj.barScale)
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
			self.Name = CastData.abilityName
			self.Duration = CastData.duration or 1
			self.Remaining = CastData.remaining or 1
			self.Progress = self.Duration/self.Remaining
			self.ui.text:SetText(string.format("%0.01f", self.Remaining).." - "..self.Name)
			self.ui.cradle:SetAlpha(1)
			self.ui.intBar:SetVisible(false)
			if CastData.uninterruptible then
				self.progBar = self.ui.progN
				self.ui.progI:SetVisible(false)
				if self.currentGlow ~= "fileN" then
					if self.barObj.texture.glow.fileN then
						LibTexture.LoadTexture(self.ui.glow, self.barObj.texture.glow.location, self.barObj.texture.glow.fileN)
						self.currentGlow = "fileN"
					end
				end
			else
				self.progBar = self.ui.progI
				self.ui.progN:SetVisible(false)
				if self.currentGlow ~= "file" then
					if self.barObj.texture.glow.file then
						LibTexture.LoadTexture(self.ui.glow, self.barObj.texture.glow.location, self.barObj.texture.glow.file)
						self.currentGlow = "file"
					end
				end
			end
			self.ui.glow:SetAlpha(0)
			self.ui.mask:SetWidth(0)
			self.progBar:SetVisible(true)
			self.ui.cradle:SetVisible(true)
			if CastData.channeled then
				self.Update = self.ChannelUpdate
			else
				self.Update = self.CastUpdate
			end
			self.StartObj = nil
			self.Active = true
		end
		
		function bar:Interrupt()
			self.anim.endTime = Inspect.Time.Real() + self.barObj.default.anim.duration
			if self.CastData.uninterruptible then
				self.ui.text:SetText(LibSCast.Lang.Stopped)
			else
				self.ui.text:SetText(LibSCast.Lang.Interrupted)
			end
			self.progBar:SetVisible(false)
			self.ui.intBar:SetVisible(true)
			self.ui.mask:SetWidth(self.progWidth)
			self.Update = self.InterruptAnim
			if not self.UpdateObj then
				self.UpdateObj = _queue:Add(self)
			end
		end
		
		function bar:End()
			self.anim.endTime = Inspect.Time.Real() + self.barObj.default.anim.duration
			self.Update = self.EndAnim
			self.ui.text:SetText(self.Name)
			self.ui.mask:SetWidth(self.progWidth)
			if not self.UpdateObj then
				self.UpdateObj = _queue:Add(self)
			end
		end
		
		function bar:Stop()
			self.ui.cradle:SetVisible(false)
			self.ui.text:SetText(self.id)
			if self.UpdateObj then
				_queue:Remove(self.UpdateObj)
			end
			self.UpdateObj = nil
			self.Active = false
		end
			
		function bar:Recycle()
		end
				
		function bar:Queue(Remaining)
			self.Remaining = Remaining				
			if not self.UpdateObj then
				self.UpdateObj = _queue:Add(self)
			end
		end
		
		function bar:CastUpdate()
			self.Progress = 1 - self.Remaining/self.Duration
			local default = self.barObj.default
			local newWidth = math.floor(self.progWidth * self.Progress)
			if newWidth ~= self.ui.mask:GetWidth() then
				self.ui.mask:SetWidth(newWidth)
			end
			local newText = string.format("%0.01f", self.Remaining).." - "..self.Name
			if newText ~= self.ui.text:GetText() then
				self.ui.text:SetText(newText)
			end
			if self.Progress > default.glow.start then
				self.ui.glow:SetAlpha(1 * ((self.Progress - default.glow.start)/default.glow.duration))
			end
			self.UpdateObj = nil
		end
		
		function bar:ChannelUpdate()
			self.Progress = 1 - self.Remaining/self.Duration		
			local default = self.barObj.default
			local newWidth = math.ceil(self.progWidth * (1 - self.Progress))
			if newWidth ~= self.ui.mask:GetWidth() then
				self.ui.mask:SetWidth(newWidth)
			end
			local newText = string.format("%0.01f", self.Remaining).." - "..self.Name
			if newText ~= self.ui.text:GetText() then
				self.ui.text:SetText(newText)
			end		
			if self.Progress > default.glow.start then
				self.ui.glow:SetAlpha(1 * ((self.Progress - default.glow.start)/default.glow.duration))
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

		function bar:SetEditMode(bool)
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
				tx = 0.03,
				ty = 0.1,
				bx = 0.97,
				by = 0.9,
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
			progBarI = {
				location = AddonIni.id,
				file = "Media/Castbar_Cyan.png",
			},
			progBarN = {
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
	_defaultBar.barScale = _defaultBar.default.progBar.bx - _defaultBar.default.progBar.tx 
	_int.Default:CreateBar(_defaultBar)
	
	local barPack = {
		default = _defaultBar, -- Required when sending bar packs.
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
				
		function PackObj:Create(CastObj)
			-- Creates an instance of a Pack Object or uses one from local storage.
			-- Used when a Cast Object starts via :StartType or :Start
			--
			local PackInstance = {
				id = self.id,
				PackObj = self,
				CastObj = CastObj,
				Type = "LibSCast_PackObj",
				barObj = {},
				bars = {},
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

			function PackInstance:Recycle()
				-- Places created Bar Objects in a store for later use.
				-- This instance is no longer usable.
				--
				for id, bar in pairs(self.bars) do
					if bar.loaded then
						bar:Recycle()
					end
				end
			end
			
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
		self.Cast.Data = CastData
		if CastData then
			if self.Active then
				if self.Cast.Start == CastData.begin then
					return
				else
					self:Stop()
				end
			end
			_active[self.UnitID] = self
			self.Cast.Start = CastData.begin
			for _, CastObj in pairs(self.Castbars) do
				if not CastObj.Passive then
					CastObj:Begin(self.Cast.Data)
				end
			end
			self.Active = true
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
				self.Cast.Data.remaining = Inspect.Time.Real() - self.Cast.Start
				self:Begin()
			end
		else
			self.Cast.Data.remaining = Inspect.Time.Real() - self.Cast.Start
			self:Visible(false)
		end
	end
	
	function CastPro:Visible(bool)
		--print("------")
		--print("Cast State Changed: "..tostring(bool))
		if bool then
			self:Begin()
			--print("Cast started for: "..self.UnitObj.Name)
		else
			if self.Active then
				--print("Cast ended for: "..self.UnitObj.Name)
				-- Calculate if the cast was interrupted.
				if self.UnitObj.CurrentKey ~= "Idle" then
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
		CurrentBar = nil, -- Current UI Object in use.
	}
	if Pack then
		CastObj.Passive = false
		CastObj.Pack = _int.Packs[Pack] or _int.Packs["Simple"]
		CastObj.PackInstance = CastObj.Pack:Create(CastObj)
	else
		CastObj.Passive = true
	end
		
	if not _int.Packs[Pack] then
		error("LibSCast:Create(Pack, Settings) : Unknown Texture Pack '"..tostring(Pack).."'")
	else
		function CastObj:Start(UnitID)
			-- Start a castbar object tracking via UID only.
			if self.Settings.enabled then
				if self.Active then
					self:Stop()
				end
				if not self.Type then
					self.Type = UnitID
				end
				self.UnitID = UnitID
				self.Active = true
				if _tracking[UnitID] then
					self.Engine = _tracking[UnitID]
					self.Engine:Add(self)
					if self.Engine.Active then
						self:Begin(self.Engine.Cast.Data)
					end
				else
					self.Engine = _int:Castbar_Processor(UnitID)
					self.Engine:Add(self)
					self.Engine:Begin()
				end	
			end
		end
		
		function CastObj:StartType(UnitType)
			-- Start a castbar object tracking via type ie; "player", "player.target" etc...
			self.Type = UnitType
			self.Static = true
			if self.Style == "dynamic" then
				self.PackInstance:LoadAll()
			else
				self.PackInstance:Load(self.Style)
			end
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
			if self.CurrentBar then
				self.CurrentBar:Stop()
			end
			self.UnitID = nil
			if self.Engine then
				self.Engine:Remove(self)
			end
			self.Active = false
		end
		
		function CastObj:Remove()
			-- Advanced Feature: Removes the CastObj entirely. (Can be used with either CastObj:Start and CastObj:StartType)
			-- ** Warning: This will remove all access to the object and will no longer be available. Usually best with Passive Cast Objects **
			self:Stop()
			if self.Static then
				Command.Event.Detach(_typeHandlers[UnitType], self.Handler)
			end
		end
		
		function CastObj:Begin(CastData)
			if self.Style == "dynamic" then
				local cDetails = LibSUnit:RequestDetails(self.UnitID) -- Caster Unit Details
				local tier = cDetails.tier or "default"
				if cDetails.pvp then
					tier = "pvp"
				elseif cDetails.player then
					tier = "player"
				end	
				self.CurrentBar = self.PackInstance.bars[tier]
			else			
				self.CurrentBar = self.PackInstance.bars[self.Style]
			end
			self.CurrentBar:Begin(CastData)
		end
		
		function CastObj:End()
			self.CurrentBar:End()
			self.CurrentBar = nil
		end
		
		function CastObj:Interrupt()
			self.CurrentBar:Interrupt()
			self.CurrentBar = nil
		end
		
		function CastObj:EndNoAnim()
			self.CurrentBar:Stop()
			self.CurrentBar = nil
		end
		
		function CastObj:Update(remaining)
			self.CurrentBar:Queue(remaining)
		end
		
		function CastObj:Pin(_pinFunction)
			-- When started, this castbar will call the _pinFunction to align itself.
			if type(_pinFunction) ~= "function" then
				error(self.id..":Pin(_pinFunction) expecting function got "..type(_pinFunction))
			end
			self.pinFunction = _pinFunction
			self.Settings.Pinned = true
			if self.Settings.Unlocked then
				-- Hide drag frame.
			end
		end
		
		function CastObj:Unpin()
			-- Returns a castbar to an unpinned state and will use relX,relY combo for positioning (defaults to center, top quarter of screen)
			self.Settings.Pinned = false
			self.pinFunction = nil
			if self.Settings.Unlocked then
				-- Show drag frame.
			end
		end
		
		function CastObj:Unlocked(bool)
			self.Settings.Unlocked = bool
			if not bool then
				-- Hide drag frame.
			
			else
				-- Show drag frame.
			
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

Command.Event.Attach(Event.Unit.Castbar, _int.Castbar_Handler, "Castbar Visibility Handler", -1)
Command.Event.Attach(Event.System.Update.Begin, _int.Update_Handler, "Castbar Update Handler", -1)

_int.Default:CreatePacks()