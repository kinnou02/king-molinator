-- King Boss Mods Ready Check Module
-- Written By Paul Snart
-- Copyright 2012
--

local AddonData = Inspect.Addon.Detail("KBMReadyCheck")
local KBMRC = AddonData.data

local PI = KBMRC

local KBMAddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMAddonData.data
if not KBM.BossMod then
	return
end

KBM.Ready = PI

PI.Enabled = true
PI.Displayed = true
PI.GUI = {}
PI.Context = UI.CreateContext("KBMReadyCheck")
PI.DetailUpdates = {}
PI.Queue = {
	Add = {},
	Remove = {},
	reQueue = {},
	Total = 0,
}
PI.Icons = {
	Planar = {
		--Type = "Rift",
		--File = "titan_shards_d.dds",
		Type = "KingMolinator",
		File = "Media/Planar_Icon.png",
	},
	Vitality = {
		Type = "KingMolinator",
		File = "Media/KBM_Death.png",
	},
	KBM = {
		Type = "KingMolinator",
		File = "Media/KBMLogo_Icon.png",
	},
}
PI.Settings = {
	Enabled = true,
	Combat = true,
	Solo = true,
	x = false,
	y = false,
	wScale = 1,
	hScale = 1,
	fScale = 1,
	Columns = {
		Planar = {
			Enabled = true,
			wScale = 1,
		},
		Vitality = {
			Enabled = true,
			wScale = 1,
		},
		KBM = {
			Enabled = true,
			wScale = 1,
		},
	},
	Rows = {
		hScale = 1,
	},
}
PI.Constants = {
	w = 150,
	h = 32,
	FontSize = 14,
	Columns = {
		Planar = {
			w = 36,
		},
		Vitality = {
			w = 36,
		},
		KBM = {
			w = 70,
		},
	},
	Rows = {
		h = 24,
	},
}

-- Dictionary in Global Locale file.

function PI.LoadVars(ModID)
	if ModID == AddonData.id then
		if not KBMRCM_Settings then
			KBMRCM_Settings = {}
		else
			KBM.LoadTable(KBMRCM_Settings, PI.Settings)
		end
		PI.Enabled = PI.Settings.Enabled
	end
end

function PI.SaveVars(ModID)
	if ModID == AddonData.id then
		KBMRCM_Settings = PI.Settings
	end
end

function PI.GUI:ApplySettings()
	if PI.Enabled then
		self.Header:ClearAll()
		self.Cradle:SetVisible(PI.Displayed)
		if not PI.Settings.x then
			self.Header:SetPoint("TOPLEFT", UI.Native.PortraitPlayer, "BOTTOMLEFT")
		else
			self.Header:SetPoint("TOPLEFT", UIParent, "TOPLEFT", PI.Settings.x, PI.Settings.y)
		end
		self.Texture:SetWidth(math.ceil(PI.Constants.w * PI.Settings.wScale))
		if self.Columns.Last then
			self.Header:SetPoint("RIGHT", self.Columns.Last.Header, "RIGHT")
		else
			self.Header:SetPoint("RIGHT", self.Texture, "RIGHT")
		end
		self.Header:SetHeight(math.ceil(PI.Constants.h * PI.Settings.hScale))
		self.HeaderText:SetFontSize(math.ceil(PI.Constants.FontSize * PI.Settings.fScale))
		self.HeaderTextS:SetFontSize(self.HeaderText:GetFontSize())
		for ID, Object in pairs(self.Columns.List) do
			local Offset = 0
			if ID ~= "KBM" then
				Offset = 5
			end
			Object.Icon:SetWidth(self.Header:GetHeight() - Offset)
			Object.Icon:SetHeight(self.Header:GetHeight() - Offset)
			Object.Header:SetWidth(math.ceil(PI.Constants.Columns[ID].w * PI.Settings.Columns[ID].wScale))
		end
		for Index, Object in ipairs(self.Rows) do
			Object.Cradle:SetHeight(math.ceil(PI.Constants.Rows.h * PI.Settings.Rows.hScale))
			Object.HPBar:SetHeight(math.ceil(Object.Cradle:GetHeight() * 0.7))
			PI.GUI.Rows:Update(Index)
		end
	else
		self.Cradle:SetVisible(false)
	end
end

function PI.GUI:Init()
	self.Cradle = UI.CreateFrame("Frame", "ReadyCheck Cradle", PI.Context)
	self.Cradle:SetLayer(KBM.Layer.ReadyCheck)
	self.Header = UI.CreateFrame("Frame", "ReadyCheck Header", self.Cradle)
	self.Header:SetLayer(1)
	self.Texture = UI.CreateFrame("Texture", "ReadyCheck Texture", self.Header)
	KBM.LoadTexture(self.Texture, "KingMolinator", "Media/MSpy_Texture.png")
	self.Texture:SetBackgroundColor(0,0.38,0,0.33)
	self.Texture:SetPoint("TOPLEFT", self.Header, "TOPLEFT")
	self.Texture:SetPoint("BOTTOM", self.Header, "BOTTOM")
	self.Texture:SetLayer(1)
	self.HeaderTextS = UI.CreateFrame("Text", "ReadyCheck Text Shadow", self.Header)
	self.HeaderTextS:SetPoint("LEFTCENTER", self.Header, "LEFTCENTER", 6, 2)
	self.HeaderTextS:SetText(KBM.Language.ReadyCheck.Name[KBM.Lang])
	self.HeaderTextS:SetFontColor(0,0,0)
	self.HeaderTextS:SetLayer(4)
	self.HeaderText = UI.CreateFrame("Text", "ReadyCheck Text", self.HeaderTextS)
	self.HeaderText:SetText(KBM.Language.ReadyCheck.Name[KBM.Lang])
	self.HeaderText:SetPoint("TOPLEFT", self.HeaderTextS, "TOPLEFT", -2, -2)
	self.Cradle:SetPoint("TOP", self.Header, "TOP")
	self.Cradle:SetPoint("BOTTOM", self.Header, "BOTTOM")
	self.Cradle:SetPoint("LEFT", self.Header, "LEFT")
	self.Cradle:SetPoint("RIGHT", self.Header, "RIGHT")

	self.Columns = {
		List = {
			Planar = {},
			Vitality = {},
			KBM = {},
		},
		First = nil,
		Last = nil,
	}
	
	function self.Columns:Create(ID)
		self.List[ID].Header = UI.CreateFrame("Frame", ID.." Header", PI.GUI.Cradle)
		self.List[ID].Header:SetBackgroundColor(0,0,0,0.33)
		self.List[ID].Icon = UI.CreateFrame("Texture", ID.." Icon", self.List[ID].Header)
		self.List[ID].Icon:SetTexture(PI.Icons[ID].Type, PI.Icons[ID].File)
		self.List[ID].Icon:SetPoint("CENTER", self.List[ID].Header, "CENTER")
		self.List[ID].Header:SetPoint("BOTTOM", PI.GUI.Texture, "BOTTOM")
		self.List[ID].Header:SetPoint("TOP", PI.GUI.Texture, "TOP")
		if not self.First then
			self.First = self.List[ID]
			self.Last = self.First
			self.List[ID].Header:SetPoint("LEFT", PI.GUI.Texture, "RIGHT")
		else
			self.List[ID].Header:SetPoint("LEFT", self.Last.Header, "RIGHT")
			self.Last = self.List[ID]
		end
	end
	
	for ID, Object in pairs(self.Columns.List) do
		self.Columns:Create(ID)
	end
	
	self.Rows = {
		Populated = 0,
		Units = {},
		Names = {},
	}
	
	function self.Rows:Update(Index)
		if self[Index].Enabled then
			if self[Index].Unit then
				local PF = self[Index].Unit.PercentFlat or 0
				self[Index].HPMask:SetWidth(math.ceil(PI.GUI.Texture:GetWidth() * PF))
				self[Index].MPMask:SetWidth(math.ceil(PI.GUI.Texture:GetWidth()))
				self[Index]:SetData(self[Index].Unit.Name)
			end
		else
			self[Index].HPMask:SetWidth(PI.GUI.Texture:GetWidth())
			self[Index].MPMask:SetWidth(PI.GUI.Texture:GetWidth())
		end
	end
	
	function self.Rows:Update_Name(Index)
		if self[Index].Enabled then
			if self[Index].Unit then
				local Class = self[Index].Unit.Calling
				if self[Index].Unit.Availability == "partial" then
					if self[Index].Unit.Offline then
						self[Index].Text:SetFontColor(0.75,0.75,0.75,1)
					else
						self[Index].Text:SetFontColor(1,1,1,1)
					end
				else
					if Class == "mage" then
						self[Index].Text:SetFontColor(0.8, 0.55, 1, 1)
					elseif Class == "cleric" then
						self[Index].Text:SetFontColor(0.55, 1, 0.55, 1)
					elseif Class == "warrior" then
						self[Index].Text:SetFontColor(1, 0.55, 0.55, 1)
					elseif Class == "rogue" then
						self[Index].Text:SetFontColor(1, 1, 0.55, 1)
					else
						self[Index].Text:SetFontColor(1,1,1,1)
					end
				end
				self[Index]:SetData(self[Index].Unit.Name)
			end
		end
	end
	
	function self.Rows:Update_Planar(Index)
		if self[Index].Enabled then
			if self[Index].Unit then
				local Planar = self[Index].Unit.Planar or "-"
				local PlanarMax = self[Index].Unit.PlanarMax or "-"
				self[Index].Columns.Planar:SetData(Planar.."/"..PlanarMax)
			end
		else
			self[Index].Columns.Planar:SetData("n/a")
		end	
	end
		
	function self.Rows:Update_Soul(Index)
		if self[Index].Enabled then
			if self[Index].Unit then
				local Vitality = self[Index].Unit.Vitality
				if Vitality then
					if Vitality > 80 then
						self[Index].Columns.Vitality.Text:SetFontColor(0.1, 0.9, 0.1)
					elseif Vitality > 60 then
						self[Index].Columns.Vitality.Text:SetFontColor(0.5, 0.9, 0.1)					
					elseif Vitality > 40 then
						self[Index].Columns.Vitality.Text:SetFontColor(0.9, 0.9, 0.1)					
					elseif Vitality > 20 then
						self[Index].Columns.Vitality.Text:SetFontColor(0.9, 0.5, 0.1)
					else
						self[Index].Columns.Vitality.Text:SetFontColor(0.9, 0.1, 0.1)
					end
					self[Index].Columns.Vitality:SetData(tostring(Vitality).."%")
				else
					self[Index].Columns.Vitality:SetData("-")
				end
			end
		else
			self[Index].Columns.Vitality:SetData("n/a")
		end		
	end
		
	function self.Rows:Update_KBM(Index)
		if self[Index].Enabled then
			if self[Index].Unit then
				if self[Index].Unit.Name then
					if KBM.MSG.History.NameStore[self[Index].Unit.Name] then
						local v
						if KBM.MSG.History.NameStore[self[Index].Unit.Name].None then
							v = "x"
							self[Index].Columns.KBM.Text:SetFontColor(0.9, 0.1, 0.1)
						else
							self[Index].Columns.KBM.Text:SetFontColor(1, 1, 1)
							if KBM.MSG.History.NameStore[self[Index].Unit.Name].Sent then
								if KBM.MSG.History.NameStore[self[Index].Unit.Name].Recieved then
									v = string.sub(KBM.MSG.History.NameStore[self[Index].Unit.Name].Full, 2)
								else
									self[Index].Columns.KBM.Text:SetFontColor(1, 0.9, 0.5)
									v = ".*.*."
								end
							else
								self[Index].Columns.KBM.Text:SetFontColor(0.9, 0.7, 0.2)
								v = "...."
							end
						end
						self[Index].Columns.KBM:SetData(v)						
					else
						self[Index].Columns.KBM.Text:SetFontColor(0.9, 0.5, 0.1)
						self[Index].Columns.KBM:SetData("..*..")
						if not KBM.MSG.History.Queue[self[Index].Unit.Name] then
							KBM.MSG.History:SetSent(self[Index].Unit.Name, false)
							KBM.MSG.History.Queue[self[Index].Unit.Name] = true
						end
					end
				else
					self[Index].Columns.KBM.Text:SetFontColor(0.9, 0.5, 0.1)
					self[Index].Columns.KBM:SetData("*.*.*")				
				end
			end
		else
			self[Index].Columns.KBM:SetData("n/a")
		end
	end
	
	function self.Rows:Set_Offline(Index)
		if self[Index].Enabled then
			if self[Index].Unit then
				if self[Index].Unit.Offline then
					self:Update_Name(Index)
					self:Update_KBM(Index)
					self[Index].HPBar:SetVisible(false)
					self[Index].MPBar:SetVisible(false)
					self[Index].Columns.Planar:SetData("-/-")
					self[Index].Columns.Vitality:SetData("-")
				else
					self[Index].HPBar:SetVisible(true)
					self[Index].MPBar:SetVisible(true)
					self:Update_All(Index)
				end
			end
		end	
	end
	
	function self.Rows:Update_All(Index)
		self:Update_Name(Index)
		self:Update(Index)
		self:Update_Planar(Index)
		self:Update_Soul(Index)
		self:Update_KBM(Index)
	end
	
	function self.Rows:Add(UnitID)
		self.Populated = self.Populated + 1
		local Index = self.Populated
		if self.Populated > 1 then
			for i = 1, self.Populated - 1 do
				if self[i].Unit then
					if KBM.AlphaComp(KBM.Unit.List.UID[UnitID].Name, self[i].Unit.Name)	then
						Index = i
						break
					end
				else
					Index = i
					break
				end
			end
			if Index < self.Populated then
				self[self.Populated].Enabled = true
				self[self.Populated].Cradle:SetVisible(true)
				for i = self.Populated, Index + 1, -1 do
					self[i].Unit = self[i-1].Unit
					if self[i].Unit then
						self.Units[self[i].Unit.UnitID] = self[i]
						self.Names[self[i].Unit.Name] = self[i]
					end
					self:Set_Offline(i)
				end
			end
		end
		self[Index].Cradle:SetVisible(true)
		self[Index].Enabled = true
		self[Index].Unit = KBM.Unit.List.UID[UnitID]
		self.Units[UnitID] = self[Index]
		self.Names[self[Index].Unit.Name] = self[Index]
		self:Set_Offline(Index)
	end
	
	function self.Rows:Remove(UnitID)
		local Index = self.Units[UnitID].Index
		self.Names[self[Index].Unit.Name] = nil
		self.Units[UnitID] = nil
		if Index < self.Populated then
			for i = Index, self.Populated - 1 do
				self[i].Unit = self[i + 1].Unit
				if self[i].Unit then
					self.Units[self[i].Unit.UnitID] = self[i]
					self.Names[self[i].Unit.Name] = self[i]
					self:Set_Offline(i)
				end
			end
		end
		self[self.Populated].Enabled = false
		self[self.Populated].Cradle:SetVisible(false)
		self[self.Populated].Unit = nil
		self.Populated = self.Populated - 1
	end
	
	for Row = 1, 20 do
		self.Rows[Row] = {}
		self.Rows.Units[tostring(Row)] = Row
		self.Rows[Row].Enabled = false
		self.Rows[Row].Index = Row
		self.Rows[Row].Unit = nil
		self.Rows[Row].Cradle = UI.CreateFrame("Frame", "Row Cradle "..Row, PI.GUI.Cradle)
		self.Rows[Row].Cradle:SetBackgroundColor(0,0,0,0.33)
		if Row > 1 then
			self.Rows[Row].Cradle:SetPoint("TOP", self.Rows[Row - 1].Cradle, "BOTTOM")
		else
			self.Rows[Row].Cradle:SetPoint("TOP", PI.GUI.Texture, "BOTTOM")
		end
		self.Rows[Row].Cradle:SetPoint("LEFT", PI.GUI.Header, "LEFT")
		self.Rows[Row].Cradle:SetPoint("RIGHT", PI.GUI.Header, "RIGHT")
		self.Rows[Row].HPMask = UI.CreateFrame("Mask", "Row HP Mask "..Row, self.Rows[Row].Cradle)
		self.Rows[Row].HPMask:SetPoint("TOPLEFT", self.Rows[Row].Cradle, "TOPLEFT")
		self.Rows[Row].HPBar = UI.CreateFrame("Texture", "Row HP Texture "..Row, self.Rows[Row].HPMask)
		self.Rows[Row].HPBar:SetPoint("TOPLEFT", self.Rows[Row].Cradle, "TOPLEFT")
		self.Rows[Row].HPBar:SetPoint("RIGHT", self.Rows[Row].Cradle, "RIGHT")
		self.Rows[Row].HPBar:SetTexture("KingMolinator", "Media/BarTexture.png")
		self.Rows[Row].HPBar:SetBackgroundColor(0,0.5,0,0.5)
		self.Rows[Row].MPMask = UI.CreateFrame("Mask", "Row MP Mask "..Row, self.Rows[Row].Cradle)
		self.Rows[Row].MPMask:SetPoint("TOPLEFT", self.Rows[Row].HPBar, "BOTTOMLEFT")
		self.Rows[Row].MPMask:SetPoint("BOTTOM", self.Rows[Row].Cradle, "BOTTOM")
		self.Rows[Row].MPBar = UI.CreateFrame("Texture", "Row MP Texture "..Row, self.Rows[Row].MPMask)
		self.Rows[Row].MPBar:SetPoint("TOPLEFT", self.Rows[Row].HPBar, "BOTTOMLEFT")
		self.Rows[Row].MPBar:SetPoint("BOTTOMRIGHT", self.Rows[Row].Cradle, "BOTTOMRIGHT")
		self.Rows[Row].MPBar:SetTexture("KingMolinator", "Media/BarTexture.png")
		self.Rows[Row].MPBar:SetBackgroundColor(0, 0, 0.5, 0.5)
		self.Rows[Row].Shadow = UI.CreateFrame("Text", "Row "..Row.." Name Shadow", self.Rows[Row].Cradle)
		self.Rows[Row].Shadow:SetLayer(2)
		self.Rows[Row].Shadow:SetFontColor(0,0,0)
		self.Rows[Row].Shadow:SetPoint("CENTERLEFT", self.Rows[Row].Cradle, "CENTERLEFT", 5, -1)
		self.Rows[Row].Text = UI.CreateFrame("Text", "Row "..Row.." Name", self.Rows[Row].Shadow)
		self.Rows[Row].Text:SetPoint("TOPLEFT", self.Rows[Row].Shadow, "TOPLEFT", -1, -2)
		local DataObject = self.Rows[Row]
		function DataObject:SetData(Text)
			Text = tostring(Text)
			self.Shadow:SetText(Text)
			self.Text:SetText(Text)
		end
		self.Rows[Row]:SetData("")
		self.Rows[Row].Columns = {}
		for ID, Object in pairs(self.Columns.List) do
			self.Rows[Row].Columns[ID] = {}
			self.Rows[Row].Columns[ID].Cradle = UI.CreateFrame("Frame", "Row "..Row.." Data for "..ID, self.Rows[Row].Cradle)
			self.Rows[Row].Columns[ID].Cradle:SetPoint("TOP", self.Rows[Row].Cradle, "TOP")
			self.Rows[Row].Columns[ID].Cradle:SetPoint("LEFT", Object.Header, "LEFT")
			self.Rows[Row].Columns[ID].Cradle:SetPoint("RIGHT", Object.Header, "RIGHT")
			self.Rows[Row].Columns[ID].Cradle:SetPoint("BOTTOM", self.Rows[Row].Cradle, "BOTTOM")
			self.Rows[Row].Columns[ID].Shadow = UI.CreateFrame("Text", "Row "..Row.." Shadow for "..ID, self.Rows[Row].Columns[ID].Cradle)
			self.Rows[Row].Columns[ID].Shadow:SetFontColor(0,0,0)
			self.Rows[Row].Columns[ID].Shadow:SetPoint("CENTER", self.Rows[Row].Columns[ID].Cradle, "CENTER", 1, 1)
			self.Rows[Row].Columns[ID].Text = UI.CreateFrame("Text", "Row "..Row.." Text for "..ID, self.Rows[Row].Columns[ID].Shadow)
			self.Rows[Row].Columns[ID].Text:SetPoint("TOPLEFT", self.Rows[Row].Columns[ID].Shadow, "TOPLEFT", -1, -1)
			local DataObject = self.Rows[Row].Columns[ID]
			function DataObject:SetData(Text)
				Text = tostring(Text)
				self.Shadow:SetText(Text)
				self.Text:SetText(Text)
			end
			self.Rows[Row].Columns[ID]:SetData("n/a")
		end
		self.Rows[Row].Cradle:SetVisible(false)
	end
	
	function self:UpdateDrag(uType)
		if uType == "end" then
			PI.Settings.x = self.Drag:GetLeft()
			PI.Settings.y = self.Drag:GetTop()
		end
	end
	
	self.Drag = KBM.AttachDragFrame(self.Header, function(uType) self:UpdateDrag(uType) end, "ReadyCheck_Drag_Bar")
	self:ApplySettings()
end

function PI.Update()
	for UnitID, bool in pairs(PI.Queue.Add) do
		if KBM.Unit.List.UID[UnitID] then
			PI.Queue.Add[UnitID] = nil
			PI.Queue.Total = PI.Queue.Total - 1
			if not PI.GUI.Rows.Units[UnitID] then
				PI.GUI.Rows:Add(UnitID)
			end
		else
			PI.Queue.reQueue[UnitID] = true
		end
	end
	PI.Queue.Add = {}
	for UnitID, bool in pairs(PI.Queue.Remove) do
		PI.Queue.Remove[UnitID] = nil
		if UnitID ~= KBM.Player.UnitID then
			PI.GUI.Rows:Remove(UnitID)
		end
	end
	PI.Queue.Remove = {}
end

function PI.Update_End()
	for UnitID, bool in pairs(PI.Queue.reQueue) do
		PI.Queue.Add[UnitID] = true
	end
	PI.Queue.reQueue = {}
end

function PI.Start()
	PI.Queue.Add[KBM.Player.UnitID] = true
	PI.Queue.Total = PI.Queue.Total + 1
	PI.Combat = Inspect.System.Secure()
	-- Rift API Events
	table.insert(Event.System.Update.Begin, {PI.Update, "KBMReadyCheck", "Update Loop"})
	table.insert(Event.System.Update.End, {PI.Update_End, "KBMReadyCheck", "Clean-up Loop"})
	table.insert(Event.System.Secure.Enter, {PI.SecureEnter, "KBMReadyCheck", "Combat Enter"})
	table.insert(Event.System.Secure.Leave, {PI.SecureLeave, "KBMReadyCheck", "Combat Leave"})
	table.insert(Event.Unit.Detail.Planar, {PI.DetailUpdates.Planar, "KBMReadyCheck", "Update Planar Charges"})
	table.insert(Event.Unit.Detail.PlanarMax, {PI.DetailUpdates.PlanarMax, "KBMReadyCheck", "Update Planar Max"})
	table.insert(Event.Unit.Detail.Vitality, {PI.DetailUpdates.Vitality, "KBMReadyCheck", "Update Vitality"})
	table.insert(Event.Unit.Availability.Full, {PI.DetailUpdates.Availability, "KBMReadyCheck", "Update Full"})
	table.insert(Event.Unit.Availability.Partial, {PI.DetailUpdates.Availability, "KBMReadyCheck", "Update Full"})
	PI.UpdateSMode()
end

function PI.UpdateSMode()
	if PI.Settings.Solo then
		if KBM.Player.Grouped then
			PI.Displayed = true
		else
			PI.Displayed = false
			PI.GUI:ApplySettings()
			return
		end
	else
		PI.Displayed = true
	end
	if PI.Settings.Combat then
		if PI.Combat then
			PI.Displayed = false
		else
			PI.Displayed = true
		end
	else
		PI.Displayed = true
	end
	PI.GUI:ApplySettings()	
end

function PI.SecureEnter()
	if PI.Settings.Combat then
		PI.Combat = true
		PI.UpdateSMode()
	end
end

function PI.SecureLeave()
	if PI.Settings.Combat then
		PI.Combat = false
		PI.UpdateSMode()
	end
end

function PI.GroupJoin(UnitID)
	PI.Queue.Add[UnitID] = true
	PI.Queue.Total = PI.Queue.Total + 1
end

function PI.GroupLeave(UnitID)
	PI.Queue.Remove[UnitID] = true
end

function PI.DetailUpdates.Planar(Units)
	for UnitID, Value in pairs(Units) do
		if PI.GUI.Rows.Units[UnitID] then
			PI.GUI.Rows:Update_Planar(PI.GUI.Rows.Units[UnitID].Index)
		end
	end
end

function PI.DetailUpdates.PlanarMax(Units)
	for UnitID, Value in pairs(Units) do
		if PI.GUI.Rows.Units[UnitID] then
			PI.GUI.Rows:Update_Planar(PI.GUI.Rows.Units[UnitID].Index)
		end
	end
end

function PI.DetailUpdates.Vitality(Units)
	for UnitID, Value in pairs(Units) do
		if PI.GUI.Rows.Units[UnitID] then
			PI.GUI.Rows:Update_Soul(PI.GUI.Rows.Units[UnitID].Index)
		end
	end
end

function PI.DetailUpdates.HPChange(UnitID)
	if PI.GUI.Rows.Units[UnitID] then
		PI.GUI.Rows:Update(PI.GUI.Rows.Units[UnitID].Index)
	end	
end

function PI.DetailUpdates.Availability(Units)
	for UnitID, Value in pairs(Units) do
		if PI.GUI.Rows.Units[UnitID] then
			PI.GUI.Rows.Units[UnitID].Unit = KBM.Unit.List.UID[UnitID]
			PI.GUI.Rows:Set_Offline(PI.GUI.Rows.Units[UnitID].Index)
		end
	end
end

function PI.DetailUpdates.Version(From)
	if From then
		if PI.GUI.Rows.Names[From] then
			PI.GUI.Rows:Update_KBM(PI.GUI.Rows.Names[From].Index)
		end
	end
end

function PI.DetailUpdates.Offline(Value, UnitID)
	if PI.GUI.Rows.Units[UnitID] then
		if PI.GUI.Rows.Units[UnitID].Unit then
			PI.GUI.Rows:Set_Offline(PI.GUI.Rows.Units[UnitID].Index)
		end
	end
end

function PI.SlashEnable()
	if PI.Enabled then
		PI.Enabled = false
	else
		PI.Enabled = true
	end
	PI.Enable(PI.Enabled)
end

function PI.Enable(bool)
	PI.Settings.Enabled = bool
	PI.UpdateSMode()
end

function PI.Init(ModID)
	if ModID == AddonData.id then
		PI.GUI:Init()
		-- KBM Events
		table.insert(Event.KingMolinator.Unit.Offline, {PI.DetailUpdates.Offline, "KBMReadyCheck", "Offline Toggle"})
		table.insert(Event.KingMolinator.System.Group.Join, {PI.GroupJoin, "KBMReadyCheck", "Group Member joins"})
		table.insert(Event.KingMolinator.System.Group.Leave, {PI.GroupLeave, "KBMReadyCheck", "Group Member leaves"})
		table.insert(Event.KingMolinator.Unit.PercentChange, {PI.DetailUpdates.HPChange, "KBMReadyCheck", "Update HP"})
		table.insert(Event.KBMMessenger.Version, {PI.DetailUpdates.Version, "KBMReadyCheck", "Update Version"})
		-- Slash Commands
		table.insert(Command.Slash.Register("kbmreadycheck"), {PI.SlashEnable, "KBMReadyCheck", "Toggle Visible"})
	end
end

table.insert(Event.Addon.Load.End, {PI.Init, "KBMReadyCheck", "Syncronized Start"})
table.insert(Event.Addon.SavedVariables.Load.End, {PI.LoadVars, "KBMReadyCheck", "Load Settings"})
table.insert(Event.Addon.SavedVariables.Save.Begin, {PI.SaveVars, "KBMReadyCheck", "Save Settings"})
table.insert(Event.KingMolinator.System.Start, {PI.Start, "KBMReadyCheck", "Start-up"})