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

local _store = {}
local _int = {
	Default = {},
	Packs = {},
}
local _tracking = {}

function _int.Default:Settings()
	local _set = {
		pack = "default", -- Texture pack to use for rendering.
		pinned = false, -- Is the castbar handled via a pin function. Usually castbars linked to other controlling frames.
		visible = false, -- Should the castbar be currently be rendered.
		relX = false, -- Percentage based screen positioning.
		relY = false, --/
		unlocked = false, -- Can be moved via left mouse button hold and drag. Pinned Castbars can never be unlocked.
		alpha = 1.0, -- Global alpha of the entire castbar.
		text = {
			enabled = true,
			alpha = 1.0,
			shadow = true, -- Enable text shadow
			glow = false, -- Enable text glow
			color = {
				font = {
					r = 1,
					g = 1,
					b = 1,
					a = 1,
				},
				shadow = {
					r = 1,
					g = 1,
					b = 1,
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

function _int.Default:TexturePack()
	-- You can create your own and supply it to LibSCast:TPackAdd(tPack)
	-- 
	local _tPack = {
		-- Default Castbar.
		id = "default", -- ID of your texture pack. It's probably best to prefix with your addon. Used as a key.
		display_name = "Default", -- Used for building settings pages.
		size = {
			w = 200,
			h = 24,
			t = 14,
		},
		layout = {
			[1] = { -- Use numbers to ensure the creation order is correct, 1 should always be the Cradle Texture/Frame.
				cradle = true, -- By setting a texture as the cradle, all other textures parent from it. Only 1 texture can be a cradle.
				id = "background", -- Id's are used for reference when setting your layouts. A key will be created with this id.
				file = "Media/background.png",
				addon = "SafesCastbarLib",
				points = {
				},
			},
			[2] = {
				id = "foreground", -- Overlay Texture, not always required.
				file = "Media/foreground.png",
				addon = "SafesCastbarLib",
				layer = 5, -- Layer for this Texture relative to <cradle>
				points = {
					link = "cradle",
					TOP = {
						ps = "TOP", -- Point to link to on <link>, Use ps for key based points. Use pv = {x = 0.5, y = 0.5} for value pairs.
						oy = 0.0, -- Y Offset for this point. (Ensure to use oy for TOP/BOTTOM)
					},
					BOTTOM = {
						ps = "BOTTOM",
						oy = 0.0,
					},
					LEFT = {
						ps = "LEFT",
						ox = 0.0, -- X Offset for this point. (Ensure to use ox for LEFT/RIGHT)
					},
					RIGHT = {
						ps = "RIGHT",
						ox = 0.0,
					},
				},
			},
			[3] = {
				id = "progbarI", -- Interruptible progress bar.
				file = false, -- Setting file or addon as false will mean this is a plain frame.
				addon = false,
				layer = 2,
				color = { -- If you wish to add a background color, supply a color quad here.
					r = 0.4,
					g = 0.4,
					b = 0.9,
					a = 1,
				},
				points = {
					link = "cradle",
					attach = {
						TOPLEFT = { -- You can also use pairing, ensure you supply both ox and oy as at least 0.
							ps = "TOPLEFT", -- Ensure the point string is also a pair string, or a a pv pair table.
							ox = 0.0,
							oy = 0.0,
						},
						BOTTOM = {
							ps = "BOTTOM",
							oy = 0.0,
						},
					},
					WIDTH = 0.0, -- Supply a width in percentage form, ensure you don't attempt to pin to right/left depending. (Float 0.0-1.0)
					MAXWIDTH = 200, -- You may supply a width to override that of the castbars width if you wish to position via offsets.
				},
			},
			[4] = {
				id = "progbarN", -- Non-interruptible progress bar.
				file = false,
				addon = false,
				layer = 2,
				color = {
					r = 0.6,
					g = 0.2,
					b = 0.3,
					a = 1,
				},
				points = {
					link = "cradle",
					attach = {
						TOPLEFT = {
							ps = "TOPLEFT",
							ox = 0.0,
							oy = 0.0,
						},
					},
					WIDTH = 0.0,
				},
			},
		},
	}
	LibSCast:TPackAdd(_tPack)
	_tPack = {
		-- Create Rift Style Castbar
		id = "rift",
		display_name = "Rift Style",
		size = {
			w = 200,
			h = 24,
			t = 14,
		},
		layout = {
			[1] = { 
				cradle = true,
				id = "background",
				file = "Media/background.png",
				addon = "SafesCastbarLib",
				points = {
				},
			},
			[2] = {
				id = "foreground",
				file = "Media/foreground.png",
				addon = "SafesCastbarLib",
				layer = 5, 
				points = {
					link = "cradle",
					TOP = {
						ps = "TOP",
						oy = 0.0,
					},
					BOTTOM = {
						ps = "BOTTOM",
						oy = 0.0,
					},
					LEFT = {
						ps = "LEFT",
						ox = 0.0,
					},
					RIGHT = {
						ps = "RIGHT",
						ox = 0.0,
					},
				},
			},
			[3] = {
				id = "progbarI",
				file = false,
				addon = false,
				layer = 2,
				color = {
					r = 0.4,
					g = 0.4,
					b = 0.9,
					a = 1,
				},
				points = {
					link = "cradle",
					attach = {
						TOPLEFT = {
							ps = "TOPLEFT",
							ox = 0.0,
							oy = 0.0,
						},
						BOTTOM = {
							ps = "BOTTOM",
							oy = 0.0,
						},
					},
					WIDTH = 0.0,
					MAXWIDTH = 200,
				},
			},
			[4] = {
				id = "progbarN",
				file = false,
				addon = false,
				layer = 2,
				color = {
					r = 0.6,
					g = 0.2,
					b = 0.3,
					a = 1,
				},
				points = {
					link = "cradle",
					attach = {
						TOPLEFT = {
							ps = "TOPLEFT",
							ox = 0.0,
							oy = 0.0,
						},
					},
					WIDTH = 0.0,
				},
			},
		},
	}
	LibSCast:TPackAdd(_tPack)
end

function LibSCast:TPackAdd(tPack)
	if type(tPack) == "table" then
		if type(tPack.id) ~= "string" then
			error("tPack.id : Expecting string got "..type(tPack.id))
		else
			if not _int.Packs[tPack.id] then
				_int.Packs[tPack.id] = tPack
				_store[tPack.id] = {} -- Used for caching UI elements.
			else
				error("tPack.id : ID already in use '"..tPack.id.."'")
			end
		end
	else
		error("LibSCast:TPackAdd(tPack) : Expecting table got "..type(tPack))
	end
end

function _int:Castbar_Processor()
	-- Handles data updates and dispatches render queue.
	local CastPro = {}
	
	function CastPro:Add(CastObj)
		-- Adds a cast object for rendering.
		
	end
	
	function CastPro:Remove(CastObj)
		-- Removes a cast object from rendering.
		
	end
	
	function CastPro:Show()
		-- Triggered when castbars become visible to the player.
	
	end
	function CastPro:Hide()
		-- Triggered when castbars are no longer visible to the player.
	
	end
	function CastPro:Queue()
		-- Queue UI cast object for rendering.
		
	end
	
	return CastPro
end

function LibSCast:Create(ID, Pack, Settings)
	local CastObj = {
		ID = ID,
		Settings = Settings or _int.Default:Settings(),
		Pack = Pack,
		Active = false,
	}
		
	if not _int[Pack] then
		error("LibSCast:Create(Pack, Settings) : Unknown Texture Pack '"..tostring(Pack).."'")
	else
		function CastObj:StartID(UnitID)
			-- Start a castbar object tracking via ID
			
		end
		function CastObj:Start(UnitType)
			-- Start a castbar object tracking via type ie; "player", "player.target" etc...
		
		end
		function CastObj:Stop()
			-- Stop tracking, and remove UI and place it in cache for recycling.
			
		end
		function CastObj:Pin(_pinFunction)
			-- When started, this castbar will call the _pinFunction to align itself.
			if type(_pinFunction) ~= "function" then
				error(self.ID..":Pin(_pinFunction) expecting function got "..type(_pinFunction))
			end
			self.pinFunction = _pinFunction
			if self.Settings.Unlocked then
				-- Hide drag frame.
			end
		end
		function CastObj:Unpin()
			-- Returns a castbar to an unpinned state and will use relX,relY combo for positioning (defaults to center, top third of screen)
		
		end
		function CastObj:UnLocked(bool)
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

end

function _int.Castbar_Handler(handle, units)
	for UnitID, Visible in pairs(units) do
		if _tracking[UnitID] then
		
		end
	end
end

_int.Default:TexturePack()
Command.Event.Attach(Event.Unit.Castbar, _int.Castbar_Handler, "Castbar Visibility Handler")
Command.Event.Attach(Event.System.Update.Begin, _int.Update_Handler, "Castbar Update Handler")