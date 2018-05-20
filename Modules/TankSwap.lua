local AddonIni, KBM = ...

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

function KBM.TankSwap:Pull()
	local GUI = {}
	if #self.TankStore > 0 then
		GUI = table.remove(self.TankStore)
		GUI.TankAggro.Texture:SetVisible(false)
		for i = 1, 4 do
			GUI.DebuffFrame[i].Texture:SetVisible(false)
			KBM.LoadTexture(GUI.DebuffFrame[i].Texture, "Rift", self.DefaultTexture)
			GUI.DeCoolFrame[i]:SetVisible(false)
		end
	else
		GUI.Frame = UI.CreateFrame("Frame", "TankSwap_Frame", KBM.Context)
		GUI.Frame:SetLayer(1)
		GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		GUI.TankAggro = UI.CreateFrame("Frame", "TankSwap_Aggro_Frame", GUI.Frame)
		GUI.TankAggro:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
		GUI.TankAggro:SetBackgroundColor(0,0,0,0)
		GUI.TankAggro.Texture = UI.CreateFrame("Texture", "TankSwap_Aggro_Texture", GUI.TankAggro)
		GUI.TankAggro.Texture:SetPoint("TOPLEFT", GUI.TankAggro, "TOPLEFT", 1, 1)
		GUI.TankAggro.Texture:SetPoint("BOTTOMRIGHT", GUI.TankAggro, "BOTTOMRIGHT", -1, -1)
		KBM.LoadTexture(GUI.TankAggro.Texture, "Rift", self.AggroTexture)
		GUI.TankAggro.Texture:SetAlpha(0.66)
		GUI.TankAggro.Texture:SetVisible(false)
		GUI.Dead = UI.CreateFrame("Texture", "TankSwap_Dead", GUI.TankAggro)
		KBM.LoadTexture(GUI.Dead, "KingMolinator", "Media/KBM_Death.png")
		GUI.Dead:SetLayer(1)
		GUI.Dead:SetPoint("TOPLEFT", GUI.TankAggro, "TOPLEFT", 1, 1)
		GUI.Dead:SetPoint("BOTTOMRIGHT", GUI.TankAggro, "BOTTOMRIGHT", -1, -1)
		GUI.Dead:SetAlpha(0.8)
		GUI.TankFrame = UI.CreateFrame("Frame", "TankSwap_Tank_Frame", GUI.Frame)
		GUI.TankFrame:SetPoint("TOPLEFT", GUI.TankAggro, "TOPRIGHT")
		GUI.TankFrame:SetPoint("BOTTOM", GUI.TankAggro, "BOTTOM")
		GUI.TankFrame:SetPoint("RIGHT", GUI.Frame, "RIGHT")
		GUI.TankHP = UI.CreateFrame("Texture", "TankSwap_Tank_HPFrame", GUI.TankFrame)
		KBM.LoadTexture(GUI.TankHP, "KingMolinator", "Media/BarTexture.png")
		GUI.TankHP:SetLayer(1)
		GUI.TankHP:SetBackgroundColor(0,0.8,0,0.33)
		GUI.TankHP:SetPoint("TOP", GUI.TankFrame, "TOP")
		GUI.TankHP:SetPoint("LEFT", GUI.TankFrame, "LEFT")
		GUI.TankHP:SetPoint("BOTTOM", GUI.TankFrame, "BOTTOM")
		GUI.TankShadow = UI.CreateFrame("Text", "TankSwap_Tank_Shadow", GUI.TankFrame)
		GUI.TankShadow:SetLayer(2)
		GUI.TankShadow:SetFontColor(0,0,0)
		GUI.TankText = UI.CreateFrame("Text", "TankSwap_Tank_Text", GUI.TankFrame)
		GUI.TankText:SetLayer(3)
		GUI.TankShadow:SetPoint("TOPLEFT", GUI.TankText, "TOPLEFT", 1, 1)
		GUI.TankText:SetPoint("CENTERLEFT", GUI.TankFrame, "CENTERLEFT", 2, 0)
		GUI.DebuffFrame = {}
		GUI.DeCoolFrame = {}
		GUI.DeCool = {}
		for i = 1, 4 do
			GUI.DebuffFrame[i] = UI.CreateFrame("Frame", "TankSwap_Debuff_Frame_"..i, GUI.Frame)
			GUI.DebuffFrame[i]:SetPoint("LEFT", GUI.Frame, "LEFT")
			if i > 2 then
				GUI.DebuffFrame[i]:SetPoint("TOP", GUI.DebuffFrame[1], "BOTTOM")
			else
				GUI.DebuffFrame[i]:SetPoint("TOP", GUI.TankHP, "BOTTOM")
			end
			GUI.DebuffFrame[i]:SetWidth(math.floor(GUI.Frame:GetHeight() * 0.5))
			GUI.DebuffFrame[i]:SetHeight(GUI.DebuffFrame[i]:GetWidth())
			GUI.DebuffFrame[i]:SetBackgroundColor(0,0,0,0)
			GUI.DebuffFrame[i]:SetLayer(1)
			GUI.DebuffFrame[i].Texture = UI.CreateFrame("Texture", "TankSwap_Debuff_Texture_"..i, GUI.DebuffFrame[i])
			GUI.DebuffFrame[i].Texture:SetPoint("TOPLEFT", GUI.DebuffFrame[i], "TOPLEFT")
			GUI.DebuffFrame[i].Texture:SetPoint("BOTTOMRIGHT", GUI.DebuffFrame[i], "BOTTOMRIGHT")
			GUI.DebuffFrame[i].Texture:SetAlpha(0.33)
			KBM.LoadTexture(GUI.DebuffFrame[i].Texture, "Rift", self.DefaultTexture)
			GUI.DebuffFrame[i].Texture:SetVisible(false)
			GUI.DebuffFrame[i].Shadow = UI.CreateFrame("Text", "TankSwap_Debuff_Shadow_"..i, GUI.DebuffFrame[i])
			GUI.DebuffFrame[i].Shadow:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			if (KBM.Options.Font.Custom > 1) then GUI.DebuffFrame[i].Shadow:SetFont(AddonIni.identifier, KBM.Constant.Font[KBM.Options.Font.Custom][2]) end
			GUI.DebuffFrame[i].Shadow:SetFontColor(0,0,0)
			GUI.DebuffFrame[i].Shadow:SetLayer(2)
			GUI.DebuffFrame[i].Text = UI.CreateFrame("Text", "TankSwap_Debuff_Text_"..i, GUI.DebuffFrame[i])
			GUI.DebuffFrame[i].Text:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DebuffFrame[i].Text:SetLayer(3)
			if (KBM.Options.Font.Custom > 1) then GUI.DebuffFrame[i].Text:SetFont(AddonIni.identifier, KBM.Constant.Font[KBM.Options.Font.Custom][2]) end
			GUI.DebuffFrame[i].Shadow:SetPoint("TOPLEFT", GUI.DebuffFrame[i].Text, "TOPLEFT", 1, 1)
			GUI.DebuffFrame[i].Text:SetPoint("CENTER", GUI.DebuffFrame[i], "CENTER")
			GUI.DeCoolFrame[i] = UI.CreateFrame("Texture", "TankSwap_CDFrame", GUI.Frame)
			GUI.DeCoolFrame[i]:SetPoint("TOPLEFT", GUI.DebuffFrame[i], "TOPRIGHT")
			GUI.DeCoolFrame[i]:SetPoint("BOTTOM", GUI.DebuffFrame[i], "BOTTOM")
			GUI.DeCoolFrame[i]:SetPoint("RIGHT", GUI.Frame, "RIGHT")
			GUI.DeCoolFrame[i]:SetBackgroundColor(0,0,0,0.33)
			GUI.DeCool[i] = UI.CreateFrame("Texture", "TankSwap_CD_Progress_"..i, GUI.DeCoolFrame[i])
			KBM.LoadTexture(GUI.DeCool[i], "KingMolinator", "Media/BarTexture.png")
			GUI.DeCool[i]:SetPoint("TOPLEFT", GUI.DeCoolFrame[i], "TOPLEFT")
			GUI.DeCool[i]:SetPoint("BOTTOM", GUI.DeCoolFrame[i], "BOTTOM")
			GUI.DeCool[i]:SetWidth(0)
			GUI.DeCool[i]:SetBackgroundColor(0.5,0,8,0.33)
			GUI.DeCool[i].Shadow = UI.CreateFrame("Text", "TankSwap_CD_Shadow_"..i, GUI.DeCoolFrame[i])
			GUI.DeCool[i].Shadow:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DeCool[i].Shadow:SetFontColor(0,0,0)
			GUI.DeCool[i].Shadow:SetLayer(2)
			GUI.DeCool[i].Text = UI.CreateFrame("Text", "TankSwap_CD_Text_"..i, GUI.DeCoolFrame[i])
			GUI.DeCool[i].Text:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			if (KBM.Options.Font.Custom > 1) then GUI.DeCool[i].Text:SetFont(AddonIni.identifier, KBM.Constant.Font[KBM.Options.Font.Custom][2]) end
			if (KBM.Options.Font.Custom > 1) then GUI.DeCool[i].Shadow:SetFont(AddonIni.identifier, KBM.Constant.Font[KBM.Options.Font.Custom][2]) end
			GUI.DeCool[i].Shadow:SetPoint("TOPLEFT", GUI.DeCool[i].Text, "TOPLEFT", 1, 1)
			GUI.DeCool[i].Text:SetPoint("CENTER", GUI.DeCoolFrame[i], "CENTER")
			GUI.DeCool[i].Text:SetLayer(3)
		end
		function GUI:SetTank(Text)
			if (KBM.Options.Font.Custom > 1) then self.TankShadow:SetFont(AddonIni.identifier, KBM.Constant.Font[KBM.Options.Font.Custom][2]) end
			self.TankShadow:SetText(Text)
			if (KBM.Options.Font.Custom > 1) then self.TankText:SetFont(AddonIni.identifier, KBM.Constant.Font[KBM.Options.Font.Custom][2]) end
			self.TankText:SetText(Text)
		end
		function GUI:SetDeCool(Text, iBuff)
			self.DeCool[iBuff].Shadow:SetText(Text)
			self.DeCool[iBuff].Text:SetText(Text)
		end
		function GUI:SetStack(Text, iBuff)
			self.DebuffFrame[iBuff].Shadow:SetText(Text)
			self.DebuffFrame[iBuff].Text:SetText(Text)
		end
		function GUI:SetDeath(bool)
			if bool then
				self.TankText:SetAlpha(0.5)
				for i = 1, 4 do
					self.DebuffFrame[i].Shadow:SetVisible(false)
					self.DebuffFrame[i].Text:SetVisible(false)
					self.DebuffFrame[i].Texture:SetVisible(false)
					self.DeCoolFrame[i]:SetVisible(false)
				end
				self.Dead:SetVisible(true)
				self.TankAggro.Texture:SetVisible(false)
				self.TankHP:SetVisible(false)
			else
				self.TankText:SetAlpha(1)
				self.Dead:SetVisible(false)
				self.TankHP:SetVisible(true)
				for i = 1, 4 do
					self.DebuffFrame[i].Shadow:SetVisible(true)
					self.DebuffFrame[i].Text:SetVisible(true)
					self.DeCoolFrame[i]:SetVisible(false)
				end
			end			
		end
	end
	self:ApplySettings(GUI)
	return GUI
end

function KBM.TankSwap:Init()
	self.Tanks = {}
	self.TankCount = 0
	self.DefaultTexture = "Data/\\UI\\ability_icons\\generic_ability_001.dds"
	self.AggroTexture = "Data/\\UI\\ability_icons\\weaponsmith1a.dds"
	self.Active = false
	self.DebuffID = {}
	self.Debuffs = 0
	self.DebuffName = {}
	self.DebuffList = {}
	self.Boss = {}
	self.LastTank = nil
	self.Test = false
	self.TankStore = {}
	self.Settings = KBM.Options.TankSwap
	self.Enabled = self.Settings.Enabled
	self.Anchor = UI.CreateFrame("Frame", "Tank-Swap_Anchor", KBM.Context)
	self.Anchor:SetWidth(KBM.Constant.TankSwap.w * self.Settings.wScale)
	self.Anchor:SetHeight(KBM.Constant.TankSwap.h * self.Settings.hScale)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Anchor:SetLayer(5)
	
	if self.Settings.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
	else
		self.Anchor:SetPoint("CENTER", UIParent, "CENTER")
	end
	
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.TankSwap.Settings.x = self:GetLeft()
			KBM.TankSwap.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Text = UI.CreateFrame("Text", "TankSwap info", self.Anchor)
	self.Anchor.Text:SetText(KBM.Language.Anchors.TankSwap[KBM.Lang])
	if (KBM.Options.Font.Custom > 1) then self.Anchor.Text:SetFont(AddonIni.identifier, KBM.Constant.Font[KBM.Options.Font.Custom][2]) end
	self.Anchor.Text:SetFontSize(KBM.Constant.TankSwap.TextSize * self.Settings.tScale)
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "TS Anchor Drag", 2)
	
	function self.Anchor.Drag:WheelForwardHandler()
		if KBM.TankSwap.Settings.ScaleWidth then
			if KBM.TankSwap.Settings.wScale < 1.5 then
				KBM.TankSwap.Settings.wScale = KBM.TankSwap.Settings.wScale + 0.025
				if KBM.TankSwap.Settings.wScale > 1.5 then
					KBM.TankSwap.Settings.wScale = 1.5
				end
				KBM.TankSwap.Anchor:SetWidth(math.floor(KBM.TankSwap.Settings.wScale * KBM.Constant.TankSwap.w))
				if KBM.TankSwap.Settings.hScale >= KBM.TankSwap.Settings.wScale then
					KBM.TankSwap.Settings.tScale = KBM.TankSwap.Settings.wScale
				end
				KBM.TankSwap.Anchor.Text:SetFontSize(math.floor(KBM.Constant.TankSwap.TextSize * KBM.TankSwap.Settings.tScale))
			end
		end
		
		if KBM.TankSwap.Settings.ScaleHeight then
			if KBM.TankSwap.Settings.hScale < 1.5 then
				KBM.TankSwap.Settings.hScale = KBM.TankSwap.Settings.hScale + 0.025
				if KBM.TankSwap.Settings.hScale > 1.5 then
					KBM.TankSwap.Settings.hScale = 1.5
				end
				KBM.TankSwap.Anchor:SetHeight(math.floor(KBM.TankSwap.Settings.hScale * KBM.Constant.TankSwap.h))
				if KBM.TankSwap.Settings.wScale >= KBM.TankSwap.Settings.hScale then
					KBM.TankSwap.Settings.tScale = KBM.TankSwap.Settings.hScale
				end
				KBM.TankSwap.Anchor.Text:SetFontSize(math.floor(KBM.Constant.TankSwap.TextSize * KBM.TankSwap.Settings.tScale))
			end
		end
	end

	function self.Anchor.Drag:WheelBackHandler()
		if KBM.TankSwap.Settings.ScaleWidth then
			if KBM.TankSwap.Settings.wScale > 0.5 then
				KBM.TankSwap.Settings.wScale = KBM.TankSwap.Settings.wScale - 0.025
				if KBM.TankSwap.Settings.wScale < 0.5 then
					KBM.TankSwap.Settings.wScale = 0.5
				end
				KBM.TankSwap.Anchor:SetWidth(math.floor(KBM.TankSwap.Settings.wScale * KBM.Constant.TankSwap.w))
				if KBM.TankSwap.Settings.hScale >= KBM.TankSwap.Settings.wScale then
					KBM.TankSwap.Settings.tScale = KBM.TankSwap.Settings.wScale
				end
				KBM.TankSwap.Anchor.Text:SetFontSize(math.floor(KBM.Constant.TankSwap.TextSize * KBM.TankSwap.Settings.tScale))
			end
		end
		
		if KBM.TankSwap.Settings.ScaleHeight then
			if KBM.TankSwap.Settings.hScale > 0.5 then
				KBM.TankSwap.Settings.hScale = KBM.TankSwap.Settings.hScale - 0.025
				if KBM.TankSwap.Settings.hScale < 0.5 then
					KBM.TankSwap.Settings.hScale = 0.5
				end
				KBM.TankSwap.Anchor:SetHeight(math.floor(KBM.TankSwap.Settings.hScale * KBM.Constant.TankSwap.h))
				if KBM.TankSwap.Settings.wScale >= KBM.TankSwap.Settings.hScale then
					KBM.TankSwap.Settings.tScale = KBM.TankSwap.Settings.hScale
				end
				KBM.TankSwap.Anchor.Text:SetFontSize(math.floor(KBM.Constant.TankSwap.TextSize * KBM.TankSwap.Settings.tScale))
			end
		end
	end
		
	self.Anchor.Drag:EventAttach(Event.UI.Input.Mouse.Wheel.Back, self.Anchor.Drag.WheelBackHandler, "wheelback")
	self.Anchor.Drag:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, self.Anchor.Drag.WheelForwardHandler, "wheelforward")
	
	if KBM.Menu.Active then
		self.Anchor:SetVisible(self.Settings.Visible)
		self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end
	
	function self:ApplySettings(GUI)
		GUI.Frame:SetHeight(math.ceil(KBM.Constant.TankSwap.h * KBM.Options.TankSwap.hScale))
		GUI.TankAggro:SetHeight(math.floor(GUI.Frame:GetHeight() * 0.5))
		GUI.TankAggro:SetWidth(GUI.TankAggro:GetHeight())
		GUI.TankHP:SetWidth(GUI.TankFrame:GetWidth())		
		GUI.TankShadow:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
		GUI.TankText:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
		for i = 1, 4 do
			GUI.DebuffFrame[i]:SetWidth(math.floor(GUI.Frame:GetHeight() * 0.5))
			GUI.DebuffFrame[i]:SetHeight(GUI.DebuffFrame[i]:GetWidth())
			GUI.DebuffFrame[i].Shadow:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DebuffFrame[i].Shadow:SetFontColor(0,0,0)
			GUI.DebuffFrame[i].Text:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DeCool[i].Shadow:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DeCool[i].Text:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
		end
	end
			
	function self:Add(UnitID, Test)
		if self.Test and not Test then
			self:Remove()
			self.Anchor:SetVisible(false)
		end
		if Test then
			self.Debuffs = 4
		end
		local TankObj = {}
		TankObj.UnitID = UnitID
		TankObj.DebuffList = {}
		TankObj.DebuffName = {}
		TankObj.Test = Test
		TankObj.TargetCount = 0
		for i = 1, self.Debuffs do
			TankObj.DebuffList[i] = {
				ID = nil,
				Stacks = 0,
				Remaining = 0,
			}
			if not Test then
				TankObj.DebuffName[self.DebuffList[i].Name] = TankObj.DebuffList[i]
			end
		end
		self.Active = true
		TankObj.Dead = false
		
		if Test then
			TankObj.Name = Test
			TankObj.UnitID = Test
			self.Test = true
			TankObj.Dead = false
		else
			TankObj.Unit = LibSUnit.Lookup.UID[UnitID]
			if TankObj.Unit then
				TankObj.Name = TankObj.Unit.Name or "<Unknown>"
				if TankObj.Unit.Dead and TankObj.Unit.Health then
					if TankObj.Unit.Health > 0 then
						TankObj.Dead = false
					else
						TankObj.Dead = true
					end
				else
					TankObj.Dead = true
				end
			end
		end
		
		TankObj.GUI = KBM.TankSwap:Pull()
		TankObj.GUI:SetTank(TankObj.Name)
		
		if self.TankCount == 0 then
			TankObj.GUI.Frame:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
			TankObj.GUI.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
		else
			TankObj.GUI.Frame:SetPoint("TOPLEFT", self.LastTank.GUI.Frame, "BOTTOMLEFT", 0, 2)
			TankObj.GUI.Frame:SetPoint("RIGHT", self.LastTank.GUI.Frame, "RIGHT")
		end
		
		self.LastTank = TankObj
		self.Tanks[TankObj.UnitID] = TankObj
		self.TankCount = self.TankCount + 1
		
		function TankObj:BuffUpdate(DebuffID, DebuffName)
			self.DebuffName[DebuffName].ID = DebuffID
		end
		
		function TankObj:Death()
			self.Dead = true
			self.GUI:SetDeath(true)
		end
		
		function TankObj:UpdateHP()
			if self.Unit.Health then
				if self.Unit.Health > 0 then
					if self.Dead then
						self.GUI:SetDeath(false)
						self.Dead = false
					end
					self.GUI.TankHP:SetWidth(math.ceil(self.GUI.TankFrame:GetWidth() * self.Unit.PercentRaw))
				elseif not self.Dead then
					self:Death()
				end
			elseif not self.Dead then
				self:Death()
			end
		end
		
		TankObj.GUI:SetDeath(TankObj.Dead)
		if self.Debuffs > 2 then
			TankObj.GUI.Frame:SetHeight(TankObj.GUI.DeCoolFrame[1]:GetHeight() * 3)
		else
			TankObj.GUI.Frame:SetHeight(TankObj.GUI.DeCoolFrame[1]:GetHeight() * 2)
		end
		if self.Test then
			for i = 1, 4 do
				local Visible = true
				if i > self.Debuffs then
					Visible = false
				end
				TankObj.GUI:SetStack("2", i)
				TankObj.GUI:SetDeCool("99.9", i)
				TankObj.GUI.DeCoolFrame[i]:SetVisible(Visible)
				TankObj.GUI.DeCool[i]:SetWidth(TankObj.GUI.DeCoolFrame[i]:GetWidth())
				TankObj.GUI.DebuffFrame[i].Texture:SetVisible(Visible)
			end
			TankObj.GUI.TankHP:SetWidth(TankObj.GUI.TankFrame:GetWidth())
			if self.Debuffs > 1 then
				TankObj.GUI.DeCoolFrame[1]:SetPoint("RIGHT", TankObj.GUI.Frame, "CENTERX")
				TankObj.GUI.DebuffFrame[2]:SetPoint("LEFT", TankObj.GUI.Frame, "CENTERX")
				TankObj.GUI.DeCool[1]:SetWidth(TankObj.GUI.DeCoolFrame[1]:GetWidth())
				TankObj.GUI.DeCool[2]:SetWidth(TankObj.GUI.DeCoolFrame[2]:GetWidth())
				if self.Debuffs > 3 then
					TankObj.GUI.DeCoolFrame[3]:SetPoint("RIGHT", TankObj.GUI.Frame, "CENTERX")
					TankObj.GUI.DebuffFrame[4]:SetPoint("LEFT", TankObj.GUI.Frame, "CENTERX")
					TankObj.GUI.DeCool[3]:SetWidth(TankObj.GUI.DeCoolFrame[3]:GetWidth())
					TankObj.GUI.DeCool[4]:SetWidth(TankObj.GUI.DeCoolFrame[4]:GetWidth())
				else
					TankObj.GUI.DeCoolFrame[3]:SetPoint("RIGHT", TankObj.GUI.Frame, "RIGHT")
				end
			else
				TankObj.GUI.DeCoolFrame[1]:SetPoint("RIGHT", TankObj.GUI.Frame, "RIGHT")
			end
		else
			for i = 1, 4 do
				TankObj.GUI:SetStack("", i)
				TankObj.GUI:SetDeCool("", i)
				TankObj.GUI.DeCoolFrame[i]:SetVisible(false)
				TankObj.GUI.DeCool[i]:SetWidth(TankObj.GUI.DeCoolFrame[i]:GetWidth())
				TankObj.GUI.DebuffFrame[i].Texture:SetVisible(false)				
			end
			if self.Debuffs > 1 then
				TankObj.GUI.DeCoolFrame[1]:SetPoint("RIGHT", TankObj.GUI.Frame, "CENTERX")
				TankObj.GUI.DebuffFrame[2]:SetPoint("LEFT", TankObj.GUI.Frame, "CENTERX")
				if self.Debuffs > 3 then
					TankObj.GUI.DeCoolFrame[3]:SetPoint("RIGHT", TankObj.GUI.Frame, "CENTERX")
					TankObj.GUI.DebuffFrame[4]:SetPoint("LEFT", TankObj.GUI.Frame, "CENTERX")
				else
					TankObj.GUI.DeCoolFrame[3]:SetPoint("RIGHT", TankObj.GUI.Frame, "RIGHT")
				end
			else
				TankObj.GUI.DeCoolFrame[1]:SetPoint("RIGHT", TankObj.GUI.Frame, "RIGHT")
			end
		end
		TankObj.GUI.Frame:SetVisible(true)
		return TankObj		
	end
	
	function self:AddBoss(UnitID)
		if self.Active then
			if self.Boss then
				self.Boss[UnitID] = false
			end
		end
	end
	
	function self:Start(DebuffName, BossID, Debuffs)
		if not BossID then 
			return
		end
		if self.Settings.Enabled then
			if (LibSUnit.Player.Role == "tank" and self.Settings.Tank == true) or self.Settings.Tank == false then
				if self.Active then
					self:Remove()
				end
				self.Active = true
				local Spec = ""
				local UnitID = ""
				local uDetails = nil
				self.Boss = {
					[BossID] = false,
				}
				self.CurrentTarget = nil
				self.CurrentIcon = nil
				self.DebuffList = {}
				self.DebuffName = {}
				if type(DebuffName) == "table" then
					for i, DebuffName in ipairs(DebuffName) do
						self:AddDebuff(DebuffName, i)
					end
				else
					self:AddDebuff(DebuffName, 1)
				end
				self.Debuffs = Debuffs or 1
				if LibSUnit.Raid.Grouped then
					local _specList = LibSUnit.Lookup.SpecList
					for i = 1, 20 do
						if LibSUnit.Raid.Lookup[_specList[i]] then
							UnitObj = LibSUnit.Raid.Lookup[_specList[i]].Unit
							if UnitObj then
								if UnitObj.UnitID then
									if UnitObj.Role == "tank" then
										self:Add(UnitObj.UnitID)
									end
								end
							end
						end
					end
					-- for UnitID, UnitObj in pairs(LibSUnit.Raid.UID) do
						-- if UnitID then
							-- if UnitObj.Role == "tank" then
								-- self:Add(UnitID)
							-- end
						-- end
					-- end
				end
			end
			local EventData = {
				DebuffList = self.DebuffName,
				Enabled = KBM.Options.TankSwap.Enabled,
			}
			KBM.Event.System.TankSwap.Start(EventData)
		end
	end
	
	function self:AddDebuff(DebuffName, Index)
		self.DebuffList[Index] = {
			Name = DebuffName,
			Index = Index,
		}
		self.DebuffName[DebuffName] = self.DebuffList[Index]
	end
		
	function self:Update()	
		local uDetails = ""
		for UnitID, TankObj in pairs(self.Tanks) do
			for i = 1, self.Debuffs do
				if TankObj.DebuffList[i].ID then
					local DebuffObj = TankObj.DebuffList[i]
					local bDetails = Inspect.Buff.Detail(UnitID, TankObj.DebuffList[i].ID)
					if bDetails then
						if bDetails.stack then
							DebuffObj.Stacks = bDetails.stack
						else
							DebuffObj.Stacks = 1
						end
						DebuffObj.Remaining = (bDetails.remaining or 0.0)
						DebuffObj.Duration = (bDetails.duration or 1.0)
						if bDetails.icon then
							DebuffObj.Icon = bDetails.icon
						else
							DebuffObj.Icon = self.DefaultTexture
						end
						if DebuffObj.Remaining > 9.94 then
							TankObj.GUI:SetDeCool(KBM.ConvertTime(DebuffObj.Remaining), i)
							TankObj.GUI.DeCool[i]:SetWidth(math.ceil(TankObj.GUI.DeCoolFrame[i]:GetWidth() * (DebuffObj.Remaining/DebuffObj.Duration)))
						elseif DebuffObj.Remaining > 0 then
							TankObj.GUI:SetDeCool(string.format("%0.01f", DebuffObj.Remaining), i)
							TankObj.GUI.DeCool[i]:SetWidth(math.ceil(TankObj.GUI.DeCoolFrame[i]:GetWidth() * (DebuffObj.Remaining/DebuffObj.Duration)))
						else
							TankObj.GUI:SetDeCool("-", i)
							TankObj.GUI.DeCool[i]:SetWidth(0)
						end
						TankObj.GUI:SetStack(tostring(DebuffObj.Stacks), i)
						KBM.LoadTexture(TankObj.GUI.DebuffFrame[i].Texture, "Rift", DebuffObj.Icon)
						TankObj.GUI.DebuffFrame[i].Texture:SetVisible(true)
						TankObj.GUI.DeCoolFrame[i]:SetVisible(true)
					else
						TankObj.GUI.DeCoolFrame[i]:SetVisible(false)
						TankObj.GUI.DeCool[i]:SetWidth(0)
						TankObj.GUI:SetDeCool("", i)
						TankObj.GUI:SetStack("", i)
						TankObj.GUI.DebuffFrame[i].Texture:SetVisible(false)
						TankObj.DebuffList[i].ID = nil
					end
				end
			end
			TankObj:UpdateHP()
			for UnitID, CurrentTarget in pairs(self.Boss) do
				local BossObj = LibSUnit.Lookup.UID[UnitID]
				if BossObj then
					if BossObj.Target then
						if self.Tanks[BossObj.Target] then
							if self.Tanks[BossObj.Target] ~= CurrentTarget then
								if CurrentTarget then
									CurrentTarget.TargetCount = CurrentTarget.TargetCount - 1
									if CurrentTarget.TargetCount == 0 then
										CurrentTarget.GUI.TankAggro.Texture:SetVisible(false)
									end
								end
								self.Boss[UnitID] = self.Tanks[BossObj.Target]
								self.Boss[UnitID].GUI.TankAggro.Texture:SetVisible(true)
								self.Boss[UnitID].TargetCount = self.Boss[UnitID].TargetCount + 1
							end
						end
					end
				end
			end
		end	
	end
	
	function self:Remove()
		for UnitID, TankObj in pairs(self.Tanks) do
			table.insert(self.TankStore, TankObj.GUI)
			TankObj.GUI.Frame:SetVisible(false)
			TankObj.GUI = nil
		end
		self.Active = false
		self.DebuffName = {}
		self.DebuffID = {}
		self.Tanks = {}
		self.LastTank = nil
		self.TankCount = 0
		self.Boss = {}
		if not self.Test then
			KBM.Event.System.TankSwap.End()
		end
		self.Test = false
	end	
end