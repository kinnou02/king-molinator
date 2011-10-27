-- King Molinator: Boss Mods
-- Written By Paul Snart
-- Copyright 2011

KBM_GlobalOptions = nil
local KBM_BossMod = {}
local KingMol_Main = {}
local KBM = {}
KBM.Testing = false
KBM.TestFilters = {}
KBM.MenuOptions = {
	MechTimers = {},
	CastBars = {},
	Enabled = true,
	Handler = nil,
	Options = nil,
	Name = "Options",
	ID = "Options",
}

--math.randomseed(Inspect.Time.Real())

local function KBM_DefineVars(AddonID)
	if AddonID == "KingMolinator" then
		KBM.Options = {
			AutoReset = true,
			Frame = {
				x = nil,
				y = nil,
			},
			MechTimer = {
				x = nil,
				y = nil,
				w = 350,
				h = 32,
				wScale = 1,
				hScale = 1,
				Enabled = true,
				Unlocked = false,
				Visible = false,
				ScaleWidth = false,
				ScaleHeight = false,
				TextSize = 20,
				TextScale = false,
			},
			CastBar = {
				x = nil,
				y = nil,
				w = 350,
				h = 32,
				Enabled = true,
				Unlocked = false,
				Visible = true,
				ScaleWidth = false,
				wScale = 1,
				hScale = 1,
				ScaleHeight = false,
				TextScale = false,
				TextSize = 20,
			},
		}
		KBM_GlobalOptions = KBM.Options
		for _, Mod in ipairs(KBM_BossMod) do
			Mod:InitVars()
		end
	end
end

local function KBM_LoadVars(AddonID)
	if AddonID == "KingMolinator" then
		for Setting, Value in pairs(KBM_GlobalOptions) do
			if type(KBM_GlobalOptions[Setting]) == "table" then
				if #KBM_GlobalOptions[Setting] then
					for tSetting, tValue in pairs(KBM_GlobalOptions[Setting]) do
						KBM.Options[Setting][tSetting] = tValue
					end
				end
			else
				KBM.Options[Setting] = Value	
			end
		end
		for _, Mod in ipairs(KBM_BossMod) do
			Mod:LoadVars()
		end
	end
end

local function KBM_SaveVars(AddonID)
	if AddonID == "KingMolinator" then
		KBM_GlobalOptions = KBM.Options
		for _, Mod in ipairs(KBM_BossMod) do
			Mod:SaveVars()
		end
	end
end

function KBM_ToAbilityID(num)
	return string.format("a%016X", num)
end

KBM.Lang = Inspect.System.Language()
local KBM_Boss = {}
KBM.BossID = {}
KBM.Encounter = false
KBM.HeaderList = {}
local KBM_CurrentBoss = ""
local KBM_CurrentMod = nil
local KBM_PlayerID = nil
local KBM_TestIsCasting = false
local KBM_TestAbility = nil

KBM.HeldTime = Inspect.Time.Real()
KBM.StartTime = 0
KBM.TimeElapsed = 0
KBM.UpdateTime = 0
KBM.CastBar = {}
KBM.CastBar.List = {}

-- Addon Primary Context
KBM.Context = UI.CreateContext("KBM_Context")
local KM_Name = "KM:Boss Mods"

-- Addon KBM Primary Frames
KBM.MainWin = {
	Handle = {},
	Border = {},
	Content = {},
}

KBM.TimeVisual = {}
KBM.TimeVisual.String = "00"
KBM.TimeVisual.Seconds = 0
KBM.TimeVisual.Minutes = 0
KBM.TimeVisual.Hours = 0

function KBM_RegisterApp()
	return KBM
end

function KBM_RegisterMod(ModID, Mod)
	table.insert(KBM_BossMod, Mod)
	return KBM
end

KBM.FrameStore = {}
KBM.CheckStore = {}
KBM.SlideStore = {}
KBM.TextfStore = {}
KBM.TotalTexts = 0
KBM.TotalChecks = 0
KBM.TotalFrames = 0
KBM.TotalSliders = 0

KBM.MechTimer = {}
KBM.MechTimer.testTimerList = {}

function KBM.MechTimer:Init()
	self.TimerList = {}
	self.ActiveTimers = {}
	self.RemoveTimers = {}
	self.WaitTimers = {}
	self.StartTimers = {}
	self.LastTimer = nil
	self.DamageTimers = {}
	self.SayTimers = {}
	self.CastTimers = {}
	self.CombatTimers = {}
	self.Anchor = UI.CreateFrame("Frame", "Timer Anchor", KBM.Context)
	self.Anchor:SetWidth(KBM.Options.MechTimer.w * KBM.Options.MechTimer.wScale)
	self.Anchor:SetHeight(KBM.Options.MechTimer.h * KBM.Options.MechTimer.hScale)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	if KBM.Options.MechTimer.x then
		self.Anchor:SetPoint("LEFT", UIParent, "LEFT", KBM.Options.MechTimer.x, nil)
	else
		self.Anchor:SetPoint("CENTERX", UIParent, "CENTERX")
	end
	if KBM.Options.MechTimer.y then
		self.Anchor:SetPoint("TOP", UIParent, "TOP", nil, KBM.Options.MechTimer.y)
	else
		self.Anchor:SetPoint("CENTERY", UIParent, "CENTERY")
	end
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Options.MechTimer.x = self:GetLeft()
			KBM.Options.MechTimer.y = self:GetTop()
		end
	end
	self.Anchor.Text = UI.CreateFrame("Text", "Timer Info", self.Anchor)
	self.Anchor.Text:SetText(" 00.0 Timer Anchor")
	self.Anchor.Text:SetFontSize(KBM.Options.MechTimer.TextSize)
	self.Anchor.Text:ResizeToText()
	self.Anchor.Text:SetPoint("CENTERLEFT", self.Anchor, "CENTERLEFT")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor Drag", 2)
	self.Anchor:SetVisible(KBM.Options.MechTimer.Visible)
	self.Anchor.Drag:SetVisible(KBM.Options.MechTimer.Unlocked)
end

function KBM.MechTimer:Add(iTrigger, iType, iTime, iBoss, iStart, iName)
	local Timer = {}
	Timer.Active = false
	Timer.TimeStart = nil
	Timer.Trigger = iTrigger
	if not iName then
		Timer.Name = iTrigger
	else
		Timer.Name = iName
	end
	Timer.Type = iType
	Timer.Time = iTime
	Timer.Boss = iBoss
	Timer.Enabled = true
	function Timer:Start(CurrentTime)
		if self.Active then
			self.Active = false
			table.insert(KBM.MechTimer.RemoveTimers, self)
			table.insert(KBM.MechTimer.StartTimers, self)
			return
		end
		local Anchor = KBM.MechTimer.Anchor
		self.Background = KBM:CallFrame(KBM.Context)
		self.Background:SetWidth(KBM.Options.MechTimer.w * KBM.Options.MechTimer.wScale)
		self.Background:SetHeight(KBM.Options.MechTimer.h * KBM.Options.MechTimer.hScale)
		self.Background:SetBackgroundColor(0,0,0,0.33)
		self.TimeBar = KBM:CallFrame(self.Background)
		self.TimeBar:SetWidth(KBM.Options.MechTimer.w * KBM.Options.MechTimer.wScale)
		self.TimeBar:SetHeight(KBM.Options.MechTimer.h * KBM.Options.MechTimer.hScale)
		self.TimeBar:SetPoint("TOPLEFT", self.Background, "TOPLEFT")
		self.TimeBar:SetLayer(1)
		self.TimeBar:SetBackgroundColor(0,0,1,0.33)
		self.TimeStart = CurrentTime
		self.Remaining = self.Time
		self.CastInfo = KBM:CallText(self.Background, self.Trigger)
		self.CastInfo:SetText(string.format(" %0.01f : ", self.Remaining)..self.Name)
		self.CastInfo:SetFontSize(KBM.Options.MechTimer.TextSize)
		self.CastInfo:SetPoint("CENTERLEFT", self.Background, "CENTERLEFT")
		self.CastInfo:SetLayer(2)
		self.CastInfo:ResizeToText()
		self.CastInfo:SetFontColor(1,1,1)
		if #KBM.MechTimer.ActiveTimers > 0 then
			for i, cTimer in ipairs(KBM.MechTimer.ActiveTimers) do
				if self.Remaining < cTimer.Remaining then
					self.Active = true
					if i == 1 then
						self.Background:SetPoint("TOPLEFT", Anchor, "TOPLEFT")
						cTimer.Background:SetPoint("TOPLEFT", self.Background, "BOTTOMLEFT", 0, 1)
					else
						self.Background:SetPoint("TOPLEFT", KBM.MechTimer.ActiveTimers[i-1].Background, "BOTTOMLEFT", 0, 1)
						cTimer.Background:SetPoint("TOPLEFT", self.Background, "BOTTOMLEFT", 0, 1)
					end
					table.insert(KBM.MechTimer.ActiveTimers, i, self)
					break
				end
			end
			if not self.Active then
				self.Background:SetPoint("TOPLEFT", KBM.MechTimer.LastTimer.Background, "BOTTOMLEFT", 0, 1)
				table.insert(KBM.MechTimer.ActiveTimers, self)
				self.Active = true
				KBM.MechTimer.LastTimer = self
			end
		else
			self.Background:SetPoint("TOPLEFT", KBM.MechTimer.Anchor, "TOPLEFT")
			table.insert(KBM.MechTimer.ActiveTimers, self)
			self.Active = true
			KBM.MechTimer.LastTimer = self
		end
	end
	function Timer:Stop()
		for i, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
			if Timer == self then
				if #KBM.MechTimer.ActiveTimers == 1 then
					KBM.MechTimer.LastTimer = nil
				elseif i == 1 then
					KBM.MechTimer.ActiveTimers[i+1].Background:SetPoint("TOPLEFT", KBM.MechTimer.Anchor, "TOPLEFT")
				elseif i == #KBM.MechTimer.ActiveTimers then
					KBM.MechTimer.LastTimer = KBM.MechTimer.ActiveTimers[i-1]
				else
					KBM.MechTimer.ActiveTimers[i+1].Background:SetPoint("TOPLEFT", KBM.MechTimer.ActiveTimers[i-1].Background, "BOTTOMLEFT", 0, 1)
				end
				table.remove(KBM.MechTimer.ActiveTimers, i)
				break
			end
		end
		self.Active = false
		self.CastInfo:sRemove()
		self.TimeBar:sRemove()
		self.Background:sRemove()
	end
	function Timer:Update(CurrentTime)
		if self.Active then
			self.Remaining = self.Time - (CurrentTime - self.TimeStart)
			local text = string.format(" %0.01f : ", self.Remaining)..self.Name
			self.CastInfo:SetText(text)
			self.CastInfo:ResizeToText()
			self.TimeBar:SetWidth(self.Background:GetWidth() * (self.Remaining/self.Time))
			if self.Remaining <= 0 then
				self.Active = false
				table.insert(KBM.MechTimer.RemoveTimers, self)
			end
		end
	end
	if iType == "damage" then
		self.DamageTimers[iTrigger] = Timer
	elseif iType == "say" then
		self.SayTimers[iTrigger] = Timer
	elseif iType == "cast" then
		self.CastTimers[iTrigger] = Timer
	else -- iType == "Combat start"
		self.CombatTimers[iTrigger] = Timer
	end
	iBoss.Timers[iTrigger] = Timer
	if KBM.Testing then
		--Timer:Start(Inspect.Time.Real())
		table.insert(self.testTimerList, iTrigger)
	end
end

function KBM:CallFrame(parent)
	local frame = nil
	if #self.FrameStore == 0 then
		self.TotalFrames = self.TotalFrames + 1
		frame = UI.CreateFrame("Frame", "Frame Store"..self.TotalFrames, parent)
		function frame:sRemove()
			self.Event.LeftClick = nil
			self.Event.MouseIn = nil
			self.Event.MouseOut = nil
			self:SetParent(KBM.Context)
			self:ClearAll()
			self:SetVisible(false)
			self:SetLayer(0)
			self:SetBackgroundColor(0,0,0,0)
			table.insert(KBM.FrameStore, self)
		end
	else
		frame = table.remove(self.FrameStore)
		frame:SetParent(parent)
		frame:SetVisible(parent:GetVisible())
		frame:SetAlpha(1)
	end
	return frame
end

function KBM:CallCheck(parent)
	local Checkbox = nil
	if #self.CheckStore == 0 then
		self.TotalChecks = self.TotalChecks + 1
		Checkbox = UI.CreateFrame("RiftCheckbox", "Check Store"..self.TotalChecks, parent)
		function Checkbox:sRemove()
			self.Event.CheckboxChange = nil
			self:ClearAll()
			self:SetParent(KBM.Context)
			self:SetVisible(false)
			self:SetLayer(0)
			table.insert(KBM.CheckStore, self)
		end
	else
		Checkbox = table.remove(self.CheckStore)
		Checkbox:SetParent(parent)
		Checkbox:SetVisible(parent:GetVisible())
		Checkbox:SetEnabled(true)
		Checkbox:SetAlpha(1)
	end
	return Checkbox
end

function KBM:CallText(parent, debugInfo)
	local Textfbox = nil
	if #self.TextfStore == 0 then
		self.TotalTexts = self.TotalTexts + 1
		Textfbox = UI.CreateFrame("Text", "Textf Store"..self.TotalTexts, parent)
		function Textfbox:sRemove()
			self:SetText("")
			self:ClearAll()
			self:SetParent(KBM.Context)
			self:SetVisible(false)
			self:SetLayer(0)
			table.insert(KBM.TextfStore, self)
		end
	else
		Textfbox = table.remove(self.TextfStore)
		Textfbox:SetParent(parent)
		Textfbox:SetFontColor(1,1,1,1)
		Textfbox:SetVisible(parent:GetVisible())
		Textfbox:SetAlpha(1)
	end
	return Textfbox
end

function KBM:CallSlider(parent)
	local Slider = nil
	if #self.SlideStore == 0 then
		self.TotalSliders = self.TotalSliders + 1
		Slider = UI.CreateFrame("RiftSlider", "Slide Store"..self.TotalSliders, parent)
		function Slider:sRemove()
			self.Event.SliderChange = nil
			self:SetParent(KBM.Context)
			self:SetVisible(false)
			self:ClearAll()
			self:SetLayer(0)
			table.insert(KBM.SlideStore, self)
		end
	else
		Slider = table.remove(self.SlideStore)
		Slider:SetParent(parent)
		Slider:SetVisible(true)
		Slider:SetEnabled(true)
		Slider:SetAlpha(1)
	end
	return Slider
end

local function KBM_Options()
	if KBM.MainWin:GetVisible() then
		KBM.MainWin:SetVisible(false)
	else
		KBM.MainWin:SetVisible(true)
	end
end


local function KBM_UnitHPCheck(info)
	if not KBM.Encounter then -- check for bosses for an encounter start

		--print("Encounter Check")
		local uDetails = {}
		local UnitID = info.target
		local uDetails = Inspect.Unit.Detail(UnitID)
		if uDetails then
			if not KBM.BossID[UnitID] then
				if KBM_Boss[uDetails.name] then
					--print("Boss seen (adding): "..UnitID.." ("..uDetails.name..") ")
					--if uDetails.level == KBM_Boss[uDetails.name].Level then
						KBM.BossID[UnitID] = {}
						KBM.BossID[UnitID].name = uDetails.name
						KBM.BossID[UnitID].monitor = true
						KBM.BossID[UnitID].Mod = KBM_Boss[uDetails.name].Mod
						if uDetails.health > 0 then
							KBM.BossID[UnitID].dead = false
							KBM.Encounter = true
							KBM_CurrentBoss = UnitID
							KBM_CurrentBossName = uDetails.Name
							KBM_CurrentMod = KBM.BossID[UnitID].Mod
							if not KBM_CurrentMod.EncounterRunning then
								print("Encounter Started: "..KBM_Boss[uDetails.name].Descript)
								print("Good luck!")
							end
							KBM_CurrentMod:UnitHPCheck(uDetails, UnitID)
						else
							KBM.BossID[UnitID].dead = true
							KBM.BossID[UnitID] = nil
						end
					--end
				else
					--print("Unit is not a boss: "..UnitID.." ("..uDetails.name..")")
				end
			else
				--print("Boss already seen. Redirecting "..KBM.BossID[UnitID].name)
				--KBM.BossID[UnitID].hook()
			end
		else
			--print(UnitID.." (n/a)")
		end
	else
		if #KBM.MechTimer.DamageTimers > 0 then
			if KBM_CurrentMod then
				if info.abilityName then
					if KBM.MechTimer.DamageTimer[info.abilityName] then
						if not KBM.MechTimer.DamageTimer[info.abilityName].Active then
							KBM.MechTimer.DamageTimer[info.abilityName]:Start(Inspect.Time.Real())
						end
					end
				end
			else
				--KBM.Encounter = false
				--print("Encounter ended")
			end
		end
	end
end

local function KBM_UnitAvailable(units)
end

function KBM.AttachDragFrame(parent, hook, name, layer)

	if not name then name = "" end
	if not layer then layer = 0 end
	
	local DragFrame = UI.CreateFrame("Frame", name.."_DragFrame", parent)
	DragFrame:SetPoint("TOPLEFT", parent, "TOPLEFT")
	DragFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT")
	DragFrame.parent = parent
	DragFrame.MouseDown = false
	DragFrame:SetLayer(layer)
	DragFrame.hook = hook
	
	function DragFrame.Event:LeftDown()
		self.MouseDown = true
		mouseData = Inspect.Mouse()
		self.MyStartX = self.parent:GetLeft()
		self.MyStartY = self.parent:GetTop()
		self.StartX = mouseData.x - self.MyStartX
		self.StartY = mouseData.y - self.MyStartY
		tempX = self.parent:GetLeft()
		tempY = self.parent:GetTop()
		tempW = self.parent:GetWidth()
		tempH =	self.parent:GetHeight()
		self.parent:ClearAll()
		self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", tempX, tempY)
		self.parent:SetWidth(tempW)
		self.parent:SetHeight(tempH)
		self:SetBackgroundColor(0,0,0,0.5)
		self.hook("start")
	end
	function DragFrame.Event:MouseMove(mouseX, mouseY)
		if self.MouseDown then
			self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", (mouseX - self.StartX), (mouseY - self.StartY))
		end
	end
	function DragFrame.Event:LeftUp()
		if self.MouseDown then
			self.MouseDown = false
			self:SetBackgroundColor(0,0,0,0)
			self.hook("end")
		end
	end
	
	return DragFrame
end

function KBM.CastBar:Init()

	self.CastBarList = {}
	self.ActiveCastBars = {}
	self.RemoveCastBars = {}
	self.WaitCastBars = {}
	self.StartCastBars = {}
	self.Anchor = UI.CreateFrame("Frame", "CastBar Anchor", KBM.Context)
	self.Anchor:SetWidth(KBM.Options.CastBar.w * KBM.Options.CastBar.wScale)
	self.Anchor:SetHeight(KBM.Options.CastBar.h * KBM.Options.CastBar.hScale)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	if KBM.Options.CastBar.x then
		self.Anchor:SetPoint("LEFT", UIParent, "LEFT", KBM.Options.CastBar.x, nil)
	else
		self.Anchor:SetPoint("CENTERX", UIParent, "CENTERX")
	end
	if KBM.Options.CastBar.y then
		self.Anchor:SetPoint("TOP", UIParent, "TOP", nil, KBM.Options.CastBar.y)
	else
		self.Anchor:SetPoint("CENTERY", UIParent, "CENTERY")
	end
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Options.CastBar.x = self:GetLeft()
			KBM.Options.CastBar.y = self:GetTop()
		end
	end
	self.Anchor.Text = UI.CreateFrame("Text", "CastBar Info", self.Anchor)
	self.Anchor.Text:SetText("CastBar Anchor")
	self.Anchor.Text:SetFontSize(KBM.Options.CastBar.TextSize)
	self.Anchor.Text:ResizeToText()
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "CB Anchor Drag", 2)
	self.Anchor:SetVisible(KBM.Options.CastBar.Visible)
	self.Anchor.Drag:SetVisible(KBM.Options.CastBar.Unlocked)

end

function KBM.CastBar:Add(UnitID, Boss, Filters)

	local CastBar = {}
	CastBar.UnitID = UnitID
	CastBar.Boss = Boss
	CastBar.Filters = Filters
	CastBar[UnitID] = CastBar

end

function KBM.CastBar:Create(UnitID, Mod, Filters)
	Castbar = UI.CreateFrame("Frame", "PrinceCastbar", KBM.Context)
	Castbar.UnitID = UnitID
	Castbar.Mod = Mod
	Castbar.Filters = Filters
	Castbar.LastCast = nil
	Castbar.Enabled = true
	Castbar:SetWidth(KBM.Options.CastBar.w)
	Castbar:SetHeight(KBM.Options.CastBar.h)
	Castbar.Progress = UI.CreateFrame("Frame", "PrinceCastProgress", Castbar)
	Castbar.Progress:SetWidth(0)
	Castbar.Progress:SetHeight(Castbar:GetHeight())
	Castbar.Icon = UI.CreateFrame("Texture", "PrinceCastIcon", Castbar)
	Castbar.Text = UI.CreateFrame("Text", "PrinceCastText", Castbar)
	Castbar.Progress:SetLayer(1)
	Castbar.Icon:SetLayer(2)
	Castbar.Text:SetLayer(2)
	Castbar.Text:SetPoint("CENTER", Castbar, "CENTER")
	if not KBM.Options.CastBar.x then
		Castbar:SetPoint("CENTERX", UIParent, "CENTERX")
	else
		Castbar:SetPoint("LEFT", UIParent, "LEFT", KBM.Options.CastBar.x, nil)
	end
	if not KBM.Options.CastBar.y then
		Castbar:SetPoint("CENTERY", UIParent, "CENTERY")
	else
		Castbar:SetPoint("TOP", UIParent, "TOP", nil, KBM.Options.CastBar.y)
	end
	Castbar.Icon:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT")
	Castbar.Progress:SetPoint("TOPLEFT", Castbar, "TOPLEFT")
	Castbar:SetBackgroundColor(0,0,0,0.3)
	Castbar.Progress:SetBackgroundColor(0.7,0,0,0.5)
	function Castbar:Start()
	
	end
	function Castbar:MoveUpdate(Type) 
		if Type == "end" then
			KBM.Options.CastBar.x = self:GetLeft()
			KBM.Options.CastBar.y = self:GetTop()
		end
	end
	function Castbar:Update()
		bDetails = Inspect.Unit.Castbar(self.UnitID)
		if bDetails then
			if bDetails.abilityName then
				if self.Filters[bDetails.abilityName].Enabled then
					if not self.Casting then
						self.Casting = true
						self:SetVisible(true)
					end
					bCastTime = bDetails.duration
					bProgress = bDetails.remaining						
					self.Progress:SetWidth(self:GetWidth() * (1-(bProgress/bCastTime)))
					self.Text:SetText(string.format("%0.01f", bProgress).." - "..bDetails.abilityName)
					self.Text:ResizeToText()
				end
				if self.LastCast ~= bDetails.abilityName then
					self.LastCast = bDetails.abilityName
					if KBM.MechTimer.CastTimers[bDetails.abilityName] then
						if KBM.MechTimer.CastTimers[bDetails.abilityName].Enabled then
							KBM.MechTimer.CastTimers[bDetails.abilityName]:Start(Inpect.Time.Real())
						end
					end
				end
			else
				self.Casting = false
				self:SetVisible(false)
				self.LastCast = ""
			end
		else
			self.Casting = false
			self:SetVisible(false)
			self.LastCast = ""
		end
	end
	function Castbar:Remove()
		KBM.CastBar.List[self.UnitID] = nil
	end
	Castbar.Drag = KBM.AttachDragFrame(Castbar, function(data) Castbar:MoveUpdate(data) end, "CastBar Drag", 2)
	self.List[UnitID] = Castbar
	--Castbar:SetVisible(false)
end

function KBM:Timer()
	if KBM.Encounter or KBM.Testing then
		local current = Inspect.Time.Real()
		local diff = (current - self.HeldTime)
		local udiff = (current - self.UpdateTime)
		if KBM_CurrentMod then
			KBM_CurrentMod:Timer(current, diff)
		end
		if diff >= 1 then
			self.TimeElapsed = self.TimeElapsed + math.floor(diff)
			self:TimeToHours(self.TimeElapsed)
			self.HeldTime = current - (diff - math.floor(diff))
			self.UpdateTime = current
			if KBM.Testing then
				local startRand = math.random(1, 100)
				if startRand < 50 then
					local TestTrigger = self.MechTimer.testTimerList[math.random(1, #self.MechTimer.testTimerList)]
					--print("Random Choosen: "..TestTrigger)
					if self.MechTimer.CastTimers[TestTrigger] then
						self.MechTimer.CastTimers[TestTrigger]:Start(current)
					end
					if self.MechTimer.DamageTimers[TestTrigger] then
						self.MechTimer.DamageTimers[TestTrigger]:Start(current)
					end
				end
			end
		end
		if udiff >= 0.05 then
			if #self.MechTimer.ActiveTimers > 0 then
				for i, Timer in ipairs(self.MechTimer.ActiveTimers) do
					Timer:Update(current)
				end
				if #self.MechTimer.RemoveTimers > 0 then
					for i, Timer in ipairs(self.MechTimer.RemoveTimers) do
						Timer:Stop()
					end
					self.MechTimer.RemoveTimers = {}
				end
				if #self.MechTimer.StartTimers > 0 then
					for i, Timer in ipairs(self.MechTimer.StartTimers) do
						Timer:Start(current)
					end
					self.MechTimer.StartTimers = {}
				end
			end
			for UnitID, CastCheck in pairs(KBM.CastBar.List) do
				CastCheck:Update()
			end
			self.UpdateTime = current
		end
	else
		-- for UnitID, CastCheck in pairs(KBM.CastBar.List) do
			-- CastCheck:Update()
		-- end
		if #self.MechTimer.ActiveTimers > 0 then
			for i, Timer in ipairs(self.MechTimer.ActiveTimers) do
				table.insert(self.MechTimer.RemoveTimers)
			end
			if #self.MechTimer.RemoveTimers > 0 then
				for i, Timer in ipairs(self.MechTimer.RemoveTimers) do
					Timer:Stop()
				end
			end
			self.MechTimer.RemoveTimers = {}
			self.MechTimer.ActiveTimers = {}
			self.MechTimer.StartTimers = {}
		end
	end
		
end

local function KBM_CastBar(units)
	--print("KBM_CastBar Event Handled")
	if KBM.Encounter then
		if KBM_CurrentCBHook then
			KBM_CurrentCBHook(units)
		end
	--else
		-- Testing Only!
		--KM_CastBar(units)
	end
end

function KBM:TimeToHours(Time)
	self.TimeVisual.String = "00"
	if Time >= 60 then
		self.TimeVisual.Minutes = math.floor(Time / 60)
		self.TimeVisual.Seconds = Time - (self.TimeVisual.Minutes * 60)
		if self.TimeVisual.Minutes >= 60 then
			self.TimeVisual.Hours = math.floor(self.TimeVisual.Minutes / 60)
			self.TimeVisual.Minutes = self.TimeVisual.Minutes - math.floor(self.TimeVisual.Hours * 60)
		else
			self.TimeVisual.String = string.format("%02d:%02d", self.TimeVisual.Minutes, self.TimeVisual.Seconds)
		end
	else
		self.TimeVisual.Seconds = Time
		self.TimeVisual.String = string.format("%02d", self.TimeVisual.Seconds)
	end
end

local function KM_ToggleEnabled(result)
	
end

local function KBM_Reset()
	if KBM.Encounter then
		if KBM_CurrentMod then
			KBM_CurrentMod:Reset()
			KBM_CurrentMod = nil
			KBM_CurrentBoss = ""
		end
	else
		print("No encounter to reset.")
	end
end

local function KBM_UnitRemoved(units)
	--[[local uDetails = {}]]
	if KBM.Encounter then
		if KBM.Options.AutoReset then
			for UnitID, Specifier in pairs(units) do
				if KBM.BossID[UnitID] then
					if KBM_CurrentMod then
						if KBM_CurrentMod:RemoveUnits(UnitID) then
							print("Encounter Ended, possible wipe.")
							KBM_Reset()
						end
					end
				end
			end
		end
	end
end

local function KBM_Death(info)
	
	if KBM.Encounter then
		local UnitID = info.target
		if UnitID then
			local uDetails = Inspect.Unit.Detail(UnitID)
			if uDetails then
				if not uDetails.player then
					if KBM.BossID[UnitID] then
						if KBM_CurrentMod:Death(UnitID) then
							print("Encounter Victory")
							print("Good job!")
							KBM_Reset()
						end
					end
				end
			end
		end
	end
	
end


local function KBM_AutoReset()
	if KBM.Options.AutoReset then
		KBM.Options.AutoReset = false
		print("Auto-Reset is now off.")
	else
		KBM.Options.AutoReset = true
		print("Auto-Reset is now on (Experimental: Please report the accuracy of this.)")
	end
end

local function KBM_Help()
	print("King Molinator in game slash commands")
	print("/kbmautoreset -- Toggle on/off, if you wish the addon to calculate a wipe (experimental).")
	print("/kbmreset -- Resets the monitor's data, and recalculates.")
	print("/kbmoptions -- Toggles the GUI Options screen.")
	print("/kbmhelp -- Displays what you're reading now :)")
end

function KBM.Notify(data)
	--print(data.message)
end

function KBM.NPCChat(data)
	--print(data.fromName..": "..data.message)
end

function KBM.MenuOptions.MechTimers:Options()
	
	-- Timer Callbacks
	function self:MechEnabled(bool)
		KBM.Options.MechTimer.Enabled = bool
	end
	function self:ShowMechAnchor(bool)
		KBM.Options.MechTimer.Visible = bool
		KBM.MechTimer.Anchor:SetVisible(bool)
	end
	function self:LockMechAnchor(bool)
		KBM.Options.MechTimer.Unlocked = bool
		KBM.MechTimer.Anchor.Drag:SetVisible(bool)
	end
	function self:MechScaleHeight(bool, Check)
		KBM.Options.MechTimer.ScaleHeight = bool
		if not bool then
			KBM.Options.MechTimer.hScale = 1
			Check.Slider.Bar:SetPosition(100)
			KBM.MechTimer.Anchor:SetHeight(KBM.Options.MechTimer.h)
		end
	end
	function self:MechhScaleChange(value)
		KBM.Options.MechTimer.hScale = value * 0.01
		KBM.MechTimer.Anchor:SetHeight(KBM.Options.MechTimer.h * KBM.Options.MechTimer.hScale)
	end
	function self:MechScaleWidth(bool, Check)
		KBM.Options.MechTimer.ScaleWidth = bool
		if not bool then
			KBM.Options.MechTimer.wScale = 1
			Check.Slider.Bar:SetPosition(100)
			KBM.MechTimer.Anchor:SetWidth(KBM.Options.MechTimer.w)
		end
	end
	function self:MechwScaleChange(value)
		KBM.Options.MechTimer.wScale = value * 0.01
		KBM.MechTimer.Anchor:SetWidth(KBM.Options.MechTimer.w * KBM.Options.MechTimer.wScale)
	end
	function self:MechTextSize(bool, Check)
		KBM.Options.MechTimer.TextScale = bool
		if not bool then
			KBM.Options.MechTimer.TextSize = 14
			Check.Slider.Bar:SetPosition(KBM.Options.MechTimer.TextSize)
			KBM.MechTimer.Anchor.Text:SetFontSize(KBM.Options.MechTimer.TextSize)
			KBM.MechTimer.Anchor.Text:ResizeToText()
		end
	end
	function self:MechTextChange(value)
		KBM.Options.MechTimer.TextSize = value
		KBM.MechTimer.Anchor.Text:SetFontSize(KBM.Options.MechTimer.TextSize)
		KBM.MechTimer.Anchor.Text:ResizeToText()
	end
	Options = self.MenuItem.Options
	Options:SetTitle()
	
	-- Timer Options
	self.MechTimers = Options:AddHeader("Mechanic Timers", self.MechEnabled, KBM.Options.MechTimer.Enabled)
	self.MechTimers:AddCheck("Show Anchor (for positioning.)", self.ShowMechAnchor, KBM.Options.MechTimer.Visible)
	self.MechTimers:AddCheck("Anchor unlocked.", self.LockMechAnchor, KBM.Options.MechTimer.Unlocked)
	-- local Mechwidth = self.MechTimers:AddCheck("Width scaling.", self.MechScaleWidth, KBM.Options.MechTimer.ScaleWidth)
	-- local slider = self.MechTimers:AddSlider(50, 150, nil, (KBM.Options.MechTimer.wScale*100))
	-- Mechwidth:LinkSlider(slider, self.MechwScaleChange)
	-- local Mechheight = self.MechTimers:AddCheck("Height scaling.", self.MechScaleHeight, KBM.Options.MechTimer.ScaleHeight)
	-- slider = self.MechTimers:AddSlider(50, 150, nil, (KBM.Options.MechTimer.hScale*100))
	-- Mechheight:LinkSlider(slider, self.MechhScaleChange)
	-- local MechText = self.MechTimers:AddCheck("Text Size", self.MechTextSize, KBM.Options.MechTimer.TextScale)
	-- slider = self.MechTimers:AddSlider(8, 20, nil, KBM.Options.MechTimer.TextSize)
	-- MechText:LinkSlider(slider, self.MechTextChange)
	
end

function KBM.MenuOptions.CastBars:Options()

	-- Castbar Callbacks
	function self:CastBarEnabled(bool)
		KBM.Options.CastBar.Enabled = bool
	end
	function self:ShowCastAnchor(bool)
		KBM.Options.CastBar.Visible = bool
		KBM.CastBar.Anchor:SetVisible(bool)
	end
	function self:LockCastAnchor(bool)
		KBM.Options.CastBar.Locked = bool
		KBM.CastBar.Anchor.Drag:SetVisible(bool)
	end
	function self:CastScaleWidth(bool, Check)
		KBM.Options.CastBar.ScaleWidth = bool
		if not bool then
			KBM.Options.CastBar.wScale = 1
			Check.SliderObj.Bar.Frame:SetPosition(100)
			KBM.CastBar.Anchor:SetWidth(KBM.Options.CastBar.w)
		end
	end
	function self:CastwScaleChange(value)
		KBM.Options.CastBar.wScale = value * 0.01
		KBM.CastBar.Anchor:SetWidth(KBM.Options.CastBar.w * KBM.Options.CastBar.wScale)
	end
	function self:CastScaleHeight(bool, Check)
		KBM.Options.CastBar.ScaleHeight = bool
		if not bool then
			KBM.Options.CastBar.hScale = 1
			Check.SliderObj.Bar.Frame:SetPosition(100)
			KBM.CastBar.Anchor:SetHeight(KBM.Options.CastBar.h)
		end
	end
	function self:CasthScaleChange(value)
		KBM.Options.CastBar.hScale = value * 0.01
		KBM.CastBar.Anchor:SetHeight(KBM.Options.CastBar.h * KBM.Options.CastBar.hScale)
	end
	function self:CastTextSize(bool, Check)
		KBM.Options.CastBar.TextScale = bool
		if not bool then
			KBM.Options.CastBar.TextSize = 20
			Check.Slider.Bar:SetPosition(KBM.Options.CastBar.TextSize)
			KBM.CastBar.Anchor.Text:SetFontSize(KBM.Options.CastBar.TextSize)
			KBM.CastBar.Anchor.Text:ResizeToText()
		end
	end
	function self:CastTextChange(value)
		KBM.Options.CastBar.TextSize = value
		KBM.CastBar.Anchor.Text:SetFontSize(KBM.Options.CastBar.TextSize)
		KBM.CastBar.Anchor.Text:ResizeToText()
	end
	
	Options = self.MenuItem.Options
	Options:SetTitle()

	-- CastBar Options. 
	self.CastBars = Options:AddHeader("Cast-bars", self.CastBarEnabled, KBM.Options.CastBar.Enabled)
	self.CastBars:AddCheck("Show Anchor (for positioning.)", self.ShowCastAnchor, KBM.Options.CastBar.Visible)
	self.CastBars:AddCheck("Anchor unlocked.", self.LockCastAnchor, KBM.Options.CastBar.Unlocked)
	-- local sliderAppend = {
					-- Min = 50,
					-- Max = 150, 
					-- Width = nil, 
					-- Default = (KBM.Options.CastBar.wScale*100),
					-- Callback = self.CastwScaleChange,
	-- }
	-- self.CastBars:AddCheck("Width scaling.", self.CastScaleWidth, KBM.Options.CastBar.ScaleWidth, sliderAppend)
	-- sliderAppend.Default = (KBM.Options.CastBar.hScale*100)
	-- sliderAppend.Callback = self.CasthScaleChange
	-- self.CastBars:AddCheck("Height scaling.", self.CastScaleHeight, KBM.Options.CastBar.ScaleHeight, sliderAppend)
	-- self.CastBars:AddCheck("Text Size", self.CastTextSize, KBM.Options.CastBar.TextScale)
	--slider = self.CastBars:AddSlider(12, 28, nil, KBM.Options.CastBar.TextSize)
	--CastText:LinkSlider(slider, self.CastTextChange)

end

local function KBM_Start()
	KBM.MechTimer:Init()
	KBM.CastBar:Init()
	KBM.InitOptions()
	local Header = KBM.MainWin.Menu:CreateHeader("Options")
	KBM.MenuOptions.MechTimers.MenuItem = KBM.MainWin.Menu:CreateEncounter("Timers", KBM.MenuOptions.MechTimers, true, Header)
	KBM.MenuOptions.CastBars.MenuItem = KBM.MainWin.Menu:CreateEncounter("Cast-bars", KBM.MenuOptions.CastBars, true, Header)
	table.insert(Command.Slash.Register("kbmreset"), {KBM_Reset, "KingMolinator", "KBM Reset"})
	table.insert(Event.Chat.Notify, {KBM.Notify, "KingMolinator", "Notify Event"})
	table.insert(Event.Chat.Npc, {KBM.NPCChat, "KingMolinator", "NPC Chat"}) 
	table.insert(Event.Combat.Damage, {KBM_UnitHPCheck, "KingMolinator", "Event"})
	table.insert(Event.Unit.Unavailable, {KBM_UnitRemoved, "KingMolinator", "Event"})
	table.insert(Event.System.Update.Begin, {function () KBM:Timer() end, "KingMolinator", "Event"}) 
	table.insert(Event.Combat.Death, {KBM_Death, "KingMolinator", "Event"})
	table.insert(Event.Unit.Castbar, {KBM_CastBar, "KingMolinator", "Cast Bar Event"})
	table.insert(Command.Slash.Register("kbmhelp"), {KBM_Help, "KingMolinator", "KBM Hekp"})
	table.insert(Command.Slash.Register("kbmautoreset"), {KBM_AutoReset, "KingMolinator", "KBM Auto Reset Toggle"})
	table.insert(Command.Slash.Register("kbmoptions"), {KBM_Options, "KingMolinator", "KBM Open Options"})
	print("/kbmhelp for a list of commands.")
	print("/kbmoptions for options.")
	KBM.MenuOptions.MechTimers:Options()
end

local function KBM_WaitReady(unitID)
	KBM_Start()
	for _, Mod in ipairs(KBM_BossMod) do
		Mod:Start(KBM_MainWin)
		Mod:AddBosses(KBM_Boss)
	end
	KBM_PlayerID = unitID
end

table.insert(Event.Addon.SavedVariables.Load.Begin, {KBM_DefineVars, "KingMolinator", "Pre Load"})
table.insert(Event.Addon.SavedVariables.Load.End, {KBM_LoadVars, "KingMolinator", "Event"})
table.insert(Event.Addon.SavedVariables.Save.Begin, {KBM_SaveVars, "KingMolinator", "Event"})
table.insert(Event.SafesRaidManager.Player.Ready, {KBM_WaitReady, "KingMolinator", "Sync Wait"})
