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
PI.Displayed = false
PI.GUI = {}
PI.Settings = {
	Enabled = true,
	x = false,
	y = false,
	wScale = 1,
	hScale = 1,
	fScale = 1,
}
PI.Constants = {
	w = 200,
	h = 32,
	FontSize = 14,
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
		self.Header:SetPoint("RIGHT", self.Texture, "RIGHT")
		self.Header:SetHeight(math.ceil(PI.Constants.h * PI.Settings.hScale))
		self.HeaderText:SetFontSize(math.ceil(PI.Constants.FontSize * PI.Settings.fScale))
		self.HeaderTextS:SetFontSize(self.HeaderText:GetFontSize())
	else
		self.Cradle:SetVisible(false)
	end
end

function PI.GUI:Init()
	self.Cradle = UI.CreateFrame("Frame", "ReadyCheck Cradle", KBM.Context)
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
	
	function self:UpdateDrag(uType)
		if uType == "end" then
			PI.Settings.x = self.Drag:GetLeft()
			PI.Settings.y = self.Drag:GetTop()
		end
	end
	
	self.Drag = KBM.AttachDragFrame(self.Header, function(uType) self:UpdateDrag(uType) end, "ReadyCheck_Drag_Bar")
	self:ApplySettings()
end

function PI.Init(ModID)
	if ModID == AddonData.id then
		PI.GUI:Init()
	end
end

table.insert(Event.Addon.Load.End, {PI.Init, "KBMReadyCheck", "Syncronized Start"})
table.insert(Event.Addon.SavedVariables.Load.End, {PI.LoadVars, "KBMReadyCheck", "Load Settings"})
table.insert(Event.Addon.SavedVariables.Save.Begin, {PI.SaveVars, "KBMReadyCheck", "Save Settings"})