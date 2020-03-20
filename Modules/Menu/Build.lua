-- KBM Menu System: Build Menu
-- Written by Paul Snart
-- Copyright 2014
--
local AddonIni, KBM = ...

local function BuildMenuSettings()
	local Menu = {}
	Menu.Callbacks = {}
	
	-- Settings
	function Menu.Main(Header)
		Menu.Callbacks.Main = {}
		local self = Menu.Callbacks.Main
		local Item = Header:CreateItem(KBM.Language.Options.Settings[KBM.Lang], "Main")
		local MenuItem

		function self:Character(bool)
			KBM.Options.Character = bool
			if bool then
				KBM_GlobalOptions = KBM.Options
				KBM.Options = chKBM_GlobalOptions
			else
				chKBM_GlobalOptions = KBM.Options
				KBM.Options = KBM_GlobalOptions
			end
			KBM.Options.Character = bool
			for _, Mod in ipairs(KBM.ModList) do
				if Mod.SwapSettings then
					Mod:SwapSettings(bool)
				end
			end
			KBM.Ready:SwapSettings(bool)
		end

		function self:Enabled(bool)
			KBM.StateSwitch(bool)
		end

		function self:Visible(bool)
			KBM.Options.Button.Visible = bool
			KBM.Button.Texture:SetVisible(bool)
		end

		function self:Unlocked(bool)
			KBM.Options.Button.Unlocked = bool
			KBM.Button:SetUnlocked(bool)
		end
		
		function self:Protect(bool)
			KBM.Options.Sheep.Protect = bool
			if bool then
				if KBM.Buffs.Active[KBM.Player.UnitID] then
					for SheepID, bool in pairs(KBM.SheepProtection.SheepList) do
						if KBM.Buffs.Active[KBM.Player.UnitID].Buff_Types[SheepID] then
							KBM.SheepProtection.Remove(KBM.Buffs.Active[KBM.Player.UnitID].Buff_Types[SheepID].id, KBM.Buffs.Active[KBM.Player.UnitID].Buff_Types[SheepID].caster)
						end
					end
				end
			end
		end
		
		function self:PlanarProtect(bool)
			KBM.Options.Planar.PlanarProtect = bool
			if bool then
				if KBM.Buffs.Active[KBM.Player.UnitID] then
					for PlanarID, bool in pairs(KBM.SheepProtection.PlanarList) do
						if KBM.Buffs.Active[KBM.Player.UnitID].Buff_Types[PlanarID] then
							KBM.SheepProtection.RemovePlanar(KBM.Buffs.Active[KBM.Player.UnitID].Buff_Types[PlanarID].id, KBM.Buffs.Active[KBM.Player.UnitID].Buff_Types[PlanarID].caster)
						end
					end
				end
			end
		end
		
		function self:Custom(item)
			KBM.Options.Font.Custom = item
		end

		Item.UI.CreateHeader(KBM.Language.Options.Character[KBM.Lang], KBM.Options, "Character", self)
		if KBM.IsAlpha then
			MenuItem = Item.UI.CreateHeader(KBM.Language.Options.ModEnabled[KBM.Lang].." Alpha", KBM.Options, "Enabled", self)
		else
			MenuItem = Item.UI.CreateHeader(KBM.Language.Options.ModEnabled[KBM.Lang], KBM.Options, "Enabled", self)
		end
		MenuItem:CreateCheck(KBM.Language.Options.Sheep[KBM.Lang], KBM.Options.Sheep, "Protect", self)
		MenuItem:CreateCheck(KBM.Language.Options.Planar[KBM.Lang], KBM.Options.Planar, "PlanarProtect", self)
		--TODO: Font Language Translations give indexing a nil field
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.Font[KBM.Lang], nil, "Font", nil)
		local fontDD = MenuItem:CreateDropDown(KBM.Language.Options.FontCustom[KBM.Lang], KBM.Options.Font, "Custom", self)
		for fontnum, FontSource in ipairs(KBM.Constant.Font) do
			if(fontnum==1) then
				table.insert(fontDD.ItemList, KBM.Language.Options.FontLegacy[KBM.Lang])
			else
				table.insert(fontDD.ItemList, FontSource[1])
			end
		end
		
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.Button[KBM.Lang], KBM.Options.Button, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.LockButton[KBM.Lang], KBM.Options.Button, "Unlocked", self)
		
		
		
		Item:Select()
	end

	-- Timers
	function Menu.Timers(Header)	
		Menu.Callbacks.Timers = {}
		Menu.Callbacks.MechTimers = {}
		local self = Menu.Callbacks.Timers
		local Item = Header:CreateItem(KBM.Language.Menu.Timers[KBM.Lang], "Timers")
		local MenuItem
		
		-- Encounter Timer Callbacks.
		function self:Enabled(bool)
			KBM.Options.EncTimer.Enabled = bool
		end
		function self:Visible(bool)
			KBM.Options.EncTimer.Visible = bool
			KBM.EncTimer.Frame:SetVisible(bool)
			KBM.EncTimer.Enrage.Frame:SetVisible(bool)
			KBM.Options.EncTimer.Unlocked = bool
			KBM.EncTimer.Frame.Drag:SetVisible(bool)
		end
		function self:Duration(bool)
			KBM.Options.EncTimer.Duration = bool
		end
		function self:Enrage(bool)
			KBM.Options.EncTimer.Enrage = bool
		end
		function self:ScaleHeight(bool, Check)
			KBM.Options.EncTimer.ScaleHeight = bool
		end
		function self:ScaleWidth(bool, Check)
			KBM.Options.EncTimer.ScaleWidth = bool
		end
		function self:TextScale(bool, Check)
			KBM.Options.EncTimer.TextScale = bool
		end
		
		-- Encounter Timer Options
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.EncTimers[KBM.Lang], KBM.Options.EncTimer, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.Options.Timer[KBM.Lang], KBM.Options.EncTimer, "Duration", self)
		MenuItem:CreateCheck(KBM.Language.Options.Enrage[KBM.Lang], KBM.Options.EncTimer, "Enrage", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowTimer[KBM.Lang], KBM.Options.EncTimer, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.EncTimer, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.EncTimer, "ScaleHeight", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.EncTimer, "TextScale", self)
		
		self = Menu.Callbacks.MechTimers
		-- Timer Callbacks
		function self:Enabled(bool)
			KBM.Options.MechTimer.Enabled = bool
		end
		function self:Shadow(bool)
			KBM.Options.MechTimer.Shadow = bool
		end
		function self:Texture(bool)
			KBM.Options.MechTimer.Texture = bool
		end
		function self:Visible(bool)
			KBM.Options.MechTimer.Visible = bool
			KBM.MechTimer.Anchor:SetVisible(bool)
			KBM.Options.MechTimer.Unlocked = bool
			KBM.MechTimer.Anchor.Drag:SetVisible(bool)
			if #KBM.MechTimer.ActiveTimers > 0 then
				KBM.MechTimer.Anchor.Text:SetVisible(false)
			else
				if bool then
					KBM.MechTimer.Anchor.Text:SetVisible(true)
				end
			end
		end
		function self:ScaleHeight(bool, Check)
			KBM.Options.MechTimer.ScaleHeight = bool
		end
		function self:ScaleWidth(bool, Check)
			KBM.Options.MechTimer.ScaleWidth = bool
		end
		function self:TextScale(bool, Check)
			KBM.Options.MechTimer.TextScale = bool
		end
		function self:Renderer(item)
			KBM.Options.MechTimer.Renderer = item
		end
		
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.MechanicTimers[KBM.Lang], KBM.Options.MechTimer, "Enabled", self)
		-- MechTimers.GUI.Check:SetEnabled(false)
		-- KBM.Options.MechTimer.Enabled = true
		local renderDD = MenuItem:CreateDropDown("Render pack:", KBM.Options.MechTimer, "Renderer", self)
		table.insert(renderDD.ItemList, "KBM")
		table.insert(renderDD.ItemList, "LifeIsMystery")
		MenuItem:CreateCheck(KBM.Language.Options.Texture[KBM.Lang], KBM.Options.MechTimer, "Texture", self)
		MenuItem:CreateCheck(KBM.Language.Options.Shadow[KBM.Lang], KBM.Options.MechTimer, "Shadow", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.MechTimer, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.MechTimer, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.MechTimer, "ScaleHeight", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.MechTimer, "TextScale", self)
	end

	-- Phases
	function Menu.Phases(Header)		
		Menu.Callbacks.Phases = {}
		local self = Menu.Callbacks.Phases
		local Item = Header:CreateItem(KBM.Language.Options.PhaseMonitor[KBM.Lang], "Phases")
		local MenuItem
		
		-- Phase Monitor Callbacks.
		function self:Enabled(bool)
			KBM.Options.PhaseMon.Enabled = bool
			if KBM.Options.PhaseMon.Visible then
				if bool then
					KBM.PhaseMonitor.Anchor:SetVisible(true)
				else
					KBM.PhaseMonitor.Anchor:SetVisible(false)
				end
			end
		end
		function self:Visible(bool)
			KBM.Options.PhaseMon.Visible = bool
			KBM.PhaseMonitor.Anchor:SetVisible(bool)
			KBM.Options.PhaseMon.Unlocked = bool
			KBM.PhaseMonitor.Anchor.Drag:SetVisible(bool)
		end
		function self:PhaseDisplay(bool)
			KBM.Options.PhaseMon.PhaseDisplay = bool
		end
		function self:Objectives(bool)
			KBM.Options.PhaseMon.Objectives = bool
		end
		function self:ScaleWidth(bool)
			KBM.Options.PhaseMon.ScaleWidth = bool
		end
		function self:ScaleHeight(bool)
			KBM.Options.PhaseMon.ScaleHeight = bool
		end
		function self:TextScale(bool)
			KBM.Options.PhaseMon.TextScale = bool
		end
				
		-- Timer Options
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.PhaseEnabled[KBM.Lang], KBM.Options.PhaseMon, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.Options.Phases[KBM.Lang], KBM.Options.PhaseMon, "PhaseDisplay", self)
		MenuItem:CreateCheck(KBM.Language.Options.Objectives[KBM.Lang], KBM.Options.PhaseMon, "Objectives", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.PhaseMon, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.PhaseMon, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.PhaseMon, "ScaleHeight", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.PhaseMon, "TextScale", self)
	end

	-- Castbars
	function Menu.CastBars(Header)
		Menu.Callbacks.CastBar = {}
		local self = Menu.Callbacks.CastBar
		local Item = Header:CreateItem(KBM.Language.Options.Castbar[KBM.Lang], "CastBars")
		local MenuItem
		self.texture = {}

		-- Castbar Callbacks
		function self:enabled(bool)
			KBM.Options.Castbar.Global.enabled = bool
			KBM.Castbar.Global.CastObj:Enable(bool)
			for UnitID, Castbar in pairs(KBM.Castbar.ActiveCastbars) do
				Castbar.CastObj:Enable(bool)
				if bool then
					Castbar.CastObj:SetVisible(KBM.Options.Castbar.Global.visible)
				else
					Castbar.CastObj:SetVisible(false)
				end
			end
			KBM.Castbar.Anchor:SetVisible(bool)
			if bool then
				KBM.Castbar.Global.CastObj:SetVisible(KBM.Options.Castbar.Global.visible)
			else
				KBM.Castbar.Global.CastObj:SetVisible(false)
			end
		end
		
		function self.texture:enabled(bool)
			KBM.Options.Castbar.Global.texture.foreground.enabled = bool
			KBM.Castbar.Global.CastObj:SetTexture("foreground", bool)
			for UnitID, Castbar in pairs(KBM.Castbar.ActiveCastbars) do
				Castbar.CastObj:SetTexture("foreground", bool)
			end
		end
		
		-- function self:Shadow(bool)
			-- KBM.Options.CastBar.Shadow = bool
			-- if KBM.CastBar.Anchor.GUI then
				-- KBM.CastBar.Anchor.GUI.Shadow:SetVisible(bool)
			-- end
		-- end
		
		function self:visible(bool)
			KBM.Options.Castbar.Global.visible = bool
			KBM.Options.Castbar.Global.unlocked = bool
			KBM.Castbar.Anchor:SetVisible(bool)
			KBM.Castbar.Global.CastObj:SetVisible(bool)
		end
		
		function self:widthUnlocked(bool)
			KBM.Options.Castbar.Global.scale.widthUnlocked = bool
		end
		
		function self:heightUnlocked(bool)
			KBM.Options.Castbar.Global.scale.heightUnlocked = bool
		end
		
		-- function self:TextScale(bool)
			-- KBM.Options.CastBar.TextScale = bool
		-- end
		
		function self:riftBar(bool)
			if bool then
				KBM.Options.Castbar.Global.pack = "Rift"
			else
				KBM.Options.Castbar.Global.pack = "Simple"
			end
			KBM.Options.Castbar.Global.riftBar = bool
			KBM.Castbar.Global.CastObj:SetPack(KBM.Options.Castbar.Global.pack)
			for UnitID, Castbar in pairs(KBM.Castbar.ActiveCastbars) do
				Castbar.CastObj:SetPack(KBM.Options.Castbar.Global.pack)
			end
		end

		-- CastBar Options. 
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.CastbarEnabled[KBM.Lang], KBM.Options.Castbar.Global, "enabled", self)
		MenuItem:CreateCheck(KBM.Language.Options.CastbarStyle[KBM.Lang], KBM.Options.Castbar.Global, "riftBar", self)
		MenuItem:CreateCheck(KBM.Language.Options.Texture[KBM.Lang], KBM.Options.Castbar.Global.texture.foreground, "enabled", self.texture)
		--MenuItem:CreateCheck(KBM.Language.Options.Shadow[KBM.Lang], KBM.Options.CastBar, "shadow", self)
		local SubMenu = MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.Castbar.Global, "visible", self)
		SubMenu:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.Castbar.Global.scale, "widthUnlocked", self)
		SubMenu:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.Castbar.Global.scale, "heightUnlocked", self)
		--MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.CastBar, "TextScale", self)
		
		-- Player Castbar Callbacks
		for _, Castbar in ipairs(KBM.Castbar.MenuOrder) do
			local self = {}
			self.texture = {}
			
			function self:enabled(bool)
				Castbar.Settings.enabled = bool
				Castbar.CastObj:Enable(bool)
				if bool then
					Castbar.CastObj:SetVisible(Castbar.Settings.visible)
					Castbar.CastObj:Unlocked(Castbar.Settings.unlocked)
				else
					Castbar.CastObj:SetVisible(false)
					Castbar.CastObj:Unlocked(false)
				end
			end
			
			function self:riftBar(bool)
				if bool then
					Castbar.Settings.pack = "Rift"
				else
					Castbar.Settings.pack = "Simple"
				end
				Castbar.Settings.riftBar = bool
				Castbar.CastObj:SetPack(Castbar.Settings.pack)
				if not Castbar.Settings.pinned then
					Castbar.CastObj:Unlocked(Castbar.Settings.unlocked)
				end
			end
			
			function self:pinned(bool)
				Castbar.Settings.pinned = bool
				if bool then
					Castbar.Settings.unlocked = false
					Castbar.CastObj:Unlocked(false)
					Castbar.CastObj:Pin(KBM.Castbar.PlayerPin)
					UI.Native.Castbar:EventAttach(Event.UI.Layout.Size, KBM.Castbar.HandlePinScale, "KBMCastbar-Mimic-PinScale-Handler")
				else
					Castbar.CastObj:Unpin()
					Castbar.CastObj:Unlocked(Castbar.Settings.visible)
					Castbar.Settings.unlocked = Castbar.Settings.visible
					UI.Native.Castbar:EventDetach(Event.UI.Layout.Size, KBM.Castbar.HandlePinScale, "KBMCastbar-Mimic-PinScale-Handler")
				end
			end
			
			function self.texture:enabled(bool)
				Castbar.Settings.texture.foreground.enabled = bool
				Castbar.CastObj:SetTexture("foreground", bool)
			end
			
			-- function self:Shadow(bool)
				-- KBM.Player.CastBar.Settings.CastBar.Shadow = bool
				-- KBM.Player.CastBar.CastObj:ApplySettings()
			-- end
			
			function self:visible(bool)
				Castbar.Settings.visible = bool
				Castbar.CastObj:SetVisible(bool)
				if not Castbar.Settings.pinned then
					Castbar.Settings.unlocked = bool
					Castbar.CastObj:Unlocked(bool)
				end
			end
			
			function self:widthUnlocked(bool)
				Castbar.Settings.scale.widthUnlocked = bool
			end
			
			function self:heightUnlocked(bool)
				Castbar.Settings.scale.heightUnlocked = bool
				Castbar.Settings.scale.textUnlocked = bool
			end
			-- function self:TextScale(bool)
				-- KBM.Player.CastBar.Settings.CastBar.TextScale = bool
			-- end
				
			MenuItem = Item.UI.CreateHeader(Castbar.MenuName, Castbar.Settings, "enabled", self)
			MenuItem:CreateCheck(KBM.Language.Options.CastbarStyle[KBM.Lang], Castbar.Settings, "riftBar", self)
			if Castbar.ID == "KBM_Player_Bar" then
				MenuItem:CreateCheck(KBM.Language.CastBar.Mimic[KBM.Lang], Castbar.Settings, "pinned", self)
			end
			MenuItem:CreateCheck(KBM.Language.Options.Texture[KBM.Lang], Castbar.Settings.texture.foreground, "enabled", self.texture)
			--MenuItem:CreateCheck(KBM.Language.Options.Shadow[KBM.Lang], KBM.Options.Player.CastBar, "Shadow", self)
			local SubMenu = MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], Castbar.Settings, "visible", self)
			SubMenu:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], Castbar.Settings.scale, "widthUnlocked", self)
			SubMenu:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], Castbar.Settings.scale, "heightUnlocked", self)
			--SubMenu:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], Castbar.Settings.scale, "textUnlocked", self)
		end
	end

	function Menu.Alerts(Header)
		Menu.Callbacks.Alerts = {}
		local self = Menu.Callbacks.Alerts
		local Item = Header:CreateItem(KBM.Language.Options.Alert[KBM.Lang], "Alerts")
		local MenuItem

		function self:Enabled(bool)
			KBM.Options.Alerts.Enabled = bool
		end
		function self:Visible(bool)
			KBM.Options.Alerts.Visible = bool
			if bool then
				KBM.Alert.Anchor:SetAlpha(1)
				KBM.Alert.Left.red:SetAlpha(1)
				KBM.Alert.Right.red:SetAlpha(1)
				KBM.Alert.Top.red:SetAlpha(1)
				KBM.Alert.Bottom.red:SetAlpha(1)
			end
			KBM.Alert:ApplySettings()
		end
		function self:ScaleText(bool)
			KBM.Options.Alerts.ScaleText = bool
		end
		function self:FlashUnlocked(bool)
			KBM.Options.Alerts.FlashUnlocked = bool
			-- if KBM.Options.Alerts.Visible then
				-- KBM.Alert.AlertControl.Left:SetVisible(bool)
				-- KBM.Alert.AlertControl.Right:SetVisible(bool)
				-- KBM.Alert.AlertControl.Top:SetVisible(bool)
				-- KBM.Alert.AlertControl.Bottom:SetVisible(bool)
			-- end
			KBM.Alert:ApplySettings()
		end
		function self:Flash(bool)
			KBM.Options.Alerts.Flash = bool
		end
		function self:Vertical(bool)
			KBM.Options.Alerts.Vertical = bool
			KBM.Alert:ApplySettings()
		end
		function self:Horizontal(bool)
			KBM.Options.Alerts.Horizontal = bool
			KBM.Alert:ApplySettings()
		end
		function self:Notify(bool)
			KBM.Options.Alerts.Notify = bool
		end

		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], KBM.Options.Alerts, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.Options.AlertText[KBM.Lang], KBM.Options.Alerts, "Notify", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.Alerts, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.Alerts, "ScaleText", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockFlash[KBM.Lang], KBM.Options.Alerts, "FlashUnlocked", self)
		MenuItem = MenuItem:CreateHeader(KBM.Language.Options.AlertFlash[KBM.Lang], KBM.Options.Alerts, "Flash", self)
		MenuItem:CreateCheck(KBM.Language.Options.AlertVert[KBM.Lang], KBM.Options.Alerts, "Vertical", self)
		MenuItem:CreateCheck(KBM.Language.Options.AlertHorz[KBM.Lang], KBM.Options.Alerts, "Horizontal", self)
	end

	-- Mechanic Spy
	function Menu.MechSpy(Header)
		Menu.Callbacks.MechSpy = {}
		local self = Menu.Callbacks.MechSpy
		local Item = Header:CreateItem(KBM.Language.MechSpy.Name[KBM.Lang], "MechSpy")
		local MenuItem	
		
		function self:Enabled(bool)
			KBM.Options.MechSpy.Enabled = bool
			KBM.MechSpy:ApplySettings()
		end
		function self:Show(bool)
			KBM.Options.MechSpy.Show = bool
			KBM.MechSpy:ApplySettings()
		end
		function self:Visible(bool)
			KBM.Options.MechSpy.Visible = bool
			KBM.MechSpy:ApplySettings()		
		end
		function self:ScaleWidth(bool)
			KBM.Options.MechSpy.ScaleWidth = bool
		end
		function self:ScaleHeight(bool)
			KBM.Options.MechSpy.ScaleHeight = bool
		end
		function self:ScaleText(bool)
			KBM.Options.MechSpy.ScaleText = bool
		end
				
		MenuItem = Item.UI.CreateHeader(KBM.Language.MechSpy.Enabled[KBM.Lang], KBM.Options.MechSpy, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.MechSpy.Show[KBM.Lang], KBM.Options.MechSpy, "Show", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.MechSpy, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.MechSpy, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.MechSpy, "ScaleHeight", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.MechSpy, "ScaleText", self)
	end

	local Header = KBM.Menu.Page:CreateHeader(KBM.Language.Menu.Global[KBM.Lang], "GLOP", "Main", "Main")
	Menu.Main(Header)
	Menu.Timers(Header)
	Menu.Phases(Header)
	Menu.CastBars(Header)
	Menu.Alerts(Header)
	Menu.MechSpy(Header)
end

local function BuildMenuModules()
	local Menu = {}
	Menu.Callbacks = {}

	-- Tank Swap
	function Menu.TankSwap(Header)
		Menu.Callbacks.TankSwap = {}
		local self = Menu.Callbacks.TankSwap
		local Item = Header:CreateItem(KBM.Language.TankSwap.Title[KBM.Lang], "TankSwap")
		local MenuItem, CheckItem
		
		-- Tank-Swap Close link.
		function self:Close()
			if KBM.Menu.Active then
				if KBM.TankSwap.Active then
					if KBM.TankSwap.Test then
						KBM.TankSwap:Remove()
						KBM.TankSwap.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
					end
				end
			else
				if KBM.TankSwap.Active then
					if KBM.TankSwap.Test then
						CheckItem.UI.Check:SetChecked(false)
					end
				end
			end
		end
		
		function self:Enabled(bool)
			KBM.Options.TankSwap.Enabled = bool
			KBM.TankSwap.Enabled = bool
		end
		
		function self:Visible(bool)
			KBM.Options.TankSwap.Visible = bool
			if not KBM.TankSwap.Active then
				KBM.TankSwap.Anchor:SetVisible(bool)
			end
		end
		
		function self:Unlocked(bool)
			KBM.Options.TankSwap.Unlocked = bool
			KBM.TankSwap.Anchor.Drag:SetVisible(bool)
		end
		
		function self:ScaleWidth(bool)
			KBM.Options.TankSwap.ScaleWidth = bool
		end
			
		function self:ScaleHeight(bool)
			KBM.Options.TankSwap.ScaleHeight = bool
		end
				
		function self:Tank(bool)
			KBM.Options.TankSwap.Tank = bool
		end
		
		function self:Test(bool)
			if bool then
				KBM.TankSwap:Add("Dummy", "Tank A")
				KBM.TankSwap:Add("Dummy", "Tank B")
				KBM.TankSwap:Add("Dummy", "Tank C")
				KBM.TankSwap.Anchor:SetVisible(false)
			else
				KBM.TankSwap:Remove()
				KBM.TankSwap.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
			end
		end
		
		-- Tank-Swap Options. 
		MenuItem = Item.UI.CreateHeader(KBM.Language.TankSwap.Enabled[KBM.Lang], KBM.Options.TankSwap, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.TankSwap, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.TankSwap.Tank[KBM.Lang], KBM.Options.TankSwap, "Tank", self)
		CheckItem = MenuItem:CreateCheck(KBM.Language.TankSwap.Test[KBM.Lang], nil, "Test", self)
		MenuItem = MenuItem:CreateHeader(KBM.Language.Options.LockAnchor[KBM.Lang], KBM.Options.TankSwap, "Unlocked", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.TankSwap, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.TankSwap, "ScaleHeight", self)
		
		Item:SetCloseLink(self.Close)
	end

	-- Percentage Monitor
	function Menu.PerMon(Header)
		Menu.Callbacks.PerMon = {}
		local self = Menu.Callbacks.PerMon
		local Item = Header:CreateItem(KBM.Language.PerMon.Title[KBM.Lang], "PerMon")
		local MenuItem
		
		function self:Enabled(bool)
			KBM.PercentageMon.Settings.Enabled = bool
			KBM.PercentageMon.GUI.Cradle:SetVisible(bool)
		end
		function self:Unlocked(bool)
			KBM.PercentageMon.Settings.Unlocked = bool
			if bool then
				KBM.PercentageMon:SetEvents()
			else
				KBM.PercentageMon:ClearEvents()
			end
		end
		function self:Scalable(bool)
			KBM.PercentageMon.Settings.Scalable = bool
			if bool then
				KBM.PercentageMon:UnlockScale()
			else
				KBM.PercentageMon:LockScale()
			end
		end
		function self:Names(bool)
			KBM.PercentageMon.Settings.Names = bool
			KBM.PercentageMon:SetNames()
		end
		function self:Marks(bool)
			KBM.PercentageMon.Settings.Marks = bool
			KBM.PercentageMon:SetMarkL()
			KBM.PercentageMon:SetMarkR()
		end
		function self:Percent(bool)
			KBM.PercentageMon.Settings.Percent = bool
			KBM.PercentageMon:SetPercentL()
			KBM.PercentageMon:SetPercentR()
		end
		
		MenuItem = Item.UI.CreateHeader(KBM.Language.PerMon.Enable[KBM.Lang], KBM.PercentageMon.Settings, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.PerMon.Unlock[KBM.Lang], KBM.PercentageMon.Settings, "Unlocked", self)
		MenuItem:CreateCheck(KBM.Language.PerMon.Scale[KBM.Lang], KBM.PercentageMon.Settings, "Scalable", self)
		MenuItem:CreateCheck(KBM.Language.PerMon.Name[KBM.Lang], KBM.PercentageMon.Settings, "Names", self)
		MenuItem:CreateCheck(KBM.Language.PerMon.Mark[KBM.Lang], KBM.PercentageMon.Settings, "Marks", self)
		MenuItem:CreateCheck(KBM.Language.PerMon.Percent[KBM.Lang], KBM.PercentageMon.Settings, "Percent", self)
	end	

	-- Ready Check
	function Menu.ReadyCheck(Header)
		Menu.Callbacks.ReadyCheck = {}
		Menu.Callbacks.ReadyButton = {}
		local self = Menu.Callbacks.ReadyCheck
		local Item = Header:CreateItem(KBM.Language.ReadyCheck.Name[KBM.Lang], "ReadyCheck")
		local MenuItem
	
		function self:Enabled(bool)
			KBM.Ready.Enabled = bool
			KBM.Ready.Enable(bool)
			KBM.Ready.Button:ApplySettings()
		end
		function self:Combat(bool)
			KBM.Ready.Settings.Combat = bool
			KBM.Ready.UpdateSMode()
		end
		function self:Solo(bool)
			KBM.Ready.Settings.Solo = bool
			KBM.Ready.UpdateSMode()
		end
		function self:Unlocked(bool)
			KBM.Ready.Settings.Unlocked = bool
			KBM.Ready.SetLock()
		end
		function self:Hidden(bool)
			KBM.Ready.Settings.Hidden = bool
			KBM.Ready.UpdateSMode()
		end
		function self:Scale(bool)
			KBM.Ready.Settings.Scale = bool
			KBM.Ready.GUI:SetScaling(bool)
		end
			
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.Enabled[KBM.Lang], KBM.Ready.Settings, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.ReadyCheck.Unlock[KBM.Lang], KBM.Ready.Settings, "Unlocked", self)
		MenuItem:CreateCheck(KBM.Language.ReadyCheck.Size[KBM.Lang], KBM.Ready.Settings, "Scale", self)
		MenuItem:CreateCheck(KBM.Language.ReadyCheck.Hidden[KBM.Lang], KBM.Ready.Settings, "Hidden", self)
		MenuItem:CreateCheck(KBM.Language.ReadyCheck.Combat[KBM.Lang], KBM.Ready.Settings, "Combat", self)
		MenuItem:CreateCheck(KBM.Language.ReadyCheck.Solo[KBM.Lang], KBM.Ready.Settings, "Solo", self)
		
		-- Button Settings
		self = Menu.Callbacks.ReadyButton
		function self:Visible(bool)
			KBM.Ready.Settings.Button.Visible = bool
			KBM.Ready.Button:ApplySettings()
		end
		function self:Unlocked(bool)
			KBM.Ready.Settings.Button.Unlocked = bool
			KBM.Ready.Button:SetUnlocked(bool)
		end
		
		MenuItem = MenuItem:CreateHeader(KBM.Language.Options.Button[KBM.Lang], KBM.Ready.Settings.Button, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.LockButton[KBM.Lang], KBM.Ready.Settings.Button, "Unlocked", self)
	end

	-- Res Master
	function Menu.ResMaster(Header)
		Menu.Callbacks.ResMaster = {}
		local self = Menu.Callbacks.ResMaster
		local Item = Header:CreateItem(KBM.Language.ResMaster.Name[KBM.Lang], "ResMaster")
		local MenuItem
		
		function self:Enabled(bool)
			KBM.Options.ResMaster.Enabled = bool
			if bool then
				KBM.PlayerControl:GatherAbilities(true)
				KBM.PlayerControl:GatherRaidInfo()
			else
				KBM.ResMaster.Rezes:Clear()
			end
		end
		function self:Visible(bool)
			KBM.Options.ResMaster.Visible = bool
			KBM.Options.ResMaster.Unlocked = bool
			KBM.ResMaster.GUI:ApplySettings()
		end
		function self:ScaleWidth(bool)
			KBM.Options.ResMaster.ScaleWidth = bool
		end
		function self:ScaleHeight(bool)
			KBM.Options.ResMaster.ScaleHeight = bool
		end
		function self:ScaleText(bool)
			KBM.Options.ResMaster.ScaleText = bool
		end
		function self:Cascade(bool)
			KBM.Options.ResMaster.Cascade = bool
			KBM.ResMaster:ReOrder()
		end
		
		MenuItem = Item.UI.CreateHeader(KBM.Language.ResMaster.Enabled[KBM.Lang], KBM.Options.ResMaster, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.ResMaster.Cascade[KBM.Lang], KBM.Options.ResMaster, "Cascade", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.ResMaster, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.ResMaster, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.ResMaster, "ScaleHeight", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.ResMaster, "ScaleText", self)
	end
	
	local Header = KBM.Menu.Page:CreateHeader(KBM.Language.Menu.Mods[KBM.Lang], "MODS", "Main", "Main")
	Menu.TankSwap(Header)
	Menu.PerMon(Header)
	Menu.ReadyCheck(Header)
	Menu.ResMaster(Header)	
end

function KBM.InitMenus()	
	-- New Style Menu
	BuildMenuSettings()
	BuildMenuModules()

	-- Reset References for missing UTIDs
	-- These are compiled fresh each run.
	KBM.Options.UnitCache.Raid = {}
	KBM.Options.UnitCache.Sliver = {}
	KBM.Options.UnitCache.Master = {}
	KBM.Options.UnitCache.Expert = {}
	KBM.Options.UnitCache.Normal = {}
	
	-- Compile Boss Menus
	for _, Mod in ipairs(KBM.ModList) do
		Mod:AddBosses(KBM.Boss.Name)
		if Mod.InstanceObj then
			if not KBM.Boss[Mod.InstanceObj.Type] then
				print("WARNING: Encounter "..Mod.InstanceObj.Name.." has an incorrect Type value of "..tostring(Mod.InstanceObj.Type))
			end
			Mod.UTID = {}
			for BossName, BossObj in pairs(Mod.Bosses) do
				if BossObj.UTID then
					if type(BossObj.UTID) == "table" then
						for i, UTID in pairs(BossObj.UTID) do
							KBM.AllocateBoss(Mod, BossObj, UTID, i)
							Mod.UTID[UTID] = BossObj
						end
					elseif type(BossObj.UTID) == "string" then
						KBM.AllocateBoss(Mod, BossObj, BossObj.UTID)
						Mod.UTID[BossObj.UTID] = BossObj
					else
						print("Error: UTID for "..BossObj.Name.." is an incorrect type (string/table)")
						error("Type is: "..type(UTID))
					end
				elseif BossObj.RaidID then
					print("WARNING: Old style RaidID field used for: "..BossObj.Name)
					print("in Encounter: "..Mod.InstanceObj.Name)
				elseif BossObj.SliverID then
					print("WARNING: Old style SliverID field used for: "..BossObj.Name)
					print("in Encounter: "..Mod.InstanceObj.Name)					
				else
					if Mod.InstanceObj.Type == "Normal" or Mod.InstanceObj.Type == "Expert" or Mod.InstanceObj.Type == "Master" then
						print(string.format("WARNING: Old style %sID field used for: "..BossObj.Name, Mod.InstanceObj.Type))
						print("in Encounter: "..Mod.InstanceObj.Name)					
					else
						print("Instance: "..BossObj.Mod.Instance)
						error("Missing RaidID or SliverID for "..BossObj.Name)
					end
				end
				if BossObj.ChronicleID then
					KBM.Boss.Chronicle[BossObj.ChronicleID] = BossObj
					KBM.Boss.TypeList[BossObj.ChronicleID] = BossObj
					Mod.UTID[BossObj.ChronicleID] = BossObj
				end
				if KBM.SubBoss[BossObj.Name] then
					print("WARNING: Boss "..BossObj.Name.." assigning old style KBM.SubBoss table entry")
					print("Instance: "..Mod.InstanceObj.Name.." ("..Mod.InstanceObj.Type..")")				
					print("Encounter: "..Mod.Descript)
				end
			end
			Mod.InstanceObj.MenuObj:CreateEncounter(Mod)
		elseif not Mod.IsInstance then
			error(tostring(Mod.ID).." is missing required field: InstanceObj")
		else
			-- Instance Header
			KBM.Menu.Instance:Create(Mod)
		end
		Mod:Start()
	end	
end