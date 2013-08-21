-- King Boss Mods Percentage Monitor
-- Written By Paul Snart
-- Copyright 2012
--

local KBMTable = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMTable.data

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

local LSGIni = Inspect.Addon.Detail("SafesGUILib")
local LibSGui = LSGIni.data

local PM = {}
KBM.PercentageMon = PM

function PM.Defaults()
	local Defaults = {
		X = 0.5,
		Y = 0.75,
		Scale = 1,
		Enabled = true,
		Names = true,
		Percent = true,
		Difference = true,
		Marks = true,
		Unlocked = true,
		Scalable = true,
	}
	return Defaults
end

function PM:ApplySettings()
	--self.GUI.Cradle:SetVisible(self.Visible)
	-- UI Adjustments
	self.GUI.Back:ClearPoint("CENTER")
	self.GUI.Back:SetPoint("CENTER", UIParent, self.Settings.X, self.Settings.Y)
	self.GUI.Back:SetWidth(math.ceil(self.Constant.W * self.Settings.Scale))
	self.GUI.Back:SetHeight(math.ceil(self.Constant.H * self.Settings.Scale))
	self.GUI.Grad:SetWidth(math.ceil(self.Constant.Gradient.W * self.Settings.Scale))
	self.GUI.Grad:SetHeight(math.ceil(self.Constant.Gradient.H * self.Settings.Scale))
	self.Constant.Gradient.Adjusted = (self.GUI.Grad:GetWidth() * 0.92) * 0.5
	self.GUI.Slider:SetWidth(math.ceil(self.Constant.SliderW * self.Settings.Scale))
	self.GUI.Slider:SetHeight(math.ceil(self.Constant.SliderH * self.Settings.Scale))
	-- Left Boss Adjustments
	self.GUI.BossL.Name:SetFontSize(math.ceil(self.Constant.Name.Size * self.Settings.Scale))
	self.GUI.BossL.Per:SetFontSize(math.ceil(self.Constant.Percent.Size * self.Settings.Scale))
	self.GUI.BossL.Mark:SetWidth(math.ceil(self.Constant.MarkW * self.Settings.Scale))
	self.GUI.BossL.Mark:SetHeight(math.ceil(self.Constant.MarkH * self.Settings.Scale))
	self.GUI.BossL.Health:SetWidth(math.ceil(self.Constant.HPBar.W * self.Settings.Scale))
	self.GUI.BossL.Health:SetHeight(math.ceil(self.Constant.HPBar.H * self.Settings.Scale))
	self.Constant.HPBar.Adjusted = self.GUI.BossL.Health:GetWidth()
	-- Right Boss Adjustments
	self.GUI.BossR.Name:SetFontSize(math.ceil(self.Constant.Name.Size * self.Settings.Scale))
	self.GUI.BossR.Per:SetFontSize(math.ceil(self.Constant.Percent.Size * self.Settings.Scale))
	self.GUI.BossR.Mark:SetWidth(math.ceil(self.Constant.MarkW * self.Settings.Scale))
	self.GUI.BossR.Mark:SetHeight(math.ceil(self.Constant.MarkH * self.Settings.Scale))
	self.GUI.BossR.Health:SetWidth(math.ceil(self.Constant.HPBar.W * self.Settings.Scale))
	self.GUI.BossR.Health:SetHeight(math.ceil(self.Constant.HPBar.H * self.Settings.Scale))	
end

function PM:SetAll()
	self:SetNames()
	self:SetMarkL()
	self:SetMarkR()
	self:SetPercentL()
	self:SetPercentR()
end

-- Scaling Handlers
function PM:WheelForwardHandler()
	if PM.Settings.Scale < PM.Constant.Scale.Max then
		PM.Settings.Scale = PM.Settings.Scale + PM.Constant.Scale.Step
		if PM.Settings.Scale > PM.Constant.Scale.Max then
			PM.Settings.Scale = PM.Constant.Scale.Max
		end
		PM:ApplySettings()
	end
end

function PM:WheelBackHandler()
	if PM.Settings.Scale > PM.Constant.Scale.Min then
		PM.Settings.Scale = PM.Settings.Scale - PM.Constant.Scale.Step
		if PM.Settings.Scale < PM.Constant.Scale.Min then
			PM.Settings.Scale = PM.Constant.Scale.Min
		end
		PM:ApplySettings()
	end	
end

function PM:MiddleClickHandler()
	if PM.Settings.Scale ~= PM.Constant.Scale.Def then
		PM.Settings.Scale = PM.Constant.Scale.Def
		PM:ApplySettings()
	end
end

function PM:UnlockScale()
	self.GUI.Back:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, PM.WheelForwardHandler, "KBM_PM Wheel Forward Handler")
	self.GUI.Back:EventAttach(Event.UI.Input.Mouse.Wheel.Back, PM.WheelBackHandler, "KBM_PM Wheel Back Handler")
	self.GUI.Back:EventAttach(Event.UI.Input.Mouse.Middle.Click, PM.MiddleClickHandler, "KBM_PM Wheel Click Handler")
end

function PM:LockScale()
	self.GUI.Back:EventDetach(Event.UI.Input.Mouse.Wheel.Forward, PM.WheelForwardHandler)
	self.GUI.Back:EventDetach(Event.UI.Input.Mouse.Wheel.Back, PM.WheelBackHandler)
	self.GUI.Back:EventDetach(Event.UI.Input.Mouse.Middle.Click, PM.MiddleClickHandler)
end

-- Positioning Handlers
function PM:MouseMoveHandler()
	if self.active then
		local MouseData = Inspect.Mouse()
		local OffSetX = self.FStartX - (self.MStartX - MouseData.x)
		local OffSetY = self.FStartY - (self.MStartY - MouseData.y)
		self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", OffSetX, OffSetY)
	end
end

function PM:MouseDownHandler()
	self:SetBackgroundColor(0,0,0,0.5)
	
	-- Store initial positional data
	local MouseData = Inspect.Mouse()
	self.MStartX = MouseData.x
	self.MStartY = MouseData.y
	self.FStartX = self:GetLeft()
	self.FStartY = self:GetTop()
	self:ClearPoint("CENTER")
	self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.FStartX, self.FStartY)
	
	-- Initialize and handle mouse movement.
	-- This is only required once the user holds down the left mouse button.
	self:EventAttach(Event.UI.Input.Mouse.Cursor.Move, PM.MouseMoveHandler, "KBM_PM Mouse Move Handler")
	self.active = true
end

function PM:MouseUpHandler()
	self:SetBackgroundColor(0,0,0,0)
	self.active = false
	
	-- Remove mouse movement handler
	self:EventDetach(Event.UI.Input.Mouse.Cursor.Move, PM.MouseMoveHandler)
	
	-- Apply changes
	local EndX = self:GetLeft() + (self:GetWidth() * 0.5)
	local EndY = self:GetTop() + (self:GetHeight() * 0.5)
	local EndRelX = EndX / (UIParent:GetWidth() or 1)
	local EndRelY = EndY / (UIParent:GetHeight() or 1)
	self:ClearPoint("TOPLEFT")
	self:SetPoint("CENTER", UIParent, EndRelX, EndRelY)
	PM.Settings.X = EndRelX
	PM.Settings.Y = EndRelY
end

function PM:SetEvents()
	self.GUI.Back:EventAttach(Event.UI.Input.Mouse.Left.Down, PM.MouseDownHandler, "KBM_PM Mouse Down Handler")
	self.GUI.Back:EventAttach(Event.UI.Input.Mouse.Left.Up, PM.MouseUpHandler, "KBM_PM Mouse Up Handler")
end

function PM:ClearEvents()
	self.GUI.Back:EventDetach(Event.UI.Input.Mouse.Left.Down, PM.MouseDownHandler)
	self.GUI.Back:EventDetach(Event.UI.Input.Mouse.Left.Up, PM.MouseUpHandler)
end

function PM:SetNames()
	if not self.Current then
		self.GUI.BossL.Name:SetVisible(self.Settings.Names)
		self.GUI.BossL.Name:SetText("Boss Left")
		self.GUI.BossR.Name:SetVisible(self.Settings.Names)
		self.GUI.BossR.Name:SetText("Boss Right")
	else
		self.GUI.BossL.Name:SetVisible(self.Settings.Names)
		self.GUI.BossL.Name:SetText(self.Current.BossL.Name)
		self.GUI.BossR.Name:SetVisible(self.Settings.Names)
		self.GUI.BossR.Name:SetText(self.Current.BossR.Name)
	end
end

function PM:SetMarkL()
	if not self.Current then
		self.GUI.BossL.Mark:SetVisible(self.Settings.Marks)
		self.GUI.BossL.Mark:SetTexture("Rift", KBM.Marks.FileFull[1])
	else
		if self.Current.BossL.UnitObj then
			if self.Current.BossL.UnitObj.Mark then
				self.GUI.BossL.Mark:SetVisible(self.Settings.Marks)
				self.GUI.BossL.Mark:SetTexture("Rift", KBM.Marks.FileFull[tonumber(self.Current.BossL.UnitObj.Mark)])
			else
				self.GUI.BossL.Mark:SetVisible(false)
			end
		else
			self.GUI.BossL.Mark:SetVisible(false)
		end
	end
end

function PM:SetMarkR()
	if not self.Current then
		self.GUI.BossR.Mark:SetVisible(self.Settings.Marks)
		self.GUI.BossR.Mark:SetTexture("Rift", KBM.Marks.FileFull[2])
	else
		if self.Current.BossR.UnitObj then
			if self.Current.BossR.UnitObj.Mark then
				self.GUI.BossR.Mark:SetVisible(self.Settings.Marks)
				self.GUI.BossR.Mark:SetTexture("Rift", KBM.Marks.FileFull[tonumber(self.Current.BossR.UnitObj.Mark)])
			else
				self.GUI.BossR.Mark:SetVisible(false)
			end
		else
			self.GUI.BossR.Mark:SetVisible(false)
		end
	end
end

function PM:SetPercentL()
	if not self.Current then
		self.GUI.BossL.Per:SetVisible(self.Settings.Percent)
		self.GUI.BossL.Per:SetText("100%")
	else
		if self.Current.BossL.UnitObj then
			self.GUI.BossL.Per:SetVisible(self.Settings.Percent)
			self.GUI.BossL.Per:SetText(self.Current.BossL.UnitObj.PercentFlat.."%")
		end
	end	
end

function PM:SetPercentR()
	if not self.Current then
		self.GUI.BossR.Per:SetVisible(self.Settings.Percent)
		self.GUI.BossR.Per:SetText("100%")
	else
		if self.Current.BossR.UnitObj then
			self.GUI.BossR.Per:SetVisible(self.Settings.Percent)
			self.GUI.BossR.Per:SetText(self.Current.BossR.UnitObj.PercentFlat.."%")
		end
	end	
end

function PM:Init()
	self.Constant = {
		Scale = {
			Def = 1,
			Min = 0.5,
			Max = 1.5,
			Step = 0.02,
		},
		Back = {
			Addon = "KingMolinator",
			Texture = "Media/PerMon_Back.png",
			Alpha = 0.8,
			Layer = 2,
		},
		Gradient = {
			Addon = "KingMolinator",
			Texture = "Media/PerMon_Grad.png",
			Alpha = 0.7,
			Layer = 3,
		},
		Slider = {
			Addon = "KingMolinator",
			Texture = "Media/PerMon_Slider.png",
			Alpha = 1,
			Layer = 4,
		},
		HPBar = {
			Left = {
				Source = "CENTER",
				X = 0.5,
				Y = 0.2,
			},
			Right = {
				Source = "CENTER",
				X = 0.5,
				Y = 0.78,
			},
			W = 357, 
			H = 11,
			Layer = 1,
		},
		Name = {
			Left = {
				Source = "BOTTOMLEFT",
				X = 0.075,
				Y = 0.125,
			},
			Right = {
				Source = "TOPRIGHT",
				X = 0.925,
				Y = 0.85,
			},
			Layer = 3,
			Alpha = 1,
			Size = 16,
		},
		Mark = {
			Left = {
				Source = "CENTER",
				X = 0.081,
				Y = 0.48,
			},
			Right = {
				Source = "CENTER",
				X = 0.916,
				Y = 0.48,
			},
			Layer = 4,
			Alpha = 0.5,
			Scale = 0.135,
		},
		Percent = {
			Left = {
				Source = "CENTER",
				X = 0.51,
				Y = 0.55,
			},
			Right = {
				Source = "CENTER",
				X = 0.51,
				Y = 0.6,
			},
			Layer = 4,
			Alpha = 1,
			Size = 12,
		},
	}
	self.GUI = {}
	self.Encounters = {}
	self.Offset = 0
	self.Active = false
	self.Visible = false
	
	-- GUI Cradle
	self.GUI.Cradle = UI.CreateFrame("Frame", "PM Cradle", KBM.Context)
	self.GUI.Cradle:SetVisible(false)
	
	-- Background Texture
	self.GUI.Back = UI.CreateFrame("Texture", "PM Background", self.GUI.Cradle)
	self.GUI.Back:SetTexture(self.Constant.Back.Addon, self.Constant.Back.Texture)
	self.GUI.Back:SetPoint("CENTER", UIParent, self.Settings.X, self.Settings.Y)
	self.GUI.Back:SetAlpha(self.Constant.Back.Alpha)
	self.GUI.Back:SetLayer(self.Constant.Back.Layer)
	self.GUI.Back:SetMouseMasking("limited")
	
	self.GUI.Cradle:SetPoint("TOPLEFT", self.GUI.Back, "TOPLEFT")
	self.GUI.Cradle:SetPoint("BOTTOMRIGHT", self.GUI.Back, "BOTTOMRIGHT")
	
	self.Constant.W = self.GUI.Back:GetWidth()
	self.Constant.H = self.GUI.Back:GetHeight()
	
	-- Gradient
	self.GUI.Grad = UI.CreateFrame("Texture", "PM Gradient", self.GUI.Cradle)
	self.GUI.Grad:SetTexture(self.Constant.Gradient.Addon, self.Constant.Gradient.Texture)
	self.GUI.Grad:SetLayer(self.Constant.Gradient.Layer)
	self.GUI.Grad:SetPoint("CENTER", self.GUI.Back, "CENTER")
	self.GUI.Grad:SetAlpha(self.Constant.Gradient.Alpha)
	self.Constant.Gradient.W = self.GUI.Grad:GetWidth()
	self.Constant.Gradient.H = self.GUI.Grad:GetHeight()
	self.Constant.Gradient.Adjusted = (self.Constant.Gradient.W * 0.98) * 0.5
	
	-- Current Difference Slider
	self.GUI.Slider = UI.CreateFrame("Texture", "PM Slider", self.GUI.Cradle)
	self.GUI.Slider:SetTexture(self.Constant.Slider.Addon, self.Constant.Slider.Texture)
	self.GUI.Slider:SetLayer(self.Constant.Slider.Layer)
	self.GUI.Slider:SetAlpha(self.Constant.Slider.Alpha)
	self.GUI.Slider:SetPoint("CENTER", self.GUI.Back, "CENTER")
	self.Constant.SliderW = self.GUI.Slider:GetWidth()
	self.Constant.SliderH = self.GUI.Slider:GetHeight()
	
	-- Left Boss GUI Elements
	-- Name
	self.GUI.BossL = {}
	self.GUI.BossL.Name = LibSGui.ShadowText:Create(self.GUI.Cradle, self.Settings.Names)
	self.GUI.BossL.Name:SetLayer(self.Constant.Name.Layer)
	self.GUI.BossL.Name:SetText("Boss Left")
	self.GUI.BossL.Name:SetPoint(self.Constant.Name.Left.Source, self.GUI.Cradle, self.Constant.Name.Left.X, self.Constant.Name.Left.Y)
	self.GUI.BossL.Name:SetFontSize(self.Constant.Name.Size)
	-- Raid Mark
	self.GUI.BossL.Mark = UI.CreateFrame("Texture", "PM Boss Left Mark Texture", self.GUI.Cradle)
	self.GUI.BossL.Mark:SetTexture("Rift", KBM.Marks.FileFull[1])
	self.GUI.BossL.Mark:SetPoint(self.Constant.Mark.Left.Source, self.GUI.Cradle, self.Constant.Mark.Left.X, self.Constant.Mark.Left.Y)
	self.GUI.BossL.Mark:SetLayer(self.Constant.Mark.Layer)
	self.GUI.BossL.Mark:SetAlpha(self.Constant.Mark.Alpha)
	-- Define constant size ratio
	self.Constant.MarkW = math.ceil(self.GUI.BossL.Mark:GetWidth() * self.Constant.Mark.Scale)
	self.Constant.MarkH = math.ceil(self.GUI.BossL.Mark:GetHeight() * self.Constant.Mark.Scale)
	-- Set default size
	self.GUI.BossL.Mark:SetWidth(self.Constant.MarkW)
	self.GUI.BossL.Mark:SetHeight(self.Constant.MarkH)
	-- Health Bar
	self.GUI.BossL.Health = UI.CreateFrame("Frame", "PM Boss Left Health Bar", self.GUI.Cradle)
	self.GUI.BossL.Health:SetPoint(self.Constant.HPBar.Left.Source, self.GUI.Cradle, self.Constant.HPBar.Left.X, self.Constant.HPBar.Left.Y)
	self.GUI.BossL.Health:SetWidth(self.Constant.HPBar.W)
	self.GUI.BossL.Health:SetHeight(self.Constant.HPBar.H)
	self.Constant.HPBar.Adjusted = self.Constant.HPBar.W
	self.GUI.BossL.Health:SetBackgroundColor(0, 0.9, 0, 0.7)
	-- Percentage text
	self.GUI.BossL.Per = LibSGui.ShadowText:Create(self.GUI.Cradle, self.Settings.Percent)
	self.GUI.BossL.Per:SetPoint(self.Constant.Percent.Left.Source, self.GUI.BossL.Health, self.Constant.Percent.Left.X, self.Constant.Percent.Right.Y)
	self.GUI.BossL.Per:SetText("100%")
	self.GUI.BossL.Per:SetFontSize(self.Constant.Percent.Size)
	self.GUI.BossL.Per:SetLayer(self.Constant.Percent.Layer)
	
	-- Right Boss GUI Elements
	-- Name
	self.GUI.BossR = {}
	self.GUI.BossR.Name = LibSGui.ShadowText:Create(self.GUI.Cradle, self.Settings.Names)
	self.GUI.BossR.Name:SetLayer(self.Constant.Name.Layer)
	self.GUI.BossR.Name:SetText("Boss Right")
	self.GUI.BossR.Name:SetPoint(self.Constant.Name.Right.Source, self.GUI.Cradle, self.Constant.Name.Right.X, self.Constant.Name.Right.Y)
	self.GUI.BossR.Name:SetFontSize(self.Constant.Name.Size)
	-- Raid Mark
	self.GUI.BossR.Mark = UI.CreateFrame("Texture", "PM Boss Right Mark Texture", self.GUI.Cradle)
	self.GUI.BossR.Mark:SetTexture("Rift", KBM.Marks.FileFull[2])
	self.GUI.BossR.Mark:SetPoint(self.Constant.Mark.Right.Source, self.GUI.Cradle, self.Constant.Mark.Right.X, self.Constant.Mark.Right.Y)
	self.GUI.BossR.Mark:SetLayer(self.Constant.Mark.Layer)
	self.GUI.BossR.Mark:SetAlpha(self.Constant.Mark.Alpha)
	self.GUI.BossR.Mark:SetWidth(self.Constant.MarkW)
	self.GUI.BossR.Mark:SetHeight(self.Constant.MarkH)
	-- Health Bar
	self.GUI.BossR.Health = UI.CreateFrame("Frame", "PM Boss Right Health Bar", self.GUI.Cradle)
	self.GUI.BossR.Health:SetPoint(self.Constant.HPBar.Right.Source, self.GUI.Cradle, self.Constant.HPBar.Right.X, self.Constant.HPBar.Right.Y)
	self.GUI.BossR.Health:SetWidth(self.Constant.HPBar.W)
	self.GUI.BossR.Health:SetHeight(self.Constant.HPBar.H)
	self.GUI.BossR.Health:SetBackgroundColor(0, 0.9, 0, 0.7)
	-- Percentage text
	self.GUI.BossR.Per = LibSGui.ShadowText:Create(self.GUI.Cradle, self.Settings.Percent)
	self.GUI.BossR.Per:SetPoint(self.Constant.Percent.Right.Source, self.GUI.BossR.Health, self.Constant.Percent.Right.X, self.Constant.Percent.Right.Y)
	self.GUI.BossR.Per:SetText("100%")
	self.GUI.BossR.Per:SetFontSize(self.Constant.Percent.Size)
	self.GUI.BossR.Per:SetLayer(self.Constant.Percent.Layer)
	
	if self.Settings.Unlocked then
		self:SetEvents()
	end
	if self.Settings.Scalable then
		self:UnlockScale()
	end
	self:ApplySettings()
end

function PM:Create(BossL, BossR, Diff, Manual)
	-- Manual is optional, if supplied as True, then the monitor has to be manually started during the encounter.
	if type(BossL) ~= "table" or type(BossR) ~= "table" then
		error("\nPercentage Monitor: Table expected for BossL and BossR\nUsage:\nPercentObj = KBM.PercentageMon:Create([table]BossObj, [table]BossObj, [number]Difference)")
	elseif type(Diff) ~= "number" then
		error("\nPercentage Monitor: Number expected for Diff\nUsage:\nPercentObj = KBM.PercentageMon:Create([table]BossObj, [table]BossObj, [number]Difference)")
	else
		if Manual ~= true then
			-- Ensure Manual is either True or nil
			Manual = nil
		end
		local newPM = {
			["BossL"] = BossL,
			["BossR"] = BossR,
			["Diff"] = Diff,
			Mod = BossL.Mod,
			Manual = Manual,
		}
		if not self.Encounters[newPM.Mod.ID] then
			self.Encounters[newPM.Mod.ID] = newPM
			newPM.Mod.Settings.PercentageMon = {
				Enabled = true,
			}
		else
			error("<Percentage Monitor> You may currently only assign one Percentage Monitor per encounter.")
		end
		return newPM
	end
end

function PM:Update(current, diff)
	if self.Active then
		if diff >= 1 then
			-- Update Data DPS Data
		end
		-- Update Visual Data
		-- Manage Left Boss Updates
		local UpdateDiff = false
		if self.Current.BossL.UnitObj then
			if self.Current.BossL.UnitObj.LastPercent ~= self.Current.BossL.UnitObj.Percent then
				if self.Current.BossL.UnitObj.LastPercentFlat ~= self.Current.BossL.UnitObj.PercentFlat then
					self.GUI.BossL.Per:SetText(self.Current.BossL.UnitObj.PercentFlat.."%")
				end
				self.GUI.BossL.Health:SetWidth(self.Constant.HPBar.Adjusted * self.Current.BossL.UnitObj.PercentRaw)
			end
			UpdateDiff = true
		end
		-- Manage Right Boss Updates
		if self.Current.BossR.UnitObj then
			if self.Current.BossR.UnitObj.LastPercent ~= self.Current.BossR.UnitObj.Percent then
				if self.Current.BossR.UnitObj.LastPercentFlat ~= self.Current.BossR.UnitObj.PercentFlat then
					self.GUI.BossR.Per:SetText(self.Current.BossR.UnitObj.PercentFlat.."%")
				end
				self.GUI.BossR.Health:SetWidth(self.Constant.HPBar.Adjusted * self.Current.BossR.UnitObj.PercentRaw)
			end
		else
			UpdateDiff = false
		end
		if UpdateDiff then
			local PerDiff = (self.Current.BossL.UnitObj.Percent - self.Current.BossR.UnitObj.Percent)
			if PerDiff > 0 then
				if PerDiff > self.Current.Diff then
					PerDiff = self.Current.Diff
				end
			elseif PerDiff < 0 then
				if PerDiff < -self.Current.Diff then
					PerDiff = -self.Current.Diff
				end
			end
			local OffsetX = self.Constant.Gradient.Adjusted * (PerDiff / self.Current.Diff)
			self.GUI.Slider:ClearPoint("CENTER")
			self.GUI.Slider:SetPoint("CENTER", self.GUI.Grad, "CENTER", OffsetX, 0)
		end
	end
end

function PM:SetBossLeft(BossObj)
	-- Allows Left Boss Objects to be changed on the fly or while idle.
	local ID
	if BossObj then
		if BossObj.Mod then
			if BossObj.Mod.ID then
				ID = BossObj.Mod.ID
			else
				if KBM.Debug then
					print("[SBL2] Warning: BossObj not valid for SetBossLeft")
				end
				return
			end
		else
			if KBM.Debug then
				print("[SBL1] Warning: BossObj not valid for SetBossLeft")
			end
			return
		end
		if ID then
			if self.Encounters[ID] then
				self.Encounters[ID].BossL = BossObj
			end
		end
	else
		if KBM.Debug then 
			print("[SBL3] Warning: A nill BossObj was sent.")
		end
	end
end

function PM:SetBossRight(BossObj)
	-- Allows Right Boss Objects to be changed on the fly or while idle.
	local ID
	if BossObj then
		if BossObj.Mod then
			if BossObj.Mod.ID then
				ID = BossObj.Mod.ID
			else
				if KBM.Debug then
					print("[SBR2] Warning: BossObj not valid for SetBossRight")
				end
				return
			end
		else
			if KBM.Debug then
				print("[SBR1] Warning: BossObj not valid for SetBossRight")
			end
			return
		end
		if ID then
			if self.Encounters[ID] then
				self.Encounters[ID].BossR = BossObj
			end
		end
	else
		if KBM.Debug then 
			print("[SBR3] Warning: A nill BossObj was sent.")
		end
	end
end

function PM:Start(ID, Force)
	if self.Active then
		self:End()
	end
	
	if self.Settings.Enabled then
		self.Current = self.Encounters[ID]
		if not self.Current then
			-- If no valid monitor for this ID, return immediately (Hello typos)
			-- Silent Error.
			return
		else
			if self.Current.Manual then
				if not Force then
					-- This is a manual start Monitor and requires Force to be supplied as true.
					return
				end
			end
			self.Visible = true
			self:SetAll()
		end
		self.Active = true
		self.GUI.Cradle:SetVisible(true)
	end
end

function PM:End()
	if self.Active then
		self.Active = false
		self.GUI.Cradle:SetVisible(false)
		self.Current = nil
		self.GUI.Slider:SetPoint("CENTER", self.GUI.Grad, "CENTER")
		self:SetAll()
	end
end