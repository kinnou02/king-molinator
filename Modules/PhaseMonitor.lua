local AddonIni, KBM = ...

local LibSataIni = Inspect.Addon.Detail("SafesTableLib")
local LibSata = LibSataIni.data

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

function KBM.PhaseMonitor:PullObjective()
	local GUI  = {}
	if #self.ObjectiveStore > 0 then
		GUI = table.remove(self.ObjectiveStore)
	else
		GUI.Frame = UI.CreateFrame("Frame", "Objective_Base", KBM.Context)
		GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
		GUI.Frame:SetPoint("LEFT", self.Anchor, "LEFT")
		GUI.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
		GUI.Progress = UI.CreateFrame("Texture", "Percentage_Progress", GUI.Frame)
		GUI.Progress:SetPoint("TOPRIGHT", GUI.Frame, "TOPRIGHT")
		GUI.Progress:SetPoint("BOTTOM", GUI.Frame, "BOTTOM")
		KBM.LoadTexture(GUI.Progress, "KingMolinator", "Media/BarTexture.png")
		GUI.Progress:SetWidth(GUI.Frame:GetWidth())
		GUI.Progress:SetBackgroundColor(0, 0.5, 0, 0.33)
		GUI.Progress:SetVisible(false)
		GUI.Progress:SetLayer(1)
		GUI.Shadow = UI.CreateFrame("Text", "Objective_Shadow", GUI.Frame)
		GUI.Shadow:SetFontColor(0,0,0,1)
		GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Shadow:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
		GUI.Shadow:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT", 1, 1)
		GUI.Shadow:SetLayer(2)
		GUI.Text = UI.CreateFrame("Text", "Objective_Text", GUI.Frame)
		GUI.Text:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT")
		GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Text:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
		GUI.Text:SetLayer(3)
		GUI.ObShadow = UI.CreateFrame("Text", "Objectives_Shadow", GUI.Frame)
		GUI.ObShadow:SetFontColor(0,0,0,1)
		GUI.ObShadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.ObShadow:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
		GUI.ObShadow:SetPoint("CENTERRIGHT", GUI.Frame, "CENTERRIGHT", 1, 1)
		GUI.ObShadow:SetLayer(4)
		GUI.Objective = UI.CreateFrame("Text", "Objective_Tracker", GUI.Frame)
		GUI.Objective:SetPoint("CENTERRIGHT", GUI.Frame, "CENTERRIGHT")
		GUI.Objective:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Objective:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
		GUI.Objective:SetLayer(5)
		GUI.Frame:SetVisible(self.Settings.Enabled)
		function GUI:SetName(Text)
			self.Shadow:SetText(Text)
			self.Text:SetText(Text)
		end
		function GUI:SetObjective(Text)
			self.ObShadow:SetText(Text)
			self.Objective:SetText(Text)
		end
	end
	return GUI
end

function KBM.PhaseMonitor:Init()

	self.Settings = KBM.Options.PhaseMon
	if self.Settings.Type ~= "PhaseMon" then
		print("Error: Incorrect Settings for Phase Monintor")
	end
	self.Anchor = UI.CreateFrame("Frame", "Phase_Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Anchor.Shadow = UI.CreateFrame("Text", "Phase_Anchor_Shadow", self.Anchor)
	self.Anchor.Shadow:SetFontColor(0,0,0,1)
	self.Anchor.Shadow:SetText(KBM.Language.Anchors.Phases[KBM.Lang])
	self.Anchor.Shadow:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
	self.Anchor.Shadow:SetPoint("CENTER", self.Anchor, "CENTER", 1, 1)
	self.Anchor.Shadow:SetLayer(1)
	self.Anchor.Text = UI.CreateFrame("Text", "Phase_Anchor_Text", self.Anchor)
	self.Anchor.Text:SetText(KBM.Language.Anchors.Phases[KBM.Lang])
	self.Anchor.Text:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Anchor.Text:SetLayer(2)

	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.PhaseMonitor.Settings.x = self:GetLeft()
			KBM.PhaseMonitor.Settings.y = self:GetTop()
		end
	end
		
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Phase Anchor Drag", 2)

	self.Frame = UI.CreateFrame("Texture", "Phase Monitor", KBM.Context)
	self.Frame:SetLayer(5)
	KBM.LoadTexture(self.Frame, "KingMolinator", "Media/BarTexture.png")
	self.Frame:SetBackgroundColor(0,0,0.9,0.33)
	self.Frame:SetPoint("LEFT", self.Anchor, "LEFT")
	self.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
	self.Frame:SetPoint("TOP", self.Anchor, "TOP")
	self.Frame:SetPoint("BOTTOM", self.Anchor, "CENTERY")
	self.Frame.Shadow = UI.CreateFrame("Text", "Phase_Monitor_Shadow", self.Frame)
	self.Frame.Shadow:SetText("Phase: 1")
	self.Frame.Shadow:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
	self.Frame.Shadow:SetFontColor(0,0,0,1)
	self.Frame.Shadow:SetPoint("CENTER", self.Frame, "CENTER", 1,1)
	self.Frame.Shadow:SetLayer(1)
	self.Frame.Text = UI.CreateFrame("Text", "Phase_Monitor_Text", self.Frame)
	self.Frame.Text:SetText("Phase: 1")
	self.Frame.Text:SetFont(AddonIni.identifier, "font/Montserrat-Bold.otf")
	self.Frame.Text:SetPoint("CENTER", self.Frame, "CENTER")
	self.Frame.Text:SetLayer(2)
	
	self.Frame:SetVisible(false)
	
	self.Objectives = {}
	self.ObjectiveStore = {}
	self.Phase = {}
	self.Phase.Object = nil
	self.Active = false
	
	self.Objectives.Lists = {}
	self.Objectives.Lists.Meta = {}
	self.Objectives.Lists.Death = {}
	self.Objectives.Lists.Percent = {}
	self.Objectives.Lists.Time = {}
	self.Objectives.Lists.All = {}
	self.Objectives.Lists.LastObjective = nil
	self.Objectives.Lists.Count = 0
	
	self.ActiveObjects = LibSata:Create()
	
	function self:ApplySettings()
	
		if self.Settings.Type ~= "PhaseMon" then
			error("Error (Apply Settings): Incorrect Settings for Phase Monitor")
		end
	
		self.Anchor:ClearAll()
		if not self.Settings.x then
			self.Anchor:SetPoint("CENTERTOP", UIParent, 0.65, 0)
		else
			self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		end
		self.Anchor:SetWidth(self.Settings.w * self.Settings.wScale)
		self.Anchor:SetHeight(self.Settings.h * self.Settings.hScale)
		self.Anchor.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Anchor.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Frame.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Frame.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		if self.Settings.Enabled and KBM.Menu.Active then
			self.Anchor:SetVisible(self.Settings.Visible)
			self.Anchor:SetBackgroundColor(0,0,0,0.33)
			self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
		else
			self.Anchor:SetVisible(false)
		end
		if #self.ObjectiveStore > 0 then
			for _, GUI in ipairs(self.ObjectiveStore) do
				GUI.ObShadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Objective:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
			end
		end
		if self.Objectives.Lists.Count > 0 then
			for _, Object in ipairs(self.Objectives.Lists.All) do
				Object.GUI.ObShadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Objective:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
			end
		end	
	end
	
	function self.Objectives.Lists:Add(Object)	
		if self.Count > 0 then
			Object.Previous = self.LastObjective
		end
		self.Count = self.Count + 1
		self.LastObjective = Object
		self.All[self.Count] = Object
		if Object.Previous then
			-- Appended to current List
			Object.GUI.Frame:SetPoint("TOP", Object.Previous.GUI.Frame, "BOTTOM")
			Object.Previous.Next = Object
			Object.Next = nil
		else
			-- First in the list
			Object.GUI.Frame:SetPoint("TOP", KBM.PhaseMonitor.Frame, "BOTTOM")
			Object.Previous = nil
			Object.Next = nil
		end
		Object.Index = self.Count
	end
	
	function self.Objectives.Lists:Remove(Object)
		if not Object then
			if KBM.Debug then
				print("Error: Unknown Object")
			end
			return
		end
		if self.Count == 1 then
			Object.GUI.Progress:SetVisible(false)
			Object.GUI.Frame:SetVisible(false)
			table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
			self[Object.Type][Object.Name] = nil
			if Object.UnitID then
				self[Object.Type][Object.UnitID] = nil
			end
			self[Object.Type] = {}
			self.All = {}
			Object = nil
			self.Count = 0
		else
			Object.GUI.Progress:SetVisible(false)
			Object.GUI.Frame:SetVisible(false)
			table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
			if Object.Next then
				if Object.Previous then
					-- Next Object is now after this objects previous in the list.
					Object.Previous.Next = Object.Next
					Object.Next.GUI.Frame:SetPoint("TOP", Object.Previous.GUI.Frame, "BOTTOM")
				else
					-- Next Object is now First in the list
					Object.Next.Previous = nil
					Object.Next.GUI.Frame:SetPoint("TOP", KBM.PhaseMonitor.Frame, "BOTTOM")
				end
			else
				-- This object was the last object in the list, and now the previous object is.
				Object.Previous.Next = nil
				self.LastObjective = Object.Previous
			end
			if Object.Type == "Percent" then
				if self[Object.Type][Object.Name] then
					self[Object.Type][Object.Name][tostring(Object)] = nil
					if not next(self[Object.Type][Object.Name]) then
						self[Object.Type][Object.Name] = nil
					end
				else
					if self[Object.Type][tostring(Object)] then
						self[Object.Type][tostring(Object)] = nil
					elseif self[Object.Type][Object.UnitID] then
						self[Object.Type][Object.UnitID] = nil
					end
				end
			else
				self[Object.Type][Object.Name] = nil
			end
			table.remove(self.All, Object.Index)
			-- Re-Index list
			for Index, Object in ipairs(self.All) do
				Object.Index = Index
			end
			self.Count = self.Count - 1
		end		
	end
	
	function self:SetPhase(Phase)
		self.Phase = Phase
		self.Frame.Shadow:SetText("Phase: "..Phase)
		self.Frame.Text:SetText("Phase: "..Phase)
	end
	
	function self.Phase:Create(Phase)
		local PhaseObj = {}
		PhaseObj.StartTime = 0
		PhaseObj.Phase = Phase
		PhaseObj.DefaultPhase = Phase
		PhaseObj.Objectives = {}
		PhaseObj.LastObjective = KBM.PhaseMonitor.Frame
		PhaseObj.Type = "PhaseMon"
		
		function PhaseObj:Update(Time)
			Time = math.floor(Time)
		end
		
		function PhaseObj:SetPhase(Phase)
			self.Phase = Phase
			KBM.PhaseMonitor:SetPhase(Phase)
		end
		
		function PhaseObj.Objectives:AddMeta(Name, Target, Total)		
			local MetaObj = {}
			MetaObj.Count = Total
			MetaObj.Target = Target
			MetaObj.Name = Name
			MetaObj.GUI = KBM.PhaseMonitor:PullObjective()
			MetaObj.GUI:SetName(Name)
			MetaObj.GUI:SetObjective(MetaObj.Count.."/"..MetaObj.Target)
			MetaObj.GUI.Progress:SetVisible(false)
			MetaObj.Type = "Meta"
			
			function MetaObj:Update(Total)
				if self.Target >= Total then
					self.Count = Total
					self.GUI:SetObjective(self.Count.."/"..self.Target)
				end
			end
			function MetaObj:Remove()
				KBM.PhaseMonitor.Objectives.Lists:Remove(self)
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Meta[Name] = MetaObj
			KBM.PhaseMonitor.Objectives.Lists:Add(MetaObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				MetaObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				MetaObj.GUI.Frame:SetVisible(false)
			end
			return MetaObj
		end
		
		function PhaseObj.Objectives:AddDeath(Name, Total, Type)		
			local DeathObj = {}
			DeathObj.Count = 0
			DeathObj.Total = Total
			DeathObj.Name = Name
			DeathObj.uType = Type
			DeathObj.Boss = BossObj
			DeathObj.GUI = KBM.PhaseMonitor:PullObjective()
			DeathObj.GUI:SetName(Name)
			DeathObj.GUI:SetObjective(DeathObj.Count.."/"..DeathObj.Total)
			DeathObj.GUI.Progress:SetVisible(false)
			DeathObj.Type = "Death"
			
			function DeathObj:Kill(UnitObj)
				if self.Count < Total then
					if self.uType == nil then
						self.Count = self.Count + 1
						self.GUI:SetObjective(self.Count.."/"..self.Total)
					elseif UnitObj.Details then
						if self.uType == UnitObj.Type then
							self.Count = self.Count + 1
							self.GUI:SetObjective(self.Count.."/"..self.Total)
						end
					end
				end
			end
			
			function DeathObj:Remove()
				KBM.PhaseMonitor.Objectives.Lists:Remove(self)
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Death[Name] = DeathObj
			KBM.PhaseMonitor.Objectives.Lists:Add(DeathObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				DeathObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				DeathObj.GUI.Frame:SetVisible(false)
			end
			return DeathObj
		end
		
		function PhaseObj.Objectives:AddPercent(Object, Target, Current)
			local PercentObj = {}
			PercentObj.Target = Target
			PercentObj.PercentRaw = Current * 0.01
			PercentObj.PercentFlat = math.ceil(Current)
			PercentObj.Percent = PercentObj.PercentFlat
			if type(Object) == "string" then
				-- Backwards Compatibility, soon to be removed
				PercentObj.Name = Object
				if KBM.CurrentMod then
					if KBM.CurrentMod.Bosses[PercentObj.Name] then
						PercentObj.BossObj = KBM.CurrentMod.Bosses[PercentObj.Name]
						PercentObj.UnitObj = PercentObj.BossObj.UnitObj
						PercentObj.UnitID = PercentObj.BossObj.UnitID
						if PercentObj.UnitObj then
							PercentObj.PercentRaw = PercentObj.UnitObj.PercentRaw
							PercentObj.Percent = PercentObj.UnitObj.Percent
							PercentObj.PercentFlat = PercentObj.UnitObj.PercentFlat
						end
					end
				end
			else
				PercentObj.Name = Object.Name
				PercentObj.BossObj = Object
				PercentObj.UnitObj = Object.UnitObj
				PercentObj.UnitID = Object.UnitID
				Object.PhaseObj = PercentObj
				if PercentObj.UnitObj then
					PercentObj.PercentRaw = Object.UnitObj.PercentRaw
					PercentObj.Percent = Object.UnitObj.Percent
					PercentObj.PercentFlat = Object.UnitObj.PercentFlat
				end
			end
			PercentObj.Dead = false
			PercentObj.GUI = KBM.PhaseMonitor:PullObjective()
			PercentObj.GUI.Progress:SetWidth(PercentObj.GUI.Frame:GetWidth() * PercentObj.PercentRaw)
			PercentObj.GUI.Progress:SetVisible(true)
			if PercentObj.BossObj then
				if PercentObj.BossObj.DisplayName then
					PercentObj.GUI:SetName(PercentObj.BossObj.DisplayName)
				else
					PercentObj.GUI:SetName(PercentObj.Name)
				end
			else
				PercentObj.GUI:SetName(PercentObj.Name)
			end
			if Target == 0 then
				PercentObj.GUI:SetObjective(PercentObj.PercentFlat.."%")
			else
				PercentObj.GUI:SetObjective(PercentObj.PercentFlat.."%/"..PercentObj.Target.."%")
			end	
			PercentObj.Type = "Percent"
			
			function PercentObj:Update()
				if self.Dead then
					return
				end
				if self.UnitObj then
					self.PercentRaw = self.UnitObj.PercentRaw
					self.Percent = self.UnitObj.Percent
					self.PercentFlat = self.UnitObj.PercentFlat
				end
				if self.PercentFlat == 0 then
					self.GUI:SetObjective(KBM.Language.Options.Dead[KBM.Lang])
					self.GUI.Progress:SetVisible(false)
					self.Dead = true
				else
					if self.PercentFlat >= self.Target then
						if self.Target == 0 then
							if self.PercentFlat <= 3 then
								self.GUI:SetObjective(tostring(self.Percent).."%")
							else
								self.GUI:SetObjective(self.PercentFlat.."%")
							end
						else
							self.GUI:SetObjective(self.PercentFlat.."%/"..self.Target.."%")
						end
						self.GUI.Progress:SetWidth(self.GUI.Frame:GetWidth() * self.PercentRaw)
					end
				end
			end
			
			function PercentObj:Remove()
				if self.BossObj then
					self.BossObj.PhaseObj = nil
				end
				KBM.PhaseMonitor.Objectives.Lists:Remove(self)
			end
			
			function PercentObj:UpdateID(UnitID)
				if self.UnitID then
					KBM.PhaseMonitor.Objectives.Lists.Percent[self.UnitID] = nil
				else
					if KBM.PhaseMonitor.Objectives.Lists.Percent[tostring(self.BossObj)] then
						KBM.PhaseMonitor.Objectives.Lists.Percent[tostring(self.BossObj)] = nil
					end
				end
				
				self.UnitID = UnitID
				if self.UnitID then
					self.UnitObj = LibSUnit.Lookup.UID[UnitID]
					KBM.PhaseMonitor.Objectives.Lists.Percent[self.UnitID] = self
				end
			end
			
			if PercentObj.UnitID then
				KBM.PhaseMonitor.Objectives.Lists.Percent[PercentObj.UnitID] = PercentObj
			elseif not PercentObj.BossObj then
				if not KBM.PhaseMonitor.Objectives.Lists.Percent[PercentObj.Name] then
					KBM.PhaseMonitor.Objectives.Lists.Percent[PercentObj.Name] = {}
				end
				table.insert(KBM.PhaseMonitor.Objectives.Lists.Percent[PercentObj.Name], PercentObj)
			else
				KBM.PhaseMonitor.Objectives.Lists.Percent[tostring(PercentObj.BossObj)] = PhaseObj
			end
			KBM.PhaseMonitor.Objectives.Lists:Add(PercentObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				PercentObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				PercentObj.GUI.Frame:SetVisible(false)
			end
			return PercentObj
		end
		
		function PhaseObj.Objectives:AddTime(Time)
		end
		
		function PhaseObj.Objectives:Remove(Index)		
			if type(Index) == "number" then
				KBM.PhaseMonitor.Objectives.Lists:Remove(KBM.PhaseMonitor.Objectives.Lists.All[Index])
			else
				for _, Object in ipairs(KBM.PhaseMonitor.Objectives.Lists.All) do
					Object.GUI.Frame:SetVisible(false)
					table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
				end
				for ListName, List in pairs(KBM.PhaseMonitor.Objectives.Lists) do
					if type(List) == "table" then
						if ListName == "Percent" then
							for ID, PercentObj in pairs(List) do
								if PercentObj.BossObj then
									PercentObj.BossObj.PhaseObj = nil
								end
							end
						end
						KBM.PhaseMonitor.Objectives.Lists[ListName] = {}
					end
				end
				KBM.PhaseMonitor.Objectives.Lists.Count = 0
			end			
		end
		
		function PhaseObj:Start(Time)
			self.StartTime = math.floor(Time)
			self.Phase = self.DefaultPhase
			if KBM.PhaseMonitor.Settings.Enabled then
				if KBM.PhaseMonitor.Settings.PhaseDisplay then
					KBM.PhaseMonitor.Frame:SetVisible(true)
				end
			end
			KBM.PhaseMonitor.Active = true
			self:SetPhase(self.Phase)
			if KBM.PhaseMonitor.Anchor:GetVisible() then
				if KBM.PhaseMonitor.Settings.Enabled then
					KBM.PhaseMonitor.Anchor:SetVisible(false)
				else
					KBM.PhaseMonitor.Anchor.Shadow:SetVisible(false)
					KBM.PhaseMonitor.Anchor.Text:SetVisible(false)
					KBM.PhaseMonitor.Anchor:SetBackgroundColor(0,0,0,0)
				end
			end
			self.TableObj = KBM.PhaseMonitor.ActiveObjects:Add(self)
		end
		
		function PhaseObj:End(Time)
			self.Objectives:Remove()
			if self.TableObj then
				KBM.PhaseMonitor.ActiveObjects:Remove(self.TableObj)
				self.TableObj = nil
			end
			KBM.PhaseMonitor.Frame:SetVisible(false)
			KBM.PhaseMonitor.Active = false
			if KBM.PhaseMonitor.Anchor:GetVisible() then
				KBM.PhaseMonitor.Anchor.Shadow:SetVisible(true)
				KBM.PhaseMonitor.Anchor.Text:SetVisible(true)
				KBM.PhaseMonitor.Anchor:SetBackgroundColor(0,0,0,0.33)
			else
				if KBM.PhaseMonitor.Settings.Visible then
					KBM.PhaseMonitor.Anchor:SetVisible(true)
				end
			end
		end
	
		self.Object = PhaseObj
		return PhaseObj
	end
	
	function self:Remove()
		for TableObj, PhaseObj in LibSata.EachIn(self.ActiveObjects) do
			PhaseObj:End()
		end
	end
	
	function self.Phase:Remove()	
	end
	
	function self.Anchor.Drag.Event:WheelForward()	
		local Change = false
		if KBM.PhaseMonitor.Settings.ScaleWidth then
			if KBM.PhaseMonitor.Settings.wScale < 1.6 then
				KBM.PhaseMonitor.Settings.wScale = KBM.PhaseMonitor.Settings.wScale + 0.02
				if KBM.PhaseMonitor.Settings.wScale > 1.6 then
					KBM.PhaseMonitor.Settings.wScale = 1.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.ScaleHeight then
			if KBM.PhaseMonitor.Settings.hScale < 1.6 then
				KBM.PhaseMonitor.Settings.hScale = KBM.PhaseMonitor.Settings.hScale + 0.02
				if KBM.PhaseMonitor.Settings.hScale > 1.6 then
					KBM.PhaseMonitor.Settings.hScale = 1.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.TextScale then
			if KBM.PhaseMonitor.Settings.tScale < 1.6 then
				KBM.PhaseMonitor.Settings.tScale = KBM.PhaseMonitor.Settings.tScale + 0.02
				if KBM.PhaseMonitor.Settings.tScale > 1.6 then
					KBM.PhaseMonitor.Settings.tScale = 1.6
				end
				Change = true
			end
		end
		
		if Change then
			KBM.PhaseMonitor:ApplySettings()
		end		
	end
	
	function self.Anchor.Drag.Event:WheelBack()	
		local Change = false
		if KBM.PhaseMonitor.Settings.ScaleWidth then
			if KBM.PhaseMonitor.Settings.wScale > 0.6 then
				KBM.PhaseMonitor.Settings.wScale = KBM.PhaseMonitor.Settings.wScale - 0.02
				if KBM.PhaseMonitor.Settings.wScale < 0.6 then
					KBM.PhaseMonitor.Settings.wScale = 0.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.ScaleHeight then
			if KBM.PhaseMonitor.Settings.hScale > 0.6 then
				KBM.PhaseMonitor.Settings.hScale = KBM.PhaseMonitor.Settings.hScale - 0.02
				if KBM.PhaseMonitor.Settings.hScale < 0.6 then
					KBM.PhaseMonitor.Settings.hScale = 0.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.TextScale then
			if KBM.PhaseMonitor.Settings.tScale > 0.6 then
				KBM.PhaseMonitor.Settings.tScale = KBM.PhaseMonitor.Settings.tScale - 0.02
				if KBM.PhaseMonitor.Settings.tScale < 0.6 then
					KBM.PhaseMonitor.Settings.tScale = 0.6
				end
				Change = true
			end
		end
		
		if Change then 
			KBM.PhaseMonitor:ApplySettings()
		end
	end
	self:ApplySettings()	
end