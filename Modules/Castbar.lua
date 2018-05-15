-- KBM: Castbar Handling
-- Written by Paul Snart
-- Copyright 2013
--

local AddonIni, KBM = ...
if not KBM then
	return
end

local LSC = Inspect.Addon.Detail("SafesCastbarLib")
local LibSCast = LSC.data
if not LibSCast then
	return
end

local LSA = Inspect.Addon.Detail("SafesTableLib")
local LibSata = LSA.data

KBM.Castbar = {}

function KBM.Castbar:DefaultSelf()
	local CastObj = {
		ID = "KBM_Player_Bar",
		Type = "player",
		Style = "default",
		Pack = "Rift",
		Name = "Your Castbar",
		MenuName = KBM.Language.CastBar.Player[KBM.Lang],
		relX = 0.5, 
		relY = 0.25,
	}
	return CastObj
end

function KBM.Castbar:DefaultTarget()
	local CastObj = {
		ID = "KBM_Player_Target",
		Type = "player.target",
		Pack = "Rift",
		Name = "Target Castbar",
		MenuName = KBM.Language.CastBar.Target[KBM.Lang],
		relX = 0.688,
		relY = 0.45,
	}
	return CastObj
end

function KBM.Castbar:DefaultFocus()
	local CastObj = {
		ID = "KBM_Player_Focus",
		Type = "focus",
		Pack = "Rift",
		Name = "Focus Castbar",
		MenuName = KBM.Language.CastBar.Focus[KBM.Lang],
		relX = 0.25,
		relY = 0.61,
	}
	return CastObj
end

function KBM.Castbar:DefaultGlobal()
	local CastObj = {
		ID = "KBM_Global_Bar",
		Style = "raid",
		Pack = "Rift",
		Name = "Global Boss Castbar",
		relX = 0.5,
		relY = 0.7,
	}
	return CastObj
end

KBM.Castbar.Player = {
	Self = KBM.Castbar:DefaultSelf(),
	Target = KBM.Castbar:DefaultTarget(),
	Focus = KBM.Castbar:DefaultFocus(),
}
KBM.Castbar.Global = KBM.Castbar:DefaultGlobal()
KBM.Castbar.Event = {}

KBM.Castbar.MenuOrder = {}
table.insert(KBM.Castbar.MenuOrder, KBM.Castbar.Player.Self)
table.insert(KBM.Castbar.MenuOrder, KBM.Castbar.Player.Target)
table.insert(KBM.Castbar.MenuOrder, KBM.Castbar.Player.Focus)

function KBM.Castbar.HandlePinScale()
	local self = KBM.Castbar.Player.Self.CastObj.CurrentBar
	if self then
		if self.ui then
			local diff = self.ui.cradle:GetHeight() / self:GetDefaultHeight()
			self.ui.text:SetFontSize((self.barObj.default.textSize * diff) - 1)
			if (KBM.Options.Font.Custom > 1) then self.ui.text:SetFont(AddonIni.identifier, KBM.Constant.Font[KBM.Options.Font.Custom][2]) end
		end
	end
end

function KBM.Castbar:PlayerPin()
	self.ui.cradle:ClearAll()
	self.ui.cradle:SetAllPoints(UI.Native.Castbar)
	local diff = self.ui.cradle:GetHeight() / self:GetDefaultHeight()
	self.ui.text:SetFontSize((self.barObj.default.textSize * diff) - 1)
	if (KBM.Options.Font.Custom > 1) then self.ui.text:SetFont(AddonIni.identifier, KBM.Constant.Font[KBM.Options.Font.Custom][2]) end
end

function KBM.Castbar:Init()
		-- New Castbar Initialization
	self.ActiveCastbars = {}
	self.ActiveCount = 0
		
	-- Boss Castbars
	self.Anchor = {
		Bars = LibSata:Create(),
		VisibleBars = LibSata:Create(),
	}
	self.Anchor.cradle = UI.CreateFrame("Frame", "Castbar Anchor Frame", KBM.Context)
	self.Anchor.cradle:SetLayer(KBM.Layer.DragActive)
	
	function self.Anchor:AddBar(castObj)
		--print("** Adding Bar: "..castObj.Name)
		if not castObj.AnchorObj then
			castObj.AnchorObj = self.Bars:Add(castObj)
			castObj:Pin(self.PinManager)
			if castObj.Visible then
				self:ShowBar(castObj, castObj.CurrentBar)
			end
			--print("** Added")
		end
	end
	
	function self.Anchor:RemoveBar(castObj)
		if castObj.AnchorObj then
			if castObj.CurrentBar then
				if castObj.CurrentBar.visibleObj then
					self:HideBar(castObj, castObj.CurrentBar)
				end
			end
			castObj:Unpin()
			self.Bars:Remove(castObj.AnchorObj)
			castObj.AnchorObj = nil
		end
	end
	
	function self.Anchor:ShowBar(castObj, barObj)
		if castObj.AnchorObj then
			if not barObj.visibleObj then
				--print("** Showing bar: "..castObj.Name)
				local _, lastBar = self.VisibleBars:Last()
				barObj.visibleObj = self.VisibleBars:Add(barObj)
				if lastBar then
					barObj.ui.cradle:SetPoint("TOPCENTER", lastBar.ui.cradle, "BOTTOMCENTER")
					self.cradle:SetHeight(self.cradle:GetHeight() + barObj.ui.cradle:GetHeight())
				else
					barObj.ui.cradle:SetPoint("TOPCENTER", self.cradle, "TOPCENTER")
					self.cradle:SetWidth(barObj:GetWidth())
					self.cradle:SetHeight(barObj:GetHeight())
					self.cradle:SetVisible(true)
				end
			end
		end
	end
	
	function self.Anchor:HideBar(castObj, barObj)
		if castObj.AnchorObj then
			if barObj.visibleObj then
				--print("** Hiding bar: "..castObj.Name)
				if self.VisibleBars:First() == barObj.visibleObj then
					local barAfter = self.VisibleBars:After(barObj.visibleObj)
					if barAfter then
						barAfter._data.ui.cradle:SetPoint("TOPCENTER", self.cradle, "TOPCENTER")
					end
				else
					local barAfter = self.VisibleBars:After(barObj.visibleObj)
					if barAfter then
						local barBefore = self.VisibleBars:Before(barObj.visibleObj)
						if barBefore then
							barAfter._data.ui.cradle:SetPoint("TOPCENTER", barBefore._data.ui.cradle, "BOTTOMCENTER")
						end
					end
				end
				self.VisibleBars:Remove(barObj.visibleObj)
				if self.VisibleBars:Count() == 0 then
					self.cradle:SetVisible(false)
				end
				barObj.ui.cradle:ClearPoint("TOPCENTER")
				self.cradle:SetHeight(self.cradle:GetHeight() - barObj:GetHeight())
				barObj.visibleObj = nil
			end
		end
	end
	
	function self.Anchor:PinManager()	
		self.ui.cradle:ClearAll()
		self.ui.cradle:SetWidth(math.ceil(self.barObj.default.w * KBM.Options.Castbar.Global.scale.w))
		self.ui.cradle:SetHeight(math.ceil(self.barObj.default.h * KBM.Options.Castbar.Global.scale.h))
		self.ui.text:SetFontSize(math.ceil(self.barObj.default.textSize * KBM.Options.Castbar.Global.scale.t))
		if (KBM.Options.Font.Custom > 1) then self.ui.text:SetFont(AddonIni.identifier, KBM.Constant.Font[KBM.Options.Font.Custom][2]) end
	end
	
	function self.Anchor.ManageEdit(cmd, relX, relY)
		if cmd == "end" then
			KBM.Options.Castbar.Global.relX = relX
			KBM.Options.Castbar.Global.relY = relY
		end
	end
	
	function self.Anchor.BarVisible(handle, barObj, castObj)
		local self = KBM.Castbar.Anchor
		if castObj.AnchorObj then
			self:ShowBar(castObj, barObj)
		end
	end
	
	function self.Anchor.BarRemove(handle, barObj, castObj)
		local self = KBM.Castbar.Anchor
		if barObj.visibleObj then
			self:HideBar(castObj, barObj)
		end
	end
	
	function self.Anchor:SetVisible(bool)
		self.cradle:SetVisible(bool)
		self.dragFrame:SetVisible(bool)
	end
	
	function self.Anchor:ApplyScale()
		local newHeight = 0
		local newWidth = 0
		for _, BarObj in LibSata.EachIn(self.VisibleBars) do
			BarObj:ApplyScale()
			newHeight = newHeight + BarObj:GetHeight()
			newWidth = BarObj:GetWidth()
		end
		self.cradle:SetWidth(newWidth)
		self.cradle:SetHeight(newHeight)
	end

	self.Anchor.EventFunc = {}
	function self.Anchor.EventFunc:HandleMouseWheelForward()
		local changed = false
		local Settings = KBM.Options.Castbar.Global
		
		if Settings.scale.widthUnlocked then
			if Settings.scale.w < 2 then
				Settings.scale.w = Settings.scale.w + 0.05
				changed = true
				if Settings.scale.w > 2 then
					Settings.scale.w = 2
				end
			end
		end
		
		if Settings.scale.heightUnlocked then
			if Settings.scale.h < 2 then
				Settings.scale.h = Settings.scale.h + 0.05
				changed = true
				if Settings.scale.h > 2 then
					Settings.scale.h = 2
				end
				Settings.scale.t = Settings.scale.h
			end
		end
		
		if changed then
			KBM.Castbar.Anchor:ApplyScale()
		end
	end
	
	function self.Anchor.EventFunc:HandleMouseWheelBack()
		local changed = false
		local Settings = KBM.Options.Castbar.Global
		
		if Settings.scale.widthUnlocked then
			if Settings.scale.w > 0.5 then
				Settings.scale.w = Settings.scale.w - 0.05
				changed = true
				if Settings.scale.w < 0.5 then
					Settings.scale.w = 0.5
				end
			end
		end
		
		if Settings.scale.heightUnlocked then
			if Settings.scale.h > 0.5 then
				Settings.scale.h = Settings.scale.h - 0.05
				changed = true
				if Settings.scale.h < 0.5 then
					Settings.scale.h = 0.5
				end
				Settings.scale.t = Settings.scale.h
			end
		end
		
		if changed then
			KBM.Castbar.Anchor:ApplyScale()
		end	
	end
	
	function self.Anchor.EventFunc:HandleMouseWheelClick()
		local changed = false
		local Settings = KBM.Options.Castbar.Global
		
		if Settings.scale.w then
			if Settings.scale.w ~= 1 then
				changed = true
				Settings.scale.w = 1
			end
		end
	
		if Settings.scale.h then
			if Settings.scale.h ~= 1 then
				changed = true
				Settings.scale.h = 1
				Settings.scale.t = 1
			end
		end
		
		if changed then
			KBM.Castbar.Anchor:ApplyScale()
		end
	end
	
	Command.Event.Attach(Event.SafesCastbarLib.Castbar.Show, self.Anchor.BarVisible, "KBM_Anchor_Castbar_Shown")
	Command.Event.Attach(Event.SafesCastbarLib.Castbar.Hide, self.Anchor.BarRemove, "KBM_Anchor_Castbar_Hidden")
end

function KBM.Castbar:LoadPlayerBars()
	for ID, Castbar in pairs(KBM.Castbar.Player) do
		if not Castbar.Settings.version then
			Castbar.Settings.enabled = true
			Castbar.Settings.unlocked = true
			Castbar.Settings.visible = true
			Castbar.Settings.custom = false
		end
		Castbar.CastObj = LibSCast:Create(Castbar.ID, KBM.Context, Castbar.Settings.pack, Castbar.Settings, Castbar.Style)
		Castbar.CastObj.Name = Castbar.Name
		Castbar.CastObj:StartType(Castbar.Type)
	end
	if KBM.Options.Castbar.Player.Self.pinned then
		KBM.Castbar.Player.Self.CastObj:Unlocked(false)
		KBM.Options.Castbar.Player.Self.unlocked = false
		KBM.Castbar.Player.Self.CastObj:Pin(KBM.Castbar.PlayerPin)
		UI.Native.Castbar:EventAttach(Event.UI.Layout.Size, KBM.Castbar.HandlePinScale, "KBMCastbar-Mimic-PinScale-Handler")
	end
	
	self.Global.CastObj = LibSCast:Create("KBM_Global_Castbar", 
		self.Anchor.cradle, 
		KBM.Options.Castbar.Global.pack, 
		KBM.Options.Castbar.Global, 
		KBM.Castbar.Global.Style)
		
	self.Global.CastObj.Name = "Boss Castbars"
	self.Global.Settings = self.Global.CastObj.Settings
	
	self.Anchor.cradle:SetPoint("CENTER", UIParent, KBM.Options.Castbar.Global.relX, KBM.Options.Castbar.Global.relY)
	self.Anchor:AddBar(self.Global.CastObj)
	self.Anchor.cradle:SetVisible(false)
	self.Anchor.dragFrame = KBM.CreateEditFrame(self.Anchor.cradle, self.Anchor.ManageEdit, 2)
	self.Anchor.dragFrame:SetVisible(false)
	self.Anchor.dragFrame:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, self.Anchor.EventFunc.HandleMouseWheelForward, 
		"KBMCastbarAnchor-EditFrame-MouseWheelForwardHandler_"..self.Anchor.cradle:GetName())
	self.Anchor.dragFrame:EventAttach(Event.UI.Input.Mouse.Wheel.Back, self.Anchor.EventFunc.HandleMouseWheelBack, 
		"KBMCastbarAnchor-EditFrame-MouseWheelBackHandler_"..self.Anchor.cradle:GetName())
	self.Anchor.dragFrame:EventAttach(Event.UI.Input.Mouse.Middle.Click, self.Anchor.EventFunc.HandleMouseWheelClick,
		"KBMCastbarAnchor-EditFrame-MouseMiddleClickHandler_"..self.Anchor.cradle:GetName())
		
	Command.Event.Attach(Event.SafesCastbarLib.Cast.Start, self.Event.CastStart, "KBMCastStart_Handler")
	Command.Event.Attach(Event.SafesCastbarLib.Channel.Start, self.Event.ChannelStart, "KBMChannelStart_Handler")
	Command.Event.Attach(Event.SafesCastbarLib.Interrupt, self.Event.Interrupt, "KBMInterrupt_Handler")
end

function KBM.Castbar.Event.CastStart(handle, UnitID, bDetails)
	if KBM.CurrentMod then
		local self = KBM.Castbar.ActiveCastbars[UnitID]
		if self then
			if KBM.Trigger.Cast[KBM.CurrentMod.ID] then
				if KBM.Trigger.Cast[KBM.CurrentMod.ID][self.Boss.Name] then
					local TriggerObj = KBM.Trigger.Cast[KBM.CurrentMod.ID][self.Boss.Name][bDetails.abilityName]
					if TriggerObj then
						local TargetID = ""
						if self.Boss.UnitID then
							TargetID = Inspect.Unit.Lookup(self.Boss.UnitID..".target")
						end
						KBM.Trigger.Queue:Add(TriggerObj, self.Boss.UnitID, TargetID, bDetails.remaining)
					end
				end
			end
			if KBM.Trigger.PersonalCast[KBM.CurrentMod.ID] then
				if KBM.Trigger.PersonalCast[KBM.CurrentMod.ID][self.Boss.Name] then
					local TriggerObj = KBM.Trigger.PersonalCast[KBM.CurrentMod.ID][self.Boss.Name][bDetails.abilityName]
					if TriggerObj then
						if self.UnitID then
							local playerTarget = Inspect.Unit.Lookup("player.target")
							local playerFocus = Inspect.Unit.Lookup("focus")
							if self.UnitID == playerTarget or self.UnitID == playerFocus then
								KBM.Trigger.Queue:Add(TriggerObj, self.UnitID, self.UnitID, bDetails.remaining)
							end
						end
					end
				end
			end
			-- if KBM.Trigger.CastID[KBM.CurrentMod.ID] then
				-- if bDetails.ability then
					-- if KBM.Trigger.CastID[KBM.CurrentMod.ID][bDetails.ability] then
						-- local TriggerObj = KBM.Trigger.CastID[KBM.CurrentMod.ID][bDetails.ability][self.Boss.Name]
						-- if TriggerObj then
							-- local TargetID = ""
							-- if self.Boss.UnitID then
								-- TargetID = Inspect.Unit.Lookup(self.Boss.UnitID..".target")
							-- end
							-- KBM.Trigger.Queue:Add(TriggerObj, self.Boss.UnitID or "", TargetID, bDetails.remaining)
						-- end
					-- end
				-- end
			-- end
			-- if KBM.Trigger.PersonalCastID[KBM.CurrentMod.ID] then
				-- if bDetails.ability then
					-- if KBM.Trigger.PersonalCastID[KBM.CurrentMod.ID][bDetails.ability] then
						-- if KBM.TriggerPersonalCastID[KBM.CurrentMod.ID][bDetails.ability][self.Boss.Name] then
							-- local TriggerObj = KBM.Trigger.PersonalCastID[KBM.CurrentMod.ID][bDetails.ability][self.Boss.Name]
							-- if self.UnitID then
								-- local playerTarget = Inspect.Unit.Lookup("player.target")
								-- local playerFocus = Inspect.Unit.Lookup("focus")
								-- if self.UnitID == playerTarget or self.UnitID == playerFocus then
									-- KBM.Trigger.Queue:Add(TriggerObj, self.UnitID, self.UnitID, bDetails.remaining)
								-- end
							-- end
						-- end
					-- end
				-- end
			-- end
		end
	end
end

function KBM.Castbar.Event.ChannelStart(handle, UnitID, bDetails)
	if KBM.CurrentMod then
		local self = KBM.Castbar.ActiveCastbars[UnitID]
		if self then
			if KBM.Trigger.PersonalChannel[KBM.CurrentMod.ID] then
				if KBM.Trigger.PersonalChannel[KBM.CurrentMod.ID][self.Boss.Name] then
					local TriggerObj = KBM.Trigger.PersonalChannel[KBM.CurrentMod.ID][self.Boss.Name][bDetails.abilityName]
					if TriggerObj then
						if self.UnitID then
							local playerTarget = Inspect.Unit.Lookup("player.target")
							local playerFocus = Inspect.Unit.Lookup("focus")
							if self.UnitID == playerTarget or self.UnitID == playerFocus then
								KBM.Trigger.Queue:Add(TriggerObj, self.UnitID, self.UnitID, bDetails.remaining)
							end
						end
					end
				end
			end
			if KBM.Trigger.Channel[KBM.CurrentMod.ID] then
				if KBM.Trigger.Channel[KBM.CurrentMod.ID][self.Boss.Name] then
					local TriggerObj = KBM.Trigger.Channel[KBM.CurrentMod.ID][self.Boss.Name][bDetails.abilityName]
					if TriggerObj then
						local TargetID = ""
						if self.Boss.UnitID then
							TargetID = Inspect.Unit.Lookup(self.Boss.UnitID..".target")
						end
						KBM.Trigger.Queue:Add(TriggerObj, self.Boss.UnitID, TargetID, bDetails.remaining)
					end
				end
			end		
			-- if KBM.Trigger.ChannelID[KBM.CurrentMod.ID] then
				-- if bDetails.ability then
					-- if KBM.Trigger.ChannelID[KBM.CurrentMod.ID][bDetails.ability] then
						-- if KBM.Trigger.ChannelID[KBM.CurrentMod.ID][bDetails.ability][self.Boss.Name] then
							-- local TriggerObj = KBM.Trigger.ChannelID[KBM.CurrentMod.ID][bDetails.ability][self.Boss.Name]
							-- local TargetID = ""
							-- if self.Boss.UnitID then
								-- TargetID = Inspect.Unit.Lookup(self.Boss.UnitID..".target")
							-- end
							-- KBM.Trigger.Queue:Add(TriggerObj, self.Boss.UnitID, TargetID, bDetails.remaining)
						-- end
					-- end
				-- end
			-- end
			-- if KBM.Trigger.PersonalChannelID[KBM.CurrentMod.ID] then
				-- if bDetails.ability then
					-- if KBM.Trigger.PersonalChannelID[KBM.CurrentMod.ID][bDetails.ability] then
						-- local TriggerObj = KBM.Trigger.PersonalChannelID[KBM.CurrentMod.ID][bDetails.ability][self.Boss.Name]
						-- if TriggerObj then
							-- if self.UnitID then
								-- local playerTarget = Inspect.Unit.Lookup("player.target")
								-- local playerFocus = Inspect.Unit.Lookup("focus")
								-- if self.UnitID == playerTarget or self.UnitID == playerFocus then
									-- KBM.Trigger.Queue:Add(TriggerObj, self.UnitID, self.UnitID, bDetails.remaining)
								-- end
							-- end	
						-- end	
					-- end
				-- end
			-- end
		end
	end
end

function KBM.Castbar.Event.Interrupt(handle, UnitID, bDetails)
	if KBM.CurrentMod then
		local self = KBM.Castbar.ActiveCastbars[UnitID]
		if self then
			if KBM.Trigger.Interrupt[KBM.CurrentMod.ID] then
				if KBM.Trigger.Interrupt[KBM.CurrentMod.ID][self.Boss.Name] then
					local TriggerObj = KBM.Trigger.Interrupt[KBM.CurrentMod.ID][self.Boss.Name][bDetails.abilityName]
					if TriggerObj then
						KBM.Trigger.Queue:Add(TriggerObj, self.Boss.UnitID, "interruptTarget", bDetails.remaining)
					end
				end
			end
			if KBM.Trigger.PersonalInterrupt[KBM.CurrentMod.ID] then
				if KBM.Trigger.PersonalInterrupt[KBM.CurrentMod.ID][self.Boss.Name] then
					local TriggerObj = KBM.Trigger.PersonalInterrupt[KBM.CurrentMod.ID][self.Boss.Name][bDetails.abilityName]
					if TriggerObj then
						if self.UnitID then
							local playerTarget = Inspect.Unit.Lookup("player.target")
							local playerFocus = Inspect.Unit.Lookup("focus")
							if self.UnitID == playerTarget or self.UnitID == playerFocus then
								KBM.Trigger.Queue:Add(TriggerObj, self.UnitID, "interruptTarget", bDetails.remaining)
							end
						end
					end
				end
			end	
			-- if KBM.Trigger.InterruptID[KBM.CurrentMod.ID] then
				-- if self.CastObject.ability then
					-- if KBM.Trigger.InterruptID[KBM.CurrentMod.ID][self.CastObject.ability] then
						-- local TriggerObj = KBM.Trigger.InterruptID[KBM.CurrentMod.ID][self.CastObject.ability][self.Boss.Name]
						-- if TriggerObj then
							-- KBM.Trigger.Queue:Add(TriggerObj, self.Boss.UnitID, "interruptTarget", self.CastObject.remaining)
						-- end
					-- end
				-- end
			-- end
		end
	end
end

function KBM.Castbar.Event.CastEnd(handle, UnitID, bDetails)
	if KBM.CurrentMod then
		local self = KBM.Castbar.ActiveBars[UnitID]
		if self then
		
		end
	end
end

function KBM.Castbar:Add(Mod, Boss, Enabled, Dynamic)
	local CastbarObj = {}
	CastbarObj.UnitID = nil
	CastbarObj.Boss = Boss
	CastbarObj.Dynamic = Dynamic
	CastbarObj.Name = Boss.Name
	CastbarObj.ID = Boss.ID or Boss.Name
	CastbarObj.Mod = Mod
	
	if not Dynamic then
		if not Boss.Settings then
			Boss.Settings = {
				CastBar = KBM.Defaults.Castbar()
			}
		end
		
		if not Boss.Settings.CastBar then
			Boss.Settings.CastBar = KBM.Defaults.Castbar()
		end
		
		if Boss.Settings.CastBar.override then
			if Boss.Settings.CastBar.custom then
				CastbarObj.Settings = Boss.Settings.CastBar
			else
				CastbarObj.Settings = KBM.Options.Castbar.Global
			end
		else
			CastbarObj.Settings = KBM.Options.Castbar.Global
		end
		
		CastbarObj.BossSettings = Boss.Settings.CastBar
		CastbarObj.CastObj = LibSCast:Create(Mod.ID.."_"..CastbarObj.ID, KBM.Context, KBM.Options.Castbar.Global.pack, CastbarObj.Settings, "raid")
		CastbarObj.CastObj.Name = CastbarObj.Name
		if CastbarObj.BossSettings.override then
			CastbarObj.CastObj.Enabled = CastbarObj.BossSettings.enabled
			if not CastbarObj.BossSettings.custom then
				self.Anchor:AddBar(CastbarObj.CastObj)
			end
		else
			CastbarObj.CastObj.Enabled = KBM.Options.Castbar.Global.enabled
			self.Anchor:AddBar(CastbarObj.CastObj)
		end
		Mod.HasCastbars = true
	else
		CastbarObj.CastObj = LibSCast:Create(Mod.ID.."_"..CastbarObj.ID, KBM.Context, nil, nil, nil)		
	end
					
	function CastbarObj:Display()
		if not self.Dynamic then
			if KBM.Menu.Active then
				if self.CastObj.Pack.id ~= KBM.Options.Castbar.Global.pack then
					self.CastObj:SetPack(KBM.Options.Castbar.Global.pack)
				end
				if self.BossSettings.override then
					if self.BossSettings.custom then
						if self.BossSettings.visible and self.BossSettings.enabled then
							self.CastObj:SetVisible(true)
							if self.BossSettings.unlocked then
								self.CastObj:Unlocked(true)
							else
								self.CastObj:Unlocked(false)
							end
						else
							self.CastObj:SetVisible(false)
							self.CastObj:Unlocked(false)
						end
					else
						if KBM.Options.Castbar.Global.visible and self.BossSettings.enabled then
							self.CastObj:SetVisible(true)
						else
							self.CastObj:SetVisible(false)
						end
						self.CastObj:Unlocked(false)
					end
				else
					if KBM.Options.Castbar.Global.visible and KBM.Options.Castbar.Global.enabled then
						self.CastObj:SetVisible(true)
					else
						self.CastObj:SetVisible(false)
					end
					self.CastObj:Unlocked(false)
				end
			end
		end
	end
	
	function CastbarObj:Create(UnitID)	
		self.UnitID = UnitID
		if self.Dynamic then
			self.CastObj:Start(UnitID, true)
		else
			if self.BossSettings.override then
				self.CastObj:Start(UnitID, self.BossSettings.enabled)
			else
				self.CastObj:Start(UnitID, KBM.Options.Castbar.Global.enabled)
			end
		end
		
		KBM.Castbar.ActiveCastbars[UnitID] = self
		self.Active = true		
	end
		
	function CastbarObj:Stop()
	end
	
	function CastbarObj:Hide(Force)
		if not self.Dynamic then
			self.CastObj:SetVisible(false)
		end
	end
	
	function CastbarObj:Remove()
		if self.UnitID then
			KBM.Castbar.ActiveCastbars[self.UnitID] = nil
		end
		self.UnitID = nil
		self.Active = false
		self.CastObj:Remove()
	end
		
	return CastbarObj
end