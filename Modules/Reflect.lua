--[[
File: Reflect.lua
Addon Author: Tekt
--]]


if not MFH then
	MFH = true
	
	local tinsert = table.insert
	local Inspect = Inspect
	local addon = ({next(Inspect.Addon.List())})[1]
	local Pattern1 = "Laethys launches a molten flare at (%a*)."
	local Pattern2 = "Laethys lance une Éruption en fusion à (%a*)."
	local Pattern3 = "Ix'ior prepares to hurl a blast of magical energy at (%a*)."
	local Pattern4 = "Ix'ior se prépare à lancer une explosion d'énergie magique à (%a*)."
	local Pattern5 = "Manifestation of the Hive prepares to hurl a blast of magical energy at (%a*)."
	local Pattern6 = "Manifestation de la ruche se prépare à lancer une explosion d'énergie magique à (%a*)."
	local InspectTimeFrame = Inspect.Time.Frame
	local Timer = 0
	local Frame = UI.CreateFrame("Frame", "Mark", UI.CreateContext(addon))
	Frame:SetBackgroundColor(0,0.58,1,.5)
	Frame:SetVisible(false)

	local function EventChatNotify(info)
		local match = info.message:match(Pattern1) or info.message:match(Pattern2) or info.message:match(Pattern3) or info.message:match(Pattern4) or info.message:match(Pattern5) or info.message:match(Pattern6)
		if match then
			local missing = 0
			for i = 1, 20 do
				local detail = Inspect.Unit.Detail(("group%02d"):format(i))
				local posInGroup = (i - 1) % 5
				if posInGroup == 0 then
					missing = 0
				end
				if not detail then
					missing = missing + 1
				end
				posInGroup = posInGroup - missing
				if detail and detail.name == match then
					local group = math.ceil(i / 5)
					local raidGroupFrame = UI.Native["RaidGroup" .. group]
					local raidGroupFrameWidth = raidGroupFrame:GetWidth()
					local raidGroupFrameHeight = raidGroupFrame:GetHeight()
					local frameHeight = 36 / 228 * raidGroupFrameHeight
					
					Frame:SetPoint(0,0,raidGroupFrame,0,0,16/96 * raidGroupFrameWidth, 27 / 228 * raidGroupFrameHeight + posInGroup * 2 / 228 * raidGroupFrameHeight + posInGroup * frameHeight)
					Frame:SetHeight(frameHeight)
					Frame:SetWidth(74 / 96 * raidGroupFrameWidth)
					Frame:SetVisible(true)
					
					Timer = InspectTimeFrame() + 4
					return
				end
			end
		end
	end

	local function Update()
		if Timer == 0 or Timer > InspectTimeFrame() then
			return
		end
		
		Timer = 0
		Frame:SetVisible(false)
	end
	
	tinsert(Event.Chat.Notify, {EventChatNotify, addon, ""})
	tinsert(Event.System.Update.Begin, {Update, addon, ""})
	
	Command.Console.Display("general", true, "<font color=\"#0094ff\">Activated!</font>", true)
end
    
