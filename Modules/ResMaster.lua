-- King Boss Mods Rez Master
-- Written By Paul Snart
-- Copyright 2012
--
local AddonIni = ...
local KBMTable = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMTable.data

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

local LibSataIni = Inspect.Addon.Detail("SafesTableLib")
local LibSata = LibSataIni.data

local RM = {
	Broadcast = {
		LastSent = Inspect.Time.Real()
	},
	Queue = {},
	Rezes = {
		ActiveCount = 0,
		ActiveTimers = LibSata:Create(),
		Tracked = {},
	},
	GUI = {
		Store = {},
	},
}

KBM.ResMaster = RM

function RM.GUI:ApplySettings()
	self.Anchor:ClearAll()
	if self.Settings.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
	else
		self.Anchor:SetPoint("BOTTOMRIGHT", UIParent, 0.9, 0.5)
	end
	self.Anchor:SetWidth(math.ceil(KBM.Constant.ResMaster.w * self.Settings.wScale))
	self.Anchor:SetHeight(math.ceil(KBM.Constant.ResMaster.h * self.Settings.hScale))
	self.Anchor.Text:SetFontSize(math.ceil(KBM.Constant.ResMaster.TextSize * self.Settings.tScale))
	if KBM.Menu.Active then
		self.Anchor:SetVisible(self.Settings.Visible)
		self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end	
end

function RM.GUI:Pull()
	local GUI = {}
	if #self.Store > 0 then
		GUI = table.remove(self.Store)
	else
		GUI.Background = UI.CreateFrame("Frame", "Timer_Frame", KBM.Context)
		GUI.Background:SetPoint("LEFT", RM.GUI.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", RM.GUI.Anchor, "RIGHT")
		GUI.Background:SetHeight(RM.GUI.Anchor:GetHeight())
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.Icon = UI.CreateFrame("Texture", "Timer_Icon", GUI.Background)
		GUI.Icon:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Icon:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.Icon:SetWidth(GUI.Background:GetHeight())
		GUI.TimeBar = UI.CreateFrame("Frame", "Timer_Progress_Frame", GUI.Background)
		--KBM.LoadTexture(GUI.TimeBar, "KingMolinator", "Media/BarTexture2.png")
		GUI.TimeBar:SetWidth(RM.GUI.Anchor:GetWidth() - GUI.Icon:GetWidth())
		GUI.TimeBar:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.TimeBar:SetPoint("TOPLEFT", GUI.Icon, "TOPRIGHT")
		GUI.TimeBar:SetLayer(1)
		GUI.TimeBar:SetBackgroundColor(0,0,1,0.33)
		GUI.TimeBar:SetMouseMasking("limited")
		GUI.CastInfo = UI.CreateFrame("Text", "Timer_Text_Frame", GUI.Background)
		GUI.CastInfo:SetFontSize(math.ceil(KBM.Constant.ResMaster.TextSize * RM.GUI.Settings.tScale))
		GUI.CastInfo:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
		GUI.CastInfo:SetPoint("CENTERLEFT", GUI.Icon, "CENTERRIGHT")
		GUI.CastInfo:SetLayer(3)
		GUI.CastInfo:SetFontColor(1,1,1)
		GUI.CastInfo:SetMouseMasking("limited")
		GUI.Shadow = UI.CreateFrame("Text", "Timer_Text_Shadow", GUI.Background)
		GUI.Shadow:SetFontSize(math.ceil(KBM.Constant.ResMaster.TextSize * RM.GUI.Settings.tScale))
		GUI.Shadow:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
		GUI.Shadow:SetPoint("CENTER", GUI.CastInfo, "CENTER", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetMouseMasking("limited")
		GUI.Texture = UI.CreateFrame("Texture", "Timer_Skin", GUI.Background)
		KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/BarSkin.png")
		GUI.Texture:SetAlpha(KBM.Constant.ResMaster.TextureAlpha)
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(4)
		GUI.Texture:SetMouseMasking("limited")
	end
	return GUI
end

function RM.GUI:Init()
	self.Settings = KBM.Options.ResMaster

	self.Anchor = UI.CreateFrame("Frame", "Rez Timer", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
		
	function self.Anchor:Update(uType)
		if uType == "end" then
			RM.GUI.Settings.x = self:GetLeft()
			RM.GUI.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Text = UI.CreateFrame("Text", "Rez Master Anchor", self.Anchor)
	self.Anchor.Text:SetText(" Ready! "..KBM.Language.ResMaster.AnchorText[KBM.Lang])
	self.Anchor.Text:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
	self.Anchor.Text:SetPoint("CENTERLEFT", self.Anchor, "CENTERLEFT")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor_Drag", 5)
	
	function self.Anchor.Drag.Event:WheelForward()
		local Changed = false
		if RM.GUI.Settings.ScaleWidth then
			if RM.GUI.Settings.wScale < 1.5 then
				RM.GUI.Settings.wScale = RM.GUI.Settings.wScale + 0.025
				if RM.GUI.Settings.wScale > 1.5 then
					RM.GUI.Settings.wScale = 1.5
				end
				RM.GUI.Anchor:SetWidth(math.ceil(RM.GUI.Settings.wScale * KBM.Constant.ResMaster.w))
				Changed = true
			end
		end
		
		if RM.GUI.Settings.ScaleHeight then
			if RM.GUI.Settings.hScale < 1.5 then
				RM.GUI.Settings.hScale = RM.GUI.Settings.hScale + 0.025
				if RM.GUI.Settings.hScale > 1.5 then
					RM.GUI.Settings.hScale = 1.5
				end
				RM.GUI.Anchor:SetHeight(math.ceil(RM.GUI.Settings.hScale * KBM.Constant.ResMaster.h))
				Change = true
			end
		end
		
		if RM.GUI.Settings.ScaleText then
			if RM.GUI.Settings.tScale < 1.5 then
				RM.GUI.Settings.tScale = RM.GUI.Settings.tScale + 0.025
				if RM.GUI.Settings.tScale > 1.5 then
					RM.GUI.Settings.tScale = 1.5
				end
				RM.GUI.Anchor.Text:SetFontSize(math.ceil(RM.GUI.Settings.tScale * KBM.Constant.ResMaster.TextSize))
				Changed = true
			end
		end
		
		if Changed then
			for TimerObj, Timer in LibSata.EachIn(RM.Rezes.ActiveTimers) do
				Timer.GUI.Background:SetHeight(RM.GUI.Anchor:GetHeight())
				Timer.GUI.Icon:SetWidth(RM.GUI.Anchor:GetHeight())
				Timer.GUI.CastInfo:SetFontSize(RM.GUI.Anchor.Text:GetFontSize())
				Timer.GUI.Shadow:SetFontSize(RM.GUI.Anchor.Text:GetFontSize())
				Timer.SetWidth = RM.GUI.Anchor:GetWidth() - RM.GUI.Anchor:GetHeight()
				if Timer.Waiting then
					Timer.GUI.TimeBar:SetWidth(Timer.SetWidth)
				else
					Timer:Update()
				end
			end
		end
	end
	
	function self.Anchor.Drag.Event:WheelBack()		
		if RM.GUI.Settings.ScaleWidth then
			if RM.GUI.Settings.wScale > 0.5 then
				RM.GUI.Settings.wScale = RM.GUI.Settings.wScale - 0.025
				if RM.GUI.Settings.wScale < 0.5 then
					RM.GUI.Settings.wScale = 0.5
				end
				RM.GUI.Anchor:SetWidth(math.ceil(RM.GUI.Settings.wScale * KBM.Constant.ResMaster.w))
				Changed = true
			end
		end
		
		if RM.GUI.Settings.ScaleHeight then
			if RM.GUI.Settings.hScale > 0.5 then
				RM.GUI.Settings.hScale = RM.GUI.Settings.hScale - 0.025
				if RM.GUI.Settings.hScale < 0.5 then
					RM.GUI.Settings.hScale = 0.5
				end
				RM.GUI.Anchor:SetHeight(math.ceil(RM.GUI.Settings.hScale * KBM.Constant.ResMaster.h))
				Changed = true
			end
		end
		
		if RM.GUI.Settings.ScaleText then
			if RM.GUI.Settings.tScale > 0.5 then
				RM.GUI.Settings.tScale = RM.GUI.Settings.tScale - 0.025
				if RM.GUI.Settings.tScale < 0.5 then
					RM.GUI.Settings.tScale = 0.5
				end
				RM.GUI.Anchor.Text:SetFontSize(math.ceil(RM.GUI.Settings.tScale * KBM.Constant.ResMaster.TextSize))
				Changed = true
			end
		end
		if Changed then
			for TimerObj, Timer in LibSata.EachIn(RM.Rezes.ActiveTimers) do
				Timer.GUI.Background:SetHeight(RM.GUI.Anchor:GetHeight())
				Timer.GUI.Icon:SetWidth(RM.GUI.Anchor:GetHeight())
				Timer.GUI.CastInfo:SetFontSize(RM.GUI.Anchor.Text:GetFontSize())
				Timer.GUI.Shadow:SetFontSize(RM.GUI.Anchor.Text:GetFontSize())
				Timer.SetWidth = RM.GUI.Anchor:GetWidth() - RM.GUI.Anchor:GetHeight()
				if Timer.Waiting then
					Timer.GUI.TimeBar:SetWidth(Timer.SetWidth)
				else
					Timer:Update()
				end
			end
		end
	end
	self:ApplySettings()
	
	function self:SetDefault()
		self.Settings.x = nil
		self.Settings.y = nil
		self.Settings.wScale = 1
		self.Settings.hScale = 1
		self.Settings.tScale = 1
		self:ApplySettings()
	end
end

function RM.Rezes:Init()
	function self:Add(UnitObj, aID, aCD, aFull, Name)
    --print (UnitObj, aID, aCD, aFull, Name)
		if LibSUnit.Raid.Grouped then
			if RM.GUI.Settings.Enabled then
				if not UnitObj then
					UnitObj = {
						Name = Name,
						_RMwaiting = true,
					}
				else
					Name = UnitObj.Name
				end
				local aDetails = Inspect.Ability.New.Detail(aID)
        -- Ugly Hack to get around problems with Legendaries.
				if aDetails or aID == "A497B3454505E51B5" then 
					local Anchor = RM.GUI.Anchor
					local Timer = {}
					Timer.UnitObj = UnitObj
					if self.Tracked[UnitObj.Name] then
						if self.Tracked[UnitObj.Name].Timers[aID] then
							self.Tracked[UnitObj.Name].Timers[aID]:Remove()
						end
					else
						self.Tracked[UnitObj.Name] = {
							UnitObj = UnitObj,
							UnitID = UnitObj.UnitID,
							Class = UnitObj.Calling,
							Timers = {},
						}
					end
					self.Tracked[UnitObj.Name].Timers[aID] = Timer
					Timer.aID = aID
					Timer.GUI = RM.GUI:Pull()
					Timer.GUI.Background:SetHeight(Anchor:GetHeight())
					Timer.GUI.CastInfo:SetFontSize(KBM.Constant.ResMaster.TextSize * RM.GUI.Settings.tScale)
					Timer.GUI.Shadow:SetFontSize(Timer.GUI.CastInfo:GetFontSize())
					--KBM.LoadTexture(Timer.GUI.Icon, "Rift", aDetails.icon)
					if(aDetails) then -- Ugly Hack to get around problems with Legendaries.
            Timer.GUI.Icon:SetTexture("Rift", aDetails.icon)
          end
					Timer.SetWidth = Timer.GUI.Background:GetWidth() - Timer.GUI.Background:GetHeight()
					local UID = self.Tracked[UnitObj.Name].UnitID
					Timer.Class = ""
					
					if UnitObj.Calling ~= "" and UnitObj.Calling ~= nil then
						Timer.Class = UnitObj.Calling
					else
						for Calling, AbilityList in pairs(KBM.PlayerControl.RezBank) do
							if AbilityList[aID] then
								Timer.Class = Calling
								break
							end
						end
					end
					
					Timer.Duration = math.floor(tonumber(aFull) or 300)
					Timer.Remaining = (aCD or 0)
					Timer.TimeStart = Inspect.Time.Real() - (Timer.Duration - Timer.Remaining)
					Timer.Player = UnitObj.Name
					Timer.Dead = UnitObj.Dead
          if(aDetails) then -- Ugly Hack to get around problems with Legendaries.
            Timer.Name = aDetails.name
          else
            Timer.Name = "Flash of the Phoenix"
          end
					Timer.UnitObj = self.Tracked[UnitObj.Name].UnitObj
					self.Tracked[UnitObj.Name].Class = Timer.Class
										
					Timer.GUI.Shadow:SetText(Timer.GUI.CastInfo:GetText())
					Timer.GUI.Shadow:SetVisible(true)
					
					if self.ActiveTimers._count > 0 then
						for TableObj, cTimer in LibSata.EachIn(self.ActiveTimers) do
							local Insert = false
							if Timer.Remaining < cTimer.Remaining then
								Insert = true
							elseif Timer.Remaining == cTimer.Remaining and cTimer.Remaining == 0 then
								if Timer.Duration < cTimer.Duration then
									Insert = true
								elseif Timer.Class == "mage" and cTimer.Class ~= "mage" then
									Insert = true
								elseif Timer.Class == "mage" then
									if KBM.AlphaComp(Timer.Player, cTimer.Player) then
										Insert = true
									end
								--elseif Timer.Class == "cleric" and cTimer.Class == "cleric" then
								else
									if KBM.AlphaComp(Timer.Player, cTimer.Player) then
										Insert = true
									end
								end
							end
							if Insert then
								Timer.Active = true
								if TableObj == self.ActiveTimers._first then
									Timer.GUI.Background:ClearPoint("BOTTOMLEFT")
									Timer.GUI.Background:ClearPoint("TOPLEFT")
									Timer.GUI.Background:SetPoint("TOPLEFT", Anchor, "TOPLEFT")
									if RM.GUI.Settings.Cascade then
										cTimer.GUI.Background:SetPoint("TOPLEFT", Timer.GUI.Background, "BOTTOMLEFT", 0, 1)
									else
										cTimer.GUI.Background:ClearPoint("TOPLEFT")
										cTimer.GUI.Background:ClearPoint("BOTTOMLEFT")
										cTimer.GUI.Background:SetPoint("BOTTOMLEFT", Timer.GUI.Background, "TOPLEFT", 0, -1)
									end
								else
									Timer.GUI.Background:ClearPoint("BOTTOMLEFT")
									Timer.GUI.Background:ClearPoint("TOPLEFT")
									if RM.GUI.Settings.Cascade then
										Timer.GUI.Background:SetPoint("TOPLEFT", TableObj._before._data.GUI.Background, "BOTTOMLEFT", 0, 1)
										cTimer.GUI.Background:SetPoint("TOPLEFT", Timer.GUI.Background, "BOTTOMLEFT", 0, 1)
									else
										Timer.GUI.Background:SetPoint("BOTTOMLEFT", TableObj._before._data.GUI.Background, "TOPLEFT", 0, -1)
										cTimer.GUI.Background:SetPoint("BOTTOMLEFT", Timer.GUI.Background, "TOPLEFT", 0, -1)
									end
								end
								Timer.TableObj = self.ActiveTimers:InsertBefore(TableObj, Timer)
								break
							end
						end
						if not Timer.Active then
							Timer.GUI.Background:ClearPoint("BOTTOMLEFT")
							Timer.GUI.Background:ClearPoint("TOPLEFT")
							if RM.GUI.Settings.Cascade then
								Timer.GUI.Background:SetPoint("TOPLEFT", self.ActiveTimers._last._data.GUI.Background, "BOTTOMLEFT", 0, 1)
							else
								Timer.GUI.Background:SetPoint("BOTTOMLEFT", self.ActiveTimers._last._data.GUI.Background, "TOPLEFT", 0, -1)
							end
							Timer.TableObj = self.ActiveTimers:Add(Timer)
							Timer.Active = true
						end
					else
						Timer.GUI.Background:ClearPoint("BOTTOMLEFT")
						Timer.GUI.Background:ClearPoint("TOPLEFT")
						Timer.GUI.Background:SetPoint("TOPLEFT", Anchor, "TOPLEFT")
						Timer.TableObj = self.ActiveTimers:Add(Timer)
						Timer.Active = true
						if RM.GUI.Settings.Visible then
							Anchor.Text:SetVisible(false)
						end
					end
					Timer.GUI.Background:SetVisible(true)
					Timer.Starting = false
					
					function Timer:SetClass(Class)
						self.Class = Class
						if not self.Dead then
							if self.Class == "mage" then
								self.GUI.TimeBar:SetBackgroundColor(0.8, 0.55, 1, 0.33)
							elseif self.Class == "cleric" then
								self.GUI.TimeBar:SetBackgroundColor(0.55, 1, 0.55, 0.33)
							elseif self.Class == "warrior" then
								self.GUI.TimeBar:SetBackgroundColor(1, 0.55, 0.55, 0.33)
							elseif self.Class == "rogue" then
								self.GUI.TimeBar:SetBackgroundColor(1, 1, 0.55, 0.33)
							elseif self.Class == "primalist" then
								self.GUI.TimeBar:SetBackgroundColor(0.23, 0.84, 1, 1)
							end
						end
					end
					
					function Timer:SetDeath(bool)
						self.Dead = bool
						if bool then
							self.GUI.TimeBar:SetBackgroundColor(0.5, 0.5, 0.5, 0.22)
							self.GUI.Icon:SetAlpha(0.33)
						else
							self:SetClass(self.Class)
							self.GUI.Icon:SetAlpha(1)
						end
					end
					
					function Timer:Update(CurrentTime, Force)
						local text = ""
						CurrentTime = CurrentTime or Inspect.Time.Real()
						if self.Active then
							if not self.Waiting then
								self.Remaining = math.ceil(self.Duration - (CurrentTime - self.TimeStart))
								if self.Remaining >= 60 then
									text = " "..KBM.ConvertTime(self.Remaining).." : "..self.Player
								else
									if self.Remaining <= 0 then
										self.Remaining = 0
										RM.Rezes:Add(self.UnitObj, self.aID, 0, self.Duration)
										return
									else
										text = " "..self.Remaining.." : "..self.Player
									end
								end
								if text ~= self.GUI.CastInfo:GetText() then
									self.GUI.CastInfo:SetText(text)
									self.GUI.Shadow:SetText(text)
								end
								self.GUI.TimeBar:SetWidth(self.SetWidth - (self.SetWidth * (self.Remaining/self.Duration)))
							end
						end
					end
					
					function Timer:Remove()
						if self.Player then
							if RM.Rezes.Tracked[self.Player] then
								RM.Rezes.Tracked[self.Player].Timers[self.aID] = nil
							end
						end
						if RM.Rezes.ActiveTimers._count == 1 then
							if RM.GUI.Settings.Visible then
								RM.GUI.Anchor.Text:SetVisible(true)
							end
						elseif self.TableObj == RM.Rezes.ActiveTimers._first then
							self.TableObj._after._data.GUI.Background:ClearPoint("TOPLEFT")
							self.TableObj._after._data.GUI.Background:ClearPoint("BOTTOMLEFT")
							self.TableObj._after._data.GUI.Background:SetPoint("TOPLEFT", RM.GUI.Anchor, "TOPLEFT")
						elseif self.TableObj ~= RM.Rezes.ActiveTimers._last then
							self.TableObj._after._data.GUI.Background:ClearPoint("BOTTOMLEFT")
							self.TableObj._after._data.GUI.Background:ClearPoint("TOPLEFT")
							if RM.GUI.Settings.Cascade then
								self.TableObj._after._data.GUI.Background:SetPoint("TOPLEFT", self.TableObj._before._data.GUI.Background, "BOTTOMLEFT", 0, 1)
							else
								self.TableObj._after._data.GUI.Background:SetPoint("BOTTOMLEFT", self.TableObj._before._data.GUI.Background, "TOPLEFT", 0, -1)
							end
						end
						RM.Rezes.ActiveTimers:Remove(self.TableObj)
						self.GUI.Background:SetVisible(false)
						self.GUI.Shadow:SetText("")
						table.insert(RM.GUI.Store, self.GUI)
						self.TableObj = nil
					end				
					
					if Timer.Remaining == 0 then
						Timer.GUI.CastInfo:SetText(" "..Timer.Player.." "..KBM.Language.ResMaster.Ready[KBM.Lang])
						Timer.GUI.Shadow:SetText(Timer.GUI.CastInfo:GetText())
						Timer.GUI.TimeBar:SetWidth(Timer.SetWidth)
						Timer.Waiting = true
					end
					
					if Timer.UnitObj.Dead then
						Timer:SetDeath(Timer.UnitObj.Dead)
					else
						Timer:SetClass(Timer.Class)
					end
					Timer:Update(Inspect.Time.Real())
				end	
			end
		end
	end

	function self:Clear(sPlayer)
		if not sPlayer then
			for Player, TimerList in pairs(self.Tracked) do
				for aID, Timer in pairs(TimerList.Timers) do
					if Timer.Remove then
						Timer:Remove()
					end
				end
			end
			self.Tracked = {}
		elseif self.Tracked[sPlayer] then
			for aID, Timer in pairs(self.Tracked[sPlayer].Timers) do
				if Timer.Remove then
					Timer:Remove()
				end
			end
			self.Tracked[sPlayer] = nil
		end
	end
	
	function self:Remove(Name, aID)
		if not self.Tracked[Name] then
			return
		end
		local Timer = self.Tracked[Name].Timers[aID]
		if Timer then
			Timer:Remove()
		end
	end
end

function RM.MessageSent(Failed, Message)
end

function RM.RezSetCheck(name, DataSend, failed, message)
	if failed then
		Command.Message.Broadcast("tell", name, "KBMRezSet", DataSend, RM.MessageSent)
	end
end

function RM.Broadcast.RezSet(toName, crID)
	if LibSUnit.Raid.Grouped then
		if toName then
			--print("Rez List send via name Started!")
			for crID, Details in pairs(KBM.Player.Rezes.List) do
				KBM.Player.Rezes.List[crID] = Inspect.Ability.New.Detail(crID)
				Details = KBM.Player.Rezes.List[crID]
				if Details then
					local DataSend = crID..","..tostring(Details.currentCooldownRemaining)..","..tostring(Details.cooldown)
					Command.Message.Send(toName, "KBMRezSet", DataSend, function(failed, message) RM.RezSetCheck(toName, DataSend, failed, message) end)
				end
			end
		elseif not crID then
			--print("Rez List send started")
			for crID, Details in pairs(KBM.Player.Rezes.List) do
				KBM.Player.Rezes.List[crID] = Inspect.Ability.New.Detail(crID)
				Details = KBM.Player.Rezes.List[crID]
				if Details then
					--print("Sending Rez Add Message via: "..tostring(LibSUnit.Raid.Mode))
					Command.Message.Broadcast(LibSUnit.Raid.Mode, nil, "KBMRezSet", crID..","..tostring(Details.currentCooldownRemaining)..","..tostring(Details.cooldown))
				end
			end
		else
			KBM.Player.Rezes.List[crID] = Inspect.Ability.New.Detail(crID)
			local Details = KBM.Player.Rezes.List[crID]
			if Details then
				--print("Sending Rez Add Message via: "..tostring(LibSUnit.Raid.Mode))
				Command.Message.Broadcast(LibSUnit.Raid.Mode, nil, "KBMRezSet", crID..","..tostring(Details.currentCooldownRemaining)..","..tostring(Details.cooldown))
			end
		end
	end
end

function RM.Broadcast.RezRem(crID)
	if LibSUnit.Raid.Grouped then
		Command.Message.Broadcast(LibSUnit.Raid.Mode, nil, "KBMRezRem", crID)
		if RM.Rezes.Tracked[LibSUnit.Player.Name] then
			if RM.Rezes.Tracked[LibSUnit.Player.Name].Timers[crID] then
				RM.Rezes.Tracked[LibSUnit.Player.Name].Timers[crID]:Remove()
				RM.Rezes.Tracked[LibSUnit.Player.Name].Timers[crID] = nil
			end
		end
	end
end

function RM.Broadcast.RezClear()
	if LibSUnit.Raid.Grouped then
		Command.Message.Broadcast(LibSUnit.Raid.Mode, nil, "KBMRezClear", LibSUnit.Player.UnitID)
		RM.Rezes:Clear(LibSUnit.Player.Name)
	end
end

function RM.RezMReq(name, failed, message)
	if failed then
		Command.Message.Broadcast("tell", name, "KBMRezReq", "R", RM.MessageSent)
	end
end

function RM.MessageHandler(handle, From, Type, Channel, Identifier, Data)
	 --print("Data received from: "..tostring(From))
	 --print("Type: "..tostring(Type))
	 --print("Channel: "..tostring(Channel))
	 --print("ID: "..tostring(Identifier))
	 --print("Data: "..tostring(Data))
	 --print("--------------------------------")
	if From ~= LibSUnit.Player.Name and Data ~= nil then
		if Type == "raid" or Type == "party" then
			if Identifier == "KBMRezSet" then
				local aID = string.sub(Data, 1, 17)
				local st = string.find(Data, ",", 19)
				local aCD = math.ceil(tonumber(string.sub(Data, 19, st - 1)) or 0)
				local aDR = math.floor(tonumber(string.sub(Data, st + 1)) or 300)
				local UnitList = LibSUnit.Lookup.Name[From]
				if UnitList then
					for UID, UnitObj in pairs(UnitList) do
						if UnitObj then
							if LibSUnit.Raid.UID[UID] then
								RM.Rezes:Add(UnitObj, aID, aCD, aDR)
								break
							end
						end
					end
				else
					RM.Rezes:Add(nil, aID, aCD, aDR, From)
				end
			elseif Identifier == "KBMRezRem" then
				if RM.Rezes.Tracked[From] then
					if RM.Rezes.Tracked[From].Timers[Data] then
						RM.Rezes.Tracked[From].Timers[Data]:Remove()
					end
				end
			elseif Identifier == "KBMRezClear" then
				RM.Rezes:Clear(From)
			end
		elseif Type == "send" or Type == "tell" then
			if Identifier == "KBMRezSet" then
				local aID = string.sub(Data, 1, 17)
				local st = string.find(Data, ",", 19)
				local aCD = math.ceil(tonumber(string.sub(Data, 19, st - 1)) or 0)
				local aDR = math.floor(tonumber(string.sub(Data, st + 1)) or 300)
				local UnitList = LibSUnit.Lookup.Name[From]
				if UnitList then
					for UID, UnitObj in pairs(UnitList) do
						if UnitObj then
							if LibSUnit.Raid.UID[UID] then
								RM.Rezes:Add(UnitObj, aID, aCD, aDR)
								break
							end
						end
					end
				else
					RM.Rezes:Add(nil, aID, aCD, aDR, From)
				end
			elseif Identifier == "KBMRezReq" then
				RM.Broadcast.RezSet(From)
				if Data == "C" then
					Command.Message.Send(From, "KBMRezReq", "R", function(failed, message) RM.RezMReq(From, failed, message) end)
				end
			end
		end
	end
end

function RM:ReOrder()
	-- Used when switching Cascade modes.
	for TimerObj, Timer in LibSata.EachIn(self.Rezes.ActiveTimers) do
		Timer.GUI.Background:ClearPoint("TOPLEFT")
		Timer.GUI.Background:ClearPoint("BOTTOMLEFT")
		if TimerObj == self.Rezes.ActiveTimers._first then
			Timer.GUI.Background:SetPoint("TOPLEFT", RM.GUI.Anchor, "TOPLEFT")	
		else
			if self.GUI.Settings.Cascade then
				Timer.GUI.Background:SetPoint("TOPLEFT", TimerObj._before._data.GUI.Background, "BOTTOMLEFT", 0, 1)
			else
				Timer.GUI.Background:SetPoint("BOTTOMLEFT", TimerObj._before._data.GUI.Background, "TOPLEFT", 0, -1)
			end
		end
	end
end

function RM:Update()
	local _cTime = Inspect.Time.Real()
	for TimerObj, Timer in LibSata.EachIn(self.Rezes.ActiveTimers) do
		Timer:Update(cTime)
	end
end

Command.Event.Attach(Command.Slash.Register("libsatadebug"), function(handle) LibSata.DebugTable(RM.Rezes.ActiveTimers) end, "List Table Contents")

function RM:Start()
	self.MSG = KBM.MSG
	self.GUI:Init()
	self.Rezes:Init()
	Command.Message.Accept(nil, "KBMRezSet")
	Command.Message.Accept(nil, "KBMRezRem")
	Command.Message.Accept(nil, "KBMRezClear")
	Command.Message.Accept(nil, "KBMRezReq")
	Command.Event.Attach(Event.Message.Receive, RM.MessageHandler, "Message Parse")
end